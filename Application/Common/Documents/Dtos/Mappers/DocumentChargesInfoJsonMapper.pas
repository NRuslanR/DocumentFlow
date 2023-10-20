unit DocumentChargesInfoJsonMapper;

interface

uses

  DocumentChargeInfoJsonMapper,
  DocumentChargeSheetsInfoDTO,
  uLkJSON,
  IGetSelfUnit,
  SysUtils,
  Classes;

type

  IDocumentChargesInfoJsonMapper = interface (IGetSelf)

    function MapDocumentChargesInfoJsonList(const DocumentChargesInfoDTO: TDocumentChargesInfoDTO): TlkJSONlist;
    function MapDocumentChargesInfoJson(const DocumentChargesInfoDTO: TDocumentChargesInfoDTO): String;
    
  end;

  TDocumentChargesInfoJsonMapper = class (TInterfacedObject, IDocumentChargesInfoJsonMapper)

    private

      FChargeInfoJsonMapper: IDocumentChargeInfoJsonMapper;

    public

      constructor Create(ChargeInfoJsonMapper: IDocumentChargeInfoJsonMapper);

      function GetSelf: TObject;
      
      function MapDocumentChargesInfoJsonList(const DocumentChargesInfoDTO: TDocumentChargesInfoDTO): TlkJSONlist;
      function MapDocumentChargesInfoJson(const DocumentChargesInfoDTO: TDocumentChargesInfoDTO): String;
    
  end;

implementation

{ TDocumentChargesInfoJsonMapper }

constructor TDocumentChargesInfoJsonMapper.Create(
  ChargeInfoJsonMapper: IDocumentChargeInfoJsonMapper);
begin

  inherited Create;

  FChargeInfoJsonMapper := ChargeInfoJsonMapper;
  
end;

function TDocumentChargesInfoJsonMapper.GetSelf: TObject;
begin

  Result := Self;
  
end;

function TDocumentChargesInfoJsonMapper.MapDocumentChargesInfoJson(
  const DocumentChargesInfoDTO: TDocumentChargesInfoDTO): String;
var
    ChargesInfoJsonList: TlkJSONlist;
begin

  ChargesInfoJsonList := MapDocumentChargesInfoJsonList(DocumentChargesInfoDTO);

  try

    Result := TlkJSON.GenerateText(ChargesInfoJsonList);
    
  finally

    FreeAndNil(Result);
    
  end;

end;

function TDocumentChargesInfoJsonMapper.MapDocumentChargesInfoJsonList(
  const DocumentChargesInfoDTO: TDocumentChargesInfoDTO): TlkJSONlist;
var
    ChargeInfoDTO: TDocumentChargeInfoDTO;
begin

  Result := TlkJSONlist.Create;

  if not Assigned(DocumentChargesInfoDTO) then Exit;
  
  try

    for ChargeInfoDTO in DocumentChargesInfoDTO do begin

      Result.Add(
        FChargeInfoJsonMapper.MapDocumentChargeInfoJsonObject(ChargeInfoDTO)
      );

    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

end.
