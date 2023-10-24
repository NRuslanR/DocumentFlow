unit DocumentAccessRightsServiceRegistry;

interface

uses

  TypeObjectRegistry,
  DocumentUsageEmployeeAccessRightsService,
  GeneralDocumentChargeSheetAccessRightsService,
  EmployeeDocumentKindAccessRightsService,
  Document,
  IncomingDocument,
  SysUtils,
  Classes;

type

  TDocumentAccessRightsServiceRegistry = class

    private

      class var FInstance: TDocumentAccessRightsServiceRegistry;

      class function GetInstance: TDocumentAccessRightsServiceRegistry; static;
      
    private

      FInternalRegistry: TTypeObjectRegistry;

    public

      procedure RegisterDocumentUsageEmployeeAccessRightsService(
        DocumentKind: TDocumentClass;
        DocumentUsageEmployeeAccessRightsService: IDocumentUsageEmployeeAccessRightsService
      );

      procedure RegisterStandardDocumentUsageEmployeeAccessRightsService(
        DocumentKind: TDocumentClass
      );

      function GetDocumentUsageEmployeeAccessRightsService(
        DocumentKind: TDocumentClass
      ): IDocumentUsageEmployeeAccessRightsService;
      
    public

      procedure RegisterEmployeeDocumentKindAccessRightsService(
        EmployeeDocumentKindAccessRightsService: IEmployeeDocumentKindAccessRightsService
      );

      procedure RegisterStandardEmployeeDocumentKindAccessRightsService;
      
      function GetEmployeeDocumentKindAccessRightsService:
        IEmployeeDocumentKindAccessRightsService;

    public

      procedure RegisterAllStandardDocumentAccessRightsServices(
        DocumentKind: TDocumentClass
      );
      
    public
    
      destructor Destroy; override;
      constructor Create;

      class property Instance: TDocumentAccessRightsServiceRegistry read GetInstance;

  end;

implementation

uses

  InMemoryObjectRegistry,
  StandardDocumentUsageEmployeeAccessRightsService,
  StandardIncomingDocumentUsageEmployeeAccessRightsService,
  StandardGeneralDocumentChargeSheetAccessRightsService,
  StandardGeneralIncomingDocumentChargeSheetAccessRightsService,
  StandardEmployeeDocumentKindAccessRightsService,
  PersonnelOrderCreatingAccessService,
  EmployeeSearchServiceRegistry,
  DocumentFormalizationServiceRegistry,
  DocumentChargeServiceRegistry,
  PersonnelOrderDomainRegistries,
  DocumentRelationsServiceRegistry,
  DocumentChargeSheetsServiceRegistry;

type

  TEmployeeDocumentKindAccessRightsServiceType = class
  
  end;

{ TDocumentAccessRightsServiceRegistry }

constructor TDocumentAccessRightsServiceRegistry.Create;
begin

  inherited Create;

  FInternalRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;

end;

destructor TDocumentAccessRightsServiceRegistry.Destroy;
begin

  FreeAndNil(FInternalRegistry);

  inherited;

end;

function TDocumentAccessRightsServiceRegistry.
  GetDocumentUsageEmployeeAccessRightsService(
    DocumentKind: TDocumentClass
  ): IDocumentUsageEmployeeAccessRightsService;
begin

  Result :=
    IDocumentUsageEmployeeAccessRightsService(
      FInternalRegistry.GetInterface(DocumentKind)
    );
    
end;

function TDocumentAccessRightsServiceRegistry.
  GetEmployeeDocumentKindAccessRightsService:
    IEmployeeDocumentKindAccessRightsService;
begin

  Result :=
    IEmployeeDocumentKindAccessRightsService(
      FInternalRegistry.GetInterface(
        TEmployeeDocumentKindAccessRightsServiceType
      )
    );
    
end;

class function TDocumentAccessRightsServiceRegistry.
  GetInstance: TDocumentAccessRightsServiceRegistry;
begin

  if not Assigned(FInstance) then
    FInstance := TDocumentAccessRightsServiceRegistry.Create;

  Result := FInstance;

end;

procedure TDocumentAccessRightsServiceRegistry.
  RegisterAllStandardDocumentAccessRightsServices(
    DocumentKind: TDocumentClass
  );
begin

  RegisterStandardDocumentUsageEmployeeAccessRightsService(DocumentKind);
  RegisterStandardEmployeeDocumentKindAccessRightsService;
  
end;

procedure TDocumentAccessRightsServiceRegistry.
  RegisterDocumentUsageEmployeeAccessRightsService(
    DocumentKind: TDocumentClass;
    DocumentUsageEmployeeAccessRightsService: IDocumentUsageEmployeeAccessRightsService
  );
begin

  FInternalRegistry.RegisterInterface(
    DocumentKind,
    DocumentUsageEmployeeAccessRightsService
  );

end;

procedure TDocumentAccessRightsServiceRegistry.
  RegisterEmployeeDocumentKindAccessRightsService(
    EmployeeDocumentKindAccessRightsService: IEmployeeDocumentKindAccessRightsService
  );
begin

  FInternalRegistry.RegisterInterface(
    TEmployeeDocumentKindAccessRightsServiceType,
    EmployeeDocumentKindAccessRightsService
  );

end;

procedure TDocumentAccessRightsServiceRegistry.
  RegisterStandardDocumentUsageEmployeeAccessRightsService(
    DocumentKind: TDocumentClass
  );
var
    DocumentUsageEmployeeAccessRightsService:
      IDocumentUsageEmployeeAccessRightsService;

    GeneralDocumentChargeSheetAccessRightsService:
      IGeneralDocumentChargeSheetAccessRightsService;
begin

  GeneralDocumentChargeSheetAccessRightsService :=
    TDocumentChargeSheetsServiceRegistry
      .Instance
        .GetGeneralDocumentChargeSheetAccessRightsService(DocumentKind);

  if not Assigned(GeneralDocumentChargeSheetAccessRightsService)
  then begin

    TDocumentChargeSheetsServiceRegistry
      .Instance
        .RegisterStandardGeneralDocumentChargeSheetAccessRightsService(DocumentKind);

    GeneralDocumentChargeSheetAccessRightsService :=
      TDocumentChargeSheetsServiceRegistry
        .Instance
          .GetGeneralDocumentChargeSheetAccessRightsService(DocumentKind);
          
  end;
  
  if GetEmployeeDocumentKindAccessRightsService = nil then
  	RegisterStandardEmployeeDocumentKindAccessRightsService;
  
  if DocumentKind.InheritsFrom(TIncomingDocument) then begin

    DocumentUsageEmployeeAccessRightsService :=
      TStandardIncomingDocumentUsageEmployeeAccessRightsService.Create(
        TDocumentFormalizationServiceRegistry.Instance.GetDocumentFullNameCompilationService,
        TDocumentRelationsServiceRegistry.Instance.GetDocumentRelationsFinder(DocumentKind),
        GeneralDocumentChargeSheetAccessRightsService,
		GetEmployeeDocumentKindAccessRightsService
      );

  end

  else begin

    DocumentUsageEmployeeAccessRightsService :=
      TStandardDocumentUsageEmployeeAccessRightsService.Create(
        TDocumentFormalizationServiceRegistry.Instance.GetDocumentFullNameCompilationService,
        TDocumentRelationsServiceRegistry.Instance.GetDocumentRelationsFinder(DocumentKind),
        GeneralDocumentChargeSheetAccessRightsService,
		GetEmployeeDocumentKindAccessRightsService
      );
      
  end;
  
  RegisterDocumentUsageEmployeeAccessRightsService(
    DocumentKind,
    DocumentUsageEmployeeAccessRightsService
  );

end;

procedure TDocumentAccessRightsServiceRegistry.
  RegisterStandardEmployeeDocumentKindAccessRightsService;
begin

  RegisterEmployeeDocumentKindAccessRightsService(
    TStandardEmployeeDocumentKindAccessRightsService.Create(

      TPersonnelOrderDomainRegistries
        .ServiceRegistries
          .PersonnelOrderAccessServiceRegistry
            .GetPersonnelOrderCreatingAccessService

    )
  );

end;

end.
