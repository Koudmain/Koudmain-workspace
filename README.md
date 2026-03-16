# Koudmain-workspace

Ce dépôt contient la configuration globale et Docker Compose pour le projet Koudmain.

## Configuration initiale

<span style="color:red">**Attention : Avant de lancer les commandes Docker, vous devez impérativement créer un fichier `.env` à la racine du projet (vous pouvez le copier depuis `.env.example`).**</span>

Il est nécessaire de modifier les variables suivantes dans votre fichier `.env` pour indiquer les chemins absolus vers les différents dépôts sur votre machine locale :
- `BACKEND_PATH_FOLDER` : Chemin vers le dépôt du backend.
- `BACKEND_PATH_INIT_DB_FILE` : Chemin vers le fichier d'initialisation de la DB (probablement `{BACKEND_PATH_FOLDER}/db/koudmain-db.sql`).
- `WEB_PATH_FOLDER` : Chemin vers le dépôt du frontend web.
- `MOBILE_WORKER_PATH_FOLDER` : Chemin vers le dépôt de l'application mobile worker.
- `MOBILE_CLIENT_PATH_FOLDER` : Chemin vers le dépôt de l'application mobile client.

## Utilisation de Docker (Makefile)

Un `Makefile` est mis à disposition pour simplifier le lancement et la gestion des différents services Docker.
L'utilisation de ces commandes est fortement recommandée pour garantir que les variables d'environnement (comme l'adresse IP locale pour le développement mobile) soient correctement passées aux conteneurs.

### Commandes disponibles

#### Lancement spécifique :
- `make backend` : Lance **uniquement le backend** (et la base de données PostgreSQL associée).
- `make web`     : Lance le **frontend web** ainsi que ses dépendances (backend & DB).
- `make mobile`  : Lance les **applications mobiles** (worker et client) ainsi que leurs dépendances (backend & DB). *Note : Cette commande se charge de récupérer automatiquement l'adresse IP locale de votre machine (nécessaire pour Expo) et de la transmettre aux conteneurs mobiles.*

#### Commandes générales :
- `make up`           : Lance **l'ensemble des services** en arrière-plan.
- `make down`         : Arrête et supprime tous les conteneurs liés au projet.
- `make build`        : Construit ou reconstruit l'ensemble des images Docker de tous les services.
- `make logs`         : Affiche en temps réel les journaux (logs) de tous les conteneurs.
- `make logs-worker`  : Affiche en temps réel les journaux du conteneur mobile-worker.
- `make logs-client`  : Affiche en temps réel les journaux du conteneur mobile-client.
- `make logs-backend` : Affiche en temps réel les journaux du conteneur backend.
- `make logs-web`     : Affiche en temps réel les journaux du conteneur frontend (web).
- `make help`         : Affiche un résumé de ces commandes directement dans le terminal (ou simplement `make`).