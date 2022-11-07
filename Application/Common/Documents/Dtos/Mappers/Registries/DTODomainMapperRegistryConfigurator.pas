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
  IncomingServiceNote,
  SysUtils,
  Classes;

type

  TDTODomainMapperRegistryConfigurationData = record

    RepositoryRegistry: IRepositoryRegistry;
    ApplicationServices: TApplicationServiceRegistries;
    
  end;
  
  IDTODomainMapperRegistryConfigurator = interface

    procedure Configure(
      Registry: IDTODomainMapperRegistry;
      ConfigurationData: TDTODomainMapperRegistryConfigurationData
    );
    
  end;
  
  TDTODomainMapperRegistryConfigurator =
    class (TInterfacedObject, IDTODomainMapperRegistryConfigurator)

      private

        FDocumentKindsReadService: INativeDocumentKindsReadService;

        procedure ConfigureForDocumentKind(
          DocumentKind: TDocumentKindClass;
          Registry: IDTODomainMapperRegistry;
          ConfigurationData: TDTODomainMapperRegistryConfigurationData
        );

        procedure DoCommonConfiguration(
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

        constructor Create(
          DocumentKindsReadService: INativeDocumentKindsReadService
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
        //TDocumentChargeInfoDTODomainMapper(ChargeInfoDTODomainMapper.Self),
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
        //TDocumentChargeInfoDTODomainMapper(ChargeInfoDTODomainMapper.Self),
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
    DocumentNumeratorRegistry: IDocumentNumeratorRegistry;
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

  { <refactor: remove this block after refactor DocumentNumeratorRegistry unit }
  if not DocumentKind.InheritsFrom(TPersonnelOrderKind) then begin

    DocumentNumeratorRegistry :=
      TDocumentsDomainRegistries
        .ServiceRegistry
          .NumerationServiceRegistry
            .GetDocumentNumeratorRegistry;

  end

  else DocumentNumeratorRegistry := nil;
  { refactor> }

  DocumentDTOMapper :=
    TDocumentDTOMapper.Create(
      RepositoryRegistry.GetEmployeeRepository,
      RepositoryRegistry.GetDocumentRepositoryRegistry.GetDocumentKindRepository,
      RepositoryRegistry.GetDocumentRepositoryRegistry.GetDocumentResponsibleRepository,
      DocumentNumeratorRegistry,
      TDocumentChargesInfoDTODomainMapper.Create(
        RepositoryRegistry.GetEmployeeRepository,
        Registry.ChargeInfoDTODomainMapperRegistry
      ),
      DocumentApprovingsInfoDTOMapper,
      EmployeeDTOMapper
    );
    
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
          RepositoryRegistry.GetDocumentRepositoryRegistry.GetDocumentResponsibleRepository,
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
    TDocumentUsageEmployeeAccessRightsInfoDTOMapper.Create
  );

  Registry.RegisterDocumentApprovingSheetDataDtoMapper(
    DocumentKind,
    TDocumentApprovingSheetDataDtoMapper.Create(
      DocumentDTOMapper,
      DocumentApprovingsInfoDTOMapper
    )
  );

end;

constructor TDTODomainMapperRegistryConfigurator.Create(
  DocumentKindsReadService: INativeDocumentKindsReadService
);
begin

  inherited Create;

  FDocumentKindsReadService := DocumentKindsReadService;
  
end;

procedure TDTODomainMapperRegistryConfigurator.DoCommonConfiguration(
  Registry: IDTODomainMapperRegistry;
  ConfigurationData: TDTODomainMapperRegistryConfigurationData
);
var
    RepositoryRegistry: IRepositoryRegistry;
begin

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
    TDocumentResponsibleInfoDTOMapper.Create
  );

end;

end.
