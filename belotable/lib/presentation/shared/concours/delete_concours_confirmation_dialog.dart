import 'package:belotable/domain/concours/concours.dart';
import 'package:flutter/material.dart';

/// Dialog for confirming competition deletion.
class DeleteConcoursConfirmationDialog extends StatelessWidget {
  /// Creates confirmation dialog.
  const DeleteConcoursConfirmationDialog({
    required this.concours,
    required this.onConfirm,
    super.key,
  });

  /// Competition to delete.
  final Concours concours;

  /// Callback when user confirms deletion.
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        '${concours.date.year.toString().padLeft(4, '0')}-'
        '${concours.date.month.toString().padLeft(2, '0')}-'
        '${concours.date.day.toString().padLeft(2, '0')}';

    return AlertDialog(
      title: const Text('Confirmer la suppression'),
      content: Text(
        'Êtes-vous certain de vouloir supprimer le concours '
        '"$formattedDate - ${concours.lieu}" ? '
        'Toutes les données associées seront également supprimées.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        FilledButton.tonal(
          onPressed: () {
            onConfirm();
            Navigator.of(context).pop();
          },
          child: const Text('Supprimer'),
        ),
      ],
    );
  }
}
