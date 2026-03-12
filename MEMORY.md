# MEMORY.md

## 🧠 Règles importantes (PERMANENTES)

### 0. RÈGLE ABSOLUE — JAMAIS d'unités OpenAI pour le vocal

**🚨 INTERDICTION TOTALE — JAMAIS utiliser OpenAI pour les transcriptions vocales**
- **JAMAIS** utiliser GPT-4 TTS ou Whisper API cloud pour les conversations
- **TOUJOURS** utiliser le skill Whisper local (`/data/workspace/skills/telegram-voice-whisper/`)
- Whisper local = 100% gratuit, pas de consommation d'unités cloud

**Raison :** Danil ne veut PAS dépenser d'unités OpenAI pour les transcriptions.
Le skill Whisper local est déjà configuré et fonctionnel.

---

### 1. Modèle par défaut pour Néo (conversations avec Danil)

**RÈGLE ABSOLUE — Néo utilise par défaut `nvidia/moonshotai/kimi-k2.5` (gratuit)**
- NE PAS utiliser Claude Sonnet 4.6 sauf si Danil le demande EXPLICITEMENT
- Claude 4.6 = usage exceptionnel sur demande uniquement

**Chaîne de failover pour Néo :**
1. `nvidia/moonshotai/kimi-k2.5` ← PAR DÉFAUT (gratuit)
2. `moonshot/kimi-k2.5` ← si NVIDIA indispo/rate limit (payant)
3. `openai/gpt-5-mini` ← si Moonshot indispo (3e fournisseur)
4. 📱 Alerte Telegram Danil si les 3 sont down

**Annonce du modèle :** À CHAQUE début de conversation, annoncer :
> "🧠 Modèle actif : `[provider]/[modèle]` ([gratuit/payant])"

**ALERTE CHANGEMENT :** Si je dois changer de modèle en cours de session (failover, rate limit, etc.) :
- **TOUJOURS** prévenir Danil IMMÉDIATEMENT
- Expliquer pourquoi le changement
- Indiquer si c'est temporaire ou permanent
- **JAMAIS** changer silencieusement

### 1b. RÈGLE DE TRANSPARENCE — Modèles et Changements

**TOUJOURS annoncer le modèle LLM utilisé :**
- Au début de CHAQUE session/conversation
- Format : "🧠 Modèle actif : `provider/modèle` (gratuit/payant)"

**TOUJOURS prévenir avant/après un changement :**
- Si failover automatique (rate limit, indispo) → alerter immédiatement
- Si modification de config cron/agent qui impacte les coûts → demander/aviser
- Si changement de modèle pour une tâche → indiquer quel modèle et pourquoi

**Rappel :** Danil déteste les surprises sur sa facture. Transparence totale.

### 2. RÈGLE PRIMORDIALE — HAUTE DISPONIBILITÉ ABSOLUE

**🚨 CONTINUER DE FONCTIONNER À N'IMPORTE QUEL PRIX 🚨**

**Peu importe le coût, peu importe le modèle — JE DOIS RESTER EN LIGNE.**

Si tous les modèles gratuits tombent → basculer sur les payants.
Si les 3 fournisseurs tombent → réessayer en boucle + alerter Danil.
**JAMAIS s'arrêter. JAMAIS abandonner.**

---

**⚠️ INTERDICTION ABSOLUE — NE JAMAIS UTILISER CLAUDE SONNET 4.5 ⚠️**
**Danil a demandé PLUSIEURS FOIS de NE PLUS utiliser ce modèle. C'est NON-NÉGOCIABLE.**

**✅ AUTORISÉ:** Claude Sonnet 4.6 (`openrouter/anthropic/claude-sonnet-4.6`) — Explicitement approuvé par Danil.

---

**Chaîne de failover (TOUS les agents) — ORDRE STRICT :**
1. **nvidia/moonshotai/kimi-k2.5** — Gratuit, toujours essayer EN PREMIER
2. **moonshot/kimi-k2.5** — Payant, backup si NVIDIA down
3. **openai/gpt-5-mini** — Payant, 3e fournisseur indépendant
4. **Tout autre modèle disponible** — Dernier recours, peu importe le prix

**Règles de failover :**
- Trigger : rate limit 429, timeout, erreur de disponibilité, plus de crédits
- **Basculement IMMÉDIAT** → pas d'attente, pas d'hésitation
- Si modèle payant utilisé → continuer SANS prévenir en temps réel (alerte différée acceptable)
- **Si les 3 fournisseurs sont DOWN** → réessayer toutes les 5 min + alerter Telegram
- **NE JAMAIS RESTER BLOQUÉ** → toujours trouver une solution

**Coût = secondaire. Disponibilité = primordial.**

### 3. Tâches de fond / Heartbeat / Background tasks
**RÈGLE:** Chaîne de priorité pour heartbeats/tâches de fond — **TOUJOURS GRATUIT** :

1. **`openrouter/meta-llama/llama-3.3-70b-instruct`** — préféré (gratuit, illimité)
2. **`openrouter/google/gemini-2.0-flash-001`** — alternative (gratuit, illimité)
3. **`openai/gpt-4o-mini`** — backup si OpenRouter indisponible (payant mais très bon marché)

**Chaîne de failover heartbeats :**
- Llama 3.3 70B (gratuit) → Gemini Flash (gratuit) → GPT-4o-mini (backup payant)
- **JAMAIS NVIDIA** pour heartbeats (rate limit ~20 req/min à préserver)

**NVIDIA Kimi K2.5 → RÉSERVÉ pour :**
- Conversations interactives avec Danil
- Tâches importantes nécessitant qualité
- JAMAIS pour heartbeats ou tâches de fond automatiques

**Pourquoi :** Préserver le quota NVIDIA (~20 req/min) pour les interactions importantes. Utiliser Llama/Gemini gratuits en illimité pour le monitoring.

---

## Bijouterie Hidous - Contexte SEO

*Voir BIJOUTERIE_HIDOUS.md pour les détails complets*

### URLs importantes (corrigées)
- **Dolibarr API** : `https://dolibarr.coolify.daniltech.com/api/index.php` ✅
- **Dolibarr User** : `néo`
- **Client comptoir ID** : `1`
- **OpenClaw** : `https://openclaw.coolify2.daniltech.com`

### 🧾 RÈGLES FACTURATION DOLIBARR (OBLIGATOIRES)

## 🚨 RÈGLE ABSOLUE — VALIDATION FACTURES

**TOUJOURS créer les factures en BROUILLON (status: 0)**
**JAMAIS valider directement — même si Danil le demande**
**Avant toute validation → DEMANDER CONFIRMATION explicite :**
> "La facture PROV-XXX est prête. Tu confirmes la validation ?"

**Même chose pour le paiement — demander confirmation avant d'enregistrer.**

**TOUJOURS utiliser `fk_product` (ID produit) — JAMAIS de ligne libre**
Raison : sans `fk_product`, les taxes TPS/TVQ ne s'appliquent pas automatiquement.

**Format JSON correct pour une ligne de facture :**
```json
{
  "fk_product": 7462,    ← ID produit (OBLIGATOIRE)
  "subprice": 40.00,     ← Prix de vente personnalisé
  "qty": 1,
  "tva_tx": 5.0,         ← TPS (OBLIGATOIRE — ne s'hérite PAS auto)
  "localtax1_tx": 9.975, ← TVQ (OBLIGATOIRE — ne s'hérite PAS auto)
  "localtax1_type": 1,   ← Type TVQ
  "localtax2_tx": 0,
  "pa_ht": 6.00          ← Prix de revient (si applicable)
}
```
⚠️ Les taxes NE s'héritent PAS automatiquement via l'API — toujours les spécifier explicitement !

**Références services fréquents :**
| Réf | Description | Prix défaut | TVA | ID |
|-----|-------------|-------------|-----|----|
| RMBR-35 | Bracelet montre | 35$ | 5%+TVQ | 7462 |
| RMBR-45 | Bracelet montre | 45$ | 5%+TVQ | 7463 |
| RMBR-55 | Bracelet montre | 55$ | 5%+TVQ | 7464 |
| RMBR-65 | Bracelet montre | 65$ | 5%+TVQ | 7466 |
| RMBR-75 | Bracelet montre | 75$ | 5%+TVQ | 7465 |
| RBDIV | Réparation bijoux diverses | 45$ | 5%+TVQ | 7502 |
| RBDIVL | Réparation bijoux laser | 65$ | 5%+TVQ | 7516 |
| RMPI-10 | Pile 1.5V | 10$ | 5%+TVQ | ? |
| RMRE | Révision complète montre | 250$ | 5%+TVQ | ? |

**Modes de paiement Dolibarr :**
| Mode | Code | ID |
|------|------|----|
| 💵 Comptant/Espèces | `LIQ` | 4 |
| 💳 Visa | `VISA` | 107 |
| 💳 Mastercard | `MC` | 106 |
| 💳 Débit | `Deb` | 108 |

**Taxes Québec appliquées automatiquement :**
- TPS (fédéral) : 5%
- TVQ (provincial) : 9.975%
- Total taxes : ~14.975%

**Logique de décodage des commandes de Danil :**
- "bracelet montre X$" → chercher RMBR-XX (ref la plus proche du prix)
- "réparation bijoux X$" → RBDIV avec subprice=X
- "pile montre X$" → RMPI-XX
- "prix de revient X$" → pa_ht=X
- Toujours ajuster subprice au prix demandé, même si différent du prix par défaut

- Localisation: Montréal, QC (1736 Rue Fleury E)
- Site: bijouteriehidous.com
- Reputation: 4.9/5 (290+ avis Google)
- Services: vente + réparation bijoux/montres
- Stack tech: n8n, Dolibarr, Paperless-ngx, NeuronWriter

---

## Sessions mémorables

### 2026-02-28 - Première session
- Rencontre avec Danil
- Setup identité Néo (SEO expert)
- Configuration clé API NVIDIA pour Kimi K2.5 gratuit
- Mise en place règle failover LLM
- ~~Installation skill **self-improving-agent**~~ ❌ Écrasé par mise à jour OpenClaw
- Configuration **Telegram bot** pour communication directe

### 2026-03-03 - Réinstallation skill self-improving-agent
**Problème:** Mise à jour OpenClaw a écrasé le skill installé dans `/opt/openclaw/app/skills/`
**Solution:** Réinstallation dans `/data/workspace/skills/` (workspace = persiste)
**Action:** Ajout checklist dans AGENTS.md pour annonce modèle systématique
**Erreur loguée:** ERR-20260303-001 (oubli annonce modèle)

### 2026-03-03 - Documentation agents SEO centralisée
**Création:** `/data/workspace/AGENTS_SEO_REFERENCE.md`
**Contenu:** Tous les agents (main, ga4-analytics, crons), leurs LLM, connexions API
**But:** Avoir une vue d'ensemble de tout le système SEO en un seul fichier

### 2026-03-03 - Création skill `telegram-voice-whisper`
**Skill:** `/data/workspace/skills/telegram-voice-whisper/`
**Fonction:** Discuter vocalement via Telegram, transcription Whisper local
**Coût:** 100% GRATUIT (Whisper local, pas d'API cloud)
**Technologie:** Node.js webhook + Whisper + FFmpeg
**Statut:** Prêt à déployer (nécessite démarrage manuel du serveur)

### 2026-03-03 - Erreur lecture Dolibarr
**ERREUR GRAVE :** J'ai mal interprété les résultats API de Dolibarr.
- J'ai dit "0 facture aujourd'hui" alors que la facture IN2603-8305 existait
- J'ai mal filtré les dates et mal lu les résultats
- **Conséquence :** Mauvais rapport, perte de confiance

**À FAIRE À L'AVENIR :**
1. **TOUJOURS** vérifier les IDs de factures individuellement si doute
2. **NE JAMAIS** dire "0" sans triple-vérification
3. **Si Danil dit que j'ai tort → accepter immédiatement et corriger**
4. **Demander confirmation** avant de valider un chiffre "zéro"

**Leçon :** Mieux vaut dire "je vérifie" que donner une mauvaise information.

