# Tutorial: Première modification UI et validation

Objectif : faire une petite modification de texte dans l'interface puis vérifier le comportement via test.

## Étape 1: modifier l'écran d'accueil

Fichier cible : `belotable/lib/presentation/shared/home_page.dart`.

Exemple de changement : remplacer `Bienvenue !` par un texte explicite du contexte de dev.

## Étape 2: adapter le test widget

Fichier cible : `belotable/test/widget_test.dart`.

Le test doit vérifier le nouveau texte affiché.

## Étape 3: vérifier statiquement et exécuter les tests

```bash
cd belotable
fvm flutter analyze
fvm flutter test
```

Résultat attendu :

- Pas d'erreur d'analyse.
- Test widget vert.

## Étape 4: lancer l'application pour validation visuelle

```bash
fvm flutter run -d windows
```

Vérifier manuellement le rendu dans la fenêtre desktop.

## Pourquoi ce flux

- Le test widget protège contre les régressions triviales de rendu.
- `fvm flutter analyze` force le respect des règles de lint configurées.

## Sources (dépôt)

- `belotable/analysis_options.yaml`
- `belotable/lib/presentation/shared/home_page.dart`
- `belotable/test/widget_test.dart`
