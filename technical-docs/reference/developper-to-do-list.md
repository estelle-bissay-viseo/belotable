<!-- tags: développement, flutter -->
# Liste des tâches de développement

Pour chaque tâche de développement, il est important de suivre les étapes mentionnées ici.

## Initialisation du développement d'une nouvelle fonctionnalité/correction de bug

1. Créer une branche à partir de `dev` (à jour) avec un nom descriptif (ex: `feat/fonctionnalite` ou `fix/bug-y`).
2. Créer un markdown décrivant la fonctionnalité ou le bug à corriger dans le dossier `.github/pr_descriptions` (ex: `feat_fonctionnalite.md` ou `fix_bug-y.md`). Ce fichier sera utile pour utiliser les scripts présents dans `dev-scripts`.
3. Pousser la nouvelle branche sur le dépôt distant.
4. Commiter les changements *régulièrement* avec des messages de commit clairs.

## Développement

Vérifier régulièrement, et en particulier en fin de développement, les commandes suivantes :

```bash
cd belotable
# regénérer les fichiers générés (si nécessaire)
fvm dart run build_runner build --delete-conflicting-outputs
# vérifier que le code est correctement formaté
fvm dart format .
# vérifier que le code est conforme aux règles de linting
fvm flutter analyze
# vérifier que les tests passent
fvm flutter test
# vérifier que les tests end-to-end passent
fvm flutter test integration_test/all_tests.dart -d windows -r expanded
# vérifier que l'application desktop fonctionne
fvm flutter run -d windows
# vérifier que l'application web fonctionne
fvm flutter run -d chrome
# vérifier que l'image docker fonctionne
cd ../
docker compose -f build/docker/docker-compose.yml up --build -d
start "http://localhost" # ouvre le navigateur par défaut sur cette adresse (Windows)
docker compose -f build/docker/docker-compose.yml down
```

## Documentations

- Mettre à jour la documentation technique dans `technical-docs/` si nécessaire (ex: architecture, API, etc.).
- Mettre à jour la documentation utilisateur dans `user-docs/` si nécessaire (ex: nouvelles fonctionnalités, changements de comportement, etc.).

## Création de PR

1. Relire le code et les tests pour s'assurer de la qualité du code et de la pertinence des tests.
2. Regénérer le glossaire de la documentation technique (si nécessaire) avec le script `dev-scripts/technical-doc-tags-page.sh`.
3. (optionnel mais recommandé) squash les commits en un seul commit clair et descriptif. Le script `dev-scripts/github/prepare-pr.sh --parent-branch dev` (qui utilise le markdown créé à l'étape 2 de l'initialisation) peut être utilisé pour cela.
4. Créer/Mettre à jour la PR sur GitHub en utilisant le script `dev-scripts/github/sync-remote-pr.sh --parent-branch dev` (qui utilise le markdown créé à l'étape 2 de l'initialisation).
5. Vérifier la PR sur GitHub, lui ajouter des labels, et retirer le statut "draft" si la PR est prête à être compilée et revue.
