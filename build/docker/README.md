# Docker – Belotable webapp

Ce répertoire contient tout le nécessaire pour construire et exécuter la webapp Belotable dans un conteneur Docker.

## Fichiers

| Fichier | Rôle |
|---|---|
| `Dockerfile` | Build multi-stage : compile Flutter web puis crée une image finale servie par nginx |
| `nginx.conf` | Configuration nginx : SPA routing, compression gzip, headers de cache |
| `docker-compose.yml` | Orchestration du service web pour un usage local |
| `../../.dockerignore` | Exclut les fichiers inutiles du contexte de build (à la racine du projet) |

## Pré-requis

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installé et démarré

## Utilisation

Toutes les commandes se lancent **depuis la racine du projet**.

### Version Flutter (source unique)

Le projet centralise la version Flutter dans le fichier `.fvmrc` à la racine du dépôt.

- CI GitHub Actions lit cette valeur automatiquement.
- Docker Compose utilise par défaut la valeur de `.fvmrc` (via fallback dans le Dockerfile).
- Vous pouvez surcharger ponctuellement avec la variable d'environnement `FLUTTER_VERSION`.

Surcharge optionnelle :

```bash
export FLUTTER_VERSION="$(sed -nE 's/.*"flutter"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/p' .fvmrc | head -n1)"
```

```powershell
$env:FLUTTER_VERSION = (Get-Content .fvmrc -Raw | ConvertFrom-Json).flutter
```

### Démarrer l'application

```bash
docker compose -f build/docker/docker-compose.yml up --build -d
```

L'application est accessible sur [http://localhost](http://localhost).

### Stopper l'application

```bash
docker compose -f build/docker/docker-compose.yml down
```

### Certificat PEM d'entreprise (proxy/inspection TLS)

#### Pourquoi

Dans certains environnements d'entreprise, le trafic HTTPS est intercepté (proxy, inspection TLS). Sans le certificat racine interne, le conteneur ne peut pas valider les certificats présentés pour les téléchargements externes (ex: Flutter SDK, dépendances), ce qui provoque des erreurs TLS pendant le build.

#### Obligatoire ou non

- **Obligatoire** si votre réseau d'entreprise intercepte le HTTPS ou impose une autorité de certification interne.
- **Non obligatoire** si vous êtes sur un réseau standard (pas d'inspection TLS) et que les builds Docker fonctionnent déjà sans erreur de certificat.

Le projet est configuré pour que ce certificat soit **optionnel** : le secret `ca_cert` est monté seulement si `CA_CERT_PATH` est fourni.

#### Comment l'appliquer

1. Récupérer le fichier PEM/CRT de l'entreprise (ex: `cacert.pem`).
2. Définir la variable d'environnement `CA_CERT_PATH` avec le chemin du fichier.
3. Lancer le build/compose normalement.

Exemples :

```bash
# Bash (Git Bash)
CA_CERT_PATH="C:/alice/cacert.pem" docker compose -f build/docker/docker-compose.yml up --build
```

```powershell
# PowerShell
$env:CA_CERT_PATH = "C:\alice\cacert.pem"
docker compose -f build/docker/docker-compose.yml up --build
```

Si `CA_CERT_PATH` n'est pas défini, Docker Compose utilise le fichier neutre versionné `build/docker/empty-ca-cert.pem` et le build continue sans certificat d'entreprise.

### Build de l'image seule (sans docker-compose)

```bash
docker build \
	--build-arg FLUTTER_VERSION="$(sed -nE 's/.*"flutter"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/p' .fvmrc | head -n1)" \
	-f build/docker/Dockerfile \
	-t belotable .
docker run -p 80:80 belotable
```

## Image prête à lancer générée par GitHub Actions

Le workflow GitHub Actions `.github/workflows/ci.yml` construit l'image Docker de la webapp et la publie automatiquement sur **GHCR** (GitHub Container Registry).

Vous pouvez récupérer les identifiants de l'image dans les releases du projet sur github.com.

Exemple pour lancer l'image publiée :

```bash
docker run --rm -p 80:80 ghcr.io/<owner>/<repo>-web:latest
```

Si l'image est privée, se connecter avant le pull :

```bash
echo <GITHUB_TOKEN> | docker login ghcr.io -u <github_user> --password-stdin
```

## Fonctionnement du Dockerfile

Le build repose sur deux stages afin de minimiser la taille de l'image finale :

1. **Stage `builder`** (`debian:bookworm-slim`) : télécharge Flutter, installe les dépendances Dart et compile l'application en fichiers web statiques (`flutter build web --release`).
2. **Stage `runtime`** (`nginx:alpine`) : copie uniquement les fichiers statiques générés et les sert via nginx. La chaîne Flutter (~1 GB) n'est pas incluse dans l'image finale.

**Taille indicative de l'image finale : ~25 MB.**

## Paramétrage

La version Flutter utilisée lors du build est fournie via la variable d'environnement `FLUTTER_VERSION`, généralement chargée depuis `.fvmrc`.

Sans variable d'environnement, le Dockerfile lit automatiquement `.fvmrc`.

Pour changer de version :

```text
1) Mettre à jour .fvmrc
2) Relancer le build Docker

Surcharge ponctuelle possible : définir `FLUTTER_VERSION` avant le build.
```
