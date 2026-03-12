# 🤖 AGENTS SEO - Bijouterie Hidous

**Documentation centralisée de tous les agents et connexions**  
*Dernière mise à jour: 2026-03-03*

---

## 📋 Table des matières

1. [Agents actifs](#agents-actifs)
2. [Agents planifiés (Cron)](#agents-planifiés-cron)
3. [Connexions API établies](#connexions-api-établies)
4. [Connexions en cours de configuration](#connexions-en-cours-de-configuration)
5. [Configuration LLM par défaut](#configuration-llm-par-défaut)

---

## 🎯 Agents actifs

### 1. `main` (Néo)
| Attribut | Valeur |
|----------|--------|
| **Rôle** | Agent principal, interface avec Danil |
| **Fonction** | SEO expert, conversations interactives, coordination |
| **LLM Principal** | `nvidia/moonshotai/kimi-k2.5` (gratuit) |
| **Failover** | `moonshot/kimi-k2.5` (payant) → `openai/gpt-5-mini` (payant) |
| **Workspace** | `/data/workspace` |
| **Créé le** | 2026-02-28 |

**Responsabilités:**
- Conversations SEO avec Danil
- Coordination des sous-agents
- Configuration système
- Mise à jour documentation

---

### 2. `ga4-analytics`
| Attribut | Valeur |
|----------|--------|
| **Rôle** | Agent Analytics / Rapports de trafic |
| **Fonction** | Lire et analyser les données Google Analytics 4 |
| **LLM Principal** | `openrouter/meta-llama/llama-3.3-70b-instruct` (gratuit) |
| **Failover** | `openrouter/google/gemini-2.0-flash-001` (gratuit) |
| **Workspace** | `/data/workspace` |
| **Créé le** | 2026-03-03 |

**Capacités:**
- Rapports de trafic en temps réel
- Pages les plus vues

---

### 3. `telegram-voice` 🎙️
| Attribut | Valeur |
|----------|--------|
| **Rôle** | Agent de transcription vocale Telegram |
| **Fonction** | Reçoit les vocaux Telegram, transcrit avec Whisper local, envoie le texte pour réponse |
| **LLM Principal** | `openrouter/meta-llama/llama-3.3-70b-instruct` (gratuit) |
| **Failover** | `openrouter/google/gemini-2.0-flash-001` (gratuit) |
| **Workspace** | `/data/workspace` |
| **Créé le** | 2026-03-03 |
| **Coût** | **100% GRATUIT** (Whisper local, pas d'API) |

**Capacités:**
- Réception des messages vocaux Telegram
- Transcription locale avec Whisper (modèle `turbo` par défaut)
- Conversion OGG → WAV via FFmpeg
- Notification de l'agent principal pour réponse
- Support multilingue (détection auto)

**Fichiers:**
- Skill: `/data/workspace/skills/telegram-voice-whisper/SKILL.md`
- Serveur: `/data/workspace/skills/telegram-voice-whisper/server.js`
- Config: `/data/workspace/skills/telegram-voice-whisper/config.json`
- Démarrage: `/data/workspace/skills/telegram-voice-whisper/start-telegram-voice.sh`
- Agent: `/data/workspace/skills/telegram-voice-whisper/agent-check.sh`

**Prérequis:**
```bash
pip install openai-whisper
sudo apt-get install ffmpeg
```

**Démarrage:**
```bash
cd /data/workspace/skills/telegram-voice-whisper
./start-telegram-voice.sh start
```

**Configuration webhook Telegram:**
- Modifier `config.json` → `webhook_url` avec ton domaine
- Le script configure automatiquement le webhook Telegram

**Architecture:**
```
Vocal Telegram → Webhook → Téléchargement → FFmpeg (OGG→WAV) → Whisper → Texte → OpenClaw
```
- Sources de trafic (Google, Direct, Social)
- Rapports hebdomadaires automatiques
- Alertes si chute de trafic

**Fichiers:**
- Config: `/data/workspace/ga4-agent-config.json`
- Script: `/data/workspace/ga4-agent.sh`
- Test: `/data/workspace/test-ga4-config.sh`

**Variables d'environnement:**
```
GA4_PROPERTY_ID=334819686
GA4_SERVICE_ACCOUNT_EMAIL=neo-seo-agent@neo-488103.iam.gserviceaccount.com
```

---

## ⏰ Agents planifiés (Cron)

### 1. `watchdog-health-check`
| Attribut | Valeur |
|----------|--------|
| **Rôle** | Surveillance santé des agents |
| **Fréquence** | Toutes les heures (`every 3600s`) |
| **LLM** | `openrouter/meta-llama/llama-3.3-70b-instruct` (gratuit) |
| **Statut** | ✅ Actif |

**Fonction:**
- Vérifie que les modèles LLM répondent
- Test chaîne: NVIDIA → Moonshot → OpenAI
- Alerte Telegram si 3 échecs consécutifs

---

### 2. `backup-daily`
| Attribut | Valeur |
|----------|--------|
| **Rôle** | Backup quotidien configuration |
| **Fréquence** | Tous les jours à 3h00 (`0 3 * * *`) |
| **LLM** | `openrouter/meta-llama/llama-3.3-70b-instruct` (gratuit) |
| **Statut** | ✅ Actif |

**Fonction:**
- Exécute `/data/workspace/maintenance-openclaw.sh`
- Backup fichiers critiques
- Vérification intégrité

---

## 🔌 Connexions API établies

### ✅ Dolibarr (ERP)
| Info | Valeur |
|------|--------|
| **Statut** | ✅ Fonctionnel |
| **URL** | `https://dolibarr.coolify.daniltech.com/api/index.php` |
| **Auth** | Clé API (header `DOLAPIKEY`) |
| **Stockage** | Variable Coolify `DOLIBARR_API_KEY` |
| **Utilisé par** | `main` (Néo) |
| **Capacités** | Factures, clients, produits, stats |

**Leçon apprise:** Vérifier TOUJOURS les IDs individuellement, ne jamais affirmer "0" sans triple-vérification.

---

### ✅ Cloudflare
| Info | Valeur |
|------|--------|
| **Statut** | ✅ Fonctionnel |
| **Account ID** | `5f0c5a45685e2d2d46ef3b7e54f9fbd0` |
| **Zone ID** | `5a7e398999c8a6fe3ad13d39ac72ce3c` |
| **Auth** | API Token |
| **Stockage** | Variable Coolify `CLOUDFLARE_API_TOKEN` |
| **Utilisé par** | `main` (Néo) |
| **Capacités** | DNS, Cache, Analytics, Rules |

---

### ✅ Telegram Bot
| Info | Valeur |
|------|--------|
| **Statut** | ✅ Fonctionnel |
| **Bot** | @NeoHidousBot |
| **Auth** | Bot Token |
| **Stockage** | Variable Coolify `TELEGRAM_BOT_TOKEN` |
| **Mode** | Allowlist strict (uniquement Danil) |
| **Utilisé par** | `main`, agents de monitoring |
| **Capacités** | Alertes, notifications, DMs |

---

### ✅ Google Analytics 4
| Info | Valeur |
|------|--------|
| **Statut** | ✅ Connecté et fonctionnel |
| **Property ID** | `334819686` |
| **Compte de service** | `neo-seo-agent@neo-488103.iam.gserviceaccount.com` |
| **Auth** | JWT Service Account |
| **Stockage** | Variable Coolify `GA4_SERVICE_ACCOUNT_KEY` (JSON) |
| **Utilisé par** | `ga4-analytics` |
| **Capacités** | Rapports temps réel, trafic, conversions |

---

### ✅ WordPress (Lecture + Écriture)
| Info | Valeur |
|------|--------|
| **Statut** | ✅ Connecté (Lecture + Écriture) |
| **URL** | `https://bijouteriehidous.com` |
| **API** | REST API WordPress native (`/wp-json/wp/v2/`) |
| **Auth** | Application Password — user `neo` |
| **Rôle** | Éditeur |
| **Utilisé par** | `main`, `wp-manager` |
| **Capacités** | Lire/écrire articles, pages, médias, publier |

---

---

### 4. `local-seo` 📍
| Attribut | Valeur |
|----------|--------|
| **Rôle** | Surveillance Google Business Profile + avis locaux |
| **Fréquence** | Quotidien à 8h00 (heure Montréal) |
| **LLM** | `openrouter/meta-llama/llama-3.3-70b-instruct` (gratuit) |
| **Statut** | ✅ Actif |
| **Cron ID** | `f8cf81b7-bd76-4b62-a019-41b6baf20c4a` |

**Capacités:**
- Note Google actuelle + nombre d'avis
- Alerte si nouvel avis < 4★ ou baisse de note
- Analyse 3 concurrents locaux (bijouteries Montréal)
- Rapport quotidien condensé sur Telegram

**API utilisée:** Google Places API (`GOOGLE_PLACES_API_KEY`)

---

### 5. `analytics-seo` 📊
| Attribut | Valeur |
|----------|--------|
| **Rôle** | Rapport combiné GA4 + Google Search Console |
| **Fréquence** | Hebdomadaire (lundi à 9h00, heure Montréal) |
| **LLM** | `openrouter/meta-llama/llama-3.3-70b-instruct` (gratuit) |
| **Statut** | ✅ Actif |
| **Cron ID** | `77620f9e-26c6-4501-a978-6bf10e3d0638` |

**Capacités:**
- Sessions GA4 semaine actuelle vs précédente
- Top 5 pages vues + sources de trafic
- Top 10 mots-clés GSC (impressions, clics, position)
- Analyse croisée: mots-clés → trafic
- Alerte si métrique chute > 20%

**API utilisée:** GA4 (service account `neo-seo-agent@neo-488103.iam.gserviceaccount.com`) + GSC

---

### 6. `keyword-tracker` 🔍
| Attribut | Valeur |
|----------|--------|
| **Rôle** | Suivi positions mots-clés + opportunités |
| **Fréquence** | Hebdomadaire (mercredi à 10h00, heure Montréal) |
| **LLM** | `openrouter/google/gemini-2.0-flash-001` (gratuit) |
| **Statut** | ✅ Actif |
| **Cron ID** | `12e44ac2-8819-4d9f-a918-80448e8c2412` |

**Mots-clés surveillés:**
- bijouterie Montréal, bijouterie Fleury, bijouterie Ahuntsic
- réparation montre Montréal, réparation bijoux Montréal
- bijouterie Hidous, réparation bijoux Fleury

**Capacités:**
- Position Bijouterie Hidous sur chaque mot-clé
- Analyse concurrents sur mêmes requêtes
- Identification opportunités longue traîne
- Rapport condensé avec variations

---

## 🔧 Connexions en cours de configuration

### ⚠️ WordPress (Écriture)
| Info | Valeur |
|------|--------|
| **Statut** | ❌ 401 Non autorisé |
| **URL** | `https://bijouteriehidous.com/wp-json/wp/v2/` |
| **Auth** | Application Password (à créer) |
| **Problème** | `rest_not_logged_in` - Possible plugin sécurité (Wordfence/Sucuri) |
| **Utilisé par** | `main` (Néo) - bloqué pour l'instant |
| **Capacités** | Créer/modifier articles, pages, médias |

**Prochaine étape:** Créer Application Password dans WordPress ou vérifier plugins sécurité.

---

### ⚠️ NeuronWriter
| Info | Valeur |
|------|--------|
| **Statut** | ❌ 401 Non autorisé |
| **Auth** | Header `X-API-KEY` |
| **Clé** | `n-22b6b31b07a7a01eebbb8ca52e24b422` (dans Coolify) |
| **Utilisé par** | Pas encore utilisé |
| **Capacités** | SEO content optimization, briefs |

**Prochaine étape:** Tester avec header API key correct.

---

### ⚠️ Paperless-ngx
| Info | Valeur |
|------|--------|
| **Statut** | ❌ 401 Non autorisé |
| **Auth** | Header `Authorization: Token <token>` |
| **Token** | `ea9ff9d420de29d25630dac993e390b96f2fe9e6` (dans Coolify) |
| **Utilisé par** | Pas encore utilisé |
| **Capacités** | Gestion documents, OCR, archivage |

**Prochaine étape:** Tester avec header Authorization correct.

---

### ⚠️ WooCommerce API
| Info | Valeur |
|------|--------|
| **Statut** | ❌ Non configuré |
| **Auth** | Consumer Key + Consumer Secret (à créer) |
| **Utilisé par** | Pas encore utilisé |
| **Capacités** | Produits, commandes, clients, rapports de vente |

**Prochaine étape:** Créer clés API WooCommerce dans WordPress Admin.

---

## 🧠 Configuration LLM par défaut

### Ordre de priorité (Conversations avec Danil)
1. **`nvidia/moonshotai/kimi-k2.5`** — GRATUIT (défaut)
2. **`moonshot/kimi-k2.5`** — Payant (backup si NVIDIA down)
3. **`openai/gpt-5-mini`** — Payant (3e fournisseur)

### Ordre de priorité (Heartbeats / Tâches de fond)
1. **`openrouter/meta-llama/llama-3.3-70b-instruct`** — GRATUIT (illimité)
2. **`openrouter/google/gemini-2.0-flash-001`** — GRATUIT (illimité)
3. **`openai/gpt-4o-mini`** — Payant (backup)

**Règles:**
- **JAMAIS** utiliser Claude Sonnet 4.5 (interdit par Danil)
- **TOUJOURS** annoncer le modèle actif au début de chaque conversation
- **TOUJOURS** prévenir avant changement de modèle (failover)
- Préserver quota NVIDIA (~20 req/min) pour conversations importantes

---

## 📁 Fichiers de référence

| Fichier | Description |
|---------|-------------|
| `/data/workspace/AGENTS.md` | Procédures agents, règles de comportement |
| `/data/workspace/MEMORY.md` | Mémoire long terme, règles permanentes |
| `/data/workspace/TOOLS.md` | Notes outils, configuration LLM |
| `/data/workspace/cron-jobs-optimized.json` | Jobs cron actifs |
| `/data/workspace/.learnings/ERRORS.md` | Journal erreurs |
| `/data/workspace/.learnings/LEARNINGS.md` | Leçons apprises |

---

## 🔄 Maintenance

**À faire périodiquement:**
- [ ] Mettre à jour ce fichier quand un nouvel agent est créé
- [ ] Vérifier que les connexions API fonctionnent toujours
- [ ] Archiver les agents obsolètes
- [ ] Mettre à jour les versions LLM si changement

---

*Document créé par Néo le 2026-03-03*  
*Source: Centralisation des configurations OpenClaw pour Bijouterie Hidous*
