unit PresentationServiceRegistryConfigurator;

interface

uses

  DocumentKinds,
  AbstractQueryExecutor,
  QueryExecutor,
  PresentationServiceRegistry,
  IRepositoryRegistryUnit,
  PersonnelOrderPresentationServiceRegistry,
  SysUtils,
  Classes;

type

  {
    refactor: simplify to Connection, RepositoryRegistry, ApplicationServices.
    Get all document kinds from certain service
  }
  TPresentationServiceRegistryConfigurationData = record

    DatabaseConnection: TComponent;

    DocumentKind: TNativeDocumentKindClass;
    OutcomingDocumentKind: TOutcomingDocumentKindClass;
    IncomingDocumentKind: TIncomingDocumentKindClass;
    ApproveableDocumentKind: TApproveableDocumentKindClass;
    OutcomingInternalDocumentKind: TOutcomingInternalDocumentKindClass;
    IncomingInternalDocumentKind: TIncomingInternalDocumentKindClass;
    
    RepositoryRegistry: IRepositoryRegistry;

  end;
  
  TPresentationServiceRegistryConfigurator = class

    private

      { refactor: remove after refactor }
      
      FIsCommonConfigurationDone: Boolean;

      procedure RegisterServiceNotePresentationServices(
        PresentationServiceRegistry: TPresentationServiceRegistry;
        ConfigurationData: TPresentationServiceRegistryConfigurationData;
        QueryExecutor: TAbstractQueryExecutor
      );

      procedure RegisterPersonnelOrderPresentationServices(
        PresentationServiceRegistry: TPresentationServiceRegistry;
        ConfigurationData: TPresentationServiceRegistryConfigurationData;
        QueryExecutor: IQueryExecutor
      );

    public

      procedure DoCommonPresentationServiceRegistryConfiguration(
        PresentationServiceRegistry: TPresentationServiceRegistry;
        ConfigurationData: TPresentationServiceRegistryConfigurationData
      );
      
      procedure ConfigurePresentationServiceRegistry(
        PresentationServiceRegistry: TPresentationServiceRegistry;
        ConfigurationData: TPresentationServiceRegistryConfigurationData
      );

  end;

implementation

uses

  BasedOnDatabaseDocumentInfoPartlyReadService,
  EmployeeDbSchema,
  DepartmentDbSchema,
  RoleDbSchema,
  EmployeeWorkGroupAssociationDbSchema,
  EmployeeSetReadService,
  EmployeeSubordinationService,
  EmployeeChargePerformingService,
  EmployeeFinder,
  EmployeesWorkGroupFinder,
  WorkGroupEmployeeDistributionService,
  DocumentKindDbSchema,
  Disposable,
  DocumentInfoReadService,
  BasedOnDatabaseDocumentCreatingDefaultInfoReadService,
  PostgresDocumentCreatingDefaultInfoFetchingQueryBuilder,
  NativeDocumentKindsReadService,
  SDItemsService,
  PlantItemService,
  BasedOnZeosVclPlantItemService,
  ZQueryExecutor,
  ZConnection,
  BasedOnDatabaseEmployeeSetReadService,
  BasedOnRepositoryEmployeeFinder,
  BasedOnRepositoryEmployeesWorkGroupFinder,
  StandardWorkGroupEmployeeDistributionService,
  StandardEmployeeSubordinationService,
  BasedOnRepositoryDepartmentFinder,
  StandardEmployeeChargePerformingService,
  BasedOnZeosPostgresSDItemsService,
  StandardInternalDocumentSignerSetReadService,
  StandardDocumentSignerSetReadService,
  StandardDocumentResponsibleSetReadService,
  StandardInternalDocumentResponsibleSetReadService,
  StandardDocumentChargePerformerSetReadService,
  StandardDocumentChargeSheetPerformerSetReadService,
  StandardInternalDocumentChargePerformerSetReadService,
  StandardIncomingInternalDocumentChargePerformerSetReadService,
  StandardDocumentApproverSetReadService,
  BasedOnDatabaseDocumentInfoReadService,
  BasedOnDatabaseNativeDocumentKindsReadService,
  NumericDocumentKindResolver,
  StandardGlobalDocumentKindsReadService,
  BasedOnDatabaseEmployeeOutcomingDocumentSetReadService,
  BasedOnDatabaseEmployeeIncomingDocumentSetReadService,
  BasedOnDatabaseEmployeeInternalDocumentSetReadService,
  BasedOnDatabaseEmployeeApproveableDocumentSetReadService,
  StandardDocumentKindWorkCycleInfoAppService,
  StandardDocumentKindWorkCycleInfoService,
  DomainRegistries,
  DataSetQueryExecutor,
  EmployeesDomainRegistries,
  DepartmentTableDef,
  EmployeeTableDef,
  RoleTableDef,
  EmployeeWorkGroupAssocTableDef,
  DocumentTypesTableDef,
  ServiceNoteDBTableUnit,
  ServiceNoteSigningTable,
  ServiceNoteApprovingsTable,
  ServiceNoteChargeSheetTable,
  ServiceNoteLinksDBTableUnit,
  ServiceNoteFilesDBTableUnit,
  LookedServiceNotesPostgresTable,
  DepartmentSetReadService,
  DocumentCreatingDefaultInfoReadService,
  StandardEmployeeDocumentKindAccessRightsService,
  DocumentKindWorkCycleInfoAppService,
  DocumentKindsMapper,
  BasedOnDatabaseDepartmentSetReadService,
  BasedOnDatabaseDepartmentApproveableDocumentSetReadService,
  BasedOnDatabaseDepartmentOutcomingDocumentSetReadService,
  BasedOnDatabaseDepartmentIncomingDocumentSetReadService,
  BasedOnDBPersonnelOrderSubKindSetReadService,
  BasedOnDatabaseEmployeePersonnelOrderSetReadService,
  PostgresEmployeeOutcomingServiceNoteSetFetchingQueryBuilder,
  PostgresEmployeeIncomingServiceNoteSetFetchingQueryBuilder,
  PostgresEmployeeApproveableServiceNoteSetFetchingQueryBuilder,
  PostgresEmployeeInternalServiceNoteSetFetchingQueryBuilder,
  PostgresDepartmentApproveableServiceNoteSetFetchingQueryBuilder,
  PostgresDepartmentOutcomingServiceNoteSetFetchingQueryBuilder,
  PostgresDepartmentIncomingServiceNoteSetFetchingQueryBuilder,
  BasedOnDatabasePersonnelOrderCreatingDefaultInfoReadService,
  BasedOnDBPlantStructureAccessService,
  PostgresDocumentFullInfoFetchingQueryBuilder,
  PostgresIncomingDocumentFullInfoFetchingQueryBuilder,
  PostgresPersonnelOrderFullInfoFetchingQueryBuilder,
  BasedOnDatabaseIncomingDocumentInfoReadService,
  PostgresIncomingServiceNoteFullInfoFetchingQueryBuilder,
  DocumentTableDefsFactoryRegistry,
  PersonnelOrderTableDefsFactory,
  StandardPersonnelOrderSignerSetReadService,
  StandardPersonnelOrderApproverSetReadService,
  PostgresEmployeePersonnelOrderSetFetchingQueryBuilder,
  DocumentsDomainRegistries,
  BasedOnDatabasePersonnelOrderInfoReadService,
  BasedOnDatabaseDepartmentPersonnelOrderSetReadService,
  PostgresDepartmentPersonnelOrderSetFetchingQueryBuilder,
  DocumentDTOFromDataSetMapper,
  DocumentChargeSheetsInfoDTOFromDataSetMapper,
  DocumentChargesInfoDTOFromDataSetMapper,
  DocumentRelationsInfoDTOFromDataSetMapper,
  DocumentFilesInfoDTOFromDataSetMapper,
  DocumentApprovingsInfoDTOFromDataSetMapper,
  DocumentApprovingCycleResultsInfoDTOFromDataSetMapper,
  DocumentInfoHolderBuilder,
  PostgresDocumentInfoQueryBuilder,
  DocumentPerformingInfoHolderBuilder,
  PostgresDocumentPerformingInfoQueryBuilder,
  DocumentRelationsInfoHolderBuilder,
  PostgresDocumentRelationsInfoQueryBuilder,
  DocumentFullInfoDTOFromDataSetMapper,
  IncomingDocumentFullInfoDTOFromDataSetMapper,
  DocumentFilesInfoHolderBuilder,
  PostgresDocumentFilesInfoQueryBuilder,
  FullDocumentApprovingsInfoHolderBuilder,
  PostgresIncomingDocumentInfoQueryBuilder,
  BasedOnDatabaseIncomingDocumentInfoPartlyReadService,
  PostgresServiceNoteSubstitutedInfoQueryBuilder,
  PersonnelOrderFullInfoDTOFromDataSetMapper,
  PersonnelOrderDTOFromDataSetMapper,
  IncomingDocumentInfoHolderBuilder,
  FullDocumentApprovingsInfoQueryBuilder,
  IncomingDocumentDTOFromDataSetMapper,
  EmployeeDocumentKindAccessRightsAppService,
  DTODomainMapperRegistry,
  ApplicationServiceRegistries,
  Document,
  Employee;

{ TPresentationServiceRegistryConfigurator }

procedure TPresentationServiceRegistryConfigurator.ConfigurePresentationServiceRegistry(
  PresentationServiceRegistry: TPresentationServiceRegistry;
  ConfigurationData: TPresentationServiceRegistryConfigurationData
);
var
    EmployeeSetReadService: IEmployeeSetReadService;

    EmployeeSubordinationService: IEmployeeSubordinationService;
    EmployeeChargePerformingService: IEmployeeChargePerformingService;

    QueryExecutor: TDataSetQueryExecutor;
    FreeQueryExecutor: IQueryExecutor;

    DocumentDbSchemaData: TDocumentDbSchemaData;
    FreeDocumentDbSchemaData: IDisposable;

    DocumentInfoReadService: IDocumentInfoReadService;
    IncomingServiceNoteInfoReadService: IDocumentInfoReadService;
    CreatingDefaultInfoReadService: IDocumentCreatingDefaultInfoReadService;

    DocumentKindDbSchema: TDocumentKindDbSchema;

    OutcomingDocumentKindWorkCycleInfoAppService: IDocumentKindWorkCycleInfoAppService;

    BaseServiceDocumentKind: TNativeDocumentKindClass;

    DocumentKindsMapper: IDocumentKindsMapper;
begin

  DoCommonPresentationServiceRegistryConfiguration(
    PresentationServiceRegistry,
    ConfigurationData
  );

  if not FIsCommonConfigurationDone then
    DoCommonPresentationServiceRegistryConfiguration(PresentationServiceRegistry, ConfigurationData);

  EmployeeSetReadService := PresentationServiceRegistry.GetEmployeeSetReadService;

  DocumentKindsMapper := TDTODomainMapperRegistry.Instance.GetDocumentKindsMapper;
  
  QueryExecutor :=
    TZQueryExecutor.Create(
      TZConnection(ConfigurationData.DatabaseConnection)
    );

  FreeQueryExecutor := QueryExecutor;

  EmployeeSubordinationService :=
    TDomainRegistries
      .EmployeesDomainRegistries
        .ServiceRegistry
          .EmployeeSubordinationServiceRegistry
            .GetEmployeeSubordinationService;


  EmployeeChargePerformingService :=
    TDomainRegistries
      .EmployeesDomainRegistries
        .ServiceRegistry
          .EmployeePerformingServiceRegistry
            .GetEmployeeChargePerformingService;

  if Assigned(ConfigurationData.DocumentKind) then
    BaseServiceDocumentKind := ConfigurationData.DocumentKind

  else BaseServiceDocumentKind := ConfigurationData.OutcomingDocumentKind;

  if BaseServiceDocumentKind <> TPersonnelOrderKind then begin
  
    CreatingDefaultInfoReadService :=
      TBasedOnDatabaseDocumentCreatingDefaultInfoReadService.Create(
        TEmployeesDomainRegistries.ServiceRegistry.EmployeeSearchServiceRegistry.GetEmployeeFinder,
        EmployeeSubordinationService,
        QueryExecutor,
        TPostgresDocumentCreatingDefaultInfoFetchingQueryBuilder.Create
      );

  end

  else CreatingDefaultInfoReadService := nil;

  if Assigned(BaseServiceDocumentKind) then begin

    if Assigned(CreatingDefaultInfoReadService) then begin

      PresentationServiceRegistry.RegisterDocumentCreatingDefaultInfoReadService(
        BaseServiceDocumentKind,
        CreatingDefaultInfoReadService
      );

    end;

    PresentationServiceRegistry.RegisterDocumentSignerSetReadService(
      BaseServiceDocumentKind,
      TStandardDocumentSignerSetReadService.Create(
        ConfigurationData.RepositoryRegistry.GetEmployeeRepository,
        EmployeeSubordinationService,
        EmployeeSetReadService
      )
    );

    PresentationServiceRegistry.RegisterDocumentResponsibleSetReadService(
      BaseServiceDocumentKind,
      TStandardDocumentResponsibleSetReadService.Create(
        EmployeeSetReadService
      )
    );

    PresentationServiceRegistry.RegisterDocumentChargePerformerSetReadService(
      BaseServiceDocumentKind,
      TStandardDocumentChargePerformerSetReadService.Create(
        ConfigurationData.RepositoryRegistry.GetEmployeeRepository,
        EmployeeChargePerformingService,
        EmployeeSetReadService
      )
    );

    PresentationServiceRegistry.RegisterDocumentChargeSheetPerformerSetReadService(
      BaseServiceDocumentKind,
      TStandardDocumentChargeSheetPerformerSetReadService.Create(
        ConfigurationData.RepositoryRegistry.GetEmployeeRepository,
        EmployeeChargePerformingService,
        EmployeeSetReadService
      )
    );

    OutcomingDocumentKindWorkCycleInfoAppService :=
      TStandardDocumentKindWorkCycleInfoAppService.Create(
        TStandardDocumentKindWorkCycleInfoService.Create(

          TDomainRegistries
            .DocumentsDomainRegistries
              .ServiceRegistry
                .DocumentSearchServiceRegistry
                  .GetDocumentKindFinder,

          TDomainRegistries
            .DocumentsDomainRegistries
              .ServiceRegistry
                .DocumentSearchServiceRegistry
                  .GetDocumentWorkCycleFinder(
                    TDTODomainMapperRegistry.Instance.GetDocumentKindsMapper.MapDocumentKindToDomainDocumentKind(
                      BaseServiceDocumentKind
                    )
                  )
        )
      );

    PresentationServiceRegistry.RegisterDocumentKindWorkCycleInfoAppService(
      BaseServiceDocumentKind,
      OutcomingDocumentKindWorkCycleInfoAppService
    );


    if Assigned(ConfigurationData.ApproveableDocumentKind) then begin

      PresentationServiceRegistry.RegisterDocumentKindWorkCycleInfoAppService(
        ConfigurationData.ApproveableDocumentKind,
        OutcomingDocumentKindWorkCycleInfoAppService
      );

    end;
    
    if BaseServiceDocumentKind = TOutcomingServiceNoteKind
    then begin

      RegisterServiceNotePresentationServices(
        PresentationServiceRegistry, ConfigurationData, QueryExecutor
      );
      
    end

    else if BaseServiceDocumentKind = TPersonnelOrderKind then begin

      RegisterPersonnelOrderPresentationServices(
        PresentationServiceRegistry,
        ConfigurationData,
        QueryExecutor
      );
      
    end;

    
  end;

  if Assigned(ConfigurationData.OutcomingInternalDocumentKind) then begin

    PresentationServiceRegistry.RegisterDocumentCreatingDefaultInfoReadService(
      ConfigurationData.OutcomingInternalDocumentKind,
      CreatingDefaultInfoReadService
    );

    PresentationServiceRegistry.RegisterDocumentSignerSetReadService(
      ConfigurationData.OutcomingInternalDocumentKind,
      TStandardInternalDocumentSignerSetReadService.Create(
        ConfigurationData.RepositoryRegistry.GetEmployeeRepository,
        EmployeeSubordinationService,
        EmployeeSetReadService
      )
    );

    PresentationServiceRegistry.RegisterDocumentResponsibleSetReadService(
      ConfigurationData.OutcomingInternalDocumentKind,
      TStandardInternalDocumentResponsibleSetReadService.Create(
        EmployeeSetReadService
      )
    );

    PresentationServiceRegistry.RegisterDocumentChargePerformerSetReadService(
      ConfigurationData.OutcomingInternalDocumentKind,
      TStandardInternalDocumentChargePerformerSetReadService.Create(
        ConfigurationData.RepositoryRegistry.GetEmployeeRepository,
        EmployeeChargePerformingService,
        EmployeeSetReadService
      )
    );

    PresentationServiceRegistry.RegisterDocumentKindWorkCycleInfoAppService(
      ConfigurationData.OutcomingInternalDocumentKind,
      TStandardDocumentKindWorkCycleInfoAppService.Create(
        TStandardDocumentKindWorkCycleInfoService.Create(

          TDomainRegistries
            .DocumentsDomainRegistries
              .ServiceRegistry
                .DocumentSearchServiceRegistry
                  .GetDocumentKindFinder,

          TDomainRegistries
            .DocumentsDomainRegistries
              .ServiceRegistry
                .DocumentSearchServiceRegistry
                  .GetDocumentWorkCycleFinder(
                    TDTODomainMapperRegistry.Instance.GetDocumentKindsMapper.MapDocumentKindToDomainDocumentKind(
                      ConfigurationData.OutcomingInternalDocumentKind
                    )
                  )
        )
      )
    );

  end;

  if Assigned(ConfigurationData.IncomingDocumentKind) then begin

    PresentationServiceRegistry.RegisterDocumentChargeSheetPerformerSetReadService(
      ConfigurationData.IncomingDocumentKind,
      TStandardDocumentChargeSheetPerformerSetReadService.Create(
        ConfigurationData.RepositoryRegistry.GetEmployeeRepository,
        EmployeeChargePerformingService,
        EmployeeSetReadService
      )
    );

    PresentationServiceRegistry.RegisterDocumentKindWorkCycleInfoAppService(
      ConfigurationData.IncomingDocumentKind,
      TStandardDocumentKindWorkCycleInfoAppService.Create(
        TStandardDocumentKindWorkCycleInfoService.Create(

          TDomainRegistries
            .DocumentsDomainRegistries
              .ServiceRegistry
                .DocumentSearchServiceRegistry
                  .GetDocumentKindFinder,

          TDomainRegistries
            .DocumentsDomainRegistries
              .ServiceRegistry
                .DocumentSearchServiceRegistry
                  .GetDocumentWorkCycleFinder(
                    TDTODomainMapperRegistry.Instance.GetDocumentKindsMapper.MapDocumentKindToDomainDocumentKind(
                      ConfigurationData.IncomingDocumentKind
                    )
                  )
        )
      )
    );

  end;

  if Assigned(ConfigurationData.IncomingInternalDocumentKind) then begin

    PresentationServiceRegistry.RegisterDocumentChargePerformerSetReadService(
      ConfigurationData.IncomingInternalDocumentKind,
      TStandardIncomingInternalDocumentChargePerformerSetReadService.Create(
        ConfigurationData.RepositoryRegistry.GetEmployeeRepository,
        EmployeeChargePerformingService,
        EmployeeSetReadService
      )
    );

    PresentationServiceRegistry.RegisterDocumentKindWorkCycleInfoAppService(
      ConfigurationData.IncomingInternalDocumentKind,
      TStandardDocumentKindWorkCycleInfoAppService.Create(
        TStandardDocumentKindWorkCycleInfoService.Create(

          TDomainRegistries
            .DocumentsDomainRegistries
              .ServiceRegistry
                .DocumentSearchServiceRegistry
                  .GetDocumentKindFinder,

          TDomainRegistries
            .DocumentsDomainRegistries
              .ServiceRegistry
                .DocumentSearchServiceRegistry
                  .GetDocumentWorkCycleFinder(
                    TDTODomainMapperRegistry.Instance.GetDocumentKindsMapper.MapDocumentKindToDomainDocumentKind(
                      ConfigurationData.IncomingInternalDocumentKind
                    )
                  )
        )
      )
    );

  end;
  //----------------------------------------------------------------------------
  PresentationServiceRegistry.RegisterDocumentApproverSetReadService(
    BaseServiceDocumentKind,
    TStandardDocumentApproverSetReadService.Create(EmployeeSetReadService)
  );
  
end;

procedure TPresentationServiceRegistryConfigurator.RegisterServiceNotePresentationServices(
  PresentationServiceRegistry: TPresentationServiceRegistry;
  ConfigurationData: TPresentationServiceRegistryConfigurationData;
  QueryExecutor: TAbstractQueryExecutor
);
var

    DocumentDbSchemaData: TDocumentDbSchemaData;
    FreeDocumentDbSchemaData: IDisposable;
    IncomingServiceNoteInfoReadService: IDocumentInfoReadService;
    EmployeeDocumentKindAccessRightsAppService: IEmployeeDocumentKindAccessRightsAppService;
    BaseServiceDocumentKind: TDocumentKindClass;
    BaseDomainDocumentKind: TDocumentClass;

    DocumentInfoDTOFromDataSetMappers: TDocumentInfoDTOFromDataSetMappers;
    DocumentInfoHolderBuilders: TDocumentInfoHolderBuilders;
begin

  {
    refactor: получать объекты схем из соответствующей фабрики
    persistence-слоя
  }
  DocumentDbSchemaData :=
      TDocumentDbSchemaData
        .Create
        .SetDocumentTableName(SERVICE_NOTE_TABLE_NAME)
        .SetDocumentChargesTableName(SERVICE_NOTE_CHARGE_SHEET_TABLE_NAME)
        .SetDocumentLinksTableName(SERVICE_NOTE_LINKS_TABLE_NAME)
        .SetDocumentApprovingsTableName(SERVICE_NOTE_APPROVINGS_TABLE_NAME)
        .SetDocumentFileMetadataTableName(SERVICE_NOTE_FILES_TABLE_NAME)
        .SetLookedDocumentsTableName(LOOKED_SERVICE_NOTES_TABLE_NAME)
        .SetDocumentSigningsTableName(SERVICE_NOTE_SIGNING_TABLE_NAME);

  FreeDocumentDbSchemaData := DocumentDbSchemaData;

  EmployeeDocumentKindAccessRightsAppService :=
    TApplicationServiceRegistries
      .Current
        .GetDocumentBusinessProcessServiceRegistry
          .GetEmployeeDocumentKindAccessRightsAppService;

  if Assigned(ConfigurationData.DocumentKind) then
    BaseServiceDocumentKind := ConfigurationData.DocumentKind

  else BaseServiceDocumentKind := ConfigurationData.OutcomingDocumentKind;

  BaseDomainDocumentKind :=
    TDTODomainMapperRegistry
      .Instance
        .GetDocumentKindsMapper
          .MapDocumentKindToDomainDocumentKind(BaseServiceDocumentKind);

  if Assigned(BaseServiceDocumentKind) then begin

    with DocumentInfoDTOFromDataSetMappers do begin

      DocumentDTOFromDataSetMapper := TDocumentDTOFromDataSetMapper.Create;
      DocumentFilesInfoDTOFromDataSetMapper := TDocumentFilesInfoDTOFromDataSetMapper.Create;
      DocumentRelationsInfoDTOFromDataSetMapper := TDocumentRelationsInfoDTOFromDataSetMapper.Create;
      DocumentChargesInfoDTOFromDataSetMapper := TDocumentChargesInfoDTOFromDataSetMapper.Create;
      DocumentChargeSheetsInfoDTOFromDataSetMapper := TDocumentChargeSheetsInfoDTOFromDataSetMapper.Create;
      DocumentApprovingsInfoDTOFromDataSetMapper := TDocumentApprovingsInfoDTOFromDataSetMapper.Create;

      DocumentApprovingCycleResultsInfoDTOFromDataSetMapper :=
        TDocumentApprovingCycleResultsInfoDTOFromDataSetMapper.Create(
          DocumentApprovingsInfoDTOFromDataSetMapper
        );

    end;

    with DocumentInfoHolderBuilders do begin

      DocumentInfoHolderBuilder :=
        TDocumentInfoHolderBuilder.Create(
          TDataSetQueryExecutor(QueryExecutor),
          TPostgresDocumentInfoQueryBuilder.Create(
            TDocumentTableDefsFactoryRegistry
              .Instance
                .GetDocumentTableDefsFactory(BaseDomainDocumentKind)
                  .GetDocumentTableDef
          )
        );

      FullDocumentApprovingsInfoHolderBuilder :=
        TFullDocumentApprovingsInfoHolderBuilder.Create(
          TFullDocumentApprovingsInfoQueryBuilder.Create(
            TDocumentTableDefsFactoryRegistry
              .Instance
                .GetDocumentTableDefsFactory(BaseDomainDocumentKind)
                  .GetDocumentApprovingsTableDef
          ),
          TDataSetQueryExecutor(QueryExecutor)
        );

      DocumentRelationsInfoHolderBuilder :=
        TDocumentRelationsInfoHolderBuilder.Create(
          TPostgresDocumentRelationsInfoQueryBuilder.Create(
            TDocumentTableDefsFactoryRegistry
              .Instance
                .GetDocumentTableDefsFactory(BaseDomainDocumentKind)
                  .GetDocumentRelationsTableDef
          ),
          TDataSetQueryExecutor(QueryExecutor)
        );

      DocumentFilesInfoHolderBuilder :=
        TDocumentFilesInfoHolderBuilder.Create(
          TPostgresDocumentFilesInfoQueryBuilder.Create(
            TDocumentTableDefsFactoryRegistry
              .Instance
                .GetDocumentTableDefsFactory(BaseDomainDocumentKind)
                  .GetDocumentFilesTableDef
          ),
          TDataSetQueryExecutor(QueryExecutor)
        );

      DocumentPerformingInfoHolderBuilder :=
        TDocumentPerformingInfoHolderBuilder.Create(
          TPostgresDocumentPerformingInfoQueryBuilder.Create(
            TDocumentTableDefsFactoryRegistry
              .Instance
                .GetDocumentTableDefsFactory(BaseDomainDocumentKind)
                  .GetDocumentChargeKindTableDef,
                
            TDocumentTableDefsFactoryRegistry
              .Instance
                .GetDocumentTableDefsFactory(BaseDomainDocumentKind)
                  .GetDocumentChargeTableDef,

            TDocumentTableDefsFactoryRegistry
              .Instance
                .GetDocumentTableDefsFactory(BaseDomainDocumentKind)
                  .GetDocumentChargeSheetTableDef
          ),
          TDataSetQueryExecutor(QueryExecutor)
        );
        
    end;

    with DocumentInfoDTOFromDataSetMappers do begin

      PresentationServiceRegistry.RegisterDocumentInfoReadService(
        BaseServiceDocumentKind,
        TBasedOnDatabaseDocumentInfoPartlyReadService.Create(
          DocumentInfoDTOFromDataSetMappers,
          DocumentInfoHolderBuilders
        )
      );

    end;

    PresentationServiceRegistry.RegisterEmployeeDocumentSetReadService(
      BaseServiceDocumentKind,
      TBasedOnDatabaseEmployeeOutcomingDocumentSetReadService.Create(
        BaseServiceDocumentKind,
        ConfigurationData.RepositoryRegistry.GetEmployeeRepository,
        EmployeeDocumentKindAccessRightsAppService,
        TDataSetQueryExecutor(QueryExecutor),
        TPostgresEmployeeOutcomingServiceNoteSetFetchingQueryBuilder.Create
      )
    );

    PresentationServiceRegistry.RegisterDepartmentDocumentSetReadService(
      ConfigurationData.OutcomingDocumentKind,
      TBasedOnDatabaseDepartmentOutcomingDocumentSetReadService.Create(
        TDataSetQueryExecutor(QueryExecutor),
        TPostgresDepartmentOutcomingServiceNoteSetFetchingQueryBuilder.Create
      )
    );

  end;
                      
  if Assigned(ConfigurationData.OutcomingInternalDocumentKind) then begin

    PresentationServiceRegistry.RegisterEmployeeDocumentSetReadService(
      ConfigurationData.OutcomingInternalDocumentKind,
      TBasedOnDatabaseEmployeeInternalDocumentSetReadService.Create(
        ConfigurationData.OutcomingInternalDocumentKind,
        ConfigurationData.RepositoryRegistry.GetEmployeeRepository,
        EmployeeDocumentKindAccessRightsAppService,
        TDataSetQueryExecutor(QueryExecutor),
        TPostgresEmployeeInternalServiceNoteSetFetchingQueryBuilder.Create
      )
    );

  end;

  with DocumentInfoHolderBuilders, DocumentInfoDTOFromDataSetMappers do begin

    DocumentInfoHolderBuilder :=
      TIncomingDocumentInfoHolderBuilder.Create(

        TDataSetQueryExecutor(QueryExecutor),

        TPostgresIncomingDocumentInfoQueryBuilder.Create(

          TPostgresServiceNoteSubstitutedInfoQueryBuilder.Create(

            TDocumentTableDefsFactoryRegistry.Instance.GetDocumentTableDefsFactory(
              BaseDomainDocumentKind
            ).GetDocumentTableDef
          ),

          TDocumentTableDefsFactoryRegistry.Instance.GetDocumentTableDefsFactory(
            BaseDomainDocumentKind
          ).GetDocumentTableDef,

          TDocumentTableDefsFactoryRegistry.Instance.GetDocumentTableDefsFactory(
            BaseDomainDocumentKind
          ).GetIncomingDocumentTableDef
        ),

        TDocumentInfoHolderBuilder(DocumentInfoHolderBuilder.Self)
      );

      DocumentDTOFromDataSetMapper :=
        TIncomingDocumentDTOFromDataSetMapper.Create(
          DocumentDTOFromDataSetMapper
        );

    
    IncomingServiceNoteInfoReadService :=
      TBasedOnDatabaseIncomingDocumentInfoPartlyReadService.Create(
        DocumentInfoDTOFromDataSetMappers,
        DocumentInfoHolderBuilders
      );

  end;

  if Assigned(ConfigurationData.IncomingDocumentKind) then begin

    PresentationServiceRegistry.RegisterDocumentInfoReadService(
      ConfigurationData.IncomingDocumentKind,
      IncomingServiceNoteInfoReadService
    );

    PresentationServiceRegistry.RegisterEmployeeDocumentSetReadService(
      ConfigurationData.IncomingDocumentKind,
      TBasedOnDatabaseEmployeeIncomingDocumentSetReadService.Create(
        ConfigurationData.IncomingDocumentKind,
        ConfigurationData.RepositoryRegistry.GetEmployeeRepository,
        EmployeeDocumentKindAccessRightsAppService,
        TDataSetQueryExecutor(QueryExecutor),
        TPostgresEmployeeIncomingServiceNoteSetFetchingQueryBuilder.Create
      )
    );

    PresentationServiceRegistry.RegisterDepartmentDocumentSetReadService(
      ConfigurationData.IncomingDocumentKind,
      TBasedOnDatabaseDepartmentIncomingDocumentSetReadService.Create(
        TDataSetQueryExecutor(QueryExecutor),
        TPostgresDepartmentIncomingServiceNoteSetFetchingQueryBuilder.Create
      )
    );

  end;

  if Assigned(ConfigurationData.IncomingInternalDocumentKind) then begin

    PresentationServiceRegistry.RegisterDocumentInfoReadService(
      ConfigurationData.IncomingInternalDocumentKind,
      IncomingServiceNoteInfoReadService
    );

  end;

  if Assigned(ConfigurationData.ApproveableDocumentKind) then begin

    PresentationServiceRegistry.RegisterEmployeeDocumentSetReadService(
      ConfigurationData.ApproveableDocumentKind,
      TBasedOnDatabaseEmployeeApproveableDocumentSetReadService.Create(
        ConfigurationData.ApproveableDocumentKind,
        ConfigurationData.RepositoryRegistry.GetEmployeeRepository,
        EmployeeDocumentKindAccessRightsAppService,
        TDataSetQueryExecutor(QueryExecutor),
        TPostgresEmployeeApproveableServiceNoteSetFetchingQueryBuilder.Create
      )
    );

    PresentationServiceRegistry.RegisterDepartmentDocumentSetReadService(
      ConfigurationData.ApproveableDocumentKind,
      TBasedOnDatabaseDepartmentApproveableDocumentSetReadService.Create(
        TDataSetQueryExecutor(QueryExecutor),
        TPostgresDepartmentApproveableServiceNoteSetFetchingQueryBuilder.Create
      )
    );

  end;

end;

procedure TPresentationServiceRegistryConfigurator
  .DoCommonPresentationServiceRegistryConfiguration(
    PresentationServiceRegistry: TPresentationServiceRegistry;
    ConfigurationData: TPresentationServiceRegistryConfigurationData
  );
var
    DocumentKindDbSchema: TDocumentKindDbSchema;

    NativeDocumentKindsReadService: INativeDocumentKindsReadService;
    SDItemsService: ISDItemsService;
    QueryExecutor: IQueryExecutor;

    EmployeeDbSchema: TEmployeeDbSchema;
    DepartmentDbSchema: TDepartmentDbSchema;
    RoleDbSchema: TRoleDbSchema;
    EmployeeWorkGroupAssociationDbSchema: TEmployeeWorkGroupAssociationDbSchema;

    EmployeeSetReadService: IEmployeeSetReadService;
begin

  if FIsCommonConfigurationDone then Exit;
  
  DocumentKindDbSchema := TDocumentKindDbSchema.Create;

  DocumentKindDbSchema.TableName := DOCUMENT_TYPES_TABLE_NAME;
  DocumentKindDbSchema.IdColumnName := DOCUMENT_TYPES_TABLE_ID_FIELD;
  DocumentKindDbSchema.ParentKindIdColumnName := DOCUMENT_TYPES_TABLE_PARENT_TYPE_ID;
  DocumentKindDbSchema.NameColumnName := DOCUMENT_TYPES_TABLE_NAME_FIELD;
  DocumentKindDbSchema.IsPresentedColumnName := DOCUMENT_TYPES_TABLE_IS_PRESENTED_FIELD;
  DocumentKindDbSchema.IsServicedColumnName := 'is_serviced';
  
  QueryExecutor :=
    TZQueryExecutor.Create(TZConnection(ConfigurationData.DatabaseConnection));
    
  NativeDocumentKindsReadService :=
    TBasedOnDatabaseNativeDocumentKindsReadService.Create(
      DocumentKindDbSchema,
      QueryExecutor,
      TNumericDocumentKindResolver.Create
    );

  try

    SDItemsService :=
      TBasedOnZeosPostgresSDItemsService.Create(
        TZConnection(ConfigurationData.DatabaseConnection)
      );

    PresentationServiceRegistry.RegisterSDItemsService(SDItemsService);

  except

    SDItemsService := nil;

  end;

  //----------------------------------------------------------------------------
  PresentationServiceRegistry.RegisterPlantItemService(
    TBasedOnZeosVclPlantItemService.Create(
      TZConnection(ConfigurationData.DatabaseConnection),
      TBasedOnDBPlantStructureAccessService.Create(
        QueryExecutor
      )
    )
  );
  //----------------------------------------------------------------------------
  PresentationServiceRegistry.RegisterGlobalDocumentKindsReadService(
    TStandardGlobalDocumentKindsReadService.Create(
      NativeDocumentKindsReadService,
      SDItemsService,
      PresentationServiceRegistry.GetPlantItemService
    )
  );
  //----------------------------------------------------------------------------
  PresentationServiceRegistry.RegisterNativeDocumentKindsReadService(
    NativeDocumentKindsReadService
  );
  //----------------------------------------------------------------------------
  EmployeeDbSchema := TEmployeeDbSchema.Create;

  EmployeeDbSchema.TableName := EMPLOYEE_TABLE_NAME;
  EmployeeDbSchema.IdColumnName := EMPLOYEE_TABLE_ID_FIELD;
  EmployeeDbSchema.PersonnelNumberColumnName := EMPLOYEE_TABLE_PERSONNEL_NUMBER_FIELD;
  EmployeeDbSchema.NameColumnName := EMPLOYEE_TABLE_NAME_FIELD;
  EmployeeDbSchema.SurnameColumnName := EMPLOYEE_TABLE_SURNAME_FIELD;
  EmployeeDbSchema.PatronymicColumnName := EMPLOYEE_TABLE_PATRONYMIC_FIELD;
  EmployeeDbSchema.SpecialityColumnName := EMPLOYEE_TABLE_SPECIALITY_FIELD;
  EmployeeDbSchema.DepartmentIdColumnName := EMPLOYEE_TABLE_DEPARTMENT_ID_FIELD;
  EmployeeDbSchema.HeadKindredDepartmentIdColumnName := EMPLOYEE_TABLE_HEAD_KINDRED_DEPARTMENT_ID_FIELD;
  EmployeeDbSchema.TelephoneNumberColumnName := EMPLOYEE_TABLE_TELEPHONE_NUMBER_FIELD;
  EmployeeDbSchema.IsForeignColumnName := EMPLOYEE_TABLE_IS_FOREIGN_FIELD;
  EmployeeDbSchema.WasDismissedColumnName := EMPLOYEE_TABLE_IS_DISMISSED_FIELD;
  EmployeeDbSchema.IsSDUserColumnName := EMPLOYEE_TABLE_IS_SD_USER_FIELD;
  EmployeeDbSchema.TopLevelEmployeeIdColumnName := EMPLOYEE_TABLE_LEADER_ID_FIELD;
  
  DepartmentDbSchema := TDepartmentDbSchema.Create;

  DepartmentDbSchema.TableName := DEPARTMENT_TABLE_NAME;
  DepartmentDbSchema.IdColumnName := DEPARTMENT_TABLE_ID_FIELD;
  DepartmentDbSchema.CodeColumnName := DEPARTMENT_TABLE_CODE_FIELD;
  DepartmentDbSchema.ShortNameColumnName := DEPARTMENT_TABLE_SHORT_NAME_FIELD;
  DepartmentDbSchema.FullNameColumnName := DEPARTMENT_TABLE_FULL_NAME_FIELD;

  RoleDbSchema := TRoleDbSchema.Create;

  RoleDbSchema.TableName := ROLE_TABLE_NAME;
  RoleDbSchema.IdColumnName := ROLE_TABLE_ID_FIELD;
  RoleDbSchema.RoleNameColumnName := ROLE_TABLE_DESCRIPTION_FIELD;

  EmployeeWorkGroupAssociationDbSchema := TEmployeeWorkGroupAssociationDbSchema.Create;

  EmployeeWorkGroupAssociationDbSchema.TableName := EMPLOYEE_WORK_GROUPS_ASSOCIATION_TABLE_NAME;
  EmployeeWorkGroupAssociationDbSchema.EmployeeIdColumnName := EMPLOYEE_WORK_GROUPS_ASSOCIATION_TABLE_EMPLOYEE_ID_FIELD;
  EmployeeWorkGroupAssociationDbSchema.WorkGroupIdColumnName := EMPLOYEE_WORK_GROUPS_ASSOCIATION_TABLE_WORK_GROUP_ID_FIELD;

  PresentationServiceRegistry
    .RegisterEmployeeSetReadService(
      TBasedOnDatabaseEmployeeSetReadService.Create(
        EmployeeDbSchema,
        DepartmentDbSchema,
        RoleDbSchema,
        EmployeeWorkGroupAssociationDbSchema,
        TDataSetQueryExecutor(QueryExecutor.Self)
      )
    );

  DepartmentDbSchema.InActiveStatusColumnName := DEPARTMENT_TABLE_INACTIVE_STATUS_FIELD;

  PresentationServiceRegistry.RegisterDepartmentSetReadService(
    TBasedOnDatabaseDepartmentSetReadService.Create(
      TDataSetQueryExecutor(QueryExecutor.Self),
      DepartmentDbSchema
    )
  );

  FIsCommonConfigurationDone := True;

end;

procedure TPresentationServiceRegistryConfigurator.RegisterPersonnelOrderPresentationServices(
  PresentationServiceRegistry: TPresentationServiceRegistry;
  ConfigurationData: TPresentationServiceRegistryConfigurationData;
  QueryExecutor: IQueryExecutor
);
var
    DocumentKindsMapper: IDocumentKindsMapper;
begin

  DocumentKindsMapper := TDTODomainMapperRegistry.Instance.GetDocumentKindsMapper;
  
  with
      PresentationServiceRegistry,
      PresentationServiceRegistry.GetPersonnelOrderPresentationServiceRegistry
  do begin

    RegisterDocumentCreatingDefaultInfoReadService(
      TPersonnelOrderKind,
      TBasedOnDatabasePersonnelOrderCreatingDefaultInfoReadService.Create(
        TEmployeesDomainRegistries.ServiceRegistry.EmployeeSearchServiceRegistry.GetEmployeeFinder,
        TEmployeesDomainRegistries.ServiceRegistry.EmployeeSubordinationServiceRegistry.GetEmployeeSubordinationService,
        TAbstractQueryExecutor(QueryExecutor.Self),
        TPostgresDocumentCreatingDefaultInfoFetchingQueryBuilder.Create,
        TDomainRegistries.DocumentsDomainRegistries.PersonnelOrderDomainRegistries.ServiceRegistries.PersonnelOrderSearchServiceRegistry.GetPersonnelOrderSignerListFinder
      )
    );

    RegisterDocumentInfoReadService(
      TPersonnelOrderKind,
      TBasedOnDatabasePersonnelOrderInfoReadService.Create(
        TAbstractQueryExecutor(QueryExecutor.Self),
        TPostgresPersonnelOrderFullInfoFetchingQueryBuilder.Create(
          TPersonnelOrderTableDefsFactory(
            TDocumentTableDefsFactoryRegistry.Instance.GetDocumentTableDefsFactory(
              DocumentKindsMapper.MapDocumentKindToDomainDocumentKind(
                TPersonnelOrderKind
              )
            )
          )
        ),
        TPersonnelOrderFullInfoDTOFromDataSetMapper.Create(
          TPersonnelOrderDTOFromDataSetMapper.Create,
          TDocumentApprovingsInfoDTOFromDataSetMapper.Create,
          TDocumentApprovingCycleResultsInfoDTOFromDataSetMapper.Create(
            TDocumentApprovingsInfoDTOFromDataSetMapper.Create
          ),
          TDocumentChargesInfoDTOFromDataSetMapper.Create,
          TDocumentChargeSheetsInfoDTOFromDataSetMapper.Create,
          TDocumentRelationsInfoDTOFromDataSetMapper.Create,
          TDocumentFilesInfoDTOFromDataSetMapper.Create
        )
      )
    );

    RegisterEmployeeDocumentSetReadService(
      TPersonnelOrderKind,
      TBasedOnDatabaseEmployeePersonnelOrderSetReadService.Create(
        TPersonnelOrderKind,
        ConfigurationData.RepositoryRegistry.GetEmployeeRepository,
        TApplicationServiceRegistries.Current.GetDocumentBusinessProcessServiceRegistry.GetEmployeeDocumentKindAccessRightsAppService,
        TDataSetQueryExecutor(QueryExecutor.Self),
        TPostgresEmployeePersonnelOrderSetFetchingQueryBuilder.Create
      )
    );

    RegisterDepartmentDocumentSetReadService(
      TPersonnelOrderKind,
      TBasedOnDatabaseDepartmentPersonnelOrderSetReadService.Create(
        TDataSetQueryExecutor(QueryExecutor.Self),
        TPostgresDepartmentPersonnelOrderSetFetchingQueryBuilder.Create
      )
    );
    
    RegisterPersonnelOrderSignerSetReadService(
      TStandardPersonnelOrderSignerSetReadService.Create(

        TDomainRegistries.DocumentsDomainRegistries
          .PersonnelOrderDomainRegistries
            .ServiceRegistries
              .PersonnelOrderSearchServiceRegistry
                .GetPersonnelOrderSignerListFinder,
              
        GetEmployeeSetReadService
      )
    );

    RegisterPersonnelOrderSubKindSetReadService(
      TBasedOnDBPersonnelOrderSubKindSetReadService.Create(
        QueryExecutor,

        TPersonnelOrderTableDefsFactory(
          TDocumentTableDefsFactoryRegistry.Instance.GetDocumentTableDefsFactory(
            DocumentKindsMapper.MapDocumentKindToDomainDocumentKind(
              TPersonnelOrderKind
            )
          )
        ).CreatePersonnelOrderSubKindTableDef
      )
    );
    
    RegisterPersonnelOrderApproverSetReadService(
      TStandardPersonnelOrderApproverSetReadService.Create(

        TDomainRegistries
          .DocumentsDomainRegistries
            .PersonnelOrderDomainRegistries
              .ServiceRegistries
                .PersonnelOrderSearchServiceRegistry
                  .GetPersonnelOrderApproverListFinder,

        GetEmployeeSetReadService
      )
    );

  end;

end;

end.
