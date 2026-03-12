# TOOLS.md - Local Notes

## Configuration LLM - Règle de failover

### Ordre de priorité
1. **NVIDIA (gratuit)** - `nvidia/moonshotai/kimi-k2.5` 
   - Clé: nvapi-...
   - Limites: ~20 req/min
   - Fallback sur erreur 429 (rate limit)
   
2. **Moonshot (payant)** - `moonshot/kimi-k2.5`
   - Backup automatique si NVIDIA indisponible

### Procédure
- **Démarrer avec NVIDIA** par défaut
- **Sur erreur 429 ou timeout** → basculer sur Moonshot
- **Toujours annoncer** le modèle actif au début de chaque conversation

### Commandes
```bash
# Basculer sur NVIDIA (gratuit)
/model nvidia/moonshotai/kimi-k2.5

# Basculer sur Moonshot (backup)
/model moonshot/kimi-k2.5

# Voir le modèle actuel
/status
```

---

## API Keys Actives

| Service | Clé | Statut |
|---------|-----|--------|
| NVIDIA | nvapi-Ec1raFY9... | ✅ Gratuit, limite rate |
| Moonshot | (config existante) | ✅ Payant, illimité |
| Telegram Bot | 8732913497:... | ✅ Bot créé, à configurer |

---

## 🧠 Self-Improving Agent Skill

**Location:** `/data/workspace/skills/self-improving-agent/` (workspace - survives updates)
**Source:** https://github.com/pskoett/self-improving-agent
**Installed:** 2026-03-03

**Règle:** Toujours logger les erreurs et corrections dans `.learnings/`
- `.learnings/ERRORS.md` — commandes qui échouent
- `.learnings/LEARNINGS.md` — corrections de Danil, lessons learned
- `.learnings/FEATURE_REQUESTS.md` — features demandées mais non dispo

**NE PAS installer dans `/opt/openclaw/app/skills/`** — écrasé lors des mises à jour.

---

*Dernière mise à jour: 2026-03-03*
