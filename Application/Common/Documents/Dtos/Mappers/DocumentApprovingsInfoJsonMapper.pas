unit DocumentApprovingsInfoJsonMapper;

interface

uses

  DocumentFlowEmployeeInfoJsonMapper,
  DocumentFullInfoDTO,
  IGetSelfUnit,
  uLkJSON,
  SysUtils,
  Classes;

type

  IDocumentApprovingsInfoJsonMapper = interface (IGetSelf)

    function MapDocumentApprovingsInfoJsonList(const DocumentApprovingsInfoDTO: TDocumentApprovingsInfoDTO): TlkJSONlist;
    function MapDocumentApprovingsInfoJson(const DocumentApprovingsInfoDTO: TDocumentApprovingsInfoDTO): String;

  end;

  TDocumentApprovingsInfoJsonMapper = class (TInterfacedObject, IDocumentApprovingsInfoJsonMapper)

    private

      FEmployeeInfoJsonMapper: IDocumentFlowEmployeeInfoJsonMapper;

      function MapDocumentApprovingInfoJsonObject(const ApprovingInfoDTO: TDocumentApprovingInfoDTO): TlkJSONobject;
      
    public

      constructor Create(EmployeeInfoJsonMapper: IDocumentFlowEmployeeInfoJsonMapper);
      
      function GetSelf: TObject;
      
      function MapDocumentApprovingsInfoJsonList(const DocumentApprovingsInfoDTO: TDocumentApprovingsInfoDTO): TlkJSONlist;
      function MapDocumentApprovingsInfoJson(const DocumentApprovingsInfoDTO: TDocumentApprovingsInfoDTO): String;

  end;
  

implementation

uses

  Variants,
  VariantFunctions,
  DateTimeUtils;
  
{ TDocumentApprovingsInfoJsonMapper }

constructor TDocumentApprovingsInfoJsonMapper.Create(
  EmployeeInfoJsonMapper: IDocumentFlowEmployeeInfoJsonMapper);
begin

  inherited Create;

  FEmployeeInfoJsonMapper := EmployeeInfoJsonMapper;
  
end;

function TDocumentApprovingsInfoJsonMapper.GetSelf: TObject;
begin

  Result := Self;
  
end;

function TDocumentApprovingsInfoJsonMapper.MapDocumentApprovingsInfoJson(
  const DocumentApprovingsInfoDTO: TDocumentApprovingsInfoDTO): String;
var
    ApprovingsInfoJsonList: TlkJSONlist;
begin

  ApprovingsInfoJsonList := MapDocumentApprovingsInfoJsonList(DocumentApprovingsInfoDTO);

  try

    Result := TlkJSON.GenerateText(ApprovingsInfoJsonList);

  finally

    FreeAndNil(Result);
    
  end;

end;

function TDocumentApprovingsInfoJsonMapper.MapDocumentApprovingsInfoJsonList(
  const DocumentApprovingsInfoDTO: TDocumentApprovingsInfoDTO): TlkJSONlist;
var
    ApprovingInfoDTO: TDocumentApprovingInfoDTO;
begin

  Result := TlkJSONlist.Create;

  if not Assigned(DocumentApprovingsInfoDTO) then Exit;
  
  try

    for ApprovingInfoDTO in DocumentApprovingsInfoDTO do begin

      Result.Add(MapDocumentApprovingInfoJsonObject(ApprovingInfoDTO));
      
    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TDocumentApprovingsInfoJsonMapper.MapDocumentApprovingInfoJsonObject(
  const ApprovingInfoDTO: TDocumentApprovingInfoDTO): TlkJSONobject;
begin

  Result := TlkJSONobject.Create;

  try

    with ApprovingInfoDTO, Result do begin

      Add('Id', VarToStr(Id));

      if not VarIsNullOrEmpty(PerformingDateTime) then begin

        Add(
          'PerformingDateTime',
          FormatDateTime(TDateTimeUtils.ISO_8601_Format, PerformingDateTime)
        );

      end;

      Add('PerformingResultId', VarToStr(PerformingResultId));
      Add('PerformingResultName', PerformingResultName);
      Add('IsViewedByApprover', IsViewedByApprover);

      Add(
        'ApproverInfoDTO',
        FEmployeeInfoJsonMapper
          .MapDocumentFlowEmployeeInfoJsonObject(ApproverInfoDTO)
      );

      if Assigned(ActuallyPerformedEmployeeInfoDTO) then begin

        Add(
          'ActuallyPerformedEmployeeInfoDTO',
          FEmployeeInfoJsonMapper
            .MapDocumentFlowEmployeeInfoJsonObject(
              ActuallyPerformedEmployeeInfoDTO
            )
        );

      end;

    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

end.
