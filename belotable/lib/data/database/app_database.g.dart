// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
mixin _$ConcoursDaoMixin on DatabaseAccessor<AppDatabase> {
  $ConcoursTableTable get concoursTable => attachedDatabase.concoursTable;
  ConcoursDaoManager get managers => ConcoursDaoManager(this);
}

class ConcoursDaoManager {
  final _$ConcoursDaoMixin _db;
  ConcoursDaoManager(this._db);
  $$ConcoursTableTableTableManager get concoursTable =>
      $$ConcoursTableTableTableManager(_db.attachedDatabase, _db.concoursTable);
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ConcoursTableTable concoursTable = $ConcoursTableTable(this);
  late final ConcoursDao concoursDao = ConcoursDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [concoursTable];
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
          (
            ConcoursTableData,
            BaseReferences<
              _$AppDatabase,
              $ConcoursTableTable,
              ConcoursTableData
            >,
          ),
          ConcoursTableData,
          PrefetchHooks Function()
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
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
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
      (
        ConcoursTableData,
        BaseReferences<_$AppDatabase, $ConcoursTableTable, ConcoursTableData>,
      ),
      ConcoursTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ConcoursTableTableTableManager get concoursTable =>
      $$ConcoursTableTableTableManager(_db, _db.concoursTable);
}
