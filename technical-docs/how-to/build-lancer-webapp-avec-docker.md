# How-to: Lancer la webapp avec Docker

Objectif : construire et exécuter la version web dans un conteneur nginx.

## Prérequis

- poste de développement mis en place (cf [tutorials/00-mise-en-place-poste-dev.md](../tutorials/00-mise-en-place-poste-dev.md))
- Docker Desktop installé et démarré (cf https://docs.docker.com/desktop/setup/install/windows-install/ )
- Commandes lancées depuis la racine du dépôt.

## Procédure rapide avec docker-compose

```bash
docker compose -f build/docker/docker-compose.yml up --build -d
```

Accès à l'application depuis n'importe quel navigateur web sur : http://localhost

Arrêt :

```bash
docker compose -f build/docker/docker-compose.yml down
```

### Surcharge de la version Flutter

La version Flutter de référence est centralisée dans `.fvmrc`.

- Le Dockerfile lit cette valeur.
- Une surcharge ponctuelle est possible avec `FLUTTER_VERSION`.

```bash
# Bash
FLUTTER_VERSION="3.41.0" docker compose -f build/docker/docker-compose.yml up --build -d
```

### Réseau entreprise avec interception TLS

Dans certains environnements d'entreprise, le trafic HTTPS est intercepté (proxy, inspection TLS). Sans le certificat racine interne, le conteneur ne peut pas valider les certificats présentés pour les téléchargements externes (ex: Flutter SDK, dépendances), ce qui provoque des erreurs TLS pendant le build.

Il faut alors fournir le path du certificat via `CA_CERT_PATH`.

```bash
# Bash
CA_CERT_PATH="C:/alice/cacert.pem" docker compose -f build/docker/docker-compose.yml up --build
```

## Démarrage via une image Docker stockée sur GitHub Container Registry

Pour chaque release du projet, une image docker est stockée sur le GitHub Container Registry. Vous pouvez parcourir les releases du projet, choisir la version que vous souhaitez démarrer sur votre poste, copier le path de l'image correspondante et démarrer ainsi :

```bash
docker run --rm -p 80:8080 ghcr.io/estelle-bissay-viseo/belotable-web:<tag>
```

## Sources (dépôt)

- `build/docker/Dockerfile`
- `build/docker/docker-compose.yml`
- `.fvmrc`
