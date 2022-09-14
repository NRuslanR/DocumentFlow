unit DocumentKindReferenceServiceRegistry;

interface

uses

  Document,
  AbstractObjectRegistry,
  DocumentKindWorkCycleInfoService,
  TypeObjectRegistry,
  SysUtils;

type

  TDocumentKindReferenceServiceRegistry = class

    private

      class var FInstance: TDocumentKindReferenceServiceRegistry;

      class function GetInstance: TDocumentKindReferenceServiceRegistry; static;

    private

      FInternalRegistry: TTypeObjectRegistry;

    public

      procedure RegisterDocumentKindWorkCycleInfoService(
        DocumentClass: TDocumentClass;
        DocumentKindWorkCycleInfoService: IDocumentKindWorkCycleInfoService
      );

      procedure RegisterStandardDocumentKindWorkCycleInfoService(DocumentClass: TDocumentClass);

      function GetDocumentKindWorkCycleInfoService(DocumentClass: TDocumentClass): IDocumentKindWorkCycleInfoService;

    public

      procedure RegisterAllStandardDocumentKindReferenceServices(DocumentClass: TDocumentClass);
      
    public

      destructor Destroy; override;
      constructor Create;

      class property Instance: TDocumentKindReferenceServiceRegistry
      read GetInstance;

  end;

implementation

uses

  DocumentSearchServiceRegistry,
  StandardDocumentKindWorkCycleInfoService;
  
{ TDocumentKindReferenceServiceRegistry }

constructor TDocumentKindReferenceServiceRegistry.Create;
begin

  inherited;

  FInternalRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;

  FInternalRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  
end;

destructor TDocumentKindReferenceServiceRegistry.Destroy;
begin

  FreeAndNil(FInternalRegistry);
  
  inherited;

end;

function TDocumentKindReferenceServiceRegistry.
  GetDocumentKindWorkCycleInfoService(DocumentClass: TDocumentClass): IDocumentKindWorkCycleInfoService;
begin

  Result :=
    IDocumentKindWorkCycleInfoService(
      FInternalRegistry.GetInterface(DocumentClass)
    );
    
end;

class function TDocumentKindReferenceServiceRegistry.
  GetInstance: TDocumentKindReferenceServiceRegistry;
begin

  if not Assigned(FInstance) then
    FInstance := TDocumentKindReferenceServiceRegistry.Create;

  Result := FInstance;
  
end;

procedure TDocumentKindReferenceServiceRegistry.
  RegisterAllStandardDocumentKindReferenceServices(DocumentClass: TDocumentClass);
begin

  RegisterStandardDocumentKindWorkCycleInfoService(DocumentClass);
  
end;

procedure TDocumentKindReferenceServiceRegistry.RegisterDocumentKindWorkCycleInfoService(
  DocumentClass: TDocumentClass;
  DocumentKindWorkCycleInfoService: IDocumentKindWorkCycleInfoService
);
begin

  FInternalRegistry.RegisterInterface(
    DocumentClass,
    DocumentKindWorkCycleInfoService
  );
  
end;

procedure TDocumentKindReferenceServiceRegistry.
  RegisterStandardDocumentKindWorkCycleInfoService(DocumentClass: TDocumentClass);
begin

  RegisterDocumentKindWorkCycleInfoService(
    DocumentClass,
    TStandardDocumentKindWorkCycleInfoService.Create(
      TDocumentSearchServiceRegistry.Instance.GetDocumentKindFinder,
      TDocumentSearchServiceRegistry.Instance.GetDocumentWorkCycleFinder(DocumentClass)
    )
  );
  
end;

end.
