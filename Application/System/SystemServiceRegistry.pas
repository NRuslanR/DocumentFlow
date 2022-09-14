unit SystemServiceRegistry;

interface

uses

  _ApplicationServiceRegistry,
  DocumentFlowAuthorizationService,
  DocumentFlowAdministrationService,
  AdminDocumentSetReadService,
  DocumentStorageService,
  AdminDocumentStorageService,
  DocumentKinds,
  SysUtils,
  Classes;

type

  TSystemServiceRegistry = class (TApplicationServiceRegistry)

    private

      FAdminDocumentStorageServiceRegistry: TApplicationServiceRegistry;

    public

      procedure AddServiceNames(ServiceNames: TStrings); override;
      
      destructor Destroy; override;

      constructor Create; override;
      
    public

      procedure RegisterDocumentFlowAuthorizationService(
        DocumentFlowAuthorizationService: IDocumentFlowAuthorizationService
      );

      function GetDocumentFlowAuthorizationService: IDocumentFlowAuthorizationService;

    public

      procedure RegisterDocumentFlowAdministrationService(
        DocumentFlowAdministrationService: IDocumentFlowAdministrationService
      );

      function GetDocumentFlowAdministrationService: IDocumentFlowAdministrationService;

    public

      procedure RegisterAdminDocumentSetReadService(
        const ServiceDocumentKind: TDocumentKindClass;
        AdminDocumentSetReadService: IAdminDocumentSetReadService
      );

      function GetAdminDocumentSetReadService(
        const ServiceDocumentKind: TDocumentKindClass
      ): IAdminDocumentSetReadService;

    public

      procedure RegisterAdminDocumentStorageService(
        const ServiceDocumentKind: TDocumentKindClass;
        AdminDocumentStorageService: IAdminDocumentStorageService
      );

      function GetAdminDocumentStorageService(
        const ServiceDocumentKind: TDocumentKindClass
      ): IAdminDocumentStorageService;

  end;

implementation

type

  TDocumentFlowAuthorizationServiceType = class

  end;

  TDocumentFlowAdministrationServiceType = class

  end;
  
{ TSystemServiceRegistry }

procedure TSystemServiceRegistry.AddServiceNames(ServiceNames: TStrings);
begin

  inherited;

  FAdminDocumentStorageServiceRegistry.AddServiceNames(ServiceNames);
  
end;

constructor TSystemServiceRegistry.Create;
begin

  inherited;
  
  FAdminDocumentStorageServiceRegistry := TApplicationServiceRegistry.Create;
  
end;

destructor TSystemServiceRegistry.Destroy;
begin

  FreeAndNil(FAdminDocumentStorageServiceRegistry);

  inherited;

end;

function TSystemServiceRegistry.GetAdminDocumentSetReadService(
  const ServiceDocumentKind: TDocumentKindClass
): IAdminDocumentSetReadService;
begin

  Result :=
    IAdminDocumentSetReadService(
      GetApplicationService(ServiceDocumentKind)
    );
    
end;

function TSystemServiceRegistry.GetAdminDocumentStorageService(
  const ServiceDocumentKind: TDocumentKindClass): IAdminDocumentStorageService;
begin

  Result :=
    IAdminDocumentStorageService(
      FAdminDocumentStorageServiceRegistry.GetApplicationService(
        ServiceDocumentKind
      )
    );
    
end;

function TSystemServiceRegistry.
  GetDocumentFlowAdministrationService: IDocumentFlowAdministrationService;
begin

  Result :=
    IDocumentFlowAdministrationService(
      GetApplicationService(TDocumentFlowAdministrationServiceType)
    );
    
end;

function TSystemServiceRegistry.GetDocumentFlowAuthorizationService:
  IDocumentFlowAuthorizationService;
begin

  Result :=
    IDocumentFlowAuthorizationService(
      GetApplicationService(TDocumentFlowAuthorizationServiceType)
    );

end;

procedure TSystemServiceRegistry.RegisterAdminDocumentSetReadService(
  const ServiceDocumentKind: TDocumentKindClass;
  AdminDocumentSetReadService: IAdminDocumentSetReadService);
begin

  RegisterApplicationService(
    ServiceDocumentKind,
    AdminDocumentSetReadService
  );
  
end;

procedure TSystemServiceRegistry.RegisterAdminDocumentStorageService(
  const ServiceDocumentKind: TDocumentKindClass;
  AdminDocumentStorageService: IAdminDocumentStorageService);
begin

  FAdminDocumentStorageServiceRegistry.RegisterApplicationService(
    ServiceDocumentKind,
    AdminDocumentStorageService
  );
  
end;

procedure TSystemServiceRegistry.RegisterDocumentFlowAdministrationService(
  DocumentFlowAdministrationService: IDocumentFlowAdministrationService);
begin

  RegisterApplicationService(
    TDocumentFlowAdministrationServiceType,
    DocumentFlowAdministrationService
  );
  
end;

procedure TSystemServiceRegistry.RegisterDocumentFlowAuthorizationService(
  DocumentFlowAuthorizationService: IDocumentFlowAuthorizationService
);
begin

  RegisterApplicationService(
    TDocumentFlowAuthorizationServiceType,
    DocumentFlowAuthorizationService
  );

end;

end.
