import 'package:belotable/domain/doublettes/doublette.dart';
import 'package:belotable/presentation/shared/doublettes/doublette_creation_page.dart';
import 'package:belotable/presentation/shared/doublettes/doublette_detail_page.dart';
import 'package:belotable/presentation/shared/doublettes/doublette_navigation_args.dart';
import 'package:belotable/utils/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Displays doublettes registered for one concours.
class DoublettesListPage extends ConsumerWidget {
  /// Creates page for one concours id.
  const DoublettesListPage({
    required this.concoursId,
    super.key,
  });

  /// Route name for navigation.
  static const routeName = '/doublettes/list';

  /// Owning concours id.
  final String concoursId;

  Future<void> _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    Doublette doublette,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text(
          'Supprimer la doublette #${doublette.doubletteId} '
          '(${doublette.nomEquipe}) ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    final deleteUseCase = ref.read(deleteDoubletteUseCaseProvider);
    final deleted = await deleteUseCase(
      concoursId: doublette.concoursId,
      doubletteId: doublette.doubletteId,
    );

    if (!context.mounted) {
      return;
    }

    if (deleted) {
      ref
        ..invalidate(doublettesByConcoursProvider(concoursId))
        ..invalidate(concoursListProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Doublette supprimée avec succès')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Suppression impossible: doublette passée en Abandon',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doublettesAsync = ref.watch(doublettesByConcoursProvider(concoursId));

    return Scaffold(
      appBar: AppBar(title: const Text('Liste des doublettes')),
      floatingActionButton: FloatingActionButton(
        key: const Key('doublettes_list_add_button'),
        tooltip: 'Créer une doublette',
        onPressed: () async {
          final created = await Navigator.of(context).pushNamed(
            DoubletteCreationPage.routeName,
            arguments: DoubletteCreationArgs(concoursId: concoursId),
          );
          if (created == true) {
            ref
              ..invalidate(doublettesByConcoursProvider(concoursId))
              ..invalidate(concoursListProvider);
          }
        },
        child: const Icon(Icons.add),
      ),
      body: doublettesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => const Center(
          child: Text('Erreur lors du chargement des doublettes'),
        ),
        data: (doublettes) {
          if (doublettes.isEmpty) {
            return const Center(
              child: Text(
                'Aucune doublette enregistrée',
                key: Key('doublettes_list_empty_message'),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            scrollDirection: Axis.horizontal,
            child: DataTable(
              key: const Key('doublettes_list_table'),
              columns: const [
                DataColumn(label: Text('Id')),
                DataColumn(label: Text('Nom équipe')),
                DataColumn(label: Text('Joueur A')),
                DataColumn(label: Text('Joueur B')),
                DataColumn(label: Text('Actions')),
              ],
              rows: doublettes
                  .map(
                    (doublette) => DataRow(
                      key: ValueKey<String>(
                        'doublette_row_${doublette.concoursId}_'
                        '${doublette.doubletteId}',
                      ),
                      cells: [
                        DataCell(Text(doublette.doubletteId.toString())),
                        DataCell(Text(doublette.nomEquipe)),
                        DataCell(Text(doublette.joueurA)),
                        DataCell(Text(doublette.joueurB)),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                key: ValueKey<String>(
                                  'doublette_manage_button_'
                                  '${doublette.concoursId}_'
                                  '${doublette.doubletteId}',
                                ),
                                onPressed: () async {
                                  final updated = await Navigator.of(context)
                                      .pushNamed(
                                        DoubletteDetailPage.routeName,
                                        arguments: DoubletteDetailArgs(
                                          concoursId: doublette.concoursId,
                                          doubletteId: doublette.doubletteId,
                                        ),
                                      );
                                  if (updated == true) {
                                    ref.invalidate(
                                      doublettesByConcoursProvider(concoursId),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.settings_outlined),
                                tooltip: 'Gérer',
                              ),
                              IconButton(
                                key: ValueKey<String>(
                                  'doublette_delete_button_'
                                  '${doublette.concoursId}_'
                                  '${doublette.doubletteId}',
                                ),
                                onPressed: () => _showDeleteConfirmation(
                                  context,
                                  ref,
                                  doublette,
                                ),
                                icon: const Icon(Icons.delete_outline),
                                tooltip: 'Supprimer',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(growable: false),
            ),
          );
        },
      ),
    );
  }
}
