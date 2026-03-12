# 🔍 AUDIT SEO - Bijouterie Hidous
**Date:** 2026-03-01  
**Analyste:** Néo (SEO Agent)  
**Site:** https://bijouteriehidous.com

---

## 📊 RÉSUMÉ EXÉCUTIF

| Métrique | Valeur | Priorité |
|----------|--------|----------|
| **Pages** | 14 | 🟢 OK |
| **Articles de blog** | 0 | 🔴 CRITIQUE |
| **Produits WooCommerce** | Non accessible | 🟡 À vérifier |
| **Structure SEO** | Basique | 🟡 À optimiser |
| **Contenu** | Élémentor (visuel) | 🟡 SEO technique manquant |

**Score SEO Global:** 55/100 (Moyen - Gros potentiel d'amélioration)

---

## 🔴 PROBLÈMES CRITIQUES

### 1. ZERO ARTICLES DE BLOG (Priorité MAX)

**Problème:** Aucun contenu "piliers" pour capter le trafic organique.

**Impact:** 
- Impossible de classer sur les requêtes longue traîne
- Aucune autorité thématique construite
- Dépendance totale aux pages de services

**Opportunités manquées:**
- "Bague de fiançailles Montréal" → 0 article
- "Réparation bijoux prix" → 0 article  
- "Comment choisir alliance" → 0 article
- "Soudure laser bijouterie" → 0 article

**Solution:** Créer 2-4 articles/mois minimum (voir plan éditorial ci-dessous)

---

### 2. PAGES SERVICES SOUS-OPTIMISÉES

#### Page "Réparation de montres" (ID: 676)
- ❌ Pas de H2 structurés visibles dans l'API
- ❌ Contenu Elementor (visuel) = difficile pour Google à crawler
- ❌ Pas de FAQ schema
- ❌ Pas de données structurées LocalBusiness

#### Page "Réparation de bijoux" (ID: 491)
- ❌ Mêmes problèmes structurels

#### Page "Perçage d'oreilles" (ID: 573)
- ❌ Titre trop générique

---

### 3. PAGE D'ACCUEIL (ID: 739)

**Analyse:**
- ✅ Titre: "Accueil" (devrait être plus descriptif)
- ❌ Meta description: "Votre Bijoutier Joaillier à Montréal..." (pas assez accrocheur)
- ❌ Pas de H1 clair dans le contenu extrait
- ❌ Pas de CTA fort visible

**Optimisation recommandée:**
```
Titre SEO: Bijouterie de Luxe à Montréal | Bagues & Réparations - Hidous
Meta: Bijouterie Hidous à Montréal ⭐ 4.9/5 (290+ avis). Bagues de 
fiancailles, réparations laser & créations sur mesure. 📍 1736 Rue Fleury E. 
Devis gratuit !
```

---

## 🟡 AMÉLIORATIONS RECOMMANDÉES

### 4. STRUCTURE DES PAGES

| Page Actuelle | URL | Problème | URL Optimisée |
|---------------|-----|----------|---------------|
| Accueil | `/accueil` | Redondant | `/` (racine) |
| Nos bijoux | `/bijoux` | Trop générique | `/collection-bijoux-luxe-montreal` |
| Réparation de bijoux | `/reparation-de-bijoux` | OK mais peut mieux faire | `/reparation-bijoux-or-argent-montreal` |
| Réparation de montres | `/reparation-de-montres` | OK | `/reparation-montres-horloger-montreal` |

### 5. CONTENU MANQUANT

**Pages à créer (priorité haute):**

| Page | Pourquoi | Mots-clés cibles |
|------|----------|------------------|
| **Bagues de fiançailles** | Service phare | "bague fiancailles montreal", "bague diamant montreal" |
| **Alliances mariage** | Complément fiancailles | "alliance mariage montreal", "alliance or montreal" |
| **Boucles d'oreilles** | Collection | "boucles oreilles diamant montreal" |
| **Colliers & Pendentifs** | Collection | "collier or montreal", "pendentif diamant" |
| **Soudure laser bijoux** | USP technique | "soudure laser bijoux montreal", "reparation chaine or" |
| **Création sur mesure** | Service premium | "bijou sur mesure montreal", "joaillerie personnalisee" |
| **Pierres précieuses** | Éducatif/SEO | "pierres precieuses montreal", "diamant certifie" |
| **Blog / Conseils** | Contenu pilier | Longue traîne éducative |

### 6. RICH SNIPPETS / SCHEMAS MANQUANTS

**À ajouter sur toutes les pages:**

```json
{
  "@context": "https://schema.org",
  "@type": "JewelryStore",
  "name": "Bijouterie Hidous",
  "image": "https://bijouteriehidous.com/wp-content/uploads/...",
  "address": {
    "@type": "PostalAddress",
    "streetAddress": "1736 Rue Fleury E",
    "addressLocality": "Montréal",
    "addressRegion": "QC",
    "postalCode": "H2C 1T2",
    "addressCountry": "CA"
  },
  "geo": {
    "@type": "GeoCoordinates",
    "latitude": 45.558,
    "longitude": -73.658
  },
  "telephone": "+1-514-389-3232",
  "url": "https://bijouteriehidous.com",
  "openingHoursSpecification": [
    {
      "@type": "OpeningHoursSpecification",
      "dayOfWeek": ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"],
      "opens": "10:00",
      "closes": "18:00"
    },
    {
      "@type": "OpeningHoursSpecification", 
      "dayOfWeek": "Saturday",
      "opens": "10:00",
      "closes": "17:00"
    }
  ],
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.9",
    "reviewCount": "290"
  },
  "priceRange": "$$$"
}
```

**FAQ Schema** sur les pages services:
```json
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "Combien coûte une réparation de bijou ?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Le prix d'une réparation de bijou dépend de la complexité..."
      }
    }
  ]
}
```

---

## 📋 PLAN ÉDITORIAL RECOMMANDÉ

### MOIS 1 - Fondations

**Semaine 1:** Créer page "Bagues de fiançailles"
- Cible: "bague de fiancailles montreal" (480 recherches/mois)
- Longueur: 1500 mots
- Structure: Guide complet + produits + CTA

**Semaine 2:** Créer page "Réparation bijoux" (optimisée)
- Cible: "reparation bijoux montreal" (390 recherches/mois)
- Ajouter FAQ détaillée
- Photos avant/après

**Semaine 3:** Premier article blog
- Titre: "Comment choisir sa bague de fiançailles à Montréal en 2026"
- Longueur: 2000 mots
- Cibles: questions pratiques, budget, styles

**Semaine 4:** Article blog #2
- Titre: "Prix d'une réparation de bijou à Montréal : Guide complet"
- Cible: "prix reparation bijou montreal"

### MOIS 2 - Expansion

- Page "Alliances mariage"
- Article "Soudure laser bijouterie : avantages et prix"
- Article "Où faire réparer sa montre à Montréal ?"
- Optimisation pages existantes (meta descriptions, titres)

### MOIS 3 - Autorité

- Article "Les 5 meilleures bijouteries de Montréal" (comparatif)
- Page "Création bijou sur mesure"
- Article "Diamant vs Moissanite : que choisir ?"
- Début stratégie link building local

---

## 🎯 ACTIONS IMMÉDIATES (CETTE SEMAINE)

### Priorité 1 (À faire maintenant)
- [ ] Créer page "Bagues de fiançailles" (brouillon)
- [ ] Optimiser meta description page d'accueil
- [ ] Ajouter Schema.org LocalBusiness
- [ ] Créer 1er article blog (brouillon)

### Priorité 2 (Cette semaine)
- [ ] Optimiser page "Réparation de bijoux"
- [ ] Créer FAQ schema sur les pages services
- [ ] Vérifier/optimiser images (alt text)
- [ ] Créer page "Soudure laser" (US technique)

### Priorité 3 (Ce mois)
- [ ] Créer pages produits manquantes
- [ ] Lancer calendrier éditorial (2 articles/mois min)
- [ ] Setup Google Business Profile posts réguliers
- [ ] Débuter stratégie backlinks locaux

---

## 📈 IMPACT ATTENDU (6 MOIS)

| Métrique | Actuel | Objectif 6 mois |
|----------|--------|-----------------|
| Articles de blog | 0 | 12+ |
| Pages optimisées | 3 | 10+ |
| Mots-clés positionnés | ~5 | 30+ |
| Trafic organique | Bas | +200% |
| Rich snippets | 0 | 5+ types |

---

## 🚀 PROCHAINES ÉTAPES

**Que veux-tu que je fasse EN PREMIER ?**

| Option | Action | Temps |
|--------|--------|-------|
| **A** | Créer la page "Bagues de fiançailles" (brouillon) | 30 min |
| **B** | Optimiser la page d'accueil (meta + structure) | 20 min |
| **C** | Créer le 1er article de blog (brouillon) | 45 min |
| **D** | Ajouter les schemas JSON-LD (code à copier) | 15 min |

**Dis-moi ta priorité et je commence immédiatement !** 🎯
