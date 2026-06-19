import 'package:belotable/domain/doublettes/doublette.dart';
import 'package:belotable/utils/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Displays doublettes ranking sorted by total points descending.
class DoublettesRankingPage extends ConsumerWidget {
  /// Creates ranking page for one concours id.
  const DoublettesRankingPage({
    required this.concoursId,
    super.key,
  });

  /// Route name for navigation.
  static const routeName = '/doublettes/ranking';

  /// Owning concours id.
  final String concoursId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doublettesAsync = ref.watch(doublettesByConcoursProvider(concoursId));

    return Scaffold(
      appBar: AppBar(title: const Text('Classement des doublettes')),
      body: doublettesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => const Center(
          child: Text('Erreur lors du chargement du classement'),
        ),
        data: (doublettes) {
          if (doublettes.isEmpty) {
            return const Center(
              child: Text(
                'Aucune doublette enregistrée',
                key: Key('doublettes_ranking_empty_message'),
              ),
            );
          }

          // Sort by total points descending
          final sorted = List<Doublette>.from(doublettes)
            ..sort((a, b) => b.totalPoints.compareTo(a.totalPoints));

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            scrollDirection: Axis.horizontal,
            child: DataTable(
              key: const Key('doublettes_ranking_table'),
              columns: const [
                DataColumn(label: Text('Position')),
                DataColumn(label: Text('Doublette')),
                DataColumn(label: Text('Points totaux')),
              ],
              rows: sorted
                  .asMap()
                  .entries
                  .map(
                    (entry) => DataRow(
                      key: ValueKey<String>(
                        'doublette_ranking_row_'
                        '${entry.value.concoursId}_'
                        '${entry.value.doubletteId}',
                      ),
                      cells: [
                        DataCell(Text((entry.key + 1).toString())),
                        DataCell(Text(entry.value.nomEquipe)),
                        DataCell(Text(entry.value.totalPoints.toString())),
                      ],
                    ),
                  )
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}
