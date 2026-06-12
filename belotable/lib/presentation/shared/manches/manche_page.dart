import 'package:belotable/domain/manches/table_de_jeu.dart';
import 'package:belotable/domain/manches/table_doublette.dart';
import 'package:belotable/utils/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Page displaying all tables of a round with editable scores and statuses.
class ManchePage extends ConsumerWidget {
  /// Creates the manche page for the given manche id.
  const ManchePage({
    required this.mancheId,
    required this.mancheNumero,
    super.key,
  });

  /// Route name for navigation to this page.
  static const routeName = '/manches/detail';

  /// Target manche id.
  final int mancheId;

  /// Round number for display.
  final int mancheNumero;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tablesAsync = ref.watch(tablesDeJeuByMancheProvider(mancheId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Manche $mancheNumero'),
      ),
      body: tablesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(
          child: Text('Erreur lors du chargement des tables'),
        ),
        data: (tables) {
          return ListView(
            key: const Key('manche_page_tables_list'),
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                key: const Key('manche_page_autosave_warning'),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.15),
                  border: Border.all(color: Colors.amber),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.amber),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Attention: toute modification réalisée sur cet écran '
                        'est immédiatement enregistrée.',
                      ),
                    ),
                  ],
                ),
              ),
              if (tables.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 32),
                  child: Center(
                    child: Text(
                      'Aucune table pour cette manche',
                      key: Key('manche_page_empty_message'),
                    ),
                  ),
                )
              else
                ...List.generate(
                  tables.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                      bottom: index == tables.length - 1 ? 0 : 12,
                    ),
                    child: _TableDeJeuCard(
                      table: tables[index],
                      onRefresh: () => ref.invalidate(
                        tablesDeJeuByMancheProvider(mancheId),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _TableDeJeuCard extends ConsumerWidget {
  const _TableDeJeuCard({required this.table, required this.onRefresh});

  final TableDeJeu table;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card.outlined(
      key: Key('table_card_${table.id}'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Table ${table.numero}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(width: 12),
                _StatutChip(statut: table.statut),
              ],
            ),
            const SizedBox(height: 12),
            if (table.doublettes.isEmpty)
              const Text('Aucune doublette assignée')
            else
              ...table.doublettes.map(
                (td) => _TableDoubletteRow(
                  key: Key('td_row_${table.id}_${td.doubletteId}'),
                  tableDoublette: td,
                  onRefresh: onRefresh,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StatutChip extends StatelessWidget {
  const _StatutChip({required this.statut});

  final TableDeJeuStatut statut;

  Color _color() {
    switch (statut) {
      case TableDeJeuStatut.enAttente:
        return Colors.grey;
      case TableDeJeuStatut.enCours:
        return Colors.orange;
      case TableDeJeuStatut.termine:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(statut.label),
      backgroundColor: _color().withValues(alpha: 0.2),
      side: BorderSide(color: _color()),
      padding: EdgeInsets.zero,
      labelPadding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}

class _TableDoubletteRow extends ConsumerStatefulWidget {
  const _TableDoubletteRow({
    required this.tableDoublette,
    required this.onRefresh,
    super.key,
  });

  final TableDoublette tableDoublette;
  final VoidCallback onRefresh;

  @override
  ConsumerState<_TableDoubletteRow> createState() => _TableDoubletteRowState();
}

class _TableDoubletteRowState extends ConsumerState<_TableDoubletteRow> {
  late final TextEditingController _scoreController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _scoreController = TextEditingController(
      text: widget.tableDoublette.score.toString(),
    );
  }

  @override
  void dispose() {
    _scoreController.dispose();
    super.dispose();
  }

  Future<void> _saveScore() async {
    final score = int.tryParse(_scoreController.text.trim()) ?? 0;
    if (score == widget.tableDoublette.score) {
      return;
    }

    setState(() => _isSaving = true);
    try {
      final repo = ref.read(mancheRepositoryProvider);
      await repo.updateScore(
        tableId: widget.tableDoublette.tableId,
        concoursId: widget.tableDoublette.concoursId,
        doubletteId: widget.tableDoublette.doubletteId,
        score: score,
      );
      widget.onRefresh();
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _updateStatut(TableDoubletteStatut statut) async {
    if (statut == widget.tableDoublette.statut) {
      return;
    }

    setState(() => _isSaving = true);
    try {
      final repo = ref.read(mancheRepositoryProvider);
      await repo.updateStatut(
        tableId: widget.tableDoublette.tableId,
        concoursId: widget.tableDoublette.concoursId,
        doubletteId: widget.tableDoublette.doubletteId,
        statut: statut,
      );
      widget.onRefresh();
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  bool get _isWinner =>
      widget.tableDoublette.statut == TableDoubletteStatut.gagne;

  @override
  Widget build(BuildContext context) {
    final td = widget.tableDoublette;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              '${td.nomEquipe} (#${td.doubletteId})',
              style: TextStyle(
                fontWeight: _isWinner ? FontWeight.bold : FontWeight.normal,
                color: _isWinner ? Colors.green[700] : null,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 95,
            child: TextField(
              key: Key('score_field_${td.tableId}_${td.doubletteId}'),
              controller: _scoreController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Score final',
                isDense: true,
              ),
              enabled: !_isSaving,
              onSubmitted: (_) => _saveScore(),
              onEditingComplete: _saveScore,
            ),
          ),
          const SizedBox(width: 8),
          DropdownButton<TableDoubletteStatut>(
            key: Key('statut_dropdown_${td.tableId}_${td.doubletteId}'),
            value: td.statut,
            items: TableDoubletteStatut.values
                .map(
                  (s) => DropdownMenuItem(
                    value: s,
                    child: Text(s.label),
                  ),
                )
                .toList(),
            onChanged: _isSaving
                ? null
                : (s) async {
                    if (s != null) {
                      await _updateStatut(s);
                    }
                  },
          ),
        ],
      ),
    );
  }
}

/// Shows confirmation dialog before creating the first manche and navigates
/// to it if confirmed.
Future<void> showCreatePremiereMancheDialog(
  BuildContext context,
  WidgetRef ref,
  String concoursId,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Préparer la première manche ?'),
      content: const Text(
        'Les doublettes enregistrées seront réparties automatiquement '
        'en tables de 2.',
      ),
      actions: [
        TextButton(
          key: const Key('prepare_manche_cancel_button'),
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Annuler'),
        ),
        FilledButton(
          key: const Key('prepare_manche_confirm_button'),
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Préparer'),
        ),
      ],
    ),
  );

  if (confirmed != true || !context.mounted) {
    return;
  }

  try {
    final useCase = ref.read(createPremiereMancheUseCaseProvider);
    await useCase(concoursId);

    if (!context.mounted) {
      return;
    }

    ref.invalidate(manchesByConcoursProvider(concoursId));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Première manche créée avec succès')),
    );
  } on Exception catch (e) {
    if (!context.mounted) {
      return;
    }
    final message = e.toString().replaceFirst('Exception: ', '');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
