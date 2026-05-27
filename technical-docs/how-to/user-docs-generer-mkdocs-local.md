# How-to: Générer la documentation MkDocs en local

Objectif : construire localement la documentation utilisateur avec les mêmes règles strictes que la CI.

## Prérequis

- poste de développement mis en place (cf [tutorials/00-mise-en-place-poste-dev.md](../tutorials/00-mise-en-place-poste-dev.md))

## Build strict

```bash
mkdocs build --strict --config-file user-docs/mkdocs.yml
```

## Activer l'export PDF

```bash
ENABLE_PDF_EXPORT=1 mkdocs build --strict --config-file user-docs/mkdocs.yml
```

## Résultats attendus

- Site statique généré dans `user-docs/site/`.
- PDF généré dans `user-docs/site/pdf/` (si export activé).

## Sources (dépôt)

- `.github/workflows/docs-pages.yml`
- `.github/workflows/ci.yml`
- `.github/workflows/release.yml`
- `user-docs/mkdocs.yml`
