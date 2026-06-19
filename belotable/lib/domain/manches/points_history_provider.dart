import 'package:belotable/domain/manches/points_history_row.dart';
import 'package:belotable/utils/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides points history for a doublette across all manches.
// ignore: specify_nonobvious_property_types
final pointsHistoryProvider = FutureProvider.autoDispose
    .family<List<PointsHistoryRow>, (String, int)>((ref, args) async {
      final (concoursId, doubletteId) = args;
      final mancheRepo = ref.watch(mancheRepositoryProvider);
      final doubletteRepo = ref.watch(doubletteRepositoryProvider);

      final tableDoublettes = await mancheRepo.findTableDoublettesByDoubletteId(
        concoursId: concoursId,
        doubletteId: doubletteId,
      );

      final allManches = await mancheRepo.findManchesByConcoursId(concoursId);
      final mancheById = {for (final m in allManches) m.id: m.numero};

      // Get all doublettes to map opponent ids to names
      final allDoublettes = await doubletteRepo.findByConcoursId(concoursId);
      final doubletteNameById = {
        for (final d in allDoublettes) d.doubletteId: d.nomEquipe,
      };

      // Get all tables to map tableId -> opponents in same table
      final allTables = await mancheRepo.findTablesDeJeuByConcoursId(
        concoursId,
      );
      final tableToDoublettes = <int, List<int>>{};
      for (final table in allTables) {
        tableToDoublettes[table.id] = table.doublettes
            .map((td) => td.doubletteId)
            .toList();
      }

      return tableDoublettes.map((td) {
        final mancheNum = mancheById[td.tableId] ?? 0;

        // Find opponent(s) in same table
        final opponentIds =
            tableToDoublettes[td.tableId]
                ?.where((id) => id != doubletteId)
                .toList() ??
            [];
        final opponentId = opponentIds.isNotEmpty ? opponentIds.first : 0;
        final opponentName = doubletteNameById[opponentId] ?? '';

        return PointsHistoryRow(
          mancheNum: mancheNum,
          points: td.points,
          statut: td.statut.label,
          opponentName: opponentName,
          opponentId: opponentId,
        );
      }).toList();
    });
