unit AbstractDocumentRepositoriesFactoryRegistry;

interface

uses

  DocumentRepositoriesFactory,
  Document,
  TypeObjectRegistry,
  SysUtils;

type

  TAbstractDocumentRepositoriesFactoryRegistry = class

    private

      FInternalRegistry: TTypeObjectRegistry;
      
      class var FInstance: TAbstractDocumentRepositoriesFactoryRegistry;

      class function GetInstance: TAbstractDocumentRepositoriesFactoryRegistry; static;
      class procedure SetInstance(Instance: TAbstractDocumentRepositoriesFactoryRegistry); static;
      
      procedure AddDocumentRepositoriesFactoriesTo(InternalRegistry: TTypeObjectRegistry);

    protected

      function CreateServiceNoteRepositoriesFactory: IDocumentRepositoriesFactory; virtual; abstract;
      function CreatePersonnelOrderRepositoriesFactory: IDocumentRepositoriesFactory; virtual; abstract;
      
    public

      destructor Destroy; override;

      constructor Create; virtual;

      function GetDocumentRepositoriesFactory(DocumentClass: TDocumentClass): IDocumentRepositoriesFactory;

    public

      class property Instance: TAbstractDocumentRepositoriesFactoryRegistry
      read GetInstance write SetInstance;
      
  end;

implementation

uses

  ServiceNote,
  IncomingServiceNote,
  PersonnelOrder,
  DocumentChargeSheetPostgresRepository;
  
{ TAbstractDocumentRepositoriesFactoryRegistry }

procedure TAbstractDocumentRepositoriesFactoryRegistry.AddDocumentRepositoriesFactoriesTo(
  InternalRegistry: TTypeObjectRegistry);
begin

  InternalRegistry.RegisterInterface(TServiceNote, CreateServiceNoteRepositoriesFactory);
  InternalRegistry.RegisterInterface(TIncomingServiceNote, CreateServiceNoteRepositoriesFactory);
  InternalRegistry.RegisterInterface(TPersonnelOrder, CreatePersonnelOrderRepositoriesFactory);
  
end;

constructor TAbstractDocumentRepositoriesFactoryRegistry.Create;
begin

  inherited;

  FInternalRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;

  FInternalRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := False;

  AddDocumentRepositoriesFactoriesTo(FInternalRegistry);

end;

destructor TAbstractDocumentRepositoriesFactoryRegistry.Destroy;
begin

  FreeAndNil(FInternalRegistry);
  
  inherited;

end;

function TAbstractDocumentRepositoriesFactoryRegistry.GetDocumentRepositoriesFactory(
  DocumentClass: TDocumentClass): IDocumentRepositoriesFactory;
begin

  Result :=
    IDocumentRepositoriesFactory(FInternalRegistry.GetInterface(DocumentClass));

end;

class function TAbstractDocumentRepositoriesFactoryRegistry.GetInstance: TAbstractDocumentRepositoriesFactoryRegistry;
begin

  Result := FInstance;
  
end;

class procedure TAbstractDocumentRepositoriesFactoryRegistry.SetInstance(
  Instance: TAbstractDocumentRepositoriesFactoryRegistry
);
begin

  FInstance := Instance;

end;

end.
