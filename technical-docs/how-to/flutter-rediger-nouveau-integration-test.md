<!-- tags: flutter, tests-end-to-end, développement -->
# How-to: Rédiger un nouveau test d'intégration Flutter (end-to-end)

Objectif: ajouter un nouveau test d'intégration dans `belotable/integration_test/` avec `e2eTest` (gestion de la base de données de test, capture screenshot sur échec).

## Prerequisites

- poste de développement mis en place (cf [tutorials/00-mise-en-place-poste-dev.md](../tutorials/00-mise-en-place-poste-dev.md))
- Support Windows desktop active (`fvm flutter config --enable-windows-desktop`).
- Les widgets testés exposent des `Key` stables.

## Process

1. Créer un fichier de test dans `belotable/integration_test/pages/` ou `belotable/integration_test/flows/`.

Exemple : `belotable/integration_test/pages/concours_page_test.dart`.

2. Importer les dépendances de test d'integration.

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../helpers/test_utils.dart';
```

3. Déclarer le test avec `e2eTest(...)` et utiliser `await pumpTestApp(tester, db);` pour démarrer l'application avec une base de données de test.

```dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  e2eTest(
    'Concours page',
    'User can open concours form then cancel',
    (tester, db) async {
      await pumpTestApp(tester, db);

      await tester.tap(find.byKey(const Key('home_create_concours_button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('concours_creation_form')), findsOneWidget);
    },
  );
}
```

4. Préparer les données (optionnel).

Si le test requiert des données initiales, définir une fonction seed et la passer à `pumpTestApp` :

```dart
Future<void> seedTestData(AppDatabase db) async {
  await db.concoursDao.insertConcours(Concours(
    id: 'test-concours-1',
    lieu: 'Salle de test',
    organisateur: 'Test Organization',
    dateCreation: DateTime.now(),
  ));
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  e2eTest(
    'Concours page',
    'User can update existing concours',
    (tester, db) async {
      // Seeding optionnel
      await pumpTestApp(tester, db, seed: seedTestData);

      await tester.tap(find.byKey(const Key('concours_edit_button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('concours_form')), findsOneWidget);
    },
  );
}
```

5. Ajouter le fichier au launcher global `belotable/integration_test/all_tests.dart`.

```dart
import 'pages/concours_page_test.dart' as concours_page;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  concours_page.main();
}
```

Sans cette étape, le test ne sera pas exécuté lors du run global.

6. Exécuter le test.

Run global recommandé:

```bash
cd belotable
fvm flutter test integration_test/all_tests.dart -d windows -r expanded
```

Run fichier unique:

```bash
cd belotable
fvm flutter test integration_test/pages/concours_page_test.dart -d windows -r expanded
```

Run test nommé:

```bash
cd belotable
fvm flutter test integration_test/pages/concours_page_test.dart -d windows -r expanded --name "User can open concours form then cancel"
```

## Checklist

- [ ] Le test est créé sous `belotable/integration_test/`.
- [ ] `e2eTest(...)` est utilisé.
- [ ] Le fichier est réferencé dans `integration_test/all_tests.dart`.
- [ ] Les widgets critiques ont des `Key` stables.
- [ ] Le test passe en local avec cible Windows.

## Troubleshooting

### Le test n'apparait pas dans l'exécution globale

Cause probable: fichier non ajouté a `integration_test/all_tests.dart`.

Résolution: ajouter l'import alias et appeler `xxx.main()` dans le `main()` global.

### Erreur "Widget key not found"

Cause probable: clé absente ou invalide dans l'UI.

Résolution: vérifier nom exact de la `Key` dans le widget cible et dans le test.

### Echec sans contexte visuel

Cause probable: interaction e2e echoue avant vérification.

Résolution: consulter les captures dans `integration_test/screenshots_failures/` (generées automatiquement par `e2eTest`).

## Resources

- [How-to: Lancer les tests d'integration en local](./flutter-lancer-integration-tests-local.md)
- [Reference: Architecture logicielle](../reference/architecture.md)
- [Tutorial: Demarrage local](../tutorials/01-demarrage-local.md)
