<!-- tags: architecture, flutter, database -->
# Explanation: Pourquoi SQLite et Drift pour Belotable

## Contexte: persistance hors ligne

Belotable est une application destinée à l'organisateur de tournoi de belote. Les utilisateurs doivent:
- Créer des concours, inscrire des joueurs, scorer les matches **hors ligne**.
- Pas de connexion réseau requise pendant l'événement.

Contrainte: l'application doit être **portable** (Windows, web, éventuellement mobile).

## Pourquoi SQLite (par rapport aux alternatives)

### SQLite: avantages

- **Embarqué**: aucun serveur. Fichier local sur l'appareil.
- **Léger**: binaire ~500KB, zéro configuration.
- **Fiable**: ACID, transactions, recovery.
- **Standard industriel**: utilisé nativement sur Android, iOS, applications desktop.
- **Multiplateforme**: Windows, Mac, Linux, web (via SQL.js).

## Pourquoi Drift (par rapport aux alternatives SQLite Dart)

### Drift: avantages

**Sécurité des types:**
```dart
// Drift: vérification des types à la compilation
final joueurs = await db.joueurDao.getJoueursByConcoursId(concoursId);
// joueurs: List<JoueurTable> → aucun cast, aucun bug runtime

// Alternatives (sqflite): SQL string → erreurs runtime
final rows = await db.rawQuery(
  'SELECT * FROM joueur WHERE concours_id = ?',
  [concoursId],
);
// rows: List<Map<String, dynamic>> → cast manuel, risque de typo
```

**Code généré:**
```dart
// Drift génère:
// - Classes Companion (insert/update)
// - Constructeurs de requêtes type-safe
// - Accesseurs DAOs
// → zéro boilerplate

// Alternatives: écrire les requêtes manuellement
const String _query = '''
  SELECT * FROM joueur 
  WHERE concours_id = ? 
  ORDER BY nom ASC
  LIMIT ? OFFSET ?
''';
// Typos = bug à runtime
```

**Requêtes en Dart:**
```dart
// Drift: méthode Dart
Future<List<Joueur>> getJoueursByConcoursId(String id) {
  return (select(joueurTable)
    ..where((t) => t.concoursId.equals(id))
    ..orderBy([(t) => OrderingTerm(expression: t.nom)])
  ).get();
}
// Refactoring automatique en IDE, filtres type-safe

// Alternatives (sqflite): chaînes SQL brutes
Future<List<Map>> getByConcoursId(String id) {
  return db.query('joueur', where: 'concours_id = ?', whereArgs: [id]);
}
// Typos SQL = erreurs runtime, pas de support de refactoring IDE
```

**Migrations versionnées:**
```dart
// Drift: version de schéma + stratégies
@override
int get schemaVersion => 2;

@override
MigrationStrategy get migration => MigrationStrategy(
  onUpgrade: (m, from, to) async {
    if (from < 2) await m.addColumn(joueurTable, joueurTable.telephone);
  },
);
// Versioning explicite, migrations testables

// Alternatives: suivi manuel des migrations
// Risque: oublier version, appliquer migration deux fois
```

### Drift: compromis

- **Apprentissage**: DSL Drift par rapport au SQL brut (mineur)
- **Overkill petit schéma**: si 1-2 tables simples, sqflite peut suffire. Drift excelle avec **multi-tables, relations**.

Belotable = tournoi multi-entités (concours, joueurs, équipes, matches, scores) → Drift excellent choix.

## Architecture proposée: pourquoi les couches

```
presentation/ ← Interface utilisateur Flutter
    ↓
repositories/ ← Adaptation DB → domain
    ↓
domain/ ← Entités métier, logique métier pures
    ↓
data/database/ ← Tables Drift, DAOs, AppDatabase
    ↓
Fichier SQLite ← Persistance
```

**Bénéfices:**

1. **Testabilité:** mock repository → tests de logique sans base de données
2. **Portabilité:** si remplacement SQLite → Firestore, seule la couche repository change
3. **Clarté:** domain ignore les détails techniques de Drift. Logique métier pure
4. **Maintenabilité:** changement du schéma de table = impact limité à la couche data

## Scalabilité de Belotable

### Cas nominal: tournoi local 50 personnes

- ~50 joueurs, ~5 équipes, ~20 matches.
- Taille SQLite <1MB.
- Requêtes <100ms.

SQLite est suffisant.

## Décisions solidifiées

**Choix SQLite + Drift = verrouillage acceptable car:**
1. Offline-first est une fonctionnalité principale. Pas de meilleures alternatives.
2. Communauté Drift mature, maintenance active (v2.33 stable).
3. Type-safety réduit les bugs critiques dans l'app de scoring (données correctes = confiance utilisateurs).

## Avenir: quand reconsidérer

- **Requêtes très complexes** (agrégation multi-entités) → SQL personnalisé ou backend GraphQL
- **Données multi-appareils en collaboration** → couche sync (ex: Realm Sync, custom CRD)
- **Appli desktop + web UI** → backend graphql/API, DB centralisée

Pour maintenant: SQLite + Drift local, synchronisation manuelle basée sur événements suffisant.
