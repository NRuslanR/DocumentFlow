unit DocumentFormalizationServiceRegistry;

interface

uses

  TypeObjectRegistry,
  DocumentResponsibleFinder,
  DocumentFullNameCompilationService,
  Document,
  SysUtils;

type

  TDocumentFormalizationServiceRegistry = class

    private

      class var FInstance: TDocumentFormalizationServiceRegistry;

      class function GetInstance: TDocumentFormalizationServiceRegistry; static;

    private

      FInternalRegistry: TTypeObjectRegistry;
      FDocumentResponsibleFinderRegistry: TTypeObjectRegistry;
      
    public

      procedure RegisterDocumentFullNameCompilationService(
        DocumentFullNameCompilationService: IDocumentFullNameCompilationService
      );

      procedure RegisterStandardDocumentFullNameCompilationService;

      function GetDocumentFullNameCompilationService:
        IDocumentFullNameCompilationService;

    public

      procedure RegisterDocumentResponsibleFinder(
        DocumentKind: TDocumentClass;
        DocumentResponsibleFinder: IDocumentResponsibleFinder
      );

      function GetDocumentResponsibleFinder(DocumentKind: TDocumentClass): IDocumentResponsibleFinder;

    public

      procedure RegisterAllStandardDocumentFormalizationServices;
      
    public

      destructor Destroy; override;
      constructor Create;

      class property Instance: TDocumentFormalizationServiceRegistry
      read GetInstance;

  end;

implementation

uses

  StandardDocumentFullNameCompilationService;
  
type

  TDocumentFullNameCompilationServiceType = class

  end;

{ TDocumentFormalizationServiceRegistry }

constructor TDocumentFormalizationServiceRegistry.Create;
begin

  inherited;

  FInternalRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FDocumentResponsibleFinderRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;

  FDocumentResponsibleFinderRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  
end;

destructor TDocumentFormalizationServiceRegistry.Destroy;
begin

  FreeAndNil(FInternalRegistry);
  FreeAndNil(FDocumentResponsibleFinderRegistry);
  
  inherited;

end;

function TDocumentFormalizationServiceRegistry.
  GetDocumentFullNameCompilationService: IDocumentFullNameCompilationService;
var doc: TDocument;
begin

  Result :=
    IDocumentFullNameCompilationService(
      FInternalRegistry.GetInterface(TDocumentFullNameCompilationServiceType)
    );

end;

function TDocumentFormalizationServiceRegistry.GetDocumentResponsibleFinder(
  DocumentKind: TDocumentClass): IDocumentResponsibleFinder;
begin

  Result :=
    IDocumentResponsibleFinder(
      FDocumentResponsibleFinderRegistry.GetInterface(DocumentKind)
    );
    
end;

class function TDocumentFormalizationServiceRegistry.GetInstance: TDocumentFormalizationServiceRegistry;
begin

  if not Assigned(FInstance) then
    FInstance := TDocumentFormalizationServiceRegistry.Create;

  Result := FInstance;

end;

procedure TDocumentFormalizationServiceRegistry.
  RegisterDocumentFullNameCompilationService(
    DocumentFullNameCompilationService: IDocumentFullNameCompilationService
  );
begin

  FInternalRegistry.RegisterInterface(
    TDocumentFullNameCompilationServiceType,
    DocumentFullNameCompilationService
  );
  
end;

procedure TDocumentFormalizationServiceRegistry.RegisterDocumentResponsibleFinder(
  DocumentKind: TDocumentClass;
  DocumentResponsibleFinder: IDocumentResponsibleFinder);
begin

  FDocumentResponsibleFinderRegistry.RegisterInterface(
    DocumentKind, DocumentResponsibleFinder
  );
  
end;

procedure TDocumentFormalizationServiceRegistry.
  RegisterStandardDocumentFullNameCompilationService;
begin

  RegisterDocumentFullNameCompilationService(
    TStandardDocumentFullNameCompilationService.Create
  );

end;

procedure TDocumentFormalizationServiceRegistry.
  RegisterAllStandardDocumentFormalizationServices;
begin

  RegisterStandardDocumentFullNameCompilationService;
  
end;


end.
