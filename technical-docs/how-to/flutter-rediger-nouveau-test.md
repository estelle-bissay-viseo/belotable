<!-- tags: flutter, tests, développement -->
# How-to: Rediger un nouveau test Flutter

Objectif: ajouter un nouveau test unitaire ou widget dans `belotable/test/` en réutilisant les helpers projet (base Drift memoire + override Riverpod).

## Prerequisites

- poste de développement mis en place (cf [tutorials/00-mise-en-place-poste-dev.md](../tutorials/00-mise-en-place-poste-dev.md))

## Process

1. Créer un fichier de test dans `belotable/test/`.

Exemple : `belotable/test/presentation/shared/home_page_test.dart`.

2. Importer les dépendances minimales et les helpers du projet.

```dart
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_utils.dart';
```

3. Choisir le helper adapté.

- `dbTest(...)` pour tester une logique data sans arbre de widgets.
- `widgetDbTest(...)` pour tester une UI Flutter avec `WidgetTester`.

4. Préparer les données (optionnel).

Si le test nécessite des données en base avant assertions, seeder la base de test :

```dart
Future<void> seedDatabase(AppDatabase db) async {
  await db.concoursDao.insertConcours(/* ... */);
}

void main() {
  widgetDbTest('Home shows concours count', (tester, db) async {
    // Seed automatique
    await pumpTestApp(tester, db, seed: seedDatabase);
    
    expect(find.text('1 concours'), findsOneWidget);
  });
}
```

5. Ecrire le test.

```dart
void main() {
  widgetDbTest('Home page displays welcome message', (tester, db) async {
    await pumpTestApp(tester, db);

    expect(find.text('Bienvenue !'), findsOneWidget);
    expect(find.text('Belotable'), findsOneWidget);
  });
}
```

6. Exécuter le test.

```bash
cd belotable
fvm flutter test test/presentation/shared/home_page_test.dart -r expanded
```

Pour exécuter toute la suite:

```bash
cd belotable
fvm flutter test -r expanded
```

## Checklist

- [ ] Le test est place sous `belotable/test/`.
- [ ] Le helper (`dbTest` ou `widgetDbTest`) est utilise.
- [ ] Le test est autonome (pas de dependance à une base persistante locale).
- [ ] Le test passe en local avec `fvm flutter test`.

## Troubleshooting

### Erreur de type "provider not found"

Cause probable: l'application de test n'est pas montee via `pumpTestApp(...)`.

Resolution: utiliser `pumpTestApp(tester, db)` pour monter `MyApp` avec override de `databaseProvider`.

### Erreur liee a Drift ou base ouverte

Cause probable: base non fermee ou logique de test en dehors des helpers.

Resolution: encapsuler le test dans `dbTest` ou `widgetDbTest` pour beneficier du cycle `create -> close`.

### Test instable (timing UI)

Cause probable: assertions executees avant stabilisation du rendu.

Resolution: appeler `await tester.pumpAndSettle()` apres les interactions.

## Resources

- [Tutorial: Creer une entite avec Drift](../tutorials/03-creer-entite-avec-drift.md)
- [How-to: Lancer les tests d'integration en local](./flutter-lancer-integration-tests-local.md)
- [Reference: Architecture logicielle](../reference/architecture.md)
