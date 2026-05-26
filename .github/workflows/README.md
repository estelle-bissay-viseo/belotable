# GitHub Workflows

Documentation des workflows GitHub Actions du projet.

## Stratégie de branches

Le dépôt suit un flux avec 3 branches principales :

- `dev` : intégration continue de développement.
- `release` : branche technique de préparation de release.
- `main` : branche de référence de production.

Cycle attendu :

1. Chaque push sur `dev` exécute la CI et met à jour la pre-release `dev-latest`.
2. Chaque push sur `release` exécute le pipeline technique de release, crée le tag `vX.Y.Z`, publie une release GitHub en brouillon, puis synchronise `main` et `dev`.

## Vue d'ensemble

La version Flutter est centralisée dans `.fvmrc` (racine du dépôt) et relue dynamiquement dans les workflows.

| Workflow | Déclencheur | Rôle |
|----------|------------|------|
| **Dev CI and Pre-release** (`ci.yml`) | Push `dev` + PR | Tests + build Docker web + build Windows + mise à jour pre-release sur `dev` |
| **Release Technical Pipeline** (`release.yml`) | Push `release` + manuel | Pipeline de release technique : normalisation version, artefacts, tag, release draft, sync des branches |
| **Web Docker Cleanup** (`web-docker-cleanup.yml`) | Planifié + manuel | Nettoyage des versions d'images GHCR obsolètes |

---

## Dev CI and Pre-release (`ci.yml`)

### Déclencheurs

- Push sur `dev`
- Pull requests : `opened`, `synchronize`, `reopened`, `ready_for_review`

Filtrage d'exécution :

- Les jobs s'exécutent toujours sur `push`.
- Pour les PR, l'exécution est limitée aux PR non draft dont l'auteur est `OWNER` ou `COLLABORATOR`.

### Permissions

- `contents: write`
- `packages: write`

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

#### 2. `build-docker-web` (`ubuntu-latest`)

- Checkout de la bonne révision (PR head SHA ou SHA du push)
- Setup Flutter
- `flutter pub get` + `flutter test --coverage` (dans `belotable/`)
- Setup Buildx + login GHCR
- Génération de tags Docker (`release_tag`, ref branch/PR, sha, semver, latest default branch)
- Build et push de `build/docker/Dockerfile`

Output principal : `image_digest`.

#### 3. `build-windows-installer` (`windows-latest`)

- Checkout + setup Flutter
- `flutter pub get` + `flutter test --coverage`
- `flutter build windows --release`
- Installation Inno Setup (`choco install innosetup`)
- Génération installeur via `build/windows-build-innosetup.ps1`
- Upload artefact `windows-installer` (rétention 7 jours)

#### 4. `publish-prerelease` (`ubuntu-latest`)

Job exécuté uniquement pour les push sur `dev` si tous les jobs précédents ont réussi.

Actions principales :

1. Déplace le tag `dev-latest` sur le commit courant (force push du tag).
2. Télécharge l'artefact Windows.
3. Génère des release notes via l'API GitHub (`releases/generate-notes`) en se basant sur le dernier tag `vX.Y.Z` existant.
4. Crée ou met à jour la pre-release GitHub :
   - titre dynamique (`release_title`)
   - notes enrichies avec les métadonnées Docker (image, digest, commande pull)
   - upload de l'installeur `.exe` (avec `--clobber` si release existante)

Pour les PR : pas de publication de pre-release.

---

## Release Technical Pipeline (`release.yml`)

### Déclencheurs

- Push sur `release`
- `workflow_dispatch`

### Permissions

- `contents: write`
- `packages: write`

### Concurrence

Groupe : `release-technical-${{ github.ref }}` avec annulation du run précédent en cours.

### Objectif

Automatiser le cycle technique de release à partir de `release` :

1. Calculer et normaliser la version stable depuis `belotable/pubspec.yaml`.
2. Mettre `release` à la version stable si nécessaire.
3. Construire et publier l'image Docker web.
4. Construire l'installeur Windows.
5. Créer et pousser le tag `vX.Y.Z`.
6. Créer la release GitHub `vX.Y.Z` en brouillon (`draft`) avec artefact Windows et infos Docker.
7. Merger `release` dans `main`.
8. Merger `main` dans `dev`.
9. Bumper `belotable/pubspec.yaml` sur `dev` vers la prochaine version `x.y.(z+1)-alpha`.

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

#### 2. `build-docker-web`

- Build sur `release_sha`
- Push GHCR avec tags : `vX.Y.Z`, `release`, `ref branch`, `sha-*`
- Expose `image_digest`

#### 3. `build-windows-installer`

- Build Windows sur `release_sha`
- Produit l'artefact `windows-installer`

#### 4. `publish-release-and-sync`

- Crée et pousse le tag annoté `vX.Y.Z`
- Génère les release notes automatiques
- Crée une release GitHub en brouillon (`--draft`) marquée latest (`--latest`)
- Merge `release_sha` dans `main`, push `main`
- Merge `main` dans `dev`
- Met à jour `belotable/pubspec.yaml` sur `dev` vers `next_dev_version`, commit/push si changement

### Points d'attention

- Les branches `release`, `main` et `dev` doivent exister.
- Les conflits de merge font échouer le workflow (pas de résolution implicite).
- Si le tag `vX.Y.Z` existe déjà sur le remote, le workflow échoue.

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

## Ressources

- https://docs.github.com/en/actions/using-workflows
- https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry
