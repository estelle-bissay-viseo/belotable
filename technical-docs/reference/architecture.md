<!-- tags: architecture -->
# Référence: Architecture logicielle

## Aperçu

Application Flutter structurée en couches dans `belotable/lib/`.

```
belotable/lib/
├── data/           # Accès données (SQLite, fichiers JSON, CSV)
├── domain/         # Logique métier (règles belote, calcul scores, génération tournoi)
├── gen/            # Fichiers générés (assets, etc.) - NE PAS MODIFIER
├── presentation/   # Widgets et écrans Flutter
│   ├── desktop/    # Layouts optimisés PC (multi-colonnes, clavier/souris)
│   └── shared/     # Widgets réutilisables toutes plateformes
├── utils/          # utilitaires transverses
└── main.dart       # Point d'entrée de l'application
```

## Point d'entrée applicatif

`belotable/lib/main.dart` :

- démarre l'application dans un `ProviderScope` (Riverpod).
- crée `MyApp`.
- configure un `MaterialApp` avec un theme base sur `ColorScheme.fromSeed`.
- utilise `MyHomePage` comme écran initial.

## Injection de dépendances (Riverpod)

`belotable/lib/utils/providers.dart` centralise les providers d'infrastructure et d'application :

Exemples de providers :

- `databaseProvider` : expose une instance `AppDatabase`.
- `concoursRepositoryProvider` : construit `DriftConcoursRepository` à partir de `databaseProvider`.
- `createConcoursUseCaseProvider` : construit `CreateConcoursUseCase` à partir de `concoursRepositoryProvider`.

Cette chaîne permet de brancher les dépendances via Riverpod et de les surcharger facilement dans les tests.

## Ecran principal actuel

`belotable/lib/presentation/shared/home_page.dart` :

- affiche un `AppBar` avec icône asset et titre.
- affiche le texte `Bienvenue !` dans le corps de page.

## Assets

Voir [ajouter-un-asset-flutter.md](../how-to/flutter-ajouter-un-asset.md)

## Règles de qualité

`belotable/analysis_options.yaml` inclut `package:very_good_analysis/analysis_options.yaml`.

## Devices actuellement pris en charge

- windows
- web (chrome)

Les autres plateformes seront disponibles dans une prochaine version.

## Sources (dépôt)

- `belotable/lib/main.dart`
- `belotable/lib/utils/providers.dart`
- `belotable/lib/presentation/shared/home_page.dart`
- `belotable/lib/gen/assets.gen.dart`
- `belotable/pubspec.yaml`
- `belotable/analysis_options.yaml`
