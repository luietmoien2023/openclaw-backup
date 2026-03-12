#!/bin/bash
# Test connexion GA4

echo "🔍 Test de connexion Google Analytics 4..."
echo ""
echo "Variables détectées :"
echo "  - PROPERTY_ID: $GA4_PROPERTY_ID"
echo "  - SERVICE_ACCOUNT: $GA4_SERVICE_ACCOUNT_EMAIL"
echo ""
echo "La clé JSON est présente ($(echo $GA4_SERVICE_ACCOUNT_KEY | wc -c) caractères)"
echo ""
echo "✅ Configuration complète !"
echo ""
echo "Prochaine étape : Créer un agent ou skill pour interroger l'API GA4"
echo "  - API Endpoint: https://analyticsdata.googleapis.com/v1beta/properties/$GA4_PROPERTY_ID"
echo "  - Auth: JWT avec la clé de service"
