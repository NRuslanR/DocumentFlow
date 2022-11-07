unit ExternalServiceRegistryConfigurator;

interface

uses

  DocumentKindsMapper,
  ExternalServiceRegistry,
  ManagementServiceRegistry,
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

  end;

  TExternalServiceRegistryConfigurator = class

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
  IDocumentFileServiceClientUnit;

{ TExternalServiceRegistryConfigurator }

procedure TExternalServiceRegistryConfigurator.ConfigureExternalServiceRegistry(
  ExternalServiceRegistry: TExternalServiceRegistry;
  ConfigurationData: TExternalServiceRegistryConfigurationData
);
var
    DocumentKindsMapper: IDocumentKindsMapper;

    DocumentChargeSheetCasesNotifier: IDocumentChargeSheetCasesNotifier;
    DatabaseMessagingServiceSchemaData: TDatabaseMessagingServiceSchemaData;
    DocumentFileServiceClient: IDocumentFileServiceClient;

    UserNotificationProfileService: IUserNotificationProfileService;
    UserNotificationProfileDbSchema: TUserNotificationProfileDbSchema;

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
        
        DocumentFileServiceClient.GetFileStoragePath + PathDelim
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

end.
