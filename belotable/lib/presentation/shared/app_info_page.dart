import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

const _githubRepoUrl = 'https://github.com/estelle-bissay-viseo/belotable';

/// Displays read-only application information.
class AppInfoPage extends StatefulWidget {
  /// Creates information page.
  const AppInfoPage({super.key});

  /// Named route used by navigator.
  static const routeName = '/app-info';

  @override
  State<AppInfoPage> createState() => _AppInfoPageState();
}

class _AppInfoPageState extends State<AppInfoPage> {
  late final Future<String> _versionFuture;

  @override
  void initState() {
    super.initState();
    _versionFuture = _loadVersion();
  }

  Future<String> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  Future<void> _openRepository() async {
    final uri = Uri.parse(_githubRepoUrl);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Impossible d'ouvrir le lien du dépôt GitHub."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informations'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FutureBuilder<String>(
                future: _versionFuture,
                builder: (context, snapshot) {
                  final version = snapshot.data ?? '...';
                  return Text(
                    'Version : $version',
                    key: const Key('app_info_version_text'),
                    style: Theme.of(context).textTheme.titleMedium,
                  );
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                key: const Key('app_info_repo_link_button'),
                onPressed: _openRepository,
                child: const Text(_githubRepoUrl),
              ),
              const SizedBox(height: 24),
              FilledButton(
                key: const Key('app_info_back_button'),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Retour'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
