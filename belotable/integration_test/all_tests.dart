import 'package:integration_test/integration_test.dart';

import 'pages/app_common_page_test.dart' as app_common_page;
import 'pages/home_page_test.dart' as home_page;

// This file is the entry point for all integration tests because
// integration_test on desktop device may not support app relaunch.

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  app_common_page.main();
  home_page.main();
}
