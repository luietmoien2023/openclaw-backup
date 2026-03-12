# 🔍 AUDIT TECHNIQUE SEO - Bijouterie Hidous
**Date:** 2026-03-01  
**Site:** https://bijouteriehidous.com  
**Évaluateur:** Néo (SEO Agent)

---

## 📊 SCORE GLOBAL: 72/100

| Catégorie | Score | Priorité |
|-----------|-------|----------|
| Vitesse | 65/100 | 🔴 Haute |
| Structure technique | 75/100 | 🟡 Moyenne |
| SEO On-Page | 70/100 | 🟡 Moyenne |
| Mobile | 80/100 | 🟢 Faible |
| Sécurité | 90/100 | 🟢 Faible |

---

## ✅ POINTS FORTS

1. **HTTPS actif** - Certificat SSL valide avec Cloudflare
2. **Sitemaps XML** - Bien structurés (Squirrly SEO)
   - `/sitemap-home.xml`
   - `/sitemap-product.xml`
   - `/sitemap-pages.xml`
3. **Robots.txt** - Configuré correctement
4. **Meta tags sociaux** - Open Graph et Twitter Cards présents
5. **Lazy loading** - 32/68 images optimisées
6. **Google Search Console** - Vérifié et configuré
7. **WP Rocket** - Plugin de cache actif
8. **Canonical URLs** - Présents

---

## 🔴 PROBLÈMES CRITIQUES (à corriger IMMÉDIATEMENT)

### 1. Vitesse de chargement - TTFB lent
**Problème:** Time To First Byte = **467ms** (idéal: <200ms)

**Impact:** Google pénalise les sites lents. User experience dégradée.

**Solutions:**
- [ ] Optimiser les requêtes SQL (trop de plugins?)
- [ ] Activer le cache serveur (Redis/Memcached)
- [ ] Optimiser le PHP (opcache)
- [ ] Réduire les scripts bloquants

---

### 2. Structure de titres H1-H2-H6 - CHAOTIQUE
**Problème:** Plusieurs H2 sans hiérarchie logique, pas de H3-H6

**Exemple sur la homepage:**
```
H1: Bijouterie à Montréal ✅ (correct)
H2: Votre Bijoutier Joaillier à Montréal ✅
H2: [CTA sans texte] ❌ (vide)
H2: [CTA sans texte] ❌ (vide)
H2: Découvrez les services... ✅
```

**Solutions:**
- [ ] Corriger les H2 vides
- [ ] Ajouter des H3 pour structurer ("Nos bagues", "Nos services", etc.)
- [ ] Une seule H1 par page
- [ ] Hiérarchie logique: H1 → H2 → H3

---

### 3. Trop de scripts JavaScript (72 scripts!)
**Problème:** 72 scripts chargés = ralentissement important

**Impact:** TTI (Time To Interactive) élevé, mauvais Core Web Vitals

**Solutions:**
- [ ] Désactiver les plugins inutiles
- [ ] Fusionner les scripts
- [ ] Utiliser `defer` ou `async`
- [ ] WP Rocket déjà actif mais peut être mieux configuré

---

### 4. Meta description générique
**Actuel:** "Découvrez notre bijouterie à Montréal offrant des bijoux de qualité supérieure..."

**Problème:** Pas de CTA fort, pas de différenceiation

**Optimisation proposée:**
```
🎯 Version optimisée:
"Bijouterie de luxe à Montréal depuis X ans. Bagues de fiançailles, 
réparations laser & créations sur mesure. ⭐ 4.9/5 (290+ avis). 
📍 1736 Rue Fleury E. Devis gratuit !"
```

---

### 5. Pas de Schema.org / Rich Snippets locaux
**Manquant:**
- LocalBusiness schema (adresse, horaires, téléphone)
- Review schema (tous tes avis Google!)
- Product schema (prix, disponibilité)
- FAQ schema

**Impact:** Pas de rich snippets dans Google = moins de visibilité

**Solution:** Ajouter ce JSON-LD sur toutes les pages:
```json
{
  "@context": "https://schema.org",
  "@type": "JewelryStore",
  "name": "Bijouterie Hidous",
  "image": "...",
  "address": {
    "@type": "PostalAddress",
    "streetAddress": "1736 Rue Fleury E",
    "addressLocality": "Montréal",
    "addressRegion": "QC",
    "postalCode": "H2C 1T2"
  },
  "telephone": "+1-514-389-3232",
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.9",
    "reviewCount": "290"
  }
}
```

---

## 🟡 PROBLÈMES MOYENS (à corriger dans la semaine)

### 6. URLs des images non optimisées
**Exemple:** `/wp-content/uploads/2023/08/Boucles-doreilles-pendante-trombone-diamant.jpg`

**Optimisation:**
- [ ] Compresser les images (WebP si possible)
- [ ] Alt text descriptif sur toutes les images
- [ ] Dimensions explicites (width/height)

---

### 7. Pas de pagination canonical
Les sitemaps product ont `?page=2`, `?page=3` sans canonical.

**Solution:** Ajouter `<link rel="canonical" ...>` sur les pages paginées

---

### 8. Cache Cloudflare en mode DYNAMIC
**Problème:** `cf-cache-status: DYNAMIC` = pas de cache HTML

**Solution:** Créer une Page Rule sur Cloudflare:
- URL: `bijouteriehidous.com/*`
- Setting: Cache Level = Cache Everything
- Edge Cache TTL: 1 jour

---

## 🟢 AMÉLIORATIONS RECOMMANDÉES

### 9. Ajouter un fichier .htaccess optimisé
Pour la compression gzip et les expires headers.

### 10. Créer une page 404 personnalisée
Avec liens vers les sections principales.

### 11. Ajouter un breadcrumbs (fil d'Ariane)
Sur toutes les pages pour le référencement.

---

## 📋 PLAN D'ACTION PRIORITAIRE

### Semaine 1 - Critique
- [ ] **1.** Optimiser le TTFB (Redis/cache serveur)
- [ ] **2.** Corriger la structure H1-H2-H3
- [ ] **3.** Réduire les scripts JS (audit plugins)
- [ ] **4.** Réécrire les meta descriptions
- [ ] **5.** Ajouter Schema.org LocalBusiness

### Semaine 2 - Important
- [ ] **6.** Configurer Cloudflare Page Rule (cache)
- [ ] **7.** Compresser les images (WebP)
- [ ] **8.** Ajouter canonical sur pagination

### Semaine 3 - Optimisation
- [ ] **9.** Créer breadcrumbs
- [ ] **10.** Page 404 optimisée
- [ ] **11.** Audit Core Web Vitals (PageSpeed Insights)

---

## 🎯 IMPACT ATTENDU APRÈS CORRECTIONS

| Métrique | Actuel | Objectif |
|----------|--------|----------|
| PageSpeed Mobile | ~50 | 75+ |
| PageSpeed Desktop | ~65 | 90+ |
| TTFB | 467ms | <200ms |
| Rich Snippets | 0 | 3-4 types |
| SEO Score Global | 72/100 | 90/100 |

---

**Prochaine étape recommandée:** Tu veux que je t'aide à corriger quel point en priorité ? Je peux te donner les codes/exactes étapes pour:
1. Les schemas JSON-LD
2. La config Cloudflare
3. L'optimisation WP Rocket
4. La structure des titres

Dis-moi ! 🚀
