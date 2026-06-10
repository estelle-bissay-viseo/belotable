<!-- tags: flutter, développement, tests-end-to-end -->
# Comment : Lancer les tests d'intégration en local

## Intérêt

- Valider le comportement de l'application sur desktop (Windows) avant le commit.
- Détecter les régressions d'interface ou de flux utilisateur.
- Développer et déboguer les tests d'intégration en itération rapide.

## Prérequis

- Environnement Flutter de développement configuré (voir [tutorials/00-mise-en-place-poste-dev.md](../tutorials/00-mise-en-place-poste-dev.md)).
- Support Windows desktop activé pour Flutter.
- Les clés de test doivent être présentes dans les widgets testés (voir section "Ajouter les clés de test").

## Configuration initiale

### Activer le support Windows desktop

Si c'est la première fois que vous lancez des tests d'intégration sur Windows :

```bash
cd belotable
fvm flutter config --enable-windows-desktop
```

Cette commande doit être exécutée une seule fois par environnement de développement.

## Lancer les tests d'intégration

### Tous les tests d'intégration

```bash
cd belotable
fvm flutter test integration_test/all_tests.dart -d windows -r expanded
```

Explication des flags :
- `integration_test/all_tests.dart` : point d'entrée principal qui exécute tous les tests.
- `-d windows` : cible le dispositif Windows desktop.
- `-r expanded` : affiche la liste des tests exécutés.

### Un fichier de test spécifique

```bash
cd belotable
fvm flutter test integration_test/pages/home_page_test.dart -d windows -r expanded
```

### Un seul test nommé

```bash
cd belotable
fvm flutter test integration_test/pages/home_page_test.dart -d windows -r expanded --name "Home page displays welcome message"
```

## Ajouter les clés de test

Les tests d'intégration localisent les widgets via des clés (`Key`). Pour ajouter une clé de test à un widget :

```dart
Text(
  'Bienvenue !',
  key: const Key('home_body_title'),
)
```

Respectez la convention de nommage : `[page]_[element]_[role]`

Exemples : `app_bar_title`, `home_body_title`.

## Dépannage

### Test échoue avec "Widget key not found"

**Cause** : La clé de test n'existe pas dans le widget ou n'a pas été synchronisée après un changement de code.

**Résolution** :

1. Vérifier que la clé est présente dans `lib/presentation/shared/home_page.dart` (ex. : `key: const Key('home_body_title')`).
2. Vérifier que le nom de la clé dans le test correspond exactement.
3. Relancer le test après `flutter clean`.

## Structure des tests d'intégration

```
belotable/integration_test/
├── all_tests.dart              # Entrée principale
├── pages/                      # Tests de pages
│   ├── app_common_page_test.dart
│   └── home_page_test.dart
├── flows/                      # Tests de flux utilisateur
├── helpers/                    # Assistants de test
└── robots/                     # Page objects pour ATDD
```

## Ressources

- [Intégration test Flutter - docs officielles](https://docs.flutter.dev/testing/integration-tests)
- [WidgetTester - référence API](https://api.flutter.dev/flutter/flutter_test/WidgetTester-class.html)
- [Commandes flutter test](https://docs.flutter.dev/reference/flutter-cli)
