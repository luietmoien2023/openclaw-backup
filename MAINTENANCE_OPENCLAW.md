# 🔧 Maintenance OpenClaw - Guide Préventif

## Problèmes détectés et corrigés

### 1. ✅ Cron watchdog timeout (CRITIQUE)
**Problème:** Le cron de santé des agents timeout après 120s et génère des erreurs  
**Cause:** Message trop long + pas de dossier de log  
**Correction:** 
- Créé `/data/workspace/monitor/logs/`
- Optimisé le message du cron (plus court)
- Réduit timeout à 60s
- Passé l'intervalle à 60min (au lieu de 30min)

### 2. ✅ Permissions credentials
**Problème:** Risque de permissions trop ouvertes  
**Correction:** `chmod 600` sur tous les fichiers credentials

### 3. ✅ Backup automatique
**Problème:** Pas de backup avant mise à jour = risque de perte  
**Correction:** Script `/data/workspace/maintenance-openclaw.sh` créé

### 4. ✅ Rotation logs sessions
**Problème:** Les fichiers .jsonl peuvent grossir indéfiniment  
**Correction:** Compression auto des fichiers >10MB

---

## 🚀 Procédure de mise à jour sécurisée

### AVANT chaque mise à jour Coolify:

1. **Backup manuel (30s)**
   ```bash
   /data/workspace/maintenance-openclaw.sh
   ```

2. **Vérifier l'état**
   ```bash
   openclaw doctor --non-interactive
   openclaw status
   ```

3. **Dans Coolify:**
   - Ne changer QUE le numéro de version (ex: `2026.2.26` → `2026.2.27`)
   - NE PAS changer de registry (garder `coollabsio/`)
   - Redeploy

4. **Après déploiement:**
   ```bash
   openclaw status  # Vérifier que tout démarre
   ps aux | grep openclaw  # Vérifier stabilité (attendre 2-3 min)
   ```

---

## 📋 Checklist santé (à faire 1x/semaine)

- [ ] `openclaw doctor --non-interactive` → pas d'erreurs critiques
- [ ] `du -sh ~/.openclaw/agents` → < 50Mo
- [ ] `ls -la ~/.openclaw/credentials` → permissions 600
- [ ] Vérifier 1 backup récent dans `/data/workspace/backups/openclaw/`

---

## 🆘 En cas de problème après MAJ

**Si boucle de redémarrage:**
1. Restaurer snapshot Coolify immédiatement
2. Vérifier que le healthcheck ne pointe pas sur le mauvais port
3. Ne pas changer de registry d'image

**Si données manquantes:**
```bash
# Restaurer dernier backup
LATEST=$(ls -t /data/workspace/backups/openclaw/ | head -1)
cp "/data/workspace/backups/openclaw/$LATEST/openclaw.json" ~/.openclaw/
```

---

## ⚠️ Règles d'or

1. **Jamais de `ghcr.io/openclaw/openclaw`** → utiliser uniquement `coollabsio/openclaw`
2. **Toujours backup avant MAJ** → script maintenance-openclaw.sh
3. **Vérifier stabilité 5min après MAJ** → `ps aux | grep openclaw`
4. **Ne pas modifier les package.json** → OpenClaw les gère

---

Dernière mise à jour: 2026-03-02
