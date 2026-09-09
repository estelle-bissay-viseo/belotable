import 'dart:io';

import 'package:belotable/presentation/shared/display/display_screen_page.dart';
import 'package:belotable/presentation/shared/services/display_window_service.dart';

/// Opens the display screen in a new native OS window by launching an
/// independent process of this same application with the target route
/// passed as a command-line argument. Every call spawns a brand-new
/// process, so instances stay fully independent from each other and from
/// the main application window.
class DesktopDisplayWindowService implements DisplayWindowService {
  @override
  Future<void> open(String concoursId) async {
    await Process.start(
      Platform.resolvedExecutable,
      [DisplayScreenPage.routePathFor(concoursId)],
      mode: ProcessStartMode.detached,
    );
  }
}

/// Returns the appropriate DisplayWindowService implementation.
DisplayWindowService getDisplayWindowService() => DesktopDisplayWindowService();
