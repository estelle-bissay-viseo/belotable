# Référence: Structure du répertoire

## Racine du dépôt

- `belotable/` : application Flutter.
- `build/` : scripts de build, packaging Windows, stack Docker web.
- `user-docs/` : documentation utilisateur (MkDocs).
- `technical-docs/` : documentation technique (ce répertoire).
- `.github/workflows/` : pipelines CI/CD et documentation.
- `trivy.yaml` : configuration centralisée des scans Trivy.
- `.trivyignore` : liste d'exceptions Trivy.
- `resources/` : ressources projet.

## Sous-projet Flutter

Dans `belotable/` :

- `lib/` : code source Dart.
- `test/` : tests Flutter.
- `assets/` : assets applicatifs.
- `android/`, `ios/`, `linux/`, `macos/`, `windows/`, `web/` : cibles plateforme Flutter.
- `pubspec.yaml` : metadata et dépendances.
- `analysis_options.yaml` : règles d'analyse statique.

## Packaging et exécution web

- `build/docker/Dockerfile` : build multi-stage Flutter web -> nginx.
- `build/docker/docker-compose.yml` : orchestration locale.
- `build/docker/nginx.conf` : configuration de service des assets web.

## Packaging Windows

- `build/windows-build-innosetup.ps1` : orchestration de compilation installeur.
- `build/windows-config.iss` : script Inno Setup.

## CI/CD

- `.github/workflows/ci.yml`
- `.github/workflows/release.yml`
- `.github/workflows/docs-pages.yml`
- `.github/workflows/web-docker-cleanup.yml`
- `.github/workflows/trivy-update-cache.yml`
