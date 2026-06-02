# GitHub Workflows

Documentation des workflows GitHub Actions du projet.

## Stratégie de branches

Le dépôt suit un flux avec 3 branches principales :

- `dev` : intégration continue de développement.
- `release` : branche technique de préparation de release.
- `main` : branche de référence de production.

Cycle attendu :

1. Chaque push sur `dev` exécute la CI et met à jour la pre-release `dev-latest`.
2. Chaque push sur `release` exécute le pipeline technique de release, crée le tag `vX.Y.Z`, publie une release GitHub en brouillon, puis intègre `release` dans `main` et `main` dans `dev` via rebase.

## Vue d'ensemble

La version Flutter est centralisée dans `.fvmrc` (racine du dépôt) et relue dynamiquement dans les workflows.

| Workflow | Déclencheur | Rôle |
|----------|------------|------|
| **Dev CI and Pre-release** (`ci.yml`) | Push `dev` + PR | Analyse statique Semgrep, analyse statique Flutter (annotations + commentaire PR), quality gate, tests, build Docker web, scan Trivy, build Windows, build PDF docs, mise à jour pre-release sur `dev` |
| **Release Technical Pipeline** (`release.yml`) | Push `release` + manuel | Pipeline de release technique : normalisation version, analyse statique Semgrep, analyse statique Flutter (annotations), quality gate, tests, artefacts (Windows + PDF docs + SBOM), scan Trivy, tag, release draft, sync des branches |
| **Trivy scan and Update Trivy cache** (`trivy-update-cache.yml`) | Planifié + manuel | Met à jour le cache DB Trivy quotidiennement et publie un SBOM vers GitHub Dependency Graph |
| **Web Docker Cleanup** (`web-docker-cleanup.yml`) | Planifié + manuel | Nettoyage des versions d'images GHCR obsolètes |
| **Docs - GitHub Pages** (`docs-pages.yml`) | Push `main` ciblé + manuel | Build MkDocs, génération d'un PDF combiné en artefact, puis déploiement de la documentation utilisateur sur GitHub Pages |

---

## Dev CI and Pre-release (`ci.yml`)

### Déclencheurs

- Push sur `dev`
- Pull requests : `opened`, `synchronize`, `reopened`, `ready_for_review`

Filtrage d'exécution :

- Les jobs s'exécutent toujours sur `push`.
- Pour les PR, l'exécution est limitée aux PR non draft dont l'auteur est `OWNER` ou `COLLABORATOR`.

### Concurrence

Groupe : `build-release-${{ github.workflow }}-${{ github.event.pull_request.number || github.ref }}` avec annulation du run précédent en cours.

### Jobs

#### 1. `prepare` (`ubuntu-latest`)

Calcule les outputs partagés :

- `flutter_version` (depuis `.fvmrc`)
- `app_version` (depuis `belotable/pubspec.yaml`)
- `release_tag` (`dev-latest` pour push, `pr-<num>` pour PR)
- `release_title` (`Dev build v<version>` ou `PR <num> - build v<version>`)
- `image_name` (`ghcr.io/<owner>/<repo>-web` en minuscules)

#### 2. `semgrep`

- Checkout de la bonne révision (PR head SHA ou SHA du push)
- Exécution de Semgrep selon la configuration `.semgrep.yml`
- Analyse du code source avec les règles définies en `.semgrepignore` pour exclusions
- Génération de rapports au format JSON et SARIF
- Publication du rapport `semgrep-report.sarif` dans l'onglet Security
- Quality gate : le job échoue si des vulnérabilités sont détectées

#### 3. `test`

- Checkout de la bonne révision (PR head SHA ou SHA du push)
- Setup Flutter
- `flutter pub get`
- Analyse statique :
   - `flutter analyze --no-fatal-infos` avec capture du rapport `flutter_analyze_report.log`
   - stockage du code de sortie de l'analyse dans `steps.flutter_analyze.outputs.exit_code`
- Publication d'annotations GitHub (error/warning/notice) à partir du rapport d'analyse (`flutter_analyze_report.log`)
- Sur PR uniquement : création ou mise à jour d'un commentaire `## Flutter Analyze Report` (tableau par fichier, ligne, sévérité, règle)
- Quality gate : échec explicite du job si `steps.flutter_analyze.outputs.exit_code != '0'`
- Exécution des tests avec couverture et reporter GitHub + export JSON :
   - `flutter test --coverage -r github --file-reporter json:tests-report.json`
- Publication des résultats de tests via `EnricoMi/publish-unit-test-result-action/windows@v2`
- Publication du taux de couverture dans l'onglet Summary

#### 4. `build-docker-web` (`ubuntu-latest`)

- Checkout de la bonne révision (PR head SHA ou SHA du push)
- Setup Flutter
- `flutter pub get`
- Setup Buildx + login GHCR
- Génération de tags Docker (`release_tag`, ref branch/PR, sha, semver, latest default branch)
- Build et push de `build/docker/Dockerfile`

Output principal : `image_digest`.

#### 5. `build-windows-installer` (`windows-latest`)

- Checkout + setup Flutter
- `flutter pub get`
- `flutter build windows --release`
- Installation Inno Setup (`choco install innosetup`)
- Génération installeur via `build/windows-build-innosetup.ps1`
- Upload artefact `windows-installer` (rétention 7 jours)

#### 6. `build-docs-pdf` (`ubuntu-latest`)

- Checkout de la bonne révision (PR head SHA ou SHA du push)
- Setup Python 3.12
- Installation des dépendances docs (`mkdocs`, `mkdocs-material`, `mkdocs-pdf-export-plugin`)
- Build strict de la documentation avec export PDF activé (`ENABLE_PDF_EXPORT=1`)
- Renommage du PDF en `belotable-documentation-v<app_version>.pdf`
- Upload artefact `docs-pdf` (rétention 7 jours)

#### 7. `scan-with-trivy` (`ubuntu-latest`)

- Exécute les scans Trivy filesystem et image Docker avec config `trivy.yaml`
- Évite la mise à jour DB pendant CI (`TRIVY_SKIP_DB_UPDATE=true`, `TRIVY_SKIP_JAVA_DB_UPDATE=true`) car gérée par workflow quotidien
- Génère les artefacts :
   - `trivy-fs-report.json`
   - `trivy-image-report.json`
   - `trivy-fs-report.sarif` (upload dans l'onglet Security)
   - `dependency-results.sbom.json` (SBOM)
- Fait échouer le job si vulnérabilités `HIGH`/`CRITICAL` détectées

#### 8. `publish-prerelease` (`ubuntu-latest`)

Job exécuté uniquement pour les push sur `dev` si tous les jobs précédents ont réussi.

Actions principales :

1. Déplace le tag `dev-latest` sur le commit courant (force push du tag).
2. Télécharge l'artefact Windows.
3. Télécharge l'artefact PDF docs versionné.
4. Télécharge l'artefact `trivy-reports` (incluant le SBOM).
5. Génère des release notes via l'API GitHub (`releases/generate-notes`) en se basant sur le dernier tag `vX.Y.Z` existant.
6. Crée ou met à jour la pre-release GitHub :
   - titre dynamique (`release_title`)
   - notes enrichies avec les métadonnées Docker (image, digest, commande pull)
   - upload des assets `.exe`, `.pdf` et `.sbom.json` (avec `--clobber` si release existante)

Pour les PR : pas de publication de pre-release.

---

## Release Technical Pipeline (`release.yml`)

### Déclencheurs

- Push sur `release`
- `workflow_dispatch`

### Concurrence

Groupe : `release-technical-${{ github.ref }}` avec annulation du run précédent en cours.

### Objectif

Automatiser le cycle technique de release à partir de `release` :

1. Calculer et normaliser la version stable depuis `belotable/pubspec.yaml`.
2. Mettre `release` à la version stable si nécessaire.
3. Exécuter les scans Semgrep et appliquer le quality gate.
4. Exécuter l'analyse statique Flutter, appliquer le quality gate, puis exécuter les tests avec publication des résultats détaillés et de la couverture.
5. Construire et publier l'image Docker web.
6. Exécuter les scans Trivy (filesystem + image) et publier les rapports sécurité.
7. Construire l'installeur Windows.
8. Construire le PDF de documentation.
9. Créer et pousser le tag `vX.Y.Z`.
10. Créer la release GitHub `vX.Y.Z` en brouillon (`draft`) avec artefacts Windows + PDF docs + SBOM et infos Docker.
11. Rebaser `release` dans `main` (intégration linéaire sans merge commit).
12. Rebaser `main` dans `dev` (intégration linéaire sans merge commit).
13. Bumper `belotable/pubspec.yaml` sur `dev` vers la prochaine version `x.y.(z+1)-alpha`.

### Versionnement appliqué

- `current_version` : valeur brute de `pubspec.yaml` (ex: `1.2.3-rc.1+4`)
- `release_version` : base stable extraite (`1.2.3`)
- `release_tag` : `v<release_version>`
- `next_dev_version` : `x.y.(z+1)-alpha`

### Jobs

#### 1. `prepare`

- Lit les variables (Flutter/version)
- Vérifie l'absence du tag distant cible
- Met à jour `belotable/pubspec.yaml` sur la branche `release` vers la version stable
- Commit/push si changement
- Expose `release_sha` pour figer la suite du pipeline

#### 2. `semgrep`

- Exécute Semgrep avec la configuration `.semgrep.yml`
- Analyse du code source avec les règles définies, ignoration des chemins listés dans `.semgrepignore`
- Génération des rapports en JSON et SARIF
- Publication du rapport `semgrep-report.sarif` dans l'onglet Security
- Quality gate : le job échoue si des vulnérabilités sont détectés

#### 3. `test`

- Exécute `flutter analyze --no-fatal-infos` et écrit le rapport `flutter_analyze_report.log`
- Parse le rapport et publie des annotations GitHub (`error` / `warning` / `notice`)
- Applique un quality gate : le job échoue si `steps.flutter_analyze.outputs.exit_code != '0'`
- Exécute `flutter test --coverage -r github --file-reporter json:tests-report.json`
- Publie les résultats de tests via `EnricoMi/publish-unit-test-result-action/windows@v2`
- Publie la couverture dans l'onglet Summary

#### 4. `build-docker-web`

- Build sur `release_sha`
- Push GHCR avec tags : `vX.Y.Z`, `release`, `ref branch`, `sha-*`
- Expose `image_digest`

#### 5. `build-windows-installer`

- Build Windows sur `release_sha`
- Produit l'artefact `windows-installer`

#### 6. `scan-with-trivy`

- Exécute les scans Trivy filesystem et image Docker avec config `trivy.yaml`
- Publie `trivy-fs-report.sarif` dans l'onglet Security
- Génère et publie `dependency-results.sbom.json` dans `trivy-reports`
- Fait échouer le pipeline si vulnérabilités `HIGH`/`CRITICAL`

#### 7. `build-docs-pdf`

- Build docs sur `release_sha`
- Génère le PDF via MkDocs
- Renomme le PDF en `belotable-documentation-v<release_version>.pdf`
- Produit l'artefact `docs-pdf`

#### 8. `publish-release-and-sync`

- Crée et pousse le tag annoté `vX.Y.Z`
- Génère les release notes automatiques
- Télécharge les artefacts Windows et PDF docs
- Télécharge l'artefact `trivy-reports` pour inclure le SBOM
- Crée une release GitHub en brouillon (`--draft`) marquée latest (`--latest`) avec les assets `.exe`, `.pdf` et `.sbom.json`
- Rebases `release` dans `main` via rebase linéaire (pas de merge commit)
- Rebases `main` dans `dev` via rebase linéaire (pas de merge commit)
- Met à jour `belotable/pubspec.yaml` sur `dev` vers `next_dev_version`, commit/push si changement

### Points d'attention

- Les branches `release`, `main` et `dev` doivent exister.
- Les conflits de rebase font échouer le workflow (pas de résolution implicite).
- Si le tag `vX.Y.Z` existe déjà sur le remote, le workflow échoue.
- Le rebase suppose une absence de divergence significative entre les branches ; le flux TBD garantit cette stabilité.

---

## Trivy scan and Update Trivy cache (`trivy-update-cache.yml`)

### Déclencheurs

- Planifié : tous les jours à 02:00 UTC
- Manuel : `workflow_dispatch`

### Objectif

Précharger base Trivy quotidiennement pour réduire le temps des scans CI/release, et publier un SBOM vers GitHub Dependency Graph.

### Job

#### 1. `update-trivy-db` (`ubuntu-latest`)

- Setup `oras` (pré-requis cache Trivy)
- Exécution Trivy en mode `github` pour générer `dependency-results.sbom.json`
- Upload artefact `trivy-reports` (rétention 7 jours)
- Scan filesystem avec config `trivy.yaml`

---

## Web Docker Cleanup (`web-docker-cleanup.yml`)

### Déclencheurs

- Planifié : tous les mardis à 10:00 UTC
- Manuel : `workflow_dispatch`

### Permissions

- `contents: read`
- `packages: write`
- `pull-requests: read`

### Objectif

Nettoyer automatiquement les versions obsolètes du package GHCR `<repo>-web`, pour les owners de type utilisateur ou organisation.

### Versions conservées systématiquement

- Versions taggées avec la branche par défaut ou `latest`
- Versions avec tag SemVer (`v` optionnel, prerelease/build metadata acceptés)
- Dernière version de chaque PR encore ouverte
- Dernière version de chaque branche existante (hors branche par défaut)

### Règles de suppression

Une version non protégée est supprimée si au moins une raison de cleanup est vraie :

- `pr_closed`
- `not_latest_open_pr`
- `branch_missing:<nom>`
- `not_latest_existing_branch`
- `older_than_7_days`

### Résumé d'exécution

Le workflow publie un résumé avec :

- Package ciblé
- Branche par défaut détectée
- Nombre de versions conservées par catégorie
- Nombre de versions supprimées

---

## Docs - GitHub Pages (`docs-pages.yml`)

### Déclencheurs

- Push sur `main` uniquement si des fichiers de documentation changent :
   - `user-docs/**`
   - `.github/workflows/docs-pages.yml`
- Manuel : `workflow_dispatch`

### Permissions

- `contents: read`
- `pages: write`
- `id-token: write`

### Concurrence

Groupe : `docs-pages` avec annulation du run précédent en cours.

### Objectif

Publier automatiquement la documentation utilisateur statique (MkDocs) sur GitHub Pages.

### Jobs

#### 1. `build` (`ubuntu-latest`)

- Checkout du dépôt
- Setup Python 3.12
- Installation des dépendances docs (`mkdocs`, `mkdocs-material`, `mkdocs-pdf-export-plugin`)
- Build strict de la doc (`mkdocs build --strict --config-file user-docs/mkdocs.yml`) avec activation de l'export PDF en CI (`ENABLE_PDF_EXPORT=1`)
- Upload de l'artefact PDF (`docs-pdf`, fichier `user-docs/site/pdf/belotable-documentation.pdf`)
- Upload de l'artefact Pages (dossier `user-docs/site`)

#### 2. `deploy` (`ubuntu-latest`)

- Déploiement de l'artefact via `actions/deploy-pages@v4`
- Publication dans l'environnement GitHub Pages (`github-pages`)

### Points d'attention

- Dans les paramètres du dépôt, la source GitHub Pages doit être `GitHub Actions`.
- Le build strict échoue en cas d'erreur de doc (liens cassés, références invalides, etc.).

---

## Ressources

- https://docs.github.com/en/actions/using-workflows
- https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry
