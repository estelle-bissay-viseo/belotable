; Script Inno Setup pour Belotable
; Prérequis : avoir compilé l'application avec "flutter build windows --release"

#ifndef AppVersion
	#define AppVersion "1.0.0"
#endif

[Setup]
AppName=Belotable
AppVersion={#AppVersion}
AppPublisher=Belotable
DefaultDirName={autopf}\Belotable
DefaultGroupName=Belotable
SetupIconFile=..\belotable\windows\runner\resources\app_icon.ico
OutputDir=windows_output
OutputBaseFilename=belotable-setup-{#AppVersion}
Compression=lzma2
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "french"; MessagesFile: "compiler:Languages\French.isl"

[Tasks]
Name: "desktopicon"; Description: "Créer un raccourci sur le Bureau"; GroupDescription: "Icônes supplémentaires :"

[Files]
; Inclure tout le contenu du dossier Release généré par Flutter
Source: "..\belotable\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\Belotable"; Filename: "{app}\belotable.exe"
Name: "{group}\Désinstaller Belotable"; Filename: "{uninstallexe}"
Name: "{autodesktop}\Belotable"; Filename: "{app}\belotable.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\belotable.exe"; Description: "Lancer Belotable"; Flags: nowait postinstall skipifsilent
