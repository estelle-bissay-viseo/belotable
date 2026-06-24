; Script Inno Setup pour Belotable
; Prérequis : avoir compilé l'application avec "flutter build windows --release"

#ifndef AppVersion
	#define AppVersion "1.0.0"
#endif

[Setup]
AppName=Belotable
AppVersion={#AppVersion}
AppPublisher=Belotable
DefaultDirName={localappdata}\Programs\Belotable
PrivilegesRequired=lowest
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

[Code]
var
  RemoveData: Boolean;

// supprimer les données existantes à l'installation
procedure CurStepChanged(CurStep: TSetupStep);
var
  ResultCode: Integer;
begin
  if CurStep = ssInstall then
  begin
    if DirExists(ExpandConstant('{userappdata}\belotable')) then
    begin
      if MsgBox(
        'Des données existantes ont été trouvées. Il est fortement conseiller de les supprimer si vous installez une nouvelle version de Belotable car elles seront incompatibles. Voulez-vous les supprimer ?',
        mbConfirmation, MB_YESNO
      ) = IDYES then
      begin
        DelTree(ExpandConstant('{userappdata}\belotable'), True, True, True);
      end;
    end;
  end;
end;

// Demander si suppression des données à la désinstallation
function InitializeUninstall(): Boolean;
begin
  Result := True;

  if DirExists(ExpandConstant('{userappdata}\belotable')) then
  begin
    RemoveData :=
      MsgBox(
        'Souhaitez-vous supprimer les données utilisateur de Belotable ?',
        mbConfirmation, MB_YESNO
      ) = IDYES;
  end
  else
  begin
    RemoveData := False;
  end;
end;

// Supprimer les données à la désinstallation si demandé
procedure CurUninstallStepChanged(Step: TUninstallStep);
begin
  if (Step = usUninstall) and RemoveData then
  begin
    DelTree(ExpandConstant('{userappdata}\belotable'), True, True, True);
  end;
end;

