# 🌐 CONFIGURATION CLOUDFLARE - Bijouterie Hidous
**Objectif:** Optimiser le cache et réduire le TTFB de 467ms à <200ms

---

## 📍 ÉTAPE 1: Accéder au dashboard Cloudflare

1. Va sur https://dash.cloudflare.com
2. Connecte-toi avec ton compte
3. Sélectionne ton domaine: **daniltech.com** (ou bijouteriehidous.com si séparé)

---

## 📍 ÉTAPE 2: Page Rules (RÈGLES DE PAGE)

**Où:** `Rules` → `Page Rules` → `Create Page Rule`

### Rule 1: Cache HTML complet
```
URL: *bijouteriehidous.com/*
Settings:
  ☑️ Cache Level: Cache Everything
  ☑️ Edge Cache TTL: 1 day
  ☑️ Browser Cache TTL: 4 hours
  ☑️ Always Online: ON
```

### Rule 2: Admin WordPress (PAS de cache)
```
URL: *bijouteriehidous.com/wp-admin*
Settings:
  ☑️ Cache Level: Bypass
  ☑️ Security Level: High
```

### Rule 3: API/Login (PAS de cache)
```
URL: *bijouteriehidous.com/wp-login*
Settings:
  ☑️ Cache Level: Bypass
```

**⚠️ Important:** L'ordre des règles compte! Place la règle 1 en BAS (moins prioritaire), règles 2 et 3 en HAUT.

---

## 📍 ÉTAPE 3: Caching Configuration

**Où:** `Caching` → `Configuration`

| Setting | Valeur | Pourquoi |
|---------|--------|----------|
| **Caching Level** | Standard | Bon équilibre |
| **Browser Cache TTL** | 4 hours | Cache navigateur |
| **Always Online** | ON | Site disponible si serveur down |
| **Development Mode** | OFF (sauf debug) | Désactive temporairement le cache |

---

## 📍 ÉTAPE 4: Speed → Optimization

**Où:** `Speed` → `Optimization`

### Auto Minify (cocher les 3)
- [x] **JavaScript** - Minifie le JS
- [x] **CSS** - Minifie le CSS  
- [x] **HTML** - Minifie le HTML

### Brotli
- [x] **ON** - Compression moderne (meilleure que gzip)

### Rocket Loader (ATTENTION)
- [ ] **OFF** - Laisse WP Rocket gérer (conflit possible)

### Early Hints
- [x] **ON** - Améliore le LCP

---

## 📍 ÉTAPE 5: Speed → Image Optimization

**Si tu as un plan PRO ($20/mois):**
- [x] **Polish** - Lossless ou Lossy (compression images)
- [x] **WebP** - Converti auto en WebP

**Gratuit:** Utilise un plugin WordPress (ShortPixel, Imagify)

---

## 📍 ÉTAPE 6: Network

**Où:** `Network`

| Setting | Valeur |
|---------|--------|
| **HTTP/2** | ON |
| **HTTP/3 (QUIC)** | ON |
| **0-RTT Connection Resumption** | ON |
| **IPv6 Compatibility** | ON |
| **WebSockets** | ON |
| **IP Geolocation** | ON |

---

## 📍 ÉTAPE 7: Scrape Shield (optionnel)

**Où:** `Scrape Shield`

- [x] **Hotlink Protection** - Empêche le vol d'images
- [x] **Email Address Obfuscation** - Protège les emails

---

## 📍 ÉTAPE 8: DNS (vérification)

**Où:** `DNS` → `Records`

Assure-toi que:
- L'icône 🟠 Orange (proxied) est active sur l'enregistrement A de bijouteriehidous.com
- Si 🟢 Gris = pas de cache Cloudflare!

**Exemple correct:**
```
Type: A
Name: bijouteriehidous
IPv4: [IP de ton serveur]
Proxy: 🟠 Proxied (DOIT être orange)
TTL: Auto
```

---

## 📍 ÉTAPE 9: WP Rocket Configuration

Dans ton WordPress, va dans **WP Rocket** et synchronise avec Cloudflare:

1. WP Rocket → **Add-ons** → **Cloudflare**
2. Clique sur **Modify options**
3. Remplis:
   - **Global API Key**: Trouvé dans Cloudflare → Mon profil → Tokens API
   - **Email**: ton email Cloudflare
   - **Zone ID**: Trouvé dans Cloudflare → Overview (sidebar droite)

4. **Save Changes**

5. Dans l'onglet **Cloudflare**:
   - [x] **Optimal settings** - Active les réglages optimaux
   - [x] **Relative protocol** - ON

---

## 📍 ÉTAPE 10: Purger le cache

**Après chaque modification:**

1. **Cloudflare:** `Caching` → `Purge Everything`
2. **WP Rocket:** Tableau de bord → `Vider le cache`

---

## ✅ CHECKLIST DE VÉRIFICATION

Une fois configuré, teste avec:

```bash
# Dans ton terminal ou https://httpstatus.io
curl -sI https://bijouteriehidous.com | grep -i "cf-cache\|age"
```

**Résultat attendu:**
```
cf-cache-status: HIT  ✅ (ou MISS la 1ère fois, puis HIT)
age: 1234  ✅ (nombre en secondes depuis mise en cache)
```

Si tu vois `DYNAMIC` encore = Page Rule non active correctement

---

## 🎯 RÉSULTATS ATTENDUS

| Métrique | Avant | Après |
|----------|-------|-------|
| TTFB | 467ms | <200ms |
| cf-cache-status | DYNAMIC | HIT |
| PageSpeed Mobile | ~50 | 70+ |
| Temps chargement | ~3s | <2s |

---

## 🚨 DÉPANNAGE

### Problème: Cache ne fonctionne pas (toujours DYNAMIC)
**Solution:** 
- Vérifie que l'URL match exactement la Page Rule
- Cloudflare est sensible à www vs non-www
- Ajoute 2 règles: `*www.bijouteriehidous.com/*` ET `*bijouteriehidous.com/*`

### Problème: WordPress cassé après activation
**Solution:**
- Page Rule pour `/wp-admin` et `/wp-login` en "Bypass"
- Désactiver "Always Online" si problème
- Vider le cache Cloudflare + WP Rocket

### Problème: Changements non visibles
**Solution:**
- Purger cache Cloudflare
- Purger cache WP Rocket  
- Désactiver temporairement "Development Mode" dans Cloudflare

---

## 📞 BESOIN D'AIDE ?

Si tu bloques sur une étape, envoie-moi:
1. Capture d'écran de ton interface Cloudflare
2. Le message d'erreur exact
3. L'étape où tu es bloqué

Je te guide ! 🚀
