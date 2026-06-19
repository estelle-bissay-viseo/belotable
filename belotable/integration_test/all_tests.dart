import 'package:integration_test/integration_test.dart';

import 'flows/doublettes_flow_test.dart' as doublettes_flow;
import 'flows/manches_flow_test.dart' as manches_flow;
import 'pages/concours_creation_page_test.dart' as concours_creation_page;
import 'pages/concours_deletion_test.dart' as concours_deletion;
import 'pages/concours_edit_page_test.dart' as concours_edit_page;
import 'pages/concours_list_page_test.dart' as concours_list_page;
import 'pages/concours_manage_page_test.dart' as concours_manage_page;
import 'pages/doublettes_ranking_page_test.dart' as doublettes_ranking_page;
import 'pages/home_info_page_test.dart' as home_info_page;
import 'pages/home_page_test.dart' as home_page;
import 'pages/pdf_generation_test.dart' as pdf_generation;

// This file is the entry point for all integration tests because
// integration_test on desktop device may not support app relaunch.

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  doublettes_flow.main();
  manches_flow.main();

  concours_creation_page.main();
  concours_edit_page.main();
  concours_list_page.main();
  concours_manage_page.main();
  concours_deletion.main();
  doublettes_ranking_page.main();
  home_info_page.main();
  home_page.main();
  pdf_generation.main();
}
