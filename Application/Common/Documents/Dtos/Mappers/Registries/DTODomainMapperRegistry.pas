unit DTODomainMapperRegistry;

interface

uses

  DocumentFullInfoDTOMapper,
  DocumentObjectsDTODomainMapper,
  DocumentChargeSheetInfoDTODomainMapper,
  DocumentChargeSheetInfoDTODomainMapperRegistry,
  DocumentChargeInfoDTODomainMapper,
  DocumentChargeInfoDTODomainMapperRegistry,
  DocumentKinds,
  DocumentApprovingSheetDataDtoMapper,
  DocumentFlowEmployeeInfoDTOMapper,
  DocumentChargeKindsControlService,
  DocumentKindsMapper,
  DocumentResponsibleInfoDTOMapper,
  DocumentCharges,
  DocumentChargeSheet,
  TypeObjectRegistry,
  DocumentUsageEmployeeAccessRightsInfoDTOMapper,
  SysUtils,
  Classes;
  
type

  IDTODomainMapperRegistry = interface

    procedure RegisterDocumentResponsibleInfoDTOMapper(
      DocumentResponsibleInfoDTOMapper: IDocumentResponsibleInfoDTOMapper
    );

    function GetDocumentResponsibleInfoDTOMapper: IDocumentResponsibleInfoDTOMapper;
    
    procedure RegisterDocumentFullInfoDTOMapper(
      DocumentKind: TDocumentKindClass;
      DocumentFullInfoDTOMapper: TDocumentFullInfoDTOMapper
    );

    function GetDocumentFullInfoDTOMapper(
      DocumentKind: TDocumentKindClass
    ): TDocumentFullInfoDTOMapper;

    function RegisterDocumentChargeSheetInfoDTODomainMapper(
      DocumentChargeSheetType: TDocumentChargeSheetClass;
      Mapper: IDocumentChargeSheetInfoDTODomainMapper
    ): IDocumentChargeSheetInfoDTODomainMapperRegistry;

    function GetDocumentChargeSheetInfoDTODomainMapper(
      DocumentChargeSheetType: TDocumentChargeSheetClass
    ): IDocumentChargeSheetInfoDTODomainMapper;

    procedure RegisterDocumentChargeInfoDTODomainMapper(
      DocumentChargeType: TDocumentChargeClass;
      ChargeInfoDTODomainMapper: IDocumentChargeInfoDTODomainMapper
    );

    function GetDocumentChargeInfoDTODomainMapper(
      DocumentChargeType: TDocumentChargeClass
    ): IDocumentChargeInfoDTODomainMapper; overload;

    function GetDocumentChargeInfoDTODomainMapper(
      const ChargeKindId: Variant
    ): IDocumentChargeInfoDTODomainMapper; overload;

    procedure RegisterDocumentKindsMapper(
      DocumentKindsMapper: IDocumentKindsMapper
    );

    function GetDocumentKindsMapper: IDocumentKindsMapper;

    procedure RegisterDocumentObjectsDTODomainMapper(
      DocumentKind: TDocumentKindClass;
      DocumentObjectsDTODomainMapper: TDocumentObjectsDTODomainMapper
    );

    function GetDocumentObjectsDTODomainMapper(
      DocumentKind: TDocumentKindClass
    ): TDocumentObjectsDTODomainMapper;

    procedure RegisterDocumentApprovingSheetDataDtoMapper(
      DocumentKind: TDocumentKindClass;
      DocumentApprovingSheetDataDtoMapper: TDocumentApprovingSheetDataDtoMapper
    );

    function GetApprovingSheetDataDtoMapper(
      DocumentKind: TDocumentKindClass
    ): TDocumentApprovingSheetDataDtoMapper;


    procedure RegisterDocumentFlowEmployeeInfoDTOMapper(
      DocumentFlowEmployeeInfoDTOMapper: TDocumentFlowEmployeeInfoDTOMapper
    );

    procedure RegisterDocumentUsageEmployeeAccessRightsInfoDTOMapper(
      DocumentUsageEmployeeAccessRightsInfoDTOMapper: TDocumentUsageEmployeeAccessRightsInfoDTOMapper
    );

    function GetDocumentUsageEmployeeAccessRightsInfoDTOMapper: TDocumentUsageEmployeeAccessRightsInfoDTOMapper;
    
    function GetDocumentFlowEmployeeInfoDTOMapper: TDocumentFlowEmployeeInfoDTOMapper;

    function ChargeInfoDTODomainMapperRegistry: IDocumentChargeInfoDTODomainMapperRegistry;
    function ChargeSheetInfoDTODomainMapperRegistry: IDocumentChargeSheetInfoDTODomainMapperRegistry;

  end;

  TDTODomainMapperRegistry =
    class (TInterfacedObject, IDTODomainMapperRegistry)

      private

        class var FInstance: IDTODomainMapperRegistry;

        class function GetInstance: IDTODomainMapperRegistry; static;
        class procedure SetInstance(const Value: IDTODomainMapperRegistry); static;

      private

        FDocumentFullInfoDTOMapperRegistry: TTypeObjectRegistry;
        FChargeInfoDTODomainMapperRegistry: IDocumentChargeInfoDTODomainMapperRegistry;
        FChargeSheetInfoDTODomainMapperRegistry: IDocumentChargeSheetInfoDTODomainMapperRegistry;
        FDocumentKindsMapperRegistry: TTypeObjectRegistry;
        FDocumentObjectsDTODomainMapperRegistry: TTypeObjectRegistry;
        FDocumentApprovingSheetDataDtoMapperRegistry: TTypeObjectRegistry;
        FEmployeeInfoDTOMapperRegistry: TTypeObjectRegistry;
        FDocumentUsageEmployeeAccessRightsInfoDTOMapperRegistry: TTypeObjectRegistry;
        
      public

        destructor Destroy; override;
        constructor Create(
          DocumentChargeKindsControlService: IDocumentChargeKindsControlService
        );

        procedure RegisterDocumentResponsibleInfoDTOMapper(
          DocumentResponsibleInfoDTOMapper: IDocumentResponsibleInfoDTOMapper
        );

        function GetDocumentResponsibleInfoDTOMapper: IDocumentResponsibleInfoDTOMapper;

        procedure RegisterDocumentFullInfoDTOMapper(
          DocumentKind: TDocumentKindClass;
          DocumentFullInfoDTOMapper: TDocumentFullInfoDTOMapper
        );

        function GetDocumentFullInfoDTOMapper(
          DocumentKind: TDocumentKindClass
        ): TDocumentFullInfoDTOMapper;

        function RegisterDocumentChargeSheetInfoDTODomainMapper(
          DocumentChargeSheetType: TDocumentChargeSheetClass;
          Mapper: IDocumentChargeSheetInfoDTODomainMapper
        ): IDocumentChargeSheetInfoDTODomainMapperRegistry;

        function GetDocumentChargeSheetInfoDTODomainMapper(
          DocumentChargeSheetType: TDocumentChargeSheetClass
        ): IDocumentChargeSheetInfoDTODomainMapper;

        procedure RegisterDocumentChargeInfoDTODomainMapper(
          DocumentChargeType: TDocumentChargeClass;
          ChargeInfoDTODomainMapper: IDocumentChargeInfoDTODomainMapper
        );

        function GetDocumentChargeInfoDTODomainMapper(
          DocumentChargeType: TDocumentChargeClass
        ): IDocumentChargeInfoDTODomainMapper; overload;

        function GetDocumentChargeInfoDTODomainMapper(
          const ChargeKindId: Variant
        ): IDocumentChargeInfoDTODomainMapper; overload;

        procedure RegisterDocumentKindsMapper(
          DocumentKindsMapper: IDocumentKindsMapper
        );

        function GetDocumentKindsMapper: IDocumentKindsMapper;

        procedure RegisterDocumentObjectsDTODomainMapper(
          DocumentKind: TDocumentKindClass;
          DocumentObjectsDTODomainMapper: TDocumentObjectsDTODomainMapper
        );

        function GetDocumentObjectsDTODomainMapper(
          DocumentKind: TDocumentKindClass
        ): TDocumentObjectsDTODomainMapper;

        procedure RegisterDocumentApprovingSheetDataDtoMapper(
          DocumentKind: TDocumentKindClass;
          DocumentApprovingSheetDataDtoMapper: TDocumentApprovingSheetDataDtoMapper
        );

        function GetApprovingSheetDataDtoMapper(
          DocumentKind: TDocumentKindClass
        ): TDocumentApprovingSheetDataDtoMapper;


        procedure RegisterDocumentFlowEmployeeInfoDTOMapper(
          DocumentFlowEmployeeInfoDTOMapper: TDocumentFlowEmployeeInfoDTOMapper
        );

        procedure RegisterDocumentUsageEmployeeAccessRightsInfoDTOMapper(
          DocumentUsageEmployeeAccessRightsInfoDTOMapper: TDocumentUsageEmployeeAccessRightsInfoDTOMapper
        );

        function GetDocumentUsageEmployeeAccessRightsInfoDTOMapper: TDocumentUsageEmployeeAccessRightsInfoDTOMapper;

        function GetDocumentFlowEmployeeInfoDTOMapper: TDocumentFlowEmployeeInfoDTOMapper;

        function ChargeInfoDTODomainMapperRegistry: IDocumentChargeInfoDTODomainMapperRegistry;
        function ChargeSheetInfoDTODomainMapperRegistry: IDocumentChargeSheetInfoDTODomainMapperRegistry;

      public

        class property Instance: IDTODomainMapperRegistry
        read GetInstance write SetInstance;

    end;

implementation

{ TDTODomainMapperRegistry }

class function TDTODomainMapperRegistry.GetInstance: IDTODomainMapperRegistry;
begin

  Result := FInstance;

end;

function TDTODomainMapperRegistry.ChargeInfoDTODomainMapperRegistry: IDocumentChargeInfoDTODomainMapperRegistry;
begin

  Result := FChargeInfoDTODomainMapperRegistry;

end;

function TDTODomainMapperRegistry.ChargeSheetInfoDTODomainMapperRegistry: IDocumentChargeSheetInfoDTODomainMapperRegistry;
begin

  Result := FChargeSheetInfoDTODomainMapperRegistry;
  
end;

constructor TDTODomainMapperRegistry.Create(
  DocumentChargeKindsControlService: IDocumentChargeKindsControlService
);
begin

  inherited Create;

  FDocumentFullInfoDTOMapperRegistry :=
    TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry(ltoFreeRegisteredObjectsOnDestroy);

  FDocumentKindsMapperRegistry :=
    TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry(ltoFreeRegisteredObjectsOnDestroy);

  FDocumentObjectsDTODomainMapperRegistry :=
    TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry(ltoFreeRegisteredObjectsOnDestroy);

  FDocumentApprovingSheetDataDtoMapperRegistry :=
    TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry(ltoFreeRegisteredObjectsOnDestroy);

  FEmployeeInfoDTOMapperRegistry :=
    TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;

  FDocumentUsageEmployeeAccessRightsInfoDTOMapperRegistry :=
    TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry(ltoFreeRegisteredObjectsOnDestroy);
    
  FDocumentFullInfoDTOMapperRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  FDocumentObjectsDTODomainMapperRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  FDocumentApprovingSheetDataDtoMapperRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  FDocumentUsageEmployeeAccessRightsInfoDTOMapperRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  
  FChargeInfoDTODomainMapperRegistry :=
    TDocumentChargeInfoDTODomainMapperRegistry.Create(
      DocumentChargeKindsControlService
    );

  FChargeSheetInfoDTODomainMapperRegistry :=
    TDocumentChargeSheetInfoDTODomainMapperRegistry.Create(
      DocumentChargeKindsControlService
    );

end;

destructor TDTODomainMapperRegistry.Destroy;
begin

  FreeAndNil(FDocumentFullInfoDTOMapperRegistry);
  FreeAndNil(FDocumentKindsMapperRegistry);
  FreeAndNil(FDocumentObjectsDTODomainMapperRegistry);
  FreeAndNil(FDocumentApprovingSheetDataDtoMapperRegistry);
  FreeAndNil(FEmployeeInfoDTOMapperRegistry);
  FreeAndNil(FDocumentUsageEmployeeAccessRightsInfoDTOMapperRegistry);

  inherited;

end;

function TDTODomainMapperRegistry.GetApprovingSheetDataDtoMapper(
  DocumentKind: TDocumentKindClass): TDocumentApprovingSheetDataDtoMapper;
begin

  Result :=
    TDocumentApprovingSheetDataDtoMapper(
      FDocumentApprovingSheetDataDtoMapperRegistry.GetObject(DocumentKind)
    );

end;

function TDTODomainMapperRegistry.GetDocumentChargeInfoDTODomainMapper(
  const ChargeKindId: Variant): IDocumentChargeInfoDTODomainMapper;
begin

  Result :=
    IDocumentChargeInfoDTODomainMapper(
      FChargeInfoDTODomainMapperRegistry.GetDocumentChargeInfoDTODomainMapper(
        ChargeKindId
      )
    );
    
end;

function TDTODomainMapperRegistry.GetDocumentChargeInfoDTODomainMapper(
  DocumentChargeType: TDocumentChargeClass): IDocumentChargeInfoDTODomainMapper;
begin

  Result :=
    IDocumentChargeInfoDTODomainMapper(
      FChargeInfoDTODomainMapperRegistry.GetDocumentChargeInfoDTODomainMapper(
        DocumentChargeType
      )
    );

end;

function TDTODomainMapperRegistry.GetDocumentChargeSheetInfoDTODomainMapper(
  DocumentChargeSheetType: TDocumentChargeSheetClass
): IDocumentChargeSheetInfoDTODomainMapper;
begin

  Result :=
    IDocumentChargeSheetInfoDTODomainMapper(
      FChargeSheetInfoDTODomainMapperRegistry
        .GetDocumentChargeSheetInfoDTODomainMapper(
          DocumentChargeSheetType
        )
    );
    
end;

function TDTODomainMapperRegistry
  .GetDocumentFlowEmployeeInfoDTOMapper: TDocumentFlowEmployeeInfoDTOMapper;
var
    Intf: IInterface;
    DocumentFlowEmployeeInfoDTOMapper: IDocumentFlowEmployeeInfoDTOMapper;
begin

  Intf :=
    FEmployeeInfoDTOMapperRegistry.GetInterface(TDocumentFlowEmployeeInfoDTOMapper);

  Supports(Intf, IDocumentFlowEmployeeInfoDTOMapper, DocumentFlowEmployeeInfoDTOMapper);

  Result :=
    TDocumentFlowEmployeeInfoDTOMapper(DocumentFlowEmployeeInfoDTOMapper.Self);
  
end;

function TDTODomainMapperRegistry.GetDocumentFullInfoDTOMapper(
  DocumentKind: TDocumentKindClass): TDocumentFullInfoDTOMapper;
begin

  Result :=
    TDocumentFullInfoDTOMapper(
      FDocumentFullInfoDTOMapperRegistry.GetObject(DocumentKind)
    );

end;

function TDTODomainMapperRegistry.GetDocumentKindsMapper: IDocumentKindsMapper;
begin

  Result :=
    IDocumentKindsMapper(
      FDocumentKindsMapperRegistry.GetInterface(TDocumentKindsMapper)
    );
    
end;

function TDTODomainMapperRegistry.GetDocumentObjectsDTODomainMapper(
  DocumentKind: TDocumentKindClass): TDocumentObjectsDTODomainMapper;
begin

  Result :=
    TDocumentObjectsDTODomainMapper(
      FDocumentObjectsDTODomainMapperRegistry.GetObject(DocumentKind)
    );
    
end;

function TDTODomainMapperRegistry
  .GetDocumentResponsibleInfoDTOMapper: IDocumentResponsibleInfoDTOMapper;
begin

  Result :=
    IDocumentResponsibleInfoDTOMapper(
      FEmployeeInfoDTOMapperRegistry.GetInterface(TDocumentResponsibleInfoDTOMapper)
    );

end;

function TDTODomainMapperRegistry
  .GetDocumentUsageEmployeeAccessRightsInfoDTOMapper: TDocumentUsageEmployeeAccessRightsInfoDTOMapper;
begin

  Result :=
    TDocumentUsageEmployeeAccessRightsInfoDTOMapper(
      FDocumentUsageEmployeeAccessRightsInfoDTOMapperRegistry.GetObject(
        TDocumentUsageEmployeeAccessRightsInfoDTOMapper
      )
    );

end;

procedure TDTODomainMapperRegistry.RegisterDocumentApprovingSheetDataDtoMapper(
  DocumentKind: TDocumentKindClass;
  DocumentApprovingSheetDataDtoMapper: TDocumentApprovingSheetDataDtoMapper
);
begin

  FDocumentApprovingSheetDataDtoMapperRegistry.RegisterObject(
    DocumentKind,
    DocumentApprovingSheetDataDtoMapper
  );
  
end;

procedure TDTODomainMapperRegistry.RegisterDocumentChargeInfoDTODomainMapper(
  DocumentChargeType: TDocumentChargeClass;
  ChargeInfoDTODomainMapper: IDocumentChargeInfoDTODomainMapper
);
begin

  FChargeInfoDTODomainMapperRegistry.RegisterDocumentChargeInfoDTODomainMapper(
    DocumentChargeType,
    ChargeInfoDTODomainMapper
  );

end;

function TDTODomainMapperRegistry.RegisterDocumentChargeSheetInfoDTODomainMapper(
  DocumentChargeSheetType: TDocumentChargeSheetClass;
  Mapper: IDocumentChargeSheetInfoDTODomainMapper): IDocumentChargeSheetInfoDTODomainMapperRegistry;
begin

  FChargeSheetInfoDTODomainMapperRegistry.RegisterDocumentChargeSheetInfoDTODomainMapper(
    DocumentChargeSheetType,
    Mapper
  );
  
end;

procedure TDTODomainMapperRegistry.RegisterDocumentFlowEmployeeInfoDTOMapper(
  DocumentFlowEmployeeInfoDTOMapper: TDocumentFlowEmployeeInfoDTOMapper);
begin

  FEmployeeInfoDTOMapperRegistry.RegisterInterface(
    TDocumentFlowEmployeeInfoDTOMapper,
    DocumentFlowEmployeeInfoDTOMapper
  );

end;

procedure TDTODomainMapperRegistry.RegisterDocumentFullInfoDTOMapper(
  DocumentKind: TDocumentKindClass;
  DocumentFullInfoDTOMapper: TDocumentFullInfoDTOMapper);
begin

  FDocumentFullInfoDTOMapperRegistry.RegisterObject(
    DocumentKind,
    DocumentFullInfoDTOMapper
  );
  
end;

procedure TDTODomainMapperRegistry.RegisterDocumentKindsMapper(
  DocumentKindsMapper: IDocumentKindsMapper);
begin

  FDocumentKindsMapperRegistry.RegisterInterface(
    TDocumentKindsMapper,
    DocumentKindsMapper
  );
  
end;

procedure TDTODomainMapperRegistry.RegisterDocumentObjectsDTODomainMapper(
  DocumentKind: TDocumentKindClass;
  DocumentObjectsDTODomainMapper: TDocumentObjectsDTODomainMapper);
begin

  FDocumentObjectsDTODomainMapperRegistry.RegisterObject(
    DocumentKind,
    DocumentObjectsDTODomainMapper
  );

end;

procedure TDTODomainMapperRegistry.RegisterDocumentResponsibleInfoDTOMapper(
  DocumentResponsibleInfoDTOMapper: IDocumentResponsibleInfoDTOMapper);
begin

  FEmployeeInfoDTOMapperRegistry.RegisterInterface(
    TDocumentResponsibleInfoDTOMapper, DocumentResponsibleInfoDTOMapper
  );
  
end;

procedure TDTODomainMapperRegistry.RegisterDocumentUsageEmployeeAccessRightsInfoDTOMapper(
  DocumentUsageEmployeeAccessRightsInfoDTOMapper: TDocumentUsageEmployeeAccessRightsInfoDTOMapper);
begin

  FDocumentUsageEmployeeAccessRightsInfoDTOMapperRegistry.RegisterObject(
    DocumentUsageEmployeeAccessRightsInfoDTOMapper.ClassType,
    DocumentUsageEmployeeAccessRightsInfoDTOMapper
  );
  
end;

class procedure TDTODomainMapperRegistry.SetInstance(
  const Value: IDTODomainMapperRegistry);
begin

  FInstance := Value;
  
end;

end.
