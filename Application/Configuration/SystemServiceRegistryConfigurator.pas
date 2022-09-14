unit SystemServiceRegistryConfigurator;

interface

uses

  PresentationServiceRegistry,
  SystemServiceRegistry,
  DocumentKinds,
  IRepositoryRegistryUnit,
  SysUtils,
  Classes;

type

  TSystemServiceRegistryConfigurationData = record

    DatabaseConnection: TComponent;
    RepositoryRegistry: IRepositoryRegistry;
    PresentationServiceRegistry: TPresentationServiceRegistry;

  end;
  
  TSystemServiceRegistryConfigurator = class

    private

      procedure RegisterAdminDocumentSetReadServices(
        const DocumentKinds: array of TDocumentKindClass;
        SystemServiceRegistry: TSystemServiceRegistry;
        ConfigurationData: TSystemServiceRegistryConfigurationData
      );

      procedure RegisterAdminDocumentStorageServices(
        const DocumentKinds: array of TDocumentKindClass;
        SystemServiceRegistry: TSystemServiceRegistry;
        ConfigurationData: TSystemServiceRegistryConfigurationData
      );
      
    public

      procedure ConfigureSystemServiceRegistry(
        SystemServiceRegistry: TSystemServiceRegistry;
        ConfigurationData: TSystemServiceRegistryConfigurationData
      );

  end;
  
implementation

uses

  DomainRegistries,
  DocumentFlowAuthorizationService,
  BasedOnDatabaseDocumentFlowAuthorizationService,
  BasedOnZeosDocumentFlowAuthorizationService,
  StandardDocumentFlowAdministrationService,
  StandardDocumentFlowAdminPrivilegeServicesFactories,
  AdminDocumentSetReadService,
  StandardAdminDocumentSetReadService,
  AdminDocumentStorageService,
  StandardAdminDocumentStorageService,
  NumericDocumentKindResolver,
  DocumentKindsMapper,
  DTODomainMapperRegistry,
  ZQueryExecutor,
  ZConnection;
  
{ TSystemServiceRegistryConfigurator }

procedure TSystemServiceRegistryConfigurator.ConfigureSystemServiceRegistry(
  SystemServiceRegistry: TSystemServiceRegistry;
  ConfigurationData: TSystemServiceRegistryConfigurationData
);
var
    DocumentFlowAuthorizationService: IDocumentFlowAuthorizationService;
    DocumentFlowAuthorizationServiceDbSchema: TDocumentFlowAuthorizationServiceDbSchema;
begin

  DocumentFlowAuthorizationServiceDbSchema :=
    TDocumentFlowAuthorizationServiceDbSchema.Create;

  DocumentFlowAuthorizationServiceDbSchema.
    EmployeeSystemRoleAssociationTableName := 'doc.employees_system_roles';

  DocumentFlowAuthorizationServiceDbSchema.EmployeeIdColumnName := 'employee_id';

  DocumentFlowAuthorizationServiceDbSchema.SystemRoleIdColumnName := 'system_role_id';

  DocumentFlowAuthorizationServiceDbSchema.
    EmployeeIdQueryParamName :=
      'p' + DocumentFlowAuthorizationServiceDbSchema.EmployeeIdColumnName;

  DocumentFlowAuthorizationServiceDbSchema.
    SystemRoleIdQueryParamName :=
      'p' + DocumentFlowAuthorizationServiceDbSchema.SystemRoleIdColumnName;

  DocumentFlowAuthorizationServiceDbSchema.
    EmployeeAuthorizationVerificatingQueryResultFieldName := 'result';

  DocumentFlowAuthorizationServiceDbSchema.SystemAdminViewRoleId := 1;
  DocumentFlowAuthorizationServiceDbSchema.SystemAdminEditRoleId := 2;

  DocumentFlowAuthorizationService :=
    TBasedOnZeosDocumentFlowAuthorizationService.Create(

      TZQueryExecutor.Create(
        TZConnection(ConfigurationData.DatabaseConnection)
      ),

      DocumentFlowAuthorizationServiceDbSchema,
      TZConnection(ConfigurationData.DatabaseConnection)
    );

  SystemServiceRegistry.RegisterDocumentFlowAuthorizationService(
    DocumentFlowAuthorizationService
  );

  SystemServiceRegistry.RegisterDocumentFlowAdministrationService(
    TStandardDocumentFlowAdministrationService.Create(
      DocumentFlowAuthorizationService,
      ConfigurationData.PresentationServiceRegistry.GetNativeDocumentKindsReadService,
      TStandardDocumentFlowAdminPrivilegeServicesFactories.Create(
        TNumericDocumentKindResolver.Create, { refactor }
        TZConnection(ConfigurationData.DatabaseConnection)
      )
    )
  );

  RegisterAdminDocumentSetReadServices(
    [
      TOutcomingServiceNoteKind,
      TIncomingServiceNoteKind,
      TApproveableServiceNoteKind,
      TPersonnelOrderKind
    ],
    SystemServiceRegistry,
    ConfigurationData
  );

  RegisterAdminDocumentStorageServices(
    [
      TOutcomingServiceNoteKind,
      TIncomingServiceNoteKind,
      TPersonnelOrderKind
    ],
    SystemServiceRegistry,
    ConfigurationData
  );
  
end;

procedure TSystemServiceRegistryConfigurator.RegisterAdminDocumentSetReadServices(
  const DocumentKinds: array of TDocumentKindClass;
  SystemServiceRegistry: TSystemServiceRegistry;
  ConfigurationData: TSystemServiceRegistryConfigurationData
);
var
    DocumentKind: TDocumentKindClass;
begin

  for DocumentKind in DocumentKinds do begin

    SystemServiceRegistry.RegisterAdminDocumentSetReadService(
      DocumentKind,

      TStandardAdminDocumentSetReadService.Create(
        SystemServiceRegistry.GetDocumentFlowAuthorizationService,

        ConfigurationData
          .PresentationServiceRegistry
            .GetDepartmentDocumentSetReadService(
              DocumentKind
            )
      )
    );

  end;

end;

procedure TSystemServiceRegistryConfigurator.RegisterAdminDocumentStorageServices(
  const DocumentKinds: array of TDocumentKindClass;
  SystemServiceRegistry: TSystemServiceRegistry;
  ConfigurationData: TSystemServiceRegistryConfigurationData
);
var
    DocumentKind: TDocumentKindClass;
begin

  for DocumentKind in DocumentKinds do begin
  
    SystemServiceRegistry.RegisterAdminDocumentStorageService(
      DocumentKind,
      
      TStandardAdminDocumentStorageService.Create(
      
        SystemServiceRegistry.GetDocumentFlowAuthorizationService,
        ConfigurationData.RepositoryRegistry.GetSessionManager,
        
        TDomainRegistries
          .DocumentsDomainRegistries
            .ServiceRegistry
              .StorageServiceRegistry
                .GetDocumentDirectory(
                  TDocumentKindsMapper.MapDocumentKindToDomainDocumentKind(
                    DocumentKind
                  )
                ),

        ConfigurationData.RepositoryRegistry.GetEmployeeRepository,
        TDomainRegistries.DocumentsDomainRegistries.ServiceRegistry.OperationServiceRegistry.GetDocumentCreatingService(
          TDocumentKindsMapper.MapDocumentKindToDomainDocumentKind(DocumentKind)
        ),
        ConfigurationData.PresentationServiceRegistry.GetDocumentInfoReadService(DocumentKind),
        
        TDomainRegistries
          .DocumentsDomainRegistries
            .ServiceRegistry
              .AccessRightsServiceRegistry
                .GetDocumentUsageEmployeeAccessRightsService(
                  TDocumentKindsMapper
                    .MapDocumentKindToDomainDocumentKind(DocumentKind)
                ),

        TDTODomainMapperRegistry.Instance.GetDocumentObjectsDTODomainMapper(DocumentKind),
        TDTODomainMapperRegistry.Instance.GetDocumentFullInfoDTOMapper(DocumentKind)
      )
    );
    
  end;

end;

end.
