import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Definition of a validator function that takes an integer
/// and returns a string error message if the value is invalid,
/// or null if it's valid.
typedef IntegerValidator = String? Function(int? value);

/// Custom FormField to input integer
class IntegerFormField extends StatelessWidget {
  /// Constructor
  const IntegerFormField({
    super.key,
    this.controller,
    this.initialValue,
    this.decoration,
    this.valueValidator,
    this.required = false,
    this.min,
    this.max,
    this.onChanged,
    this.enabled,
    this.autovalidateMode,
  });

  /// Controller for the text field. If provided, [initialValue] must be null.
  final TextEditingController? controller;

  /// Initial value for the field. Ignored if [controller] is provided.
  final String? initialValue;

  /// Decoration for the input field
  final InputDecoration? decoration;

  /// Validator métier basé sur int (plus pratique que String)
  final IntegerValidator? valueValidator;

  /// Whether the field is required (non-empty)
  final bool required;

  /// Minimum allowed value (inclusive)
  final int? min;

  /// Maximum allowed value (inclusive)
  final int? max;

  /// Callback when the value changes,
  /// providing the parsed integer (or null if invalid)
  final ValueChanged<int?>? onChanged;

  /// Whether the field is enabled
  final bool? enabled;

  /// Autovalidate mode for the form field
  final AutovalidateMode? autovalidateMode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: key,
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      decoration: decoration,
      enabled: enabled,
      autovalidateMode: autovalidateMode,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      validator: (value) {
        final trimmed = value?.trim();

        if (required && (trimmed == null || trimmed.isEmpty)) {
          return 'Champ obligatoire';
        }

        if (trimmed == null || trimmed.isEmpty) {
          return null; // champ optionnel
        }

        final parsed = int.tryParse(trimmed);
        if (parsed == null) {
          return 'Nombre invalide';
        }

        if (min != null && parsed < min!) {
          return 'Doit être >= $min';
        }

        if (max != null && parsed > max!) {
          return 'Doit être <= $max';
        }

        if (valueValidator != null) {
          return valueValidator!(parsed);
        }

        return null;
      },
      onChanged: (value) {
        if (onChanged != null) {
          final parsed = int.tryParse(value);
          onChanged!(parsed);
        }
      },
    );
  }
}
