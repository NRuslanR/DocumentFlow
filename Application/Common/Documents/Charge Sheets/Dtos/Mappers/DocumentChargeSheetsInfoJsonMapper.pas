unit DocumentChargeSheetsInfoJsonMapper;

interface

uses

  DocumentChargeSheetInfoJsonMapper,
  DocumentChargeSheetsInfoDTO,
  IGetSelfUnit,
  uLkJSON,
  SysUtils,
  Classes;

type

  IDocumentChargeSheetsInfoJsonMapper = interface (IGetSelf)

    function MapDocumentChargeSheetsInfoJsonList(const ChargeSheetsInfoDTO: TDocumentChargeSheetsInfoDTO): TlkJSONlist;
    function MapDocumentChargeSheetsInfoJson(const ChargeSheetsInfoDTO: TDocumentChargeSheetsInfoDTO): String;

  end;

  TDocumentChargeSheetsInfoJsonMapper = class (TInterfacedObject, IDocumentChargeSheetsInfoJsonMapper)

    private

      FChargeSheetInfoJsonMapper: IDocumentChargeSheetInfoJsonMapper;
      
    public

    constructor Create(DocumentChargeSheetInfoJsonMapper: IDocumentChargeSheetInfoJsonMapper);

    function GetSelf: TObject;
    
    function MapDocumentChargeSheetsInfoJsonList(const ChargeSheetsInfoDTO: TDocumentChargeSheetsInfoDTO): TlkJSONlist;
    function MapDocumentChargeSheetsInfoJson(const ChargeSheetsInfoDTO: TDocumentChargeSheetsInfoDTO): String;

  end;

implementation

{ TDocumentChargeSheetsInfoJsonMapper }

constructor TDocumentChargeSheetsInfoJsonMapper.Create(
  DocumentChargeSheetInfoJsonMapper: IDocumentChargeSheetInfoJsonMapper);
begin

  inherited Create;

  FChargeSheetInfoJsonMapper := DocumentChargeSheetInfoJsonMapper;

end;

function TDocumentChargeSheetsInfoJsonMapper.GetSelf: TObject;
begin

  Result := Self;
  
end;

function TDocumentChargeSheetsInfoJsonMapper.MapDocumentChargeSheetsInfoJson(
  const ChargeSheetsInfoDTO: TDocumentChargeSheetsInfoDTO): String;
var
    ChargeSheetsInfoJsonList: TlkJSONlist;
begin

  ChargeSheetsInfoJsonList := MapDocumentChargeSheetsInfoJsonList(ChargeSheetsInfoDTO);

  try

    Result := TlkJSON.GenerateText(ChargeSheetsInfoJsonList);
    
  finally

    FreeAndNil(ChargeSheetsInfoJsonList);

  end;

end;

function TDocumentChargeSheetsInfoJsonMapper.MapDocumentChargeSheetsInfoJsonList(
  const ChargeSheetsInfoDTO: TDocumentChargeSheetsInfoDTO): TlkJSONlist;
var
    ChargeSheetInfoDTO: TDocumentChargeSheetInfoDTO;
begin

  Result := TlkJSONlist.Create;

  if not Assigned(ChargeSheetsInfoDTO) then Exit;
  
  try

    for ChargeSheetInfoDTO in ChargeSheetsInfoDTO do  begin

      Result.Add(
        FChargeSheetInfoJsonMapper
          .MapDocumentChargeSheetInfoJsonObject(ChargeSheetInfoDTO)
      );

    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

end.
