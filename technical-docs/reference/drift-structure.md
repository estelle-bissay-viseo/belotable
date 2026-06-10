<!-- tags: flutter, développement, database -->
# Reference: Structure Drift et architecture data

## Vue d'ensemble

Drift est une bibliothèque de base de données type-safe pour Dart. Elle compile le code Dart en requêtes SQL. Zéro surcharge à l'exécution, sécurité complète des types.

Architecture de Belotable:
- **Database layer** (`data/database/`) : tables, DAOs, AppDatabase
- **Repository layer** (`data/repositories/`) : adaptateur DB → domain
- **Domain layer** (`domain/`) : entités métier, logique métier pure
- **Presentation layer** : utilise le repository, affiche l'interface utilisateur

## Table: anatomie

```dart
class NomTable extends Table {
  // Colonnes
  TextColumn get nomColonne => text()();
  IntColumn get quantite => integer()();
  DateTimeColumn get date => dateTime()();
  BoolColumn get actif => boolean().withDefault(const Constant(true))();
  
  // Clé primaire (requis)
  @override
  Set<Column<Object>> get primaryKey => {nomColonne};
}
```

### Types disponibles

| Type Dart | Colonne Drift | Notes |
|-----------|---|---|
| String | `TextColumn` | texte de longueur variable |
| int | `IntColumn` | entier 64 bits |
| double | `RealColumn` | nombre flottant |
| bool | `BoolColumn` | booléen |
| DateTime | `DateTimeColumn` | timestamp |
| Uint8List | `BlobColumn` | données binaires |

### Modificateurs de colonne

```dart
TextColumn get nom => text()
  .withLength(min: 1, max: 100)  // Contrainte de taille
  ();

IntColumn get age => integer()
  .withDefault(const Constant(0))  // Valeur par défaut
  ();

TextColumn get cle => text()
  .unique()                         // Contrainte d'unicité
  ();

TextColumn get ref => text()
  .references(AutreTable, #id)      // Clé étrangère
  ();
```

## DAO: requêtes et mutations

```dart
@DriftAccessor(tables: [NomTable])
class NomDao extends DatabaseAccessor<AppDatabase> with _$NomDaoMixin {
  NomDao(super.db);

  // INSERT
  Future<int> insert(NomTableCompanion row) => into(nomTable).insert(row);
  
  Future<void> insertOnConflictUpdate(NomTableCompanion row) async {
    await into(nomTable).insertOnConflictUpdate(row);
  }

  // SELECT tous
  Future<List<NomTable>> getAll() => select(nomTable).get();
  
  // SELECT avec WHERE
  Future<List<NomTable>> getByField(String value) {
    return (select(nomTable)
      ..where((t) => t.nomColonne.equals(value))
    ).get();
  }

  // SELECT single
  Future<NomTable?> getById(String id) {
    return (select(nomTable)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  // COUNT
  Future<int> count() async {
    final countExpr = nomTable.id.count();
    final query = selectOnly(nomTable)..addColumns([countExpr]);
    final row = await query.getSingle();
    return row.read(countExpr) ?? 0;
  }

  // UPDATE
  Future<bool> update(NomTableCompanion row) => update(nomTable).replace(row);

  // DELETE
  Future<void> deleteById(String id) async {
    await (delete(nomTable)..where((t) => t.id.equals(id))).go();
  }
}
```

## AppDatabase: registre central

```dart
@DriftDatabase(
  tables: [Table1, Table2, Table3],
  daos: [Dao1, Dao2],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'belotable_db'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      // Custom migration logic
    },
  );
}
```

### `schemaVersion`

Incrémenter lorsque le schéma change:
- Ajouter une table → version++
- Ajouter une colonne → version++
- Renommer une colonne → version++ + migration personnalisée

## Companions (valeurs partielles)

`NomTableCompanion` est une version partiellement nullable (utilisée lors des insertions).

```dart
// Insertion partielle (si l'id est auto-généré, omettez-le; sinon, il est requis)
await into(nomTable).insert(
  NomTableCompanion.insert(
    nom: 'Alice',
    prenom: 'Bob',
    // id omis si AUTOINCREMENT, sinon requis
  ),
);

// Insertion complète
await into(nomTable).insert(
  NomTableCompanion(
    id: Value('123'),
    nom: Value('Alice'),
    prenom: Value('Bob'),
  ),
);

// Mise à jour partielle
await update(nomTable).replace(
  NomTableCompanion(
    id: Value('123'),
    nom: Value('Alice - updated'),
    prenom: Value(null), // reste inchangé
  ),
);
```

## Relations (clés étrangères)

### One-to-Many

```dart
class ConcoursTable extends Table {
  TextColumn get id => text()();
  TextColumn get nom => text()();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

class JoueurTable extends Table {
  TextColumn get id => text()();
  TextColumn get nom => text()();
  TextColumn get concoursId => text().references(ConcoursTable, #id)();
  @override
  Set<Column<Object>> get primaryKey => {id};
}
```

Query de jointure:

```dart
Future<List<(Concours, List<Joueur>)>> getConcoursWithJoueurs() async {
  final query = select(concoursTable).join([
    innerJoin(joueurTable, joueurTable.concoursId.equalsExp(concoursTable.id)),
  ]);

  final rows = await query.get();
  
  // Grouper par concours
  Map<String, List<Joueur>> grouped = {};
  for (var row in rows) {
    final concours = row.readTable(concoursTable);
    final joueur = row.readTable(joueurTable);
    grouped.putIfAbsent(concours.id, () => []).add(joueur);
  }

  return grouped.entries.map((e) => (concoursTable, e.value)).toList();
}
```

## Migrations

Lorsque vous ajoutez une colonne:

```dart
@override
MigrationStrategy get migration => MigrationStrategy(
  onUpgrade: (m, from, to) async {
    if (from < 2) {
      // Migration de v1 → v2
      await m.addColumn(joueurTable, joueurTable.telephone);
    }
  },
);
```

## Transactions

```dart
await db.transaction(() async {
  await db.joueurDao.insertJoueur(joueur1);
  await db.joueurDao.insertJoueur(joueur2);
  // Atomique: tout ou rien
});
```

## Requêtes personnalisées (SQL brut)

Rarement nécessaire. Si les performances sont critiques:

```dart
@override
Future<List<Map<String, dynamic>>> customQuery() {
  return customSelect('SELECT * FROM joueur WHERE age > ?', variables: [18]).get();
}
```

## Indexation

Accélérer les recherches:

```dart
class JoueurTable extends Table {
  TextColumn get id => text()();
  TextColumn get concoursId => text()();
  
  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {concoursId}, // Index mono-colonne
  ];
}
```

## Couche Repository: mappage

```dart
class JoueurRepository {
  final AppDatabase _db;
  JoueurRepository(this._db);

  Future<Joueur> getById(String id) async {
    final row = await _db.joueurDao.getById(id);
    return _rowToEntity(row);
  }

  Joueur _rowToEntity(JoueurTable row) => Joueur(
    id: row.id,
    nom: row.nom,
    prenom: row.prenom,
    concoursId: row.concoursId,
  );
}
```

**Raison:** La couche domain ignore les détails techniques de Drift et SQLite. Facilite un futur remplacement de la base de données.

## Débogage

```dart
// SQL verbose
driftDatabase(
  name: 'belotable_db',
  logStatements: true, // affiche requêtes
)
```

Le terminal affiche le SQL exécuté:

```
I/Drift: SELECT * FROM joueur WHERE concours_id = ?
```

## Ressources

- [Drift docs](https://drift.simonbinder.eu/)
- [SQLite types](https://www.sqlite.org/datatype3.html)
