unit LoodsmanDocumentUploadingInfoMapper;

interface

uses

  LoodsmanDocumentUploadingStatus,
  LoodsmanDocumentUploadingInfo,
  LoodsmanDocumentsUploadingQueueTableDef,
  LoodsmanDocumentsUploadingAccessRights,
  DocumentInfoReadService,
  EmployeeInfoReadService,
  DocumentFullInfoDTO,
  DocumentFlowEmployeeInfoDTO,
  DataReader,
  SysUtils;

type

  ILoodsmanDocumentUploadingInfoMapper = interface

    function MapLoodsmanDocumentUploadingInfoFrom(
      DocumentsUploadingAccessRights: TLoodsmanDocumentsUploadingAccessRights;
      DataReader: IDataReader;
      EmployeeId: Variant;
      DocumentId: Variant
    ): TLoodsmanDocumentUploadingInfo;

    function MapLoodsmanDocumentUploadingStatus(const StatusName: String): TLoodsmanDocumentUploadingStatus;
    function MapLoodsmanDocumentUploadingStatusName(const Status: TLoodsmanDocumentUploadingStatus): String;

    function MapLoodsmanDocumentUploadingAccessRightsFrom(
      StatusInfo: TLoodsmanDocumentUploadingStatusInfo
    ): TLoodsmanDocumentUploadingAccessRights;

  end;

  TLoodsmanDocumentUploadingInfoMapper =
    class (TInterfacedObject, ILoodsmanDocumentUploadingInfoMapper)

      private

        FDocumentInfoReadService: IDocumentInfoReadService;
        FEmployeeInfoReadService: IEmployeeInfoReadService;
        FUploadingQueueTableDef: TLoodsmanDocumentsUploadingQueueTableDef;

      private

        function MapDocumentUploadingStatusInfoFrom(DataReader: IDataReader): TLoodsmanDocumentUploadingStatusInfo;
        function MapDocumentUploadingStatusFrom(DataReader: IDataReader): TLoodsmanDocumentUploadingStatus;
        function MapDocumentUploadingStatusDateTimeFrom(Status: TLoodsmanDocumentUploadingStatus; DataReader: IDataReader): TDateTime;

      private

        function MapDocumentUploadingInitiatorDTOFrom(
          DataReader: IDataReader
        ): TDocumentFlowEmployeeInfoDTO;

        function MapDocumentFullInfoDTOFrom(
          DataReader: IDataReader
        ): TDocumentFullInfoDTO; overload;

        function MapDocumentFullInfoDTOFrom(
          const DocumentId: Variant
        ): TDocumentFullInfoDTO; overload;
      
      public

        constructor Create(
          DocumentInfoReadService: IDocumentInfoReadService;
          EmployeeInfoReadService: IEmployeeInfoReadService;
          UploadingQueueTableDef: TLoodsmanDocumentsUploadingQueueTableDef
        );
      
        function MapLoodsmanDocumentUploadingInfoFrom(
          DocumentsUploadingAccessRights: TLoodsmanDocumentsUploadingAccessRights;
          DataReader: IDataReader;
          EmployeeId: Variant;
          DocumentId: Variant
        ): TLoodsmanDocumentUploadingInfo;

        function MapLoodsmanDocumentUploadingAccessRightsFrom(
          StatusInfo: TLoodsmanDocumentUploadingStatusInfo
        ): TLoodsmanDocumentUploadingAccessRights;
        
        function MapLoodsmanDocumentUploadingStatus(const StatusName: String): TLoodsmanDocumentUploadingStatus;
        function MapLoodsmanDocumentUploadingStatusName(const Status: TLoodsmanDocumentUploadingStatus): String;

    end;

implementation

uses

  Variants,
  VariantFunctions;

{ TLoodsmanDocumentUploadingInfoMapper }

constructor TLoodsmanDocumentUploadingInfoMapper.Create(
  DocumentInfoReadService: IDocumentInfoReadService;
  EmployeeInfoReadService: IEmployeeInfoReadService;
  UploadingQueueTableDef: TLoodsmanDocumentsUploadingQueueTableDef);
begin

  inherited Create;

  FDocumentInfoReadService := DocumentInfoReadService;
  FEmployeeInfoReadService := EmployeeInfoReadService;
  
  FUploadingQueueTableDef := UploadingQueueTableDef;
  
end;

function TLoodsmanDocumentUploadingInfoMapper
  .MapLoodsmanDocumentUploadingInfoFrom(
    DocumentsUploadingAccessRights: TLoodsmanDocumentsUploadingAccessRights;
    DataReader: IDataReader;
    EmployeeId: Variant;
    DocumentId: Variant
  ): TLoodsmanDocumentUploadingInfo;
begin

  Result := TLoodsmanDocumentUploadingInfo.Create;

  try

    Result.StatusInfo := MapDocumentUploadingStatusInfoFrom(DataReader);
    Result.AccessRights := MapLoodsmanDocumentUploadingAccessRightsFrom(Result.StatusInfo);

    if Result.StatusInfo.Status = usNotUploaded then
      Result.DocumentFullInfoDTO := MapDocumentFullInfoDTOFrom(DocumentId)

    else
      Result.DocumentFullInfoDTO := MapDocumentFullInfoDTOFrom(DataReader);

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TLoodsmanDocumentUploadingInfoMapper.MapDocumentUploadingStatusInfoFrom(
  DataReader: IDataReader): TLoodsmanDocumentUploadingStatusInfo;
var
    Status: TLoodsmanDocumentUploadingStatus;
    StatusDateTime: TDateTime;
    StatusInitiatorDTO: TDocumentFlowEmployeeInfoDTO;
    StatusInitiatorIdColumnName: String;
    StatusInitiatorId: Variant;
    ErrorMessage: String;
begin

  Status := MapDocumentUploadingStatusFrom(DataReader);

  if Status = usNotUploaded then begin

    StatusDateTime := 0;
    StatusInitiatorDTO := nil;
    ErrorMessage := '';
    
  end

  else begin

    StatusDateTime := MapDocumentUploadingStatusDateTimeFrom(Status, DataReader);

    StatusInitiatorIdColumnName :=
      FUploadingQueueTableDef.GetStatusInitiatorIdColumnNameByStatus(Status);

    if StatusInitiatorIdColumnName <> '' then begin

      StatusInitiatorId := DataReader[StatusInitiatorIdColumnName];

      StatusInitiatorDTO :=
        FEmployeeInfoReadService.GetEmployeeInfo(StatusInitiatorId);

      ErrorMessage := VarToStr(DataReader[FUploadingQueueTableDef.ErrorMessageColumnName]);

    end;

  end;

  Result :=
    TLoodsmanDocumentUploadingStatusInfo.Create(
      Status,
      StatusDateTime,
      StatusInitiatorDTO,
      ErrorMessage
    );
    
end;

function TLoodsmanDocumentUploadingInfoMapper
  .MapDocumentUploadingStatusDateTimeFrom(
    Status: TLoodsmanDocumentUploadingStatus;
    DataReader: IDataReader
  ): TDateTime;
var
    StatusDateTimeColumnName: String;
    StatusDateTimeVariant: Variant;
begin

  StatusDateTimeColumnName :=
    FUploadingQueueTableDef.GetStatusDateTimeColumnNameByStatus(Status);

  StatusDateTimeVariant := DataReader[StatusDateTimeColumnName];

  if not VarIsNullOrEmpty(StatusDateTimeVariant) then
    Result := StatusDateTimeVariant;

end;

function TLoodsmanDocumentUploadingInfoMapper.MapDocumentUploadingStatusFrom(
  DataReader: IDataReader): TLoodsmanDocumentUploadingStatus;
var
    StatusVariant: Variant;
    StatusName: String;
begin

  StatusVariant := DataReader[FUploadingQueueTableDef.StatusColumnName];

  if VarIsNullOrEmpty(StatusVariant) then
    StatusName := TLoodsmanDocumentsUploadingQueueTableDef.NOT_UPLOADED_STATUS_NAME

  else StatusName := StatusVariant;
  
  Result := MapLoodsmanDocumentUploadingStatus(StatusName);
  
end;

function TLoodsmanDocumentUploadingInfoMapper.MapLoodsmanDocumentUploadingStatus(
  const StatusName: String): TLoodsmanDocumentUploadingStatus;
begin

  if StatusName = TLoodsmanDocumentsUploadingQueueTableDef.NOT_UPLOADED_STATUS_NAME then
    Result := usNotUploaded

  else if StatusName = TLoodsmanDocumentsUploadingQueueTableDef.UPLOADING_REQUESTED_STATUS_NAME then
    Result := usUploadingRequested

  else if StatusName = TLoodsmanDocumentsUploadingQueueTableDef.UPLOADING_STATUS_NAME then
    Result := usUploading

  else if StatusName = TLoodsmanDocumentsUploadingQueueTableDef.CANCELATION_REQUESTED_STATUS_NAME then
    Result := usCancelationRequested

  else if StatusName = TLoodsmanDocumentsUploadingQueueTableDef.CANCELING_STATUS_NAME then
    Result := usCanceling

  else if StatusName = TLoodsmanDocumentsUploadingQueueTableDef.CANCELED_STATUS_NAME then
    Result := usCanceled

  else if StatusName = TLoodsmanDocumentsUploadingQueueTableDef.UPLOADED_STATUS_NAME then
    Result := usUploaded

  else Result := usUnknown;

end;

function TLoodsmanDocumentUploadingInfoMapper.MapLoodsmanDocumentUploadingStatusName(
  const Status: TLoodsmanDocumentUploadingStatus): String;
begin

  case Status of
    usNotUploaded:
      Result := TLoodsmanDocumentsUploadingQueueTableDef.NOT_UPLOADED_STATUS_NAME;

    usUploadingRequested:
      result := TLoodsmanDocumentsUploadingQueueTableDef.UPLOADING_REQUESTED_STATUS_NAME;

    usUploading:
      Result := TLoodsmanDocumentsUploadingQueueTableDef.UPLOADING_STATUS_NAME;

    usCancelationRequested:
      Result := TLoodsmanDocumentsUploadingQueueTableDef.CANCELATION_REQUESTED_STATUS_NAME;
      
    usCanceling:
      Result := TLoodsmanDocumentsUploadingQueueTableDef.CANCELING_STATUS_NAME;
      
    usCanceled:
      Result := TLoodsmanDocumentsUploadingQueueTableDef.CANCELED_STATUS_NAME;
      
    usUploaded:
      Result := TLoodsmanDocumentsUploadingQueueTableDef.UPLOADED_STATUS_NAME;
      
    usUnknown: Result := TLoodsmanDocumentsUploadingQueueTableDef.UNKNOWN_STATUS_NAME;

    else Result := '';

  end;
  
end;

function TLoodsmanDocumentUploadingInfoMapper.MapLoodsmanDocumentUploadingAccessRightsFrom(
  StatusInfo: TLoodsmanDocumentUploadingStatusInfo): TLoodsmanDocumentUploadingAccessRights;
begin

  Result := TLoodsmanDocumentUploadingAccessRights.Create;

  Result.UploadingAllowed := StatusInfo.Status in [usNotUploaded, usCanceled];
  Result.CancellationAllowed := StatusInfo.Status in [usUploadingRequested];
  
end;

function TLoodsmanDocumentUploadingInfoMapper.MapDocumentFullInfoDTOFrom(
  DataReader: IDataReader): TDocumentFullInfoDTO;
var
    DocumentId: Variant;
begin

  DocumentId := DataReader[FUploadingQueueTableDef.DocumentIdColumnName];

  Result := MapDocumentFullInfoDTOFrom(DocumentId);

end;

function TLoodsmanDocumentUploadingInfoMapper.MapDocumentFullInfoDTOFrom(
  const DocumentId: Variant): TDocumentFullInfoDTO;
begin

  Result := FDocumentInfoReadService.GetDocumentFullInfo(DocumentId);

end;

function TLoodsmanDocumentUploadingInfoMapper.MapDocumentUploadingInitiatorDTOFrom(
  DataReader: IDataReader): TDocumentFlowEmployeeInfoDTO;
var
    InitiatorId: Variant;
begin

  InitiatorId := DataReader[FUploadingQueueTableDef.InitiatorIdColumnName];

  Result := FEmployeeInfoReadService.GetEmployeeInfo(InitiatorId);

end;

end.
