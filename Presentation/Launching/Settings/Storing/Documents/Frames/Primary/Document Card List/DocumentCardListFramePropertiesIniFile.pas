unit DocumentCardListFramePropertiesIniFile;

interface

uses

  DocumentCardListFramePropertiesStorage,
  unDocumentCardListFrame,
  unDocumentFlowInformationFrame,
  PropertiesIniFileUnit,
  IPropertiesStorageUnit,
  SysUtils;

type

  TDocumentCardListFramePropertiesIniFile =
    class (TDocumentCardListFramePropertiesStorage)

      public

        constructor Create(
          const IniFilePath: String;
          const DefaultIniFilePath: String = ''
        );

    end;

implementation

uses

  Forms;

{ TDocumentCardListFramePropertiesIniFile }

constructor TDocumentCardListFramePropertiesIniFile.Create(
  const IniFilePath: String;
  const DefaultIniFilePath: String
);
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
