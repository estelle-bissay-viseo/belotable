<!-- tags: développement, flutter, database -->
# Tutorial: Créer une entité avec Drift

Objectif: créer une table persistante, un DAO et des requêtes pour une nouvelle entité. À la fin de ce tutorial, vous serez capable d'insérer et de lire des données. L'entité sera liée à une table existante (Concours).

## Prérequis

- Flutter configuré localement et fonctionnel (voir [01-demarrage-local.md](01-demarrage-local.md)).

## Étape 1: Créer la classe JoueurTable

La classe JoueurTable définit les colonnes, leurs types et la clé primaire. Créez un fichier `belotable/lib/data/database/joueur_table.dart`:

```dart
import 'package:drift/drift.dart';

class JoueurTable extends Table {
  TextColumn get id => text()();
  
  TextColumn get nom => text()();
  
  TextColumn get prenom => text()();
  
  TextColumn get concoursId => text()();
  
  DateTimeColumn get dateInscription => dateTime()();
  
  @override
  Set<Column<Object>> get primaryKey => {id};
}
```

**Explication:**
- `TextColumn` : type texte (identifiants, noms, clés étrangères).
- `DateTimeColumn` : timestamp (date et heure).
- `text()()` / `dateTime()()` : colonnes **non-nullables**. Pour les rendre nullables, utilisez `.nullable()` (ex: `text().nullable()()`). Pour limiter la taille, utilisez `text().withLength(max: 100)`.
- `primaryKey` : identifiant unique par ligne.

## Étape 2: Créer le DAO (Data Access Object)

Le DAO encapsule toutes les requêtes (insert, select, update, delete). Dans un fichier Dart, les `import` doivent être en tête de fichier : placez donc le DAO dans un fichier dédié (ex: `belotable/lib/data/database/joueur_dao.dart`) ou dans `app_database.dart`, puis ajoutez le code suivant :

```dart
import 'package:belotable/domain/joueur/joueur.dart';

@DriftAccessor(tables: [JoueurTable])
class JoueurDao extends DatabaseAccessor<AppDatabase> with _$JoueurDaoMixin {
  JoueurDao(super.db);

  // Query: Insérer joueur
  Future<void> insertJoueur(Joueur joueur) async {
    await into(joueurTable).insertOnConflictUpdate(
      JoueurTableCompanion.insert(
        id: joueur.id,
        nom: joueur.nom,
        prenom: joueur.prenom,
        concoursId: joueur.concoursId,
        dateInscription: DateTime.now(),
      ),
    );
  }

  // Query: Récupérer tous joueurs
  Future<List<JoueurTableData>> getAllJoueurs() => select(joueurTable).get();

  // Query: Récupérer joueurs par concours
  Future<List<JoueurTableData>> getJoueursByConcoursId(String concoursId) {
    return (select(joueurTable)..where((t) => t.concoursId.equals(concoursId))).get();
  }

  // Query: Compter joueurs concours
  Future<int> countJoueursByConcours(String concoursId) async {
    final countExpr = joueurTable.id.count();
    final query = selectOnly(joueurTable)
      ..addColumns([countExpr])
      ..where(joueurTable.concoursId.equals(concoursId));
    
    final row = await query.getSingle();
    return row.read(countExpr) ?? 0;
  }

  // Query: Supprimer joueur
  Future<void> deleteJoueur(String joueurId) async {
    await (delete(joueurTable)..where((t) => t.id.equals(joueurId))).go();
  }
}
```

**Explication:**
- `@DriftAccessor` : annotation qui déclare les requêtes disponibles.
- `insertOnConflictUpdate` : effectue un « upsert » (insertion ou mise à jour si la ligne existe déjà).
- `select().where()` : filtre les résultats selon une condition.
- `.get()` : exécute la requête et retourne le résultat.

## Étape 3: Enregistrer le DAO et la Table dans AppDatabase

Modifiez le fichier `belotable/lib/data/database/app_database.dart`:

```dart
// Ajoutez import
import 'joueur_table.dart';

// Modifiez annotation @DriftDatabase
@DriftDatabase(
  tables: [ConcoursTable, JoueurTable],
  daos: [ConcoursDao, JoueurDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'belotable_db'));

  @override
  int get schemaVersion => 2; // Incrémenter la version chaque fois que le schéma change
}
```

**Raison:** AppDatabase est le registre central. Drift génère les accesseurs pour les tables et les DAOs.

## Étape 4: Générer le code Drift

Le build runner génère le code manquant (fichiers `.g.dart` et `.drift.dart`).

```bash
cd belotable
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

Résultat attendu: les fichiers `.g.dart` sont créés ou mis à jour, sans erreurs.

## Étape 5: Créer entité métier (Domain layer)

Créez `belotable/lib/domain/joueur/joueur.dart`:

```dart
class Joueur {
  final String id;
  final String nom;
  final String prenom;
  final String concoursId;
  final DateTime dateInscription;

  Joueur({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.concoursId,
    required this.dateInscription,
  });
}
```

**Raison:** L'entité métier est découplée du schéma de la base de données. La couche domain contient la logique métier pure, sans détails techniques.

## Étape 6: Mapper Table vers Joueur

Créez `belotable/lib/data/repositories/joueur_repository.dart`:

```dart
import 'package:belotable/data/database/app_database.dart';
import 'package:belotable/data/database/joueur_table.dart';
import 'package:belotable/domain/joueur/joueur.dart';

class JoueurRepository {
  final AppDatabase db;

  JoueurRepository(this.db);

  Future<void> createJoueur(Joueur joueur) async {
    await db.joueurDao.insertJoueur(joueur);
  }

  Future<List<Joueur>> getJoueursByConcoursId(String concoursId) async {
    final rows = await db.joueurDao.getJoueursByConcoursId(concoursId);
    return rows.map(_toJoueur).toList();
  }

  Future<int> countByConcoursId(String concoursId) async {
    return db.joueurDao.countJoueursByConcours(concoursId);
  }

  Future<void> deleteJoueur(String joueurId) async {
    await db.joueurDao.deleteJoueur(joueurId);
  }

  Joueur _toJoueur(JoueurTable row) => Joueur(
    id: row.id,
    nom: row.nom,
    prenom: row.prenom,
    concoursId: row.concoursId,
    dateInscription: row.dateInscription,
  );
}
```

**Raison:** Le Repository agit comme un adaptateur qui transforme les lignes de la base de données en entités métier. La couche domain ignore complètement les détails techniques de Drift.

## Étape 7: Utiliser en UI

Voici des exemples d'utilisation dans une interface Flutter (cas d'usage non valides, juste pour démonstration):

```dart
import 'package:belotable/data/database/app_database.dart';
import 'package:belotable/data/repositories/joueur_repository.dart';
import 'package:belotable/domain/joueur/joueur.dart';

class MonEcran extends StatefulWidget {
  @override
  State<MonEcran> createState() => _MonEcranState();
}

class _MonEcranState extends State<MonEcran> {
  late JoueurRepository _joueurRepo;

  @override
  void initState() {
    super.initState();
    final db = AppDatabase();
    _joueurRepo = JoueurRepository(db);
  }

  void _creerJoueur() async {
    final joueur = Joueur(
      id: 'joueur_123',
      nom: 'Dupont',
      prenom: 'Jean',
      concoursId: 'concours_1',
      dateInscription: DateTime.now(),
    );

    await _joueurRepo.createJoueur(joueur);
    
    final count = await _joueurRepo.countByConcoursId('concours_1');
    print('Joueurs concours: $count');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: _creerJoueur,
          child: Text('Ajouter Joueur'),
        ),
      ),
    );
  }
}
```

## Vérification

- [ ] Table créée avec colonnes typées
- [ ] DAO contient les méthodes `insert`, `select` et les filtres
- [ ] DAO enregistré dans l'annotation `@DriftDatabase`
- [ ] `build_runner build` exécuté sans erreur
- [ ] Entité métier créée (`domain/joueur/joueur.dart`)
- [ ] Repository adapter créé
- [ ] Interface utilisateur peut insérer et lire les joueurs

## Prochaines étapes

- [Reference: Structure Drift](../reference/drift-structure.md) — patterns avancés (migrations, champs calculés, relations).
- [Explanation: Pourquoi SQLite et Drift](../explanation/sqlite-et-drift.md) — architecture de la persistance.
- Tests unitaires du DAO (avec mock AppDatabase).
