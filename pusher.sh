#!/bin/bash

# Script de publication pour mawena/maravel-xy
# Usage: ./pusher.sh <version> <message>
# Exemple: ./pusher.sh 1.1.0 "Tables frontend + formulaires dynamiques"

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Vérifier les arguments
if [ $# -lt 2 ]; then
    echo -e "${RED}❌ Usage: ./pusher.sh <version> <message>${NC}"
    echo -e "${YELLOW}Exemple: ./pusher.sh 1.1.0 \"Tables frontend + formulaires dynamiques\"${NC}"
    exit 1
fi

VERSION=$1
MESSAGE=$2

# Vérifier le format de la version (doit être x.y.z)
if ! [[ $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo -e "${RED}❌ Format de version invalide. Utilisez le format x.y.z (ex: 1.1.0)${NC}"
    exit 1
fi

echo -e "${GREEN}🚀 Publication de la version v${VERSION}${NC}"
echo ""

# Vérifier qu'on est dans un dépôt Git
if [ ! -d .git ]; then
    echo -e "${RED}❌ Erreur: Pas un dépôt Git${NC}"
    exit 1
fi

# Vérifier que le tag n'existe pas déjà (évite de pousser des commits pour rien)
if git rev-parse "v${VERSION}" >/dev/null 2>&1; then
    echo -e "${RED}❌ Le tag v${VERSION} existe déjà${NC}"
    exit 1
fi

# Rappel : le CHANGELOG doit mentionner la version publiée
if [ -f CHANGELOG.md ] && ! grep -q "\[${VERSION}\]" CHANGELOG.md; then
    echo -e "${YELLOW}⚠️  CHANGELOG.md ne contient pas d'entrée pour la version ${VERSION}${NC}"
    echo -e "${YELLOW}   Pensez à l'ajouter avant de publier.${NC}"
    echo ""
fi

# Vérifier qu'il n'y a pas de modifications non commitées
if [[ -n $(git status -s) ]]; then
    echo -e "${YELLOW}⚠️  Modifications non commitées détectées${NC}"
    echo -e "${YELLOW}📦 Ajout et commit des modifications...${NC}"

    # Ajouter tous les fichiers
    git add .

    # Commit
    git commit -m "$MESSAGE"

    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Échec du commit${NC}"
        exit 1
    fi

    echo -e "${GREEN}✅ Modifications commitées${NC}"
fi

# Pousser les modifications
echo -e "${YELLOW}📤 Push des modifications vers origin...${NC}"
git push

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Échec du push${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Modifications poussées${NC}"

# Créer le tag
echo -e "${YELLOW}🏷️  Création du tag v${VERSION}...${NC}"
git tag -a "v${VERSION}" -m "$MESSAGE"

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Échec de la création du tag${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Tag v${VERSION} créé${NC}"

# Pousser le tag
echo -e "${YELLOW}📤 Push du tag vers origin...${NC}"
git push origin "v${VERSION}"

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Échec du push du tag${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✅ Version v${VERSION} publiée avec succès!${NC}"
echo ""
echo -e "${YELLOW}📋 Prochaines étapes:${NC}"
echo "   1. Vérifiez sur GitHub que le tag est bien présent"
echo "   2. Si vous avez configuré le webhook Packagist, la mise à jour sera automatique"
echo "   3. Sinon, connectez-vous sur Packagist.org et cliquez sur 'Update' dans votre package"
echo ""
echo -e "${GREEN}🎉 Votre template peut maintenant être utilisé avec:${NC}"
echo -e "${YELLOW}   composer create-project mawena/maravel-xy mon-projet${NC}"
echo ""
