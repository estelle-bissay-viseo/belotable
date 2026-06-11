import 'package:belotable/presentation/shared/app_info_page.dart';
import 'package:belotable/presentation/shared/concours/concours_creation_page.dart';
import 'package:belotable/presentation/shared/concours/concours_detail_page.dart';
import 'package:belotable/presentation/shared/concours/concours_list_page.dart';
import 'package:belotable/presentation/shared/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

/// Root widget providing dependency injection via ProviderScope.
class MyApp extends StatelessWidget {
  /// Creates root application widget.
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Belotable',
      locale: const Locale('fr'),
      supportedLocales: const [
        Locale('fr'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      routes: {
        AppInfoPage.routeName: (_) => const AppInfoPage(),
        ConcoursCreationPage.routeName: (_) => const ConcoursCreationPage(),
        ConcoursListPage.routeName: (_) => const ConcoursListPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == ConcoursDetailPage.routeName) {
          final concoursId = settings.arguments;
          if (concoursId is String) {
            return MaterialPageRoute<void>(
              builder: (_) => ConcoursDetailPage(concoursId: concoursId),
              settings: settings,
            );
          }
        }

        return null;
      },
      home: const MyHomePage(
        title: 'Belotable',
      ),
    );
  }
}
