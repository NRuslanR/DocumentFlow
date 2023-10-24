unit DocumentCardFramePropertiesIniFile;

interface

uses

  DocumentCardFramePropertiesStorage,
  unDocumentCardFrame,
  PropertiesIniFileUnit,
  IPropertiesStorageUnit,
  SysUtils,
  Classes;

type

  TDocumentCardFramePropertiesIniFile =
    class (TDocumentCardFramePropertiesStorage)

      public

        constructor Create(
          const IniFilePath: String;
          const DefaultIniFilePath: String = ''
        );

    end;
    
implementation


{ TDocumentCardFramePropertiesIniFile }

constructor TDocumentCardFramePropertiesIniFile.Create(const IniFilePath,
  DefaultIniFilePath: String);
var
    DefaultPropertiesStorage: IPropertiesStorage;
begin

  if Trim(DefaultIniFilePath) <> '' then
    DefaultPropertiesStorage := TPropertiesIniFile.Create(DefaultIniFilePath, True, False)

  else DefaultPropertiesStorage := nil;

  inherited Create(
    TPropertiesIniFile.Create(IniFilePath, True, False),
    DefaultPropertiesStorage
  );

end;

end.
