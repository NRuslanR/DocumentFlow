unit DocumentChargeInfoJsonMapper;

interface

uses

  DocumentFlowEmployeeInfoJsonMapper,
  DocumentChargeSheetsInfoDTO,
  uLkJSON,
  IGetSelfUnit,
  SysUtils,
  Classes;

type

  IDocumentChargeInfoJsonMapper = interface (IGetSelf)

    function MapDocumentChargeInfoJsonObject(const DocumentChargeInfoDTO: TDocumentChargeInfoDTO): TlkJSONobject;
    function MapDocumentChargeInfoJson(const DocumentChargeInfoDTO: TDocumentChargeInfoDTO): String;

  end;

  TDocumentChargeInfoJsonMapper = class (TInterfacedObject, IDocumentChargeInfoJsonMapper)

    private

      FDocumentFlowEmployeeInfoJsonMapper: IDocumentFlowEmployeeInfoJsonMapper;

      function MapDocumentChargeAccessRightsJsonObject(
        const AccessRights: TDocumentChargeAccessRightsDTO
      ): TlkJSONobject;
      
    public

      constructor Create(DocumentFlowEmployeeInfoJsonMapper: IDocumentFlowEmployeeInfoJsonMapper);
      
      function GetSelf: TObject;
      
      function MapDocumentChargeInfoJsonObject(const DocumentChargeInfoDTO: TDocumentChargeInfoDTO): TlkJSONobject;
      function MapDocumentChargeInfoJson(const DocumentChargeInfoDTO: TDocumentChargeInfoDTO): String;

  end;

  
implementation

uses

  Variants,
  VariantFunctions,
  DateTimeUtils;

{ TDocumentChargeInfoJsonMapper }

constructor TDocumentChargeInfoJsonMapper.Create(
  DocumentFlowEmployeeInfoJsonMapper: IDocumentFlowEmployeeInfoJsonMapper);
begin

  inherited Create;

  FDocumentFlowEmployeeInfoJsonMapper := DocumentFlowEmployeeInfoJsonMapper;
  
end;

function TDocumentChargeInfoJsonMapper.GetSelf: TObject;
begin

  Result := Self;
  
end;

function TDocumentChargeInfoJsonMapper.MapDocumentChargeInfoJson(
  const DocumentChargeInfoDTO: TDocumentChargeInfoDTO): String;
var
    ChargeJsonObject: TlkJSONobject;
begin

  ChargeJsonObject := MapDocumentChargeInfoJsonObject(DocumentChargeInfoDTO);

  try

    Result := TlkJSON.GenerateText(ChargeJsonObject);

  finally

    FreeAndNil(ChargeJsonObject);
    
  end;

end;

function TDocumentChargeInfoJsonMapper.MapDocumentChargeInfoJsonObject(
  const DocumentChargeInfoDTO: TDocumentChargeInfoDTO): TlkJSONobject;
begin

  Result := TlkJSONobject.Create;

  try

    with DocumentChargeInfoDTO, Result do begin

      Add('Id', VarToStr(Id));
      Add('KindId', VarToStr(KindId));
      Add('KindName', KindName);
      Add('ServiceKindName', ServiceKindName);
      Add('ChargeText', ChargeText);
      Add('PerformerResponse', PerformerResponse);

      if not VarIsNullOrEmpty(TimeFrameStart) then begin

        Add(
          'TimeFrameStart',
          FormatDateTime(TDateTimeUtils.ISO_8601_Format, TimeFrameStart)
        );

      end;

      if not VarIsNullOrEmpty(TimeFrameDeadline) then begin

        Add(
          'TimeFrameDeadline',
          FormatDateTime(TDateTimeUtils.ISO_8601_Format, TimeFrameDeadline)
        );

      end;

      if not VarIsNullOrEmpty(PerformingDateTime) then begin

        Add(
          'PerformingDateTime',
          FormatDateTime(TDateTimeUtils.ISO_8601_Format, PerformingDateTime)
        );

      end;

      Add('IsForAcquaitance', IsForAcquaitance);

      Add(
        'PerformerInfoDTO',
        FDocumentFlowEmployeeInfoJsonMapper
          .MapDocumentFlowEmployeeInfoJsonObject(PerformerInfoDTO)
        );

      if Assigned(ActuallyPerformedEmployeeInfoDTO) then begin

        Add(
          'ActuallyPerformedEmployeeInfoDTO',
          FDocumentFlowEmployeeInfoJsonMapper
            .MapDocumentFlowEmployeeInfoJsonObject(ActuallyPerformedEmployeeInfoDTO)
        );

      end;

      Add(
        'AccessRights',
        MapDocumentChargeAccessRightsJsonObject(AccessRights)
      );

    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TDocumentChargeInfoJsonMapper.MapDocumentChargeAccessRightsJsonObject(
  const AccessRights: TDocumentChargeAccessRightsDTO): TlkJSONobject;
var
    AccessSuccessed: Boolean;
begin

  Result := TlkJSONobject.Create;


  try

    with AccessRights, Result do begin

      if not VarIsNullOrEmpty(ChargeSectionAccessible) then
        Add('ChargeSectionAccessible', Boolean(ChargeSectionAccessible));

      if not VarIsNullOrEmpty(RemovingAllowed) then
        Add('RemovingAllowed', Boolean(RemovingAllowed));

    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

end.
