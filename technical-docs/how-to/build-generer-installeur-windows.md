# How-to: Générer un installeur Windows

Objectif : générer un installeur `.exe` distribuable pour Windows.

## Prérequis

- poste de développement mis en place (cf [tutorials/00-mise-en-place-poste-dev.md](../tutorials/00-mise-en-place-poste-dev.md))

## Procédure

1. Compiler l'application Flutter en release.

```bash
cd belotable
fvm flutter pub get
fvm flutter test --coverage
fvm flutter build windows --release
```

Le dossier `belotable/build/windows/x64/runner/Release/` contient l'exécutable principal (`belotable.exe`) ainsi que toutes les DLL nécessaires à son exécution. Mais cet exe n'est pas autoportant.

2. Lancer la génération Inno Setup depuis la racine du dépôt.

```powershell
# à exécuter via powershell
./build/windows-build-innosetup.ps1
```

Le répertoire de sortie par défaut est `.\build\windows_output`. L'executable `belotable-setup-xxx.exe` qui y est généré est autoportant.

3. Optionnel : forcer un dossier de sortie.

```powershell
# à exécuter via powershell
./build/windows-build-innosetup.ps1 -OutputDir ".\artifacts\windows"
```

## Ce que fait le script

Le script [build/windows-build-innosetup.ps1](../../build/windows-build-innosetup.ps1) :

- lit la version applicative dans `belotable/pubspec.yaml`.
- recherche `iscc.exe` (InnoSetup) sur le poste d'exécution (chemins connus, registre, puis `PATH`).
- compile [build/windows-config.iss](../../build/windows-config.iss).

## Vérification

- Le script termine sans erreur.
- Un installeur `.exe` est présent dans le dossier de sortie.

## En cas d'échec

- Vérifier que `fvm flutter build windows --release` réussit avant Inno Setup.
- Vérifier l'installation d'Inno Setup et la disponibilité de `iscc.exe`.

## Sources (dépôt)

- `build/windows-build-innosetup.ps1`
- `build/windows-config.iss`
- `.github/workflows/ci.yml`
- `.github/workflows/release.yml`
