# How-to: Mettre à jour la version Flutter

Objectif : changer la version Flutter de référence de façon cohérente entre local, CI et Docker.

## Principe

La source de vérité est le fichier `.fvmrc` à la racine.

Exemple actuel :

```json
{
  "flutter": "3.44.0"
}
```

## Étapes

1. Modifier la valeur `flutter` dans `.fvmrc`.
2. Mettre à jour l'environnement local si vous utilisez FVM.
3. Vérifier que les builds locaux passent.
4. Vérifier que les workflows CI passent sur la branche cible.

## Commandes utiles (local)

```bash
fvm install
fvm use --pin
fvm flutter --version
```

## Points de vérification

- `fvm flutter pub get` fonctionne dans `belotable/`.
- `fvm flutter test` fonctionne dans `belotable/`.
- Le build Docker web fonctionne.
- Les workflows `.github/workflows/ci.yml` et `.github/workflows/release.yml` lisent bien `.fvmrc`.

## Sources (dépôt)

- `.fvmrc`
- `.github/workflows/ci.yml`
- `.github/workflows/release.yml`
