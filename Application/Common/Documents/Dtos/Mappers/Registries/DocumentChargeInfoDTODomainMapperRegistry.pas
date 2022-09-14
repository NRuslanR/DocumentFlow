unit DocumentChargeInfoDTODomainMapperRegistry;

interface

uses

  DocumentChargeInfoDTODomainMapper,
  DocumentChargeKindsControlService,
  DocumentCharges,
  DocumentChargeKind,
  TypeObjectRegistry,
  SysUtils,
  Classes;

type

  IDocumentChargeInfoDTODomainMapperRegistry = interface

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

  end;

  TDocumentChargeInfoDTODomainMapperRegistry =
    class (TInterfacedObject, IDocumentChargeInfoDTODomainMapperRegistry)

      private

        FMapperRegistry: TTypeObjectRegistry;
        FChargeKindsControlService: IDocumentChargeKindsControlService;
        
      public

        destructor Destroy; override;
        constructor Create(
          ChargeKindsControlService: IDocumentChargeKindsControlService
        );

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

    end;

implementation

uses

  IDomainObjectBaseUnit;
  
{ IDocumentChargeInfoDTODomainMapperRegistry }

constructor TDocumentChargeInfoDTODomainMapperRegistry.Create(
  ChargeKindsControlService: IDocumentChargeKindsControlService
);
begin

  inherited Create;

  FChargeKindsControlService := ChargeKindsControlService;
  FMapperRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;

  FMapperRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;

end;

destructor TDocumentChargeInfoDTODomainMapperRegistry.Destroy;
begin

  FreeAndNil(FMapperRegistry);

  inherited;

end;

function TDocumentChargeInfoDTODomainMapperRegistry.GetDocumentChargeInfoDTODomainMapper(
  const ChargeKindId: Variant): IDocumentChargeInfoDTODomainMapper;
var
    ChargeKind: TDocumentChargeKind;
    FreeChargeKind: IDomainObjectBase;
begin

  ChargeKind :=
    FChargeKindsControlService.FindDocumentChargeKindById(ChargeKindId);

  FreeChargeKind := ChargeKind;

  Result := GetDocumentChargeInfoDTODomainMapper(ChargeKind.ChargeClass);
  
end;

function TDocumentChargeInfoDTODomainMapperRegistry
  .GetDocumentChargeInfoDTODomainMapper(
    DocumentChargeType: TDocumentChargeClass
  ): IDocumentChargeInfoDTODomainMapper;
begin

  Result :=
    IDocumentChargeInfoDTODomainMapper(
      FMapperRegistry.GetInterface(DocumentChargeType)
    );

end;

procedure TDocumentChargeInfoDTODomainMapperRegistry
  .RegisterDocumentChargeInfoDTODomainMapper(
    DocumentChargeType: TDocumentChargeClass;
    ChargeInfoDTODomainMapper: IDocumentChargeInfoDTODomainMapper
  );
begin

  FMapperRegistry.RegisterInterface(
    DocumentChargeType,
    ChargeInfoDTODomainMapper
  );
  
end;

end.
