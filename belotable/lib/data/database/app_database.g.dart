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

mixin _$ManchesDaoMixin on DatabaseAccessor<AppDatabase> {
  $ConcoursTableTable get concoursTable => attachedDatabase.concoursTable;
  $ManchesTableTable get manchesTable => attachedDatabase.manchesTable;
  $TablesDeJeuTableTable get tablesDeJeuTable =>
      attachedDatabase.tablesDeJeuTable;
  $TableDoublettesTableTable get tableDoublettesTable =>
      attachedDatabase.tableDoublettesTable;
  $DoublettesTableTable get doublettesTable => attachedDatabase.doublettesTable;
  ManchesDaoManager get managers => ManchesDaoManager(this);
}

class ManchesDaoManager {
  final _$ManchesDaoMixin _db;
  ManchesDaoManager(this._db);
  $$ConcoursTableTableTableManager get concoursTable =>
      $$ConcoursTableTableTableManager(_db.attachedDatabase, _db.concoursTable);
  $$ManchesTableTableTableManager get manchesTable =>
      $$ManchesTableTableTableManager(_db.attachedDatabase, _db.manchesTable);
  $$TablesDeJeuTableTableTableManager get tablesDeJeuTable =>
      $$TablesDeJeuTableTableTableManager(
        _db.attachedDatabase,
        _db.tablesDeJeuTable,
      );
  $$TableDoublettesTableTableTableManager get tableDoublettesTable =>
      $$TableDoublettesTableTableTableManager(
        _db.attachedDatabase,
        _db.tableDoublettesTable,
      );
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
  static const VerificationMeta _nombreDonnesParMancheMeta =
      const VerificationMeta('nombreDonnesParManche');
  @override
  late final GeneratedColumn<int> nombreDonnesParManche = GeneratedColumn<int>(
    'nombre_donnes_par_manche',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _nombreMaxPointsParDonneMeta =
      const VerificationMeta('nombreMaxPointsParDonne');
  @override
  late final GeneratedColumn<int> nombreMaxPointsParDonne =
      GeneratedColumn<int>(
        'nombre_max_points_par_donne',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(162),
      );
  static const VerificationMeta _reglesJeuMeta = const VerificationMeta(
    'reglesJeu',
  );
  @override
  late final GeneratedColumn<String> reglesJeu = GeneratedColumn<String>(
    'regles_jeu',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statutConcoursMeta = const VerificationMeta(
    'statutConcours',
  );
  @override
  late final GeneratedColumn<String> statutConcours = GeneratedColumn<String>(
    'statut_concours',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('initialisation'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    lieu,
    organisateur,
    nombreDonnesParManche,
    nombreMaxPointsParDonne,
    reglesJeu,
    statutConcours,
  ];
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
    if (data.containsKey('nombre_donnes_par_manche')) {
      context.handle(
        _nombreDonnesParMancheMeta,
        nombreDonnesParManche.isAcceptableOrUnknown(
          data['nombre_donnes_par_manche']!,
          _nombreDonnesParMancheMeta,
        ),
      );
    }
    if (data.containsKey('nombre_max_points_par_donne')) {
      context.handle(
        _nombreMaxPointsParDonneMeta,
        nombreMaxPointsParDonne.isAcceptableOrUnknown(
          data['nombre_max_points_par_donne']!,
          _nombreMaxPointsParDonneMeta,
        ),
      );
    }
    if (data.containsKey('regles_jeu')) {
      context.handle(
        _reglesJeuMeta,
        reglesJeu.isAcceptableOrUnknown(data['regles_jeu']!, _reglesJeuMeta),
      );
    } else if (isInserting) {
      context.missing(_reglesJeuMeta);
    }
    if (data.containsKey('statut_concours')) {
      context.handle(
        _statutConcoursMeta,
        statutConcours.isAcceptableOrUnknown(
          data['statut_concours']!,
          _statutConcoursMeta,
        ),
      );
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
      nombreDonnesParManche: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nombre_donnes_par_manche'],
      )!,
      nombreMaxPointsParDonne: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nombre_max_points_par_donne'],
      )!,
      reglesJeu: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}regles_jeu'],
      )!,
      statutConcours: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}statut_concours'],
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

  /// Number of deals per round.
  final int nombreDonnesParManche;

  /// Maximum points per deal.
  final int nombreMaxPointsParDonne;

  /// Game rules text.
  final String reglesJeu;

  /// Contest status: Initialisation, EnCours, Termine.
  final String statutConcours;
  const ConcoursTableData({
    required this.id,
    required this.date,
    required this.lieu,
    required this.organisateur,
    required this.nombreDonnesParManche,
    required this.nombreMaxPointsParDonne,
    required this.reglesJeu,
    required this.statutConcours,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<DateTime>(date);
    map['lieu'] = Variable<String>(lieu);
    map['organisateur'] = Variable<String>(organisateur);
    map['nombre_donnes_par_manche'] = Variable<int>(nombreDonnesParManche);
    map['nombre_max_points_par_donne'] = Variable<int>(nombreMaxPointsParDonne);
    map['regles_jeu'] = Variable<String>(reglesJeu);
    map['statut_concours'] = Variable<String>(statutConcours);
    return map;
  }

  ConcoursTableCompanion toCompanion(bool nullToAbsent) {
    return ConcoursTableCompanion(
      id: Value(id),
      date: Value(date),
      lieu: Value(lieu),
      organisateur: Value(organisateur),
      nombreDonnesParManche: Value(nombreDonnesParManche),
      nombreMaxPointsParDonne: Value(nombreMaxPointsParDonne),
      reglesJeu: Value(reglesJeu),
      statutConcours: Value(statutConcours),
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
      nombreDonnesParManche: serializer.fromJson<int>(
        json['nombreDonnesParManche'],
      ),
      nombreMaxPointsParDonne: serializer.fromJson<int>(
        json['nombreMaxPointsParDonne'],
      ),
      reglesJeu: serializer.fromJson<String>(json['reglesJeu']),
      statutConcours: serializer.fromJson<String>(json['statutConcours']),
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
      'nombreDonnesParManche': serializer.toJson<int>(nombreDonnesParManche),
      'nombreMaxPointsParDonne': serializer.toJson<int>(
        nombreMaxPointsParDonne,
      ),
      'reglesJeu': serializer.toJson<String>(reglesJeu),
      'statutConcours': serializer.toJson<String>(statutConcours),
    };
  }

  ConcoursTableData copyWith({
    String? id,
    DateTime? date,
    String? lieu,
    String? organisateur,
    int? nombreDonnesParManche,
    int? nombreMaxPointsParDonne,
    String? reglesJeu,
    String? statutConcours,
  }) => ConcoursTableData(
    id: id ?? this.id,
    date: date ?? this.date,
    lieu: lieu ?? this.lieu,
    organisateur: organisateur ?? this.organisateur,
    nombreDonnesParManche: nombreDonnesParManche ?? this.nombreDonnesParManche,
    nombreMaxPointsParDonne:
        nombreMaxPointsParDonne ?? this.nombreMaxPointsParDonne,
    reglesJeu: reglesJeu ?? this.reglesJeu,
    statutConcours: statutConcours ?? this.statutConcours,
  );
  ConcoursTableData copyWithCompanion(ConcoursTableCompanion data) {
    return ConcoursTableData(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      lieu: data.lieu.present ? data.lieu.value : this.lieu,
      organisateur: data.organisateur.present
          ? data.organisateur.value
          : this.organisateur,
      nombreDonnesParManche: data.nombreDonnesParManche.present
          ? data.nombreDonnesParManche.value
          : this.nombreDonnesParManche,
      nombreMaxPointsParDonne: data.nombreMaxPointsParDonne.present
          ? data.nombreMaxPointsParDonne.value
          : this.nombreMaxPointsParDonne,
      reglesJeu: data.reglesJeu.present ? data.reglesJeu.value : this.reglesJeu,
      statutConcours: data.statutConcours.present
          ? data.statutConcours.value
          : this.statutConcours,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConcoursTableData(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('lieu: $lieu, ')
          ..write('organisateur: $organisateur, ')
          ..write('nombreDonnesParManche: $nombreDonnesParManche, ')
          ..write('nombreMaxPointsParDonne: $nombreMaxPointsParDonne, ')
          ..write('reglesJeu: $reglesJeu, ')
          ..write('statutConcours: $statutConcours')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    lieu,
    organisateur,
    nombreDonnesParManche,
    nombreMaxPointsParDonne,
    reglesJeu,
    statutConcours,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConcoursTableData &&
          other.id == this.id &&
          other.date == this.date &&
          other.lieu == this.lieu &&
          other.organisateur == this.organisateur &&
          other.nombreDonnesParManche == this.nombreDonnesParManche &&
          other.nombreMaxPointsParDonne == this.nombreMaxPointsParDonne &&
          other.reglesJeu == this.reglesJeu &&
          other.statutConcours == this.statutConcours);
}

class ConcoursTableCompanion extends UpdateCompanion<ConcoursTableData> {
  final Value<String> id;
  final Value<DateTime> date;
  final Value<String> lieu;
  final Value<String> organisateur;
  final Value<int> nombreDonnesParManche;
  final Value<int> nombreMaxPointsParDonne;
  final Value<String> reglesJeu;
  final Value<String> statutConcours;
  final Value<int> rowid;
  const ConcoursTableCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.lieu = const Value.absent(),
    this.organisateur = const Value.absent(),
    this.nombreDonnesParManche = const Value.absent(),
    this.nombreMaxPointsParDonne = const Value.absent(),
    this.reglesJeu = const Value.absent(),
    this.statutConcours = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConcoursTableCompanion.insert({
    required String id,
    required DateTime date,
    required String lieu,
    required String organisateur,
    this.nombreDonnesParManche = const Value.absent(),
    this.nombreMaxPointsParDonne = const Value.absent(),
    required String reglesJeu,
    this.statutConcours = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       lieu = Value(lieu),
       organisateur = Value(organisateur),
       reglesJeu = Value(reglesJeu);
  static Insertable<ConcoursTableData> custom({
    Expression<String>? id,
    Expression<DateTime>? date,
    Expression<String>? lieu,
    Expression<String>? organisateur,
    Expression<int>? nombreDonnesParManche,
    Expression<int>? nombreMaxPointsParDonne,
    Expression<String>? reglesJeu,
    Expression<String>? statutConcours,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (lieu != null) 'lieu': lieu,
      if (organisateur != null) 'organisateur': organisateur,
      if (nombreDonnesParManche != null)
        'nombre_donnes_par_manche': nombreDonnesParManche,
      if (nombreMaxPointsParDonne != null)
        'nombre_max_points_par_donne': nombreMaxPointsParDonne,
      if (reglesJeu != null) 'regles_jeu': reglesJeu,
      if (statutConcours != null) 'statut_concours': statutConcours,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConcoursTableCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? date,
    Value<String>? lieu,
    Value<String>? organisateur,
    Value<int>? nombreDonnesParManche,
    Value<int>? nombreMaxPointsParDonne,
    Value<String>? reglesJeu,
    Value<String>? statutConcours,
    Value<int>? rowid,
  }) {
    return ConcoursTableCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      lieu: lieu ?? this.lieu,
      organisateur: organisateur ?? this.organisateur,
      nombreDonnesParManche:
          nombreDonnesParManche ?? this.nombreDonnesParManche,
      nombreMaxPointsParDonne:
          nombreMaxPointsParDonne ?? this.nombreMaxPointsParDonne,
      reglesJeu: reglesJeu ?? this.reglesJeu,
      statutConcours: statutConcours ?? this.statutConcours,
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
    if (nombreDonnesParManche.present) {
      map['nombre_donnes_par_manche'] = Variable<int>(
        nombreDonnesParManche.value,
      );
    }
    if (nombreMaxPointsParDonne.present) {
      map['nombre_max_points_par_donne'] = Variable<int>(
        nombreMaxPointsParDonne.value,
      );
    }
    if (reglesJeu.present) {
      map['regles_jeu'] = Variable<String>(reglesJeu.value);
    }
    if (statutConcours.present) {
      map['statut_concours'] = Variable<String>(statutConcours.value);
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
          ..write('nombreDonnesParManche: $nombreDonnesParManche, ')
          ..write('nombreMaxPointsParDonne: $nombreMaxPointsParDonne, ')
          ..write('reglesJeu: $reglesJeu, ')
          ..write('statutConcours: $statutConcours, ')
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

class $ManchesTableTable extends ManchesTable
    with TableInfo<$ManchesTableTable, ManchesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ManchesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
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
  static const VerificationMeta _numeroMeta = const VerificationMeta('numero');
  @override
  late final GeneratedColumn<int> numero = GeneratedColumn<int>(
    'numero',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, concoursId, numero];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'manches_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ManchesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('concours_id')) {
      context.handle(
        _concoursIdMeta,
        concoursId.isAcceptableOrUnknown(data['concours_id']!, _concoursIdMeta),
      );
    } else if (isInserting) {
      context.missing(_concoursIdMeta);
    }
    if (data.containsKey('numero')) {
      context.handle(
        _numeroMeta,
        numero.isAcceptableOrUnknown(data['numero']!, _numeroMeta),
      );
    } else if (isInserting) {
      context.missing(_numeroMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ManchesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ManchesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      concoursId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}concours_id'],
      )!,
      numero: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}numero'],
      )!,
    );
  }

  @override
  $ManchesTableTable createAlias(String alias) {
    return $ManchesTableTable(attachedDatabase, alias);
  }
}

class ManchesTableData extends DataClass
    implements Insertable<ManchesTableData> {
  /// Auto-incremented primary key.
  final int id;

  /// Owning concours id.
  final String concoursId;

  /// Round number, starting at 1.
  final int numero;
  const ManchesTableData({
    required this.id,
    required this.concoursId,
    required this.numero,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['concours_id'] = Variable<String>(concoursId);
    map['numero'] = Variable<int>(numero);
    return map;
  }

  ManchesTableCompanion toCompanion(bool nullToAbsent) {
    return ManchesTableCompanion(
      id: Value(id),
      concoursId: Value(concoursId),
      numero: Value(numero),
    );
  }

  factory ManchesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ManchesTableData(
      id: serializer.fromJson<int>(json['id']),
      concoursId: serializer.fromJson<String>(json['concoursId']),
      numero: serializer.fromJson<int>(json['numero']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'concoursId': serializer.toJson<String>(concoursId),
      'numero': serializer.toJson<int>(numero),
    };
  }

  ManchesTableData copyWith({int? id, String? concoursId, int? numero}) =>
      ManchesTableData(
        id: id ?? this.id,
        concoursId: concoursId ?? this.concoursId,
        numero: numero ?? this.numero,
      );
  ManchesTableData copyWithCompanion(ManchesTableCompanion data) {
    return ManchesTableData(
      id: data.id.present ? data.id.value : this.id,
      concoursId: data.concoursId.present
          ? data.concoursId.value
          : this.concoursId,
      numero: data.numero.present ? data.numero.value : this.numero,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ManchesTableData(')
          ..write('id: $id, ')
          ..write('concoursId: $concoursId, ')
          ..write('numero: $numero')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, concoursId, numero);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ManchesTableData &&
          other.id == this.id &&
          other.concoursId == this.concoursId &&
          other.numero == this.numero);
}

class ManchesTableCompanion extends UpdateCompanion<ManchesTableData> {
  final Value<int> id;
  final Value<String> concoursId;
  final Value<int> numero;
  const ManchesTableCompanion({
    this.id = const Value.absent(),
    this.concoursId = const Value.absent(),
    this.numero = const Value.absent(),
  });
  ManchesTableCompanion.insert({
    this.id = const Value.absent(),
    required String concoursId,
    required int numero,
  }) : concoursId = Value(concoursId),
       numero = Value(numero);
  static Insertable<ManchesTableData> custom({
    Expression<int>? id,
    Expression<String>? concoursId,
    Expression<int>? numero,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (concoursId != null) 'concours_id': concoursId,
      if (numero != null) 'numero': numero,
    });
  }

  ManchesTableCompanion copyWith({
    Value<int>? id,
    Value<String>? concoursId,
    Value<int>? numero,
  }) {
    return ManchesTableCompanion(
      id: id ?? this.id,
      concoursId: concoursId ?? this.concoursId,
      numero: numero ?? this.numero,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (concoursId.present) {
      map['concours_id'] = Variable<String>(concoursId.value);
    }
    if (numero.present) {
      map['numero'] = Variable<int>(numero.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ManchesTableCompanion(')
          ..write('id: $id, ')
          ..write('concoursId: $concoursId, ')
          ..write('numero: $numero')
          ..write(')'))
        .toString();
  }
}

class $TablesDeJeuTableTable extends TablesDeJeuTable
    with TableInfo<$TablesDeJeuTableTable, TablesDeJeuTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TablesDeJeuTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _mancheIdMeta = const VerificationMeta(
    'mancheId',
  );
  @override
  late final GeneratedColumn<int> mancheId = GeneratedColumn<int>(
    'manche_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES manches_table (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _numeroMeta = const VerificationMeta('numero');
  @override
  late final GeneratedColumn<int> numero = GeneratedColumn<int>(
    'numero',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statutMeta = const VerificationMeta('statut');
  @override
  late final GeneratedColumn<String> statut = GeneratedColumn<String>(
    'statut',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('En attente'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, mancheId, numero, statut];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tables_de_jeu_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TablesDeJeuTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('manche_id')) {
      context.handle(
        _mancheIdMeta,
        mancheId.isAcceptableOrUnknown(data['manche_id']!, _mancheIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mancheIdMeta);
    }
    if (data.containsKey('numero')) {
      context.handle(
        _numeroMeta,
        numero.isAcceptableOrUnknown(data['numero']!, _numeroMeta),
      );
    } else if (isInserting) {
      context.missing(_numeroMeta);
    }
    if (data.containsKey('statut')) {
      context.handle(
        _statutMeta,
        statut.isAcceptableOrUnknown(data['statut']!, _statutMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TablesDeJeuTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TablesDeJeuTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      mancheId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}manche_id'],
      )!,
      numero: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}numero'],
      )!,
      statut: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}statut'],
      )!,
    );
  }

  @override
  $TablesDeJeuTableTable createAlias(String alias) {
    return $TablesDeJeuTableTable(attachedDatabase, alias);
  }
}

class TablesDeJeuTableData extends DataClass
    implements Insertable<TablesDeJeuTableData> {
  /// Auto-incremented primary key.
  final int id;

  /// Owning manche id.
  final int mancheId;

  /// Table number within round, starting at 1.
  final int numero;

  /// Computed status stored as string.
  final String statut;
  const TablesDeJeuTableData({
    required this.id,
    required this.mancheId,
    required this.numero,
    required this.statut,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['manche_id'] = Variable<int>(mancheId);
    map['numero'] = Variable<int>(numero);
    map['statut'] = Variable<String>(statut);
    return map;
  }

  TablesDeJeuTableCompanion toCompanion(bool nullToAbsent) {
    return TablesDeJeuTableCompanion(
      id: Value(id),
      mancheId: Value(mancheId),
      numero: Value(numero),
      statut: Value(statut),
    );
  }

  factory TablesDeJeuTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TablesDeJeuTableData(
      id: serializer.fromJson<int>(json['id']),
      mancheId: serializer.fromJson<int>(json['mancheId']),
      numero: serializer.fromJson<int>(json['numero']),
      statut: serializer.fromJson<String>(json['statut']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mancheId': serializer.toJson<int>(mancheId),
      'numero': serializer.toJson<int>(numero),
      'statut': serializer.toJson<String>(statut),
    };
  }

  TablesDeJeuTableData copyWith({
    int? id,
    int? mancheId,
    int? numero,
    String? statut,
  }) => TablesDeJeuTableData(
    id: id ?? this.id,
    mancheId: mancheId ?? this.mancheId,
    numero: numero ?? this.numero,
    statut: statut ?? this.statut,
  );
  TablesDeJeuTableData copyWithCompanion(TablesDeJeuTableCompanion data) {
    return TablesDeJeuTableData(
      id: data.id.present ? data.id.value : this.id,
      mancheId: data.mancheId.present ? data.mancheId.value : this.mancheId,
      numero: data.numero.present ? data.numero.value : this.numero,
      statut: data.statut.present ? data.statut.value : this.statut,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TablesDeJeuTableData(')
          ..write('id: $id, ')
          ..write('mancheId: $mancheId, ')
          ..write('numero: $numero, ')
          ..write('statut: $statut')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, mancheId, numero, statut);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TablesDeJeuTableData &&
          other.id == this.id &&
          other.mancheId == this.mancheId &&
          other.numero == this.numero &&
          other.statut == this.statut);
}

class TablesDeJeuTableCompanion extends UpdateCompanion<TablesDeJeuTableData> {
  final Value<int> id;
  final Value<int> mancheId;
  final Value<int> numero;
  final Value<String> statut;
  const TablesDeJeuTableCompanion({
    this.id = const Value.absent(),
    this.mancheId = const Value.absent(),
    this.numero = const Value.absent(),
    this.statut = const Value.absent(),
  });
  TablesDeJeuTableCompanion.insert({
    this.id = const Value.absent(),
    required int mancheId,
    required int numero,
    this.statut = const Value.absent(),
  }) : mancheId = Value(mancheId),
       numero = Value(numero);
  static Insertable<TablesDeJeuTableData> custom({
    Expression<int>? id,
    Expression<int>? mancheId,
    Expression<int>? numero,
    Expression<String>? statut,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mancheId != null) 'manche_id': mancheId,
      if (numero != null) 'numero': numero,
      if (statut != null) 'statut': statut,
    });
  }

  TablesDeJeuTableCompanion copyWith({
    Value<int>? id,
    Value<int>? mancheId,
    Value<int>? numero,
    Value<String>? statut,
  }) {
    return TablesDeJeuTableCompanion(
      id: id ?? this.id,
      mancheId: mancheId ?? this.mancheId,
      numero: numero ?? this.numero,
      statut: statut ?? this.statut,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mancheId.present) {
      map['manche_id'] = Variable<int>(mancheId.value);
    }
    if (numero.present) {
      map['numero'] = Variable<int>(numero.value);
    }
    if (statut.present) {
      map['statut'] = Variable<String>(statut.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TablesDeJeuTableCompanion(')
          ..write('id: $id, ')
          ..write('mancheId: $mancheId, ')
          ..write('numero: $numero, ')
          ..write('statut: $statut')
          ..write(')'))
        .toString();
  }
}

class $TableDoublettesTableTable extends TableDoublettesTable
    with TableInfo<$TableDoublettesTableTable, TableDoublettesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TableDoublettesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tableIdMeta = const VerificationMeta(
    'tableId',
  );
  @override
  late final GeneratedColumn<int> tableId = GeneratedColumn<int>(
    'table_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tables_de_jeu_table (id) ON DELETE CASCADE',
    ),
  );
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
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statutMeta = const VerificationMeta('statut');
  @override
  late final GeneratedColumn<String> statut = GeneratedColumn<String>(
    'statut',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('En attente'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    tableId,
    concoursId,
    doubletteId,
    score,
    statut,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'table_doublettes_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TableDoublettesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('table_id')) {
      context.handle(
        _tableIdMeta,
        tableId.isAcceptableOrUnknown(data['table_id']!, _tableIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tableIdMeta);
    }
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
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    }
    if (data.containsKey('statut')) {
      context.handle(
        _statutMeta,
        statut.isAcceptableOrUnknown(data['statut']!, _statutMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {tableId, concoursId, doubletteId};
  @override
  TableDoublettesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TableDoublettesTableData(
      tableId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}table_id'],
      )!,
      concoursId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}concours_id'],
      )!,
      doubletteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}doublette_id'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      )!,
      statut: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}statut'],
      )!,
    );
  }

  @override
  $TableDoublettesTableTable createAlias(String alias) {
    return $TableDoublettesTableTable(attachedDatabase, alias);
  }
}

class TableDoublettesTableData extends DataClass
    implements Insertable<TableDoublettesTableData> {
  /// Owning table id.
  final int tableId;

  /// Owning concours id (matches doublette scope).
  final String concoursId;

  /// Doublette registration id.
  final int doubletteId;

  /// Score achieved in this table.
  final int score;

  /// Team status in this table stored as string.
  final String statut;
  const TableDoublettesTableData({
    required this.tableId,
    required this.concoursId,
    required this.doubletteId,
    required this.score,
    required this.statut,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['table_id'] = Variable<int>(tableId);
    map['concours_id'] = Variable<String>(concoursId);
    map['doublette_id'] = Variable<int>(doubletteId);
    map['score'] = Variable<int>(score);
    map['statut'] = Variable<String>(statut);
    return map;
  }

  TableDoublettesTableCompanion toCompanion(bool nullToAbsent) {
    return TableDoublettesTableCompanion(
      tableId: Value(tableId),
      concoursId: Value(concoursId),
      doubletteId: Value(doubletteId),
      score: Value(score),
      statut: Value(statut),
    );
  }

  factory TableDoublettesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TableDoublettesTableData(
      tableId: serializer.fromJson<int>(json['tableId']),
      concoursId: serializer.fromJson<String>(json['concoursId']),
      doubletteId: serializer.fromJson<int>(json['doubletteId']),
      score: serializer.fromJson<int>(json['score']),
      statut: serializer.fromJson<String>(json['statut']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'tableId': serializer.toJson<int>(tableId),
      'concoursId': serializer.toJson<String>(concoursId),
      'doubletteId': serializer.toJson<int>(doubletteId),
      'score': serializer.toJson<int>(score),
      'statut': serializer.toJson<String>(statut),
    };
  }

  TableDoublettesTableData copyWith({
    int? tableId,
    String? concoursId,
    int? doubletteId,
    int? score,
    String? statut,
  }) => TableDoublettesTableData(
    tableId: tableId ?? this.tableId,
    concoursId: concoursId ?? this.concoursId,
    doubletteId: doubletteId ?? this.doubletteId,
    score: score ?? this.score,
    statut: statut ?? this.statut,
  );
  TableDoublettesTableData copyWithCompanion(
    TableDoublettesTableCompanion data,
  ) {
    return TableDoublettesTableData(
      tableId: data.tableId.present ? data.tableId.value : this.tableId,
      concoursId: data.concoursId.present
          ? data.concoursId.value
          : this.concoursId,
      doubletteId: data.doubletteId.present
          ? data.doubletteId.value
          : this.doubletteId,
      score: data.score.present ? data.score.value : this.score,
      statut: data.statut.present ? data.statut.value : this.statut,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TableDoublettesTableData(')
          ..write('tableId: $tableId, ')
          ..write('concoursId: $concoursId, ')
          ..write('doubletteId: $doubletteId, ')
          ..write('score: $score, ')
          ..write('statut: $statut')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(tableId, concoursId, doubletteId, score, statut);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TableDoublettesTableData &&
          other.tableId == this.tableId &&
          other.concoursId == this.concoursId &&
          other.doubletteId == this.doubletteId &&
          other.score == this.score &&
          other.statut == this.statut);
}

class TableDoublettesTableCompanion
    extends UpdateCompanion<TableDoublettesTableData> {
  final Value<int> tableId;
  final Value<String> concoursId;
  final Value<int> doubletteId;
  final Value<int> score;
  final Value<String> statut;
  final Value<int> rowid;
  const TableDoublettesTableCompanion({
    this.tableId = const Value.absent(),
    this.concoursId = const Value.absent(),
    this.doubletteId = const Value.absent(),
    this.score = const Value.absent(),
    this.statut = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TableDoublettesTableCompanion.insert({
    required int tableId,
    required String concoursId,
    required int doubletteId,
    this.score = const Value.absent(),
    this.statut = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : tableId = Value(tableId),
       concoursId = Value(concoursId),
       doubletteId = Value(doubletteId);
  static Insertable<TableDoublettesTableData> custom({
    Expression<int>? tableId,
    Expression<String>? concoursId,
    Expression<int>? doubletteId,
    Expression<int>? score,
    Expression<String>? statut,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (tableId != null) 'table_id': tableId,
      if (concoursId != null) 'concours_id': concoursId,
      if (doubletteId != null) 'doublette_id': doubletteId,
      if (score != null) 'score': score,
      if (statut != null) 'statut': statut,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TableDoublettesTableCompanion copyWith({
    Value<int>? tableId,
    Value<String>? concoursId,
    Value<int>? doubletteId,
    Value<int>? score,
    Value<String>? statut,
    Value<int>? rowid,
  }) {
    return TableDoublettesTableCompanion(
      tableId: tableId ?? this.tableId,
      concoursId: concoursId ?? this.concoursId,
      doubletteId: doubletteId ?? this.doubletteId,
      score: score ?? this.score,
      statut: statut ?? this.statut,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (tableId.present) {
      map['table_id'] = Variable<int>(tableId.value);
    }
    if (concoursId.present) {
      map['concours_id'] = Variable<String>(concoursId.value);
    }
    if (doubletteId.present) {
      map['doublette_id'] = Variable<int>(doubletteId.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (statut.present) {
      map['statut'] = Variable<String>(statut.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TableDoublettesTableCompanion(')
          ..write('tableId: $tableId, ')
          ..write('concoursId: $concoursId, ')
          ..write('doubletteId: $doubletteId, ')
          ..write('score: $score, ')
          ..write('statut: $statut, ')
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
  late final $ManchesTableTable manchesTable = $ManchesTableTable(this);
  late final $TablesDeJeuTableTable tablesDeJeuTable = $TablesDeJeuTableTable(
    this,
  );
  late final $TableDoublettesTableTable tableDoublettesTable =
      $TableDoublettesTableTable(this);
  late final ConcoursDao concoursDao = ConcoursDao(this as AppDatabase);
  late final DoublettesDao doublettesDao = DoublettesDao(this as AppDatabase);
  late final ManchesDao manchesDao = ManchesDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    concoursTable,
    doublettesTable,
    manchesTable,
    tablesDeJeuTable,
    tableDoublettesTable,
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
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'concours_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('manches_table', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'manches_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('tables_de_jeu_table', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tables_de_jeu_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('table_doublettes_table', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ConcoursTableTableCreateCompanionBuilder =
    ConcoursTableCompanion Function({
      required String id,
      required DateTime date,
      required String lieu,
      required String organisateur,
      Value<int> nombreDonnesParManche,
      Value<int> nombreMaxPointsParDonne,
      required String reglesJeu,
      Value<String> statutConcours,
      Value<int> rowid,
    });
typedef $$ConcoursTableTableUpdateCompanionBuilder =
    ConcoursTableCompanion Function({
      Value<String> id,
      Value<DateTime> date,
      Value<String> lieu,
      Value<String> organisateur,
      Value<int> nombreDonnesParManche,
      Value<int> nombreMaxPointsParDonne,
      Value<String> reglesJeu,
      Value<String> statutConcours,
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

  static MultiTypedResultKey<$ManchesTableTable, List<ManchesTableData>>
  _manchesTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.manchesTable,
    aliasName: $_aliasNameGenerator(
      db.concoursTable.id,
      db.manchesTable.concoursId,
    ),
  );

  $$ManchesTableTableProcessedTableManager get manchesTableRefs {
    final manager = $$ManchesTableTableTableManager(
      $_db,
      $_db.manchesTable,
    ).filter((f) => f.concoursId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_manchesTableRefsTable($_db));
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

  ColumnFilters<int> get nombreDonnesParManche => $composableBuilder(
    column: $table.nombreDonnesParManche,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nombreMaxPointsParDonne => $composableBuilder(
    column: $table.nombreMaxPointsParDonne,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reglesJeu => $composableBuilder(
    column: $table.reglesJeu,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get statutConcours => $composableBuilder(
    column: $table.statutConcours,
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

  Expression<bool> manchesTableRefs(
    Expression<bool> Function($$ManchesTableTableFilterComposer f) f,
  ) {
    final $$ManchesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.manchesTable,
      getReferencedColumn: (t) => t.concoursId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ManchesTableTableFilterComposer(
            $db: $db,
            $table: $db.manchesTable,
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

  ColumnOrderings<int> get nombreDonnesParManche => $composableBuilder(
    column: $table.nombreDonnesParManche,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nombreMaxPointsParDonne => $composableBuilder(
    column: $table.nombreMaxPointsParDonne,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reglesJeu => $composableBuilder(
    column: $table.reglesJeu,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get statutConcours => $composableBuilder(
    column: $table.statutConcours,
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

  GeneratedColumn<int> get nombreDonnesParManche => $composableBuilder(
    column: $table.nombreDonnesParManche,
    builder: (column) => column,
  );

  GeneratedColumn<int> get nombreMaxPointsParDonne => $composableBuilder(
    column: $table.nombreMaxPointsParDonne,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reglesJeu =>
      $composableBuilder(column: $table.reglesJeu, builder: (column) => column);

  GeneratedColumn<String> get statutConcours => $composableBuilder(
    column: $table.statutConcours,
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

  Expression<T> manchesTableRefs<T extends Object>(
    Expression<T> Function($$ManchesTableTableAnnotationComposer a) f,
  ) {
    final $$ManchesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.manchesTable,
      getReferencedColumn: (t) => t.concoursId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ManchesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.manchesTable,
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
          PrefetchHooks Function({
            bool doublettesTableRefs,
            bool manchesTableRefs,
          })
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
                Value<int> nombreDonnesParManche = const Value.absent(),
                Value<int> nombreMaxPointsParDonne = const Value.absent(),
                Value<String> reglesJeu = const Value.absent(),
                Value<String> statutConcours = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConcoursTableCompanion(
                id: id,
                date: date,
                lieu: lieu,
                organisateur: organisateur,
                nombreDonnesParManche: nombreDonnesParManche,
                nombreMaxPointsParDonne: nombreMaxPointsParDonne,
                reglesJeu: reglesJeu,
                statutConcours: statutConcours,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime date,
                required String lieu,
                required String organisateur,
                Value<int> nombreDonnesParManche = const Value.absent(),
                Value<int> nombreMaxPointsParDonne = const Value.absent(),
                required String reglesJeu,
                Value<String> statutConcours = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConcoursTableCompanion.insert(
                id: id,
                date: date,
                lieu: lieu,
                organisateur: organisateur,
                nombreDonnesParManche: nombreDonnesParManche,
                nombreMaxPointsParDonne: nombreMaxPointsParDonne,
                reglesJeu: reglesJeu,
                statutConcours: statutConcours,
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
          prefetchHooksCallback:
              ({doublettesTableRefs = false, manchesTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (doublettesTableRefs) db.doublettesTable,
                    if (manchesTableRefs) db.manchesTable,
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
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.concoursId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (manchesTableRefs)
                        await $_getPrefetchedData<
                          ConcoursTableData,
                          $ConcoursTableTable,
                          ManchesTableData
                        >(
                          currentTable: table,
                          referencedTable: $$ConcoursTableTableReferences
                              ._manchesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ConcoursTableTableReferences(
                                db,
                                table,
                                p0,
                              ).manchesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.concoursId == item.id,
                              ),
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
      PrefetchHooks Function({bool doublettesTableRefs, bool manchesTableRefs})
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
typedef $$ManchesTableTableCreateCompanionBuilder =
    ManchesTableCompanion Function({
      Value<int> id,
      required String concoursId,
      required int numero,
    });
typedef $$ManchesTableTableUpdateCompanionBuilder =
    ManchesTableCompanion Function({
      Value<int> id,
      Value<String> concoursId,
      Value<int> numero,
    });

final class $$ManchesTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $ManchesTableTable, ManchesTableData> {
  $$ManchesTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ConcoursTableTable _concoursIdTable(_$AppDatabase db) =>
      db.concoursTable.createAlias(
        $_aliasNameGenerator(db.manchesTable.concoursId, db.concoursTable.id),
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

  static MultiTypedResultKey<$TablesDeJeuTableTable, List<TablesDeJeuTableData>>
  _tablesDeJeuTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.tablesDeJeuTable,
    aliasName: $_aliasNameGenerator(
      db.manchesTable.id,
      db.tablesDeJeuTable.mancheId,
    ),
  );

  $$TablesDeJeuTableTableProcessedTableManager get tablesDeJeuTableRefs {
    final manager = $$TablesDeJeuTableTableTableManager(
      $_db,
      $_db.tablesDeJeuTable,
    ).filter((f) => f.mancheId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _tablesDeJeuTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ManchesTableTableFilterComposer
    extends Composer<_$AppDatabase, $ManchesTableTable> {
  $$ManchesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get numero => $composableBuilder(
    column: $table.numero,
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

  Expression<bool> tablesDeJeuTableRefs(
    Expression<bool> Function($$TablesDeJeuTableTableFilterComposer f) f,
  ) {
    final $$TablesDeJeuTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tablesDeJeuTable,
      getReferencedColumn: (t) => t.mancheId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TablesDeJeuTableTableFilterComposer(
            $db: $db,
            $table: $db.tablesDeJeuTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ManchesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ManchesTableTable> {
  $$ManchesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get numero => $composableBuilder(
    column: $table.numero,
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

class $$ManchesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ManchesTableTable> {
  $$ManchesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get numero =>
      $composableBuilder(column: $table.numero, builder: (column) => column);

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

  Expression<T> tablesDeJeuTableRefs<T extends Object>(
    Expression<T> Function($$TablesDeJeuTableTableAnnotationComposer a) f,
  ) {
    final $$TablesDeJeuTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tablesDeJeuTable,
      getReferencedColumn: (t) => t.mancheId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TablesDeJeuTableTableAnnotationComposer(
            $db: $db,
            $table: $db.tablesDeJeuTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ManchesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ManchesTableTable,
          ManchesTableData,
          $$ManchesTableTableFilterComposer,
          $$ManchesTableTableOrderingComposer,
          $$ManchesTableTableAnnotationComposer,
          $$ManchesTableTableCreateCompanionBuilder,
          $$ManchesTableTableUpdateCompanionBuilder,
          (ManchesTableData, $$ManchesTableTableReferences),
          ManchesTableData,
          PrefetchHooks Function({bool concoursId, bool tablesDeJeuTableRefs})
        > {
  $$ManchesTableTableTableManager(_$AppDatabase db, $ManchesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ManchesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ManchesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ManchesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> concoursId = const Value.absent(),
                Value<int> numero = const Value.absent(),
              }) => ManchesTableCompanion(
                id: id,
                concoursId: concoursId,
                numero: numero,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String concoursId,
                required int numero,
              }) => ManchesTableCompanion.insert(
                id: id,
                concoursId: concoursId,
                numero: numero,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ManchesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({concoursId = false, tablesDeJeuTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (tablesDeJeuTableRefs) db.tablesDeJeuTable,
                  ],
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
                                        $$ManchesTableTableReferences
                                            ._concoursIdTable(db),
                                    referencedColumn:
                                        $$ManchesTableTableReferences
                                            ._concoursIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (tablesDeJeuTableRefs)
                        await $_getPrefetchedData<
                          ManchesTableData,
                          $ManchesTableTable,
                          TablesDeJeuTableData
                        >(
                          currentTable: table,
                          referencedTable: $$ManchesTableTableReferences
                              ._tablesDeJeuTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ManchesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).tablesDeJeuTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.mancheId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ManchesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ManchesTableTable,
      ManchesTableData,
      $$ManchesTableTableFilterComposer,
      $$ManchesTableTableOrderingComposer,
      $$ManchesTableTableAnnotationComposer,
      $$ManchesTableTableCreateCompanionBuilder,
      $$ManchesTableTableUpdateCompanionBuilder,
      (ManchesTableData, $$ManchesTableTableReferences),
      ManchesTableData,
      PrefetchHooks Function({bool concoursId, bool tablesDeJeuTableRefs})
    >;
typedef $$TablesDeJeuTableTableCreateCompanionBuilder =
    TablesDeJeuTableCompanion Function({
      Value<int> id,
      required int mancheId,
      required int numero,
      Value<String> statut,
    });
typedef $$TablesDeJeuTableTableUpdateCompanionBuilder =
    TablesDeJeuTableCompanion Function({
      Value<int> id,
      Value<int> mancheId,
      Value<int> numero,
      Value<String> statut,
    });

final class $$TablesDeJeuTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TablesDeJeuTableTable,
          TablesDeJeuTableData
        > {
  $$TablesDeJeuTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ManchesTableTable _mancheIdTable(_$AppDatabase db) =>
      db.manchesTable.createAlias(
        $_aliasNameGenerator(db.tablesDeJeuTable.mancheId, db.manchesTable.id),
      );

  $$ManchesTableTableProcessedTableManager get mancheId {
    final $_column = $_itemColumn<int>('manche_id')!;

    final manager = $$ManchesTableTableTableManager(
      $_db,
      $_db.manchesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mancheIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $TableDoublettesTableTable,
    List<TableDoublettesTableData>
  >
  _tableDoublettesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.tableDoublettesTable,
        aliasName: $_aliasNameGenerator(
          db.tablesDeJeuTable.id,
          db.tableDoublettesTable.tableId,
        ),
      );

  $$TableDoublettesTableTableProcessedTableManager
  get tableDoublettesTableRefs {
    final manager = $$TableDoublettesTableTableTableManager(
      $_db,
      $_db.tableDoublettesTable,
    ).filter((f) => f.tableId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _tableDoublettesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TablesDeJeuTableTableFilterComposer
    extends Composer<_$AppDatabase, $TablesDeJeuTableTable> {
  $$TablesDeJeuTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get numero => $composableBuilder(
    column: $table.numero,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get statut => $composableBuilder(
    column: $table.statut,
    builder: (column) => ColumnFilters(column),
  );

  $$ManchesTableTableFilterComposer get mancheId {
    final $$ManchesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mancheId,
      referencedTable: $db.manchesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ManchesTableTableFilterComposer(
            $db: $db,
            $table: $db.manchesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> tableDoublettesTableRefs(
    Expression<bool> Function($$TableDoublettesTableTableFilterComposer f) f,
  ) {
    final $$TableDoublettesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tableDoublettesTable,
      getReferencedColumn: (t) => t.tableId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TableDoublettesTableTableFilterComposer(
            $db: $db,
            $table: $db.tableDoublettesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TablesDeJeuTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TablesDeJeuTableTable> {
  $$TablesDeJeuTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get numero => $composableBuilder(
    column: $table.numero,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get statut => $composableBuilder(
    column: $table.statut,
    builder: (column) => ColumnOrderings(column),
  );

  $$ManchesTableTableOrderingComposer get mancheId {
    final $$ManchesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mancheId,
      referencedTable: $db.manchesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ManchesTableTableOrderingComposer(
            $db: $db,
            $table: $db.manchesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TablesDeJeuTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TablesDeJeuTableTable> {
  $$TablesDeJeuTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get numero =>
      $composableBuilder(column: $table.numero, builder: (column) => column);

  GeneratedColumn<String> get statut =>
      $composableBuilder(column: $table.statut, builder: (column) => column);

  $$ManchesTableTableAnnotationComposer get mancheId {
    final $$ManchesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mancheId,
      referencedTable: $db.manchesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ManchesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.manchesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> tableDoublettesTableRefs<T extends Object>(
    Expression<T> Function($$TableDoublettesTableTableAnnotationComposer a) f,
  ) {
    final $$TableDoublettesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.tableDoublettesTable,
          getReferencedColumn: (t) => t.tableId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TableDoublettesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.tableDoublettesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TablesDeJeuTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TablesDeJeuTableTable,
          TablesDeJeuTableData,
          $$TablesDeJeuTableTableFilterComposer,
          $$TablesDeJeuTableTableOrderingComposer,
          $$TablesDeJeuTableTableAnnotationComposer,
          $$TablesDeJeuTableTableCreateCompanionBuilder,
          $$TablesDeJeuTableTableUpdateCompanionBuilder,
          (TablesDeJeuTableData, $$TablesDeJeuTableTableReferences),
          TablesDeJeuTableData,
          PrefetchHooks Function({bool mancheId, bool tableDoublettesTableRefs})
        > {
  $$TablesDeJeuTableTableTableManager(
    _$AppDatabase db,
    $TablesDeJeuTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TablesDeJeuTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TablesDeJeuTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TablesDeJeuTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> mancheId = const Value.absent(),
                Value<int> numero = const Value.absent(),
                Value<String> statut = const Value.absent(),
              }) => TablesDeJeuTableCompanion(
                id: id,
                mancheId: mancheId,
                numero: numero,
                statut: statut,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int mancheId,
                required int numero,
                Value<String> statut = const Value.absent(),
              }) => TablesDeJeuTableCompanion.insert(
                id: id,
                mancheId: mancheId,
                numero: numero,
                statut: statut,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TablesDeJeuTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({mancheId = false, tableDoublettesTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (tableDoublettesTableRefs) db.tableDoublettesTable,
                  ],
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
                        if (mancheId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.mancheId,
                                    referencedTable:
                                        $$TablesDeJeuTableTableReferences
                                            ._mancheIdTable(db),
                                    referencedColumn:
                                        $$TablesDeJeuTableTableReferences
                                            ._mancheIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (tableDoublettesTableRefs)
                        await $_getPrefetchedData<
                          TablesDeJeuTableData,
                          $TablesDeJeuTableTable,
                          TableDoublettesTableData
                        >(
                          currentTable: table,
                          referencedTable: $$TablesDeJeuTableTableReferences
                              ._tableDoublettesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TablesDeJeuTableTableReferences(
                                db,
                                table,
                                p0,
                              ).tableDoublettesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tableId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TablesDeJeuTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TablesDeJeuTableTable,
      TablesDeJeuTableData,
      $$TablesDeJeuTableTableFilterComposer,
      $$TablesDeJeuTableTableOrderingComposer,
      $$TablesDeJeuTableTableAnnotationComposer,
      $$TablesDeJeuTableTableCreateCompanionBuilder,
      $$TablesDeJeuTableTableUpdateCompanionBuilder,
      (TablesDeJeuTableData, $$TablesDeJeuTableTableReferences),
      TablesDeJeuTableData,
      PrefetchHooks Function({bool mancheId, bool tableDoublettesTableRefs})
    >;
typedef $$TableDoublettesTableTableCreateCompanionBuilder =
    TableDoublettesTableCompanion Function({
      required int tableId,
      required String concoursId,
      required int doubletteId,
      Value<int> score,
      Value<String> statut,
      Value<int> rowid,
    });
typedef $$TableDoublettesTableTableUpdateCompanionBuilder =
    TableDoublettesTableCompanion Function({
      Value<int> tableId,
      Value<String> concoursId,
      Value<int> doubletteId,
      Value<int> score,
      Value<String> statut,
      Value<int> rowid,
    });

final class $$TableDoublettesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TableDoublettesTableTable,
          TableDoublettesTableData
        > {
  $$TableDoublettesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TablesDeJeuTableTable _tableIdTable(_$AppDatabase db) =>
      db.tablesDeJeuTable.createAlias(
        $_aliasNameGenerator(
          db.tableDoublettesTable.tableId,
          db.tablesDeJeuTable.id,
        ),
      );

  $$TablesDeJeuTableTableProcessedTableManager get tableId {
    final $_column = $_itemColumn<int>('table_id')!;

    final manager = $$TablesDeJeuTableTableTableManager(
      $_db,
      $_db.tablesDeJeuTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tableIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TableDoublettesTableTableFilterComposer
    extends Composer<_$AppDatabase, $TableDoublettesTableTable> {
  $$TableDoublettesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get concoursId => $composableBuilder(
    column: $table.concoursId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get doubletteId => $composableBuilder(
    column: $table.doubletteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get statut => $composableBuilder(
    column: $table.statut,
    builder: (column) => ColumnFilters(column),
  );

  $$TablesDeJeuTableTableFilterComposer get tableId {
    final $$TablesDeJeuTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tableId,
      referencedTable: $db.tablesDeJeuTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TablesDeJeuTableTableFilterComposer(
            $db: $db,
            $table: $db.tablesDeJeuTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TableDoublettesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TableDoublettesTableTable> {
  $$TableDoublettesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get concoursId => $composableBuilder(
    column: $table.concoursId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get doubletteId => $composableBuilder(
    column: $table.doubletteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get statut => $composableBuilder(
    column: $table.statut,
    builder: (column) => ColumnOrderings(column),
  );

  $$TablesDeJeuTableTableOrderingComposer get tableId {
    final $$TablesDeJeuTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tableId,
      referencedTable: $db.tablesDeJeuTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TablesDeJeuTableTableOrderingComposer(
            $db: $db,
            $table: $db.tablesDeJeuTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TableDoublettesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TableDoublettesTableTable> {
  $$TableDoublettesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get concoursId => $composableBuilder(
    column: $table.concoursId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get doubletteId => $composableBuilder(
    column: $table.doubletteId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<String> get statut =>
      $composableBuilder(column: $table.statut, builder: (column) => column);

  $$TablesDeJeuTableTableAnnotationComposer get tableId {
    final $$TablesDeJeuTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tableId,
      referencedTable: $db.tablesDeJeuTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TablesDeJeuTableTableAnnotationComposer(
            $db: $db,
            $table: $db.tablesDeJeuTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TableDoublettesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TableDoublettesTableTable,
          TableDoublettesTableData,
          $$TableDoublettesTableTableFilterComposer,
          $$TableDoublettesTableTableOrderingComposer,
          $$TableDoublettesTableTableAnnotationComposer,
          $$TableDoublettesTableTableCreateCompanionBuilder,
          $$TableDoublettesTableTableUpdateCompanionBuilder,
          (TableDoublettesTableData, $$TableDoublettesTableTableReferences),
          TableDoublettesTableData,
          PrefetchHooks Function({bool tableId})
        > {
  $$TableDoublettesTableTableTableManager(
    _$AppDatabase db,
    $TableDoublettesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TableDoublettesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TableDoublettesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TableDoublettesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> tableId = const Value.absent(),
                Value<String> concoursId = const Value.absent(),
                Value<int> doubletteId = const Value.absent(),
                Value<int> score = const Value.absent(),
                Value<String> statut = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TableDoublettesTableCompanion(
                tableId: tableId,
                concoursId: concoursId,
                doubletteId: doubletteId,
                score: score,
                statut: statut,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int tableId,
                required String concoursId,
                required int doubletteId,
                Value<int> score = const Value.absent(),
                Value<String> statut = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TableDoublettesTableCompanion.insert(
                tableId: tableId,
                concoursId: concoursId,
                doubletteId: doubletteId,
                score: score,
                statut: statut,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TableDoublettesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tableId = false}) {
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
                    if (tableId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tableId,
                                referencedTable:
                                    $$TableDoublettesTableTableReferences
                                        ._tableIdTable(db),
                                referencedColumn:
                                    $$TableDoublettesTableTableReferences
                                        ._tableIdTable(db)
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

typedef $$TableDoublettesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TableDoublettesTableTable,
      TableDoublettesTableData,
      $$TableDoublettesTableTableFilterComposer,
      $$TableDoublettesTableTableOrderingComposer,
      $$TableDoublettesTableTableAnnotationComposer,
      $$TableDoublettesTableTableCreateCompanionBuilder,
      $$TableDoublettesTableTableUpdateCompanionBuilder,
      (TableDoublettesTableData, $$TableDoublettesTableTableReferences),
      TableDoublettesTableData,
      PrefetchHooks Function({bool tableId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ConcoursTableTableTableManager get concoursTable =>
      $$ConcoursTableTableTableManager(_db, _db.concoursTable);
  $$DoublettesTableTableTableManager get doublettesTable =>
      $$DoublettesTableTableTableManager(_db, _db.doublettesTable);
  $$ManchesTableTableTableManager get manchesTable =>
      $$ManchesTableTableTableManager(_db, _db.manchesTable);
  $$TablesDeJeuTableTableTableManager get tablesDeJeuTable =>
      $$TablesDeJeuTableTableTableManager(_db, _db.tablesDeJeuTable);
  $$TableDoublettesTableTableTableManager get tableDoublettesTable =>
      $$TableDoublettesTableTableTableManager(_db, _db.tableDoublettesTable);
}
