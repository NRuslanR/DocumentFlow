{ refactor:
  преобразовать реализацию конфигурирования служб бинес-сценариев
  для более лучшего сопровождения. Аналогично преобразовать реализацию
  конфигураторов других типов
}
unit DocumentBusinessProcessServiceRegistryConfigurator;

interface

uses

  DocumentBusinessProcessServiceRegistry,
  IRepositoryRegistryUnit,
  ExternalServiceRegistry,
  DocumentChargeSheet,
  PresentationServiceRegistry,
  Document,
  DocumentKinds,
  IncomingDocument,
  SysUtils,
  Windows,
  Classes;

type

  TDocumentBusinessProcessServiceRegistryConfigurationData = record

    DocumentClass: TDocumentClass;
    IncomingDocumentClass: TIncomingDocumentClass;

    RepositoryRegistry: IRepositoryRegistry;

    PresentationServiceRegistry: TPresentationServiceRegistry;
    ExternalServiceRegistry: TExternalServiceRegistry;

  end;

  TDocumentBusinessProcessServiceRegistryConfigurator = class

    private

      FIsCommonConfigurationDone: Boolean;
      
    public

      procedure DoCommonBusinessProcessServiceRegistryConfiguration(
        DocumentBusinessProcessServiceRegistry: TDocumentBusinessProcessServiceRegistry;
        ConfigurationData: TDocumentBusinessProcessServiceRegistryConfigurationData
      );

      procedure ConfigureDocumentBusinessProcessServiceRegistry(
        DocumentBusinessProcessServiceRegistry: TDocumentBusinessProcessServiceRegistry;
        ConfigurationData: TDocumentBusinessProcessServiceRegistryConfigurationData
      );

  end;
  
implementation

uses

  StandardDocumentChargeKindsControlAppService,
  DocumentChargeKindDtoDomainMapper,
  DocumentChargesInfoDTODomainMapper,
  DocumentChargeSheetInfoDTODomainMapperRegistry,
  DocumentKindsMapper,
  DocumentSigningServiceRegistry,
  StandardSendingDocumentToSigningService,
  StandardSendingDocumentToApprovingService,
  StandardSendingDocumentToPerformingAppService,
  StandardDocumentApprovingService,
  StandardDocumentApprovingRejectingService,
  StandardDocumentApprovingControlAppService,
  StandardDocumentSigningRejectingService,
  DocumentChargeSheetControlAppService,
  StandardDocumentChargeSheetControlAppService,
  StandardDocumentStorageService,
  StandardOutcomingDocumentStorageService,
  StandardRelatedDocumentStorageService,
  RespondingDocumentCreatingAppService,
  DocumentSigningAppService,
  StandardRespondingDocumentCreatingAppService,
  StandardDocumentSigningToPerformingAppService,
  StandardEmployeeDocumentKindAccessRightsAppService,
  EmployeeDocumentKindAccessRightsAppService,
  DocumentSigningToPerformingService,
  DomainRegistries,
  DocumentFullInfoDTOMapper,
  DocumentDTOMapper,
  DocumentAcquaitanceSheet,
  DocumentAcquaitanceSheetInfoDTODomainMapper,
  DocumentPerformingSheet,
  DocumentPerformingSheetInfoDTODomainMapper,
  DocumentPerformingServiceRegistry,
  DocumentChargeSheetsInfoDTODomainMapper,
  DocumentApprovingsInfoDTOMapper,
  DocumentFlowEmployeeInfoDTOMapper,
  DocumentUsageEmployeeAccessRightsInfoDTOMapper,
  DocumentsDomainRegistries,
  ApplicationServiceRegistries,
  DocumentApprovingServiceRegistry,
  DocumentChargeSheetsServiceRegistry,
  OriginalDocumentFinder,
  DocumentSigningMarkingAppService,
  StandardDocumentSigningMarkingAppService,
  StandardDocumentSigningMarkingToPerformingAppService,
  DTODomainMapperRegistry,
  StandardDocumentSigningAppService,
  IncomingDocumentDirectory,
  PersonnelOrderDTODomainMapper,
  EmployeesDomainRegistries;
  
{ TDocumentBusinessProcessServiceRegistryConfigurator }

procedure TDocumentBusinessProcessServiceRegistryConfigurator.ConfigureDocumentBusinessProcessServiceRegistry(
  DocumentBusinessProcessServiceRegistry: TDocumentBusinessProcessServiceRegistry;
  ConfigurationData: TDocumentBusinessProcessServiceRegistryConfigurationData
);
var
    DocumentKindsMapper: IDocumentKindsMapper;
    
    ServiceDocumentKind: TDocumentKindClass;
    ServiceIncomingDocumentKind: TIncomingDocumentKindClass;

    RepositoryRegistry: IRepositoryRegistry;

    EmployeeDocumentKindAccessRightsAppService:
      IEmployeeDocumentKindAccessRightsAppService;

    DocumentStorageServiceClass: TStandardDocumentStorageServiceClass;
begin

  if not FIsCommonConfigurationDone then begin

    DoCommonBusinessProcessServiceRegistryConfiguration(
      DocumentBusinessProcessServiceRegistry, ConfigurationData
    );

  end;
  
  DocumentKindsMapper := TDTODomainMapperRegistry.Instance.GetDocumentKindsMapper;

  ServiceDocumentKind :=
    DocumentKindsMapper.MapDomainDocumentKindToDocumentKind(
      ConfigurationData.DocumentClass
    );

  RepositoryRegistry := ConfigurationData.RepositoryRegistry;

  //--------------UseCase App-Services Registration-----------------------------
  DocumentBusinessProcessServiceRegistry.
    RegisterSendingDocumentToSigningService(
      ServiceDocumentKind,
      TSendingDocumentToSigningService.Create(
        RepositoryRegistry.GetSessionManager,
        TDocumentsDomainRegistries.ServiceRegistry.StorageServiceRegistry.GetDocumentDirectory(ConfigurationData.DocumentClass),
        RepositoryRegistry.GetEmployeeRepository
      )
    );

  DocumentBusinessProcessServiceRegistry.RegisterSendingDocumentToApprovingService(
    ServiceDocumentKind,
    TStandardSendingDocumentToApprovingService.Create(
      RepositoryRegistry.GetSessionManager,
      TDocumentsDomainRegistries.ServiceRegistry.StorageServiceRegistry.GetDocumentDirectory(ConfigurationData.DocumentClass),
      RepositoryRegistry.GetEmployeeRepository
    )
  );

  DocumentBusinessProcessServiceRegistry.RegisterDocumentApprovingService(
    ServiceDocumentKind,
    TStandardDocumentApprovingService.Create(
      RepositoryRegistry.GetSessionManager,
      TDocumentsDomainRegistries.ServiceRegistry.StorageServiceRegistry.GetDocumentDirectory(ConfigurationData.DocumentClass),
      RepositoryRegistry.GetEmployeeRepository,
      TDocumentsDomainRegistries.ServiceRegistry.ApprovingServiceRegistry.GetDocumentApprovingProcessControlService(ConfigurationData.DocumentClass),
      RepositoryRegistry.GetDocumentRepositoryRegistry.GetDocumentApprovingCycleResultRepository(ConfigurationData.DocumentClass)
    )
  );

  DocumentBusinessProcessServiceRegistry.RegisterDocumentApprovingRejectingService(
    ServiceDocumentKind,
    TStandardDocumentApprovingRejectingService.Create(
      RepositoryRegistry.GetSessionManager,
      TDocumentsDomainRegistries.ServiceRegistry.StorageServiceRegistry.GetDocumentDirectory(ConfigurationData.DocumentClass),
      RepositoryRegistry.GetEmployeeRepository,
      TDocumentsDomainRegistries.ServiceRegistry.ApprovingServiceRegistry.GetDocumentApprovingProcessControlService(ConfigurationData.DocumentClass),
      RepositoryRegistry.GetDocumentRepositoryRegistry.GetDocumentApprovingCycleResultRepository(ConfigurationData.DocumentClass)
    )
  );

  DocumentBusinessProcessServiceRegistry.RegisterDocumentApprovingControlAppService(
    ServiceDocumentKind,
    TStandardDocumentApprovingControlAppService.Create(
      RepositoryRegistry.GetSessionManager,
      TDocumentsDomainRegistries.ServiceRegistry.StorageServiceRegistry.GetDocumentDirectory(ConfigurationData.DocumentClass),
      RepositoryRegistry.GetEmployeeRepository,
      TDocumentsDomainRegistries.ServiceRegistry.ApprovingServiceRegistry.GetDocumentApprovingProcessControlService(ConfigurationData.DocumentClass),
      RepositoryRegistry.GetDocumentRepositoryRegistry.GetDocumentApprovingCycleResultRepository(ConfigurationData.DocumentClass)
    )
  );

  DocumentBusinessProcessServiceRegistry.RegisterSendingDocumentToPerformingAppService(
    ServiceDocumentKind,
    TStandardSendingDocumentToPerformingAppService.Create(
      RepositoryRegistry.GetSessionManager,
      TDocumentsDomainRegistries.ServiceRegistry.StorageServiceRegistry.GetDocumentDirectory(ConfigurationData.DocumentClass),
      RepositoryRegistry.GetEmployeeRepository,
      TDocumentPerformingServiceRegistry.Instance.GetSendingDocumentToPerformingService(ConfigurationData.DocumentClass),
      ConfigurationData.ExternalServiceRegistry.GetDocumentChargeSheetCasesNotifier(ServiceDocumentKind)
    )
  );

  DocumentBusinessProcessServiceRegistry.RegisterDocumentSigningMarkingAppService(
    ServiceDocumentKind,
    TStandardDocumentSigningMarkingToPerformingAppService.Create(
      RepositoryRegistry.GetSessionManager,
      TDocumentsDomainRegistries.ServiceRegistry.StorageServiceRegistry.GetDocumentDirectory(ConfigurationData.DocumentClass),
      RepositoryRegistry.GetEmployeeRepository,
      TDocumentsDomainRegistries.ServiceRegistry.SigningServiceRegistry.GetDocumentSigningMarkingToPerformingService(ConfigurationData.DocumentClass),
      ConfigurationData.ExternalServiceRegistry.GetDocumentChargeSheetCasesNotifier(ServiceDocumentKind)
    )
  );

  DocumentBusinessProcessServiceRegistry.RegisterDocumentSigningAppService(
    ServiceDocumentKind,
    TStandardDocumentSigningToPerformingAppService.Create(
      RepositoryRegistry.GetSessionManager,
      TDocumentsDomainRegistries.ServiceRegistry.StorageServiceRegistry.GetDocumentDirectory(ConfigurationData.DocumentClass),
      RepositoryRegistry.GetEmployeeRepository,
      IDocumentSigningToPerformingService(TDocumentSigningServiceRegistry.Instance.GetDocumentSigningService(ConfigurationData.DocumentClass)),
      ConfigurationData.ExternalServiceRegistry.GetDocumentChargeSheetCasesNotifier(ServiceDocumentKind)
    )
  );

  DocumentBusinessProcessServiceRegistry.RegisterDocumentSigningRejectingService(
    ServiceDocumentKind,
    TDocumentSigningRejectingService.Create(
      RepositoryRegistry.GetSessionManager,
      TDocumentsDomainRegistries.ServiceRegistry.StorageServiceRegistry.GetDocumentDirectory(ConfigurationData.DocumentClass),
      RepositoryRegistry.GetEmployeeRepository
    )
  );

  DocumentBusinessProcessServiceRegistry.RegisterDocumentChargeSheetControlAppService(
    ServiceDocumentKind,
    TStandardDocumentChargeSheetControlAppService.Create(
      RepositoryRegistry.GetSessionManager,
      TDocumentsDomainRegistries.ServiceRegistry.StorageServiceRegistry.GetOriginalDocumentDirectory(ConfigurationData.DocumentClass),
      RepositoryRegistry.GetEmployeeRepository,
      TDocumentsDomainRegistries.ServiceRegistry.ChargeSheetsServiceRegistry.GetDocumentChargeSheetControlService(ConfigurationData.DocumentClass),
      ConfigurationData.ExternalServiceRegistry.GetDocumentChargeSheetCasesNotifier(ServiceDocumentKind),
      TDTODomainMapperRegistry.Instance.ChargeSheetInfoDTODomainMapperRegistry
    )
  );

  DocumentBusinessProcessServiceRegistry.RegisterDocumentChargeKindsControlAppService(
    TStandardDocumentChargeKindsControlAppService.Create(
      TDocumentsDomainRegistries.ServiceRegistry.ChargeServiceRegistry.GetDocumentChargeKindsControlService,
      TDocumentChargeKindDtoDomainMapper.Create
    )
  );
  
  if Assigned(ConfigurationData.IncomingDocumentClass) then
    DocumentStorageServiceClass := TStandardOutcomingDocumentStorageService

  else DocumentStorageServiceClass := TStandardDocumentStorageService;
                                              
  DocumentBusinessProcessServiceRegistry.RegisterDocumentStorageService(
    ServiceDocumentKind,
    DocumentStorageServiceClass.Create(
      RepositoryRegistry.GetSessionManager,
      TDocumentsDomainRegistries.ServiceRegistry.StorageServiceRegistry.GetDocumentDirectory(ConfigurationData.DocumentClass),
      RepositoryRegistry.GetEmployeeRepository,
      TDocumentsDomainRegistries.ServiceRegistry.OperationServiceRegistry.GetDocumentCreatingService(ConfigurationData.DocumentClass),
      ConfigurationData.PresentationServiceRegistry.GetDocumentInfoReadService(ServiceDocumentKind),
      TDocumentsDomainRegistries.ServiceRegistry.AccessRightsServiceRegistry.GetDocumentUsageEmployeeAccessRightsService(ConfigurationData.DocumentClass),
      TDTODomainMapperRegistry.Instance.GetDocumentObjectsDTODomainMapper(ServiceDocumentKind),
      TDTODomainMapperRegistry.Instance.GetDocumentFullInfoDTOMapper(ServiceDocumentKind),
      TDTODomainMapperRegistry.Instance.GetDocumentUsageEmployeeAccessRightsInfoDTOMapper,
      TDTODomainMapperRegistry.Instance.GetDocumentResponsibleInfoDTOMapper.AsSelf
    )
  );

  DocumentBusinessProcessServiceRegistry.
    RegisterRelatedDocumentStorageService(
      ServiceDocumentKind,
      TStandardRelatedDocumentStorageService.Create(
        RepositoryRegistry.GetSessionManager,
        TDocumentsDomainRegistries.ServiceRegistry.StorageServiceRegistry.GetDocumentDirectory(ConfigurationData.DocumentClass),
        RepositoryRegistry.GetDocumentRepositoryRegistry.GetDocumentKindRepository,
        TDocumentsDomainRegistries.ServiceRegistry.AccessRightsServiceRegistry.GetDocumentUsageEmployeeAccessRightsService(ConfigurationData.DocumentClass),
        RepositoryRegistry.GetEmployeeRepository,
        TDocumentKindsMapper(TDTODomainMapperRegistry.Instance.GetDocumentKindsMapper.Self),
        TDTODomainMapperRegistry.Instance.GetDocumentUsageEmployeeAccessRightsInfoDTOMapper
      )
    );

  if Assigned(ConfigurationData.IncomingDocumentClass) then begin

    ServiceIncomingDocumentKind :=
      TIncomingDocumentKindClass(
        DocumentKindsMapper.MapDomainDocumentKindToDocumentKind(
          ConfigurationData.IncomingDocumentClass
        )
      );

    DocumentBusinessProcessServiceRegistry.RegisterDocumentChargeSheetControlAppService(
      ServiceIncomingDocumentKind,
      TStandardDocumentChargeSheetControlAppService.Create(
        RepositoryRegistry.GetSessionManager,
        TDocumentsDomainRegistries.ServiceRegistry.StorageServiceRegistry.GetOriginalDocumentDirectory(ConfigurationData.IncomingDocumentClass),
        RepositoryRegistry.GetEmployeeRepository,
        TDocumentsDomainRegistries.ServiceRegistry.ChargeSheetsServiceRegistry.GetDocumentChargeSheetControlService(ConfigurationData.DocumentClass),
        ConfigurationData.ExternalServiceRegistry.GetDocumentChargeSheetCasesNotifier(ServiceDocumentKind),
        TDTODomainMapperRegistry.Instance.ChargeSheetInfoDTODomainMapperRegistry
      )
    );

    DocumentBusinessProcessServiceRegistry.RegisterDocumentStorageService(
      ServiceIncomingDocumentKind,
      TStandardDocumentStorageService.Create(
        RepositoryRegistry.GetSessionManager,
        TDocumentsDomainRegistries.ServiceRegistry.StorageServiceRegistry.GetDocumentDirectory(ConfigurationData.IncomingDocumentClass),
        RepositoryRegistry.GetEmployeeRepository,
        TDocumentsDomainRegistries.ServiceRegistry.OperationServiceRegistry.GetDocumentCreatingService(ConfigurationData.IncomingDocumentClass),
        ConfigurationData.PresentationServiceRegistry.GetDocumentInfoReadService(ServiceIncomingDocumentKind),
        TDocumentsDomainRegistries.ServiceRegistry.AccessRightsServiceRegistry.GetDocumentUsageEmployeeAccessRightsService(ConfigurationData.IncomingDocumentClass),
        TDTODomainMapperRegistry.Instance.GetDocumentObjectsDTODomainMapper(ServiceDocumentKind),
        TDTODomainMapperRegistry.Instance.GetDocumentFullInfoDTOMapper(ServiceIncomingDocumentKind),
        TDTODomainMapperRegistry.Instance.GetDocumentUsageEmployeeAccessRightsInfoDTOMapper,
        TDTODomainMapperRegistry.Instance.GetDocumentResponsibleInfoDTOMapper.AsSelf
      )
    );

    DocumentBusinessProcessServiceRegistry.RegisterRelatedDocumentStorageService(
      ServiceIncomingDocumentKind,
      TStandardRelatedDocumentStorageService.Create(
        RepositoryRegistry.GetSessionManager,
        TDocumentsDomainRegistries.ServiceRegistry.StorageServiceRegistry.GetDocumentDirectory(ConfigurationData.IncomingDocumentClass),
        RepositoryRegistry.GetDocumentRepositoryRegistry.GetDocumentKindRepository,
        TDocumentsDomainRegistries.ServiceRegistry.AccessRightsServiceRegistry.GetDocumentUsageEmployeeAccessRightsService(ConfigurationData.IncomingDocumentClass),
        RepositoryRegistry.GetEmployeeRepository,
        TDocumentKindsMapper(TDTODomainMapperRegistry.Instance.GetDocumentKindsMapper.Self),
        TDTODomainMapperRegistry.Instance.GetDocumentUsageEmployeeAccessRightsInfoDTOMapper
      )
    );

    DocumentBusinessProcessServiceRegistry
      .RegisterRespondingDocumentCreatingAppService(
        ServiceIncomingDocumentKind,
        TStandardRespondingDocumentCreatingAppService.Create(
          RepositoryRegistry.GetSessionManager,
          TDocumentsDomainRegistries.ServiceRegistry.StorageServiceRegistry.GetDocumentDirectory(ConfigurationData.IncomingDocumentClass),
          RepositoryRegistry.GetEmployeeRepository,
          TDocumentsDomainRegistries.ServiceRegistry.OperationServiceRegistry.GetRespondingDocumentCreatingService(ConfigurationData.IncomingDocumentClass),
          TDTODomainMapperRegistry.Instance.GetDocumentFullInfoDTOMapper(ServiceDocumentKind),
          TDTODomainMapperRegistry.Instance.GetDocumentUsageEmployeeAccessRightsInfoDTOMapper
      )
    );

  end;

end;

procedure TDocumentBusinessProcessServiceRegistryConfigurator
  .DoCommonBusinessProcessServiceRegistryConfiguration(
    DocumentBusinessProcessServiceRegistry: TDocumentBusinessProcessServiceRegistry;
    ConfigurationData: TDocumentBusinessProcessServiceRegistryConfigurationData
  );
var
    EmployeeDocumentKindAccessRightsAppService: IEmployeeDocumentKindAccessRightsAppService;
begin

  if FIsCommonConfigurationDone then Exit;
  
  EmployeeDocumentKindAccessRightsAppService :=
    DocumentBusinessProcessServiceRegistry
      .GetEmployeeDocumentKindAccessRightsAppService;
      
  with ConfigurationData do begin

    if not Assigned(EmployeeDocumentKindAccessRightsAppService)
    then begin

      DocumentBusinessProcessServiceRegistry.
        RegisterEmployeeDocumentKindAccessRightsAppService(
          TStandardEmployeeDocumentKindAccessRightsAppService.Create(
            RepositoryRegistry.GetSessionManager,
            RepositoryRegistry.GetEmployeeRepository,
            TDocumentsDomainRegistries.ServiceRegistry.AccessRightsServiceRegistry.GetEmployeeDocumentKindAccessRightsService,
            ConfigurationData.PresentationServiceRegistry.GetNativeDocumentKindsReadService,
            TDTODomainMapperRegistry.Instance.GetDocumentKindsMapper
          )
        );

    end;

  end;

  FIsCommonConfigurationDone := True;

end;

end.
