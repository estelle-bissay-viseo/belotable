import 'package:flutter/material.dart';

/// A widget that displays a label and a value in a column.
/// That read-only widget reduces information size on screen.
class InfoField extends StatelessWidget {
  /// constructor for [InfoField]
  const InfoField({
    required this.label,
    required this.value,
    super.key,
  });

  /// The label of the field.
  final String label;

  /// The value of the field.
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
          ),
        ),
      ],
    );
  }
}
