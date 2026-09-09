import 'dart:math' show pi;

import 'package:belotable/domain/doublettes/doublette.dart';
import 'package:belotable/domain/doublettes/doublette_ranking.dart';
import 'package:belotable/domain/manches/manche.dart';
import 'package:belotable/domain/manches/table_de_jeu.dart';
import 'package:belotable/gen/assets.gen.dart';
import 'package:belotable/presentation/shared/display/display_column_layout.dart';
import 'package:belotable/presentation/shared/display/display_table_formatter.dart';
import 'package:belotable/utils/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const double _appBarIconRotationDegrees = -15;

/// Read-only screen projecting the current round table assignments.
/// Independent instances are opened via a display window service; data is
/// loaded once and reloaded only through the manual refresh control.
class DisplayScreenPage extends ConsumerWidget {
  /// Creates the display screen for the given concours id.
  const DisplayScreenPage({required this.concoursId, super.key});

  /// Route name prefix used to encode the target concours id in the route.
  static const routeNamePrefix = '/display/';

  /// Builds the route path opening the display screen for [concoursId].
  static String routePathFor(String concoursId) =>
      '$routeNamePrefix${Uri.encodeComponent(concoursId)}';

  /// Extracts the concours id from a route [name], or null if it does not
  /// match the display screen route pattern.
  static String? concoursIdFromRouteName(String name) {
    if (!name.startsWith(routeNamePrefix)) {
      return null;
    }
    final encoded = name.substring(routeNamePrefix.length);
    if (encoded.isEmpty) {
      return null;
    }
    return Uri.decodeComponent(encoded);
  }

  /// Target concours id.
  final String concoursId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final concoursAsync = ref.watch(concoursProvider(concoursId));
    final displayAsync = ref.watch(displayDataProvider(concoursId));
    final doublettesAsync = ref.watch(doublettesByConcoursProvider(concoursId));

    void refresh() {
      ref
        ..invalidate(concoursProvider(concoursId))
        ..invalidate(displayDataProvider(concoursId))
        ..invalidate(doublettesByConcoursProvider(concoursId));
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          children: [
            Transform.rotate(
              key: const Key('display_screen_app_bar_icon'),
              angle: _appBarIconRotationDegrees * pi / 180,
              child: Assets.icon.image(width: 32, height: 32),
            ),
            const SizedBox(width: 8),
            Text(
              concoursAsync.maybeWhen(
                data: (concours) =>
                    concours?.organisateur ?? "Écran d'affichage",
                orElse: () => "Écran d'affichage",
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            key: const Key('display_screen_refresh_button'),
            onPressed: refresh,
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: concoursAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(
          key: Key('display_screen_load_error'),
          child: Text('Erreur: impossible de charger le concours'),
        ),
        data: (concours) {
          if (concours == null) {
            return const Center(
              key: Key('display_screen_concours_not_found'),
              child: Text('Concours introuvable'),
            );
          }

          return displayAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => const Center(
              key: Key('display_screen_load_error'),
              child: Text('Erreur: impossible de charger les données'),
            ),
            data: (display) {
              final manche = display.manche;
              final doubletteCount = doublettesAsync.value?.length ?? 0;
              if (manche == null) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _DoubletteCountLabel(count: doubletteCount),
                      const SizedBox(height: 24),
                      const Expanded(
                        child: Center(
                          key: Key('display_screen_empty_state'),
                          child: Text(
                            // ignore: lines_longer_than_80_chars because UI
                            'La première manche va bientôt commencer. Veuillez patienter.',
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return _DisplayContent(
                manche: manche,
                tables: display.tables,
                doublettes: doublettesAsync.value ?? const [],
              );
            },
          );
        },
      ),
    );
  }
}

class _DisplayContent extends StatefulWidget {
  const _DisplayContent({
    required this.manche,
    required this.tables,
    required this.doublettes,
  });

  final Manche manche;
  final List<TableDeJeu> tables;
  final List<Doublette> doublettes;

  @override
  State<_DisplayContent> createState() => _DisplayContentState();
}

class _DisplayContentState extends State<_DisplayContent> {
  bool _tablesExpanded = true;
  bool _rankingExpanded = false;

  @override
  Widget build(BuildContext context) {
    final headerStyle = Theme.of(
      context,
    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold);
    final cellStyle = Theme.of(context).textTheme.titleMedium;
    final doubletteCount = widget.doublettes.length;
    final ranking = sortDoublettesByRanking(widget.doublettes);

    return Padding(
      key: const Key('display_screen_content'),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DoubletteCountLabel(count: doubletteCount),
          const SizedBox(height: 8),
          Text(
            'Manche ${widget.manche.numero}',
            key: const Key('display_screen_round_heading'),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          _buildCollapsibleSection(
            title: 'Tables',
            keyPrefix: 'display_screen_tables_card',
            expanded: _tablesExpanded,
            onToggle: () => setState(() => _tablesExpanded = !_tablesExpanded),
            content: (constraints) {
              final columnCount = resolveDisplayColumnCount(
                tableCount: widget.tables.length,
                availableHeight: constraints.maxHeight,
                availableWidth: constraints.maxWidth,
              );
              final columns = splitDisplayItemsIntoColumns(
                widget.tables,
                columnCount,
              );
              return _buildColumnsRow(
                columns.map(
                  (tables) => _buildTable(
                    tables: tables,
                    headerStyle: headerStyle,
                    cellStyle: cellStyle,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildCollapsibleSection(
            title: 'Classement',
            keyPrefix: 'display_screen_ranking_card',
            expanded: _rankingExpanded,
            onToggle: () =>
                setState(() => _rankingExpanded = !_rankingExpanded),
            content: (constraints) {
              final columnCount = resolveDisplayColumnCount(
                tableCount: ranking.length,
                availableHeight: constraints.maxHeight,
                availableWidth: constraints.maxWidth,
              );
              final columns = splitDisplayItemsIntoColumns(
                ranking,
                columnCount,
              );
              return _buildRankingColumnsRow(
                columns,
                headerStyle: headerStyle,
                cellStyle: cellStyle,
              );
            },
          ),
        ],
      ),
    );
  }

  /// Builds a collapsible card whose body is only built (and testable via
  /// `findsNothing`) while [expanded] is true. When expanded, the card grows
  /// to fill the remaining vertical space so [content] can measure it via
  /// `LayoutBuilder`, matching the pre-existing tables layout behavior.
  Widget _buildCollapsibleSection({
    required String title,
    required String keyPrefix,
    required bool expanded,
    required VoidCallback onToggle,
    required Widget Function(BoxConstraints constraints) content,
  }) {
    final header = InkWell(
      key: Key('${keyPrefix}_toggle'),
      onTap: onToggle,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Icon(expanded ? Icons.expand_less : Icons.expand_more),
          ],
        ),
      ),
    );

    if (!expanded) {
      return Card(child: header);
    }

    return Expanded(
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            header,
            Expanded(
              child: Padding(
                key: Key('${keyPrefix}_body'),
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: LayoutBuilder(
                  builder: (context, constraints) => content(constraints),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColumnsRow(Iterable<Widget> tables) {
    final children = tables.toList();
    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(width: displayColumnSpacing),
            Expanded(child: children[i]),
          ],
        ],
      ),
    );
  }

  /// Builds ranking columns, numbering rows continuously left-to-right so
  /// ranks stay accurate across column splits.
  Widget _buildRankingColumnsRow(
    List<List<Doublette>> columns, {
    TextStyle? headerStyle,
    TextStyle? cellStyle,
  }) {
    var offset = 0;
    final children = <Widget>[];
    for (var i = 0; i < columns.length; i++) {
      if (i > 0) {
        children.add(const SizedBox(width: displayColumnSpacing));
      }
      children.add(
        Expanded(
          child: _buildRankingTable(
            doublettes: columns[i],
            startRank: offset + 1,
            headerStyle: headerStyle,
            cellStyle: cellStyle,
          ),
        ),
      );
      offset += columns[i].length;
    }
    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildTable({
    required List<TableDeJeu> tables,
    TextStyle? headerStyle,
    TextStyle? cellStyle,
  }) {
    return Table(
      border: TableBorder.all(color: const Color(0xFFBDBDBD)),
      columnWidths: const {
        0: FlexColumnWidth(),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
      },
      children: [
        TableRow(
          decoration: const BoxDecoration(
            color: Color(0xFFE0E0E0),
          ),
          children: [
            _DisplayCell('Table n°', style: headerStyle),
            _DisplayCell('Doublette A', style: headerStyle),
            _DisplayCell('Doublette B', style: headerStyle),
          ],
        ),
        for (final table in tables)
          _buildTableRow(table: table, style: cellStyle),
      ],
    );
  }

  TableRow _buildTableRow({required TableDeJeu table, TextStyle? style}) {
    final labels = buildDisplaySlotLabels(table);
    return TableRow(
      children: [
        _DisplayCell(
          'Table ${table.numero}',
          style: style,
          rowKey: Key('display_screen_table_row_${table.numero}'),
        ),
        _DisplayCell(labels[0], style: style),
        _DisplayCell(labels[1], style: style),
      ],
    );
  }

  Widget _buildRankingTable({
    required List<Doublette> doublettes,
    required int startRank,
    TextStyle? headerStyle,
    TextStyle? cellStyle,
  }) {
    return Table(
      border: TableBorder.all(color: const Color(0xFFBDBDBD)),
      columnWidths: const {
        0: FlexColumnWidth(),
        1: FlexColumnWidth(3),
        2: FlexColumnWidth(2),
      },
      children: [
        TableRow(
          decoration: const BoxDecoration(
            color: Color(0xFFE0E0E0),
          ),
          children: [
            _DisplayCell('Rang', style: headerStyle),
            _DisplayCell('Doublette', style: headerStyle),
            _DisplayCell('Points', style: headerStyle),
          ],
        ),
        for (var i = 0; i < doublettes.length; i++)
          _buildRankingRow(
            doublette: doublettes[i],
            rank: startRank + i,
            style: cellStyle,
          ),
      ],
    );
  }

  TableRow _buildRankingRow({
    required Doublette doublette,
    required int rank,
    TextStyle? style,
  }) {
    return TableRow(
      children: [
        _DisplayCell(
          '$rank',
          style: style,
          rowKey: Key(
            'display_screen_ranking_row_'
            '${doublette.concoursId}_${doublette.doubletteId}',
          ),
        ),
        _DisplayCell(
          '${doublette.nomEquipe} (#${doublette.doubletteId})',
          style: style,
        ),
        _DisplayCell('${doublette.totalPoints}', style: style),
      ],
    );
  }
}

class _DisplayCell extends StatelessWidget {
  const _DisplayCell(this.label, {this.style, this.rowKey});

  final String label;
  final TextStyle? style;

  /// Key attached to the cell so tests can locate the row (TableRow itself
  /// is not part of the widget/element tree).
  final Key? rowKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: rowKey,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Text(label, style: style),
    );
  }
}

class _DoubletteCountLabel extends StatelessWidget {
  const _DoubletteCountLabel({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Text(
      count == 0
          ? 'Inscription des doublettes en cours'
          : '$count doublettes inscrites',
      key: const Key('display_screen_doublette_count_label'),
      style: Theme.of(context).textTheme.titleMedium,
    );
  }
}
