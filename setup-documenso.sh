#!/bin/bash

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}==================================================${NC}"
echo -e "${BLUE}   Initialisation de Documenso      ${NC}"
echo -e "${BLUE}==================================================${NC}"

echo -e "\n${YELLOW}Reset et injection des données de test...${NC}"

docker exec -it koudmain-documenso npm run prisma:migrate-reset --workspace=@documenso/prisma

echo -e "\n${BLUE}==================================================${NC}"
echo -e "${GREEN}Configuration terminée avec succès !${NC}"
echo -e "${GREEN}L'interface Documenso est disponible sur le port 3010 de votre machine${NC}"
echo -e "${BLUE}==================================================${NC}"