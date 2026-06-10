<!-- tags: développement, flutter -->
# Tutorial: Première modification UI et validation

Objectif : faire une petite modification de texte dans l'interface puis vérifier le comportement via test.

## Étape 1: modifier l'écran d'accueil

Fichier cible : `belotable/lib/presentation/shared/home_page.dart`.

Exemple de changement : remplacer `Bienvenue !` par un texte explicite du contexte de dev.

## Étape 2: adapter le test widget

Fichier cible : `belotable/test/widgets/widget_test.dart`.

Le test doit vérifier le nouveau texte affiché.

## Étape 3: adapter les tests d'intégration

Fichier cible : `belotable/integration_test/pages/home_page_test.dart`.

Le test doit vérifier le nouveau texte affiché.

## Étape 4: vérifier statiquement et exécuter les tests

```bash
cd belotable
# analyse statique
fvm flutter analyze
# tests unitaires et widget
fvm flutter test
# tests d'intégration (end-to-end)
fvm flutter test integration_test/all_tests.dart -d windows -r expanded
```

Résultat attendu :

- Pas d'erreur d'analyse.
- Tests en succès.

## Étape 5: lancer l'application pour validation visuelle

```bash
# windows
fvm flutter run -d windows
# webapp avec chrome
fvm flutter run -d chrome
```

Vérifier manuellement le rendu dans la fenêtre desktop.

## Pourquoi ce flux

- Les tests protègent contre les régressions.
- `fvm flutter analyze` force le respect des règles de lint configurées.
