unit DomainConfigurator;

interface


uses

  Document,
  IncomingDocument,
  InternalDocument,
  ServiceNote,
  IncomingServiceNote,
  InternalServiceNote,
  IncomingInternalServiceNote,
  DomainRegistries,
  SysUtils,
  Classes;

type

  TDomainConfigurationData = record

    DatabaseConnection: TComponent;

  end;
  
  TDomainConfigurator = class

    private

      procedure ConfigureEmployeesDomain(
        ConfigurationData: TDomainConfigurationData
      );
      
      procedure ConfigureDocumentsDomain(
        ConfigurationData: TDomainConfigurationData
      );

      procedure ConfigurePersonnelOrderRegistries(
        ConfigurationData: TDomainConfigurationData
      );

    private

      procedure ConfigureEmployeesRules;
      procedure ConfigureEmployeesServices;
      procedure ConfigureEmployeesSpecifications;

    private

      procedure ConfigureAllRegistriesForDocumentKind(
        ConfigurationData: TDomainConfigurationData;
        DocumentKind: TDocumentClass
      );

      procedure ConfigureLastPerformingServicesForDocumentKind(
        DocumentKind: TDocumentClass
      );

      procedure ConfigureSigningServicesForDocumentKind(
        DocumentKind: TDocumentClass
      );

      procedure ConfigureChargeAndChargeSheetRegistriesForDocument(
        ConfigurationData: TDomainConfigurationData;
        DocumentKind: TDocumentClass
      );

      procedure DoCommonRegistriesConfigurationForDocumentChargesAndChargeSheets(
        ConfigurationData: TDomainConfigurationData
      );
      
    public

      destructor Destroy; override;
      
      procedure ConfigureDomain(ConfigurationData: TDomainConfigurationData);

  end;

implementation

uses

  PersonnelOrder,
  ZConnection,
  ZQueryExecutor,
  RepositoryRegistryUnit,
  DocumentChargeSheetFinder,
  BasedOnRepositoryDocumentKindFinder,
  BasedOnRepositoryDocumentWorkCycleFinder,
  BasedOnRepositoryEmployeeFinder,
  BasedOnRepositoryDepartmentFinder,
  DocumentNumeratorTableDef,
  BasedOnRepositoryDocumentApprovingFinder,
  BasedOnRepositoryApprovingCycleResultFinder,
  BasedOnRepositoryDocumentFinder,
  BasedOnRepositoryEmployeesWorkGroupFinder,
  BasedOnRepositoryDocumentRelationsFinder,
  BasedOnRepositoryDocumentRelationDirectory,
  BasedOnRepositoryDocumentResponsibleDirectory,
  BasedOnRepositoryDocumentDirectory,
  BasedOnRepositoryIncomingDocumentDirectory,
  BasedOnRepositoryDocumentChargeSheetDirectory,
  BasedOnRepositoryDocumentFileMetadataDirectory,
  BasedOnRepositoryDocumentApprovingCycleResultDirectory,
  LocalNetworkFileStorageServiceClientUnit,
  BasedOnRepositoryDocumentChargeSheetFinder,
  BasedOnRepositoryDocumentResponsibleFinder,
  EmployeeSearchServiceRegistry,
  BasedOnDatabaseDocumentNumeratorRegistry,
  EmployeeServiceRegistry,
  EmployeeDistributionServiceRegistry,
  EmployeeSubordinationServiceRegistry,
  EmployeeRuleRegistry,
  EmployeeSpecificationRegistry,
  BasedOnPostgresDocumentNumeratorRegistry,
  DocumentFormalizationServiceRegistry,
  DocumentsDomainRegistries,
  DocumentDraftingRuleRegistry,
  DocumentServiceRegistry,
  DocumentStorageServiceRegistry,
  IncomingDocumentRepository,
  IncomingDocumentDirectory,
  DocumentCharges,
  DocumentAcquaitance,
  DocumentPerforming,
  DocumentPerformingSheet,
  DocumentAcquaitanceSheet,
  DocumentDirectory,
  DocumentChargeSheetDirectory,
  DocumentFileStorageService,
  DocumentFinder,
  DocumentRelationDirectory,
  DocumentResponsibleDirectory,
  DocumentApprovingCycleResultDirectory,
  PersonnelOrderDomainRegistries,
  PersonnelOrderServiceRegistries,
  StandardPersonnelOrderCreatingAccessService,
  StandardPersonnelOrderControlService,
  BasedOnRepositoryPersonnelOrderSignerListFinder,
  BasedOnRepositoryPersonnelOrderCreatingAccessEmployeeListFinder,
  BasedOnRepositoryPersonnelOrderApproverListFinder,
  BasedOnRepositoryDocumentChargeKindsControlService,
  StandardDocumentPersistingValidator,
  SuccessedDocumentPersistingValidator,
  BasedOnRepositoryPersonnelOrderControlGroupFinder,
  LegacyHttpFileStorageServiceClient,
  PersonnelOrderSearchServiceRegistry,
  PersonnelOrderAccessServiceRegistry,
  OriginalDocumentFinder,
  DocumentChargeSheet,
  DocumentChargeKind,
  IDomainObjectBaseListUnit,
  DocumentChargeServiceRegistry,
  DocumentChargeSheetsServiceRegistry, DocumentSigningServiceRegistry;


{ TDomainConfigurator }

procedure TDomainConfigurator.ConfigureDomain(ConfigurationData: TDomainConfigurationData);
begin

  ConfigureEmployeesDomain(ConfigurationData);
  ConfigureDocumentsDomain(ConfigurationData);

end;

procedure TDomainConfigurator.ConfigureEmployeesDomain(ConfigurationData: TDomainConfigurationData);
begin

  ConfigureEmployeesServices;
  ConfigureEmployeesSpecifications;
  ConfigureEmployeesRules;

end;

procedure TDomainConfigurator.ConfigureEmployeesRules;
begin

  with
    TDomainRegistries
      .EmployeesDomainRegistries
        .RuleRegistry
  do begin

    RegisterAllStandardEmployeeRules;

  end;

end;

procedure TDomainConfigurator.ConfigureEmployeesServices;
begin
                               
  with
    TDomainRegistries
      .EmployeesDomainRegistries
        .ServiceRegistry
  do begin

    with EmployeeSearchServiceRegistry do begin

      RegisterEmployeeFinder(
        TBasedOnRepositoryEmployeeFinder.Create(
          TRepositoryRegistry.Current.GetEmployeeRepository
        )
      );

      RegisterDepartmentFinder(
        TBasedOnRepositoryDepartmentFinder.Create(
          TRepositoryRegistry.Current.GetDepartmentRepository
        )
      );

      RegisterEmployeesWorkGroupFinder(
        TBasedOnRepositoryEmployeesWorkGroupFinder.Create(
          TRepositoryRegistry.Current.GetEmployeesWorkGroupRepository
        )
      );
      
    end;

    with EmployeeDistributionServiceRegistry do begin

      RegisterAllStandardEmployeeDistributionServices;

    end;

    with EmployeeSubordinationServiceRegistry do begin

      RegisterAllStandardEmployeeSubordinationServices;

    end;

    with EmployeePerformingServiceRegistry do begin

      RegisterAllStandardEmployeePerformingServices;

    end;
    
  end;

end;

procedure TDomainConfigurator.ConfigureEmployeesSpecifications;
begin

  with
    TDomainRegistries
      .EmployeesDomainRegistries
        .SpecificationRegistry
  do begin

    RegisterAllStandardEmployeeSpecifications;
    
  end;

end;

procedure TDomainConfigurator.ConfigureDocumentsDomain(ConfigurationData: TDomainConfigurationData);
var DocumentNumeratorTableData: TDocumentNumeratorTableData;
begin

  with
    TDomainRegistries
      .DocumentsDomainRegistries
        .ServiceRegistry
  do begin

    FormalizationServiceRegistry
      .RegisterAllStandardDocumentFormalizationServices;

    DocumentNumeratorTableData := TDocumentNumeratorTableData.Create;

    DocumentNumeratorTableData.TableName := DOCUMENT_NUMERATOR_TABLE_NAME;
    DocumentNumeratorTableData.DepartmentIdColumnName := DOCUMENT_NUMERATOR_TABLE_DEPARTMENT_ID_COLUMN_NAME;
    DocumentNumeratorTableData.DocumentTypeIdColumnName := DOCUMENT_NUMERATOR_TABLE_DOCUMENT_TYPE_ID_COLUMN_NAME;
    DocumentNumeratorTableData.NumberPrefixColumnName := DOCUMENT_NUMERATOR_TABLE_PREFIX_COLUMN_NAME;
    DocumentNumeratorTableData.NumberPostfixColumnName := DOCUMENT_NUMERATOR_TABLE_POSTFIX_COLUMN_NAME;
    DocumentNumeratorTableData.DelimiterColumnName := DOCUMENT_NUMERATOR_TABLE_DELIMITER_COLUMN_NAME;
    DocumentNumeratorTableData.CurrentNumberColumnName := DOCUMENT_NUMERATOR_TABLE_CURRENT_NUMBER_COLUMN_NAME;
    
    NumerationServiceRegistry
      .RegisterDocumentNumeratorRegistry(
        TBasedOnPostgresDocumentNumeratorRegistry.Create(
          DocumentNumeratorTableData,
          TZQueryExecutor.Create(
            TZConnection(
              ConfigurationData.DatabaseConnection
            )
          ),
          TRepositoryRegistry.Current.GetDepartmentRepository,
          TRepositoryRegistry.Current.GetDocumentRepositoryRegistry.GetDocumentKindRepository
        )
      );

    DocumentSearchServiceRegistry
      .RegisterDocumentKindFinder(
        TBasedOnRepositoryDocumentKindFinder.Create(
          TRepositoryRegistry.Current.GetDocumentRepositoryRegistry.GetDocumentKindRepository
        )
      );

    DocumentSearchServiceRegistry
      .RegisterStandardRegisterFormalDocumentSignerFinder;

    StorageServiceRegistry.RegisterDocumentResponsibleDirectory(
      TBasedOnRepositoryDocumentResponsibleDirectory.Create(
        TRepositoryRegistry.Current.GetDocumentRepositoryRegistry.GetDocumentResponsibleRepository
      )
    );
    
  end;

  DoCommonRegistriesConfigurationForDocumentChargesAndChargeSheets(ConfigurationData);

  ConfigurePersonnelOrderRegistries(ConfigurationData);
  
  ConfigureChargeAndChargeSheetRegistriesForDocument(ConfigurationData, TServiceNote);
  ConfigureChargeAndChargeSheetRegistriesForDocument(ConfigurationData, TIncomingServiceNote);
  ConfigureChargeAndChargeSheetRegistriesForDocument(ConfigurationData, TPersonnelOrder);

  ConfigureAllRegistriesForDocumentKind(ConfigurationData, TServiceNote);
  ConfigureAllRegistriesForDocumentKind(ConfigurationData, TIncomingServiceNote);
  ConfigureAllRegistriesForDocumentKind(ConfigurationData, TInternalServiceNote);
  ConfigureAllRegistriesForDocumentKind(ConfigurationData, TIncomingInternalServiceNote);
  ConfigureAllRegistriesForDocumentKind(ConfigurationData, TPersonnelOrder);
  
  ConfigureLastPerformingServicesForDocumentKind(TServiceNote);
  ConfigureLastPerformingServicesForDocumentKind(TInternalServiceNote);
  ConfigureLastPerformingServicesForDocumentKind(TPersonnelOrder);

  ConfigureSigningServicesForDocumentKind(TServiceNote);
  ConfigureSigningServicesForDocumentKind(TInternalServiceNote);
  ConfigureSigningServicesForDocumentKind(TPersonnelOrder);

  TDomainRegistries
    .DocumentsDomainRegistries
      .ServiceRegistry
        .AccessRightsServiceRegistry
          .RegisterStandardEmployeeDocumentKindAccessRightsService;
  
end;

procedure TDomainConfigurator.ConfigureLastPerformingServicesForDocumentKind(
  DocumentKind: TDocumentClass);
begin

  with
    TDomainRegistries
      .DocumentsDomainRegistries
        .ServiceRegistry
          .PerformingServiceRegistry
  do begin

    RegisterStandardSendingDocumentToPerformingService(DocumentKind);
    RegisterStandardCreatingNecessaryDataForDocumentPerformingService(DocumentKind);

  end;

end;

procedure TDomainConfigurator.ConfigurePersonnelOrderRegistries(
  ConfigurationData: TDomainConfigurationData);
begin

  with TPersonnelOrderDomainRegistries do begin

    with ServiceRegistries.PersonnelOrderSearchServiceRegistry do begin

      RegisterPersonnelOrderCreatingAccessEmployeeFinder(

        TBasedOnRepositoryPersonnelOrderCreatingAccessEmployeeListFinder.Create(

          TRepositoryRegistry
            .Current
              .GetPersonnelOrderRepositoryRegistry
                .GetPersonnelOrderCreatingAccessEmployeeRepository

        )
      );

      RegisterPersonnelOrderSignerListFinder(

        TBasedOnRepositoryPersonnelOrderSignerListFinder.Create(

          TRepositoryRegistry
            .Current
              .GetPersonnelOrderRepositoryRegistry
                .GetPersonnelOrderSignerListRepository
        )
      );

      RegisterPersonnelOrderApproverListFinder(

        TBasedOnRepositoryPersonnelOrderApproverListFinder.Create(

          TRepositoryRegistry
            .Current
              .GetPersonnelOrderRepositoryRegistry
                .GetPersonnelOrderApproverListRepository
        )
      );

      RegisterPersonnelOrderControlGroupFinder(

        TBasedOnRepositoryPersonnelOrderControlGroupFinder.Create(

          TRepositoryRegistry
            .Current
              .GetPersonnelOrderRepositoryRegistry
                .GetPersonnelOrderControlGroupRepository
        )
      );

    end;

    with ServiceRegistries.PersonnelOrderAccessServiceRegistry do begin

      RegisterStandardPersonnelOrderCreatingAccessService;
      
    end;

    with ServiceRegistries.PersonnelOrderControlServiceRegistry do begin

      RegisterStandardPersonnelOrderControlService;
      
    end;

  end;

end;

procedure TDomainConfigurator.ConfigureSigningServicesForDocumentKind(
  DocumentKind: TDocumentClass
);
begin

  with
    TDomainRegistries
      .DocumentsDomainRegistries
        .ServiceRegistry
          .SigningServiceRegistry
  do begin

    RegisterAllStandardDocumentSigningServices(DocumentKind);
    
  end;

end;

destructor TDomainConfigurator.Destroy;
begin

  TDomainRegistries.Destroy;
  
  inherited;

end;

procedure TDomainConfigurator.DoCommonRegistriesConfigurationForDocumentChargesAndChargeSheets(
  ConfigurationData: TDomainConfigurationData);
var
    ChargeKinds: TDocumentChargeKinds;
    ChargeKind: TDocumentChargeKind;
    FreeChargeKinds: IDomainObjectBaseList;
begin

  with TDocumentsDomainRegistries.RuleRegistry.ChargeRuleRegistry do begin

    RegisterStandardDocumentChargeChangingRule(TDocumentCharge);

  end;


  with TDocumentsDomainRegistries.ServiceRegistry.ChargeServiceRegistry do begin

    RegisterDocumentChargeKindsControlService(
      TBasedOnRepositoryDocumentChargeKindsControlService.Create(
        TRepositoryRegistry.Current.GetDocumentRepositoryRegistry.GetDocumentChargeKindRepository
      )
    );

    ChargeKinds := GetDocumentChargeKindsControlService.GetAllDocumentChargeKinds;

    FreeChargeKinds := ChargeKinds;

    for ChargeKind in ChargeKinds do begin

      with TDocumentsDomainRegistries.RuleRegistry.ChargeSheetRuleRegistry do begin

        RegisterAllStandardDocumentChargeSheetRules(
          TDocumentChargeSheetClass(ChargeKind.ChargeClass.ChargeSheetType)
        );

      end;

      RegisterStandardDocumentChargeCreatingService(ChargeKind.ChargeClass);

    end;      

  end;
  
end;

procedure TDomainConfigurator.ConfigureAllRegistriesForDocumentKind(
  ConfigurationData: TDomainConfigurationData;
  DocumentKind: TDocumentClass
);
var
    OutcomingDocumentType: TDocumentClass;
    OriginalDocumentFinder: IDocumentFinder;
begin

  with
    TDomainRegistries
      .DocumentsDomainRegistries
  do begin

    with
      ServiceRegistry
        .FormalizationServiceRegistry
    do begin

      RegisterDocumentResponsibleFinder(
        DocumentKind,
        TBasedOnRepositoryDocumentResponsibleFinder.Create(
        
          TRepositoryRegistry
            .Current
              .GetDocumentRepositoryRegistry
                .GetDocumentResponsibleRepository
        )
      );

    end;

    ServiceRegistry
      .RelationsServiceRegistry
        .RegisterDocumentRelationsFinder(
          DocumentKind,
          TBasedOnRepositoryDocumentRelationsFinder.Create(
          
            TRepositoryRegistry
              .Current
                .GetDocumentRepositoryRegistry
                  .GetDocumentRelationsRepository(
                    DocumentKind
                  )
          )
        );

    TDocumentsDomainRegistries
      .SpecificationRegistry
        .RegisterAllStandardDocumentSpecifications(DocumentKind);
        
    with
      RuleRegistry
        .DraftingRuleRegistry
    do begin

      RegisterAllStandardDocumentDraftingRules(DocumentKind);

    end;

    RuleRegistry
      .ApprovingRuleRegistry
        .RegisterAllStandardDocumentApprovingRules(DocumentKind);

    with
      ServiceRegistry
        .DocumentSearchServiceRegistry
    do begin
                
      RegisterDocumentFinder(
        DocumentKind,
        TBasedOnRepositoryDocumentFinder.Create(

          TRepositoryRegistry
            .Current
              .GetDocumentRepositoryRegistry
                .GetDocumentRepository(DocumentKind)
        )
      );

      RegisterDocumentWorkCycleFinder(
        DocumentKind,
        TBasedOnRepositoryDocumentWorkCycleFinder.Create(
          TRepositoryRegistry
            .Current
              .GetDocumentRepositoryRegistry
                .GetDocumentWorkCycleRepository(DocumentKind)
        )
      );
      
    end;

    with
      ServiceRegistry
        .ApprovingServiceRegistry
    do begin

      RegisterDocumentApprovingCycleResultFinder(
        DocumentKind,
        TBasedOnRepositoryApprovingCycleResultFinder.Create(

          TRepositoryRegistry
            .Current
              .GetDocumentRepositoryRegistry
                .GetDocumentApprovingCycleResultRepository(
                  DocumentKind
                )
        )
      );

      RegisterDocumentApprovingFinder(
        DocumentKind,
        TBasedOnRepositoryDocumentApprovingFinder.Create(

          TRepositoryRegistry
            .Current
              .GetDocumentRepositoryRegistry
                .GetDocumentApprovingRepository(DocumentKind)

        )
      );

    end;
        
    RuleRegistry
      .AccessRuleRegistry
        .RegisterAllStandardDocumentAccessRules(DocumentKind);

    RuleRegistry
      .ChargeRuleRegistry
        .RegisterStandardDocumentChargeListChangingRule(DocumentKind);

    RuleRegistry
      .PerformingRuleRegistry
        .RegisterAllStandardDocumentPerformingRules(DocumentKind);

    RuleRegistry
      .SigningRuleRegistry
        .RegisterAllStandardDocumentSigningRules(DocumentKind);

    ServiceRegistry
      .AccessRightsServiceRegistry
        .RegisterAllStandardDocumentAccessRightsServices(DocumentKind);

    ServiceRegistry
      .RegistrationServiceRegistry
        .RegisterStandardDocumentRegistrationService(DocumentKind);

    if DocumentKind.InheritsFrom(TIncomingDocument) then begin

      ServiceRegistry
        .OperationServiceRegistry
          .RegisterStandardIncomingDocumentCreatingService(
            TIncomingDocumentClass(DocumentKind)
          );

      ServiceRegistry
        .OperationServiceRegistry
          .RegisterStandardRespondingDocumentCreatingService(DocumentKind);
          
    end

    else begin

      ServiceRegistry
        .OperationServiceRegistry
          .RegisterStandardDocumentCreatingService(DocumentKind);

    end;

    with ServiceRegistry.StorageServiceRegistry do begin

      RegisterDocumentFileMetadataDirectory(
        DocumentKind,
        TBasedOnRepositoryDocumentFileMetadataDirectory.Create(
          TRepositoryRegistry.Current.GetDocumentRepositoryRegistry.GetDocumentFilesRepository(
            DocumentKind
          )
        )
      );

      RegisterStandardDocumentFileStorageService(
        DocumentKind,
        TLegacyHttpFileStorageServiceClient.Create(
          TZConnection(ConfigurationData.DatabaseConnection),
          TLocalNetworkFileSystemPathBuilder.Create
        )
      );

      RegisterDocumentRelationDirectory(
        DocumentKind,
        TBasedOnRepositoryDocumentRelationDirectory.Create(
          TRepositoryRegistry.Current.GetDocumentRepositoryRegistry.GetDocumentRelationsRepository(
            DocumentKind
          )
        )
      );

      RegisterDocumentApprovingCycleResultDirectory(
        DocumentKind,

        TBasedOnRepositoryDocumentApprovingCycleResultDirectory.Create(
        
          TRepositoryRegistry.Current.GetDocumentRepositoryRegistry.GetDocumentApprovingCycleResultRepository(
            DocumentKind
          ),

          ServiceRegistry.ApprovingServiceRegistry.GetDocumentApprovingCycleResultFinder(
            DocumentKind
          )
        )
      );

      if not DocumentKind.InheritsFrom(TIncomingDocument) then begin

        RegisterDocumentDirectory(
          DocumentKind,
          TBasedOnRepositoryDocumentDirectory.Create(
            TRepositoryRegistry.Current.GetDocumentRepositoryRegistry.GetDocumentRepository(
              DocumentKind
            ),
            TStandardDocumentPersistingValidator.Create(
              ServiceRegistry.DocumentSearchServiceRegistry.GetDocumentFinder(DocumentKind)
            ),
            ServiceRegistry.DocumentSearchServiceRegistry.GetDocumentFinder(DocumentKind),
            GetDocumentRelationDirectory(DocumentKind),
            GetDocumentApprovingCycleResultDirectory(DocumentKind),
            GetDocumentResponsibleDirectory,
            GetDocumentFileStorageService(DocumentKind),
            ServiceRegistry.ChargeSheetsServiceRegistry.GetDocumentChargeSheetDirectory(DocumentKind)
          )
        );

        RegisterOriginalDocumentDirectory(
          DocumentKind,
          TBasedOnRepositoryDocumentDirectory.Create(
            TRepositoryRegistry.Current.GetDocumentRepositoryRegistry.GetDocumentRepository(
              DocumentKind
            ),
            TSuccessedDocumentPersistingValidator.Create,
            ServiceRegistry.DocumentSearchServiceRegistry.GetDocumentFinder(DocumentKind),
            GetDocumentRelationDirectory(DocumentKind),
            GetDocumentApprovingCycleResultDirectory(DocumentKind),
            GetDocumentResponsibleDirectory,
            GetDocumentFileStorageService(DocumentKind),
            ServiceRegistry.ChargeSheetsServiceRegistry.GetDocumentChargeSheetDirectory(DocumentKind)
          )
        );
        
      end

      else begin

        OutcomingDocumentType := TIncomingDocumentClass(DocumentKind).OutcomingDocumentType;

        RegisterDocumentDirectory(
          DocumentKind,

          TBasedOnRepositoryIncomingDocumentDirectory.Create(

            TRepositoryRegistry.Current.GetDocumentRepositoryRegistry.GetIncomingDocumentRepository(
              TIncomingDocumentClass(DocumentKind)
            ),

            GetDocumentDirectory(TIncomingDocumentClass(DocumentKind).OutcomingDocumentType),
            TSuccessedDocumentPersistingValidator.Create,
            ServiceRegistry.DocumentSearchServiceRegistry.GetDocumentFinder(DocumentKind),
            GetDocumentRelationDirectory(DocumentKind),
            GetDocumentApprovingCycleResultDirectory(DocumentKind),
            GetDocumentResponsibleDirectory,
            GetDocumentFileStorageService(DocumentKind),
            ServiceRegistry.ChargeSheetsServiceRegistry.GetDocumentChargeSheetDirectory(DocumentKind)
          )
        );

        OriginalDocumentFinder :=
          TOriginalDocumentFinder.Create(
            ServiceRegistry.DocumentSearchServiceRegistry.GetDocumentFinder(
              DocumentKind
            )
          );

        RegisterOriginalDocumentDirectory(
          DocumentKind,
          TBasedOnRepositoryDocumentDirectory.Create(

            TRepositoryRegistry.Current.GetDocumentRepositoryRegistry.GetDocumentRepository(
              OutcomingDocumentType
            ),

            TSuccessedDocumentPersistingValidator.Create,
            
            OriginalDocumentFinder,

            GetDocumentRelationDirectory(OutcomingDocumentType),
            GetDocumentApprovingCycleResultDirectory(OutcomingDocumentType),
            GetDocumentResponsibleDirectory,
            GetDocumentFileStorageService(OutcomingDocumentType),
            ServiceRegistry.ChargeSheetsServiceRegistry.GetDocumentChargeSheetDirectory(DocumentKind)
          )
        );
        
      end;

    end;

    ServiceRegistry
      .PerformingServiceRegistry
        .RegisterStandardDocumentPerformingService(DocumentKind);

    ServiceRegistry
      .ChargeSheetsServiceRegistry
        .RegisterStandardDocumentChargeSheetControlService(DocumentKind);

    ServiceRegistry
      .ApprovingServiceRegistry
        .RegisterAllStandardDocumentApprovingServices(DocumentKind);

    ServiceRegistry
      .DocumentKindReferenceServiceRegistry
        .RegisterStandardDocumentKindWorkCycleInfoService(DocumentKind);
        
  end;
  
end;

procedure TDomainConfigurator
  .ConfigureChargeAndChargeSheetRegistriesForDocument(
    ConfigurationData: TDomainConfigurationData;
    DocumentKind: TDocumentClass
  );
begin

  with TDocumentsDomainRegistries.ServiceRegistry.ChargeSheetsServiceRegistry
  do begin

    RegisterDocumentChargeSheetFinder(
      DocumentKind,
      TBasedOnRepositoryDocumentChargeSheetFinder.Create(
        TRepositoryRegistry.Current.GetDocumentRepositoryRegistry.GetDocumentChargeSheetRepository(DocumentKind)
      )
    );

    RegisterDocumentChargeSheetDirectory(
      DocumentKind,
      TBasedOnRepositoryDocumentChargeSheetDirectory.Create(
        GetDocumentChargeSheetFinder(DocumentKind),
        TRepositoryRegistry.Current.GetDocumentRepositoryRegistry.GetDocumentChargeSheetRepository(DocumentKind)
      )
    );

    RegisterAllStandardDocumentChargeSheetPerformingServices(DocumentKind);

  end;

end;

end.
