unit DocumentFullInfoJsonMapper;

interface

uses

  DocumentFullInfoDTO,
  DocumentJsonMapper,
  DocumentApprovingsInfoJsonMapper,
  DocumentChargeSheetsInfoJsonMapper,
  DocumentFlowEmployeeInfoJsonMapper,
  IGetSelfUnit,
  uLkJSON,
  SysUtils,
  Classes;

type

  IDocumentFullInfoJsonMapper = interface (IGetSelf)

    function MapDocumentFullInfoJsonObject(const DocumentFullInfoDTO: TDocumentFullInfoDTO): TlkJSONobject;
    function MapDocumentFullInfoJson(const DocumentFullInfoDTO: TDocumentFullInfoDTO): String;

  end;

  TDocumentFullInfoJsonMapper = class (TInterfacedObject, IDocumentFullInfoJsonMapper)

    private

      FDocumentJsonMapper: IDocumentJsonMapper;
      FApprovingsInfoJsonMapper: IDocumentApprovingsInfoJsonMapper;
      FChargeSheetsInfoJsonMapper: IDocumentChargeSheetsInfoJsonMapper;

    private

      function MapDocumentRelationsInfoJsonList(
        const RelationsInfoDTO: TDocumentRelationsInfoDTO
      ): TlkJSONlist;

      function MapRelationInfoJsonObject(
        const RelationInfoDTO: TDocumentRelationInfoDTO
      ): TlkJSONobject;

    private

      function MapDocumentFilesInfoJsonList(
        const FilesInfoDTO: TDocumentFilesInfoDTO
      ): TlkJSONlist;

      function MapFileInfoJsonObject(
        const FileInfoDTO: TDocumentFileInfoDTO
      ): TlkJSONobject;
      
    private

      function MapDocumentApprovingCycleResultsInfoJsonList(
        const ApprovingCycleResultsInfoDTO: TDocumentApprovingCycleResultsInfoDTO
      ): TlkJSONlist;

      function MapApprovingCycleResultInfoJsonObject(
        const ApprovingCycleResultInfoDTO: TDocumentApprovingCycleResultInfoDTO
      ): TlkJSONobject;
      
    public

      constructor Create(
        DocumentJsonMapper: IDocumentJsonMapper;
        ApprovingsInfoJsonMapper: IDocumentApprovingsInfoJsonMapper;
        ChargeSheetsInfoJsonMapper: IDocumentChargeSheetsInfoJsonMapper
      );

      function GetSelf: TObject;
      
      function MapDocumentFullInfoJsonObject(const DocumentFullInfoDTO: TDocumentFullInfoDTO): TlkJSONobject;
      function MapDocumentFullInfoJson(const DocumentFullInfoDTO: TDocumentFullInfoDTO): String;

  end;
  
implementation

uses

  Variants;
  
{ TDocumentFullInfoJsonMapper }

constructor TDocumentFullInfoJsonMapper.Create(
  DocumentJsonMapper: IDocumentJsonMapper;
  ApprovingsInfoJsonMapper: IDocumentApprovingsInfoJsonMapper;
  ChargeSheetsInfoJsonMapper: IDocumentChargeSheetsInfoJsonMapper);
begin

  inherited Create;

  FDocumentJsonMapper := DocumentJsonMapper;
  FApprovingsInfoJsonMapper := ApprovingsInfoJsonMapper;
  FChargeSheetsInfoJsonMapper := ChargeSheetsInfoJsonMapper;
  
end;

function TDocumentFullInfoJsonMapper.GetSelf: TObject;
begin

  Result := Self;
  
end;

function TDocumentFullInfoJsonMapper.MapDocumentFullInfoJson(
  const DocumentFullInfoDTO: TDocumentFullInfoDTO): String;
var
    DocumentFullInfoJsonObject: TlkJSONobject;
    level: Integer;
begin

  DocumentFullInfoJsonObject := MapDocumentFullInfoJsonObject(DocumentFullInfoDTO);
  
  try

    level := 0;
    
    Result := //TlkJSON.GenerateText(DocumentFullInfoJsonObject);
      GenerateReadableText(DocumentFullInfoJsonObject, level);
    
  finally

    FreeAndNil(DocumentFullInfoJsonObject);

  end;
  
end;

function TDocumentFullInfoJsonMapper.MapDocumentFullInfoJsonObject(
  const DocumentFullInfoDTO: TDocumentFullInfoDTO): TlkJSONobject;
begin

  Result := TlkJSONobject.Create;

  try

    with DocumentFullInfoDTO, Result do begin

      Add(
        'DocumentDTO',
        FDocumentJsonMapper.MapDocumentJsonObject(DocumentDTO)
      );

      Add(
        'DocumentRelationsInfoDTO',
        MapDocumentRelationsInfoJsonList(DocumentRelationsInfoDTO)
      );

      Add(
        'DocumentFilesInfoDTO',
        MapDocumentFilesInfoJsonList(DocumentFilesInfoDTO)
      );

      Add(
        'DocumentApprovingCycleResultsInfoDTO',
        MapDocumentApprovingCycleResultsInfoJsonList(
          DocumentApprovingCycleResultsInfoDTO
        )
      );

      Add(
        'DocumentChargeSheetsInfoDTO',
        FChargeSheetsInfoJsonMapper.MapDocumentChargeSheetsInfoJsonList(
          DocumentChargeSheetsInfoDTO
        )
      );

    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TDocumentFullInfoJsonMapper.MapDocumentRelationsInfoJsonList(
  const RelationsInfoDTO: TDocumentRelationsInfoDTO): TlkJSONlist;
var
    RelationInfoDTO: TDocumentRelationInfoDTO;
begin

  Result := TlkJSONlist.Create;

  if not Assigned(RelationsInfoDTO) then Exit;

  try

    for RelationInfoDTO in RelationsInfoDTO do
      Result.Add(MapRelationInfoJsonObject(RelationInfoDTO));

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TDocumentFullInfoJsonMapper.MapRelationInfoJsonObject(
  const RelationInfoDTO: TDocumentRelationInfoDTO): TlkJSONobject;
begin

  Result := TlkJSONobject.Create;

  try

    with RelationInfoDTO, Result do begin

      Add('TargetDocumentId', VarToStr(TargetDocumentId));
      Add('RelatedDocumentId', VarToStr(RelatedDocumentId));
      Add('RelatedDocumentKindId', VarToStr(RelatedDocumentKindId));
      Add('RelatedDocumentKindName', RelatedDocumentKindName);
      Add('RelatedDocumentNumber', RelatedDocumentNumber);
      Add('RelatedDocumentName', RelatedDocumentName);
      Add('RelatedDocumentDate', VarToStr(RelatedDocumentDate));
      
    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TDocumentFullInfoJsonMapper.MapDocumentFilesInfoJsonList(
  const FilesInfoDTO: TDocumentFilesInfoDTO): TlkJSONlist;
var
    FileInfoDTO: TDocumentFileInfoDTO;
begin

  Result := TlkJSONlist.Create;

  if not Assigned(FilesInfoDTO) then Exit;

  try

    for FileInfoDTO in FilesInfoDTO do
      Result.Add(MapFileInfoJsonObject(FileInfoDTO));

  except

    FreeAndNil(Result);

    Raise;

  end;
  
end;

function TDocumentFullInfoJsonMapper.MapFileInfoJsonObject(
  const FileInfoDTO: TDocumentFileInfoDTO): TlkJSONobject;
begin

  Result := TlkJSONobject.Create;

  try

    with FileInfoDTO, Result do begin

      Add('Id', VarToStr(Id));
      Add('DocumentId', VarToStr(DocumentId));
      Add('FileName', FileName);
      Add('FilePath', FilePath);
      
    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TDocumentFullInfoJsonMapper.MapDocumentApprovingCycleResultsInfoJsonList(
  const ApprovingCycleResultsInfoDTO: TDocumentApprovingCycleResultsInfoDTO): TlkJSONlist;
var
    ApprovingCycleResultInfoDTO: TDocumentApprovingCycleResultInfoDTO;
begin

  Result := TlkJSONlist.Create;

  if not Assigned(ApprovingCycleResultsInfoDTO) then Exit;
  
  try

    for ApprovingCycleResultInfoDTO in ApprovingCycleResultsInfoDTO do
      Result.Add(MapApprovingCycleResultInfoJsonObject(ApprovingCycleResultInfoDTO));

  except

    FreeAndNil(Result);

    Raise;

  end;
  
end;

function TDocumentFullInfoJsonMapper.MapApprovingCycleResultInfoJsonObject(
  const ApprovingCycleResultInfoDTO: TDocumentApprovingCycleResultInfoDTO): TlkJSONobject;
begin

  Result := TlkJSONobject.Create;

  try

    with ApprovingCycleResultInfoDTO, Result do begin

      Add('Id', VarToStr(Id));
      Add('CycleNumber', CycleNumber);

      Add(
        'DocumentApprovingsInfoDTO',
        FApprovingsInfoJsonMapper.MapDocumentApprovingsInfoJsonList(
          DocumentApprovingsInfoDTO
        )
      );
      
    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;


end.
