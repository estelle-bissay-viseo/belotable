# How-to: Analyser le code et l'image Docker avec Trivy

Objectif : exécuter localement les scans de sécurité alignés avec la CI.

## Interet

- Détecter tôt des vulnérabilités et mauvaises configurations avant push.
- Reproduire localement la politique CI (seuil `HIGH` et `CRITICAL`).
- Vérifier le contenu de l'image Docker publiée avec les mêmes règles que le pipeline.

## Usage local

### Prérequis

- Trivy installé (cf [tutorials/00-mise-en-place-poste-dev.md](../tutorials/00-mise-en-place-poste-dev.md)).
- Commandes lancées depuis la racine du dépôt.
- Pour le scan image : image locale construite (`belotable-web:latest` ou tag équivalent).

### 1. Scanner le filesystem du dépôt

```bash
trivy fs --config trivy.yaml .
```

Ce scan utilise la configuration versionnée :
- `trivy.yaml` (scanners, sévérités, seuil d'échec, timeout)
- `.trivyignore` (exceptions documentées)

### 2. Construire puis scanner l'image Docker

Construire l'image :

```bash
docker compose -f build/docker/docker-compose.yml build
```

Scanner l'image :

```bash
trivy image --config trivy.yaml belotable-web:latest
```

### Vérification attendue

- Sortie Trivy sans vulnérabilité `HIGH`/`CRITICAL` non ignorée.
- Si des vulnérabilités `HIGH`/`CRITICAL` sont trouvées, la commande retourne un code de sortie non nul (`exit-code: 1` dans `trivy.yaml`).

### Dépannage

- Erreur `image ... not found`: reconstruire l'image locale puis relancer `trivy image`.
- Faux positif confirmé: ajouter l'identifiant CVE dans `.trivyignore` avec justification interne.

## Sources (dépôt)

- `trivy.yaml`
- `.trivyignore`
- `.github/workflows/ci.yml`
- `.github/workflows/release.yml`
- `.github/workflows/trivy-update-cache.yml`
- `build/docker/docker-compose.yml`