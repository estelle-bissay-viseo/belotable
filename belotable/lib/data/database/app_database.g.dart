// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
mixin _$ConcoursDaoMixin on DatabaseAccessor<AppDatabase> {
  $ConcoursTableTable get concoursTable => attachedDatabase.concoursTable;
  $DoublettesTableTable get doublettesTable => attachedDatabase.doublettesTable;
  ConcoursDaoManager get managers => ConcoursDaoManager(this);
}

class ConcoursDaoManager {
  final _$ConcoursDaoMixin _db;
  ConcoursDaoManager(this._db);
  $$ConcoursTableTableTableManager get concoursTable =>
      $$ConcoursTableTableTableManager(_db.attachedDatabase, _db.concoursTable);
  $$DoublettesTableTableTableManager get doublettesTable =>
      $$DoublettesTableTableTableManager(
        _db.attachedDatabase,
        _db.doublettesTable,
      );
}

mixin _$DoublettesDaoMixin on DatabaseAccessor<AppDatabase> {
  $ConcoursTableTable get concoursTable => attachedDatabase.concoursTable;
  $DoublettesTableTable get doublettesTable => attachedDatabase.doublettesTable;
  DoublettesDaoManager get managers => DoublettesDaoManager(this);
}

class DoublettesDaoManager {
  final _$DoublettesDaoMixin _db;
  DoublettesDaoManager(this._db);
  $$ConcoursTableTableTableManager get concoursTable =>
      $$ConcoursTableTableTableManager(_db.attachedDatabase, _db.concoursTable);
  $$DoublettesTableTableTableManager get doublettesTable =>
      $$DoublettesTableTableTableManager(
        _db.attachedDatabase,
        _db.doublettesTable,
      );
}

class $ConcoursTableTable extends ConcoursTable
    with TableInfo<$ConcoursTableTable, ConcoursTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConcoursTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lieuMeta = const VerificationMeta('lieu');
  @override
  late final GeneratedColumn<String> lieu = GeneratedColumn<String>(
    'lieu',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _organisateurMeta = const VerificationMeta(
    'organisateur',
  );
  @override
  late final GeneratedColumn<String> organisateur = GeneratedColumn<String>(
    'organisateur',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, date, lieu, organisateur];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'concours_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ConcoursTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('lieu')) {
      context.handle(
        _lieuMeta,
        lieu.isAcceptableOrUnknown(data['lieu']!, _lieuMeta),
      );
    } else if (isInserting) {
      context.missing(_lieuMeta);
    }
    if (data.containsKey('organisateur')) {
      context.handle(
        _organisateurMeta,
        organisateur.isAcceptableOrUnknown(
          data['organisateur']!,
          _organisateurMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_organisateurMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConcoursTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConcoursTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      lieu: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lieu'],
      )!,
      organisateur: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}organisateur'],
      )!,
    );
  }

  @override
  $ConcoursTableTable createAlias(String alias) {
    return $ConcoursTableTable(attachedDatabase, alias);
  }
}

class ConcoursTableData extends DataClass
    implements Insertable<ConcoursTableData> {
  /// Unique identifier.
  final String id;

  /// Competition date.
  final DateTime date;

  /// Venue location.
  final String lieu;

  /// Organizing entity.
  final String organisateur;
  const ConcoursTableData({
    required this.id,
    required this.date,
    required this.lieu,
    required this.organisateur,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<DateTime>(date);
    map['lieu'] = Variable<String>(lieu);
    map['organisateur'] = Variable<String>(organisateur);
    return map;
  }

  ConcoursTableCompanion toCompanion(bool nullToAbsent) {
    return ConcoursTableCompanion(
      id: Value(id),
      date: Value(date),
      lieu: Value(lieu),
      organisateur: Value(organisateur),
    );
  }

  factory ConcoursTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConcoursTableData(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      lieu: serializer.fromJson<String>(json['lieu']),
      organisateur: serializer.fromJson<String>(json['organisateur']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<DateTime>(date),
      'lieu': serializer.toJson<String>(lieu),
      'organisateur': serializer.toJson<String>(organisateur),
    };
  }

  ConcoursTableData copyWith({
    String? id,
    DateTime? date,
    String? lieu,
    String? organisateur,
  }) => ConcoursTableData(
    id: id ?? this.id,
    date: date ?? this.date,
    lieu: lieu ?? this.lieu,
    organisateur: organisateur ?? this.organisateur,
  );
  ConcoursTableData copyWithCompanion(ConcoursTableCompanion data) {
    return ConcoursTableData(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      lieu: data.lieu.present ? data.lieu.value : this.lieu,
      organisateur: data.organisateur.present
          ? data.organisateur.value
          : this.organisateur,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConcoursTableData(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('lieu: $lieu, ')
          ..write('organisateur: $organisateur')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, lieu, organisateur);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConcoursTableData &&
          other.id == this.id &&
          other.date == this.date &&
          other.lieu == this.lieu &&
          other.organisateur == this.organisateur);
}

class ConcoursTableCompanion extends UpdateCompanion<ConcoursTableData> {
  final Value<String> id;
  final Value<DateTime> date;
  final Value<String> lieu;
  final Value<String> organisateur;
  final Value<int> rowid;
  const ConcoursTableCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.lieu = const Value.absent(),
    this.organisateur = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConcoursTableCompanion.insert({
    required String id,
    required DateTime date,
    required String lieu,
    required String organisateur,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       lieu = Value(lieu),
       organisateur = Value(organisateur);
  static Insertable<ConcoursTableData> custom({
    Expression<String>? id,
    Expression<DateTime>? date,
    Expression<String>? lieu,
    Expression<String>? organisateur,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (lieu != null) 'lieu': lieu,
      if (organisateur != null) 'organisateur': organisateur,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConcoursTableCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? date,
    Value<String>? lieu,
    Value<String>? organisateur,
    Value<int>? rowid,
  }) {
    return ConcoursTableCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      lieu: lieu ?? this.lieu,
      organisateur: organisateur ?? this.organisateur,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (lieu.present) {
      map['lieu'] = Variable<String>(lieu.value);
    }
    if (organisateur.present) {
      map['organisateur'] = Variable<String>(organisateur.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConcoursTableCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('lieu: $lieu, ')
          ..write('organisateur: $organisateur, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DoublettesTableTable extends DoublettesTable
    with TableInfo<$DoublettesTableTable, DoublettesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DoublettesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _concoursIdMeta = const VerificationMeta(
    'concoursId',
  );
  @override
  late final GeneratedColumn<String> concoursId = GeneratedColumn<String>(
    'concours_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES concours_table (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _doubletteIdMeta = const VerificationMeta(
    'doubletteId',
  );
  @override
  late final GeneratedColumn<int> doubletteId = GeneratedColumn<int>(
    'doublette_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _joueurAMeta = const VerificationMeta(
    'joueurA',
  );
  @override
  late final GeneratedColumn<String> joueurA = GeneratedColumn<String>(
    'joueur_a',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _joueurBMeta = const VerificationMeta(
    'joueurB',
  );
  @override
  late final GeneratedColumn<String> joueurB = GeneratedColumn<String>(
    'joueur_b',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nomEquipeMeta = const VerificationMeta(
    'nomEquipe',
  );
  @override
  late final GeneratedColumn<String> nomEquipe = GeneratedColumn<String>(
    'nom_equipe',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    concoursId,
    doubletteId,
    joueurA,
    joueurB,
    nomEquipe,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'doublettes_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<DoublettesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('concours_id')) {
      context.handle(
        _concoursIdMeta,
        concoursId.isAcceptableOrUnknown(data['concours_id']!, _concoursIdMeta),
      );
    } else if (isInserting) {
      context.missing(_concoursIdMeta);
    }
    if (data.containsKey('doublette_id')) {
      context.handle(
        _doubletteIdMeta,
        doubletteId.isAcceptableOrUnknown(
          data['doublette_id']!,
          _doubletteIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_doubletteIdMeta);
    }
    if (data.containsKey('joueur_a')) {
      context.handle(
        _joueurAMeta,
        joueurA.isAcceptableOrUnknown(data['joueur_a']!, _joueurAMeta),
      );
    } else if (isInserting) {
      context.missing(_joueurAMeta);
    }
    if (data.containsKey('joueur_b')) {
      context.handle(
        _joueurBMeta,
        joueurB.isAcceptableOrUnknown(data['joueur_b']!, _joueurBMeta),
      );
    } else if (isInserting) {
      context.missing(_joueurBMeta);
    }
    if (data.containsKey('nom_equipe')) {
      context.handle(
        _nomEquipeMeta,
        nomEquipe.isAcceptableOrUnknown(data['nom_equipe']!, _nomEquipeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomEquipeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {concoursId, doubletteId};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {concoursId, nomEquipe},
  ];
  @override
  DoublettesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DoublettesTableData(
      concoursId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}concours_id'],
      )!,
      doubletteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}doublette_id'],
      )!,
      joueurA: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}joueur_a'],
      )!,
      joueurB: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}joueur_b'],
      )!,
      nomEquipe: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nom_equipe'],
      )!,
    );
  }

  @override
  $DoublettesTableTable createAlias(String alias) {
    return $DoublettesTableTable(attachedDatabase, alias);
  }
}

class DoublettesTableData extends DataClass
    implements Insertable<DoublettesTableData> {
  /// Owning concours id.
  final String concoursId;

  /// Registration order id scoped to concours.
  final int doubletteId;

  /// Player A full name.
  final String joueurA;

  /// Player B full name.
  final String joueurB;

  /// Team name unique per concours.
  final String nomEquipe;
  const DoublettesTableData({
    required this.concoursId,
    required this.doubletteId,
    required this.joueurA,
    required this.joueurB,
    required this.nomEquipe,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['concours_id'] = Variable<String>(concoursId);
    map['doublette_id'] = Variable<int>(doubletteId);
    map['joueur_a'] = Variable<String>(joueurA);
    map['joueur_b'] = Variable<String>(joueurB);
    map['nom_equipe'] = Variable<String>(nomEquipe);
    return map;
  }

  DoublettesTableCompanion toCompanion(bool nullToAbsent) {
    return DoublettesTableCompanion(
      concoursId: Value(concoursId),
      doubletteId: Value(doubletteId),
      joueurA: Value(joueurA),
      joueurB: Value(joueurB),
      nomEquipe: Value(nomEquipe),
    );
  }

  factory DoublettesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DoublettesTableData(
      concoursId: serializer.fromJson<String>(json['concoursId']),
      doubletteId: serializer.fromJson<int>(json['doubletteId']),
      joueurA: serializer.fromJson<String>(json['joueurA']),
      joueurB: serializer.fromJson<String>(json['joueurB']),
      nomEquipe: serializer.fromJson<String>(json['nomEquipe']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'concoursId': serializer.toJson<String>(concoursId),
      'doubletteId': serializer.toJson<int>(doubletteId),
      'joueurA': serializer.toJson<String>(joueurA),
      'joueurB': serializer.toJson<String>(joueurB),
      'nomEquipe': serializer.toJson<String>(nomEquipe),
    };
  }

  DoublettesTableData copyWith({
    String? concoursId,
    int? doubletteId,
    String? joueurA,
    String? joueurB,
    String? nomEquipe,
  }) => DoublettesTableData(
    concoursId: concoursId ?? this.concoursId,
    doubletteId: doubletteId ?? this.doubletteId,
    joueurA: joueurA ?? this.joueurA,
    joueurB: joueurB ?? this.joueurB,
    nomEquipe: nomEquipe ?? this.nomEquipe,
  );
  DoublettesTableData copyWithCompanion(DoublettesTableCompanion data) {
    return DoublettesTableData(
      concoursId: data.concoursId.present
          ? data.concoursId.value
          : this.concoursId,
      doubletteId: data.doubletteId.present
          ? data.doubletteId.value
          : this.doubletteId,
      joueurA: data.joueurA.present ? data.joueurA.value : this.joueurA,
      joueurB: data.joueurB.present ? data.joueurB.value : this.joueurB,
      nomEquipe: data.nomEquipe.present ? data.nomEquipe.value : this.nomEquipe,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DoublettesTableData(')
          ..write('concoursId: $concoursId, ')
          ..write('doubletteId: $doubletteId, ')
          ..write('joueurA: $joueurA, ')
          ..write('joueurB: $joueurB, ')
          ..write('nomEquipe: $nomEquipe')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(concoursId, doubletteId, joueurA, joueurB, nomEquipe);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DoublettesTableData &&
          other.concoursId == this.concoursId &&
          other.doubletteId == this.doubletteId &&
          other.joueurA == this.joueurA &&
          other.joueurB == this.joueurB &&
          other.nomEquipe == this.nomEquipe);
}

class DoublettesTableCompanion extends UpdateCompanion<DoublettesTableData> {
  final Value<String> concoursId;
  final Value<int> doubletteId;
  final Value<String> joueurA;
  final Value<String> joueurB;
  final Value<String> nomEquipe;
  final Value<int> rowid;
  const DoublettesTableCompanion({
    this.concoursId = const Value.absent(),
    this.doubletteId = const Value.absent(),
    this.joueurA = const Value.absent(),
    this.joueurB = const Value.absent(),
    this.nomEquipe = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DoublettesTableCompanion.insert({
    required String concoursId,
    required int doubletteId,
    required String joueurA,
    required String joueurB,
    required String nomEquipe,
    this.rowid = const Value.absent(),
  }) : concoursId = Value(concoursId),
       doubletteId = Value(doubletteId),
       joueurA = Value(joueurA),
       joueurB = Value(joueurB),
       nomEquipe = Value(nomEquipe);
  static Insertable<DoublettesTableData> custom({
    Expression<String>? concoursId,
    Expression<int>? doubletteId,
    Expression<String>? joueurA,
    Expression<String>? joueurB,
    Expression<String>? nomEquipe,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (concoursId != null) 'concours_id': concoursId,
      if (doubletteId != null) 'doublette_id': doubletteId,
      if (joueurA != null) 'joueur_a': joueurA,
      if (joueurB != null) 'joueur_b': joueurB,
      if (nomEquipe != null) 'nom_equipe': nomEquipe,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DoublettesTableCompanion copyWith({
    Value<String>? concoursId,
    Value<int>? doubletteId,
    Value<String>? joueurA,
    Value<String>? joueurB,
    Value<String>? nomEquipe,
    Value<int>? rowid,
  }) {
    return DoublettesTableCompanion(
      concoursId: concoursId ?? this.concoursId,
      doubletteId: doubletteId ?? this.doubletteId,
      joueurA: joueurA ?? this.joueurA,
      joueurB: joueurB ?? this.joueurB,
      nomEquipe: nomEquipe ?? this.nomEquipe,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (concoursId.present) {
      map['concours_id'] = Variable<String>(concoursId.value);
    }
    if (doubletteId.present) {
      map['doublette_id'] = Variable<int>(doubletteId.value);
    }
    if (joueurA.present) {
      map['joueur_a'] = Variable<String>(joueurA.value);
    }
    if (joueurB.present) {
      map['joueur_b'] = Variable<String>(joueurB.value);
    }
    if (nomEquipe.present) {
      map['nom_equipe'] = Variable<String>(nomEquipe.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DoublettesTableCompanion(')
          ..write('concoursId: $concoursId, ')
          ..write('doubletteId: $doubletteId, ')
          ..write('joueurA: $joueurA, ')
          ..write('joueurB: $joueurB, ')
          ..write('nomEquipe: $nomEquipe, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ConcoursTableTable concoursTable = $ConcoursTableTable(this);
  late final $DoublettesTableTable doublettesTable = $DoublettesTableTable(
    this,
  );
  late final ConcoursDao concoursDao = ConcoursDao(this as AppDatabase);
  late final DoublettesDao doublettesDao = DoublettesDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    concoursTable,
    doublettesTable,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'concours_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('doublettes_table', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ConcoursTableTableCreateCompanionBuilder =
    ConcoursTableCompanion Function({
      required String id,
      required DateTime date,
      required String lieu,
      required String organisateur,
      Value<int> rowid,
    });
typedef $$ConcoursTableTableUpdateCompanionBuilder =
    ConcoursTableCompanion Function({
      Value<String> id,
      Value<DateTime> date,
      Value<String> lieu,
      Value<String> organisateur,
      Value<int> rowid,
    });

final class $$ConcoursTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $ConcoursTableTable, ConcoursTableData> {
  $$ConcoursTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$DoublettesTableTable, List<DoublettesTableData>>
  _doublettesTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.doublettesTable,
    aliasName: $_aliasNameGenerator(
      db.concoursTable.id,
      db.doublettesTable.concoursId,
    ),
  );

  $$DoublettesTableTableProcessedTableManager get doublettesTableRefs {
    final manager = $$DoublettesTableTableTableManager(
      $_db,
      $_db.doublettesTable,
    ).filter((f) => f.concoursId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _doublettesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ConcoursTableTableFilterComposer
    extends Composer<_$AppDatabase, $ConcoursTableTable> {
  $$ConcoursTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lieu => $composableBuilder(
    column: $table.lieu,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get organisateur => $composableBuilder(
    column: $table.organisateur,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> doublettesTableRefs(
    Expression<bool> Function($$DoublettesTableTableFilterComposer f) f,
  ) {
    final $$DoublettesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.doublettesTable,
      getReferencedColumn: (t) => t.concoursId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DoublettesTableTableFilterComposer(
            $db: $db,
            $table: $db.doublettesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ConcoursTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ConcoursTableTable> {
  $$ConcoursTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lieu => $composableBuilder(
    column: $table.lieu,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get organisateur => $composableBuilder(
    column: $table.organisateur,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConcoursTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConcoursTableTable> {
  $$ConcoursTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get lieu =>
      $composableBuilder(column: $table.lieu, builder: (column) => column);

  GeneratedColumn<String> get organisateur => $composableBuilder(
    column: $table.organisateur,
    builder: (column) => column,
  );

  Expression<T> doublettesTableRefs<T extends Object>(
    Expression<T> Function($$DoublettesTableTableAnnotationComposer a) f,
  ) {
    final $$DoublettesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.doublettesTable,
      getReferencedColumn: (t) => t.concoursId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DoublettesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.doublettesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ConcoursTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConcoursTableTable,
          ConcoursTableData,
          $$ConcoursTableTableFilterComposer,
          $$ConcoursTableTableOrderingComposer,
          $$ConcoursTableTableAnnotationComposer,
          $$ConcoursTableTableCreateCompanionBuilder,
          $$ConcoursTableTableUpdateCompanionBuilder,
          (ConcoursTableData, $$ConcoursTableTableReferences),
          ConcoursTableData,
          PrefetchHooks Function({bool doublettesTableRefs})
        > {
  $$ConcoursTableTableTableManager(_$AppDatabase db, $ConcoursTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConcoursTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConcoursTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConcoursTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> lieu = const Value.absent(),
                Value<String> organisateur = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConcoursTableCompanion(
                id: id,
                date: date,
                lieu: lieu,
                organisateur: organisateur,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime date,
                required String lieu,
                required String organisateur,
                Value<int> rowid = const Value.absent(),
              }) => ConcoursTableCompanion.insert(
                id: id,
                date: date,
                lieu: lieu,
                organisateur: organisateur,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ConcoursTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({doublettesTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (doublettesTableRefs) db.doublettesTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (doublettesTableRefs)
                    await $_getPrefetchedData<
                      ConcoursTableData,
                      $ConcoursTableTable,
                      DoublettesTableData
                    >(
                      currentTable: table,
                      referencedTable: $$ConcoursTableTableReferences
                          ._doublettesTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ConcoursTableTableReferences(
                            db,
                            table,
                            p0,
                          ).doublettesTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.concoursId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ConcoursTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConcoursTableTable,
      ConcoursTableData,
      $$ConcoursTableTableFilterComposer,
      $$ConcoursTableTableOrderingComposer,
      $$ConcoursTableTableAnnotationComposer,
      $$ConcoursTableTableCreateCompanionBuilder,
      $$ConcoursTableTableUpdateCompanionBuilder,
      (ConcoursTableData, $$ConcoursTableTableReferences),
      ConcoursTableData,
      PrefetchHooks Function({bool doublettesTableRefs})
    >;
typedef $$DoublettesTableTableCreateCompanionBuilder =
    DoublettesTableCompanion Function({
      required String concoursId,
      required int doubletteId,
      required String joueurA,
      required String joueurB,
      required String nomEquipe,
      Value<int> rowid,
    });
typedef $$DoublettesTableTableUpdateCompanionBuilder =
    DoublettesTableCompanion Function({
      Value<String> concoursId,
      Value<int> doubletteId,
      Value<String> joueurA,
      Value<String> joueurB,
      Value<String> nomEquipe,
      Value<int> rowid,
    });

final class $$DoublettesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $DoublettesTableTable,
          DoublettesTableData
        > {
  $$DoublettesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ConcoursTableTable _concoursIdTable(_$AppDatabase db) =>
      db.concoursTable.createAlias(
        $_aliasNameGenerator(
          db.doublettesTable.concoursId,
          db.concoursTable.id,
        ),
      );

  $$ConcoursTableTableProcessedTableManager get concoursId {
    final $_column = $_itemColumn<String>('concours_id')!;

    final manager = $$ConcoursTableTableTableManager(
      $_db,
      $_db.concoursTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_concoursIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DoublettesTableTableFilterComposer
    extends Composer<_$AppDatabase, $DoublettesTableTable> {
  $$DoublettesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get doubletteId => $composableBuilder(
    column: $table.doubletteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get joueurA => $composableBuilder(
    column: $table.joueurA,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get joueurB => $composableBuilder(
    column: $table.joueurB,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nomEquipe => $composableBuilder(
    column: $table.nomEquipe,
    builder: (column) => ColumnFilters(column),
  );

  $$ConcoursTableTableFilterComposer get concoursId {
    final $$ConcoursTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.concoursId,
      referencedTable: $db.concoursTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ConcoursTableTableFilterComposer(
            $db: $db,
            $table: $db.concoursTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DoublettesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DoublettesTableTable> {
  $$DoublettesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get doubletteId => $composableBuilder(
    column: $table.doubletteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get joueurA => $composableBuilder(
    column: $table.joueurA,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get joueurB => $composableBuilder(
    column: $table.joueurB,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nomEquipe => $composableBuilder(
    column: $table.nomEquipe,
    builder: (column) => ColumnOrderings(column),
  );

  $$ConcoursTableTableOrderingComposer get concoursId {
    final $$ConcoursTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.concoursId,
      referencedTable: $db.concoursTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ConcoursTableTableOrderingComposer(
            $db: $db,
            $table: $db.concoursTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DoublettesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DoublettesTableTable> {
  $$DoublettesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get doubletteId => $composableBuilder(
    column: $table.doubletteId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get joueurA =>
      $composableBuilder(column: $table.joueurA, builder: (column) => column);

  GeneratedColumn<String> get joueurB =>
      $composableBuilder(column: $table.joueurB, builder: (column) => column);

  GeneratedColumn<String> get nomEquipe =>
      $composableBuilder(column: $table.nomEquipe, builder: (column) => column);

  $$ConcoursTableTableAnnotationComposer get concoursId {
    final $$ConcoursTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.concoursId,
      referencedTable: $db.concoursTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ConcoursTableTableAnnotationComposer(
            $db: $db,
            $table: $db.concoursTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DoublettesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DoublettesTableTable,
          DoublettesTableData,
          $$DoublettesTableTableFilterComposer,
          $$DoublettesTableTableOrderingComposer,
          $$DoublettesTableTableAnnotationComposer,
          $$DoublettesTableTableCreateCompanionBuilder,
          $$DoublettesTableTableUpdateCompanionBuilder,
          (DoublettesTableData, $$DoublettesTableTableReferences),
          DoublettesTableData,
          PrefetchHooks Function({bool concoursId})
        > {
  $$DoublettesTableTableTableManager(
    _$AppDatabase db,
    $DoublettesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DoublettesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DoublettesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DoublettesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> concoursId = const Value.absent(),
                Value<int> doubletteId = const Value.absent(),
                Value<String> joueurA = const Value.absent(),
                Value<String> joueurB = const Value.absent(),
                Value<String> nomEquipe = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DoublettesTableCompanion(
                concoursId: concoursId,
                doubletteId: doubletteId,
                joueurA: joueurA,
                joueurB: joueurB,
                nomEquipe: nomEquipe,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String concoursId,
                required int doubletteId,
                required String joueurA,
                required String joueurB,
                required String nomEquipe,
                Value<int> rowid = const Value.absent(),
              }) => DoublettesTableCompanion.insert(
                concoursId: concoursId,
                doubletteId: doubletteId,
                joueurA: joueurA,
                joueurB: joueurB,
                nomEquipe: nomEquipe,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DoublettesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({concoursId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (concoursId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.concoursId,
                                referencedTable:
                                    $$DoublettesTableTableReferences
                                        ._concoursIdTable(db),
                                referencedColumn:
                                    $$DoublettesTableTableReferences
                                        ._concoursIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DoublettesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DoublettesTableTable,
      DoublettesTableData,
      $$DoublettesTableTableFilterComposer,
      $$DoublettesTableTableOrderingComposer,
      $$DoublettesTableTableAnnotationComposer,
      $$DoublettesTableTableCreateCompanionBuilder,
      $$DoublettesTableTableUpdateCompanionBuilder,
      (DoublettesTableData, $$DoublettesTableTableReferences),
      DoublettesTableData,
      PrefetchHooks Function({bool concoursId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ConcoursTableTableTableManager get concoursTable =>
      $$ConcoursTableTableTableManager(_db, _db.concoursTable);
  $$DoublettesTableTableTableManager get doublettesTable =>
      $$DoublettesTableTableTableManager(_db, _db.doublettesTable);
}
