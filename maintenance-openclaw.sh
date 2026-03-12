#!/bin/bash
# Maintenance préventive OpenClaw - À exécuter avant chaque mise à jour
# Créé: 2026-03-02

set -e

echo "🔧 Maintenance préventive OpenClaw"
echo "=================================="

# 1. Backup de la configuration
echo "📦 Backup de la configuration..."
BACKUP_DIR="/data/workspace/backups/openclaw/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
cp ~/.openclaw/openclaw.json "$BACKUP_DIR/"
cp -r ~/.openclaw/credentials "$BACKUP_DIR/" 2>/dev/null || true
cp ~/.openclaw/cron/jobs.json "$BACKUP_DIR/" 2>/dev/null || true
echo "✅ Backup créé: $BACKUP_DIR"

# 2. Nettoyage des sessions orphelines (>30 jours)
echo "🧹 Nettoyage des vieilles sessions..."
find ~/.openclaw/agents/main/sessions -name "*.jsonl" -mtime +30 -type f -delete 2>/dev/null || true

# 3. Rotation des logs (>10MB)
echo "📋 Rotation des gros fichiers de log..."
find ~/.openclaw/agents/main/sessions -name "*.jsonl" -size +10M -type f | while read f; do
    mv "$f" "$f.old"
    gzip "$f.old"
    echo "  Compressé: $f"
done

# 4. Vérification des permissions
echo "🔐 Vérification des permissions..."
chmod 700 ~/.openclaw/credentials 2>/dev/null || true
chmod 600 ~/.openclaw/credentials/* 2>/dev/null || true
chmod 700 ~/.openclaw/agents 2>/dev/null || true

# 5. Vérification de l'intégrité
echo "🩺 Vérification de l'intégrité..."
if command -v openclaw &> /dev/null; then
    openclaw doctor --non-interactive 2>&1 | grep -E "(Error|Warning|orphan|lock)" || echo "✅ Pas d'erreurs critiques"
fi

# 6. Nettoyage des vieux backups (>30 jours)
echo "🗑️  Nettoyage des vieux backups..."
find /data/workspace/backups/openclaw -type d -mtime +30 -exec rm -rf {} + 2>/dev/null || true

echo ""
echo "✅ Maintenance terminée!"
echo "💾 Backup disponible: $BACKUP_DIR"
