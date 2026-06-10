<!-- tags: documentation-utilisateur -->
# How-to: Mettre à jour la documentation utilisateur avec MkDocs

Objectif : modifier la documentation utilisateur dans `user-docs/` et vérifier le rendu localement en direct avec `mkdocs serve`.

## Prérequis

- poste de développement mis en place (cf [tutorials/00-mise-en-place-poste-dev.md](../tutorials/00-mise-en-place-poste-dev.md))
- commandes lancées depuis la racine du dépôt

## Procédure

### 1. Modifier le contenu utilisateur

- Éditer les pages Markdown dans `user-docs/docs/`.
- Si vous ajoutez une nouvelle page, l'ajouter aussi dans la section `nav` de `user-docs/mkdocs.yml`.

### 2. Prévisualiser en local avec mkdocs serve

```bash
mkdocs serve --config-file user-docs/mkdocs.yml
```

- Ouvrir ensuite l'URL affichée dans le terminal (par défaut : http://127.0.0.1:8000).
- Vérifier la navigation, les liens internes, la recherche et le rendu mobile/desktop.

Vous pouvez continuer l'édition du contenu des pages en gardant le serve actif, le contenu modifié sera rechargé en direct.

### 3. Valider un build strict avant commit

```bash
mkdocs build --strict --config-file user-docs/mkdocs.yml
```

## Résultats attendus

- Les changements sont visibles localement via `mkdocs serve`.
- Le build strict passe sans avertissement bloquant.
- Le site statique est régénéré dans `user-docs/site/`.
