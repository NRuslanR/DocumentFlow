unit PresentationServiceRegistry;

interface

uses

  _ApplicationServiceRegistry,
  DocumentKinds,
  DocumentCreatingDefaultInfoReadService,
  EmployeeSetReadService,
  EmployeeSetHolder,
  DocumentSignerSetReadService,
  DocumentChargePerformerSetReadService,
  DocumentInfoReadService,
  DocumentResponsibleSetReadService,
  DocumentApproverSetReadService,
  DocumentKindWorkCycleInfoAppService,
  NativeDocumentKindsReadService,
  GlobalDocumentKindsReadService,
  EmployeeDocumentSetReadService,
  DepartmentDocumentSetReadService,
  DepartmentSetReadService,
  DocumentChargeSheetPerformerSetReadService,
  PlantItemService,
  PersonnelOrderPresentationServiceRegistry,
  SDItemsService,
  SysUtils,
  Classes;

type

  TPresentationServiceRegistry = class (TApplicationServiceRegistry)

    private

      FDocumentInfoReadServiceRegistry: TApplicationServiceRegistry;
      FDocumentChargePerformerSetReadServiceRegistry: TApplicationServiceRegistry;
      FDocumentChargeSheetPerformerSetReadServiceRegistry: TApplicationServiceRegistry;
      FDocumentApproverSetReadServiceRegistry: TApplicationServiceRegistry;
      FEmployeeDocumentSetReadServiceRegistry: TApplicationServiceRegistry;
      FDepartmentDocumentSetReadServiceRegistry: TApplicationServiceRegistry;
      FDocumentResponsibleSetReadServiceRegistry: TApplicationServiceRegistry;
      FDocumentSignerSetReadServiceRegistry: TApplicationServiceRegistry;
      FDocumentKindWorkCycleInfoAppServiceRegistry: TApplicationServiceRegistry;

    public

      procedure AddServiceNames(ServiceNames: TStrings); override;

    private

      FPersonnelOrderPresentationServiceRegistry: TPersonnelOrderPresentationServiceRegistry;
      
    public
    
      procedure RegisterDocumentCreatingDefaultInfoReadService(
        DocumentKind: TDocumentKindClass;
        DocumentCreatingDefaultInfoReadService:
          IDocumentCreatingDefaultInfoReadService
      );

      function GetDocumentCreatingDefaultInfoReadService(
        DocumentKind: TDocumentKindClass
      ): IDocumentCreatingDefaultInfoReadService;


    public

      procedure RegisterEmployeeSetReadService(
        EmployeeSetReadService: IEmployeeSetReadService
      );

      function GetEmployeeSetReadService: IEmployeeSetReadService;

    public

      procedure RegisterDocumentSignerSetReadService(
        const DocumentKind: TDocumentKindClass;
        DocumentSignerSetReadService: IDocumentSignerSetReadService
      );

      function GetDocumentSignerSetReadService(
        const DocumentKind: TDocumentKindClass
      ): IDocumentSignerSetReadService;

    public

      procedure RegisterDocumentResponsibleSetReadService(
        const DocumentKind: TDocumentKindClass;
        DocumentResponsibleSetReadService: IDocumentResponsibleSetReadService
      );

      function GetDocumentResponsibleSetReadService(
        const DocumentKind: TDocumentKindClass
      ): IDocumentResponsibleSetReadService;

    public

      procedure RegisterDocumentApproverSetReadService(
        DocumentKind: TDocumentKindClass;
        DocumentApproverSetReadService: IDocumentApproverSetReadService
      );

      function GetDocumentApproverSetReadService(
        DocumentKind: TDocumentKindClass
      ): IDocumentApproverSetReadService;
        
    public

      procedure RegisterDocumentChargePerformerSetReadService(
        DocumentKind: TDocumentKindClass;
        DocumentChargePerformerSetReadService:
          IDocumentChargePerformerSetReadService
      );

      function GetDocumentChargePerformerSetReadService(
        DocumentKind: TDocumentKindClass
      ): IDocumentChargePerformerSetReadService;

    public

      procedure RegisterDocumentChargeSheetPerformerSetReadService(
        DocumentKind: TDocumentKindClass;
        DocumentChargeSheetPerformerSetReadService: IDocumentChargeSheetPerformerSetReadService
      );

      function GetDocumentChargeSheetPerformerSetReadService(
        DocumentKind: TDocumentKindClass
      ): IDocumentChargeSheetPerformerSetReadService;
      
    public

      procedure RegisterEmployeeDocumentSetReadService(
        DocumentKind: TDocumentKindClass;
        EmployeeDocumentSetReadService: IEmployeeDocumentSetReadService
      );

      function GetEmployeeDocumentSetReadService(
        DocumentKind: TDocumentKindClass
      ): IEmployeeDocumentSetReadService;

    public

      procedure RegisterDepartmentDocumentSetReadService(
        DocumentKind: TDocumentKindClass;
        DepartmentDocumentSetReadService: IDepartmentDocumentSetReadService
      );

      function GetDepartmentDocumentSetReadService(
        DocumentKind: TDocumentKindClass
      ): IDepartmentDocumentSetReadService;
      
    public

      procedure RegisterDocumentInfoReadService(
        DocumentKind: TDocumentKindClass;
        DocumentInfoReadService: IDocumentInfoReadService
      );
      
      function GetDocumentInfoReadService(
        DocumentKind: TDocumentKindClass
      ): IDocumentInfoReadService;


    public

      procedure RegisterDocumentKindWorkCycleInfoAppService(

        DocumentKind: TDocumentKindClass;
        
        DocumentKindWorkCycleInfoAppService:
          IDocumentKindWorkCycleInfoAppService
      );

      function GetDocumentKindWorkCycleInfoAppService(
        DocumentKind: TDocumentKindClass
      ): IDocumentKindWorkCycleInfoAppService;

    public

      procedure RegisterGlobalDocumentKindsReadService(
        GlobalDocumentKindsReadService: IGlobalDocumentKindsReadService
      );

      function GetGlobalDocumentKindsReadService: IGlobalDocumentKindsReadService;

    public

      procedure RegisterNativeDocumentKindsReadService(
        NativeDocumentKindsReadService: INativeDocumentKindsReadService
      );

      function GetNativeDocumentKindsReadService: INativeDocumentKindsReadService;
      
    public

      procedure RegisterSDItemsService(SDItemsService: ISDItemsService);

      function GetSDItemsService: ISDItemsService;

    public

      { refactor: remove SDItemsService and it after DocumentFlowItemService implementation }
      
      procedure RegisterPlantItemService(PlantItemService: IPlantItemService);

      function GetPlantItemService: IPlantItemService;

    public

      procedure RegisterDepartmentSetReadService(
        DepartmentSetReadService: IDepartmentSetReadService
      );

      function GetDepartmentSetReadService: IDepartmentSetReadService;

    public

      function GetPersonnelOrderPresentationServiceRegistry: TPersonnelOrderPresentationServiceRegistry;
      
    public

      destructor Destroy; override;
      constructor Create; override;
      
  end;

implementation

uses

  ServiceNote,
  AuxDebugFunctionsUnit,
  IncomingServiceNote;
  
type

  TEmployeeSetReadServiceType = class

  end;

  TDocumentSignerSetReadServiceType = class
  
  end;

  TDocumentResponsibleSetReadServiceType = class
  
  end;

  TDocumentApproverSetReadServiceType = class
  
  end;

  TDocumentChargePerformerSetReadServiceType = class
  
  end;

  TDocumentKindSetReadServiceType = class

  end;

  TGlobalDocumentKindsReadServiceType = class

  end;

  TNativeDocumentKindsReadServiceType = class
  
  end;

  TSDItemsServiceType = class

  end;

  TPlantItemServiceType = class
  
  end;

  TDepartmentSetReadServiceType = class
  
  end;
  
{ TPresentationServiceRegistry }


function TPresentationServiceRegistry.
  GetDocumentChargePerformerSetReadService(
    DocumentKind: TDocumentKindClass
  ): IDocumentChargePerformerSetReadService;
begin

  Result :=
    IDocumentChargePerformerSetReadService(
      FDocumentChargePerformerSetReadServiceRegistry.GetApplicationService(DocumentKind)
    );

end;

function TPresentationServiceRegistry.GetDocumentChargeSheetPerformerSetReadService(
  DocumentKind: TDocumentKindClass): IDocumentChargeSheetPerformerSetReadService;
begin

  Result :=
    IDocumentChargeSheetPerformerSetReadService(
      FDocumentChargeSheetPerformerSetReadServiceRegistry.GetApplicationService(DocumentKind)
    );
    
end;

function TPresentationServiceRegistry.
  GetDocumentCreatingDefaultInfoReadService(
    DocumentKind: TDocumentKindClass
  ): IDocumentCreatingDefaultInfoReadService;
begin

  Result :=
    IDocumentCreatingDefaultInfoReadService(
      GetApplicationService(DocumentKind)
    );
    
end;

function TPresentationServiceRegistry.GetDocumentInfoReadService(
  DocumentKind: TDocumentKindClass
): IDocumentInfoReadService;
begin

  Result :=
    IDocumentInfoReadService(
      FDocumentInfoReadServiceRegistry.GetApplicationService(DocumentKind)
    );
    
end;

function TPresentationServiceRegistry.
  GetDocumentKindWorkCycleInfoAppService(DocumentKind: TDocumentKindClass): IDocumentKindWorkCycleInfoAppService;
begin

  Result :=
    IDocumentKindWorkCycleInfoAppService(
      FDocumentKindWorkCycleInfoAppServiceRegistry.GetApplicationService(
        DocumentKind
      )
    );
    
end;

function TPresentationServiceRegistry.
  GetDocumentResponsibleSetReadService(
    const DocumentKind: TDocumentKindClass
  ): IDocumentResponsibleSetReadService;
begin

  Result :=
    IDocumentResponsibleSetReadService(
      FDocumentResponsibleSetReadServiceRegistry.GetApplicationService(
        DocumentKind
      )
    );
    
end;

function TPresentationServiceRegistry.GetEmployeeDocumentSetReadService(
  DocumentKind: TDocumentKindClass
): IEmployeeDocumentSetReadService;
begin

  Result :=
    IEmployeeDocumentSetReadService(
      FEmployeeDocumentSetReadServiceRegistry.GetApplicationService(
        DocumentKind
      )
    );

end;

function TPresentationServiceRegistry.GetDocumentSignerSetReadService(
  const DocumentKind: TDocumentKindClass
): IDocumentSignerSetReadService;
begin

  Result :=
    IDocumentSignerSetReadService(
      FDocumentSignerSetReadServiceRegistry.GetApplicationService(
        DocumentKind
      )
    );

end;

function TPresentationServiceRegistry.GetEmployeeSetReadService: IEmployeeSetReadService;
begin

  Result :=
    IEmployeeSetReadService(
      GetApplicationService(TEmployeeSetReadServiceType)
    );
      
end;

function TPresentationServiceRegistry.
  GetGlobalDocumentKindsReadService: IGlobalDocumentKindsReadService;
begin

  Result :=
    IGlobalDocumentKindsReadService(
      GetApplicationService(TGlobalDocumentKindsReadServiceType)
    );
    
end;

function TPresentationServiceRegistry.
  GetNativeDocumentKindsReadService: INativeDocumentKindsReadService;
begin

  Result :=
    INativeDocumentKindsReadService(
      GetApplicationService(TNativeDocumentKindsReadServiceType)
    );
    
end;

function TPresentationServiceRegistry.
  GetPersonnelOrderPresentationServiceRegistry: TPersonnelOrderPresentationServiceRegistry;
begin

  Result := FPersonnelOrderPresentationServiceRegistry;

end;

function TPresentationServiceRegistry.GetPlantItemService: IPlantItemService;
begin

  Result :=
    IPlantItemService(
      GetApplicationService(TPlantItemServiceType)
    );
    
end;

function TPresentationServiceRegistry.GetSDItemsService: ISDItemsService;
begin

  Result :=
    ISDItemsService(
      GetApplicationService(TSDItemsServiceType)
    );
    
end;

procedure TPresentationServiceRegistry.RegisterDocumentChargePerformerSetReadService(
  DocumentKind: TDocumentKindClass;
  DocumentChargePerformerSetReadService: IDocumentChargePerformerSetReadService
);
begin

  FDocumentChargePerformerSetReadServiceRegistry.RegisterApplicationService(
    DocumentKind,
    DocumentChargePerformerSetReadService
  );

end;

procedure TPresentationServiceRegistry.RegisterDocumentChargeSheetPerformerSetReadService(
  DocumentKind: TDocumentKindClass;
  DocumentChargeSheetPerformerSetReadService: IDocumentChargeSheetPerformerSetReadService);
begin

  FDocumentChargeSheetPerformerSetReadServiceRegistry.RegisterApplicationService(
    DocumentKind,
    DocumentChargeSheetPerformerSetReadService
  );
  
end;

procedure TPresentationServiceRegistry.
  RegisterDocumentCreatingDefaultInfoReadService(
    DocumentKind: TDocumentKindClass;
    DocumentCreatingDefaultInfoReadService:
      IDocumentCreatingDefaultInfoReadService
  );
begin

  RegisterApplicationService(
    DocumentKind,
    DocumentCreatingDefaultInfoReadService
  );

end;

procedure TPresentationServiceRegistry.RegisterDocumentInfoReadService(
  DocumentKind: TDocumentKindClass;
  DocumentInfoReadService: IDocumentInfoReadService);
begin

  FDocumentInfoReadServiceRegistry.RegisterApplicationService(
    DocumentKind,
    DocumentInfoReadService
  );

end;

procedure TPresentationServiceRegistry.
  RegisterDocumentKindWorkCycleInfoAppService(
    DocumentKind: TDocumentKindClass;
    DocumentKindWorkCycleInfoAppService: IDocumentKindWorkCycleInfoAppService
  );
begin

  FDocumentKindWorkCycleInfoAppServiceRegistry.RegisterApplicationService(
    DocumentKind,
    DocumentKindWorkCycleInfoAppService
  );
  
end;

procedure TPresentationServiceRegistry.RegisterDocumentResponsibleSetReadService(
  const DocumentKind: TDocumentKindClass;
  DocumentResponsibleSetReadService: IDocumentResponsibleSetReadService
);
begin

  FDocumentResponsibleSetReadServiceRegistry.RegisterApplicationService(
    DocumentKind,
    DocumentResponsibleSetReadService
  );

end;

procedure TPresentationServiceRegistry.RegisterEmployeeDocumentSetReadService(
  DocumentKind: TDocumentKindClass;
  EmployeeDocumentSetReadService: IEmployeeDocumentSetReadService
);
begin

  FEmployeeDocumentSetReadServiceRegistry.RegisterApplicationService(
    DocumentKind,
    EmployeeDocumentSetReadService
  );
  
end;

procedure TPresentationServiceRegistry.RegisterDocumentSignerSetReadService(
  const DocumentKind: TDocumentKindClass;
  DocumentSignerSetReadService: IDocumentSignerSetReadService
);
begin

  FDocumentSignerSetReadServiceRegistry.RegisterApplicationService(
    DocumentKind,
    DocumentSignerSetReadService
  );

end;

procedure TPresentationServiceRegistry.RegisterEmployeeSetReadService(
  EmployeeSetReadService: IEmployeeSetReadService);
begin

  RegisterApplicationService(
    TEmployeeSetReadServiceType,
    EmployeeSetReadService
  );

end;

procedure TPresentationServiceRegistry.RegisterGlobalDocumentKindsReadService(
  GlobalDocumentKindsReadService: IGlobalDocumentKindsReadService);
begin

  RegisterApplicationService(
    TGlobalDocumentKindsReadServiceType,
    GlobalDocumentKindsReadService
  );
  
end;

procedure TPresentationServiceRegistry.RegisterNativeDocumentKindsReadService(
  NativeDocumentKindsReadService: INativeDocumentKindsReadService);
begin

  RegisterApplicationService(
    TNativeDocumentKindsReadServiceType,
    NativeDocumentKindsReadService
  );
  
end;

procedure TPresentationServiceRegistry.RegisterPlantItemService(
  PlantItemService: IPlantItemService);
begin

  RegisterApplicationService(
    TPlantItemServiceType,
    PlantItemService
  );
  
end;

procedure TPresentationServiceRegistry.RegisterSDItemsService(
  SDItemsService: ISDItemsService
);
begin

  RegisterApplicationService(
    TSDItemsServiceType,
    SDItemsService
  );
  
end;

procedure TPresentationServiceRegistry.AddServiceNames(ServiceNames: TStrings);
begin

  inherited;

  FDocumentInfoReadServiceRegistry.AddServiceNames(ServiceNames);
  FDocumentChargePerformerSetReadServiceRegistry.AddServiceNames(ServiceNames);
  FEmployeeDocumentSetReadServiceRegistry.AddServiceNames(ServiceNames);
  FDocumentResponsibleSetReadServiceRegistry.AddServiceNames(ServiceNames);
  FDocumentSignerSetReadServiceRegistry.AddServiceNames(ServiceNames);
  FDepartmentDocumentSetReadServiceRegistry.AddServiceNames(ServiceNames);
  FDocumentKindWorkCycleInfoAppServiceRegistry.AddServiceNames(ServiceNames);

end;

constructor TPresentationServiceRegistry.Create;
begin

  inherited;

  FDocumentInfoReadServiceRegistry := TApplicationServiceRegistry.Create;
  FDocumentChargePerformerSetReadServiceRegistry := TApplicationServiceRegistry.Create;
  FDocumentChargeSheetPerformerSetReadServiceRegistry := TApplicationServiceRegistry.Create;
  FEmployeeDocumentSetReadServiceRegistry := TApplicationServiceRegistry.Create;
  FDocumentResponsibleSetReadServiceRegistry := TApplicationServiceRegistry.Create;
  FDocumentSignerSetReadServiceRegistry := TApplicationServiceRegistry.Create;
  FDepartmentDocumentSetReadServiceRegistry := TApplicationServiceRegistry.Create;
  FDocumentKindWorkCycleInfoAppServiceRegistry := TApplicationServiceRegistry.Create;
  FDocumentApproverSetReadServiceRegistry := TApplicationServiceRegistry.Create;
  
  FPersonnelOrderPresentationServiceRegistry :=
    TPersonnelOrderPresentationServiceRegistry.Create;

  FEmployeeDocumentSetReadServiceRegistry
    .UseSearchByNearestAncestorTypeIfTargetServiceNotFound := False;

  FDepartmentDocumentSetReadServiceRegistry
    .UseSearchByNearestAncestorTypeIfTargetServiceNotFound := False;

  FPersonnelOrderPresentationServiceRegistry
    .UseSearchByNearestAncestorTypeIfTargetServiceNotFound := False;
  
end;

destructor TPresentationServiceRegistry.Destroy;
begin

  FreeAndNil(FDocumentInfoReadServiceRegistry);
  FreeAndNil(FDocumentChargePerformerSetReadServiceRegistry);
  FreeAndNil(FDocumentChargeSheetPerformerSetReadServiceRegistry);
  FreeAndNil(FEmployeeDocumentSetReadServiceRegistry);
  FreeAndNil(FDocumentResponsibleSetReadServiceRegistry);
  FreeAndNil(FDocumentSignerSetReadServiceRegistry);
  FreeAndNil(FDepartmentDocumentSetReadServiceRegistry);
  FreeAndNil(FDocumentKindWorkCycleInfoAppServiceRegistry);
  FreeAndNil(FDocumentApproverSetReadServiceRegistry);
  
  inherited;
  
end;

function TPresentationServiceRegistry.GetDepartmentDocumentSetReadService(
  DocumentKind: TDocumentKindClass
): IDepartmentDocumentSetReadService;
begin

  Result :=
    IDepartmentDocumentSetReadService(
      FDepartmentDocumentSetReadServiceRegistry.GetApplicationService(
        DocumentKind
      )
    );
    
end;

function TPresentationServiceRegistry.GetDepartmentSetReadService: IDepartmentSetReadService;
begin

  Result :=
    IDepartmentSetReadService(
      GetApplicationService(TDepartmentSetReadServiceType)
    );
    
end;

function TPresentationServiceRegistry.
  GetDocumentApproverSetReadService(DocumentKind: TDocumentKindClass): IDocumentApproverSetReadService;
begin

  Result :=
    IDocumentApproverSetReadService(
      FDocumentApproverSetReadServiceRegistry.GetApplicationService(
          DocumentKind
      )
    );

end;

procedure TPresentationServiceRegistry.RegisterDepartmentDocumentSetReadService(
  DocumentKind: TDocumentKindClass;
  DepartmentDocumentSetReadService: IDepartmentDocumentSetReadService
);
begin

  FDepartmentDocumentSetReadServiceRegistry.RegisterApplicationService(
    DocumentKind,
    DepartmentDocumentSetReadService
  );
  
end;

procedure TPresentationServiceRegistry.RegisterDepartmentSetReadService(
  DepartmentSetReadService: IDepartmentSetReadService);
begin

  RegisterApplicationService(
    TDepartmentSetReadServiceType,
    DepartmentSetReadService
  );

end;

procedure TPresentationServiceRegistry.RegisterDocumentApproverSetReadService(
  DocumentKind: TDocumentKindClass;
  DocumentApproverSetReadService: IDocumentApproverSetReadService);
begin

  FDocumentApproverSetReadServiceRegistry.RegisterApplicationService(
    DocumentKind,
    DocumentApproverSetReadService
  );
  
end;

end.
