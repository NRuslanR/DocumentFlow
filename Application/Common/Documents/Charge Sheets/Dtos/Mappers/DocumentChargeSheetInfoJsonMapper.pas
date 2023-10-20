unit DocumentChargeSheetInfoJsonMapper;

interface

uses

  DocumentChargeSheetsInfoDTO,
  DocumentFlowEmployeeInfoJsonMapper,
  IGetSelfUnit,
  uLkJSON,
  SysUtils,
  Classes;

type

  IDocumentChargeSheetInfoJsonMapper = interface (IGetSelf)

    function MapDocumentChargeSheetInfoJsonObject(const ChargeSheetInfoDTO: TDocumentChargeSheetInfoDTO): TlkJSONobject;
    function MapDocumentChargeSheetInfoJson(const ChargeSheetInfoDTO: TDocumentChargeSheetInfoDTO): String;

  end;

  TDocumentChargeSheetInfoJsonMapper = class (TInterfacedObject, IDocumentChargeSheetInfoJsonMapper)

    private

      FEmployeeInfoJsonMapper: IDocumentFlowEmployeeInfoJsonMapper;

      function MapDocumentChargeSheetAccessRightsJsonObject(
        const AccessRights: TDocumentChargeSheetAccessRightsDTO
      ): TlkJSONobject;

    public

      constructor Create(EmployeeInfoJsonMapper: IDocumentFlowEmployeeInfoJsonMapper);

      function GetSelf: TObject;

      function MapDocumentChargeSheetInfoJsonObject(const ChargeSheetInfoDTO: TDocumentChargeSheetInfoDTO): TlkJSONobject;
      function MapDocumentChargeSheetInfoJson(const ChargeSheetInfoDTO: TDocumentChargeSheetInfoDTO): String;

  end;

implementation

uses

  Variants,
  VariantFunctions,
  DateTimeUtils;

{ TDocumentChargeSheetInfoJsonMapper }

constructor TDocumentChargeSheetInfoJsonMapper.Create(
  EmployeeInfoJsonMapper: IDocumentFlowEmployeeInfoJsonMapper);
begin

  inherited Create;

  FEmployeeInfoJsonMapper := EmployeeInfoJsonMapper;
  
end;

function TDocumentChargeSheetInfoJsonMapper.GetSelf: TObject;
begin

  Result := Self;
  
end;

function TDocumentChargeSheetInfoJsonMapper.MapDocumentChargeSheetInfoJson(
  const ChargeSheetInfoDTO: TDocumentChargeSheetInfoDTO): String;
var
    ChargeSheetInfoJsonObject: TlkJSONobject;
begin

  ChargeSheetInfoJsonObject := MapDocumentChargeSheetInfoJsonObject(ChargeSheetInfoDTO);

  try

    Result := TlkJSON.GenerateText(ChargeSheetInfoJsonObject);
    
  finally

    FreeAndNil(ChargeSheetInfoJsonObject);

  end;

end;

function TDocumentChargeSheetInfoJsonMapper.MapDocumentChargeSheetInfoJsonObject(
  const ChargeSheetInfoDTO: TDocumentChargeSheetInfoDTO): TlkJSONobject;
begin

  Result := TlkJSONobject.Create;

  try

    with ChargeSheetInfoDTO, Result do begin

      Add('Id', VarToStr(Id));
      Add('KindId', VarToStr(KindId));
      Add('KindName', KindName);
      Add('ServiceKindName', ServiceKindName);
      Add('TopLevelChargeSheetId', VarToStr(TopLevelChargeSheetId));
      Add('DocumentId', VarToStr(DocumentId));
      Add('DocumentKindId', VarToStr(DocumentKindId));

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

      if not VarIsNullOrEmpty(IssuingDateTime) then begin

        Add(
          'IssuingDateTime',
          FormatDateTime(TDateTimeUtils.ISO_8601_Format, IssuingDateTime)
        );

      end;

      if not VarIsNullOrEmpty(PerformingDateTime) then begin

        Add(
          'PerformingDateTime',
          FormatDateTime(TDateTimeUtils.ISO_8601_Format, PerformingDateTime)
        );

      end;

      Add('IsForAcquaitance', IsForAcquaitance);

      if not VarIsNullOrEmpty(ViewDateByPerformer) then begin

        Add(
          'ViewingDateByPerformer',
          FormatDateTime(TDateTimeUtils.ISO_8601_Format, ViewDateByPerformer)
        );

      end;

      Add(
        'PerformerInfoDTO',
        FEmployeeInfoJsonMapper.MapDocumentFlowEmployeeInfoJsonObject(
          PerformerInfoDTO
        )
      );

      if Assigned(ActuallyPerformedEmployeeInfoDTO) then begin

        Add(
          'ActuallyPerformedEmployeeInfoDTO',
          FEmployeeInfoJsonMapper.MapDocumentFlowEmployeeInfoJsonObject(
            ActuallyPerformedEmployeeInfoDTO
          )
        );

      end;

      Add(
        'IssuerInfoDTO',
        FEmployeeInfoJsonMapper.MapDocumentFlowEmployeeInfoJsonObject(
          IssuerInfoDTO
        )
      );

      Add(
        'AccessRights',
        MapDocumentChargeSheetAccessRightsJsonObject(
          AccessRights
        )
      );

    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TDocumentChargeSheetInfoJsonMapper.MapDocumentChargeSheetAccessRightsJsonObject(
  const AccessRights: TDocumentChargeSheetAccessRightsDTO): TlkJSONobject;
begin

  Result := TlkJSONobject.Create;

  try

    with AccessRights, Result do begin

      if not VarIsNullOrEmpty(ViewingAllowed) then
        Add('ViewingAllowed', Boolean(ViewingAllowed));

      if not VarIsNullOrEmpty(ChargeSectionAccessible) then
        Add('ChargeSectionAccessible', Boolean(ChargeSectionAccessible));

      if not VarIsNullOrEmpty(ResponseSectionAccessible) then
        Add('ResponseSectionAccessible', Boolean(ResponseSectionAccessible));

      if not VarIsNullOrEmpty(RemovingAllowed) then
        Add('RemovingAllowed', Boolean(RemovingAllowed));

      if not VarIsNullOrEmpty(PerformingAllowed) then
        Add('PerformingAllowed', Boolean(PerformingAllowed));
      
    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

end.
