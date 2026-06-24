import 'dart:async';

import 'package:belotable/domain/manches/deal_points.dart';
import 'package:belotable/domain/manches/manche_statut.dart';
import 'package:belotable/domain/manches/table_de_jeu.dart';
import 'package:belotable/domain/manches/table_doublette.dart';
import 'package:belotable/presentation/shared/manches/deal_sum_utils.dart';
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
                      mancheId: mancheId,
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
  const _TableDeJeuCard({
    required this.table,
    required this.mancheId,
    required this.onRefresh,
  });

  final TableDeJeu table;
  final int mancheId;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card.outlined(
      key: Key('table_card_${table.numero}'),
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
            else ...[
              ...table.doublettes.map(
                (td) => _TableDoubletteRow(
                  key: Key('td_row_${table.numero}_${td.doubletteId}'),
                  tableDoublette: td,
                  tableId: table.id,
                  tableNumero: table.numero,
                  mancheId: mancheId,
                  onRefresh: onRefresh,
                ),
              ),
              _TableSumRow(
                table: table,
                mancheId: mancheId,
              ),
            ],
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

class _TableDoubletteRow extends ConsumerWidget {
  const _TableDoubletteRow({
    required this.tableDoublette,
    required this.tableId,
    required this.tableNumero,
    required this.mancheId,
    required this.onRefresh,
    super.key,
  });

  final TableDoublette tableDoublette;
  final int tableId;
  final int tableNumero;
  final int mancheId;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dealPointsAsync = ref.watch(
      dealPointsByTableDoubletteProvider(
        (
          tableId: tableId,
          concoursId: tableDoublette.concoursId,
          doubletteId: tableDoublette.doubletteId,
          mancheId: mancheId,
        ),
      ),
    );

    return dealPointsAsync.when(
      loading: () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Expanded(
              child: Text(tableDoublette.nomEquipe),
            ),
            const SizedBox(width: 8),
            const CircularProgressIndicator(),
          ],
        ),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text('Erreur: $e'),
      ),
      data: (dealPoints) => _DealPointsRow(
        tableDoublette: tableDoublette,
        tableId: tableId,
        tableNumero: tableNumero,
        mancheId: mancheId,
        dealPoints: dealPoints,
        onRefresh: onRefresh,
      ),
    );
  }
}

class _DealPointsRow extends ConsumerStatefulWidget {
  const _DealPointsRow({
    required this.tableDoublette,
    required this.tableId,
    required this.tableNumero,
    required this.mancheId,
    required this.dealPoints,
    required this.onRefresh,
  });

  final TableDoublette tableDoublette;
  final int tableId;
  final int tableNumero;
  final int mancheId;
  final List<DealPoints> dealPoints;
  final VoidCallback onRefresh;

  @override
  ConsumerState<_DealPointsRow> createState() => _DealPointsRowState();
}

class _DealPointsRowState extends ConsumerState<_DealPointsRow> {
  late final List<TextEditingController> _dealControllers;
  late final List<FocusNode> _dealFocusNodes;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _dealControllers = List.generate(
      widget.dealPoints.length,
      (i) => TextEditingController(
        text: widget.dealPoints[i].points.toString(),
      ),
    );
    _dealFocusNodes = List.generate(
      widget.dealPoints.length,
      (i) => FocusNode(),
    );
    // Attach listeners to focus nodes
    for (var i = 0; i < _dealFocusNodes.length; i++) {
      _dealFocusNodes[i].addListener(() async {
        if (!_dealFocusNodes[i].hasFocus) {
          await _saveDealPoints(i + 1);
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _dealControllers) {
      controller.dispose();
    }
    for (final focusNode in _dealFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  Future<void> _saveDealPoints(int dealNumber) async {
    final points =
        int.tryParse(_dealControllers[dealNumber - 1].text.trim()) ?? 0;

    // Validate >= 0
    if (points < 0) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Les points doivent être >= 0'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      // Reset to previous value
      _dealControllers[dealNumber - 1].text = widget
          .dealPoints[dealNumber - 1]
          .points
          .toString();
      return;
    }

    setState(() => _isSaving = true);
    try {
      final updateUseCase = ref.read(updateManchePointsUseCaseProvider);
      await updateUseCase(
        tableId: widget.tableDoublette.tableId,
        concoursId: widget.tableDoublette.concoursId,
        doubletteId: widget.tableDoublette.doubletteId,
        mancheId: widget.mancheId,
        dealNumber: dealNumber,
        points: points,
      );
      // Invalidate deal points provider to update total score
      ref.invalidate(
        dealPointsByTableDoubletteProvider(
          (
            tableId: widget.tableDoublette.tableId,
            concoursId: widget.tableDoublette.concoursId,
            doubletteId: widget.tableDoublette.doubletteId,
            mancheId: widget.mancheId,
          ),
        ),
      );
      widget.onRefresh();
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
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
    final total = widget.dealPoints.fold<int>(0, (sum, dp) => sum + dp.points);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${td.nomEquipe} (#${td.doubletteId})',
                      style: TextStyle(
                        fontWeight: _isWinner
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: _isWinner ? Colors.green[700] : null,
                      ),
                      key: Key(
                        // ignore: lines_longer_than_80_chars because UI key
                        'doublette_name_${widget.tableNumero}_${td.doubletteId}',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Deal inputs row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      widget.dealPoints.length,
                      (i) {
                        final dealNumber = i + 1;
                        return Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: SizedBox(
                            width: 60,
                            child: TextField(
                              key: Key(
                                // ignore: lines_longer_than_80_chars because UI key
                                'points_field_${widget.tableNumero}_${td.doubletteId}_$dealNumber',
                              ),
                              controller: _dealControllers[i],
                              focusNode: _dealFocusNodes[i],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: 'D$dealNumber',
                                isDense: true,
                              ),
                              enabled: !_isSaving,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Total score (read-only)
          SizedBox(
            width: 95,
            child: InputDecorator(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Score final',
                isDense: true,
              ),
              child: Text(
                total.toString(),
                key: Key('total_field_${widget.tableNumero}_${td.doubletteId}'),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(width: 8),
          DropdownButton<TableDoubletteStatut>(
            key: Key('statut_dropdown_${widget.tableNumero}_${td.doubletteId}'),
            value: td.statut,
            items: TableDoubletteStatut.values
                .map(
                  (s) => DropdownMenuItem(
                    key: Key(
                      // ignore: lines_longer_than_80_chars because UI key
                      'statut_dropdown_item_${widget.tableNumero}_${td.doubletteId}_${s.name}',
                    ),
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

class _TableSumRow extends ConsumerWidget {
  const _TableSumRow({
    required this.table,
    required this.mancheId,
  });

  final TableDeJeu table;
  final int mancheId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstDoublette = table.doublettes.isNotEmpty
        ? table.doublettes[0]
        : null;
    if (firstDoublette == null) {
      return const SizedBox.shrink();
    }

    final concoursAsync = ref.watch(
      concoursProvider(firstDoublette.concoursId),
    );

    return concoursAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (concours) {
        if (concours == null || concours.nombreMaxPointsParDonne == 0) {
          return const SizedBox.shrink();
        }

        // Fetch dealPoints for all doublettes
        final allDealPointsAsync = <AsyncValue<List<DealPoints>>>[];
        for (final td in table.doublettes) {
          allDealPointsAsync.add(
            ref.watch(
              dealPointsByTableDoubletteProvider(
                (
                  tableId: table.id,
                  concoursId: td.concoursId,
                  doubletteId: td.doubletteId,
                  mancheId: mancheId,
                ),
              ),
            ),
          );
        }

        // Check if any are loading or error
        final isLoading = allDealPointsAsync.any((av) => av.isLoading);
        final hasError = allDealPointsAsync.any((av) => av.hasError);

        if (isLoading || hasError) {
          return const SizedBox.shrink();
        }

        // Combine all dealPoints
        final combinedPoints = <DealPoints>[];
        for (final dpAsync in allDealPointsAsync) {
          dpAsync.whenData(combinedPoints.addAll);
        }

        final sums = computeTableDealSums(combinedPoints);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Somme des points par donne',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    sums.length,
                    (i) {
                      final dealNumber = i + 1;
                      final dealSum = sums[i];
                      final sumColor = getDealSumColor(
                        dealSum,
                        concours.nombreMaxPointsParDonne,
                      );
                      return Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: SizedBox(
                          width: 60,
                          child: InputDecorator(
                            key: Key(
                              'table_sum_${table.numero}_$dealNumber',
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: sumColor,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: sumColor,
                                ),
                              ),
                              labelText: 'D$dealNumber',
                              isDense: true,
                              floatingLabelStyle: TextStyle(color: sumColor),
                            ),
                            child: Text(
                              dealSum.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: sumColor),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Shows confirmation dialog before creating the next manche and navigates
/// to it if confirmed. Blocks creation if previous manche exists and is not
/// finished.
/// Also handles PremiereMancheTermineeException for doublette creation.
Future<void> showCreatePremiereMancheDialog(
  BuildContext context,
  WidgetRef ref,
  String concoursId,
) async {
  // Check if a manche exists and is not finished
  final mancheRepo = ref.read(mancheRepositoryProvider);
  final latestManche = await mancheRepo.findLatestManche(concoursId);

  if (latestManche != null && latestManche.statut != MancheStatut.termine) {
    // Show blocking dialog
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Manche précédente non terminée'),
        content: const Text(
          'Vous ne pouvez pas préparer une nouvelle manche tant que '
          "la manche précédente n'est pas terminée.",
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    return;
  }

  final title = latestManche == null
      ? 'Préparer la première manche ?'
      : 'Préparer une nouvelle manche ?';

  if (!context.mounted) return;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: const Text(
        'Les doublettes seront réparties automatiquement '
        'en tables par classement (points descendants, '
        "puis date d'inscription).",
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
    final useCase = ref.read(createNextMancheUseCaseProvider);
    await useCase(concoursId);

    if (!context.mounted) {
      return;
    }

    ref.invalidate(manchesByConcoursProvider(concoursId));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Manche créée avec succès')),
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
