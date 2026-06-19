import 'package:intl/intl.dart';

/// French date formatting utilities for the Belotable application.
String formatDateFrNumerique(DateTime date) {
  final formatter = DateFormat('dd/MM/yyyy', 'fr_FR');
  return formatter.format(date);
}

/// French date formatting utility
/// that returns the date in a more readable format with letters.
String formatDateFrLettres(DateTime date) {
  final formatter = DateFormat('d MMMM yyyy', 'fr_FR');
  return formatter.format(date);
}
