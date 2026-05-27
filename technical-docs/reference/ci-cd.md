# Référence: CI/CD

## Workflows actifs

- `ci.yml` : CI de développement sur `dev` et PR éligibles.
- `release.yml` : pipeline technique de release sur `release` ou manuel.
- `docs-pages.yml` : publication de la documentation utilisateur sur GitHub Pages.
- `web-docker-cleanup.yml` : nettoyage des images GHCR obsolètes.

## Stratégie de branches

- `dev` : intégration continue.
- `release` : préparation technique de release.
- `main` : référence production.

## Artefacts principaux

- Installeur Windows (`windows-installer`).
- PDF de documentation (`docs-pdf`).
- Image web Docker publiée sur GHCR (`ghcr.io/<owner>/<repo>-web`).

## Variables et versionnement

- Version Flutter lue depuis `.fvmrc`.
- Version applicative lue depuis `belotable/pubspec.yaml`.
- Release stable taggée sous `vX.Y.Z`.
- En flux `release`, bump automatique de `dev` vers `X.Y.(Z+1)-alpha`.

## Conditions importantes

- Les tests (`fvm flutter test --coverage`) sont exécutés avant les builds dans les workflows principaux.
- Le build docs est en mode strict (`mkdocs build --strict`).
- Le pipeline release échoue si le tag distant cible existe déjà.

## Sources (dépôt)

- `.github/workflows/README.md`
- `.github/workflows/ci.yml`
- `.github/workflows/release.yml`
- `.github/workflows/docs-pages.yml`
- `.github/workflows/web-docker-cleanup.yml`
