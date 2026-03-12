#!/bin/bash

# Démarrer l'agent Telegram Voice Whisper
# Usage: ./start-telegram-voice.sh [start|stop|status]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PID_FILE="/tmp/telegram-voice-server.pid"
LOG_FILE="/data/workspace/logs/telegram-voice.log"

# Créer le dossier de logs
mkdir -p "$(dirname "$LOG_FILE")"

start() {
    echo "🚀 Démarrage du serveur Telegram Voice..."
    
    # Vérifier les prérequis
    if ! command -v whisper &> /dev/null; then
        echo "❌ Whisper n'est pas installé. Installation: pip install openai-whisper"
        exit 1
    fi
    
    if ! command -v ffmpeg &> /dev/null; then
        echo "❌ FFmpeg n'est pas installé. Installation: sudo apt-get install ffmpeg"
        exit 1
    fi
    
    if [ -z "$TELEGRAM_BOT_TOKEN" ]; then
        echo "❌ TELEGRAM_BOT_TOKEN non défini dans les variables d'environnement"
        exit 1
    fi
    
    # Vérifier si déjà en cours
    if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
        echo "⚠️ Le serveur tourne déjà (PID: $(cat "$PID_FILE"))"
        exit 1
    fi
    
    # Démarrer le serveur
    cd "$SCRIPT_DIR"
    nohup node server.js >> "$LOG_FILE" 2>&1 &
    echo $! > "$PID_FILE"
    
    echo "✅ Serveur démarré (PID: $(cat "$PID_FILE"))"
    echo "📍 Webhook: http://localhost:3001/webhook/telegram-voice"
    echo "📊 Logs: tail -f $LOG_FILE"
    
    # Configurer le webhook Telegram
    setup_webhook
}

stop() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if kill -0 "$PID" 2>/dev/null; then
            echo "🛑 Arrêt du serveur (PID: $PID)..."
            kill "$PID"
            rm -f "$PID_FILE"
            echo "✅ Serveur arrêté"
        else
            echo "⚠️ Processus non trouvé"
            rm -f "$PID_FILE"
        fi
    else
        echo "⚠️ Aucun serveur en cours"
    fi
}

status() {
    if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
        echo "✅ Serveur actif (PID: $(cat "$PID_FILE"))"
        echo "📍 URL: http://localhost:3001/webhook/telegram-voice"
        echo "🧠 Modèle: $(grep -o '"model": "[^"]*"' "$SCRIPT_DIR/config.json" | cut -d'"' -f4)"
    else
        echo "❌ Serveur inactif"
    fi
}

setup_webhook() {
    if [ -n "$TELEGRAM_BOT_TOKEN" ]; then
        WEBHOOK_URL=$(grep -o '"webhook_url": "[^"]*"' "$SCRIPT_DIR/config.json" | cut -d'"' -f4)
        if [ -n "$WEBHOOK_URL" ] && [ "$WEBHOOK_URL" != "https://ton-domaine.com/webhook/telegram-voice" ]; then
            echo "🔧 Configuration du webhook Telegram..."
            curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/setWebhook" \
                -d "url=${WEBHOOK_URL}" \
                -d "allowed_updates=[\"message\"]"
            echo ""
        fi
    fi
}

# Menu
case "${1:-start}" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        stop
        sleep 2
        start
        ;;
    status)
        status
        ;;
    *)
        echo "Usage: $0 [start|stop|restart|status]"
        exit 1
        ;;
esac
