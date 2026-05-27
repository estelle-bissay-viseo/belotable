# How-to : Ajouter un asset dans le projet Flutter

**Objectif** : Intégrer un nouveau fichier image, icône ou ressource dans l'application Flutter de manière cohérente avec le système de génération de code existant.

## Principe

Le projet utilise **flutter_gen** pour générer des références type-safe aux assets, plutôt que d'utiliser des chemins textes. Cela offre une meilleure expérience développeur et prévient les erreurs de chemin.

Les assets sont organisés dans le dossier `assets/` et déclarés dans `pubspec.yaml`.

## Étapes

### 1. Placer le fichier dans le dossier approprié

Rangez votre asset dans le dossier correspondant selon son type :

- **Images** : `belotable/assets/images/`
- **Icônes** : `belotable/assets/icons/`
- **Autres ressources** : `belotable/assets/`

**Exemple** : Ajouter une image de banneau en `/belotable/assets/images/banneau.png`

### 2. Déclarer l'asset dans pubspec.yaml

Modifiez `belotable/pubspec.yaml` dans la section `flutter:`:

```yaml
flutter:
  uses-material-design: true

  assets:
    - assets/icon.png
    - assets/images/  # ← Déclarer le dossier complet
    - assets/icons/
```

**Note** : Vous pouvez déclarer un dossier entier (`assets/images/`) pour inclure récursivement tous les fichiers, ou des fichiers spécifiques.

### 3. Générer les références type-safe

Exécutez la commande de génération :

```bash
cd belotable
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

Cela génère les classes Dart dans `lib/gen/assets.gen.dart`.

### 4. Utiliser l'asset dans le code

L'asset est maintenant disponible via la classe générée `Assets` :

```dart
import 'package:belotable/gen/assets.gen.dart';

// Pour une image
Image(image: AssetImage(Assets.images.banneau.path))

// Ou en utilisant Image.asset directement
Image.asset(Assets.images.banneau.path)

// Pour une icône
Icon(... /* AssetImage via Assets.icons.monIcone.path */)
```

## Points de vérification

- Le fichier est placé dans le bon dossier (`assets/images/`, `assets/icons/`, etc.)
- Le chemin du dossier est déclaré dans `pubspec.yaml` sous `flutter: assets:`
- La commande `flutter pub run build_runner build` a été exécutée sans erreur
- Le fichier généré `lib/gen/assets.gen.dart` contient votre nouvel asset
- L'import `import 'package:belotable/gen/assets.gen.dart';` est présent dans le fichier qui utilise l'asset
- Le code compile sans erreur : `flutter pub get` suivi de `flutter build web` (ou l'autre plateforme cible)

## Troubleshooting courant

**Le asset ne s'affiche pas ou il y a une erreur de chemin** :
- Vérifiez que le dossier est déclaré dans `pubspec.yaml`
- Relancez la génération des assets
- Nettoyez le cache : `flutter clean` puis `flutter pub get`

**La classe `Assets` n'est pas disponible** :
- Assurez-vous que `lib/gen/` existe
- Vérifiez que `flutter_gen:` est configuré dans `pubspec.yaml`
- Relancez la génération des assets

## Sources (dépôt)

- `belotable/pubspec.yaml` (section `flutter:`)
- `belotable/assets/` (dossier des ressources)
- `belotable/lib/gen/assets.gen.dart` (fichier généré — ne pas éditer manuellement)
- [Documentation Flutter Assets](https://flutter.dev/docs/development/ui/assets-and-images)
- [flutter_gen sur pub.dev](https://pub.dev/packages/flutter_gen)
