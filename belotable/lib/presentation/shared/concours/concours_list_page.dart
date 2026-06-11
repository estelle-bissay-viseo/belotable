import 'package:belotable/presentation/shared/concours/concours_creation_page.dart';
import 'package:belotable/utils/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Displays all concours entries sorted by descending date.
class ConcoursListPage extends ConsumerWidget {
  /// Creates concours list page.
  const ConcoursListPage({super.key});

  /// Route name for navigation to this page.
  static const routeName = '/concours/list';

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
                DataColumn(label: Text('Actions')),
              ],
              rows: concoursList
                  .map(
                    (concours) => DataRow(
                      cells: [
                        DataCell(
                          Text(
                            '${concours.date.year.toString().padLeft(4, '0')}-'
                            '${concours.date.month.toString().padLeft(2, '0')}-'
                            '${concours.date.day.toString().padLeft(2, '0')}',
                          ),
                        ),
                        DataCell(Text(concours.lieu)),
                        DataCell(Text(concours.organisateur)),
                        const DataCell(
                          Row(
                            children: [
                              IconButton(
                                onPressed: null,
                                icon: Icon(Icons.settings_outlined),
                                tooltip: 'Gérer',
                              ),
                              IconButton(
                                onPressed: null,
                                icon: Icon(Icons.delete_outline),
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
