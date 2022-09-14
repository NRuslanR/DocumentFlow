unit DocumentChargeKindDtoDomainMapper;

interface

uses

  DocumentChargeKindDto,
  DocumentCharges,
  DocumentChargeKind,
  DocumentFullInfoDTO,
  SysUtils;

type

  IDocumentChargeKindDtoDomainMapper = interface

    function MapDocumentChargeKindDto(
      DocumentChargeKind: TDocumentChargeKind
    ): TDocumentChargeKindDto;

    function MapDocumentChargeKindDtos(
      DocumentChargeKinds: TDocumentChargeKinds
    ): TDocumentChargeKindDtos;

  end;

  TDocumentChargeKindDtoDomainMapper =
    class (TInterfacedObject, IDocumentChargeKindDtoDomainMapper)

      private

        function MapChargeInfoDTOClass(ChargeClass: TDocumentChargeClass): TDocumentChargeInfoDTOClass;

      public

        function MapDocumentChargeKindDto(
          DocumentChargeKind: TDocumentChargeKind
        ): TDocumentChargeKindDto;

        function MapDocumentChargeKindDtos(
          DocumentChargeKinds: TDocumentChargeKinds
        ): TDocumentChargeKindDtos;
        
    end;

implementation

uses

  DocumentPerforming,
  DocumentAcquaitance,
  DocumentChargeSheetsInfoDTO,
  DomainObjectUnit;

{ TDocumentChargeKindDtoDomainMapper }

function TDocumentChargeKindDtoDomainMapper.MapDocumentChargeKindDtos(
  DocumentChargeKinds: TDocumentChargeKinds
): TDocumentChargeKindDtos;
var
    DocumentChargeKind: TDocumentChargeKind;
begin

  Result := TDocumentChargeKindDtos.Create;

  try

    for DocumentChargeKind in DocumentChargeKinds do
      Result.Add(MapDocumentChargeKindDto(DocumentChargeKind));

  except

    FreeAndNil(Result);

  end;
    
end;

function TDocumentChargeKindDtoDomainMapper.MapChargeInfoDTOClass(
  ChargeClass: TDocumentChargeClass): TDocumentChargeInfoDTOClass;
begin

  if ChargeClass.InheritsFrom(TDocumentAcquaitance) then
    Result := TDocumentAcquaitanceInfoDTO

  else if ChargeClass.InheritsFrom(TDocumentPerforming) then
    Result := TDocumentPerformingInfoDTO

  else begin

    raise Exception.Create(
      'Charge Class unexpected during DocumentChargeKindDto mapping'
    );

  end;
  
end;

function TDocumentChargeKindDtoDomainMapper.MapDocumentChargeKindDto(
  DocumentChargeKind: TDocumentChargeKind
): TDocumentChargeKindDto;
begin

  Result := TDocumentChargeKindDto.Create;

  try

    with DocumentChargeKind do begin

      Result.Id := Identity;
      Result.Name := Name;
      Result.ServiceName := ServiceName;

      Result.ChargeInfoDTOClass := MapChargeInfoDTOClass(ChargeClass);

    end;
    
  except

    FreeAndNil(Result);

    Raise;

  end;

end;

end.
