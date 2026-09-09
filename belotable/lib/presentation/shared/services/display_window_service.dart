import 'package:belotable/presentation/shared/services/display_window_service_stub.dart'
    if (dart.library.html) 'package:belotable/presentation/web/services/display_window_service_web.dart'
    if (dart.library.io) 'package:belotable/presentation/desktop/services/display_window_service_desktop.dart';

/// Opens an independent display screen instance for a concours.
///
/// Each call must open a new, independent instance: it must not search for,
/// focus, reuse, or close any existing display instance.
abstract class DisplayWindowService {
  /// Opens a new display screen instance for [concoursId].
  Future<void> open(String concoursId);
}

/// Returns the appropriate DisplayWindowService implementation.
DisplayWindowService createDisplayWindowService() => getDisplayWindowService();
