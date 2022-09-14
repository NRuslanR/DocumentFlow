unit DocumentChargeSheetsServiceRegistry;

interface

uses

  Document,
  IncomingDocument,
  DocumentChargeSheetFinder,
  DocumentChargeSheetControlService,
  DocumentChargeSheetDirectory,
  DocumentChargeSheetOverlappingPerformingService,
  DocumentChargeSheetOrdinaryPerformingService,
  DocumentChargeSheetPerformingService,
  DocumentChargeSheetControlPerformingService,
  DocumentChargeSheetRemovingService,
  DocumentChargeSheetCreatingService,
  DocumentChargeSheetAccessRightsService,
  DomainException,
  TypeObjectRegistry,
  DocumentChargeSheet,
  SysUtils;

type

  TDocumentChargeSheetsServiceRegistry = class

    private

      class var FInstance: TDocumentChargeSheetsServiceRegistry;

      class function GetInstance: TDocumentChargeSheetsServiceRegistry; static;

    private

      FDocumentChargeSheetFinderRegistry: TTypeObjectRegistry;
      FDocumentChargeSheetCreatingServiceRegistry: TTypeObjectRegistry;
      FDocumentChargeSheetControlServiceRegistry: TTypeObjectRegistry;
      FDocumentChargeSheetPerformingServiceRegistry: TTypeObjectRegistry;
      FDocumentChargeSheetControlPerformingServiceRegistry: TTypeObjectRegistry;
      FDocumentChargeSheetRemovingServiceRegistry: TTypeObjectRegistry;
      FDocumentChargeSheetDirectoryRegistry: TTypeObjectRegistry;
      FDocumentChargeSheetAccessRightsServiceRegistry: TTypeObjectRegistry;
      
    public

      procedure RegisterDocumentChargeSheetFinder(
        DocumentKind: TDocumentClass;
        DocumentChargeSheetFinder: IDocumentChargeSheetFinder
      );

      function GetDocumentChargeSheetFinder(DocumentKind: TDocumentClass): IDocumentChargeSheetFinder;

    public

      procedure RegisterDocumentChargeSheetDirectory(
        DocumentKind: TDocumentClass;
        DocumentChargeSheetDirectory: IDocumentChargeSheetDirectory
      );

      function GetDocumentChargeSheetDirectory(DocumentKind: TDocumentClass): IDocumentChargeSheetDirectory;

    public

      procedure RegisterDocumentChargeSheetCreatingService(
        ChargeSheetCreatingService: IDocumentChargeSheetCreatingService;
        DocumentChargeSheetKind: TDocumentChargeSheetClass
      );

      procedure RegisterStandardDocumentChargeSheetCreatingService(
        DocumentChargeSheetKind: TDocumentChargeSheetClass
      );

      function GetDocumentChargeSheetCreatingService(
        DocumentChargeSheetKind: TDocumentChargeSheetClass
      ): IDocumentChargeSheetCreatingService;
      
    public

      procedure RegisterDocumentChargeSheetControlService(
        DocumentKind: TDocumentClass;
        DocumentChargeSheetControlService: IDocumentChargeSheetControlService
      );

      procedure RegisterStandardDocumentChargeSheetControlService(
        DocumentKind: TDocumentClass
      );

      function GetDocumentChargeSheetControlService(
        DocumentKind: TDocumentClass
      ): IDocumentChargeSheetControlService;

    public

      procedure RegisterDocumentChargeSheetOverlappingPerformingService(
        DocumentKind: TDocumentClass;
        DocumentChargeSheetType: TDocumentChargeSheetClass;
        DocumentChargeSheetOverlappingPerformingService: IDocumentChargeSheetOverlappingPerformingService
      );

      procedure RegisterStandardDocumentChargeSheetOverlappingPerformingService(
        DocumentKind: TDocumentClass;
        DocumentChargeSheetType: TDocumentChargeSheetClass
      );

      function GetDocumentChargeSheetOverlappingPerformingService(
        DocumentKind: TDocumentClass;
        DocumentChargeSheetType: TDocumentChargeSheetClass
      ): IDocumentChargeSheetOverlappingPerformingService;

    public

      procedure RegisterDocumentChargeSheetOrdinaryPerformingService(

        DocumentKind: TDocumentClass;
        DocumentChargeSheetType: TDocumentChargeSheetClass;
        
        DocumentChargeSheetOrdinaryPerformingService:
          IDocumentChargeSheetOrdinaryPerformingService
      );

      procedure RegisterStandardDocumentChargeSheetOrdinaryPerformingService(
        DocumentKind: TDocumentClass;
        DocumentChargeSheetType: TDocumentChargeSheetClass
      );

      function GetDocumentChargeSheetOrdinaryPerformingService(
        DocumentKind: TDocumentClass;
        DocumentChargeSheetType: TDocumentChargeSheetClass
      ):IDocumentChargeSheetOrdinaryPerformingService;

    public

      procedure RegisterDocumentChargeSheetPerformingService(
        DocumentKind: TDocumentClass;
        DocumentChargeSheetType: TDocumentChargeSheetClass;
        PerformingService: IDocumentChargeSheetPerformingService
      );

      function GetDocumentChargeSheetPerformingService(
        DocumentKind: TDocumentClass;
        DocumentChargeSheetType: TDocumentChargeSheetClass
      ):IDocumentChargeSheetPerformingService;

    public
    
      procedure RegisterDocumentChargeSheetAccessRightsService(
        ChargeSheetAccessRightsService: IDocumentChargeSheetAccessRightsService;
        DocumentChargeSheetKind: TDocumentChargeSheetClass = nil
      );

      procedure RegisterStandardDocumentChargeSheetAccessRightsService(
        DocumentChargeSheetKind: TDocumentChargeSheetClass = nil
      );

      function GetDocumentChargeSheetAccessRightsService(
        DocumentChargeSheetKind: TDocumentChargeSheetClass = nil
      ): IDocumentChargeSheetAccessRightsService;

    public

      procedure RegisterDocumentChargeSheetControlPerformingService(
        DocumentKind: TDocumentClass;
        DocumentChargeSheetControlPerformingService: IDocumentChargeSheetControlPerformingService
      );

      procedure RegisterStandardDocumentChargeSheetControlPerformingService(
        DocumentKind: TDocumentClass
      );

      function GetDocumentChargeSheetControlPerformingService(
        DocumentKind: TDocumentClass
      ): IDocumentChargeSheetControlPerformingService;

    public

      procedure RegisterDocumentChargeSheetRemovingService(
        DocumentKind: TDocumentClass;
        DocumentChargeSheetRemovingService: IDocumentChargeSheetRemovingService
      );

      procedure RegisterStandardDocumentChargeSheetRemovingService(
        DocumentKind: TDocumentClass
      );

      function GetDocumentChargeSheetRemovingService(
        DocumentKind: TDocumentClass
      ): IDocumentChargeSheetRemovingService;

    public

      procedure RegisterAllStandardDocumentChargeSheetPerformingServices(
        DocumentKind: TDocumentClass
      );

      procedure RegisterAllStandardDocumentChargeSheetsServices(
        DocumentKind: TDocumentClass
      );

    public

      destructor Destroy; override;
      constructor Create;
      
      class property Instance: TDocumentChargeSheetsServiceRegistry
      read GetInstance;
      
  end;

implementation

uses

  InternalDocument,
  IncomingInternalDocument,
  DocumentAcquaitanceSheet,
  DocumentPerformingSheet,
  PersonnelOrder,
  StandardDocumentChargeSheetControlService,
  StandardDocumentChargeSheetCreatingService,
  StandardDocumentPerformingSheetCreatingService,
  StandardDocumentChargeSheetOverlappingPerformingService,
  StandardDocumentChargeSheetOrdinaryPerformingService,
  StandardDocumentChargeSheetControlPerformingService,
  InterfaceObjectList,
  EmployeeRelationshipRuleRegistry,
  DocumentChargeSheetRuleRegistry,
  DocumentChargeServiceRegistry,
  DocumentFormalizationServiceRegistry,
  EmployeeDistributionSpecificationRegistry,
  DocumentStorageServiceRegistry,
  DocumentPerformingServiceRegistry,
  StandardDocumentChargeSheetAccessRightsService,
  DocumentSpecificationRegistry,
  StandardDocumentChargeSheetRemovingService,
  EmployeeSubordinationSpecificationRegistry;

{ TDocumentChargeSheetsServiceRegistry }

constructor TDocumentChargeSheetsServiceRegistry.Create;
begin

  inherited;

  FDocumentChargeSheetCreatingServiceRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FDocumentChargeSheetFinderRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FDocumentChargeSheetDirectoryRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FDocumentChargeSheetControlServiceRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FDocumentChargeSheetPerformingServiceRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FDocumentChargeSheetControlPerformingServiceRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FDocumentChargeSheetRemovingServiceRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FDocumentChargeSheetAccessRightsServiceRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  
  FDocumentChargeSheetFinderRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  FDocumentChargeSheetDirectoryRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  FDocumentChargeSheetControlServiceRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  FDocumentChargeSheetPerformingServiceRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  
end;

destructor TDocumentChargeSheetsServiceRegistry.Destroy;
begin

  FreeAndNil(FDocumentChargeSheetFinderRegistry);
  FreeAndNil(FDocumentChargeSheetCreatingServiceRegistry);
  FreeAndNil(FDocumentChargeSheetDirectoryRegistry);
  FreeAndNil(FDocumentChargeSheetControlServiceRegistry);
  FreeAndNil(FDocumentChargeSheetPerformingServiceRegistry);
  FreeAndNil(FDocumentChargeSheetControlPerformingServiceRegistry);
  FreeAndNil(FDocumentChargeSheetRemovingServiceRegistry);
  FreeAndNil(FDocumentChargeSheetAccessRightsServiceRegistry);

  inherited;

end;

function TDocumentChargeSheetsServiceRegistry.GetDocumentChargeSheetAccessRightsService(
  DocumentChargeSheetKind: TDocumentChargeSheetClass): IDocumentChargeSheetAccessRightsService;
begin

  Result :=
    IDocumentChargeSheetAccessRightsService(
      FDocumentChargeSheetAccessRightsServiceRegistry.GetInterface(
        DocumentChargeSheetKind
      )
    );

end;

function TDocumentChargeSheetsServiceRegistry.GetDocumentChargeSheetControlPerformingService(
  DocumentKind: TDocumentClass): IDocumentChargeSheetControlPerformingService;
begin

  Result :=
    IDocumentChargeSheetControlPerformingService(
      FDocumentChargeSheetControlPerformingServiceRegistry.GetInterface(
        DocumentKind
      )
    );
    
end;

function TDocumentChargeSheetsServiceRegistry.GetDocumentChargeSheetControlService(
  DocumentKind: TDocumentClass): IDocumentChargeSheetControlService;
begin

  Result :=
    IDocumentChargeSheetControlService(
      FDocumentChargeSheetControlServiceRegistry.GetInterface(
        DocumentKind
      )
    );
    
end;

function TDocumentChargeSheetsServiceRegistry.GetDocumentChargeSheetCreatingService(
  DocumentChargeSheetKind: TDocumentChargeSheetClass): IDocumentChargeSheetCreatingService;
begin

  Result :=
    IDocumentChargeSheetCreatingService(
      FDocumentChargeSheetCreatingServiceRegistry.GetInterface(
        DocumentChargeSheetKind
      )
    );
    
end;

function TDocumentChargeSheetsServiceRegistry.GetDocumentChargeSheetDirectory(DocumentKind: TDocumentClass): IDocumentChargeSheetDirectory;
begin

  Result :=
    IDocumentChargeSheetDirectory(
      FDocumentChargeSheetDirectoryRegistry.GetInterface(DocumentKind)
    );
    
end;

function TDocumentChargeSheetsServiceRegistry.
  GetDocumentChargeSheetFinder(DocumentKind: TDocumentClass): IDocumentChargeSheetFinder;
begin

  Result :=
    IDocumentChargeSheetFinder(
      FDocumentChargeSheetFinderRegistry.GetInterface(DocumentKind)
    );

end;

function TDocumentChargeSheetsServiceRegistry.
  GetDocumentChargeSheetOrdinaryPerformingService(
    DocumentKind: TDocumentClass;
    DocumentChargeSheetType: TDocumentChargeSheetClass
  ): IDocumentChargeSheetOrdinaryPerformingService;
begin

  Result :=
    IDocumentChargeSheetOrdinaryPerformingService(
      GetDocumentChargeSheetPerformingService(DocumentKind, DocumentChargeSheetType)
    );
    
end;

function TDocumentChargeSheetsServiceRegistry
  .GetDocumentChargeSheetOverlappingPerformingService(
    DocumentKind: TDocumentClass;
    DocumentChargeSheetType: TDocumentChargeSheetClass
  ): IDocumentChargeSheetOverlappingPerformingService;
begin

  Result :=
    IDocumentChargeSheetOverlappingPerformingService(
      GetDocumentChargeSheetPerformingService(DocumentKind, DocumentChargeSheetType)
    );

end;

function TDocumentChargeSheetsServiceRegistry.GetDocumentChargeSheetPerformingService(
  DocumentKind: TDocumentClass;
  DocumentChargeSheetType: TDocumentChargeSheetClass
): IDocumentChargeSheetPerformingService;
begin

  Result :=
    IDocumentChargeSheetPerformingService(
      FDocumentChargeSheetPerformingServiceRegistry.GetInterface(
        [DocumentKind, DocumentChargeSheetType]
      )
    );
    
end;

function TDocumentChargeSheetsServiceRegistry.GetDocumentChargeSheetRemovingService(
  DocumentKind: TDocumentClass
): IDocumentChargeSheetRemovingService;
begin

  Result :=
    IDocumentChargeSheetRemovingService(
      FDocumentChargeSheetRemovingServiceRegistry.GetInterface(
        DocumentKind
      )
    ); 

end;

class function TDocumentChargeSheetsServiceRegistry.
  GetInstance: TDocumentChargeSheetsServiceRegistry;
begin

  if not Assigned(FInstance) then
    FInstance := TDocumentChargeSheetsServiceRegistry.Create;

  Result := FInstance;
  
end;

procedure TDocumentChargeSheetsServiceRegistry.RegisterDocumentChargeSheetAccessRightsService(
  ChargeSheetAccessRightsService: IDocumentChargeSheetAccessRightsService;
  DocumentChargeSheetKind: TDocumentChargeSheetClass);
begin

  FDocumentChargeSheetAccessRightsServiceRegistry.RegisterInterface(
    DocumentChargeSheetKind,
    ChargeSheetAccessRightsService
  );

end;

procedure TDocumentChargeSheetsServiceRegistry.RegisterDocumentChargeSheetControlPerformingService(
  DocumentKind: TDocumentClass;
  DocumentChargeSheetControlPerformingService: IDocumentChargeSheetControlPerformingService);
begin

  FDocumentChargeSheetControlPerformingServiceRegistry.RegisterInterface(
    DocumentKind,
    DocumentChargeSheetControlPerformingService
  );

end;

procedure TDocumentChargeSheetsServiceRegistry.RegisterDocumentChargeSheetControlService(
  DocumentKind: TDocumentClass;
  DocumentChargeSheetControlService: IDocumentChargeSheetControlService);
begin

  FDocumentChargeSheetControlServiceRegistry.RegisterInterface(
    DocumentKind,
    DocumentChargeSheetControlService
  );
  
end;

procedure TDocumentChargeSheetsServiceRegistry.RegisterDocumentChargeSheetCreatingService(
  ChargeSheetCreatingService: IDocumentChargeSheetCreatingService;
  DocumentChargeSheetKind: TDocumentChargeSheetClass);
begin

  FDocumentChargeSheetCreatingServiceRegistry.RegisterInterface(
    DocumentChargeSheetKind,
    ChargeSheetCreatingService
  );

end;

procedure TDocumentChargeSheetsServiceRegistry.RegisterDocumentChargeSheetDirectory(
  DocumentKind: TDocumentClass;
  DocumentChargeSheetDirectory: IDocumentChargeSheetDirectory);
begin

  FDocumentChargeSheetDirectoryRegistry.RegisterInterface(
    DocumentKind, DocumentChargeSheetDirectory
  );
  
end;

procedure TDocumentChargeSheetsServiceRegistry.RegisterDocumentChargeSheetFinder(
  DocumentKind: TDocumentClass;
  DocumentChargeSheetFinder: IDocumentChargeSheetFinder
);
begin

  FDocumentChargeSheetFinderRegistry.RegisterInterface(
    DocumentKind,
    DocumentChargeSheetFinder
  );

end;

procedure TDocumentChargeSheetsServiceRegistry.RegisterDocumentChargeSheetOrdinaryPerformingService(
  DocumentKind: TDocumentClass;
  DocumentChargeSheetType: TDocumentChargeSheetClass;
  DocumentChargeSheetOrdinaryPerformingService: IDocumentChargeSheetOrdinaryPerformingService);
begin

  RegisterDocumentChargeSheetPerformingService(
    DocumentKind,
    DocumentChargeSheetType,
    DocumentChargeSheetOrdinaryPerformingService
  );

end;

procedure TDocumentChargeSheetsServiceRegistry.RegisterDocumentChargeSheetOverlappingPerformingService(
  DocumentKind: TDocumentClass;
  DocumentChargeSheetType: TDocumentChargeSheetClass;
  DocumentChargeSheetOverlappingPerformingService: IDocumentChargeSheetOverlappingPerformingService
);
begin

  RegisterDocumentChargeSheetPerformingService(
    DocumentKind,
    DocumentChargeSheetType,
    DocumentChargeSheetOverlappingPerformingService
  );
  
end;

procedure TDocumentChargeSheetsServiceRegistry.RegisterDocumentChargeSheetPerformingService(
  DocumentKind: TDocumentClass;
  DocumentChargeSheetType: TDocumentChargeSheetClass;
  PerformingService: IDocumentChargeSheetPerformingService);
begin

  FDocumentChargeSheetPerformingServiceRegistry.RegisterInterface(
    [DocumentKind, DocumentChargeSheetType],
    PerformingService
  );
  
end;

procedure TDocumentChargeSheetsServiceRegistry.RegisterDocumentChargeSheetRemovingService(
  DocumentKind: TDocumentClass;
  DocumentChargeSheetRemovingService: IDocumentChargeSheetRemovingService);
begin

  FDocumentChargeSheetRemovingServiceRegistry.RegisterInterface(
    DocumentKind,
    DocumentChargeSheetRemovingService
  );
  
end;

procedure TDocumentChargeSheetsServiceRegistry.RegisterStandardDocumentChargeSheetAccessRightsService(
  DocumentChargeSheetKind: TDocumentChargeSheetClass);
begin

  RegisterDocumentChargeSheetAccessRightsService(
    TStandardDocumentChargeSheetAccessRightsService.Create,
    DocumentChargeSheetKind 
  );
  
end;

procedure TDocumentChargeSheetsServiceRegistry.RegisterStandardDocumentChargeSheetControlPerformingService(
  DocumentKind: TDocumentClass);
begin

  RegisterDocumentChargeSheetControlPerformingService(
    DocumentKind,
    TStandardDocumentChargeSheetControlPerformingService.Create(
      TDocumentPerformingServiceRegistry.Instance.GetDocumentPerformingService(
        DocumentKind
      )
    )
  );

end;

procedure TDocumentChargeSheetsServiceRegistry.RegisterStandardDocumentChargeSheetControlService(
  DocumentKind: TDocumentClass);
var
    DocumentChargeSheetKind: TDocumentChargeSheetClass;
begin

  if DocumentKind.InheritsFrom(TIncomingDocument) then Exit;

  {
    refactor: получать типы поручений из службу ChargeKindsControlService
    и регистрировать соответствующие службы создани€ листов поручений
  }

  if GetDocumentChargeSheetCreatingService(TDocumentAcquaitanceSheet) = nil then
    RegisterStandardDocumentChargeSheetCreatingService(TDocumentAcquaitanceSheet);

  if GetDocumentChargeSheetCreatingService(TDocumentPerformingSheet) = nil then
    RegisterStandardDocumentChargeSheetCreatingService(TDocumentPerformingSheet);

  if GetDocumentChargeSheetRemovingService(DocumentKind) = nil then
    RegisterStandardDocumentChargeSheetRemovingService(DocumentKind);

  if GetDocumentChargeSheetControlPerformingService(DocumentKind) = nil then
    RegisterStandardDocumentChargeSheetControlPerformingService(DocumentKind);
  
  if DocumentKind.InheritsFrom(TPersonnelOrder) then
    DocumentChargeSheetKind := TDocumentAcquaitanceSheet

  else DocumentChargeSheetKind := TDocumentPerformingSheet;

  RegisterDocumentChargeSheetControlService(
    DocumentKind,
    TStandardDocumentChargeSheetControlService.Create(
      TDocumentChargeSheetsServiceRegistry.Instance.GetDocumentChargeSheetDirectory(DocumentKind),
      GetDocumentChargeSheetCreatingService(DocumentChargeSheetKind),
      GetDocumentChargeSheetRemovingService(DocumentKind),
      TDocumentPerformingServiceRegistry.Instance.GetDocumentPerformingService(DocumentKind),
      GetDocumentChargeSheetControlPerformingService(DocumentKind),
      GetDocumentChargeSheetAccessRightsService(DocumentChargeSheetKind)
    )
  );

end;

procedure TDocumentChargeSheetsServiceRegistry.RegisterStandardDocumentChargeSheetCreatingService(
  DocumentChargeSheetKind: TDocumentChargeSheetClass);
begin

  if GetDocumentChargeSheetAccessRightsService(DocumentChargeSheetKind) = nil then
    RegisterStandardDocumentChargeSheetAccessRightsService(DocumentChargeSheetKind);
    
  if DocumentChargeSheetKind.InheritsFrom(TDocumentAcquaitanceSheet)
  then begin

    RegisterDocumentChargeSheetCreatingService(
      TStandardDocumentChargeSheetCreatingService.Create(
        GetDocumentChargeSheetAccessRightsService(DocumentChargeSheetKind),
        TDocumentChargeServiceRegistry.Instance.GetDocumentChargeCreatingService(DocumentChargeSheetKind.ChargeType),
        TEmployeeRelationshipRuleRegistry.Instance.GetEmployeeChargeIssuingRule,
        TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsSameAsOrDeputyOfEmployeesSpecification
      ),
      DocumentChargeSheetKind
    );

  end

  else if DocumentChargeSheetKind.InheritsFrom(TDocumentPerformingSheet) then begin

    RegisterDocumentChargeSheetCreatingService(
      TStandardDocumentPerformingSheetCreatingService.Create(
        GetDocumentChargeSheetAccessRightsService(DocumentChargeSheetKind),
        TDocumentChargeServiceRegistry.Instance.GetDocumentChargeCreatingService(DocumentChargeSheetKind.ChargeType),
        TEmployeeRelationshipRuleRegistry.Instance.GetEmployeeChargeIssuingRule,
        TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsSameAsOrDeputyOfEmployeesSpecification
      ),
      DocumentChargeSheetKind
    );

  end

  else begin

    Raise TDomainException.Create(
      'Ќеожидаемый тип поручени€ при регистрации ' +
      'службы создани€ листа поручени€'
    );

  end;

end;

procedure TDocumentChargeSheetsServiceRegistry.RegisterStandardDocumentChargeSheetOrdinaryPerformingService(
  DocumentKind: TDocumentClass;
  DocumentChargeSheetType: TDocumentChargeSheetClass
);
begin

  RegisterDocumentChargeSheetOrdinaryPerformingService(
    DocumentKind,
    DocumentChargeSheetType,
    TStandardDocumentChargeSheetOrdinaryPerformingService.Create
  );
  
end;

procedure TDocumentChargeSheetsServiceRegistry.RegisterStandardDocumentChargeSheetOverlappingPerformingService(
  DocumentKind: TDocumentClass;
  DocumentChargeSheetType: TDocumentChargeSheetClass
);
begin

  RegisterDocumentChargeSheetOverlappingPerformingService(
    DocumentKind,
    DocumentChargeSheetType,
    TStandardDocumentChargeSheetOverlappingPerformingService.Create(
      TEmployeeSubordinationSpecificationRegistry.Instance.GetEmployeeIsSameAsOrDeputySpecification,
      GetDocumentChargeSheetFinder(DocumentKind)
    )
  );

end;

procedure TDocumentChargeSheetsServiceRegistry.RegisterStandardDocumentChargeSheetRemovingService(
  DocumentKind: TDocumentClass
);
begin

  RegisterDocumentChargeSheetRemovingService(
    DocumentKind,
    TStandardDocumentChargeSheetRemovingService.Create(
      TDocumentChargeSheetsServiceRegistry.Instance.GetDocumentChargeSheetDirectory(DocumentKind)
    )
  );

end;

procedure TDocumentChargeSheetsServiceRegistry.RegisterAllStandardDocumentChargeSheetsServices(
  DocumentKind: TDocumentClass);
begin

  RegisterAllStandardDocumentChargeSheetPerformingServices(DocumentKind);
  RegisterStandardDocumentChargeSheetControlService(DocumentKind);

end;

procedure TDocumentChargeSheetsServiceRegistry.
  RegisterAllStandardDocumentChargeSheetPerformingServices(DocumentKind: TDocumentClass);
begin

  RegisterStandardDocumentChargeSheetOverlappingPerformingService(DocumentKind, TDocumentPerformingSheet);
  RegisterStandardDocumentChargeSheetOrdinaryPerformingService(DocumentKind, TDocumentAcquaitanceSheet);

end;

end.
