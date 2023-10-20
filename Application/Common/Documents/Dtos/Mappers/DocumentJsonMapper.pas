unit DocumentJsonMapper;

interface

uses

  DocumentFullInfoDTO,
  DocumentResponsibleInfoJsonMapper,
  DocumentApprovingsInfoJsonMapper,
  DocumentChargesInfoJsonMapper,
  DocumentFlowEmployeeInfoJsonMapper,
  IGetSelfUnit,
  uLkJSON,
  SysUtils,
  Classes;

type

  IDocumentJsonMapper = interface (IGetSelf)

    function MapDocumentJsonObject(const DocumentDTO: TDocumentDTO): TlkJSONobject;
    function MapDocumentJson(const DocumentDTO: TDocumentDTO): String;

  end;

  TDocumentJsonMapper = class (TInterfacedObject, IDocumentJsonMapper)

    private

      FApprovingsInfoJsonMapper: IDocumentApprovingsInfoJsonMapper;
      FChargesInfoJsonMapper: IDocumentChargesInfoJsonMapper;
      FResponsibleInfoJsonMapper: IDocumentResponsibleInfoJsonMapper;
      FEmployeeInfoJsonMapper: IDocumentFlowEmployeeInfoJsonMapper;

      function MapSigningsInfoJsonList(const SigningsInfoDTO: TDocumentSigningsInfoDTO): TlkJSONlist;
      function MapSigningInfoJsonObject(const SigningInfoDTO: TDocumentSigningInfoDTO): TlkJSONobject;
      
    public

      constructor Create(
        ApprovingsInfoJsonMapper: IDocumentApprovingsInfoJsonMapper;
        ChargesInfoJsonMapper: IDocumentChargesInfoJsonMapper;
        ResponsibleInfoJsonMapper: IDocumentResponsibleInfoJsonMapper;
        EmployeeInfoJsonMapper: IDocumentFlowEmployeeInfoJsonMapper
      );

      function GetSelf: TObject;

      function MapDocumentJsonObject(const DocumentDTO: TDocumentDTO): TlkJSONobject;
      function MapDocumentJson(const DocumentDTO: TDocumentDTO): String;

  end;

implementation

uses

  DateUtils,
  Variants,
  DateTimeUtils,
  VariantFunctions;

{ TDocumentJsonMapper }

constructor TDocumentJsonMapper.Create(
  ApprovingsInfoJsonMapper: IDocumentApprovingsInfoJsonMapper;
  ChargesInfoJsonMapper: IDocumentChargesInfoJsonMapper;
  ResponsibleInfoJsonMapper: IDocumentResponsibleInfoJsonMapper;
  EmployeeInfoJsonMapper: IDocumentFlowEmployeeInfoJsonMapper
);
begin

  inherited Create;

  FApprovingsInfoJsonMapper := ApprovingsInfoJsonMapper;
  FChargesInfoJsonMapper := ChargesInfoJsonMapper;
  FResponsibleInfoJsonMapper := ResponsibleInfoJsonMapper;
  FEmployeeInfoJsonMapper := EmployeeInfoJsonMapper;
                                   
end;

function TDocumentJsonMapper.GetSelf: TObject;
begin

  Result := Self;
  
end;

function TDocumentJsonMapper.MapDocumentJson(
  const DocumentDTO: TDocumentDTO): String;
var
    DocumentJsonObject: TlkJSONobject;
begin

  DocumentJsonObject := MapDocumentJsonObject(DocumentDTO);

  try

    Result := TlkJSON.GenerateText(DocumentJsonObject);
    
  finally

    FreeAndNil(DocumentJsonObject);

  end;

end;

function TDocumentJsonMapper.MapDocumentJsonObject(
  const DocumentDTO: TDocumentDTO): TlkJSONobject;
var
    TargetDocumentDate: TDateTime;
begin

  Result := TlkJSONobject.Create;
          
  try

    with DocumentDTO, Result do begin

      if not VarIsNullOrEmpty(DocumentDate) then
        TargetDocumentDate := DocumentDate

      else TargetDocumentDate := 0;
                                               
      Add('Id', VarToStr(Id));
      Add('Number', Number);
      Add('SeparatorOfNumberParts', SeparatorOfNumberParts);
      Add('Name', Name);
      Add('FullName', FullName);
      Add('Content', Content);
      Add('CreationDate', VarToStr(CreationDate));

      if not VarIsNullOrEmpty(DocumentDate) then begin

        Add(
          'DocumentDate',
          FormatDateTime(TDateTimeUtils.ISO_8601_Format, DocumentDate)
        );

      end;

      Add('Note', Note);
      Add('KindId', VarToStr(KindId));
      Add('Kind', Kind);
      Add('CurrentWorkCycleStageNumber', CurrentWorkCycleStageNumber);
      Add('CurrentWorkCycleStageName', CurrentWorkCycleStageName);

      if not VarIsNullOrEmpty(IsSelfRegistered) then
        Add('IsSelfRegistered', Boolean(IsSelfRegistered));
      
      Add(
        'AuthorDTO',
        FEmployeeInfoJsonMapper.MapDocumentFlowEmployeeInfoJsonObject(AuthorDTO)
      );

      Add(
        'ChargesInfoDTO',
        FChargesInfoJsonMapper.MapDocumentChargesInfoJsonList(ChargesInfoDTO)
      );

      Add(
        'ApprovingsInfoDTO',
        FApprovingsInfoJsonMapper
          .MapDocumentApprovingsInfoJsonList(ApprovingsInfoDTO)
      );

      Add('SigningsInfoDTO', MapSigningsInfoJsonList(SigningsInfoDTO));

      Add(
        'ResponsibleInfoDTO',
        FResponsibleInfoJsonMapper
          .MapDocumentResponsibleInfoJsonObject(ResponsibleInfoDTO)
      );
      
    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TDocumentJsonMapper.MapSigningsInfoJsonList(
  const SigningsInfoDTO: TDocumentSigningsInfoDTO): TlkJSONlist;
var
    SigningInfoDTO: TDocumentSigningInfoDTO;
begin

  Result := TlkJSONlist.Create;

  if not Assigned(SigningsInfoDTO) then Exit;
  
  try

    for SigningInfoDTO in SigningsInfoDTO do begin

      Result.Add(MapSigningInfoJsonObject(SigningInfoDTO));
      
    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TDocumentJsonMapper.MapSigningInfoJsonObject(
  const SigningInfoDTO: TDocumentSigningInfoDTO): TlkJSONobject;
begin

  Result := TlkJSONobject.Create;

  try

    with SigningInfoDTO, Result do begin

      Add('Id', VarToStr(Id));

      if not VarIsNullOrEmpty(SigningDate) then begin

        Add(
          'SigningDate',
          FormatDateTime(TDateTimeUtils.ISO_8601_Format, SigningDate)
        );
        
      end;

      Add(
        'SignerInfoDTO',
        FEmployeeInfoJsonMapper
          .MapDocumentFlowEmployeeInfoJsonObject(SignerInfoDTO)
      );

      Add(
        'ActuallySignedEmployeeInfoDTO',
        FEmployeeInfoJsonMapper
          .MapDocumentFlowEmployeeInfoJsonObject(ActuallySignedEmployeeInfoDTO)
      );
      
    end;

  except

    FreeAndNil(Result);

    Raise;
    
  end;

end;

end.
