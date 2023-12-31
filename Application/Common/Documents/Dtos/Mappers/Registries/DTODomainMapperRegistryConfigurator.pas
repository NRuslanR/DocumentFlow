unit DTODomainMapperRegistryConfigurator;

interface

uses

  DTODomainMapperRegistry,
  DocumentFullInfoDTOMapper,
  DocumentObjectsDTODomainMapper,
  DocumentChargeSheetInfoDTODomainMapper,
  DocumentChargeSheetsInfoDTODomainMapper,
  DocumentChargeSheetInfoDTODomainMapperRegistry,
  DocumentChargeInfoDTODomainMapper,
  DocumentChargeInfoDTODomainMapperRegistry,
  DocumentChargesInfoDTODomainMapper,
  DocumentKinds,
  DocumentApprovingsInfoDTOMapper,
  DocumentApprovingSheetDataDtoMapper,
  DocumentFlowEmployeeInfoDTOMapper,
  DocumentChargeKindsControlService,
  DocumentKindsMapper,
  NativeDocumentKindsReadService,
  DocumentCharges,
  DocumentDTOMapper,
  AccountingServiceRegistry,
  DocumentChargeSheet,
  TypeObjectRegistry,
  DocumentKind,
  DocumentResponsibleInfoDTOMapper,
  DocumentKindDto,
  Document,
  ServiceNote,
  ApplicationServiceRegistries,
  PersonnelOrder,
  IRepositoryRegistryUnit,
  IncomingDocument,
  DocumentChargeKindDtoDomainMapper,
  DocumentFullInfoJsonMapper,
  DocumentJsonMapper,
  DocumentApprovingsInfoJsonMapper,
  DocumentChargeInfoJsonMapper,
  DocumentChargesInfoJsonMapper,
  DocumentChargeSheetInfoJsonMapper,
  DocumentChargeSheetsInfoJsonMapper,
  DocumentFlowEmployeeInfoJsonMapper,
  DocumentResponsibleInfoJsonMapper,
  IncomingServiceNote,
  SysUtils,
  Classes;

type

  TDTODomainMapperRegistryConfigurationData = record

    RepositoryRegistry: IRepositoryRegistry;
    ApplicationServices: TApplicationServiceRegistries;
    
  end;
  
  IDTODomainMapperRegistryConfigurator = interface

    procedure DoCommonConfiguration(
      Registry: IDTODomainMapperRegistry;
      ConfigurationData: TDTODomainMapperRegistryConfigurationData
    );

    procedure Configure(
      Registry: IDTODomainMapperRegistry;
      ConfigurationData: TDTODomainMapperRegistryConfigurationData
    );
    
  end;
  
  TDTODomainMapperRegistryConfigurator =
    class (TInterfacedObject, IDTODomainMapperRegistryConfigurator)

      private

        FIsCommonConfigurationDone: Boolean;
        
        procedure ConfigureForDocumentKind(
          DocumentKind: TDocumentKindClass;
          Registry: IDTODomainMapperRegistry;
          ConfigurationData: TDTODomainMapperRegistryConfigurationData
        );

        procedure ConfigureDocumentChargeAndChargeSheetMappers(
          Registry: IDTODomainMapperRegistry;
          ConfigurationData: TDTODomainMapperRegistryConfigurationData
        );

        procedure ConfigureDocumentKindsMappers(
          Registry: IDTODomainMapperRegistry;
          ConfigurationData: TDTODomainMapperRegistryConfigurationData
        );

        procedure ConfigureForChargeKind(
          ChargeType: TDocumentChargeClass;
          Registry: IDTODomainMapperRegistry;
          ConfigurationData: TDTODomainMapperRegistryConfigurationData
        );

      public

        procedure DoCommonConfiguration(
          Registry: IDTODomainMapperRegistry;
          ConfigurationData: TDTODomainMapperRegistryConfigurationData
        );
        
        procedure Configure(
          Registry: IDTODomainMapperRegistry;
          ConfigurationData: TDTODomainMapperRegistryConfigurationData
        );

    end;

implementation

uses

  IDomainObjectBaseListUnit,
  DocumentChargeKind,
  DocumentAcquaitance,
  PersonnelOrderDTOMapper,
  DocumentPerforming,
  DocumentViewingAccountingService,
  DocumentAcquaitanceInfoDTODomainMapper,
  IncomingDocumentFullInfoDTOMapper,
  DocumentAcquaitanceSheetInfoDTODomainMapper,
  DocumentPerformingSheetInfoDTODomainMapper,
  DocumentPerformingInfoDTODomainMapper,
  IncomingDocumentDTOMapper,
  PersonnelOrderDTODomainMapper,
  PersonnelOrderFullInfoDTO,
  DocumentNumeratorRegistry,
  DocumentUsageEmployeeAccessRightsInfoDTOMapper,
  DocumentsDomainRegistries;

{ TDTODomainMapperRegistryConfigurator }

procedure TDTODomainMapperRegistryConfigurator.Configure(
  Registry: IDTODomainMapperRegistry;
  ConfigurationData: TDTODomainMapperRegistryConfigurationData
);
begin

  DoCommonConfiguration(Registry, ConfigurationData);

  ConfigureDocumentChargeAndChargeSheetMappers(Registry, ConfigurationData);

  ConfigureDocumentKindsMappers(Registry, ConfigurationData);

end;

procedure TDTODomainMapperRegistryConfigurator
  .ConfigureDocumentChargeAndChargeSheetMappers(
    Registry: IDTODomainMapperRegistry;
    ConfigurationData: TDTODomainMapperRegistryConfigurationData
  );
var
    DocumentChargeKindsControlService: IDocumentChargeKindsControlService;
    DocumentChargeKinds: TDocumentChargeKinds;
    FreeDocumentChargeKinds: IDomainObjectBaseList;
    DocumentChargeKind: TDocumentChargeKind;
begin

  DocumentChargeKindsControlService :=
    TDocumentsDomainRegistries.ServiceRegistry.ChargeServiceRegistry.GetDocumentChargeKindsControlService;

  DocumentChargeKinds :=
    DocumentChargeKindsControlService.GetAllDocumentChargeKinds;

  FreeDocumentChargeKinds := DocumentChargeKinds;

  for DocumentChargeKind in DocumentChargeKinds do
    ConfigureForChargeKind(DocumentChargeKind.ChargeClass, Registry, ConfigurationData);

end;

procedure TDTODomainMapperRegistryConfigurator.ConfigureForChargeKind(
  ChargeType: TDocumentChargeClass;
  Registry: IDTODomainMapperRegistry;
  ConfigurationData: TDTODomainMapperRegistryConfigurationData
);
var
    ChargeInfoDTODomainMapper: IDocumentChargeInfoDTODomainMapper;
    ChargeSheetInfoDTODomainMapper: IDocumentChargeSheetInfoDTODomainMapper;
    RepositoryRegistry: IRepositoryRegistry;
begin

  RepositoryRegistry := ConfigurationData.RepositoryRegistry;

  if ChargeType.InheritsFrom(TDocumentPerforming) then begin

    ChargeInfoDTODomainMapper :=
      TDocumentPerformingInfoDTODomainMapper.Create(
        RepositoryRegistry.GetEmployeeRepository,
        TDocumentsDomainRegistries.ServiceRegistry.ChargeServiceRegistry.GetDocumentChargeCreatingService(ChargeType),
        Registry.GetDocumentFlowEmployeeInfoDTOMapper
      );

    ChargeSheetInfoDTODomainMapper :=
      TDocumentPerformingSheetInfoDTODomainMapper.Create(
        RepositoryRegistry.GetEmployeeRepository,
        ConfigurationData.ApplicationServices.GetAccountingServiceRegistry.GetDocumentChargeSheetViewingAccountingService,
        TDocumentChargeInfoDTODomainMapper(ChargeInfoDTODomainMapper.Self),
        Registry.GetDocumentFlowEmployeeInfoDTOMapper
      );

  end

  else if ChargeType.InheritsFrom(TDocumentAcquaitance) then begin

    ChargeInfoDTODomainMapper :=
      TDocumentAcquaitanceInfoDTODomainMapper.Create(
        RepositoryRegistry.GetEmployeeRepository,
        TDocumentsDomainRegistries.ServiceRegistry.ChargeServiceRegistry.GetDocumentChargeCreatingService(ChargeType),
        Registry.GetDocumentFlowEmployeeInfoDTOMapper
      );

    ChargeSheetInfoDTODomainMapper :=
      TDocumentAcquaitanceSheetInfoDTODomainMapper.Create(
        RepositoryRegistry.GetEmployeeRepository,
        ConfigurationData.ApplicationServices.GetAccountingServiceRegistry.GetDocumentChargeSheetViewingAccountingService,
        TDocumentChargeInfoDTODomainMapper(ChargeInfoDTODomainMapper.Self),
        Registry.GetDocumentFlowEmployeeInfoDTOMapper
      );

  end

  else begin

    Raise Exception.Create('ConfigureForChargeKind error');

  end;

  Registry.RegisterDocumentChargeInfoDTODomainMapper(
    ChargeType,
    ChargeInfoDTODomainMapper
  );

  Registry.RegisterDocumentChargeSheetInfoDTODomainMapper(
    TDocumentChargeSheetClass(ChargeType.ChargeSheetType),
    ChargeSheetInfoDTODomainMapper
  );
  
end;

procedure TDTODomainMapperRegistryConfigurator.ConfigureDocumentKindsMappers(
  Registry: IDTODomainMapperRegistry;
  ConfigurationData: TDTODomainMapperRegistryConfigurationData);
var
    NativeDocumentKindsReadService: INativeDocumentKindsReadService;
    
    DocumentKindDtos: TDocumentKindDtos;
    FreeDocumentKindDtos: IDomainObjectBaseList;
    DocumentKindDto: TDocumentKindDto;
begin

  NativeDocumentKindsReadService :=
    ConfigurationData
      .ApplicationServices
        .GetPresentationServiceRegistry
          .GetNativeDocumentKindsReadService;

  DocumentKindDtos := NativeDocumentKindsReadService.GetServicedDocumentKindDtos;

  try

    for DocumentKindDto in DocumentKindDtos do begin

      ConfigureForDocumentKind(
        DocumentKindDto.ServiceType, Registry, ConfigurationData
      );

    end;

  except

    FreeAndNil(DocumentKindDtos);

    Raise;

  end;

end;

procedure TDTODomainMapperRegistryConfigurator.ConfigureForDocumentKind(
  DocumentKind: TDocumentKindClass;
  Registry: IDTODomainMapperRegistry;
  ConfigurationData: TDTODomainMapperRegistryConfigurationData
);
var
    RepositoryRegistry: IRepositoryRegistry;
    EmployeeDTOMapper: TDocumentFlowEmployeeInfoDTOMapper;
    DocumentDTOMapper: TDocumentDTOMapper;
    DocumentApprovingsInfoDTOMapper: TDocumentApprovingsInfoDTOMapper;
    DocumentViewingAccountingService: IDocumentViewingAccountingService;
    DocumentFullInfoJsonMapper: IDocumentFullInfoJsonMapper;
begin

  EmployeeDTOMapper := Registry.GetDocumentFlowEmployeeInfoDTOMapper;

  RepositoryRegistry := ConfigurationData.RepositoryRegistry;

  DocumentViewingAccountingService :=
    ConfigurationData.ApplicationServices.GetAccountingServiceRegistry.GetDocumentViewingAccountingService(DocumentKind);

  DocumentApprovingsInfoDTOMapper :=
    TDocumentApprovingsInfoDTOMapper.Create(
      RepositoryRegistry.GetEmployeeRepository,
      DocumentViewingAccountingService,
      EmployeeDTOMapper
    );

  DocumentFullInfoJsonMapper :=
    TDocumentFullInfoJsonMapper.Create(
      TDocumentJsonMapper.Create(
        TDocumentApprovingsInfoJsonMapper.Create(
          TDocumentFlowEmployeeInfoJsonMapper.Create
        ),
        TDocumentChargesInfoJsonMapper.Create(
          TDocumentChargeInfoJsonMapper.Create(
            TDocumentFlowEmployeeInfoJsonMapper.Create
          )
        ),
        TDocumentResponsibleInfoJsonMapper.Create,
        TDocumentFlowEmployeeInfoJsonMapper.Create
      ),
      TDocumentApprovingsInfoJsonMapper.Create(
        TDocumentFlowEmployeeInfoJsonMapper.Create
      ),
      TDocumentChargeSheetsInfoJsonMapper.Create(
        TDocumentChargeSheetInfoJsonMapper.Create(
          TDocumentFlowEmployeeInfoJsonMapper.Create
        )
      )
    );
    
  { <refactor: remove this block after refactor DocumentNumeratorRegistry unit }
  if not DocumentKind.InheritsFrom(TPersonnelOrderKind) then begin

    DocumentDTOMapper :=
      TDocumentDTOMapper.Create(
        RepositoryRegistry.GetEmployeeRepository,
        RepositoryRegistry.GetDocumentRepositoryRegistry.GetDocumentKindRepository,
        Registry.GetDocumentResponsibleInfoDTOMapper,
        TDocumentsDomainRegistries.ServiceRegistry.NumerationServiceRegistry.GetDocumentNumeratorRegistry,
        TDocumentChargesInfoDTODomainMapper.Create(
          RepositoryRegistry.GetEmployeeRepository,
          Registry.ChargeInfoDTODomainMapperRegistry
        ),
        DocumentApprovingsInfoDTOMapper,
        EmployeeDTOMapper
      );

  end

  else begin

    DocumentDTOMapper :=
      TPersonnelOrderDTOMapper.Create(
        TDocumentsDomainRegistries.PersonnelOrderDomainRegistries.ServiceRegistries.PersonnelOrderSearchServiceRegistry.GetPersonnelOrderSubKindFinder,
        RepositoryRegistry.GetEmployeeRepository,
        RepositoryRegistry.GetDocumentRepositoryRegistry.GetDocumentKindRepository,
        Registry.GetDocumentResponsibleInfoDTOMapper,
        nil,
        TDocumentChargesInfoDTODomainMapper.Create(
          RepositoryRegistry.GetEmployeeRepository,
          Registry.ChargeInfoDTODomainMapperRegistry
        ),
        DocumentApprovingsInfoDTOMapper,
        EmployeeDTOMapper
      );

  end;

  { refactor> }
    
  if not DocumentKind.InheritsFrom(TIncomingDocumentKind) then begin

    Registry.RegisterDocumentFullInfoDTOMapper(
      DocumentKind,
      TDocumentFullInfoDTOMapper.Create(
        RepositoryRegistry.GetDocumentRepositoryRegistry,
        DocumentDTOMapper,
        DocumentApprovingsInfoDTOMapper,
        TDocumentChargeSheetsInfoDTODomainMapper.Create(
          RepositoryRegistry.GetEmployeeRepository,
          Registry.ChargeSheetInfoDTODomainMapperRegistry
        ),
        EmployeeDTOMapper
      )
    );

  end

  else begin

    Registry.RegisterDocumentFullInfoDTOMapper(
      DocumentKind,
      TIncomingDocumentFullInfoDTOMapper.Create(
        RepositoryRegistry.GetDocumentRepositoryRegistry,
        TIncomingDocumentDTOMapper.Create(
          RepositoryRegistry.GetEmployeeRepository,
          RepositoryRegistry.GetDocumentRepositoryRegistry.GetDocumentKindRepository,
          Registry.GetDocumentResponsibleInfoDTOMapper,
          TDocumentsDomainRegistries.ServiceRegistry.NumerationServiceRegistry.GetDocumentNumeratorRegistry,
          TDocumentChargesInfoDTODomainMapper.Create(
            RepositoryRegistry.GetEmployeeRepository,
            Registry.ChargeInfoDTODomainMapperRegistry
          ),
          DocumentApprovingsInfoDTOMapper,
          EmployeeDTOMapper,
          DocumentDTOMapper
        ),
        DocumentApprovingsInfoDTOMapper,
        TDocumentChargeSheetsInfoDTODomainMapper.Create(
          RepositoryRegistry.GetEmployeeRepository,
          Registry.ChargeSheetInfoDTODomainMapperRegistry
        ),
        EmployeeDTOMapper
      )
    );
                                          
  end;

  Registry.RegisterDocumentFullInfoJsonMapper(
    DocumentKind,
    DocumentFullInfoJsonMapper
  );
  
  if DocumentKind.InheritsFrom(TPersonnelOrderKind) then begin

    Registry.RegisterDocumentObjectsDTODomainMapper(
      DocumentKind,
      TPersonnelOrderDTODomainMapper.Create(
        RepositoryRegistry.GetEmployeeRepository,
        TDocumentsDomainRegistries.ServiceRegistry.OperationServiceRegistry.GetDocumentCreatingService(
          Registry.GetDocumentKindsMapper.MapDocumentKindToDomainDocumentKind(DocumentKind)
        ),
        TDocumentChargesInfoDTODomainMapper.Create(
          RepositoryRegistry.GetEmployeeRepository,
          Registry.ChargeInfoDTODomainMapperRegistry
        ),
        Registry.GetDocumentResponsibleInfoDTOMapper
      )
    );

  end

  else begin

    Registry.RegisterDocumentObjectsDTODomainMapper(
      DocumentKind,
      TDocumentObjectsDTODomainMapper.Create(
        RepositoryRegistry.GetEmployeeRepository,
        TDocumentsDomainRegistries.ServiceRegistry.OperationServiceRegistry.GetDocumentCreatingService(
          Registry.GetDocumentKindsMapper.MapDocumentKindToDomainDocumentKind(DocumentKind)
        ),
        TDocumentChargesInfoDTODomainMapper.Create(
          RepositoryRegistry.GetEmployeeRepository,
          Registry.ChargeInfoDTODomainMapperRegistry
        ),
        Registry.GetDocumentResponsibleInfoDTOMapper
      )
    );
    
  end;

  Registry.RegisterDocumentUsageEmployeeAccessRightsInfoDTOMapper(
    TDocumentUsageEmployeeAccessRightsInfoDTOMapper.Create(
      Registry.GetDocumentChargeKindDtoDomainMapper
    )
  );

  Registry.RegisterDocumentApprovingSheetDataDtoMapper(
    DocumentKind,
    TDocumentApprovingSheetDataDtoMapper.Create(
      DocumentDTOMapper,
      DocumentApprovingsInfoDTOMapper
    )
  );

end;

procedure TDTODomainMapperRegistryConfigurator.DoCommonConfiguration(
  Registry: IDTODomainMapperRegistry;
  ConfigurationData: TDTODomainMapperRegistryConfigurationData
);
var
    RepositoryRegistry: IRepositoryRegistry;
begin

  if FIsCommonConfigurationDone then Exit;
  
  RepositoryRegistry := ConfigurationData.RepositoryRegistry;

  Registry.RegisterDocumentKindsMapper(
    TDocumentKindsMapper.Create
  );
  
  Registry.RegisterDocumentFlowEmployeeInfoDTOMapper(
    TDocumentFlowEmployeeInfoDTOMapper.Create(
      RepositoryRegistry.GetDepartmentRepository
    )
  );

  Registry.RegisterDocumentResponsibleInfoDTOMapper(
    TDocumentResponsibleInfoDTOMapper.Create(
      ConfigurationData.RepositoryRegistry.GetDocumentRepositoryRegistry.GetDocumentResponsibleRepository
    )
  );

  Registry.RegisterDocumentChargeKindDtoDomainMapper(
    TDocumentChargeKindDtoDomainMapper.Create
  );

  FIsCommonConfigurationDone := True;

end;

end.
