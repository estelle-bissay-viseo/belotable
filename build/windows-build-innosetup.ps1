<#
.SYNOPSIS
Compile l'installeur pour Windows via Inno Setup.

.DESCRIPTION
Ce script recherche automatiquement `iscc.exe`, lit la version de l'application
depuis `pubspec.yaml`, puis lance la compilation du script Inno Setup
`windows-config.iss`.

Si `OutputDir` est fourni, le script utilise ce répertoire pour les artefacts
de sortie de la compilation (et le crée s'il n'existe pas). Sinon, le
répertoire de sortie défini dans le script `.iss` est utilisé.

.PARAMETER OutputDir
Chemin du répertoire de sortie à forcer pour la compilation Inno Setup.
Le chemin peut être relatif ou absolu.

.EXAMPLE
.\windows-build-innosetup.ps1
Compile en utilisant le répertoire de sortie défini dans `windows-config.iss`.

.EXAMPLE
.\windows-build-innosetup.ps1 -OutputDir ".\windows\output"
Compile en forçant la sortie vers `.\windows\output`.
#>

param(
    [string]$OutputDir
)

$ErrorActionPreference = 'Stop'

# ------
# Vérification des paramètres d'entrée
# ------

$scriptDir = $PSScriptRoot
$issScript = Join-Path $scriptDir "windows-config.iss"
$pubspecPath = Join-Path $scriptDir "..\belotable\pubspec.yaml"
$resolvedOutputDir = $null

if (-not (Test-Path $issScript)) {
    Write-Error "Script Inno introuvable: $issScript"
    exit 1
}

if (-not (Test-Path $pubspecPath)) {
    Write-Error "pubspec.yaml introuvable: $pubspecPath"
    exit 1
}

if (-not [string]::IsNullOrWhiteSpace($OutputDir)) {
    # Permet de passer un chemin relatif ou absolu pour le répertoire de sortie.
    $resolvedOutputDir = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputDir)

    if (-not (Test-Path $resolvedOutputDir)) {
        New-Item -ItemType Directory -Path $resolvedOutputDir -Force | Out-Null
    }
}

# ------
# Recherche de iscc.exe
# ------

# Recherche de iscc.exe dans les emplacements courants
$searchPaths = @(
    "C:\Program Files (x86)\Inno Setup 6\iscc.exe",
    "C:\Program Files\Inno Setup 6\iscc.exe",
    "C:\Program Files (x86)\Inno Setup 5\iscc.exe",
    "C:\Program Files\Inno Setup 5\iscc.exe",
    "$env:LOCALAPPDATA\Programs\Inno Setup 6\iscc.exe",
    "$env:LOCALAPPDATA\Programs\Inno Setup 5\iscc.exe"
)

$iscc = $null

# Vérifier les chemins connus
foreach ($path in $searchPaths) {
    if (Test-Path $path) {
        $iscc = $path
        break
    }
}

# Si non trouvé, recherche dans le registre Windows
if (-not $iscc) {
    $registryPaths = @(
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall",
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
    )
    foreach ($regPath in $registryPaths) {
        $key = Get-ChildItem $regPath -ErrorAction SilentlyContinue |
            Where-Object { (Get-ItemProperty $_.PSPath -ErrorAction SilentlyContinue).DisplayName -like "Inno Setup*" } |
            Select-Object -First 1
        if ($key) {
            $installLocation = (Get-ItemProperty $key.PSPath).InstallLocation
            $candidate = Join-Path $installLocation "iscc.exe"
            if (Test-Path $candidate) {
                $iscc = $candidate
                break
            }
        }
    }
}

# Si toujours non trouvé, recherche dans le PATH
if (-not $iscc) {
    $iscc = Get-Command "iscc.exe" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source
}

if (-not $iscc) {
    Write-Error "iscc.exe introuvable. Veuillez installer Inno Setup depuis https://jrsoftware.org/isdl.php"
    exit 1
}

# ------
# Récupération du numéro de version depuis pubspec.yaml
# ------

${pubspecContent} = Get-Content $pubspecPath -Raw
$match = [regex]::Match($pubspecContent, '(?m)^version:\s*([0-9]+\.[0-9]+\.[0-9]+(?:-[0-9A-Za-z.-]+)?)\s*$')

if (-not $match.Success) {
    Write-Error "Impossible de lire une version valide dans pubspec.yaml (attendu: version: x.y.z[-tag])."
    exit 1
}

$appVersion = $match.Groups[1].Value

# ------
# Compilation
# ------

Write-Host "Inno Setup trouvé : $iscc"
Write-Host "Numéro de version détecté : $appVersion"
Write-Host "Compilation de : $issScript"
if ($resolvedOutputDir) {
    Write-Host "Répertoire de sortie surchargé : $resolvedOutputDir"
} else {
    Write-Host "Répertoire de sortie : défini par le script .iss"
}
Write-Host ""

$isccArgs = @("/DAppVersion=$appVersion")
if ($resolvedOutputDir) {
    $isccArgs += "/O$resolvedOutputDir"
}
$isccArgs += "$issScript"

& $iscc @isccArgs

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "Installeur généré avec succès"
} else {
    Write-Error "Échec de la compilation (code $LASTEXITCODE)"
    exit $LASTEXITCODE
}
