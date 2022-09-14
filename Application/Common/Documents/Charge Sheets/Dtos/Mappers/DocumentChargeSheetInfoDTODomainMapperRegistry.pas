unit DocumentChargeSheetInfoDTODomainMapperRegistry;

interface

uses

  DocumentChargeSheet,
  DocumentChargeSheetsInfoDTO,
  DocumentChargeSheetInfoDTODomainMapper,
  DocumentChargeKindsControlService,
  DocumentCharges,
  DocumentChargeKind,
  TypeObjectRegistry,
  SysUtils;

type

  IDocumentChargeSheetInfoDTODomainMapperRegistry = interface

    function RegisterDocumentChargeSheetInfoDTODomainMapper(
      DocumentChargeSheetType: TDocumentChargeSheetClass;
      Mapper: IDocumentChargeSheetInfoDTODomainMapper
    ): IDocumentChargeSheetInfoDTODomainMapperRegistry;

    function GetDocumentChargeSheetInfoDTODomainMapper(
      DocumentChargeSheetType: TDocumentChargeSheetClass
    ): IDocumentChargeSheetInfoDTODomainMapper;

  end;

  { refactor: add standard mapper registration method }
  TDocumentChargeSheetInfoDTODomainMapperRegistry =
    class (TInterfacedObject, IDocumentChargeSheetInfoDTODomainMapperRegistry)

      private

        FDocumentChargeKindsControlService: IDocumentChargeKindsControlService;
        
        FMapperRegistry: TTypeObjectRegistry;

      public

        destructor Destroy; override;

        constructor Create(ChargeKindsControlService: IDocumentChargeKindsControlService);

        function RegisterDocumentChargeSheetInfoDTODomainMapper(
          DocumentChargeSheetType: TDocumentChargeSheetClass;
          Mapper: IDocumentChargeSheetInfoDTODomainMapper
        ): IDocumentChargeSheetInfoDTODomainMapperRegistry;

        function GetDocumentChargeSheetInfoDTODomainMapper(
          DocumentChargeSheetType: TDocumentChargeSheetClass
        ): IDocumentChargeSheetInfoDTODomainMapper;
    
    end;

implementation

uses

  DocumentAcquaitanceSheetInfoDTODomainMapper,
  DocumentPerformingSheetInfoDTODomainMapper,
  IDomainObjectBaseListUnit;

{ TDocumentChargeSheetInfoDTODomainMapperRegistry }

constructor TDocumentChargeSheetInfoDTODomainMapperRegistry.Create(
  ChargeKindsControlService: IDocumentChargeKindsControlService
);
begin

  inherited Create;

  FMapperRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;

  FMapperRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;

  FDocumentChargeKindsControlService := ChargeKindsControlService;
  
end;

destructor TDocumentChargeSheetInfoDTODomainMapperRegistry.Destroy;
begin

  FreeAndNil(FMapperRegistry);
  
  inherited;

end;

function TDocumentChargeSheetInfoDTODomainMapperRegistry
  .GetDocumentChargeSheetInfoDTODomainMapper(
    DocumentChargeSheetType: TDocumentChargeSheetClass
  ): IDocumentChargeSheetInfoDTODomainMapper;
begin

  Result :=
    IDocumentChargeSheetInfoDTODomainMapper(
      FMapperRegistry.GetInterface(DocumentChargeSheetType)
    );

end;

function TDocumentChargeSheetInfoDTODomainMapperRegistry
  .RegisterDocumentChargeSheetInfoDTODomainMapper(
    DocumentChargeSheetType: TDocumentChargeSheetClass;
    Mapper: IDocumentChargeSheetInfoDTODomainMapper
  ): IDocumentChargeSheetInfoDTODomainMapperRegistry;
begin

  FMapperRegistry.RegisterInterface(DocumentChargeSheetType, Mapper);

  Result := Self;
  
end;

end.
