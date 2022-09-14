unit DocumentTableDefsFactoryRegistry;

interface

uses

  Document,
  TypeObjectRegistry,
  DocumentTableDefsFactory,
  SysUtils;

type

  TDocumentTableDefsFactoryRegistry = class

    private

      class var FInstance: TDocumentTableDefsFactoryRegistry;

      class function GetInstance: TDocumentTableDefsFactoryRegistry; static;
      
    private

      FInternalRegistry: TTypeObjectRegistry;

      procedure AddDocumentTableDefsFactoriesTo(InternalRegistry: TTypeObjectRegistry);

    public

      destructor Destroy; override;
      
      constructor Create;

      function GetDocumentTableDefsFactory(DocumentClass: TDocumentClass): TDocumentTableDefsFactory;

    public

      class property Instance: TDocumentTableDefsFactoryRegistry
      read GetInstance;
      
  end;
  
implementation

uses

  ServiceNote,
  ServiceNoteTableDefsFactory,

  PersonnelOrder,
  PersonnelOrderTableDefsFactory;

{ TDocumentTableDefsFactoryRegistry }

constructor TDocumentTableDefsFactoryRegistry.Create;
begin

  inherited Create;

  FInternalRegistry :=
    TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry(
      ltoFreeRegisteredObjectsOnDestroy
    );

  FInternalRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;

  AddDocumentTableDefsFactoriesTo(FInternalRegistry);

end;

procedure TDocumentTableDefsFactoryRegistry.AddDocumentTableDefsFactoriesTo(
  InternalRegistry: TTypeObjectRegistry);
begin

  InternalRegistry.RegisterObject(TDocument, TDocumentTableDefsFactory.Create);
  InternalRegistry.RegisterObject(TServiceNote, TServiceNoteTableDefsFactory.Create);
  InternalRegistry.RegisterObject(TPersonnelOrder, TPersonnelOrderTableDefsFactory.Create);
  
end;

destructor TDocumentTableDefsFactoryRegistry.Destroy;
begin

  FreeAndNil(FInternalRegistry);
  
  inherited;

end;

function TDocumentTableDefsFactoryRegistry.GetDocumentTableDefsFactory(
  DocumentClass: TDocumentClass): TDocumentTableDefsFactory;
begin

  Result :=
    TDocumentTableDefsFactory(FInternalRegistry.GetObject(DocumentClass));

end;

class function TDocumentTableDefsFactoryRegistry.GetInstance: TDocumentTableDefsFactoryRegistry;
begin

  if not Assigned(FInstance) then
    FInstance := TDocumentTableDefsFactoryRegistry.Create;

  Result := FInstance;
  
end;

end.
