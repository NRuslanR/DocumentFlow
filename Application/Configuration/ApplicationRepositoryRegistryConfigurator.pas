unit ApplicationRepositoryRegistryConfigurator;

interface

uses

  IRepositoryRegistryUnit,
  DocumentRepositoryRegistry,
  Document,
  DocumentChargeSheet,
  ServiceNote,
  IncomingServiceNote,
  InternalServiceNote,
  IncomingInternalServiceNote,
  DocumentFilesRepository,
  DocumentRepository,
  DocumentRelationsRepository,
  IncomingDocumentRepository,
  IncomingDocument,
  DocumentApprovingRepository,
  DocumentApprovingCycleResultRepository,
  DocumentChargeSheetRepository,
  QueryExecutor,
  SysUtils,
  Classes;

type

  TApplicationRepositoryRegistryConfigurationData = record

    DatabaseConnection: TComponent;
    
  end;

  TApplicationRepositoryRegistryConfigurator = class

    private

    public

      procedure ConfigureApplicationRepositoryRegistry(
        RepositoryRegistry: IRepositoryRegistry;
        const ConfigurationData: TApplicationRepositoryRegistryConfigurationData
      );

    public

      destructor Destroy; override;

      function CreateSessionManager(

        RepositoryRegistry: IRepositoryRegistry;
        const ConfigurationData: TApplicationRepositoryRegistryConfigurationData

      ): TApplicationRepositoryRegistryConfigurator;

      function ConfigureEmployeeRepositoryRegistry(

        RepositoryRegistry: IRepositoryRegistry;
        const ConfigurationData: TApplicationRepositoryRegistryConfigurationData

      ): TApplicationRepositoryRegistryConfigurator;

      function CreateDocumentRepositoryRegistry(
        RepositoryRegistry: IRepositoryRegistry
      ): TApplicationRepositoryRegistryConfigurator;


  end;
  
implementation

uses

  AuxDebugFunctionsUnit,
  ZConnection,
  PostgresTransactionUnit,
  ServiceNoteApprovingPostgresRepository,
  EmployeesWorkGroupPostgresRepository,
  StandardDocumentRepositoryRegistry,
  DocumentWorkCycleStagesPostgresRepository,
  AbstractDocumentRepositoriesFactoryRegistry,
  StandardDocumentWorkCycleRepository,
  DocumentKindPostgresRepository,
  DocumentResponsiblePostgresRepository,
  EmployeePostgresRepository,
  DepartmentPostgresRepository,
  RolePostgresRepository,
  DocumentRepositoryRegistryInitializer,
  PostgresDocumentRepositoriesFactoryRegistry,
  PersonnelOrderRepositoryRegistryInitializer,
  PersonnelOrderRepositoriesFactory,
  PersonnelOrderRepositoryRegistry,
  RepositoryRegistryUnit,
  StandardPersonnelOrderRepositoryRegistry,
  PersonnelOrder,
  ZQueryExecutor,
  PostgresTransaction;

{ TApplicationRepositoryRegistryConfigurator }

procedure TApplicationRepositoryRegistryConfigurator.ConfigureApplicationRepositoryRegistry(
  RepositoryRegistry: IRepositoryRegistry;
  const ConfigurationData: TApplicationRepositoryRegistryConfigurationData
);
var
    DocumentRepositoryRegistryInitializer: IDocumentRepositoryRegistryInitializer;
    PersonnelOrderRepositoryRegistryInitializer: IPersonnelOrderRepositoryRegistryInitializer;
    PersonnelOrderRepositoryRegistry: IPersonnelOrderRepositoryRegistry;
    QueryExecutor: IQueryExecutor;
begin

  CreateSessionManager(RepositoryRegistry, ConfigurationData);

  ConfigureEmployeeRepositoryRegistry(RepositoryRegistry, ConfigurationData);
  CreateDocumentRepositoryRegistry(RepositoryRegistry);

  QueryExecutor :=
    TZQueryExecutor.Create(TZConnection(ConfigurationData.DatabaseConnection));

  TAbstractDocumentRepositoriesFactoryRegistry.Instance :=
    TPostgresDocumentRepositoriesFactoryRegistry.Create;
    
  DocumentRepositoryRegistryInitializer :=
    TDocumentRepositoryRegistryInitializer.Create(
      TAbstractDocumentRepositoriesFactoryRegistry.Instance,
      QueryExecutor
    );

  DocumentRepositoryRegistryInitializer.InitializeDocumentRepositoryRegistry(
    RepositoryRegistry.GetDocumentRepositoryRegistry
  );

  PersonnelOrderRepositoryRegistryInitializer :=

    TPersonnelOrderRepositoryRegistryInitializer.Create(

      IPersonnelOrderRepositoriesFactory(

        TAbstractDocumentRepositoriesFactoryRegistry
          .Instance
            .GetDocumentRepositoriesFactory(
              TPersonnelOrder
            )
      ),

      QueryExecutor
    );

  PersonnelOrderRepositoryRegistry :=
    TStandardPersonnelOrderRepositoryRegistry.Create;

  PersonnelOrderRepositoryRegistryInitializer.InitializePersonnelOrderRepositoryRegistry(
    PersonnelOrderRepositoryRegistry
  );

  RepositoryRegistry.RegisterPersonnelOrderRepositoryRegistry(
    PersonnelOrderRepositoryRegistry
  );

end;

function TApplicationRepositoryRegistryConfigurator.ConfigureEmployeeRepositoryRegistry(
  RepositoryRegistry: IRepositoryRegistry;
  const ConfigurationData: TApplicationRepositoryRegistryConfigurationData
): TApplicationRepositoryRegistryConfigurator;
var
    QueryExecutor: IQueryExecutor;
begin

  QueryExecutor :=
    TZQueryExecutor.Create(TZConnection(ConfigurationData.DatabaseConnection));

  with RepositoryRegistry do begin
  
    RegisterEmployeeRepository(
      TEmployeePostgresRepository.Create(QueryExecutor)
    );

    RegisterDepartmentRepository(
      TDepartmentPostgresRepository.Create(QueryExecutor)
    );

    RegisterRoleRepository(
      TRolePostgresRepository.Create(QueryExecutor)
    );

    RegisterEmployeesWorkGroupRepository(
      TEmployeesWorkGroupPostgresRepository.Create(QueryExecutor)
    );

  end;

  Result := Self;

end;

function TApplicationRepositoryRegistryConfigurator.
  CreateDocumentRepositoryRegistry(
    RepositoryRegistry: IRepositoryRegistry
  ): TApplicationRepositoryRegistryConfigurator;
begin

  RepositoryRegistry.RegisterDocumentRepositoryRegistry(
    TStandardDocumentRepositoryRegistry.Create
  );
  
  Result := Self;

end;

function TApplicationRepositoryRegistryConfigurator.CreateSessionManager(
  RepositoryRegistry: IRepositoryRegistry;
  const ConfigurationData: TApplicationRepositoryRegistryConfigurationData
): TApplicationRepositoryRegistryConfigurator;
var
    QueryExecutor: IQueryExecutor;
begin

  QueryExecutor :=
    TZQueryExecutor.Create(TZConnection(ConfigurationData.DatabaseConnection));
    
  RepositoryRegistry
    .RegisterSessionManager(
      TPostgresTransaction.Create(QueryExecutor)
    );

  Result := Self;

end;

destructor TApplicationRepositoryRegistryConfigurator.Destroy;
begin

  TRepositoryRegistry.Current := nil;
  
  inherited;

end;

end.
