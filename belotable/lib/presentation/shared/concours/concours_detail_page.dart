import 'package:belotable/domain/concours/concours.dart';
import 'package:belotable/presentation/shared/doublettes/doublette_navigation_args.dart';
import 'package:belotable/presentation/shared/doublettes/doublettes_list_page.dart';
import 'package:belotable/utils/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Page for viewing and editing one concours.
class ConcoursDetailPage extends ConsumerStatefulWidget {
  /// Creates detail page for the given concours id.
  const ConcoursDetailPage({
    required this.concoursId,
    super.key,
  });

  /// Route name for navigation to this page.
  static const routeName = '/concours/detail';

  /// Target concours id.
  final String concoursId;

  @override
  ConsumerState<ConcoursDetailPage> createState() => _ConcoursDetailPageState();
}

class _ConcoursDetailPageState extends ConsumerState<ConcoursDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _lieuController = TextEditingController();
  final _organisateurController = TextEditingController();

  late final Future<Concours?> _loadFuture;
  late DateTime _selectedDate;
  bool _isInitialized = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _loadFuture = _loadConcours();
  }

  @override
  void dispose() {
    _idController.dispose();
    _lieuController.dispose();
    _organisateurController.dispose();
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

    _idController.text = concours.id;
    _selectedDate = concours.date;
    _lieuController.text = concours.lieu;
    _organisateurController.text = concours.organisateur;
    _isInitialized = true;
  }

  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  bool _hasChanges(Concours initial) {
    return _selectedDate != initial.date ||
        _lieuController.text.trim() != initial.lieu ||
        _organisateurController.text.trim() != initial.organisateur;
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

  Future<bool> _confirmDiscardChanges() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Annuler les modifications ?'),
          content: const Text(
            'Les modifications non enregistrées seront perdues.',
          ),
          actions: [
            TextButton(
              key: const Key('concours_detail_discard_keep_editing_button'),
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Continuer édition'),
            ),
            FilledButton(
              key: const Key('concours_detail_discard_confirm_button'),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Annuler les modifications'),
            ),
          ],
        );
      },
    );

    return confirmed ?? false;
  }

  Future<bool> _canPop(Concours initial) async {
    if (!_hasChanges(initial) || _isSaving) {
      return true;
    }

    return _confirmDiscardChanges();
  }

  Future<void> _cancel(Concours initial) async {
    final canClose = await _canPop(initial);
    if (!mounted || !canClose) {
      return;
    }

    Navigator.of(context).pop();
  }

  Future<void> _save() async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      final updateUseCase = ref.read(updateConcoursUseCaseProvider);
      await updateUseCase(
        id: _idController.text,
        date: _selectedDate,
        lieu: _lieuController.text,
        organisateur: _organisateurController.text,
      );

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
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
            appBar: AppBar(title: const Text('Informations concours')),
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

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) {
              return;
            }

            final canClose = await _canPop(concours);
            if (!mounted || !canClose) {
              return;
            }

            Navigator.of(this.context).pop();
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Informations concours'),
            ),
            body: Form(
              key: _formKey,
              child: ListView(
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
                          TextFormField(
                            key: const Key('concours_detail_id_field'),
                            controller: _idController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Id',
                            ),
                          ),
                          const SizedBox(height: 12),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Date'),
                            subtitle: Text(_formatDate(_selectedDate)),
                            trailing: TextButton(
                              key: const Key('concours_detail_date_button'),
                              onPressed: _isSaving ? null : _pickDate,
                              child: const Text('Choisir une date'),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            key: const Key('concours_detail_lieu_field'),
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
                            key: const Key(
                              'concours_detail_organisateur_field',
                            ),
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
                          FilledButton.tonalIcon(
                            key: const Key('concours_detail_doublettes_button'),
                            onPressed: _isSaving
                                ? null
                                : () => Navigator.of(context).pushNamed(
                                    DoublettesListPage.routeName,
                                    arguments: DoublettesListArgs(
                                      concoursId: widget.concoursId,
                                    ),
                                  ),
                            label: const Text('Doublettes'),
                            icon: const Icon(Icons.group),
                            iconAlignment: .start,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  FilledButton(
                    key: const Key('concours_detail_validate_button'),
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
                    key: const Key('concours_detail_cancel_button'),
                    onPressed: _isSaving ? null : () => _cancel(concours),
                    child: const Text('Annuler les modifications'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
