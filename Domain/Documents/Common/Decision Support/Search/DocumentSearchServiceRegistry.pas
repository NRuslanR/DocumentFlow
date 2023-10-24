unit DocumentSearchServiceRegistry;

interface

uses

  Document,
  DocumentFinder,
  FormalDocumentSignerFinder,
  DocumentWorkCycleFinder,
  DocumentKindFinder,
  TypeObjectRegistry,
  SysUtils,
  Classes;

type

  TDocumentSearchServiceRegistry = class
      
    private

      FDocumentFinderRegistry: TTypeObjectRegistry;
      FFormalDocumentSignerFinderRegistry: TTypeObjectRegistry;
      FDocumentWorkCycleFinderRegistry: TTypeObjectRegistry;

      FTypeServiceRegistry: TTypeObjectRegistry;
      
    private

      class var FInstance: TDocumentSearchServiceRegistry;

      class function GetInstance: TDocumentSearchServiceRegistry; static;

    public

      destructor Destroy; override;
      constructor Create;

    public

      procedure RegisterDocumentKindFinder(
        DocumentKindFinder: IDocumentKindFinder
      );

      function GetDocumentKindFinder: IDocumentKindFinder;

    public

      procedure RegisterDocumentFinder(
        DocumentKind: TDocumentClass;
        DocumentFinder: IDocumentFinder
      );

      function GetDocumentFinder(DocumentKind: TDocumentClass): IDocumentFinder;

    public

      procedure RegisterFormalDocumentSignerFinder(
        FormalDocumentSignerFinder: IFormalDocumentSignerFinder
      );

      function GetFormalDocumentSignerFinder: IFormalDocumentSignerFinder;

      procedure RegisterStandardRegisterFormalDocumentSignerFinder;

    public

      procedure RegisterDocumentWorkCycleFinder(
        DocumentKind: TDocumentClass;
        DocumentWorkCycleFinder: IDocumentWorkCycleFinder
      );

      function GetDocumentWorkCycleFinder(DocumentKind: TDocumentClass): IDocumentWorkCycleFinder;

    public

      class property Instance: TDocumentSearchServiceRegistry read GetInstance;

  end;


implementation

uses

  StandardFormalDocumentSignerFinder,
  EmployeeSearchServiceRegistry,
  DocumentNumerationServiceRegistry;
  
type

  TFormalDocumentSignerFinderType = class

  end;

  TDocumentKindFinderType = class

  end;
  
{ TDocumentSearchServiceRegistry }

constructor TDocumentSearchServiceRegistry.Create;
begin

  inherited;

  FDocumentFinderRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FFormalDocumentSignerFinderRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FDocumentWorkCycleFinderRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FTypeServiceRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;

  FDocumentWorkCycleFinderRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  
end;

destructor TDocumentSearchServiceRegistry.Destroy;
begin

  FreeAndNil(FDocumentFinderRegistry);
  FreeAndNil(FFormalDocumentSignerFinderRegistry);
  FreeAndNil(FDocumentWorkCycleFinderRegistry);
  FreeAndNil(FTypeServiceRegistry);

  FInstance := nil;
    
  inherited;

end;

function TDocumentSearchServiceRegistry.GetDocumentFinder(
  DocumentKind: TDocumentClass): IDocumentFinder;
begin

  Result :=
    IDocumentFinder(
      FDocumentFinderRegistry.GetInterface(DocumentKind)
    );

end;

function TDocumentSearchServiceRegistry.GetDocumentKindFinder: IDocumentKindFinder;
begin

  Result :=
    IDocumentKindFinder(
      FTypeServiceRegistry.GetInterface(TDocumentKindFinderType)
    );
    
end;

function TDocumentSearchServiceRegistry.GetDocumentWorkCycleFinder(
  DocumentKind: TDocumentClass): IDocumentWorkCycleFinder;
begin

  Result :=
    IDocumentWorkCycleFinder(
      FDocumentWorkCycleFinderRegistry.GetInterface(DocumentKind)
    );
    
end;

function TDocumentSearchServiceRegistry.GetFormalDocumentSignerFinder: IFormalDocumentSignerFinder;
begin

  Result :=
    IFormalDocumentSignerFinder(
      FFormalDocumentSignerFinderRegistry.GetInterface(
        TFormalDocumentSignerFinderType
      )
    );
    
end;

class function TDocumentSearchServiceRegistry.GetInstance: TDocumentSearchServiceRegistry;
begin

  if not Assigned(FInstance) then
    FInstance := TDocumentSearchServiceRegistry.Create;

  Result := FInstance;

end;

procedure TDocumentSearchServiceRegistry.RegisterDocumentFinder(
  DocumentKind: TDocumentClass; DocumentFinder: IDocumentFinder);
begin

  FDocumentFinderRegistry.RegisterInterface(
    DocumentKind,
    DocumentFinder
  );

end;

procedure TDocumentSearchServiceRegistry.RegisterDocumentKindFinder(
  DocumentKindFinder: IDocumentKindFinder);
begin

  FTypeServiceRegistry.RegisterInterface(
    TDocumentKindFinderType,
    DocumentKindFinder
  );
  
end;

procedure TDocumentSearchServiceRegistry.RegisterDocumentWorkCycleFinder(
  DocumentKind: TDocumentClass;
  DocumentWorkCycleFinder: IDocumentWorkCycleFinder);
begin

  FDocumentWorkCycleFinderRegistry.RegisterInterface(
    DocumentKind,
    DocumentWorkCycleFinder
  );
  
end;

procedure TDocumentSearchServiceRegistry.RegisterFormalDocumentSignerFinder(
  FormalDocumentSignerFinder: IFormalDocumentSignerFinder
);
begin

  FFormalDocumentSignerFinderRegistry.RegisterInterface(
    TFormalDocumentSignerFinderType,
    FormalDocumentSignerFinder
  );
  
end;

procedure TDocumentSearchServiceRegistry.RegisterStandardRegisterFormalDocumentSignerFinder;
begin

  RegisterFormalDocumentSignerFinder(
    TStandardFormalDocumentSignerFinder.Create(
      TDocumentNumerationServiceRegistry.Instance.GetDocumentNumeratorRegistry,
      TEmployeeSearchServiceRegistry.Instance.GetEmployeeFinder
    )
  );
  
end;

end.
