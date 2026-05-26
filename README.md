# Belotable

![Belotable Logo](resources/logo_full.png)

Besoin : organisation et scoring d'un tournoi de belote

Contraintes :
 - outil compatible à n'importe quel OS
 - fonctionne sans connexion internet
 - outil de préférence portable (càd ne nécessite pas d'installation)

## MVP

 - belote à la vache, sans coinche et sans annonces
 - tournoi en 3 parties
 - chaque partie fait 10 donnes
 - seules les doublettes gagnantes jouent les parties suivantes
 - saisie des joueurs par doublette
 - génération des premières parties en répartissant les doublettes sur les tables dans l'ordre d'inscription des doublettes
 - saisie des scores à chaque fin de partie
 - le score de chaque donne doit être juste. Si un score saisi n'est pas juste, il faut le mettre en évidence.
 - pour une belote à la vache, le score d'une donne est juste si la somme des points est égale à 162.
 - génération de l'arbre du tournoi
 - visualisation de l'arbre du tournoi avec les résultats : mise en évidence des gagnants de chaque partie
 - sauvegarde automatique de toutes les informations du tournoi pour reprendre en cas d'erreur
 - possibilité de créer un nouveau tournoi ou de charger un précédent tournoi
 - possibilité d'exporter les données d'un tournoi dans un format exploitable pour l'outil lui-même pour charger à nouveau le tournoi

### Fonctionnalités bonus au MVP

 - créer un pdf imprimable A4 noir et blanc (une seule page) pour saisir manuellement par les joueurs le score d'une partie sur une table
 - créer un pdf imprimable A4 noir et blanc (une seule page) pour préciser les règles de jeu et comment compter les points
 - créer un pdf imprimable A4 noir et blanc (plusieurs pages) qui récapitule toutes les parties de toutes les parties avec les résultats finaux, et l'arbre du tournoi avec mise en évidence des gagnants de chaque partie
 - possibilité d'exporter les données d'un tournoi dans un format csv

## Solution technique retenue : Flutter

L'application est développée avec **Flutter** (Dart), ciblant les plateformes desktop : Windows, macOS et Linux.

Flutter dispose de son propre moteur de rendu (Impeller/Skia), indépendant de la WebView système. Le rendu est donc **identique sur tous les OS** sans dépendance externe.

### Stack technique

| Composant | Technologie |
|---|---|
| Framework UI | Flutter (Dart) |
| Gestion d'état | Riverpod |
| Persistance locale | SQLite via `drift` |
| Sauvegarde / export natif | Fichiers JSON via `path_provider` + `file_picker` |
| Génération PDF | Package `pdf` + `printing` |
| Export CSV | Package `csv` |
| Visualisation bracket | Widget personnalisé (`CustomPainter`) |
| Packaging desktop | `flutter build windows/linux/macos` |

### Structure du projet (couches)

```
belotable/lib/
├── data/           # Accès données : SQLite, fichiers JSON, CSV
├── domain/         # Logique métier : règles belote, calcul scores, génération tournoi
├── presentation/   # Widgets et écrans Flutter
│   ├── desktop/    # Layouts optimisés PC (multi-colonnes, clavier/souris)
│   └── shared/     # Widgets réutilisables toutes plateformes
├── gen/            # Fichiers générés (assets, etc.) - NE PAS MODIFIER
└── main.dart       # Point d'entrée de l'application
```

La logique métier (`domain/`) et l'accès aux données (`data/`) sont **découplés de l'UI**, ce qui facilite les évolutions futures.

### Portage smartphone (perspective future)

Flutter ciblant nativement Android et iOS, un portage mobile est envisageable **sans réécriture** des couches `domain/` et `data/` (réutilisation estimée à ~90 %).

Les adaptations nécessaires se limitent à la couche `presentation/` :

- Ajouter des layouts adaptés aux petits écrans dans `presentation/mobile/` (navigation en pile, vues simplifiées)
- Adapter la visualisation du bracket du tournoi pour le tactile (scroll horizontal, zoom)
- Gérer les différences d'accès fichiers (sandbox mobile via `path_provider`)

Un cas d'usage mobile pertinent serait une **application compagne** permettant la saisie des scores à la table par les joueurs eux-mêmes sur smartphone, synchronisée avec l'application desktop de l'organisateur.

### Maintenance

#### Version Flutter centralisée

La version Flutter de référence est stockée dans `.fvmrc` (racine du dépôt).

- CI (Windows/Web) lit cette valeur automatiquement.
- Docker Compose l'utilise via la variable d'environnement `FLUTTER_VERSION`.
- En local, FVM lit directement cette valeur.

Synchroniser FVM avec la version centralisée :

```bash
fvm install
fvm use --pin
```

#### Poste de développement (windows)

Pré-requis :

| Outil | Comment l'installer/mettre à jour | Docs |
| --- | --- | --- |
| Chocolatey | https://chocolatey.org/install | https://community.chocolatey.org/packages |
| winget | https://learn.microsoft.com/fr-fr/windows/package-manager/winget/ | |
| Git | `winget install Git.Git` | https://git-scm.com/doc |
| GitHub CLI | `winget install GitHub.cli` | https://cli.github.com/manual/ |
| VS Code | `winget install Microsoft.VisualStudioCode` | https://code.visualstudio.com/ |
| Flutter (via fvm) | `choco upgrade fvm --yes` | https://github.com/leoafarias/fvm et https://docs.flutter.dev/ |
| Chrome | `winget install Google.Chrome` | |
| Visual Studio Community | `winget install Microsoft.VisualStudio.Community` | https://learn.microsoft.com/en-us/visualstudio/windows/?view=visualstudio |
| Inno Setup | `winget install JRSoftware.InnoSetup` | https://jrsoftware.org/isinfo.php |

#### Plateformes

L'application est compilée pour Windows et sous forme de webapp. Les autres plateformes seront disponibles dans une prochaine version.

##### Windows

###### Prérequis

- Visual Studio Community installé avec le workload **"Développement Desktop en C++"** (composant requis par Flutter pour compiler les applications Windows natives)

Pour vérifier que l'environnement est correctement configuré :
```bash
fvm flutter doctor
```

###### Compilation

```bash
fvm flutter build windows --release
```

Le résultat est généré dans :
```
build/windows/x64/runner/Release/
```

Ce dossier contient l'exécutable principal (`belotable.exe`) ainsi que toutes les DLL nécessaires à son exécution.

###### Déploiement sur un poste Windows (via Inno Setup)

Le déploiement Windows se fait via un installeur généré par **Inno Setup** à l'aide du script PowerShell [`build/windows-build-innosetup.ps1`](build/windows-build-innosetup.ps1).

1. Compiler l'application Flutter en mode release :
  ```bash
  fvm flutter build windows --release
  ```
2. Générer l'installeur depuis le dossier `build/` :
  ```powershell
  .\windows-build-innosetup.ps1
  ```

Le livrable à distribuer est l'installeur généré par Inno Setup qui sera dans le répertoire `build/windows_output`.

##### Webapp

###### Compilation

```bash
fvm flutter build web --release
```

Le résultat est généré dans :
```
build/web/
```

Ce dossier contient des fichiers statiques (HTML, JavaScript, CSS, assets) pouvant être servis par n'importe quel serveur HTTP.

###### Démarrage sur un serveur

**En local (test rapide) :**

```bash
python -m http.server 8080 --directory build/web
```

Puis ouvrir `http://localhost:8080` dans un navigateur.

**Via Docker (recommandé) :**

Le répertoire [`build/docker/`](build/docker/README.md) fournit un Dockerfile et un `docker-compose.yml` prêts à l'emploi. L'image finale (~25 MB) compile Flutter en multi-stage puis sert les fichiers statiques via nginx:alpine.

```bash
docker compose -f build/docker/docker-compose.yml up --build -d
```

Surcharge ponctuelle possible :

```powershell
$env:FLUTTER_VERSION = (Get-Content .fvmrc -Raw | ConvertFrom-Json).flutter
docker compose -f build/docker/docker-compose.yml up --build -d
```

Puis ouvrir `http://localhost` dans un navigateur. Voir [`build/docker/README.md`](build/docker/README.md) pour les détails.

Pour stopper le docker :

```bash
docker compose -f build/docker/docker-compose.yml down
```

Une image prête à lancer est aussi générée par la CI GitHub et publiée sur GHCR. Voir la section dédiée dans [`build/docker/README.md`](build/docker/README.md).

**Sur un serveur de production (Nginx) :**

Copier le contenu de `build/web/` dans le répertoire servi par Nginx, puis configurer le bloc `server` pour rediriger toutes les routes vers `index.html` (requis pour le routage SPA de Flutter) :

```nginx
server {
    listen 80;
    root /var/www/belotable;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

> **Note :** l'application ne nécessite aucun backend. Le serveur se contente de servir les fichiers statiques générés.

#### CI/CD

Les workflows GitHub Actions sont définis dans [`.github/workflows/`](.github/workflows/README.md).

##### Artefacts produits par la CI

| Workflow | Déclencheur | Artefact attendu |
|----------|-------------|------------------|
| **Windows Build** | Push `dev` / PR | Installeur `.exe` généré par Inno Setup, disponible dans les artefacts GitHub Actions sous le nom `windows-installer-<run_number>` (rétention : 14 jours) |
| **Web Docker Image** | Push `main`/`dev` / PR | Image Docker publiée sur GHCR (`ghcr.io/<owner>/belotable-web`) avec tags de branche, PR et commit SHA |

Dans les deux cas, **les tests sont exécutés avant la compilation** (`flutter test --coverage`). Un échec des tests bloque le build.

#### Gestionnaire des assets (flutter_gen)

Le projet utilise **flutter_gen** pour la gestion type-safe des assets (images, icônes, etc.). Cela permet d'éviter les erreurs de chemins et de bénéficier de l'autocomplétion de l'IDE.

##### Ajouter un nouvel asset

1. Placer le fichier dans le dossier `assets/` (ex. : `assets/icon.png`, `assets/images/logo.png`)
2. Régénérer les assets avec :
   ```bash
   fvm flutter pub run build_runner build
   ```
   Ou en mode watch (régénération automatique) :
   ```bash
   fvm flutter pub run build_runner watch
   ```

3. Le fichier généré `lib/gen/assets.gen.dart` est automatiquement mis à jour. Utiliser ensuite l'asset dans le code :
   ```dart
   import 'package:belotable/gen/assets.gen.dart';

   // Accès type-safe
   Assets.icon.image(width: 32, height: 32)
   ```

##### Avantages

- ✅ **Pas de risque d'erreur** : Les erreurs de chemins sont détectées à la compilation
- ✅ **Autocomplétion IDE** : Liste automatique des assets disponibles
- ✅ **Maintenabilité** : Refactoring facile des noms d'assets
- ✅ **Performance** : Les assets générés sont optimisés

##### Configuration

La configuration se trouve dans `pubspec.yaml` :
```yaml
flutter_gen:
  output: lib/gen
  line_length: 80
```

Pour plus d'informations, consulter la [documentation officielle](https://pub.dev/packages/flutter_gen).
