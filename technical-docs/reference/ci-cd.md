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

## Intégration via rebase

Les mise à jour des branches après une release utilisent **rebase** plutôt que merge :
- `release` est rebased dans `main`.
- `main` est rebased dans `dev`.

Cette approche conserve un historique Git linéaire, sans merge commits, tout en maintenant la traçabilité des changements.

## Artefacts principaux

- Installeur Windows (`windows-installer`).
- PDF de documentation (`docs-pdf`).
- Image web Docker publiée sur GHCR (`ghcr.io/<owner>/<repo>-web`).

## Variables et versionnement

- Version Flutter lue depuis `.fvmrc`.
- Version applicative lue depuis `belotable/pubspec.yaml`.
- Release stable taggée sous `vX.Y.Z`.
- En flux `release`, bump automatique de `dev` vers `X.Y.(Z+1)-alpha`.

## Stratégie de test

Un job dédié `test` exécute l'intégralité de la suite de tests avant les builds (Docker, Windows), dans les deux workflows `ci.yml` et `release.yml`, pour :
- Paralléliser les builds tout en garantissant que les tests passent d'abord.
- Centraliser la gestion du timeout (**15 minutes max**).
- Publier les résultats détaillés de tests (check run + éventuel commentaire PR) via `EnricoMi/publish-unit-test-result-action@v2`.
- Publier le taux de couverture dans le résumé du run Actions (onglet "Summary"), visible aussi bien sur les pushs `dev` que sur les PR et les releases.

Commande de test utilisée :
- `flutter test --coverage -r github --file-reporter json:tests-report.json`
- `-r github` alimente les annotations GitHub Actions.
- `--file-reporter` produit `tests-report.json`, consommé par l'action de publication des résultats.

Dans `release.yml`, le checkout du job `test` utilise le SHA du commit de release (`release_sha`) pour garantir la cohérence avec les builds.

Tous les builds (`build-docker-web`, `build-windows-installer`) dépendent du succès du job `test` et ne réexécutent pas les tests.

## Conditions importantes

- Le build docs est en mode strict (`mkdocs build --strict`).
- Le pipeline release échoue si le tag distant cible existe déjà.
- Le rebase suppose une absence de divergence significative entre les branches ; le flux TBD garantit cette stabilité.
- Le job `test` échoue si l'exécution dépasse 15 minutes ou si un test échoue (exit code non-zéro).
- Les workflows `ci.yml` et `release.yml` exigent les permissions GitHub suivantes pour publier les résultats de tests : `checks: write`, `issues: write`, `pull-requests: write`.


## Sources (dépôt)

- `.github/workflows/README.md`
- `.github/workflows/ci.yml`
- `.github/workflows/release.yml`
- `.github/workflows/docs-pages.yml`
- `.github/workflows/web-docker-cleanup.yml`
