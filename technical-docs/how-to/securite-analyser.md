# How-to: Analyser la sécurité du code avec Trivy et Semgrep

Objectif : exécuter localement les scans de sécurité alignés avec la CI.

## Intérêt

- Détecter tôt des vulnérabilités et mauvaises configurations avant push.
- Reproduire localement la politique CI.
- Vérifier le contenu de l'image Docker publiée avec les mêmes règles que le pipeline.

## Prérequis

- Trivy et Semgrep installés (cf [tutorials/00-mise-en-place-poste-dev.md](../tutorials/00-mise-en-place-poste-dev.md)).
- Commandes lancées depuis la racine du dépôt.
- Pour le scan image : image locale construite (`belotable-web:latest` ou tag équivalent).

## Trivy

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

- Si des vulnérabilités `HIGH`/`CRITICAL` sont trouvées, la commande retourne un code de sortie non nul (`exit-code: 1` dans `trivy.yaml`).
- Si des vulnérabilités sont trouvées, il faut les corriger (ou documenter les exceptions dans `.trivyignore` avec justification interne) puis relancer le scan.

### Dépannage

- Erreur `image ... not found`: reconstruire l'image locale puis relancer `trivy image`.
- Faux positif confirmé: ajouter l'identifiant CVE dans `.trivyignore` avec justification interne.

## Semgrep

### 1. Scanner les fichiers

```bash
semgrep scan --config=auto --config=p/owasp-top-ten  --config=p/cwe-top-25  --config=p/security-audit --config=p/trailofbits --json-output=semgrep.result.json --strict
```

### Vérification attendue

- Si des vulnérabilités plus hautes que `info` sont trouvées, la commande retourne un code de sortie non nul.
- Si des vulnérabilités sont trouvées, il faut les corriger puis relancer le scan.

## Sources (dépôt)

- `trivy.yaml`
- `.trivyignore`
- `.github/workflows/ci.yml`
- `.github/workflows/release.yml`
- `.github/workflows/trivy-update-cache.yml`
- `build/docker/docker-compose.yml`
- `.semgrep.yml`
- `.semgrepignore`