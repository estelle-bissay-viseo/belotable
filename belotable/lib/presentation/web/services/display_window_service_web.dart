import 'package:belotable/presentation/shared/display/display_screen_page.dart';
import 'package:belotable/presentation/shared/services/display_window_service.dart';
import 'package:web/web.dart' as web;

/// Opens the display screen in a new browser window/tab (depending on
/// browser behavior and settings), independent from the current context.
class WebDisplayWindowService implements DisplayWindowService {
  @override
  Future<void> open(String concoursId) async {
    final location = web.window.location;
    final url =
        '${location.origin}${location.pathname}'
        '#${DisplayScreenPage.routePathFor(concoursId)}';
    web.window.open(url, '_blank');
  }
}

/// Returns the appropriate DisplayWindowService implementation.
DisplayWindowService getDisplayWindowService() => WebDisplayWindowService();
