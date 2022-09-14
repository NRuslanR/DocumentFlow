unit DocumentChargeSheetsChangesInfoDTOMapperFactories;

interface

uses

  UIDocumentKinds,
  DocumentChargeSheetsChangesInfoDTOMapperFactory,
  SysUtils,
  Classes;

type

  TDocumentChargeSheetsChangesInfoDTOMapperFactories = class

    protected

      class var FInstance: TDocumentChargeSheetsChangesInfoDTOMapperFactories;

      class function GetInstance: TDocumentChargeSheetsChangesInfoDTOMapperFactories; static;

      constructor Create;
      
    public

      function CreateDocumentChargeSheetsChangesInfoDTOMapperFactory(
        UIDocumentKind: TUIDocumentKindClass
      ): TDocumentChargeSheetsChangesInfoDTOMapperFactory; virtual;

      class property Current: TDocumentChargeSheetsChangesInfoDTOMapperFactories
      read GetInstance;

  end;

implementation

{ TDocumentChargeSheetsChangesInfoDTOMapperFactories }

constructor TDocumentChargeSheetsChangesInfoDTOMapperFactories.Create;
begin

  inherited;
  
end;

function TDocumentChargeSheetsChangesInfoDTOMapperFactories.
  CreateDocumentChargeSheetsChangesInfoDTOMapperFactory(
    UIDocumentKind: TUIDocumentKindClass
  ): TDocumentChargeSheetsChangesInfoDTOMapperFactory;
begin

  Result := TDocumentChargeSheetsChangesInfoDTOMapperFactory.Create;

end;

class function TDocumentChargeSheetsChangesInfoDTOMapperFactories.GetInstance: TDocumentChargeSheetsChangesInfoDTOMapperFactories;
begin

  if not Assigned(FInstance) then
    FInstance := TDocumentChargeSheetsChangesInfoDTOMapperFactories.Create;

  Result := FInstance;
  
end;

end.
