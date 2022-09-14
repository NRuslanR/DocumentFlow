unit AppDataLocalSettingsResetService;

interface

uses

  ApplicationSettingsResetService,
  Forms,
  SysUtils,
  ShellAPI,
  Classes;

type

  TAppDataLocalSettingsResetService =
    class (TInterfacedObject, IApplicatonSettingsResetService)

      private

        FSettingsDirName: String;
        
      public

        constructor Create(const SettingsDirName: String);

        procedure ResetApplicationSettings;

    end;
    
implementation

uses

  AuxSystemFunctionsUnit,
  AuxWindowsFunctionsUnit;
  
{ TStandardApplicationSettingsResetService }

constructor TAppDataLocalSettingsResetService.Create(
  const SettingsDirName: String);
begin

  inherited Create;

  FSettingsDirName := SettingsDirName;
  
end;

procedure TAppDataLocalSettingsResetService.ResetApplicationSettings;
var
    SettingsDirPath: String;
    SHFileOpStruct: TSHFileOpStruct;
    ResultCode: Integer;
begin

  SettingsDirPath := GetAppLocalDataFolderPath(FSettingsDirName);

  if not DirectoryExists(SettingsDirPath) then Exit;

  SHFileOpStruct.Wnd := Application.Handle;
  SHFileOpStruct.wFunc := FO_DELETE;
  SHFileOpStruct.pFrom := PChar(SettingsDirPath);
  SHFileOpStruct.pTo := nil;
  SHFileOpStruct.fFlags := FOF_SILENT or FOF_NOCONFIRMATION or FOF_ALLOWUNDO;

  ResultCode := SHFileOperation(SHFileOpStruct);

  if ResultCode <> 0 then begin
  
    raise Exception.CreateFmt(
      'Не удалось удалить файлы настроек. Ошибка %d',
      [ResultCode]
    );

  end;
  
end;

end.
