const express = require('express');
const fs = require('fs');
const path = require('path');
const { spawn } = require('child_process');
const axios = require('axios');

// Configuration
const CONFIG = {
  telegram: {
    botToken: process.env.TELEGRAM_BOT_TOKEN,
    apiUrl: 'https://api.telegram.org/bot'
  },
  webhook: {
    port: process.env.WEBHOOK_PORT || 3001,
    path: '/webhook/telegram-voice'
  },
  whisper: {
    model: process.env.WHISPER_MODEL || 'turbo',
    language: process.env.WHISPER_LANGUAGE || 'auto',
    tempDir: process.env.TEMP_DIR || '/tmp/telegram-voice'
  }
};

// Créer le dossier temporaire
if (!fs.existsSync(CONFIG.whisper.tempDir)) {
  fs.mkdirSync(CONFIG.whisper.tempDir, { recursive: true });
}

const app = express();
app.use(express.json());

// Logger
function log(message) {
  const timestamp = new Date().toISOString();
  console.log(`[${timestamp}] ${message}`);
}

// Télécharger un fichier depuis Telegram
async function downloadTelegramFile(fileId, fileName) {
  try {
    // 1. Obtenir l'URL du fichier
    const fileInfoUrl = `${CONFIG.telegram.apiUrl}${CONFIG.telegram.botToken}/getFile?file_id=${fileId}`;
    const fileInfo = await axios.get(fileInfoUrl);
    
    if (!fileInfo.data.ok) {
      throw new Error(`Telegram API error: ${fileInfo.data.description}`);
    }
    
    const filePath = fileInfo.data.result.file_path;
    const downloadUrl = `https://api.telegram.org/file/bot${CONFIG.telegram.botToken}/${filePath}`;
    
    // 2. Télécharger le fichier
    const localPath = path.join(CONFIG.whisper.tempDir, fileName);
    const response = await axios.get(downloadUrl, { responseType: 'stream' });
    
    const writer = fs.createWriteStream(localPath);
    response.data.pipe(writer);
    
    return new Promise((resolve, reject) => {
      writer.on('finish', () => resolve(localPath));
      writer.on('error', reject);
    });
  } catch (error) {
    log(`❌ Erreur téléchargement: ${error.message}`);
    throw error;
  }
}

// Convertir OGG → WAV avec ffmpeg
function convertOggToWav(oggPath) {
  return new Promise((resolve, reject) => {
    const wavPath = oggPath.replace('.oga', '.wav');
    
    const ffmpeg = spawn('ffmpeg', [
      '-i', oggPath,
      '-ar', '16000',
      '-ac', '1',
      '-c:a', 'pcm_s16le',
      wavPath,
      '-y'
    ]);
    
    ffmpeg.on('close', (code) => {
      if (code === 0) {
        resolve(wavPath);
      } else {
        reject(new Error(`ffmpeg exited with code ${code}`));
      }
    });
    
    ffmpeg.on('error', reject);
  });
}

// Transcrire avec Whisper
function transcribeWithWhisper(audioPath) {
  return new Promise((resolve, reject) => {
    const outputDir = CONFIG.whisper.tempDir;
    const languageFlag = CONFIG.whisper.language === 'auto' ? '' : `--language ${CONFIG.whisper.language}`;
    
    log(`🎙️ Transcription en cours... (modèle: ${CONFIG.whisper.model})`);
    
    const whisper = spawn('whisper', [
      audioPath,
      '--model', CONFIG.whisper.model,
      '--output_format', 'txt',
      '--output_dir', outputDir,
      languageFlag,
      '--fp16', 'False'  // Pour compatibilité CPU
    ].filter(Boolean));
    
    let output = '';
    whisper.stdout.on('data', (data) => {
      output += data.toString();
    });
    
    whisper.stderr.on('data', (data) => {
      log(`Whisper: ${data.toString().trim()}`);
    });
    
    whisper.on('close', (code) => {
      if (code === 0) {
        // Lire le fichier de transcription
        const txtPath = audioPath.replace('.wav', '.txt');
        if (fs.existsSync(txtPath)) {
          const transcription = fs.readFileSync(txtPath, 'utf8').trim();
          resolve(transcription);
        } else {
          resolve(output.trim() || '[Aucune transcription]');
        }
      } else {
        reject(new Error(`Whisper exited with code ${code}`));
      }
    });
    
    whisper.on('error', (error) => {
      reject(new Error(`Whisper error: ${error.message}`));
    });
  });
}

// Envoyer un message via Telegram
async function sendTelegramMessage(chatId, text) {
  try {
    const url = `${CONFIG.telegram.apiUrl}${CONFIG.telegram.botToken}/sendMessage`;
    await axios.post(url, {
      chat_id: chatId,
      text: text,
      parse_mode: 'Markdown'
    });
    log(`✅ Réponse envoyée à ${chatId}`);
  } catch (error) {
    log(`❌ Erreur envoi message: ${error.message}`);
  }
}

// Notifier OpenClaw (via fichier ou API)
async function notifyOpenClaw(chatId, text, audioDuration) {
  try {
    // Créer un fichier de notification que l'agent OpenClaw va lire
    const notificationPath = path.join(CONFIG.whisper.tempDir, 'pending_messages.json');
    
    let messages = [];
    if (fs.existsSync(notificationPath)) {
      messages = JSON.parse(fs.readFileSync(notificationPath, 'utf8'));
    }
    
    messages.push({
      chatId,
      text,
      audioDuration,
      timestamp: new Date().toISOString(),
      processed: false
    });
    
    fs.writeFileSync(notificationPath, JSON.stringify(messages, null, 2));
    log(`📤 Notification créée pour OpenClaw`);
  } catch (error) {
    log(`❌ Erreur notification: ${error.message}`);
  }
}

// Webhook principal
app.post(CONFIG.webhook.path, async (req, res) => {
  try {
    const update = req.body;
    
    // Vérifier si c'est un message vocal
    if (!update.message || !update.message.voice) {
      return res.sendStatus(200); // Ignorer les non-vocaux
    }
    
    const message = update.message;
    const chatId = message.chat.id;
    const voice = message.voice;
    const fileId = voice.file_id;
    const duration = voice.duration;
    const fileName = `voice_${chatId}_${Date.now()}.oga`;
    
    log(`🎵 Vocal reçu de ${chatId} (${duration}s)`);
    
    // 1. Télécharger le fichier
    log(`📥 Téléchargement...`);
    const oggPath = await downloadTelegramFile(fileId, fileName);
    
    // 2. Convertir en WAV
    log(`🔄 Conversion...`);
    const wavPath = await convertOggToWav(oggPath);
    
    // 3. Transcrire
    log(`🎯 Transcription...`);
    const transcription = await transcribeWithWhisper(wavPath);
    
    log(`✅ Transcription: "${transcription.substring(0, 50)}..."`);
    
    // 4. Notifier OpenClaw
    await notifyOpenClaw(chatId, transcription, duration);
    
    // 5. Nettoyer les fichiers temporaires
    try {
      fs.unlinkSync(oggPath);
      fs.unlinkSync(wavPath);
      fs.unlinkSync(wavPath.replace('.wav', '.txt'));
    } catch (e) {
      // Ignorer les erreurs de nettoyage
    }
    
    res.sendStatus(200);
  } catch (error) {
    log(`❌ Erreur webhook: ${error.message}`);
    res.sendStatus(500);
  }
});

// Health check
app.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    whisper_model: CONFIG.whisper.model,
    temp_dir: CONFIG.whisper.tempDir
  });
});

// Démarrer le serveur
app.listen(CONFIG.webhook.port, () => {
  log(`🚀 Serveur Telegram Voice démarré sur le port ${CONFIG.webhook.port}`);
  log(`📍 Webhook: http://localhost:${CONFIG.webhook.port}${CONFIG.webhook.path}`);
  log(`🧠 Modèle Whisper: ${CONFIG.whisper.model}`);
});
