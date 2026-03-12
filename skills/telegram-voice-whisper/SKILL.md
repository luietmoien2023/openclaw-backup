---
name: telegram-voice-whisper
description: "Transcription vocale Telegram via Whisper local (100% gratuit). Écoute les messages vocaux, transcrit avec Whisper, permet de répondre."
metadata:
  {
    "openclaw":
      {
        "emoji": "🎙️",
        "requires": { "bins": ["whisper", "ffmpeg"], "env": ["TELEGRAM_BOT_TOKEN"] },
      },
  }
---

# Telegram Voice Whisper

Discute vocalement avec ton agent via Telegram. Gratuit, local, privé.

## Fonctionnement

1. Tu envoies un vocal sur Telegram
2. L'agent télécharge le fichier `.oga` (format Telegram)
3. Conversion en `.wav` via `ffmpeg`
4. Transcription avec **Whisper local** (gratuit)
5. Je reçois le texte et je te réponds

## Installation

### 1. Prérequis système

```bash
# Whisper (si pas déjà installé)
pip install openai-whisper

# FFmpeg (pour convertir OGG → WAV)
# Ubuntu/Debian:
sudo apt-get install ffmpeg

# macOS:
brew install ffmpeg
```

### 2. Configurer l'agent

Le skill crée automatiquement un agent dédié `telegram-voice`.

### 3. Démarrer l'écoute

```bash
# Démarrer le webhook server
node /data/workspace/skills/telegram-voice-whisper/server.js
```

Ou via l'agent OpenClaw:
```bash
openclaw agent start telegram-voice
```

## Usage

1. **Envoie un vocal** sur Telegram (bouton micro)
2. **Attends 2-5 secondes** (transcription)
3. **Je reçois le texte** et je te réponds normalement

## Modèles Whisper disponibles

| Modèle | Taille | Vitesse | Précision | Usage |
|--------|--------|---------|-----------|-------|
| `tiny` | 39 MB | ⚡ Très rapide | Basique | Tests rapides |
| `base` | 74 MB | 🚀 Rapide | Bonne | Usage quotidien |
| `small` | 244 MB | ⚖️ Moyen | Très bonne | Recommandé |
| `medium` | 769 MB | 🐌 Lent | Excellente | Qualité max |
| `turbo` | 809 MB | ⚡ Rapide | Très bonne | Défaut (équilibre) |

**Par défaut :** `turbo` (bon équilibre vitesse/précision)

## Configuration

Dans `/data/workspace/skills/telegram-voice-whisper/config.json` :

```json
{
  "whisper": {
    "model": "turbo",
    "language": "auto",
    "output_format": "txt"
  },
  "telegram": {
    "webhook_port": 3001,
    "webhook_path": "/webhook/telegram-voice"
  },
  "paths": {
    "temp_dir": "/tmp/telegram-voice",
    "cache_dir": "~/.cache/whisper"
  }
}
```

## Architecture

```
┌─────────────┐     ┌─────────────────────┐     ┌──────────────┐
│   Telegram  │────▶│  Webhook Server     │────▶│  Télécharge  │
│   (vocal)   │     │  (Node.js/Python)   │     │  fichier .oga│
└─────────────┘     └─────────────────────┘     └──────────────┘
                                                          │
┌─────────────┐     ┌─────────────────────┐              │
│   OpenClaw  │◀────│  Agent "telegram-   │◀─────────────┘
│   (réponse) │     │  voice" reçoit text │
└─────────────┘     └─────────────────────┘
                            │
                    ┌───────┴───────┐
                    │  Whisper Local │
                    │  (transcrit)   │
                    └────────────────┘
```

## Commandes utiles

```bash
# Tester Whisper
whisper /tmp/test.m4a --model turbo

# Voir les modèles téléchargés
ls -la ~/.cache/whisper/

# Logs de l'agent
tail -f /data/workspace/logs/telegram-voice.log
```

## Dépannage

### "ffmpeg not found"
```bash
sudo apt-get install ffmpeg  # Ubuntu/Debian
brew install ffmpeg          # macOS
```

### "whisper not found"
```bash
pip install openai-whisper
```

### Le webhook ne reçoit rien
- Vérifier que le webhook est enregistré sur Telegram
- Vérifier le port (3001 par défaut)
- Vérifier le firewall/routeur

### Téléchargement échoue
- Vérifier `TELEGRAM_BOT_TOKEN` dans les variables d'environnement
- Le bot doit avoir accès aux fichiers (pas de restrictions)

## Coût

| Composant | Coût |
|-----------|------|
| Whisper local | **0€** (tourne sur ton CPU) |
| Telegram API | **0€** |
| OpenClaw | **0€** (si modèles gratuits) |
| **TOTAL** | **100% GRATUIT** ✅ |

## Notes

- **Première utilisation** : Téléchargement du modèle Whisper (~500MB-1GB)
- **Langue** : Détection automatique ou forcer avec `language: "fr"`
- **Confidentialité** : Aucun fichier audio n'est envoyé sur Internet

---

Créé pour Bijouterie Hidous - 2026-03-03
