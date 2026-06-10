import 'package:belotable/data/database/app_database.dart';
import 'package:belotable/main.dart';
import 'package:belotable/utils/providers.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

typedef TestWithDb = Future<void> Function(AppDatabase db);
typedef RepositoryFactory<T> = T Function(AppDatabase db);
typedef RepositoryTestBody<T> =
    Future<void> Function(AppDatabase db, T repository);
typedef RepositoryTestSetup<T> = ({AppDatabase db, T repository});
typedef UseCaseDependenciesFactory<TDependencies> = TDependencies Function();
typedef UseCaseFactory<TDependencies, TUseCase> =
    TUseCase Function(TDependencies dependencies);
typedef UseCaseTestBody<TDependencies, TUseCase> =
    Future<void> Function(TDependencies dependencies, TUseCase useCase);
typedef UseCaseTestSetup<TDependencies, TUseCase> = ({
  TDependencies dependencies,
  TUseCase useCase,
});
typedef UseCaseDbDependenciesFactory<TDependencies> =
    TDependencies Function(AppDatabase db);
typedef UseCaseDbTestBody<TDependencies, TUseCase> =
    Future<void> Function(
      AppDatabase db,
      TDependencies dependencies,
      TUseCase useCase,
    );
typedef UseCaseDbTestSetup<TDependencies, TUseCase> = ({
  AppDatabase db,
  TDependencies dependencies,
  TUseCase useCase,
});

/// Creates an in-memory database for testing purposes.
AppDatabase createTestDatabase() {
  return AppDatabase.withExecutor(
    NativeDatabase.memory(),
  );
}

RepositoryTestSetup<T> createRepositoryTestSetup<T>(
  RepositoryFactory<T> factory,
) {
  final db = createTestDatabase();
  final repository = factory(db);

  return (db: db, repository: repository);
}

UseCaseTestSetup<TDependencies, TUseCase>
createUseCaseTestSetup<TDependencies, TUseCase>({
  required UseCaseDependenciesFactory<TDependencies> dependenciesFactory,
  required UseCaseFactory<TDependencies, TUseCase> useCaseFactory,
}) {
  final dependencies = dependenciesFactory();
  final useCase = useCaseFactory(dependencies);

  return (dependencies: dependencies, useCase: useCase);
}

UseCaseDbTestSetup<TDependencies, TUseCase>
createUseCaseDbTestSetup<TDependencies, TUseCase>({
  required UseCaseDbDependenciesFactory<TDependencies> dependenciesFactory,
  required UseCaseFactory<TDependencies, TUseCase> useCaseFactory,
}) {
  final db = createTestDatabase();
  final dependencies = dependenciesFactory(db);
  final useCase = useCaseFactory(dependencies);

  return (db: db, dependencies: dependencies, useCase: useCase);
}

/// Helper function to run a test with a repository and its database.
void repositoryDbTest<T>(
  String description, {
  required RepositoryFactory<T> factory,
  required RepositoryTestBody<T> body,
}) {
  test(description, () async {
    final setup = createRepositoryTestSetup<T>(factory);

    try {
      await body(setup.db, setup.repository);
    } finally {
      await setup.db.close();
    }
  });
}

/// Helper function to run a use case test with dependencies and use case.
void useCaseTest<TDependencies, TUseCase>(
  String description, {
  required UseCaseDependenciesFactory<TDependencies> dependenciesFactory,
  required UseCaseFactory<TDependencies, TUseCase> useCaseFactory,
  required UseCaseTestBody<TDependencies, TUseCase> body,
}) {
  test(description, () async {
    final setup = createUseCaseTestSetup<TDependencies, TUseCase>(
      dependenciesFactory: dependenciesFactory,
      useCaseFactory: useCaseFactory,
    );

    await body(setup.dependencies, setup.useCase);
  });
}

/// Helper function to run a use case test backed by in-memory database.
void useCaseDbTest<TDependencies, TUseCase>(
  String description, {
  required UseCaseDbDependenciesFactory<TDependencies> dependenciesFactory,
  required UseCaseFactory<TDependencies, TUseCase> useCaseFactory,
  required UseCaseDbTestBody<TDependencies, TUseCase> body,
}) {
  test(description, () async {
    final setup = createUseCaseDbTestSetup<TDependencies, TUseCase>(
      dependenciesFactory: dependenciesFactory,
      useCaseFactory: useCaseFactory,
    );

    try {
      await body(setup.db, setup.dependencies, setup.useCase);
    } finally {
      await setup.db.close();
    }
  });
}

/// Helper function to run a test with a database.
void dbTest(
  String description,
  TestWithDb body,
) {
  test(description, () async {
    final db = createTestDatabase();

    try {
      await body(db);
    } finally {
      await db.close();
    }
  });
}

typedef WidgetTestWithDb =
    Future<void> Function(
      WidgetTester tester,
      AppDatabase db,
    );

/// Helper function to run a widget test with a database.
void widgetDbTest(
  String description,
  WidgetTestWithDb body,
) {
  testWidgets(description, (tester) async {
    final db = createTestDatabase();

    try {
      await body(tester, db);
    } finally {
      await db.close();
    }
  });
}

/// Pumps the test app with the provided database and optional seeding function.
Future<void> pumpTestApp(
  WidgetTester tester,
  AppDatabase db, {
  Future<void> Function(AppDatabase db)? seed,
}) async {
  // seed optionnel
  if (seed != null) {
    await seed(db);
  }

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
      ],
      child: const MyApp(),
    ),
  );

  await tester.pumpAndSettle();
}
