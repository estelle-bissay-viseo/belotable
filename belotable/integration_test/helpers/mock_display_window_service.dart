import 'package:belotable/presentation/shared/services/display_window_service.dart';

/// Mock implementation for testing display screen opening without spawning
/// a real OS process or browser window.
class MockDisplayWindowService implements DisplayWindowService {
  /// Concours ids passed to [open], in call order.
  final openedConcoursIds = <String>[];

  @override
  Future<void> open(String concoursId) async {
    openedConcoursIds.add(concoursId);
  }
}
