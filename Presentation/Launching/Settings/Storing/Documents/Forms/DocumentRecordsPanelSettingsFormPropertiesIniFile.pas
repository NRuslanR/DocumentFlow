unit DocumentRecordsPanelSettingsFormPropertiesIniFile;

interface

uses

  DocumentRecordsPanelSettingsFormPropertiesStorage,
  DocumentRecordsPanelSettingsFormUnit,
  PropertiesIniFileUnit,
  IPropertiesStorageUnit,
  SysUtils,
  Classes;

type

  TDocumentRecordsPanelSettingsFormPropertiesIniFile =
    class (TDocumentRecordsPanelSettingsFormPropertiesStorage)

      public

        constructor Create(
          const PropertiesIniFilePath: String;
          const DefaultIniFilePath: String = '');

    end;

implementation



{ TDocumentRecordsPanelSettingsFormPropertiesIniFile }

constructor TDocumentRecordsPanelSettingsFormPropertiesIniFile.Create(
  const PropertiesIniFilePath: String;
  const DefaultIniFilePath: String
);
var
    DefaultPropertiesStorage: IPropertiesStorage;
begin

  if Trim(DefaultIniFilePath) <> '' then
    DefaultPropertiesStorage := TPropertiesIniFile.Create(DefaultIniFilePath, True, False)

  else DefaultPropertiesStorage := nil;

  inherited Create(TPropertiesIniFile.Create(
    PropertiesIniFilePath, True, False),
    DefaultPropertiesStorage
  );
  
end;

end.
