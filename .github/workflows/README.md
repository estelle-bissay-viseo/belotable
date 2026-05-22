# GitHub Workflows

Documentation des workflows GitHub Actions implémentés pour ce projet.

## Vue d'ensemble

La version Flutter est centralisée dans le fichier `.fvmrc` (racine du dépôt). Les workflows la lisent dynamiquement avant `subosito/flutter-action`.

| Workflow | Déclencheur | Rôle |
|----------|------------|------|
| **Build and Release** (`ci.yml`) | Push `dev` / PR | Build web (Docker) + Windows (Inno Setup) + publication de la release GitHub |
| **Web Docker Cleanup** (`web-docker-cleanup.yml`) | Planifié (mardi 10h UTC) | Nettoyage automatique des images obsolètes dans GHCR |

---

## Build and Release (`ci.yml`)

### Déclencheurs

- **Push** sur la branche : `dev`
- **Pull requests** : `opened`, `synchronize`, `reopened`, `ready_for_review`

> Les PR de contributeurs non `OWNER` ou `COLLABORATOR` sont ignorées (condition sur `author_association`).

### Concurrence

Un groupe de concurrence `build-release-*` annule le run précédent en cours pour la même PR ou branche.

### Jobs

#### 1. `prepare` — Variables partagées (`ubuntu-latest`)

Calcule les valeurs réutilisées par tous les jobs suivants :

| Output | Valeur |
|--------|--------|
| `flutter_version` | Lu depuis `.fvmrc` |
| `app_version` | Lu depuis `belotable/pubspec.yaml` |
| `release_tag` | `dev-latest` (push) ou `pr-<num>` (PR) |
| `release_title` | `Dev build v<version>` ou `PR <num> - build v<version>` |
| `image_name` | `ghcr.io/<owner>/<repo>-web` (en minuscules) |

#### 2. `build-docker-web` — Image Docker web (`ubuntu-latest`)

1. **Checkout** du code à la ref correcte (HEAD de la PR ou commit du push)
2. **Setup Flutter** (version issue de `.fvmrc`, channel stable, cache activé)
3. **Installation des dépendances** : `flutter pub get` dans `belotable/`
4. **Exécution des tests** : `flutter test --coverage`
5. **Setup Docker Buildx** pour le build multi-plateforme
6. **Authentification GHCR** avec `GITHUB_TOKEN`
7. **Extraction des métadonnées** et génération des tags :
   - `dev-latest` ou `pr-<num>` (valeur de `release_tag`)
   - `type=ref,event=branch` → tag de branche (ex: `dev`)
   - `type=ref,event=pr` → tag PR (ex: `pr-42`)
   - `type=sha,prefix=sha-` → tag du commit (ex: `sha-abc123`)
   - `type=semver,pattern={{version}}` → tag SemVer si applicable
   - `latest` si branche par défaut
8. **Build et push** vers GHCR avec `FLUTTER_VERSION` en build-arg, cache GHA activé

**Output** : `image_digest` (digest de l'image poussée, transmis au job `publish-release`)

#### 3. `build-windows-installer` — Installeur Windows (`windows-latest`)

1. **Checkout** du code à la ref correcte
2. **Setup Flutter** (version issue de `.fvmrc`, channel stable, cache activé)
3. **Installation des dépendances** : `flutter pub get` dans `belotable/`
4. **Exécution des tests** : `flutter test --coverage`
5. **Build Windows Release** : `flutter build windows --release`
6. **Installation Inno Setup** via Chocolatey (`choco install innosetup`)
7. **Génération de l'installeur** via `build/windows-build-innosetup.ps1`
8. **Upload de l'artefact** `windows-installer` (rétention : 7 jours, `if-no-files-found: error`)

#### 4. `publish-release` — Release GitHub (`ubuntu-latest`)

Déclenché uniquement si les trois jobs précédents ont réussi.

1. **Téléchargement** de l'artefact `windows-installer`
2. **Création ou mise à jour** d'une release GitHub pre-release :
   - Tag : `dev-latest` (push) ou `pr-<num>` (PR)
   - Titre : défini par `release_title`
   - Notes : conserve le corps existant et insère/remplace un bloc `<!-- docker-image-start -->…<!-- docker-image-end -->` avec le nom de l'image, le digest et la commande `docker pull`
   - L'installeur `.exe` est attaché à la release (écrase l'existant si présent)

### Permissions requises

- `contents: write` — création/édition des releases GitHub
- `packages: write` — push vers GHCR

---

## Web Docker Cleanup (`web-docker-cleanup.yml`)

### Déclencheurs

- **Planifié** : Tous les mardis à 10h UTC
- **Manuel** : `workflow_dispatch` via Actions tab

### Objectif

Maintenir l'hygiène du registry GHCR en supprimant automatiquement les images obsolètes selon une politique de rétention stricte. Supporte les repos appartenant à un utilisateur ou à une organisation.

### Exceptions (images toujours conservées)

Les versions suivantes ne sont **jamais** supprimées :

- **Branche par défaut** : image taggée avec la branche par défaut ou `latest`
- **Tags SemVer** : tag correspondant au pattern `vX.Y.Z[-prerelease][+build]`
- **Latest de PR ouverte** : la version la plus récente pour chaque PR encore ouverte
- **Latest de branche existante** : la version la plus récente pour chaque branche encore présente dans le repo

### Règles de suppression

Une version est supprimée si elle ne satisfait aucune exception ci-dessus **et** qu'au moins une des conditions suivantes est vraie :

| Raison | Description |
|--------|-------------|
| `pr_closed` | Taggée `pr-<num>` et la PR est fermée |
| `not_latest_open_pr` | Appartient à une PR ouverte mais n'en est pas la version la plus récente |
| `branch_missing:<nom>` | Taggée avec un nom de branche qui n'existe plus |
| `not_latest_existing_branch` | Appartient à une branche existante mais n'en est pas la version la plus récente |
| `older_than_7_days` | Créée il y a plus de 7 jours |

### Résumé d'exécution

Le job génère un résumé GitHub Actions avec :
- Package cible (`ghcr.io/<owner>/<package>`)
- Branche par défaut détectée
- Nombre de versions conservées (par catégorie) et supprimées

---

## Bonnes pratiques

### Pour les contributeurs

- Les PR sont buildées automatiquement (tests + Docker + Windows)
- La release GitHub (`pr-<num>`) est créée ou mise à jour à chaque push sur la PR
- Seuls les `OWNER` et `COLLABORATOR` déclenchent les jobs (configurez cela dans **Settings → Collaborators**)

### Pour la maintenance

- **Nettoyage GHCR** : exécuté automatiquement chaque mardi — pas d'intervention requise
- **Versions SemVer** : jamais supprimées (pérennité des releases)
- **Branche par défaut** : toujours protégée du cleanup

---

## Restrictions et limites

- Le pattern SemVer accepte les préfixes `v` et les suffixes `-prerelease`, `+build`
- Les PR de contributeurs non-collaborateurs ne déclenchent aucun job

---

## Ressources utiles

- [GitHub Actions Workflows Documentation](https://docs.github.com/en/actions/using-workflows)
- [Container Registry (GHCR) Documentation](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
