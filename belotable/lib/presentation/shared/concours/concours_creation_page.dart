import 'package:belotable/domain/concours/default_game_rules.dart';
import 'package:belotable/utils/date_format.dart';
import 'package:belotable/utils/providers.dart';
import 'package:belotable/utils/widgets/integer_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Page for creating a new Concours
class ConcoursCreationPage extends ConsumerStatefulWidget {
  /// Constructor
  const ConcoursCreationPage({super.key});

  /// Route name for navigation to this page
  static const routeName = '/concours/create';

  @override
  ConsumerState<ConcoursCreationPage> createState() =>
      _ConcoursCreationPageState();
}

class _ConcoursCreationPageState extends ConsumerState<ConcoursCreationPage> {
  final _formKey = GlobalKey<FormState>();
  final _lieuController = TextEditingController();
  final _organisateurController = TextEditingController();
  final _reglesJeuController = TextEditingController();
  final _nombreDonnesController = TextEditingController();
  final _nombreMaxPointsController = TextEditingController();

  late DateTime _selectedDate;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
    _reglesJeuController.text = defaultGameRules;
    _nombreDonnesController.text = '10';
    _nombreMaxPointsController.text = '162';
  }

  @override
  void dispose() {
    _lieuController.dispose();
    _organisateurController.dispose();
    _reglesJeuController.dispose();
    _nombreDonnesController.dispose();
    _nombreMaxPointsController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) {
      return;
    }

    setState(() {
      _selectedDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
      );
    });
  }

  Future<void> _saveConcours() async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      final createConcoursUseCase = ref.read(createConcoursUseCaseProvider);

      await createConcoursUseCase(
        date: _selectedDate,
        lieu: _lieuController.text,
        organisateur: _organisateurController.text,
        nombreDonnesParManche: int.tryParse(_nombreDonnesController.text) ?? 10,
        nombreMaxPointsParDonne:
            int.tryParse(_nombreMaxPointsController.text) ?? 162,
        reglesJeu: _reglesJeuController.text,
      );

      if (!mounted) return;

      Navigator.of(context).pop();
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un concours'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          key: const Key('concours_creation_form'),
          padding: const EdgeInsets.all(16),
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Date'),
              subtitle: Text(
                formatDateFrLettres(_selectedDate),
              ),
              trailing: TextButton(
                key: const Key('concours_date_button'),
                onPressed: _pickDate,
                child: const Text('Choisir une date'),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const Key('concours_lieu_field'),
              controller: _lieuController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Lieu',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Lieu obligatoire';
                }

                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const Key('concours_organisateur_field'),
              controller: _organisateurController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Organisateur',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Organisateur obligatoire';
                }

                return null;
              },
            ),
            const SizedBox(height: 12),
            IntegerFormField(
              key: const Key('concours_nombre_donnes_field'),
              controller: _nombreDonnesController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nombre de donnes par manche',
              ),
              min: 1,
            ),
            const SizedBox(height: 12),
            IntegerFormField(
              key: const Key('concours_nombre_max_points_field'),
              controller: _nombreMaxPointsController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nombre maximum de points par donne',
              ),
              min: 0,
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: const Key('concours_regles_jeu_field'),
              controller: _reglesJeuController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Règles de jeu',
              ),
              maxLines: 6,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Règles de jeu obligatoires';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            FilledButton(
              key: const Key('concours_validate_button'),
              onPressed: _isSaving ? null : _saveConcours,
              child: _isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Valider'),
            ),
            const SizedBox(height: 8),
            TextButton(
              key: const Key('concours_cancel_button'),
              onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
          ],
        ),
      ),
    );
  }
}
