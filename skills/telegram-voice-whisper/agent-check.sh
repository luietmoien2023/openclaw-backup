#!/bin/bash

# Agent OpenClaw pour Telegram Voice
# Ce script est appelé par un cron ou une session continue
# Il vérifie les messages vocaux transcrits et demande une réponse

PENDING_FILE="/tmp/telegram-voice/pending_messages.json"
LOG_FILE="/data/workspace/logs/telegram-voice-agent.log"

mkdir -p "$(dirname "$LOG_FILE")"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Vérifier s'il y a des messages en attente
if [ ! -f "$PENDING_FILE" ]; then
    exit 0
fi

# Lire les messages
MESSAGES=$(cat "$PENDING_FILE" 2>/dev/null || echo "[]")

# Traiter chaque message non traité
echo "$MESSAGES" | jq -c '.[] | select(.processed == false)' 2>/dev/null | while read -r message; do
    CHAT_ID=$(echo "$message" | jq -r '.chatId')
    TEXT=$(echo "$message" | jq -r '.text')
    DURATION=$(echo "$message" | jq -r '.audioDuration')
    
    log "🎙️ Message vocal reçu de $CHAT_ID (${DURATION}s): $TEXT"
    
    # Créer une notification pour l'agent principal
    # L'agent principal va voir ce fichier et répondre
    cat > "/tmp/telegram-voice/response_${CHAT_ID}.json" << EOF
{
  "chatId": "$CHAT_ID",
  "originalText": "$TEXT",
  "audioDuration": $DURATION,
  "timestamp": "$(date -Iseconds)",
  "needsResponse": true
}
EOF
    
    log "📤 Notification créée pour réponse automatique"
done

# Marquer tous les messages comme traités
if command -v jq &> /dev/null; then
    echo "$MESSAGES" | jq '[.[] | .processed = true]' > "$PENDING_FILE.tmp"
    mv "$PENDING_FILE.tmp" "$PENDING_FILE"
fi
