import 'package:belotable/domain/concours/concours.dart';
import 'package:belotable/presentation/shared/concours/concours_creation_page.dart';
import 'package:belotable/presentation/shared/concours/concours_detail_page.dart';
import 'package:belotable/presentation/shared/concours/delete_concours_confirmation_dialog.dart';
import 'package:belotable/utils/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Displays all concours entries sorted by descending date.
class ConcoursListPage extends ConsumerWidget {
  /// Creates concours list page.
  const ConcoursListPage({super.key});

  /// Route name for navigation to this page.
  static const routeName = '/concours/list';

  Future<void> _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    Concours concours,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (context) => DeleteConcoursConfirmationDialog(
        concours: concours,
        onConfirm: () async {
          final deleteUseCase = ref.read(deleteConcoursUseCaseProvider);
          try {
            final success = await deleteUseCase(concours.id);
            if (!context.mounted) return;
            if (success) {
              ref.invalidate(concoursListProvider);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Concours supprimé avec succès'),
                  duration: Duration(seconds: 2),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Erreur lors de la suppression'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          } on Exception catch (e) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Erreur : $e'),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final concoursAsyncValue = ref.watch(concoursListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des concours'),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('concours_list_add_button'),
        tooltip: 'Créer un concours',
        onPressed: () async {
          await Navigator.of(context).pushNamed(ConcoursCreationPage.routeName);
          ref.invalidate(concoursListProvider);
        },
        child: const Icon(Icons.add),
      ),
      body: concoursAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => const Center(
          child: Text('Erreur lors du chargement des concours'),
        ),
        data: (concoursList) {
          if (concoursList.isEmpty) {
            return const Center(
              child: Text(
                'Aucun concours disponible',
                key: Key('concours_list_empty_message'),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            scrollDirection: Axis.horizontal,
            child: DataTable(
              key: const Key('concours_list_table'),
              columns: const [
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Lieu')),
                DataColumn(label: Text('Organisateur')),
                DataColumn(label: Text('Doublettes')),
                DataColumn(label: Text('Actions')),
              ],
              rows: concoursList
                  .map(
                    (concours) {
                      final formattedDate =
                          '${concours.date.year.toString().padLeft(4, '0')}-'
                          '${concours.date.month.toString().padLeft(2, '0')}-'
                          '${concours.date.day.toString().padLeft(2, '0')}';

                      return DataRow(
                        key: ValueKey<String>('concours_row_${concours.id}'),
                        cells: [
                          DataCell(Text(formattedDate)),
                          DataCell(Text(concours.lieu)),
                          DataCell(Text(concours.organisateur)),
                          DataCell(
                            Text(
                              concours.nombreDoublettes.toString(),
                              key: ValueKey<String>(
                                'concours_doublettes_count_${concours.id}',
                              ),
                            ),
                          ),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  key: ValueKey<String>(
                                    'concours_manage_button_${concours.id}',
                                  ),
                                  onPressed: () async {
                                    await Navigator.of(context).pushNamed(
                                      ConcoursDetailPage.routeName,
                                      arguments: concours.id,
                                    );
                                    ref.invalidate(concoursListProvider);
                                  },
                                  icon: const Icon(Icons.settings_outlined),
                                  tooltip: 'Gérer',
                                ),
                                IconButton(
                                  key: ValueKey<String>(
                                    'concours_delete_button_${concours.id}',
                                  ),
                                  onPressed: () => _showDeleteConfirmation(
                                    context,
                                    ref,
                                    concours,
                                  ),
                                  icon: const Icon(Icons.delete_outline),
                                  tooltip: 'Supprimer',
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  )
                  .toList(growable: false),
            ),
          );
        },
      ),
    );
  }
}
