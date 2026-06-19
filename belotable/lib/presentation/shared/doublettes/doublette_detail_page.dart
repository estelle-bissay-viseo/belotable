import 'package:belotable/domain/doublettes/doublette.dart';
import 'package:belotable/domain/doublettes/doublette_exceptions.dart';
import 'package:belotable/domain/manches/points_history_provider.dart';
import 'package:belotable/presentation/shared/utils/info_field.dart';
import 'package:belotable/utils/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Page for viewing and editing one doublette.
class DoubletteDetailPage extends ConsumerStatefulWidget {
  /// Creates detail page for one doublette.
  const DoubletteDetailPage({
    required this.concoursId,
    required this.doubletteId,
    super.key,
  });

  /// Route name for navigation to this page.
  static const routeName = '/doublettes/detail';

  /// Owning concours id.
  final String concoursId;

  /// Target doublette id.
  final int doubletteId;

  @override
  ConsumerState<DoubletteDetailPage> createState() =>
      _DoubletteDetailPageState();
}

class _DoubletteDetailPageState extends ConsumerState<DoubletteDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _joueurAController = TextEditingController();
  final _joueurBController = TextEditingController();
  final _nomEquipeController = TextEditingController();

  late final Future<Doublette?> _loadFuture;
  bool _isInitialized = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadFuture = _loadDoublette();
  }

  @override
  void dispose() {
    _joueurAController.dispose();
    _joueurBController.dispose();
    _nomEquipeController.dispose();
    super.dispose();
  }

  Future<Doublette?> _loadDoublette() {
    final repository = ref.read(doubletteRepositoryProvider);
    return repository.findById(
      concoursId: widget.concoursId,
      doubletteId: widget.doubletteId,
    );
  }

  void _initializeForm(Doublette doublette) {
    if (_isInitialized) {
      return;
    }

    _joueurAController.text = doublette.joueurA;
    _joueurBController.text = doublette.joueurB;
    _nomEquipeController.text = doublette.nomEquipe;
    _isInitialized = true;
  }

  String? _validateRequired(String? value, String error) {
    if (value == null || value.trim().isEmpty) {
      return error;
    }
    return null;
  }

  Future<void> _save() async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      final updateUseCase = ref.read(updateDoubletteUseCaseProvider);
      await updateUseCase(
        concoursId: widget.concoursId,
        doubletteId: widget.doubletteId,
        joueurA: _joueurAController.text,
        joueurB: _joueurBController.text,
        nomEquipe: _nomEquipeController.text,
      );

      if (!mounted) {
        return;
      }
      Navigator.of(context).pop(true);
    } on DuplicateTeamNameException {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Nom d'équipe déjà utilisé pour ce concours"),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Doublette?>(
      future: _loadFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final doublette = snapshot.data;
        if (doublette == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Gérer la doublette')),
            body: const Center(child: Text('Doublette introuvable')),
          );
        }

        _initializeForm(doublette);

        return Scaffold(
          appBar: AppBar(title: const Text('Gérer la doublette')),
          body: Form(
            key: _formKey,
            child: ListView(
              key: const Key('doublette_detail_form'),
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  key: const Key('doublette_detail_joueur_a_field'),
                  controller: _joueurAController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Joueur A',
                  ),
                  validator: (value) =>
                      _validateRequired(value, 'Joueur A obligatoire'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: const Key('doublette_detail_joueur_b_field'),
                  controller: _joueurBController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Joueur B',
                  ),
                  validator: (value) =>
                      _validateRequired(value, 'Joueur B obligatoire'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: const Key('doublette_detail_nom_equipe_field'),
                  controller: _nomEquipeController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Nom d'équipe",
                  ),
                  validator: (value) =>
                      _validateRequired(value, "Nom d'équipe obligatoire"),
                ),
                const SizedBox(height: 24),
                InfoField(
                  key: const Key('doublette_points_total'),
                  label: 'Total des points',
                  value: doublette.totalPoints.toString(),
                ),
                const SizedBox(height: 24),
                _PointsHistorySection(
                  concoursId: widget.concoursId,
                  doubletteId: widget.doubletteId,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  key: const Key('doublette_detail_validate_button'),
                  onPressed: _isSaving ? null : _save,
                  child: _isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Valider les modifications'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  key: const Key('doublette_detail_cancel_button'),
                  onPressed: _isSaving
                      ? null
                      : () => Navigator.of(context).pop(),
                  child: const Text('Annuler les modifications'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PointsHistorySection extends ConsumerWidget {
  const _PointsHistorySection({
    required this.concoursId,
    required this.doubletteId,
  });

  final String concoursId;
  final int doubletteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pointsAsync = ref.watch(
      pointsHistoryProvider((concoursId, doubletteId)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Points par manche',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        pointsAsync.when(
          loading: () => const CircularProgressIndicator(),
          error: (_, _) => const Text('Erreur lors du chargement'),
          data: (points) {
            if (points.isEmpty) {
              return const Text('Aucune participation enregistrée');
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Table(
                  key: const Key('doublette_points_history_table'),
                  columnWidths: const {
                    0: FlexColumnWidth(0.6),
                    1: FlexColumnWidth(0.8),
                    2: FlexColumnWidth(1.2),
                  },
                  border: TableBorder.all(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            'Manche',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            'Points',
                            style: Theme.of(context).textTheme.labelMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            'Statut',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            'Concurrents',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                      ],
                    ),
                    ...points.map(
                      (p) => TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              'Manche ${p.mancheNum}',
                              key: Key(
                                // ignore: lines_longer_than_80_chars because of UI key
                                'doublette_points_history_manche_${p.mancheNum}',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              p.points.toString(),
                              textAlign: TextAlign.center,
                              key: Key(
                                // ignore: lines_longer_than_80_chars because of UI key
                                'doublette_points_history_points_${p.mancheNum}',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              p.statut,
                              key: Key(
                                // ignore: lines_longer_than_80_chars because of UI key
                                'doublette_points_history_statut_${p.mancheNum}',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              p.opponentName.isNotEmpty
                                  ? '${p.opponentName} (#${p.opponentId})'
                                  : '-',
                              key: Key(
                                // ignore: lines_longer_than_80_chars because UI key
                                'doublette_points_history_opponent_${p.mancheNum}',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
