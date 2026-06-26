#!/bin/bash

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}==================================================${NC}"
echo -e "${BLUE}   Initialisation de Documenso      ${NC}"
echo -e "${BLUE}==================================================${NC}"

echo -e "\n${YELLOW}Vérification des certificats de signature...${NC}"

if [ -f "key.pem" ] && [ -f "cert.pem" ] && [ -f "cert.p12" ]; then
    echo -e "${GREEN}Les fichiers cert.pem, key.pem et cert.p12 existent déjà. Passage à l'étape suivante.${NC}"
else
    echo -e "${YELLOW}Certificats manquants. Génération d'un nouveau certificat de test...${NC}"

    openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -sha256 -days 365 -nodes -subj "/CN=Koudmain Dev" && \
    openssl pkcs12 -export -out cert.p12 -inkey key.pem -in cert.pem -passout pass:password

    echo -e "${GREEN}Certificats créés avec succès !${NC}"
fi

echo -e "\n${YELLOW}Reset et injection des données de test...${NC}"

docker exec -it koudmain-documenso npm run prisma:migrate-reset --workspace=@documenso/prisma

echo -e "\n${BLUE}==================================================${NC}"
echo -e "${GREEN}Configuration terminée avec succès !${NC}"
echo -e "${GREEN}L'interface Documenso est disponible sur le port 3010${NC}"
echo -e "${BLUE}==================================================${NC}"