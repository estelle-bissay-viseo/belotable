<!-- tags: développement, flutter -->
# Tutorial: Démarrage local de Belotable

Objectif : lancer l'application Flutter en local et vérifier que l'écran d'accueil s'affiche.

## Prérequis

- Flutter installé (version de référence dans `.fvmrc`).
- Un environnement desktop Flutter fonctionnel (`fvm flutter doctor` sans erreur bloquante).
- Depuis la racine du dépôt, accéder au sous-projet Flutter dans `belotable/`.

## Étape 1: récupérer les dépendances

Depuis la racine du dépôt :

```bash
cd belotable
fvm flutter pub get
```

Résultat attendu : les dépendances sont résolues sans erreur.

## Étape 2: lancer l'application

```bash
# pour application desktop (Windows)
fvm flutter run -d windows
# pour application web (Chrome)
fvm flutter run -d chrome
```

L'application démarre en mode debug. Utilisez le menu de debug de Flutter pour :
- ♻️ **Hot Reload** : Recharger le code sans redémarrer l'app
- 🔄 **Hot Restart** : Redémarrer l'app complètement
- 🐛 **Debugger** : Inspecter variables, ajouter breakpoints

Résultat attendu : une fenêtre Belotable s'ouvre avec le message `Bienvenue !`.

Tapez `q` dans le terminal pour arrêter l'application.

## Étape 3: exécuter les tests de base

```bash
fvm flutter test
```

Résultat attendu : le test widget passe.

## Vérification rapide dans le code

- `main.dart` initialise `MyApp`.
- `home_page.dart` affiche `Bienvenue !` et `Belotable`.

Voir aussi : [tutorials/02-premiere-modification-ui.md](02-premiere-modification-ui.md).

## Sources (dépôt)

- `belotable/lib/main.dart`
- `belotable/lib/presentation/shared/home_page.dart`
- `belotable/test/widget_test.dart`
- `.fvmrc`
