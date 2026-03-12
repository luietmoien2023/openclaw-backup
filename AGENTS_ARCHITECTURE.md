# 🏗️ Architecture Multi-Agents — Danil / Bijouterie Hidous
*Créé le 2026-03-02*

---

## 🔄 Règle de failover universelle (TOUS les agents)

```
1. nvidia/moonshotai/kimi-k2.5  ← TOUJOURS EN PREMIER (gratuit)
        ↓ (429 / timeout / indispo)
2. moonshot/kimi-k2.5           ← Backup automatique (payant)
        ↓ (indispo / plus de crédits)
3. Autre modèle disponible      ← Dernier recours
        +
📱 Alerte Telegram à Danil : "⚠️ [Agent] : [modèle X] indispo/plus de crédits. J'utilise [Y]. Pensez à recharger."
```

---

## 🎯 Néo — Chef d'orchestre (MOI)
- **Rôle :** Stratégie, coordination, décisions, communication Danil
- **Modèle principal :** `openrouter/anthropic/claude-sonnet-4.6`
- **Failover :** nvidia/kimi-k2.5 → moonshot/kimi-k2.5

---

## 💎 Agents SEO

### 📝 Agent "Content Writer"
- **Rôle :** Rédaction articles blog + pages WordPress optimisées SEO
- **Modèle :** `nvidia/moonshotai/kimi-k2.5` → `moonshot/kimi-k2.5`
- **Outils :** WP API, NeuronWriter, GSC data

### 🔧 Agent "Technical SEO"
- **Rôle :** Meta tags, schema markup, Core Web Vitals, liens cassés
- **Modèle :** `nvidia/moonshotai/kimi-k2.5` → `moonshot/kimi-k2.5`
- **Outils :** WP API, GSC API

### 📍 Agent "GMB & Social"
- **Rôle :** Posts Google My Business + contenu Instagram/Facebook
- **Modèle :** `nvidia/moonshotai/kimi-k2.5` → `moonshot/kimi-k2.5`
- **Outils :** GMB API, n8n

### 📊 Agent "Keyword Monitor"
- **Rôle :** Surveillance positions Google, alertes si chute, rapport hebdo
- **Modèle :** `nvidia/moonshotai/kimi-k2.5` → `moonshot/kimi-k2.5`
- **Fréquence :** Cron hebdomadaire (lundi 8h)
- **Outils :** GSC API, GA4 API

---

## 🧾 Agents Comptabilité & Documents

### 📸 Agent "Vision Factures"
- **Rôle :** Lire photos/PDF de factures → extraire données → Paperless + Dolibarr
- **Modèle principal :** `openrouter/google/gemini-pro-1.5` (vision multimodale)
- **Failover :** `nvidia/kimi-k2.5` → `moonshot/kimi-k2.5`
- **Outils :** Paperless API, Dolibarr API
- **Trigger :** Photo envoyée sur Telegram

### 🧮 Agent "Comptable"
- **Rôle :** Sync Paperless → Dolibarr, rapprochement, alertes impayés
- **Modèle :** `nvidia/moonshotai/kimi-k2.5` → `moonshot/kimi-k2.5`
- **Outils :** Paperless API, Dolibarr API
- **Fréquence :** Cron quotidien

---

## ⚙️ Agents Automatisation

### 🔁 Agent "n8n Monitor"
- **Rôle :** Surveille les workflows n8n, alerte si échec, redémarre si possible
- **Modèle :** `nvidia/moonshotai/kimi-k2.5` → `moonshot/kimi-k2.5`
- **Fréquence :** Cron toutes les heures

---

## 🔍 Agent "Deep Research"
- **Rôle :** Recherche web approfondie (concurrents SEO, tendances, veille)
- **Modèle principal :** `openrouter/perplexity/sonar-pro` (recherche web temps réel)
- **Failover :** `openrouter/perplexity/sonar` (gratuit) → `nvidia/kimi-k2.5`
- **Trigger :** À la demande de Néo ou Danil

---

## 🏠 Agent "Home Assistant"
- **Rôle :** Contrôle domotique, automatisations contextuelles
- **Modèle :** `nvidia/moonshotai/kimi-k2.5` → `moonshot/kimi-k2.5`
- **Outils :** Home Assistant API

---

## 📊 Agent "Rapport Hebdo"
- **Rôle :** Compile tout chaque lundi → envoie résumé Telegram
  - Positions SEO semaine
  - Trafic GA4
  - Factures en attente Dolibarr
  - CA de la semaine
  - Workflows n8n en erreur
- **Modèle :** `nvidia/moonshotai/kimi-k2.5` → `moonshot/kimi-k2.5`
- **Fréquence :** Cron lundi 8h00 (heure Montréal)

---

## 💰 Budget LLM estimé

| Agent | Modèle par défaut | Coût |
|-------|-------------------|------|
| Néo | Claude Sonnet 4.6 | ~$0.03/conv |
| Content Writer | NVIDIA Kimi K2.5 | **Gratuit** |
| Technical SEO | NVIDIA Kimi K2.5 | **Gratuit** |
| GMB & Social | NVIDIA Kimi K2.5 | **Gratuit** |
| Keyword Monitor | NVIDIA Kimi K2.5 | **Gratuit** |
| Vision Factures | Gemini Pro 1.5 | ~$0.001/facture |
| Comptable | NVIDIA Kimi K2.5 | **Gratuit** |
| n8n Monitor | NVIDIA Kimi K2.5 | **Gratuit** |
| Deep Research | Perplexity Sonar Pro | ~$0.005/requête |
| Rapport Hebdo | NVIDIA Kimi K2.5 | **Gratuit** |

**Total estimé : < $10/mois**

---

## 🗺️ Schéma global

```
         📱 Danil (Telegram)
                ↕
            🎯 Néo (Claude 4.6)
         (Chef d'orchestre)
    /    /    |    |    \    \
📝SEO 🔧Tech 📸Fact 🔍Rech 🏠Home 📊Hebdo
  |     |      |      |
 WP   WP+GSC Paper+  Sonar
 API   API  Dolibarr  Pro
         \    /
         n8n
```
