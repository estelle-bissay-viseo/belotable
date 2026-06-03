# Référence: CI/CD

## Workflows actifs

- `ci.yml` : CI de développement sur `dev` et PR éligibles.
- `release.yml` : pipeline technique de release sur `release` ou manuel.
- `_shared-build-scan.yml` : workflow réutilisable appelé par `ci.yml` et `release.yml` pour exécuter jobs techniques communs (Semgrep, test/analyze Flutter, builds, scans Trivy).
- `docs-pages.yml` : publication de la documentation utilisateur sur GitHub Pages.
- `web-docker-cleanup.yml` : nettoyage des images GHCR obsolètes.
- `trivy-update-cache.yml` : scan Trivy planifié et production d'un artefact SBOM.

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
- Rapports Trivy (`trivy-reports`) incluant un fichier SBOM (`*.sbom.json`).

## Variables et versionnement

- Version Flutter lue depuis `.fvmrc`.
- Version applicative lue depuis `belotable/pubspec.yaml`.
- Release stable taggée sous `vX.Y.Z`.
- En flux `release`, bump automatique de `dev` vers `X.Y.(Z+1)-alpha`.

## Factorisation CI/release

Les workflows `ci.yml` et `release.yml` utilisent des jobs techniques communs (analyse de code, tests, builds, scans) qui ont été factorisés dans `_shared-build-scan.yml` pour éviter les redondances et faciliter la maintenance.

Approche :
- `ci.yml` conserve `prepare` + `publish-prerelease`, puis appelle `_shared-build-scan.yml` via un job `quality-build`.
- `release.yml` conserve `prepare` + `publish-release-and-sync`, puis appelle `_shared-build-scan.yml` via un job `quality-build`.
- `_shared-build-scan.yml` contient les jobs communs : `semgrep`, `test`, `build-docker-web`, `build-windows-installer`, `build-docs-pdf`, `scan-with-trivy`.

Garantie fonctionnelle :
- mêmes outils,
- mêmes commandes,
- mêmes quality gates,
- mêmes artefacts,
- même enchaînement logique des validations/builds/scans.

## Scan de sécurité Semgrep

Le workflow partagé `_shared-build-scan.yml` exécute un job `semgrep` (appelé par `ci.yml` et `release.yml`) qui :
- scanne le code avec Semgrep en utilisant les règles de sécurité préintégrées (auto-config, OWASP Top Ten, CWE Top 25, security-audit, TrailOfBits) ;
- produit un rapport JSON (`semgrep.result.json`) publié en artefact ;
- applique un quality gate (`semgrep ci`) qui échoue si des vulnérabilités sont trouvées ;
- le job `test` dépend du succès de `semgrep` pour s'exécuter.

Fichiers de configuration :
- `.semgrepignore` : chemins exclus du scan (dépendances, dossiers de build, docs, etc.).

## Stratégie de qualité et test

Le workflow partagé `_shared-build-scan.yml` exécute un job dédié `test` avant les builds (Docker, Windows), pour :
- Paralléliser les builds tout en garantissant que les tests passent d'abord.
- Exécuter les tests sur runner Windows pour partager le cache avec le build Windows.
- Centraliser la gestion du timeout (**15 minutes max**).
- Exécuter une analyse statique Flutter avant les tests avec annotations GitHub.
- Publier les résultats détaillés de tests (check run + éventuel commentaire PR) via `EnricoMi/publish-unit-test-result-action/windows@v2`.
- Publier le taux de couverture dans le résumé du run Actions (onglet "Summary"), visible aussi bien sur les pushs `dev` que sur les PR et les releases.

Commande d'analyse utilisée :
- `flutter analyze --no-fatal-infos`
- Le rapport est capturé dans `flutter_analyze_report.log`.
- Le code de sortie est propagé et validé par un quality gate (`exit_code != 0` => échec du job).
- Dans `ci.yml` uniquement (paramètre `enable_pr_analyze_comment=true`), un commentaire PR `Flutter Analyze Report` est créé/mis à jour à partir du rapport.

Commande de test utilisée :
- `flutter test --coverage -r github --file-reporter json:tests-report.json`
- `-r github` alimente les annotations GitHub Actions.
- `--file-reporter` produit `tests-report.json`, consommé par l'action de publication des résultats.

Dans `release.yml`, le paramètre `checkout_ref` passé au workflow partagé vaut `release_sha` pour garantir la cohérence avec les builds.

Tous les builds (`build-docker-web`, `build-windows-installer`) du workflow partagé dépendent du succès du job `test` et ne réexécutent pas les tests.

## Scan de sécurité Trivy

Le workflow partagé `_shared-build-scan.yml` exécute un job `scan-with-trivy` (appelé par `ci.yml` et `release.yml`) qui :
- génère des rapports JSON sur le filesystem et l'image Docker ;
- génère un rapport SARIF envoyé dans l'onglet Security GitHub ;
- génère un SBOM (`dependency-results.sbom.json`) envoyé au Dependency Graph ;
- échoue si des vulnérabilités `HIGH` ou `CRITICAL` sont détectées.

Le workflow `trivy-update-cache.yml` exécute aussi un scan planifié et publie un artefact `trivy-reports`.

## Conditions importantes

- Le build docs est en mode strict (`mkdocs build --strict`).
- Le pipeline release échoue si le tag distant cible existe déjà.
- Le rebase suppose une absence de divergence significative entre les branches ; le flux TBD garantit cette stabilité.
- Le job `test` du workflow partagé échoue si l'exécution dépasse 15 minutes, si l'analyse Flutter échoue (quality gate), ou si un test échoue (exit code non-zéro).
- Les workflows `ci.yml` et `release.yml` exigent les permissions GitHub suivantes pour publier les résultats de tests via le workflow partagé : `checks: write`, `issues: write`, `pull-requests: write`.


## Sources (dépôt)

- `.github/workflows/README.md`
- `.github/workflows/ci.yml`
- `.github/workflows/release.yml`
- `.github/workflows/_shared-build-scan.yml`
- `.github/workflows/docs-pages.yml`
- `.github/workflows/web-docker-cleanup.yml`
- `.github/workflows/trivy-update-cache.yml`
- `trivy.yaml`
- `.trivyignore`
- `.semgrepignore`
