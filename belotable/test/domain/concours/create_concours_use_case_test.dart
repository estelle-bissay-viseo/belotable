import 'package:belotable/domain/concours/create_concours_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/in_memory_concours_repository.dart';
import '../../helpers/test_utils.dart';

typedef _CreateConcoursTestDeps = ({
  InMemoryConcoursRepository repository,
});

void main() {
  group('CreateConcoursUseCase', () {
    useCaseTest<_CreateConcoursTestDeps, CreateConcoursUseCase>(
      'creates concours and persists trimmed values',
      dependenciesFactory: () => (
        repository: InMemoryConcoursRepository(),
      ),
      useCaseFactory: (deps) => CreateConcoursUseCase(deps.repository),
      body: (deps, useCase) async {
        final repository = deps.repository;

        final concours = await useCase(
          date: DateTime(2026, 6, 8, 15, 30),
          lieu: '  Salle des fetes  ',
          organisateur: '  Association Belote  ',
        );

        expect(repository.savedConcours, hasLength(1));
        expect(concours.id, isNotEmpty);
        expect(concours.date, DateTime(2026, 6, 8));
        expect(concours.lieu, 'Salle des fetes');
        expect(concours.organisateur, 'Association Belote');
        expect(concours.nombreDonnesParManche, 10);
        expect(concours.nombreMaxPointsParDonne, 162);
        expect(concours.reglesJeu, isNotEmpty);
      },
    );

    useCaseTest<_CreateConcoursTestDeps, CreateConcoursUseCase>(
      'throws when lieu is empty',
      dependenciesFactory: () => (
        repository: InMemoryConcoursRepository(),
      ),
      useCaseFactory: (deps) => CreateConcoursUseCase(deps.repository),
      body: (deps, useCase) async {
        final repository = deps.repository;

        await expectLater(
          () => useCase(
            date: DateTime(2026, 6, 8),
            lieu: '   ',
            organisateur: 'Club',
          ),
          throwsA(isA<ArgumentError>()),
        );
        expect(repository.savedConcours, isEmpty);
      },
    );

    useCaseTest<_CreateConcoursTestDeps, CreateConcoursUseCase>(
      'throws when organisateur is empty',
      dependenciesFactory: () => (
        repository: InMemoryConcoursRepository(),
      ),
      useCaseFactory: (deps) => CreateConcoursUseCase(deps.repository),
      body: (deps, useCase) async {
        final repository = deps.repository;

        await expectLater(
          () => useCase(
            date: DateTime(2026, 6, 8),
            lieu: 'Salle',
            organisateur: '   ',
          ),
          throwsA(isA<ArgumentError>()),
        );
        expect(repository.savedConcours, isEmpty);
      },
    );

    useCaseTest<_CreateConcoursTestDeps, CreateConcoursUseCase>(
      'sets status to Initialisation on creation',
      dependenciesFactory: () => (
        repository: InMemoryConcoursRepository(),
      ),
      useCaseFactory: (deps) => CreateConcoursUseCase(deps.repository),
      body: (deps, useCase) async {
        final concours = await useCase(
          date: DateTime(2026, 6, 8),
          lieu: 'Salle',
          organisateur: 'Club',
        );

        expect(
          concours.statutConcours.toString(),
          equalsIgnoringCase('ConcoursStatut.initialisation'),
        );
      },
    );

    useCaseTest<_CreateConcoursTestDeps, CreateConcoursUseCase>(
      'uses custom values when provided',
      dependenciesFactory: () => (
        repository: InMemoryConcoursRepository(),
      ),
      useCaseFactory: (deps) => CreateConcoursUseCase(deps.repository),
      body: (deps, useCase) async {
        final concours = await useCase(
          date: DateTime(2026, 6, 8),
          lieu: 'Salle',
          organisateur: 'Club',
          nombreDonnesParManche: 15,
          reglesJeu: 'Belote contrée',
          nombreMaxPointsParDonne: 180,
        );

        expect(concours.nombreDonnesParManche, 15);
        expect(concours.nombreMaxPointsParDonne, 180);
        expect(concours.reglesJeu, 'Belote contrée');
      },
    );
  });
}
