<!-- tags: flutter, développement -->
# How-to: Utiliser le linter Flutter en local

## Objectif

Vérifier localement les règles de lint avant push, avec la même base de règles que la CI.

## Prérequis

- poste de développement mis en place (cf [tutorials/00-mise-en-place-poste-dev.md](../tutorials/00-mise-en-place-poste-dev.md))
- Commandes exécutées depuis le dossier `belotable/`.

## Commandes

```bash
cd belotable
flutter pub get
flutter analyze --no-fatal-infos
```

## Résultat attendu

- Code de sortie `0` si aucune erreur bloquante.
- Les messages affichent les fichiers, lignes et règles concernées.

## Dépannage

- Erreur de dépendances (ex: `Target of URI doesn't exist`) : relancer `flutter pub get` dans `belotable/`.
- Erreurs de lint : corriger selon `belotable/analysis_options.yaml` puis relancer `flutter analyze --no-fatal-infos`.

## Notes

- Les workflows CI/release exécutent aussi `flutter analyze --no-fatal-infos` avec quality gate.
- Le linter est configuré via `package:very_good_analysis/analysis_options.yaml` dans `belotable/analysis_options.yaml`.

## Sources (dépôt)

- `belotable/analysis_options.yaml`
- `belotable/pubspec.yaml`
- `.github/workflows/ci.yml`
- `.github/workflows/release.yml`