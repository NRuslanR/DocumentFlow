unit ExternalServiceRegistryConfigurator;

interface

uses

  DocumentKindsMapper,
  ExternalServiceRegistry,
  ManagementServiceRegistry,
  PresentationServiceRegistry,
  IRepositoryRegistryUnit,
  DocumentKinds,
  SysUtils,
  Classes;

type

  TExternalServiceRegistryConfigurationData = record

    DatabaseConnection: TComponent;

    DocumentKind: TDocumentKindClass;
    IncomingDocumentKind: TIncomingDocumentKindClass;

    RepositoryRegistry: IRepositoryRegistry;

    ManagementServiceRegistry: TManagementServiceRegistry;
    PresentationServiceRegistry: TPresentationServiceRegistry;
    
  end;

  TExternalServiceRegistryConfigurator = class

    private

      procedure ConfigureDocumentFileServiceClient(
        ExternalServiceRegistry: TExternalServiceRegistry;
        ConfigurationData: TExternalServiceRegistryConfigurationData
      );

      procedure ConfigureDocumentChargeSheetCasesNotifier(
        ExternalServiceRegistry: TExternalServiceRegistry;
        ConfigurationData: TExternalServiceRegistryConfigurationData
      );

    private

      procedure ConfigureLoodsmanDocumentsUploadingServices(
        ExternalServiceRegistry: TExternalServiceRegistry;
        ConfigurationData: TExternalServiceRegistryConfigurationData
      );

      procedure ConfigureLoodsmanDocumentsUploadingServiceForDocumentKind(
        const DocumentKind: TDocumentKindClass;
        ExternalServiceRegistry: TExternalServiceRegistry;
        ConfigurationData: TExternalServiceRegistryConfigurationData
      );

    public

      procedure ConfigureExternalServiceRegistry(
        ExternalServiceRegistry: TExternalServiceRegistry;
        ConfigurationData: TExternalServiceRegistryConfigurationData
      );

  end;

implementation

uses

  DocumentChargeSheetCasesNotifier,
  AbstractDatabaseMessagingService,
  DocumentFileServiceClientUnit,
  UserNotificationProfileService,
  BasedOnDatabaseUserNotificationProfileService,
  QueryExecutor,
  LocalNetworkFileStorageServiceClientUnit,
  ZQueryExecutor,
  ZConnection,
  Document,
  IncomingDocument,
  StandardDocumentChargeSheetCasesNotifier,
  EmailDocumentChargeSheetNotifyingMessageBuilder2,
  EmailMessageSpecChars,
  StandardDocumentFullNameCompilationService,
  PostgresDatabaseMessagingService,
  DocumentsDomainRegistries,
  DTODomainMapperRegistry,
  Role,
  IDocumentFileServiceClientUnit,
  LoodsmanDocumentsUploadingAccessRightsService,
  LoodsmanDocumentsUploadingService,
  BasedOnDatabaseLoodsmanDocumentsUploadingAccessRightsService,
  BasedOnDatabaseLoodsmanDocumentsUploadingService,
  LoodsmanDocumentsUploadingQueueTableDef,
  LoodsmanDocumentsUploadingAccessRightsTableDef,
  LoodsmanDocumentUploadingStatusChangingEnsurer,
  StandardLoodsmanDocumentUploadingStatusChangingEnsurer,
  LoodsmanDocumentUploadingInfoMapper,
  StandardOriginalDocumentInfoReadService;

{ TExternalServiceRegistryConfigurator }

procedure TExternalServiceRegistryConfigurator.ConfigureExternalServiceRegistry(
  ExternalServiceRegistry: TExternalServiceRegistry;
  ConfigurationData: TExternalServiceRegistryConfigurationData
);
begin

  ConfigureDocumentFileServiceClient(ExternalServiceRegistry, ConfigurationData);
  ConfigureDocumentChargeSheetCasesNotifier(ExternalServiceRegistry, ConfigurationData);
  ConfigureLoodsmanDocumentsUploadingServices(ExternalServiceRegistry, ConfigurationData);
  
end;

procedure TExternalServiceRegistryConfigurator
  .ConfigureDocumentFileServiceClient(
    ExternalServiceRegistry: TExternalServiceRegistry;
    ConfigurationData: TExternalServiceRegistryConfigurationData
  );
var
    DocumentKindsMapper: IDocumentKindsMapper;
    DocumentFileServiceClient: IDocumentFileServiceClient;
begin

  DocumentKindsMapper := TDTODomainMapperRegistry.Instance.GetDocumentKindsMapper;
  
  DocumentFileServiceClient :=
    TDocumentFileServiceClient.Create(

      TDocumentsDomainRegistries
        .ServiceRegistry
          .StorageServiceRegistry
            .GetDocumentFileStorageService(
              DocumentKindsMapper.MapDocumentKindToDomainDocumentKind(
                ConfigurationData.DocumentKind
              )
            )
    );

  if Assigned(ConfigurationData.DocumentKind) then begin

    ExternalServiceRegistry.RegisterDocumentFileServiceClient(
      ConfigurationData.DocumentKind,
      DocumentFileServiceClient
    );

  end;

  if Assigned(ConfigurationData.IncomingDocumentKind) then begin

    ExternalServiceRegistry.RegisterDocumentFileServiceClient(
      ConfigurationData.IncomingDocumentKind,
      DocumentFileServiceClient
    );

  end;
  
end;

procedure TExternalServiceRegistryConfigurator
  .ConfigureDocumentChargeSheetCasesNotifier(
    ExternalServiceRegistry: TExternalServiceRegistry;
    ConfigurationData: TExternalServiceRegistryConfigurationData
  );
var
    DocumentKindsMapper: IDocumentKindsMapper;

    DocumentChargeSheetCasesNotifier: IDocumentChargeSheetCasesNotifier;
    DatabaseMessagingServiceSchemaData: TDatabaseMessagingServiceSchemaData;

    QueryExecutor: IQueryExecutor;
    RepositoryRegistry: IRepositoryRegistry;

    DocumentClass: TDocumentClass;
begin
  
  DocumentKindsMapper := TDTODomainMapperRegistry.Instance.GetDocumentKindsMapper;
  
  DocumentClass :=
    DocumentKindsMapper.MapDocumentKindToDomainDocumentKind(
      ConfigurationData.DocumentKind
    );

  RepositoryRegistry := ConfigurationData.RepositoryRegistry;

  DatabaseMessagingServiceSchemaData := TDatabaseMessagingServiceSchemaData.Create;

  DatabaseMessagingServiceSchemaData.MessageTableName := 'sys.sendemail_queue';

  DatabaseMessagingServiceSchemaData.MessageNameColumnName := 'mailsubject';
  DatabaseMessagingServiceSchemaData.MessageContentColumnName := 'mailbody';
  DatabaseMessagingServiceSchemaData.MessageReceiversColumnName := 'mailto';
  DatabaseMessagingServiceSchemaData.MessageAttachmentsColumnName := 'attachments';

  DatabaseMessagingServiceSchemaData.MessageNameQueryParamName :=
    'p' + DatabaseMessagingServiceSchemaData.MessageNameColumnName;

  DatabaseMessagingServiceSchemaData.MessageContentQueryParamName :=
    'p' + DatabaseMessagingServiceSchemaData.MessageContentColumnName;

  DatabaseMessagingServiceSchemaData.MessageReceiversQueryParamName :=
    'p' + DatabaseMessagingServiceSchemaData.MessageReceiversColumnName;

  DatabaseMessagingServiceSchemaData.MessageAttachmentsQueryParamName :=
    'p' + DatabaseMessagingServiceSchemaData.MessageAttachmentsColumnName;

  QueryExecutor :=
    TZQueryExecutor.Create(
      TZConnection(ConfigurationData.DatabaseConnection)
    );

  DocumentChargeSheetCasesNotifier :=
    TStandardDocumentChargeSheetCasesNotifier.Create(
      RepositoryRegistry.GetDocumentRepositoryRegistry.GetDocumentRepository(DocumentClass),
      RepositoryRegistry.GetDocumentRepositoryRegistry.GetDocumentFilesRepository(DocumentClass),
      RepositoryRegistry.GetDocumentRepositoryRegistry.GetDocumentResponsibleRepository,

      TEmailDocumentChargeSheetNotifyingMessageBuilder2.Create(
        TEmailMessageSpecChars.Create,
        TStandardDocumentFullNameCompilationService.Create,

        ExternalServiceRegistry.GetDocumentFileServiceClient(ConfigurationData.DocumentKind).GetFileStoragePath + PathDelim
      ),

      TPostgresDatabaseMessagingService.Create(
        DatabaseMessagingServiceSchemaData,
        QueryExecutor
      ),

      ConfigurationData.ManagementServiceRegistry.GetUserNotificationProfileService,

      RepositoryRegistry.GetEmployeeRepository
    );

  ExternalServiceRegistry.RegisterDocumentChargeSheetCasesNotifier(
    ConfigurationData.DocumentKind,
    DocumentChargeSheetCasesNotifier
  );

  if Assigned(ConfigurationData.IncomingDocumentKind) then begin

    ExternalServiceRegistry.RegisterDocumentChargeSheetCasesNotifier(
      ConfigurationData.IncomingDocumentKind,
      DocumentChargeSheetCasesNotifier
    );

  end;

end;

procedure TExternalServiceRegistryConfigurator.ConfigureLoodsmanDocumentsUploadingServices(
  ExternalServiceRegistry: TExternalServiceRegistry;
  ConfigurationData: TExternalServiceRegistryConfigurationData);
begin

  if Assigned(ConfigurationData.DocumentKind) then begin

    ConfigureLoodsmanDocumentsUploadingServiceForDocumentKind(
      ConfigurationData.DocumentKind,
      ExternalServiceRegistry,
      ConfigurationData
    )

  end;

  if Assigned(ConfigurationData.IncomingDocumentKind) then begin

    ConfigureLoodsmanDocumentsUploadingServiceForDocumentKind(
      ConfigurationData.IncomingDocumentKind,
      ExternalServiceRegistry,
      ConfigurationData
    );
    
  end;

end;

procedure TExternalServiceRegistryConfigurator
  .ConfigureLoodsmanDocumentsUploadingServiceForDocumentKind(
    const DocumentKind: TDocumentKindClass;
    ExternalServiceRegistry: TExternalServiceRegistry;
    ConfigurationData: TExternalServiceRegistryConfigurationData
  );
var
    AccessRightsTableDef: TLoodsmanDocumentsUploadingAccessRightsTableDef;
    UploadingQueueTableDef: TLoodsmanDocumentsUploadingQueueTableDef;

    LoodsmanDocumentUploadingInfoMapper: ILoodsmanDocumentUploadingInfoMapper;
    LoodsmanDocumentUploadingStatusChangingEnsurer: ILoodsmanDocumentUploadingStatusChangingEnsurer;
    
    LoodsmanDocumentsUploadingAccessRightsService: ILoodsmanDocumentsUploadingAccessRightsService;
    LoodsmanDocumentsUploadingService: ILoodsmanDocumentsUploadingService;


    PresentationServiceRegistry: TPresentationServiceRegistry;
    RepositoryRegistry: IRepositoryRegistry;
    QueryExecutor: IQueryExecutor;
begin

  QueryExecutor :=
    TZQueryExecutor.Create(TZConnection(ConfigurationData.DatabaseConnection));
    
  PresentationServiceRegistry := ConfigurationData.PresentationServiceRegistry;
  RepositoryRegistry := ConfigurationData.RepositoryRegistry;

  AccessRightsTableDef := TLoodsmanDocumentsUploadingAccessRightsTableDef.Create;

  AccessRightsTableDef.TableName := 'loodsman_integration.documents_uploading_access_rights';
  AccessRightsTableDef.IdColumnName := 'id';
  AccessRightsTableDef.EmployeeIdColumnName := 'employee_id';

  LoodsmanDocumentsUploadingAccessRightsService :=
    TBasedOnDatabaseLoodsmanDocumentsUploadingAccessRightsService.Create(
      QueryExecutor,
      AccessRightsTableDef
    );

  UploadingQueueTableDef := TLoodsmanDocumentsUploadingQueueTableDef.Create;

  UploadingQueueTableDef.TableName := 'loodsman_integration.service_notes_uploading_queue';
  UploadingQueueTableDef.IdColumnName := 'id';
  UploadingQueueTableDef.InitiatorIdColumnName := 'initiator_id';
  UploadingQueueTableDef.DocumentIdColumnName := 'document_id';
  UploadingQueueTableDef.DocumentJsonColumnName := 'document_json';
  UploadingQueueTableDef.StatusColumnName := 'status';
  UploadingQueueTableDef.UploadingRequestedDateTimeColumnName := 'uploading_requested_timestamp';
  UploadingQueueTableDef.UploadingDateTimeColumnName := 'uploading_timestamp';
  UploadingQueueTableDef.CancelerIdColumnName := 'canceler_id';
  UploadingQueueTableDef.CancelationRequestedDateTimeColumnName := 'cancelation_requested_timestamp';
  UploadingQueueTableDef.CancelingDateTimeColumnName := 'canceling_timestamp';
  UploadingQueueTableDef.CanceledDateTimeColumnName := 'canceled_timestamp';
  UploadingQueueTableDef.UploadedDateTimeColumnName := 'uploaded_timestamp';
  UploadingQueueTableDef.ErrorMessageColumnName := 'error_message';

  LoodsmanDocumentUploadingInfoMapper :=
    TLoodsmanDocumentUploadingInfoMapper.Create(
      TStandardOriginalDocumentInfoReadService.Create(
        PresentationServiceRegistry.GetDocumentInfoReadService(DocumentKind)
      ),
      PresentationServiceRegistry.GetEmployeeInfoReadService,
      UploadingQueueTableDef
    );

  LoodsmanDocumentUploadingStatusChangingEnsurer :=
    TStandardLoodsmanDocumentUploadingStatusChangingEnsurer.Create;
    
  LoodsmanDocumentsUploadingService :=
    TBasedOnDatabaseLoodsmanDocumentsUploadingService.Create(
      RepositoryRegistry.GetSessionManager,
      LoodsmanDocumentsUploadingAccessRightsService,
      QueryExecutor,
      UploadingQueueTableDef,
      LoodsmanDocumentUploadingInfoMapper,
      TDTODomainMapperRegistry.Instance.GetDocumentFullInfoJsonMapper(DocumentKind),
      LoodsmanDocumentUploadingStatusChangingEnsurer
    );

  ExternalServiceRegistry.RegisterLoodsmanDocumentsUploadingService(
    DocumentKind,
    LoodsmanDocumentsUploadingService
  );
  
end;

end.
