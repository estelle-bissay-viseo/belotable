import 'dart:math' show pi;

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

    void refresh() {
      ref
        ..invalidate(concoursProvider(concoursId))
        ..invalidate(displayDataProvider(concoursId));
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
              if (manche == null) {
                return const Center(
                  key: Key('display_screen_empty_state'),
                  child: Text(
                    // ignore: lines_longer_than_80_chars because UI
                    'La première manche va bientôt commencer. Veuillez patienter.',
                  ),
                );
              }
              return _DisplayContent(manche: manche, tables: display.tables);
            },
          );
        },
      ),
    );
  }
}

class _DisplayContent extends StatelessWidget {
  const _DisplayContent({required this.manche, required this.tables});

  final Manche manche;
  final List<TableDeJeu> tables;

  @override
  Widget build(BuildContext context) {
    final headerStyle = Theme.of(
      context,
    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold);
    final cellStyle = Theme.of(context).textTheme.titleMedium;

    return Padding(
      key: const Key('display_screen_content'),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Manche ${manche.numero}',
            key: const Key('display_screen_round_heading'),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final columnCount = resolveDisplayColumnCount(
                  tableCount: tables.length,
                  availableHeight: constraints.maxHeight,
                  availableWidth: constraints.maxWidth,
                );
                final columns = splitDisplayTablesIntoColumns(
                  tables,
                  columnCount,
                );

                return SingleChildScrollView(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < columns.length; i++) ...[
                        if (i > 0) const SizedBox(width: displayColumnSpacing),
                        Expanded(
                          child: _buildTable(
                            tables: columns[i],
                            headerStyle: headerStyle,
                            cellStyle: cellStyle,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ],
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
