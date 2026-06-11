import 'package:integration_test/integration_test.dart';

import 'pages/app_common_page_test.dart' as app_common_page;
import 'pages/concours_creation_page_test.dart' as concours_creation_page;
import 'pages/concours_list_page_test.dart' as concours_list_page;
import 'pages/home_info_page_test.dart' as home_info_page;
import 'pages/home_page_test.dart' as home_page;

// This file is the entry point for all integration tests because
// integration_test on desktop device may not support app relaunch.

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  app_common_page.main();
  concours_creation_page.main();
  concours_list_page.main();
  home_info_page.main();
  home_page.main();
}
