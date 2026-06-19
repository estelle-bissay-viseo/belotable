import 'package:belotable/data/database/app_database.dart';
import 'package:belotable/data/pdf/pdf_repository_impl.dart';
import 'package:belotable/data/repositories/drift_concours_repository.dart';
import 'package:belotable/data/repositories/drift_doublette_repository.dart';
import 'package:belotable/data/repositories/drift_manche_repository.dart';
import 'package:belotable/domain/concours/concours.dart';
import 'package:belotable/domain/concours/concours_repository.dart';
import 'package:belotable/domain/concours/create_concours_use_case.dart';
import 'package:belotable/domain/concours/delete_concours_use_case.dart';
import 'package:belotable/domain/concours/update_concours_use_case.dart';
import 'package:belotable/domain/doublettes/create_doublette_use_case.dart';
import 'package:belotable/domain/doublettes/delete_doublette_use_case.dart';
import 'package:belotable/domain/doublettes/doublette.dart';
import 'package:belotable/domain/doublettes/doublette_repository.dart';
import 'package:belotable/domain/doublettes/update_doublette_use_case.dart';
import 'package:belotable/domain/manches/create_premiere_manche_use_case.dart';
import 'package:belotable/domain/manches/manche.dart';
import 'package:belotable/domain/manches/manche_repository.dart';
import 'package:belotable/domain/manches/table_de_jeu.dart';
import 'package:belotable/domain/manches/update_manche_points_use_case.dart';
import 'package:belotable/domain/pdf/repositories/pdf_repository.dart';
import 'package:belotable/domain/pdf/usecases/generate_concours_table_pdf_usecase.dart';
import 'package:belotable/presentation/shared/services/pdf_export_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Dependency injection providers for database, repositories, and use cases.

/// Provides singleton Drift database instance.
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

/// Provides ConcoursRepository bound to database.
final concoursRepositoryProvider = Provider<ConcoursRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return DriftConcoursRepository(db);
});

/// Provides DoubletteRepository bound to database.
final doubletteRepositoryProvider = Provider<DoubletteRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return DriftDoubletteRepository(db);
});

/// Provides MancheRepository bound to database.
final mancheRepositoryProvider = Provider<MancheRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return DriftMancheRepository(db);
});

/// Provides CreateConcoursUseCase with repository dependency.
final createConcoursUseCaseProvider = Provider<CreateConcoursUseCase>((ref) {
  final repo = ref.watch(concoursRepositoryProvider);
  return CreateConcoursUseCase(repo);
});

/// Provides DeleteConcoursUseCase with repository dependency.
final deleteConcoursUseCaseProvider = Provider<DeleteConcoursUseCase>((ref) {
  final repo = ref.watch(concoursRepositoryProvider);
  return DeleteConcoursUseCase(repo);
});

/// Provides UpdateConcoursUseCase with repository dependency.
final updateConcoursUseCaseProvider = Provider<UpdateConcoursUseCase>((ref) {
  final repo = ref.watch(concoursRepositoryProvider);
  return UpdateConcoursUseCase(repo);
});

/// Provides CreateDoubletteUseCase with repository dependencies.
final createDoubletteUseCaseProvider = Provider<CreateDoubletteUseCase>((ref) {
  final repo = ref.watch(doubletteRepositoryProvider);
  final mancheRepo = ref.watch(mancheRepositoryProvider);
  return CreateDoubletteUseCase(repo, mancheRepository: mancheRepo);
});

/// Provides UpdateDoubletteUseCase with repository dependency.
final updateDoubletteUseCaseProvider = Provider<UpdateDoubletteUseCase>((ref) {
  final repo = ref.watch(doubletteRepositoryProvider);
  return UpdateDoubletteUseCase(repo);
});

/// Provides DeleteDoubletteUseCase with repository dependencies.
final deleteDoubletteUseCaseProvider = Provider<DeleteDoubletteUseCase>((ref) {
  final repo = ref.watch(doubletteRepositoryProvider);
  final mancheRepo = ref.watch(mancheRepositoryProvider);
  return DeleteDoubletteUseCase(repo, mancheRepository: mancheRepo);
});

/// Provides concours list sorted by date desc for list screen.
/// autoDispose: disposes when list page leaves stack, re-fetches on re-entry.
// ignore: specify_nonobvious_property_types
final concoursListProvider = FutureProvider.autoDispose<List<Concours>>((ref) {
  final repo = ref.watch(concoursRepositoryProvider);
  return repo.findAllByDateDesc();
});

/// Provides doublettes list by concours ordered by registration id.
// ignore: specify_nonobvious_property_types
final doublettesByConcoursProvider = FutureProvider.autoDispose
    .family<List<Doublette>, String>((ref, concoursId) {
      final repo = ref.watch(doubletteRepositoryProvider);
      return repo.findByConcoursId(concoursId);
    });

/// Provides CreatePremiereMancheUseCase with repository dependencies.
final createPremiereMancheUseCaseProvider =
    Provider<CreatePremiereMancheUseCase>((ref) {
      final doubletteRepo = ref.watch(doubletteRepositoryProvider);
      final mancheRepo = ref.watch(mancheRepositoryProvider);
      final concoursRepo = ref.watch(concoursRepositoryProvider);
      return CreatePremiereMancheUseCase(
        doubletteRepo,
        mancheRepo,
        concoursRepo,
      );
    });

/// Provides UpdateManchePointsUseCase with repository dependencies.
final updateManchePointsUseCaseProvider = Provider<UpdateManchePointsUseCase>(
  (ref) {
    final mancheRepo = ref.watch(mancheRepositoryProvider);
    final doubletteRepo = ref.watch(doubletteRepositoryProvider);
    return UpdateManchePointsUseCase(mancheRepo, doubletteRepo);
  },
);

/// Provides manches list for a concours.
// ignore: specify_nonobvious_property_types
final manchesByConcoursProvider = FutureProvider.autoDispose
    .family<List<Manche>, String>((ref, concoursId) {
      final repo = ref.watch(mancheRepositoryProvider);
      return repo.findManchesByConcoursId(concoursId);
    });

/// Provides tables de jeu for a manche.
// ignore: specify_nonobvious_property_types
final tablesDeJeuByMancheProvider = FutureProvider.autoDispose
    .family<List<TableDeJeu>, int>((ref, mancheId) {
      final repo = ref.watch(mancheRepositoryProvider);
      return repo.findTablesDeJeuByMancheId(mancheId);
    });

/// Provides PdfRepository for PDF generation.
final pdfRepositoryProvider = Provider<PdfRepository>((ref) {
  return PdfRepositoryImpl();
});

/// Provides GenerateConcoursTablePdfUseCase for exporting concours to PDF.
final generateConcoursTablePdfUseCaseProvider =
    Provider<GenerateConcoursTablePdfUseCase>((ref) {
      final concoursRepo = ref.watch(concoursRepositoryProvider);
      final pdfRepo = ref.watch(pdfRepositoryProvider);
      return GenerateConcoursTablePdfUseCase(
        concoursRepository: concoursRepo,
        pdfRepository: pdfRepo,
      );
    });

/// Provides PdfExportService for generating PDFs,
/// with platform-specific implementations.
final pdfExportServiceProvider = Provider<PdfExportService>((ref) {
  return createPdfExportService();
});
