unit DocumentKindsFramePropertiesIniFile;

interface

uses

  DocumentKindsFramePropertiesStorage,
  unDocumentFlowInformationFrame,
  PropertiesIniFileUnit,
  unDocumentKindsFrame,
  IPropertiesStorageUnit,
  SysUtils,
  Classes;

type

  TDocumentKindsFramePropertiesIniFile =
    class (TDocumentKindsFramePropertiesStorage)

      public

        constructor Create(
          const IniFilePath: String;
          const DefaultIniFilePath: String = ''
        );

    end;

implementation

uses

  Variants,
  UIDocumentKinds;


{ TDocumentKindsFramePropertiesIniFile }

constructor TDocumentKindsFramePropertiesIniFile.Create(
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
