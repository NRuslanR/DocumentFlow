unit DocumentRegistrationServiceRegistry;

interface

uses

  DocumentRegistrationService,
  Document,
  TypeObjectRegistry,
  SysUtils;

type

  TDocumentRegistrationServiceRegistry = class

    private

      class var FInstance: TDocumentRegistrationServiceRegistry;

      class function GetInstance: TDocumentRegistrationServiceRegistry; static;

    private

      FInternalRegistry: TTypeObjectRegistry;

    public

      procedure RegisterDocumentRegistrationService(
        DocumentKind: TDocumentClass;
        DocumentRegistrationService: IDocumentRegistrationService
      );

      function GetDocumentRegistrationService(
        DocumentKind: TDocumentClass
      ): IDocumentRegistrationService;

      procedure RegisterStandardDocumentRegistrationService(
        DocumentKind: TDocumentClass
      );

    public

      destructor Destroy; override;
      constructor Create;

      class property Instance: TDocumentRegistrationServiceRegistry
      read GetInstance;

  end;

implementation

uses

  IncomingDocument,
  InternalDocument,
  IncomingInternalDocument,
  StandardInDepartmentDocumentRegistrationService,
  StandardInDepartmentIncomingDocumentRegistrationService,
  StandardInDepartmentIncomingInternalDocumentRegistrationService,
  EmployeeSearchServiceRegistry,
  DocumentNumerationServiceRegistry;



{ TDocumentRegistrationServiceRegistry }

constructor TDocumentRegistrationServiceRegistry.Create;
begin

  inherited;

  FInternalRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;

  FInternalRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  
end;

destructor TDocumentRegistrationServiceRegistry.Destroy;
begin

  FreeAndNil(FInternalRegistry);
  
  inherited;

end;

function TDocumentRegistrationServiceRegistry.GetDocumentRegistrationService(
  DocumentKind: TDocumentClass): IDocumentRegistrationService;
begin

  Result :=
    IDocumentRegistrationService(
      FInternalRegistry.GetInterface(DocumentKind)
    );
    
end;

class function TDocumentRegistrationServiceRegistry.
  GetInstance: TDocumentRegistrationServiceRegistry;
begin

  if not Assigned(FInstance) then
    FInstance := TDocumentRegistrationServiceRegistry.Create;

  Result := FInstance;

end;

procedure TDocumentRegistrationServiceRegistry.RegisterDocumentRegistrationService(
  DocumentKind: TDocumentClass;
  DocumentRegistrationService: IDocumentRegistrationService);
begin

  FInternalRegistry.RegisterInterface(
    DocumentKind,
    DocumentRegistrationService
  );
  
end;

procedure TDocumentRegistrationServiceRegistry.
  RegisterStandardDocumentRegistrationService(
    DocumentKind: TDocumentClass
  );
var Service: IDocumentRegistrationService;
begin

  if DocumentKind.InheritsFrom(TIncomingInternalDocument) then begin

    Service :=
      TStandardInDepartmentIncomingInternalDocumentRegistrationService.Create(
        TEmployeeSearchServiceRegistry.Instance.GetEmployeeFinder,
        TDocumentNumerationServiceRegistry.Instance.GetDocumentNumeratorRegistry
      );
      
  end

  else if DocumentKind.InheritsFrom(TIncomingDocument) then begin

    Service :=
      TStandardInDepartmentIncomingDocumentRegistrationService.Create(
        TEmployeeSearchServiceRegistry.Instance.GetEmployeeFinder,
        TDocumentNumerationServiceRegistry.Instance.GetDocumentNumeratorRegistry
      );

  end

  else begin

    Service :=
      TStandardInDepartmentDocumentRegistrationService.Create(
        TDocumentNumerationServiceRegistry.Instance.GetDocumentNumeratorRegistry
      );
    
  end;

  RegisterDocumentRegistrationService(DocumentKind, Service);
  
end;

end.
