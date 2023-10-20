{ refactor:
  получить информацию о том, какие компоненты
  должны быть инстанцированы для функционирования
  приложения из специального файла конфигурации.
  Пока инстанцирование компонентов жестко определено
  в коде, но изолировано в одном месте, так что
  это не должно доставлять проблем, но для
  большей гибкости не помешало всё таки вынести
  логику определения конфигурации приложения
  во внешнюю среду }

{
  refactor:
  добавить метод конфигурации реестра спецификаций и
  предметных служб для избежания
  дублирования экземпляров спецификаций и служб
}

{
  refactor:
  разбить на несколько конфигураторов.
  Конфигуратор прикладных служб,                                      
  конфигуратор репозиториев и т.д.
}
unit ApplicationConfigurator;

interface

uses

  ConfigurationData,
  DomainConfigurator,
  ApplicationRepositoryRegistryConfigurator,
  PresentationServiceRegistryConfigurator,
  ExternalServiceRegistryConfigurator,
  DocumentBusinessProcessServiceRegistryConfigurator,
  SystemServiceRegistryConfigurator,
  DTODomainMapperRegistryConfigurator,
  DTODomainMapperRegistry,
  SysUtils,
  Classes;

type

  TApplicationConfigurator = class

    private

      FRepositoryRegistryConfigurator:
        TApplicationRepositoryRegistryConfigurator;
        
      FDomainConfigurator: TDomainConfigurator;

      FDocumentBusinessProcessServiceRegistryConfigurator:
        TDocumentBusinessProcessServiceRegistryConfigurator;

      FPresentationServiceRegistryConfigurator:
        TPresentationServiceRegistryConfigurator;

      FExternalServiceRegistryConfigurator:
        TExternalServiceRegistryConfigurator;

      FSystemServiceRegistryConfigurator:
        TSystemServiceRegistryConfigurator;

      FDTODomainMapperRegistryConfigurator:
        IDTODomainMapperRegistryConfigurator;
        
    protected

      procedure ConfigureRepositoryRegistry(
        ConfigurationData: TConfigurationData
      );

      procedure ConfigureDtoMapperRegistry(
        ConfigurationData: TConfigurationData
      );

      procedure ConfigureDomain(ConfigurationData: TConfigurationData);

      procedure ConfigureAccountingServiceRegistry(
        ConfigurationData: TConfigurationData
      );

      procedure ConfigureManagementServiceRegistry(
        ConfigurationData: TConfigurationData
      );

      procedure ConfigureStatisticsServiceRegistry(
        ConfigureData: TConfigurationData
      );

      procedure ConfigureReportingServiceRegistry(
        ConfigurationData: TConfigurationData
      );

      procedure ConfigureExternalServiceRegistry(
        ConfigurationData: TConfigurationData
      );

      procedure ConfigurePresentationServiceRegistry(
        ConfigurationData: TConfigurationData
      );

      procedure ConfigureDocumentBusinessProcessServiceRegistry(
        ConfigurationData: TConfigurationData
      );

      procedure ConfigureSystemServiceRegistry(
        ConfigurationData: TConfigurationData
      );

      procedure ConfigureNotificationRegistry(
        ConfigurationData: TConfigurationData
      );

      procedure LoadWorkingEmployeeData(
        ConfigurationData: TConfigurationData
      );

    public

      destructor Destroy; override;
      
      constructor Create;

      procedure Configure(ConfigurationData: TConfigurationData); 
      
  end;

implementation

uses

  ZConnection,
  RepositoryRegistryUnit,
  StatisticsServiceRegistry,
  DocumentKinds,
  ManagementServiceRegistry,
  AccountingServiceRegistry,
  ApplicationServiceRegistries,
  BasedOnDatabaseDocumentViewingAccountingService,
  QueryExecutor,
  ZQueryExecutor,
  BasedOnDatabaseIncomingDocumentViewingAccountingService,
  DocumentBusinessProcessServiceRegistry,
  ServiceNote,
  IncomingServiceNote,
  InternalServiceNote,
  PersonnelOrder,
  IncomingInternalDocument,
  IncomingInternalServiceNote,
  ExternalServiceRegistry,
  StandardEmployeeDepartmentManagementService,
  PresentationServiceRegistry,
  ReportingServiceRegistry,
  DocumentApprovingListCreatingAppService,
  NotPerformedDocumentsReportDataService,
  BasedOnPostgresNotPerformedIncomingServiceNotesReportDataService,
  StandardDocumentApprovingListCreatingAppService,
  DocumentApprovingServiceRegistry,
  StandardIncomingDocumentApprovingListCreatingAppService,
  WorkingEmployeeUnit,
  DBWorkingEmployeeUnit,
  ZeosPostgresWorkingEmployeeUnit,
  SystemServiceRegistry,
  EmployeeDocumentWorkStatisticsPostgresService,
  NumericDocumentKindResolver,
  DocumentFlowEmployeeInfoDTOMapper,
  EmployeeOutcomingServiceNoteChargesWorkStatisticsPostgresService,
  EmployeeIncomingServiceNoteChargesWorkStatisticsPostgresService,
  DocumentFlowAuthorizationService,
  BasedOnDatabaseDocumentFlowAuthorizationService,
  BasedOnZeosDocumentFlowAuthorizationService,
  StandardDocumentApprovingSheetDataCreatingService,
  StandardDocumentApprovingSheetDataCreatingAppService,
  DocumentChargesInfoDTODomainMapper,
  DocumentChargeSheetsInfoDTODomainMapper,
  DocumentApprovingSheetDataDtoMapper,
  DocumentDTOMapper,
  DocumentApprovingsInfoDTOMapper,
  DocumentNumerationServiceRegistry,
  DocumentsDomainRegistries,
  Role,
  UserNotificationProfileService,
  BasedOnDatabaseUserNotificationProfileService,
  StandardUserNotificationProfileAccessRightsService,
  DocumentViewingAccountingService,
  NotificationRegistry,
  BasedOnDBApplicationVersionInfoService,
  PropertiesIniFileUnit,
  AuxSystemFunctionsUnit;

{ TApplicationConfigurator }

procedure TApplicationConfigurator.Configure(ConfigurationData: TConfigurationData);
var
    PresentationServiceRegistryConfigData: TPresentationServiceRegistryConfigurationData;
    BusinessProcessServiceRegistryConfigData: TDocumentBusinessProcessServiceRegistryConfigurationData;

    DTODomainMapperRegistry: IDTODomainMapperRegistry;
    MapperRegistryConfigData: TDTODomainMapperRegistryConfigurationData;
begin

  LoadWorkingEmployeeData(ConfigurationData);

  ConfigureRepositoryRegistry(ConfigurationData);
  ConfigureDomain(ConfigurationData);
  ConfigureAccountingServiceRegistry(ConfigurationData);

  TDTODomainMapperRegistry.Instance :=
    TDTODomainMapperRegistry.Create(
      TDocumentsDomainRegistries.ServiceRegistry.ChargeServiceRegistry.GetDocumentChargeKindsControlService
    );

  MapperRegistryConfigData.RepositoryRegistry := TRepositoryRegistry.Current;
  MapperRegistryConfigData.ApplicationServices := TApplicationServiceRegistries.Current;

  FDTODomainMapperRegistryConfigurator.DoCommonConfiguration(
    TDTODomainMapperRegistry.Instance,
    MapperRegistryConfigData
  );

  PresentationServiceRegistryConfigData.DatabaseConnection :=
    ConfigurationData.DatabaseConnection;
    
  FPresentationServiceRegistryConfigurator
    .DoCommonPresentationServiceRegistryConfiguration(
      TApplicationServiceRegistries.Current.GetPresentationServiceRegistry,
      PresentationServiceRegistryConfigData
    );

  ConfigureDtoMapperRegistry(ConfigurationData);

  with BusinessProcessServiceRegistryConfigData do begin

    RepositoryRegistry := TRepositoryRegistry.Current;
    PresentationServiceRegistry := TApplicationServiceRegistries.Current.GetPresentationServiceRegistry;
    
  end;

  FDocumentBusinessProcessServiceRegistryConfigurator
    .DoCommonBusinessProcessServiceRegistryConfiguration(
      TApplicationServiceRegistries.Current.GetDocumentBusinessProcessServiceRegistry,
      BusinessProcessServiceRegistryConfigData
    );

  ConfigurePresentationServiceRegistry(ConfigurationData);
  ConfigureManagementServiceRegistry(ConfigurationData);
  ConfigureExternalServiceRegistry(ConfigurationData);
  ConfigureStatisticsServiceRegistry(ConfigurationData);
  ConfigureDocumentBusinessProcessServiceRegistry(ConfigurationData);
  ConfigureSystemServiceRegistry(ConfigurationData);
  ConfigureReportingServiceRegistry(ConfigurationData);
  ConfigureNotificationRegistry(ConfigurationData);

end;

procedure TApplicationConfigurator.ConfigureAccountingServiceRegistry(
  ConfigurationData: TConfigurationData
);
var AccountingServiceRegistry: TAccountingServiceRegistry;
    DatabaseConnection: TComponent;
    ZConnection: TZConnection;

    QueryExecutor: IQueryExecutor;

    LookedDocumentsDbSchema: TLookedDocumentsDbSchema;
    IncomingLookedDocumentsDbSchema: TIncomingLookedDocumentsDbSchema;

    OutcomingDocumentViewingAccountingService: IDocumentViewingAccountingService;
begin

  { refactor: extract to separate configurator }
  
  DatabaseConnection := ConfigurationData.DatabaseConnection;
  ZConnection := DatabaseConnection as TZConnection;

  AccountingServiceRegistry :=
    TApplicationServiceRegistries.Current.GetAccountingServiceRegistry;

  LookedDocumentsDbSchema.TableName := 'doc.looked_service_notes';
  LookedDocumentsDbSchema.IdColumnName := 'id';
  LookedDocumentsDbSchema.DocumentIdColumnName := 'document_id';
  LookedDocumentsDbSchema.EmployeeIdColumnName := 'looked_employee_id';
  LookedDocumentsDbSchema.ViewDateColumnName := 'look_date';

  IncomingLookedDocumentsDbSchema
    .LookedDocumentsDbSchema := LookedDocumentsDbSchema;

  IncomingLookedDocumentsDbSchema.IncomingDocumentTableName := 'doc.service_note_receivers';
  IncomingLookedDocumentsDbSchema.OutcomingDocumentIdColumnName := 'document_id';
  IncomingLookedDocumentsDbSchema.IncomingDocumentIdColumnName := 'id';

  QueryExecutor := TZQueryExecutor.Create(ZConnection);

  OutcomingDocumentViewingAccountingService :=
    TBasedOnDatabaseDocumentViewingAccountingService.Create(
      LookedDocumentsDbSchema,
      QueryExecutor
    );

  AccountingServiceRegistry.RegisterDocumentViewingAccountingService(
    TOutcomingServiceNoteKind,
    OutcomingDocumentViewingAccountingService
  );

  AccountingServiceRegistry.RegisterDocumentViewingAccountingService(
    TApproveableServiceNoteKind,
    OutcomingDocumentViewingAccountingService
  );
  
  AccountingServiceRegistry.RegisterDocumentViewingAccountingService(
    TIncomingServiceNoteKind,
    TBasedOnDatabaseIncomingDocumentViewingAccountingService.Create(
      IncomingLookedDocumentsDbSchema,
      QueryExecutor
    )
  );

  LookedDocumentsDbSchema.TableName := 'doc.looked_personnel_orders';
  LookedDocumentsDbSchema.IdColumnName := 'id';
  LookedDocumentsDbSchema.DocumentIdColumnName := 'document_id';
  LookedDocumentsDbSchema.EmployeeIdColumnName := 'looked_employee_id';
  LookedDocumentsDbSchema.ViewDateColumnName := 'look_date';

  AccountingServiceRegistry.RegisterDocumentViewingAccountingService(
    TPersonnelOrderKind,
    TBasedOnDatabaseDocumentViewingAccountingService.Create(
      LookedDocumentsDbSchema,
      QueryExecutor
    )
  );
  
end;

procedure TApplicationConfigurator.ConfigureDocumentBusinessProcessServiceRegistry(
  ConfigurationData: TConfigurationData
);
var

  DocumentBusinessProcessServiceRegistry:
    TDocumentBusinessProcessServiceRegistry;

  DocumentBusinessProcessServiceRegistryConfigurationData:
    TDocumentBusinessProcessServiceRegistryConfigurationData;
begin

  DocumentBusinessProcessServiceRegistry :=
    TApplicationServiceRegistries
      .Current
        .GetDocumentBusinessProcessServiceRegistry;

   with DocumentBusinessProcessServiceRegistryConfigurationData do begin

    DocumentClass := TServiceNote;
    IncomingDocumentClass := TIncomingServiceNote;

    RepositoryRegistry := TRepositoryRegistry.Current;
    
    PresentationServiceRegistry :=
      TApplicationServiceRegistries.Current.GetPresentationServiceRegistry;

    ExternalServiceRegistry :=
      TApplicationServiceRegistries.Current.GetExternalServiceRegistry;

  end;

  FDocumentBusinessProcessServiceRegistryConfigurator
    .ConfigureDocumentBusinessProcessServiceRegistry(
      DocumentBusinessProcessServiceRegistry,
      DocumentBusinessProcessServiceRegistryConfigurationData
    );

  with DocumentBusinessProcessServiceRegistryConfigurationData do begin

    DocumentClass := TPersonnelOrder;
    IncomingDocumentClass := nil;

  end;

  FDocumentBusinessProcessServiceRegistryConfigurator
    .ConfigureDocumentBusinessProcessServiceRegistry(
      DocumentBusinessProcessServiceRegistry,
      DocumentBusinessProcessServiceRegistryConfigurationData
    );
    
end;


procedure TApplicationConfigurator.ConfigureDomain(
  ConfigurationData: TConfigurationData
);
var
  DomainConfigurationData: TDomainConfigurationData;
begin

  DomainConfigurationData.DatabaseConnection :=
    ConfigurationData.DatabaseConnection;
    
  FDomainConfigurator.ConfigureDomain(DomainConfigurationData);
  
end;

procedure TApplicationConfigurator
  .ConfigureDtoMapperRegistry(ConfigurationData: TConfigurationData);
var
    MapperRegistryConfigData: TDTODomainMapperRegistryConfigurationData;
begin

  MapperRegistryConfigData.RepositoryRegistry := TRepositoryRegistry.Current;
  MapperRegistryConfigData.ApplicationServices := TApplicationServiceRegistries.Current;

  FDTODomainMapperRegistryConfigurator.Configure(TDTODomainMapperRegistry.Instance, MapperRegistryConfigData);

end;

procedure TApplicationConfigurator.ConfigureExternalServiceRegistry(
  ConfigurationData: TConfigurationData);

var
    ExternalServiceRegistry: TExternalServiceRegistry;
    ExternalServiceRegistryConfigurationData: TExternalServiceRegistryConfigurationData;
begin

  ExternalServiceRegistry :=
    TApplicationServiceRegistries.Current.GetExternalServiceRegistry;

  with ExternalServiceRegistryConfigurationData do begin

    DatabaseConnection := ConfigurationData.DatabaseConnection;

    DocumentKind := TOutcomingServiceNoteKind;
    IncomingDocumentKind := TIncomingServiceNoteKind;

    RepositoryRegistry := TRepositoryRegistry.Current;

    ManagementServiceRegistry := TApplicationServiceRegistries.Current.GetManagementServiceRegistry;
    PresentationServiceRegistry := TApplicationServiceRegistries.Current.GetPresentationServiceRegistry;
    
  end;

  FExternalServiceRegistryConfigurator.ConfigureExternalServiceRegistry(
    ExternalServiceRegistry,
    ExternalServiceRegistryConfigurationData
  );

  with ExternalServiceRegistryConfigurationData do begin

    DocumentKind := TPersonnelOrderKind;
    IncomingDocumentKind := nil;

  end;

  FExternalServiceRegistryConfigurator.ConfigureExternalServiceRegistry(
    ExternalServiceRegistry,
    ExternalServiceRegistryConfigurationData
  );
  
end;

procedure TApplicationConfigurator.ConfigureManagementServiceRegistry(
  ConfigurationData: TConfigurationData
);
var
    DatabaseConnection: TComponent;
    ManagementServiceRegistry: TManagementServiceRegistry;
    UserNotificationProfileDbSchema: TUserNotificationProfileDbSchema;
begin

  DatabaseConnection := ConfigurationData.DatabaseConnection;

  ManagementServiceRegistry :=
    TApplicationServiceRegistries.Current.GetManagementServiceRegistry;

  ManagementServiceRegistry.RegisterEmployeeDepartmentManagementService(
    TStandardEmployeeDepartmentManagementService.Create(
      TRepositoryRegistry.Current.GetSessionManager,
      TRepositoryRegistry.Current.GetDepartmentRepository,
      TRepositoryRegistry.Current.GetEmployeeRepository
    )
  );

  UserNotificationProfileDbSchema := TUserNotificationProfileDbSchema.Create;

  UserNotificationProfileDbSchema.ProfileTableName := 'doc.employees';
  UserNotificationProfileDbSchema.UsersForWhichPermissibleReceivingNotificationsToOthersTableName :=
    'doc.users_for_which_permissible_receiving_notification_to_others';

  UserNotificationProfileDbSchema.ProfileTableUserIdColumnName := 'id';
  UserNotificationProfileDbSchema.ProfileTableReceivingNotificationsEnabledColumnName :=
    'receiving_notifications_enabled';

  UserNotificationProfileDbSchema.UserIdForWhichReceivingPermissibleColumnName :=
    'user_id_for_which_receiving_permissible';

  UserNotificationProfileDbSchema.ForOtherUserReceivingUserIdColumnName :=
    'for_other_receiving_user_id';

  ManagementServiceRegistry.RegisterUserNotificationProfileService(
    TBasedOnDatabaseUserNotificationProfileService.Create(
      UserNotificationProfileDbSchema,
      TZQueryExecutor.Create(
        TZConnection(ConfigurationData.DatabaseConnection)
      ),
      TRepositoryRegistry.Current.GetSessionManager,
      TStandardUserNotificationProfileAccessRightsService.Create(
        TRoleMemento.GetLeadershipRoles,
        TRepositoryRegistry.Current.GetEmployeeRepository
      ),
      TRepositoryRegistry.Current.GetEmployeeRepository,
      TApplicationServiceRegistries.Current.GetPresentationServiceRegistry.GetEmployeeSetReadService
    )
  );

end;

procedure TApplicationConfigurator.ConfigureNotificationRegistry(
  ConfigurationData: TConfigurationData);
var
  NotificationRegistry: TNotificationServiceRegistry;
  DatabaseConnection: TComponent;
  ZConnection: TZConnection;

  QueryExecutor: IQueryExecutor;
  IniFile: TPropertiesIniFile;
begin

  DatabaseConnection := ConfigurationData.DatabaseConnection;
  ZConnection := DatabaseConnection as TZConnection;

  QueryExecutor := TZQueryExecutor.Create(ZConnection);

  IniFile :=
    TPropertiesIniFile.Create(
      GetAppLocalDataFolderPath('umz_doc', CreateFolderIfNotExists)+ PathDelim + 'AppVersion.ini',
      True
    );

  NotificationRegistry :=
    TApplicationServiceRegistries.Current.GetNotificationRegistry;

  NotificationRegistry.
    RegisterApplicationVersionInfoService(
      TBasedOnDBApplicationVersionInfoService.Create(
        QueryExecutor,
        IniFile
      )
    );

end;

procedure TApplicationConfigurator.ConfigurePresentationServiceRegistry(
  ConfigurationData: TConfigurationData
);
var
    PresentationServiceRegistry: TPresentationServiceRegistry;
    PresentationServiceRegistryConfigurationData: TPresentationServiceRegistryConfigurationData;
begin

  PresentationServiceRegistry :=
    TApplicationServiceRegistries.Current.GetPresentationServiceRegistry;
               
  with PresentationServiceRegistryConfigurationData do begin

    DatabaseConnection := ConfigurationData.DatabaseConnection;
    DocumentKind := nil;
    OutcomingDocumentKind := TOutcomingServiceNoteKind;
    IncomingDocumentKind := TIncomingServiceNoteKind;
    ApproveableDocumentKind := TApproveableServiceNoteKind;
    OutcomingInternalDocumentKind := TOutcomingInternalServiceNoteKind;
    IncomingInternalDocumentKind := TIncomingInternalServiceNoteKind;
    RepositoryRegistry := TRepositoryRegistry.Current;

  end;

  FPresentationServiceRegistryConfigurator
    .ConfigurePresentationServiceRegistry(
      PresentationServiceRegistry,
      PresentationServiceRegistryConfigurationData
    );

  with PresentationServiceRegistryConfigurationData do begin

    DocumentKind := TPersonnelOrderKind;
    OutcomingDocumentKind := nil;
    IncomingDocumentKind := nil;
    ApproveableDocumentKind := nil;
    OutcomingInternalDocumentKind := nil;
    IncomingInternalDocumentKind := nil;

  end;

  FPresentationServiceRegistryConfigurator
    .ConfigurePresentationServiceRegistry(
      PresentationServiceRegistry,
      PresentationServiceRegistryConfigurationData
    );

end;    

procedure TApplicationConfigurator.ConfigureReportingServiceRegistry(
  ConfigurationData: TConfigurationData
);
var
    DatabaseConnection: TComponent;
    
    ReportingServiceRegistry: TReportingServiceRegistry;
    ZConnection: TZConnection;

    DocumentApprovingListCreatingAppService:
      IDocumentApprovingListCreatingAppService;

    QueryExecutor: IQueryExecutor;
begin

  DatabaseConnection := ConfigurationData.DatabaseConnection;

  ZConnection := DatabaseConnection as TZConnection;

  QueryExecutor := TZQueryExecutor.Create(ZConnection);

  ReportingServiceRegistry :=
    TApplicationServiceRegistries.Current.GetReportingServiceRegistry;

  ReportingServiceRegistry.RegisterNotPerformedDocumentsReportDataService(
    TBasedOnPostgresNotPerformedIncomingServiceNotesReportDataService.Create(
      TZQueryExecutor(QueryExecutor.Self)
    )
  );

  DocumentApprovingListCreatingAppService :=
    TStandardDocumentApprovingListCreatingAppService.Create(
      TDocumentApprovingServiceRegistry.Instance.GetDocumentApprovingListCreatingService(
        TServiceNote
      ),
      TDTODomainMapperRegistry.Instance.GetDocumentFlowEmployeeInfoDTOMapper
    );
  
  ReportingServiceRegistry.RegisterDocumentApprovingListCreatingAppService(
    TOutcomingServiceNoteKind,
    DocumentApprovingListCreatingAppService
  );

  ReportingServiceRegistry.RegisterDocumentApprovingListCreatingAppService(
    TIncomingServiceNoteKind,
    TStandardIncomingDocumentApprovingListCreatingAppService.Create(
      DocumentApprovingListCreatingAppService,
      TRepositoryRegistry.Current.GetDocumentRepositoryRegistry.GetIncomingDocumentRepository(
        TIncomingServiceNote
      )
    )
  );

  ReportingServiceRegistry.RegisterDocumentApprovingSheetDataCreatingAppService(
    TPersonnelOrderKind,
    TStandardDocumentApprovingSheetDataCreatingAppService.Create(
      TDocumentApprovingServiceRegistry.Instance.GetDocumentApprovingSheetDataCreatingService(TPersonnelOrder),
      TDTODomainMapperRegistry.Instance.GetApprovingSheetDataDtoMapper(TPersonnelOrderKind)
    )
  );

end;

procedure TApplicationConfigurator.ConfigureRepositoryRegistry(
  ConfigurationData: TConfigurationData
);
var ApplicationRepositoryRegistryConfigurationData:
      TApplicationRepositoryRegistryConfigurationData;
begin

  ApplicationRepositoryRegistryConfigurationData.DatabaseConnection :=
    ConfigurationData.DatabaseConnection;

  FRepositoryRegistryConfigurator.ConfigureApplicationRepositoryRegistry(
    TRepositoryRegistry.Current,
    ApplicationRepositoryRegistryConfigurationData
  );
  
end;

procedure TApplicationConfigurator.ConfigureStatisticsServiceRegistry(
  ConfigureData: TConfigurationData
);
var DatabaseConnection: TComponent;
    ZConnection: TZConnection;
    StatisticsServieRegistry: TStatisticsServiceRegistry;
begin

  DatabaseConnection := ConfigureData.DatabaseConnection;

  ZConnection := DatabaseConnection as TZConnection;

  StatisticsServieRegistry :=
    TApplicationServiceRegistries.Current.GetStatisticsServiceRegistry;

  StatisticsServieRegistry.RegisterEmployeeDocumentWorkStatisticsService(
    TEmployeeDocumentWorkStatisticsPostgresService.Create(
      ZConnection,
      TRepositoryRegistry.Current.GetEmployeeRepository,
      TNumericDocumentKindResolver.Create
    )
  );

  StatisticsServieRegistry.RegisterEmployeeDocumentChargesWorkStatisticsService(
    TOutcomingServiceNoteKind,
    TEmployeeOutcomingServiceNoteChargesWorkStatisticsPostgresService.Create(
      ZConnection
    )
  );

  StatisticsServieRegistry.RegisterEmployeeDocumentChargesWorkStatisticsService(
    TIncomingServiceNoteKind,
    TEmployeeIncomingServiceNoteChargesWorkStatisticsPostgresService.Create(
      ZConnection
    )
  );
  
end;

procedure TApplicationConfigurator.ConfigureSystemServiceRegistry(
  ConfigurationData: TConfigurationData
);
var
  SystemServiceRegistry: TSystemServiceRegistry;
  SystemServiceRegistryConfigurationData: TSystemServiceRegistryConfigurationData;
begin

  SystemServiceRegistry :=
    TApplicationServiceRegistries.Current.GetSystemServiceRegistry;

  SystemServiceRegistryConfigurationData.DatabaseConnection :=
    ConfigurationData.DatabaseConnection;

  SystemServiceRegistryConfigurationData.RepositoryRegistry :=
    TRepositoryRegistry.Current;

  SystemServiceRegistryConfigurationData.PresentationServiceRegistry :=
    TApplicationServiceRegistries.Current.GetPresentationServiceRegistry;
    
  FSystemServiceRegistryConfigurator.ConfigureSystemServiceRegistry(
    SystemServiceRegistry, SystemServiceRegistryConfigurationData
  );
  
end;

constructor TApplicationConfigurator.Create;
begin

  inherited;

  FDocumentBusinessProcessServiceRegistryConfigurator :=
    TDocumentBusinessProcessServiceRegistryConfigurator.Create;

  FDomainConfigurator := TDomainConfigurator.Create;

  FRepositoryRegistryConfigurator :=
    TApplicationRepositoryRegistryConfigurator.Create;

  FPresentationServiceRegistryConfigurator :=
    TPresentationServiceRegistryConfigurator.Create;

  FExternalServiceRegistryConfigurator :=
    TExternalServiceRegistryConfigurator.Create;

  FSystemServiceRegistryConfigurator :=
    TSystemServiceRegistryConfigurator.Create;

  FDTODomainMapperRegistryConfigurator :=
    TDTODomainMapperRegistryConfigurator.Create;
    
end;

destructor TApplicationConfigurator.Destroy;
begin

  TApplicationServiceRegistries.Current.Free;
  
  FreeAndNil(FDomainConfigurator);
  FreeAndNil(FRepositoryRegistryConfigurator);
  FreeAndNil(FDocumentBusinessProcessServiceRegistryConfigurator);
  FreeAndNil(FPresentationServiceRegistryConfigurator);
  FreeAndNil(FExternalServiceRegistryConfigurator);
  FreeAndNil(FSystemServiceRegistryConfigurator);
  
  inherited;

end;

procedure TApplicationConfigurator.LoadWorkingEmployeeData(
  ConfigurationData: TConfigurationData
);
var CurrentWorkingEmployee: TDBWorkingEmployee;
begin

  CurrentWorkingEmployee :=
    TZeosPostgresWorkingEmployee.Create(
      ConfigurationData.DatabaseConnection
    );

  CurrentWorkingEmployee.LoadFromDatabase;

  TWorkingEmployee.Current := CurrentWorkingEmployee;

end;

end.
