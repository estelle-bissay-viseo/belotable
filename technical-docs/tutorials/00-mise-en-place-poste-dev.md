<!-- tags: développement -->
# Mise en place du poste de développement (windows)

Ce tutoriel vous guidera pour configurer votre environnement de développement local afin de contribuer à Belotable.

## Étape 1 : Installer les dépendances système

### 1.1 Windows - mode développeur

Si votre poste de développeur est sous Windows, vous devez activer le mode développeur pour permettre l'exécution de l'application Windows en mode debug.

1. Dans powershell (en tant qu'administrateur), exécutez la commande suivante pour ouvrir la fenêtre gérant le mode développeur : `start ms-settings:developers`
1. Dans la fenêtre des paramètres qui s'ouvre, activez le **Mode développeur**.
1. Redémarrez votre IDE s'il était ouvert pendant cette opération.

### 1.2 Installer winget (gestionnaire de paquets Windows natif)

**winget** est le gestionnaire de paquets natif de Windows. Consultez la [documentation officielle d'installation de winget](https://learn.microsoft.com/fr-fr/windows/package-manager/winget/) pour l'installer.

Vérifiez l'installation :

```powershell
winget --version
```

### 1.3 Installer Chocolatey (gestionnaire de paquets)

Consultez la [documentation officielle d'installation de Chocolatey](https://chocolatey.org/install) pour installer le gestionnaire de paquets (exécutez PowerShell en tant qu'administrateur).

Vérifiez l'installation :

```powershell
choco --version
```

### 1.4 Installer les paquets de base

Toujours en PowerShell administrateur :

```powershell
winget install Git.Git
winget install GitHub.cli
winget install Microsoft.VisualStudioCode
winget install Python.Python.3.12
winget install Google.Chrome
winget install JRSoftware.InnoSetup
winget install AquaSecurity.Trivy
```

Ajouter ces variables d'environnement (niveau user) :

| Variable d'environnement | Valeur                  | Commentaire                           | 
|--------------------------|-------------------------|---------------------------------------|
| `PYTHONUTF8`             | `1` | Force Python à utiliser UTF-8 pour éviter les problèmes d'encodage |
| `REQUESTS_CA_BUNDLE`     | Chemin absolu vers votre fichier de certificats SSL si vous en avez | Permet à Python de faire confiance aux certificats SSL de l'entreprise |


Puis installez Flutter via FVM (Flutter Version Manager) :

```powershell
choco upgrade fvm --yes
```

## Étape 2 : Installer Visual Studio Community (pour Flutter Windows)

Flutter nécessite le workload **"Développement Desktop en C++"** pour compiler des applications Windows natives.

1. Installez Visual Studio Community :
   ```powershell
   winget install Microsoft.VisualStudio.Community
   ```

2. Lancez l'installateur Visual Studio (Visual Studio Installer) et assurez-vous que le workload **"Développement Desktop en C++"** est coché.

3. Terminez l'installation.

## Étape 3 : Cloner le dépôt

### 3.1 Configurer Git localement

Avant de cloner le dépôt, configurez Git avec vos identifiants et générez une clé SSH pour communiquer de manière sécurisée avec GitHub.

#### Configurer l'identité Git

```bash
git config --global user.name "Votre Nom"
git config --global user.email "votre.email@exemple.com"
```

Vérifiez la configuration :

```bash
git config --list
```

#### Générer une clé SSH pour GitHub

Si vous n'avez pas encore de clé SSH, générez-en une :

```bash
ssh-keygen -t ed25519 -C "votre.email@exemple.com"
```

À la première invite, appuyez sur Entrée pour accepter l'emplacement par défaut (`~/.ssh/id_ed25519`).
À la deuxième invite, entrez une passphrase sécurisée (optionnel mais recommandé).

Ajoutez la clé SSH à l'agent SSH :

```bash
ssh-add ~/.ssh/id_ed25519
```

Affichez la clé publique et copiez-la :

```bash
cat ~/.ssh/id_ed25519.pub
```

Consultez la [documentation GitHub pour ajouter une clé SSH](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) et ajoutez cette clé à votre compte GitHub.

#### Vérifier la connexion SSH à GitHub

```bash
ssh -T git@github.com
```

Vous devriez voir un message comme :
```
Hi <votre-username>! You've successfully authenticated, but GitHub does not provide shell access.
```

### 3.2 Cloner le dépôt

Ouvrez un terminal dans votre répertoire de travail habituel et exécutez :

```bash
git clone git@github.com:estelle-bissay-viseo/belotable.git
cd belotable
```

## Étape 4 : Configurer GitHub CLI

GitHub CLI (`gh`) facilite l'interaction avec GitHub depuis le terminal (créer des PR, gérer les issues, etc.).

Authentifiez-vous auprès de GitHub :

```bash
gh auth login
```

Répondez aux questions interactives :
- **What is your preferred protocol for Git operations?** → Sélectionnez `SSH`
- **Upload your SSH public key to GitHub?** → Répondez `Y` pour que GitHub CLI ajoute automatiquement votre clé SSH
- **How would you like to authenticate GitHub CLI?** → Sélectionnez `Login with a web browser`

Suivez les instructions pour autoriser GitHub CLI dans votre navigateur.

Vérifiez l'authentification :

```bash
gh auth status
```

Vous devriez voir un message confirmant votre connexion.

## Étape 5 : Configurer Flutter avec FVM

FVM (Flutter Version Manager) permet de gérer les versions de Flutter et d'assurer que tous les développeurs utilisent la même version.

Le fichier `.fvmrc` à la racine du dépôt spécifie la version Flutter à utiliser.

### 5.1 Installer la version Flutter correcte

```bash
fvm install
fvm use --pin
```

### 5.2 Vérifier l'environnement

```bash
fvm flutter doctor
```

Cette commande vérifie que tous les pré-requis sont correctement installés. Le résultat devrait ressembler à :

```
Doctor summary (to see all details run flutter doctor -v):
[✓] Flutter (Channel stable, version X.Y.Z)
[✓] Windows Version (Windows 10/11)
[✓] Visual Studio - full install (Visual Studio Community 2022 version 17.x)
[✓] VS Code (version X.X.X)
[✓] Connected device (1 available)
```

Si vous voyez des croix ❌, consultez la documentation officielle pour corriger les problèmes signalés.

Si vous avez une croix sur "Android toolchain", ce n'est pas problématique pour le moment car la version Android n'est pas encore compilée.

## Étape 6 : Installer les dépendances pour la documentation utilisateur

Si vous souhaitez éditer la documentation utilisateur avec MkDocs :

```bash
python -m pip install --upgrade pip
pip install mkdocs mkdocs-material mkdocs-pdf-export-plugin
```

Il est possible qu'il soit nécessaire d'ajouter le répertoire des scripts python dans votre PATH et de redémarrer votre terminal pour prendre en compte la mise à jour du PATH.

## Étape 7 : Installer semgrep

```bash
python -m pip install --upgrade pip
pip install semgrep
```

Voir la documentation officielle de semgrep pour plus d'informations : https://semgrep.dev/docs/getting-started/quickstart-ce

## Étape 8 : Ouvrir le projet dans VS Code

```bash
code .
```

VS Code devrait détecter automatiquement qu'il s'agit d'un projet Flutter et vous proposer d'installer l'extension Dart/Flutter.

### Extensions recommandées VS Code

- **Dart** (officiellement supporté par Dart/Flutter team)
- **Flutter** (officiellement supporté par Dart/Flutter team)
- **GitHub Copilot Chat**

## Prochaines étapes

Une fois l'environnement configuré :

1. **Pour démarrer en local** : Consultez le tutoriel [Démarrage local](01-demarrage-local.md)
2. **Pour une première modification UI** : Consultez le tutoriel [Première modification UI](02-premiere-modification-ui.md)
3. **Pour comprendre l'architecture** : Consultez la [documentation architecture](../reference/architecture.md)

## Besoin d'aide ?

- 📖 Consultez la [documentation technique](../home.md)
- 🐛 Vérifiez les [issues GitHub](https://github.com/estelle-bissay-viseo/belotable/issues)
- 💬 Posez vos questions dans les discussions GitHub
