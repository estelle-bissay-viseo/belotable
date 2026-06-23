import 'package:belotable/domain/concours/concours.dart';
import 'package:belotable/domain/manches/manche.dart';
import 'package:belotable/presentation/shared/doublettes/doublette_navigation_args.dart';
import 'package:belotable/presentation/shared/doublettes/doublettes_list_page.dart';
import 'package:belotable/presentation/shared/doublettes/doublettes_ranking_args.dart';
import 'package:belotable/presentation/shared/doublettes/doublettes_ranking_page.dart';
import 'package:belotable/presentation/shared/manches/manche_navigation_args.dart';
import 'package:belotable/presentation/shared/manches/manche_page.dart';
import 'package:belotable/presentation/shared/utils/info_field.dart';
import 'package:belotable/utils/date_format.dart';
import 'package:belotable/utils/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Page for managing one concours during event day.
class ConcoursManagePage extends ConsumerStatefulWidget {
  /// Creates management page for given concours id.
  const ConcoursManagePage({
    required this.concoursId,
    super.key,
  });

  /// Route name for navigation to this page.
  static const routeName = '/concours/detail';

  /// Target concours id.
  final String concoursId;

  @override
  ConsumerState<ConcoursManagePage> createState() => _ConcoursManagePageState();
}

class _ConcoursManagePageState extends ConsumerState<ConcoursManagePage> {
  late final Future<Concours?> _loadFuture;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadFuture = _loadConcours();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<Concours?> _loadConcours() {
    final repository = ref.read(concoursRepositoryProvider);
    return repository.findById(widget.concoursId);
  }

  void _initializeForm(Concours concours) {
    if (_isInitialized) {
      return;
    }
    _isInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Concours?>(
      future: _loadFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final concours = snapshot.data;
        if (concours == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Gérer un concours')),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Concours introuvable'),
                  const SizedBox(height: 12),
                  TextButton(
                    key: const Key('concours_detail_back_button'),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Retour à la liste'),
                  ),
                ],
              ),
            ),
          );
        }

        _initializeForm(concours);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Gérer un concours'),
          ),
          body: ListView(
            key: const Key('concours_detail_form'),
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                key: const Key('concours_detail_general_section'),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informations générales',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      InfoField(
                        key: const Key('concours_detail_id_field'),
                        label: 'Id',
                        value: concours.id,
                      ),
                      const SizedBox(height: 12),
                      InfoField(
                        key: const Key('concours_detail_date_field'),
                        label: 'Date',
                        value: formatDateFrLettres(concours.date),
                      ),
                      const SizedBox(height: 12),
                      InfoField(
                        key: const Key('concours_detail_lieu_field'),
                        label: 'Lieu',
                        value: concours.lieu,
                      ),
                      const SizedBox(height: 12),
                      InfoField(
                        key: const Key('concours_detail_organisateur_field'),
                        label: 'Organisateur',
                        value: concours.organisateur,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                key: const Key('concours_detail_parametres_section'),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Paramètres du concours',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      InfoField(
                        key: const Key('concours_detail_donnes_field'),
                        label: 'Nombre de donnes par manche',
                        value: concours.nombreDonnesParManche.toString(),
                      ),
                      const SizedBox(height: 12),
                      InfoField(
                        key: const Key('concours_detail_max_points_field'),
                        label: 'Nombre maximum de points par donne',
                        value: concours.nombreMaxPointsParDonne.toString(),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Règles de jeu :',
                        key: Key('concours_detail_regles_field'),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          concours.reglesJeu,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                key: const Key('concours_detail_jour_j_section'),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Le jour J',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Consumer(
                            builder: (context, ref, _) {
                              return FilledButton.tonalIcon(
                                key: const Key(
                                  'concours_detail_pdf_table_button',
                                ),
                                onPressed: () async {
                                  final useCase = ref.read(
                                    generateConcoursTablePdfUseCaseProvider,
                                  );
                                  try {
                                    final bytes = await useCase(
                                      widget.concoursId,
                                    );
                                    final pdfExportService = ref.read(
                                      pdfExportServiceProvider,
                                    );
                                    if (context.mounted) {
                                      await pdfExportService.saveAndOpen(bytes);
                                    }
                                  } on Exception {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            // ignore: lines_longer_than_80_chars because short
                                            'Erreur: Impossible de générer le PDF',
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                                label: const Text('PDF pour les tables'),
                                icon: const Icon(Icons.picture_as_pdf),
                                iconAlignment: .start,
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          FilledButton.tonalIcon(
                            key: const Key('concours_detail_doublettes_button'),
                            onPressed: () => Navigator.of(context).pushNamed(
                              DoublettesListPage.routeName,
                              arguments: DoublettesListArgs(
                                concoursId: widget.concoursId,
                              ),
                            ),
                            label: const Text('Doublettes'),
                            icon: const Icon(Icons.group),
                            iconAlignment: .start,
                          ),
                          const SizedBox(width: 8),
                          Consumer(
                            builder: (context, ref, _) {
                              final manchesAsync = ref.watch(
                                manchesByConcoursProvider(widget.concoursId),
                              );
                              return manchesAsync.when(
                                loading: () => const SizedBox.shrink(),
                                error: (_, _) => const SizedBox.shrink(),
                                data: (manches) {
                                  if (manches.isEmpty) {
                                    return const SizedBox.shrink();
                                  }
                                  return FilledButton.tonalIcon(
                                    key: const Key(
                                      'concours_detail_ranking_button',
                                    ),
                                    onPressed: () =>
                                        Navigator.of(context).pushNamed(
                                          DoublettesRankingPage.routeName,
                                          arguments: DoublettesRankingArgs(
                                            concoursId: widget.concoursId,
                                          ),
                                        ),
                                    label: const Text('Voir le classement'),
                                    icon: const Icon(Icons.leaderboard),
                                    iconAlignment: .start,
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Consumer(
                        builder: (context, ref, _) {
                          final manchesAsync = ref.watch(
                            manchesByConcoursProvider(widget.concoursId),
                          );
                          return manchesAsync.when(
                            loading: () => const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            error: (_, _) =>
                                const Text('Erreur chargement manches'),
                            data: (manches) => Row(
                              children: [
                                if (manches.isNotEmpty) ...[
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: manches
                                        .map((m) => _MancheButton(manche: m))
                                        .toList(),
                                  ),
                                ],
                                if (manches.isNotEmpty)
                                  const SizedBox(width: 8),
                                FilledButton.tonalIcon(
                                  key: const Key(
                                    'concours_detail_prepare_manche_button',
                                  ),
                                  onPressed: () =>
                                      showCreatePremiereMancheDialog(
                                        context,
                                        ref,
                                        widget.concoursId,
                                      ),
                                  label: const Text(
                                    'Préparer une nouvelle manche',
                                  ),
                                  icon: const Icon(Icons.sports_score),
                                  iconAlignment: .start,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
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

/// Button navigating to manche management page.
class _MancheButton extends StatelessWidget {
  const _MancheButton({required this.manche});

  final Manche manche;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      key: Key('concours_detail_manche_button_${manche.id}'),
      onPressed: () => Navigator.of(context).pushNamed(
        ManchePage.routeName,
        arguments: ManchePageArgs(
          mancheId: manche.id,
          mancheNumero: manche.numero,
        ),
      ),
      label: Text('Manche ${manche.numero}'),
      icon: const Icon(Icons.table_chart),
      iconAlignment: .start,
    );
  }
}
