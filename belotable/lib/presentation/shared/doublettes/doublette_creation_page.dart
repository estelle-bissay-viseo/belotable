import 'package:belotable/domain/doublettes/doublette_exceptions.dart';
import 'package:belotable/domain/doublettes/team_name_dictionary.dart';
import 'package:belotable/domain/manches/manche_exceptions.dart';
import 'package:belotable/utils/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Page for creating a new doublette.
class DoubletteCreationPage extends ConsumerStatefulWidget {
  /// Creates doublette creation page.
  const DoubletteCreationPage({
    required this.concoursId,
    super.key,
  });

  /// Route name for navigation to this page.
  static const routeName = '/doublettes/create';

  /// Owning concours id.
  final String concoursId;

  @override
  ConsumerState<DoubletteCreationPage> createState() =>
      _DoubletteCreationPageState();
}

class _DoubletteCreationPageState extends ConsumerState<DoubletteCreationPage> {
  final _formKey = GlobalKey<FormState>();
  final _joueurAController = TextEditingController();
  final _joueurBController = TextEditingController();
  final _nomEquipeController = TextEditingController();

  bool _isSaving = false;
  bool _isInitialized = false;

  @override
  void dispose() {
    _joueurAController.dispose();
    _joueurBController.dispose();
    _nomEquipeController.dispose();
    super.dispose();
  }

  Future<void> _ensureSuggestedTeamName() async {
    if (_isInitialized) {
      return;
    }

    _isInitialized = true;
    final createUseCase = ref.read(createDoubletteUseCaseProvider);
    final suggestion = await createUseCase.suggestTeamName(widget.concoursId);
    if (!mounted) {
      return;
    }
    _nomEquipeController.text = suggestion;
  }

  Future<void> _save() async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      final createUseCase = ref.read(createDoubletteUseCaseProvider);
      await createUseCase(
        concoursId: widget.concoursId,
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
    } on PremiereMancheTermineeException catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  String? _validateRequired(String? value, String error) {
    if (value == null || value.trim().isEmpty) {
      return error;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _ensureSuggestedTeamName(),
      builder: (context, snapshot) {
        final isLoading = snapshot.connectionState != ConnectionState.done;

        return Scaffold(
          appBar: AppBar(title: const Text('Créer une doublette')),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Form(
                  key: _formKey,
                  child: ListView(
                    key: const Key('doublette_creation_form'),
                    padding: const EdgeInsets.all(16),
                    children: [
                      TextFormField(
                        key: const Key('doublette_creation_joueur_a_field'),
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
                        key: const Key('doublette_creation_joueur_b_field'),
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
                        key: const Key('doublette_creation_nom_equipe_field'),
                        controller: _nomEquipeController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: "Nom d'équipe",
                          helperText: teamNameDictionary.isEmpty
                              ? null
                              : 'Suggestion initiale automatique',
                        ),
                        validator: (value) => _validateRequired(
                          value,
                          "Nom d'équipe obligatoire",
                        ),
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        key: const Key('doublette_creation_validate_button'),
                        onPressed: _isSaving ? null : _save,
                        child: _isSaving
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Valider'),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        key: const Key('doublette_creation_cancel_button'),
                        onPressed: _isSaving
                            ? null
                            : () => Navigator.of(context).pop(),
                        child: const Text('Annuler'),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
