unit ApplicationMainFramePropertiesIniFile;

interface

uses

  Graphics,
  UIDocumentKinds,
  UIDocumentKindResolver,
  unApplicationMainFrame,
  ApplicationMainFramePropertiesStorage,
  IPropertiesStorageUnit,
  PropertiesIniFileUnit,
  SysUtils,
  Classes;

type

  TApplicationMainFramePropertiesIniFile = class (TApplicationMainFramePropertiesStorage)

    public

      constructor Create(
        const IniFilePath: String;
        const DefaultIniFilePath: String = ''
      );
      
  end;

implementation

uses

  Variants,
  AuxiliaryStringFunctions,
  Forms;

{ TApplicationMainFramePropertiesIniFile }

constructor TApplicationMainFramePropertiesIniFile.Create(
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
