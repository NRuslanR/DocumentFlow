unit BasedOnDatabaseLoodsmanDocumentsUploadingService;

interface

uses

  LoodsmanDocumentUploadingStatus,
  LoodsmanDocumentsUploadingService,
  LoodsmanDocumentUploadingInfo,
  AbstractApplicationService,
  LoodsmanDocumentsUploadingAccessRightsService,
  LoodsmanDocumentsUploadingQueueTableDef,
  LoodsmanDocumentsUploadingAccessRights,
  LoodsmanDocumentUploadingInfoMapper,
  LoodsmanDocumentUploadingStatusChangingEnsurer,
  DocumentFullInfoDTO,
  DocumentFullInfoJsonMapper,
  Session,
  QueryExecutor,
  NameValue,
  DataReader,
  SysUtils,
  Classes;

type

  TBasedOnDatabaseLoodsmanDocumentsUploadingService =
    class (TAbstractApplicationService, ILoodsmanDocumentsUploadingService)

      private

        FDocumentUploadingInfoGettingQueryPattern: String;

      private

        FSession: ISession;
        FUploadingAccessRightsService: ILoodsmanDocumentsUploadingAccessRightsService;
        FQueryExecutor: IQueryExecutor;
        FUploadingQueueTableDef: TLoodsmanDocumentsUploadingQueueTableDef;
        FDocumentUploadingInfoMapper: ILoodsmanDocumentUploadingInfoMapper;
        FDocumentFullInfoJsonMapper: IDocumentFullInfoJsonMapper;
        FDocumentUploadingStatusChangingEnsurer: ILoodsmanDocumentUploadingStatusChangingEnsurer;
        
      private

        function PrepareDocumentUploadingInfoGettingQueryPattern(
          TableDef: TLoodsmanDocumentsUploadingQueueTableDef
        ): String;

      private

        function ExecuteDocumentUploadingInfoGettingQuery(
          const QueryPattern: String;
          const DocumentId: Variant
        ): IDataReader;

        function ExecuteDocumentUploadingInfoAddingQuery(
          const InitiatorId: Variant;
          const DocumentFullInfoDTO: TDocumentFullInfoDTO;
          const Attributes: array of TNameValue
        ): Boolean;

        function ExecuteDocumentUploadingInfoSavingQuery(
          const DocumentId: Variant;
          const Attributes: array of TNameValue
        ): Boolean;

      private

        function ChangeLoodsmanDocumentUploadingInfo(
          const EmployeeId: Variant;
          const DocumentId: Variant;
          Attributes: array of TNameValue
        ): TLoodsmanDocumentUploadingInfo;

        procedure EnsureDocumentUploadingStatusChangingAllowed(
          DocumentUploadingInfo: TLoodsmanDocumentUploadingInfo;
          const NewStatus: TLoodsmanDocumentUploadingStatus
        );
        
        function ChangeLoodsmanDocumentUploadingStatusInfo(
          const EmployeeId: Variant;
          const DocumentId: Variant;
          const Status: TLoodsmanDocumentUploadingStatus;
          const StatusDateTime: TDateTime
        ):TLoodsmanDocumentUploadingInfo;

      private

        function GetValidLoodsmanDocumentUploadingInfo(
          CommonUploadingAccessRights: TLoodsmanDocumentsUploadingAccessRights;
          const EmployeeId: Variant;
          const DocumentId: Variant
        ): TLoodsmanDocumentUploadingInfo;

        function GetInvalidLoodsmanDocumentUploadingInfo(
          CommonUploadingAccessRights: TLoodsmanDocumentsUploadingAccessRights
        ): TLoodsmanDocumentUploadingInfo;
        
      private

        function MapLoodsmanDocumentUploadingInfoFrom(
          CommonUploadingAccessRights: TLoodsmanDocumentsUploadingAccessRights;
          DataReader: IDataReader;
          const EmployeeId: Variant;
          const DocumentId: Variant
        ): TLoodsmanDocumentUploadingInfo;
        
      public

        constructor Create(
          Session: ISession;
          UploadingAccessRightsService: ILoodsmanDocumentsUploadingAccessRightsService;
          QueryExecutor: IQueryExecutor;
          UploadingQueueTableDef: TLoodsmanDocumentsUploadingQueueTableDef;
          DocumentUploadingInfoMapper: ILoodsmanDocumentUploadingInfoMapper;
          DocumentFullInfoJsonMapper: IDocumentFullInfoJsonMapper;
          DocumentUploadingStatusChangingEnsurer: ILoodsmanDocumentUploadingStatusChangingEnsurer
        );

        function EnsureAccessRightsAndGetLoodsmanDocumentUploadingInfo(
          const EmployeeId: Variant;
          const DocumentId: Variant
        ): TLoodsmanDocumentUploadingInfo;

        function GetLoodsmanDocumentUploadingInfo(
          const EmployeeId: Variant;
          const DocumentId: Variant
        ): TLoodsmanDocumentUploadingInfo;

        function RunDocumentUploadingToLoodsman(
          const EmployeeId: Variant;
          const DocumentId: Variant
        ): TLoodsmanDocumentUploadingInfo;

        function RunCancellationDocumentUploadingToLoodsman(
          const EmployeeId: Variant;
          const DocumentId: Variant
        ): TLoodsmanDocumentUploadingInfo;

    end;

implementation

uses

  StrUtils,
  VariantListUnit,
  AuxiliaryStringFunctions;

{ TBasedOnDatabaseLoodsmanDocumentsUploadingService }

constructor TBasedOnDatabaseLoodsmanDocumentsUploadingService.Create(
  Session: ISession;
  UploadingAccessRightsService: ILoodsmanDocumentsUploadingAccessRightsService;
  QueryExecutor: IQueryExecutor;
  UploadingQueueTableDef: TLoodsmanDocumentsUploadingQueueTableDef;
  DocumentUploadingInfoMapper: ILoodsmanDocumentUploadingInfoMapper;
  DocumentFullInfoJsonMapper: IDocumentFullInfoJsonMapper;
  DocumentUploadingStatusChangingEnsurer: ILoodsmanDocumentUploadingStatusChangingEnsurer
);
begin

  inherited Create;
                    
  FSession := Session;
  FUploadingAccessRightsService := UploadingAccessRightsService;
  FQueryExecutor := QueryExecutor;
  FUploadingQueueTableDef := UploadingQueueTableDef;
  FDocumentUploadingInfoMapper := DocumentUploadingInfoMapper;
  FDocumentFullInfoJsonMapper := DocumentFullInfoJsonMapper;
  FDocumentUploadingStatusChangingEnsurer := DocumentUploadingStatusChangingEnsurer;

  FDocumentUploadingInfoGettingQueryPattern :=
    PrepareDocumentUploadingInfoGettingQueryPattern(FUploadingQueueTableDef);

end;

function TBasedOnDatabaseLoodsmanDocumentsUploadingService
  .PrepareDocumentUploadingInfoGettingQueryPattern(
    TableDef: TLoodsmanDocumentsUploadingQueueTableDef
  ): String;
begin

  with TableDef do begin

    Result :=
      Format(
        'SELECT * FROM %s WHERE %s = :p%s FOR UPDATE',
        [
          TableName,

          DocumentIdColumnName, DocumentIdColumnName
        ]
      );

  end;

end;

function TBasedOnDatabaseLoodsmanDocumentsUploadingService
  .GetLoodsmanDocumentUploadingInfo(
    const EmployeeId, DocumentId: Variant
  ): TLoodsmanDocumentUploadingInfo;
var
    CommonUploadingAccessRights: TLoodsmanDocumentsUploadingAccessRights;
    FreeCommonUploadingAccessRights: ILoodsmanDocumentsUploadingAccessRights;
begin

  CommonUploadingAccessRights :=
    FUploadingAccessRightsService
      .GetEmployeeLoodsmanDocumentsUploadingAccessRights(EmployeeId);

  FreeCommonUploadingAccessRights := CommonUploadingAccessRights;

  if CommonUploadingAccessRights.UploadingAccessible then
    Result := GetValidLoodsmanDocumentUploadingInfo(CommonUploadingAccessRights, EmployeeId, DocumentId)

  else Result := GetInvalidLoodsmanDocumentUploadingInfo(CommonUploadingAccessRights);

end;

function TBasedOnDatabaseLoodsmanDocumentsUploadingService
  .GetValidLoodsmanDocumentUploadingInfo(
    CommonUploadingAccessRights: TLoodsmanDocumentsUploadingAccessRights;
    const EmployeeId, DocumentId: Variant
  ): TLoodsmanDocumentUploadingInfo;
var
    DataReader: IDataReader;
begin

  DataReader := 
    ExecuteDocumentUploadingInfoGettingQuery(
      FDocumentUploadingInfoGettingQueryPattern, DocumentId
    );

  Result := 
    MapLoodsmanDocumentUploadingInfoFrom(
      CommonUploadingAccessRights, DataReader,
      EmployeeId, DocumentId
    );
  
end;

function TBasedOnDatabaseLoodsmanDocumentsUploadingService
  .GetInvalidLoodsmanDocumentUploadingInfo(
    CommonUploadingAccessRights: TLoodsmanDocumentsUploadingAccessRights
  ): TLoodsmanDocumentUploadingInfo;
begin

  Result := TLoodsmanDocumentUploadingInfo.CreateAsEmpty;
  
end;

function TBasedOnDatabaseLoodsmanDocumentsUploadingService
  .ExecuteDocumentUploadingInfoGettingQuery(
    const QueryPattern: String;
    const DocumentId: Variant
  ): IDataReader;
var
    QueryParams: TQueryParams;
begin

  QueryParams := TQueryParams.Create;

  try

    QueryParams.Add('p' + FUploadingQueueTableDef.DocumentIdColumnName, DocumentId);
  
    Result := FQueryExecutor.ExecuteSelectionQuery(QueryPattern, QueryParams);

  finally

    FreeAndNil(QueryParams);

  end;

end;

function TBasedOnDatabaseLoodsmanDocumentsUploadingService
  .MapLoodsmanDocumentUploadingInfoFrom(
    CommonUploadingAccessRights: TLoodsmanDocumentsUploadingAccessRights;
    DataReader: IDataReader;
    const EmployeeId: Variant;
    const DocumentId: Variant
  ): TLoodsmanDocumentUploadingInfo;
begin

  Result :=
    FDocumentUploadingInfoMapper.MapLoodsmanDocumentUploadingInfoFrom(
      CommonUploadingAccessRights, DataReader, EmployeeId, DocumentId
    );

end;

function TBasedOnDatabaseLoodsmanDocumentsUploadingService
  .RunDocumentUploadingToLoodsman(
    const EmployeeId, DocumentId: Variant
  ): TLoodsmanDocumentUploadingInfo;
begin

  Result :=
    ChangeLoodsmanDocumentUploadingStatusInfo(
      EmployeeId, DocumentId,
      usUploadingRequested, Now
    );
  
end;

function TBasedOnDatabaseLoodsmanDocumentsUploadingService
  .RunCancellationDocumentUploadingToLoodsman(
    const EmployeeId, DocumentId: Variant
  ): TLoodsmanDocumentUploadingInfo;
begin

  Result :=
    ChangeLoodsmanDocumentUploadingStatusInfo(
      EmployeeId, DocumentId,
      usCancelationRequested, Now
    );

end;

function TBasedOnDatabaseLoodsmanDocumentsUploadingService
  .EnsureAccessRightsAndGetLoodsmanDocumentUploadingInfo(
    const EmployeeId, DocumentId: Variant
  ): TLoodsmanDocumentUploadingInfo;
begin

  FUploadingAccessRightsService
    .EnsureEmployeeLoodsmanDocumentsUploadingAccessRights(EmployeeId);

  Result := GetLoodsmanDocumentUploadingInfo(EmployeeId, DocumentId);
  
end;

function TBasedOnDatabaseLoodsmanDocumentsUploadingService
  .ChangeLoodsmanDocumentUploadingStatusInfo(
    const EmployeeId: Variant;
    const DocumentId: Variant;
    const Status: TLoodsmanDocumentUploadingStatus;
    const StatusDateTime: TDateTime
  ): TLoodsmanDocumentUploadingInfo;
var
    StatusName: String;
    StatusDateTimeColumnName: String;
    StatusInitiatorIdColumnName: String;
begin

  StatusName :=
    FDocumentUploadingInfoMapper.MapLoodsmanDocumentUploadingStatusName(Status);

  StatusDateTimeColumnName :=
    FUploadingQueueTableDef.GetStatusDateTimeColumnNameByStatus(Status);

  StatusInitiatorIdColumnName :=
    FUploadingQueueTableDef.GetStatusInitiatorIdColumnNameByStatus(Status);
    
  Result :=
    ChangeLoodsmanDocumentUploadingInfo(
      EmployeeId,
      DocumentId,
      [
        TNameValue.Create(
          FUploadingQueueTableDef.StatusColumnName,
          StatusName
        ),
        TNameValue.Create(
          StatusDateTimeColumnName,
          StatusDateTime
        ),
        TNameValue.Create(
          StatusInitiatorIdColumnName,
          EmployeeId
        )
      ]
    );

  
end;

function TBasedOnDatabaseLoodsmanDocumentsUploadingService
  .ChangeLoodsmanDocumentUploadingInfo(
    const EmployeeId: Variant;
    const DocumentId: Variant;
    Attributes: array of TNameValue
  ): TLoodsmanDocumentUploadingInfo;

  function ExtractRequestedDocumentUploadingStatus(
    Attributes: array of TNameValue
  ): TLoodsmanDocumentUploadingStatus;
  var
    StatusAttribute: TNameValue;
    RequestedStatus: TLoodsmanDocumentUploadingStatus;
  begin

    StatusAttribute :=
      TNameValue.FindByName(Attributes, FUploadingQueueTableDef.StatusColumnName);

    Result :=
      FDocumentUploadingInfoMapper
        .MapLoodsmanDocumentUploadingStatus(StatusAttribute.Value);

  end;

var
    RequestedStatus: TLoodsmanDocumentUploadingStatus;
begin

  RequestedStatus := ExtractRequestedDocumentUploadingStatus(Attributes);

  Result := nil;

  FSession.Start;

  try
  
    Result := 
      EnsureAccessRightsAndGetLoodsmanDocumentUploadingInfo(EmployeeId, DocumentId);

    EnsureDocumentUploadingStatusChangingAllowed(Result, RequestedStatus);
    
    if Result.StatusInfo.Status = usNotUploaded then begin

      ExecuteDocumentUploadingInfoAddingQuery(
        EmployeeId,
        Result.DocumentFullInfoDTO,
        Attributes
      );

    end

    else begin

      ExecuteDocumentUploadingInfoSavingQuery(
        Result.DocumentFullInfoDTO.DocumentDTO.Id,
        Attributes
      );

    end;

    Result := GetLoodsmanDocumentUploadingInfo(EmployeeId, DocumentId);
    
    FSession.Commit;
    
  except

    FreeAndNil(Result);

    FSession.Rollback;
    
    Raise;

  end;
  
end;

procedure TBasedOnDatabaseLoodsmanDocumentsUploadingService
  .EnsureDocumentUploadingStatusChangingAllowed(
    DocumentUploadingInfo: TLoodsmanDocumentUploadingInfo;
    const NewStatus: TLoodsmanDocumentUploadingStatus
  );
begin

  FDocumentUploadingStatusChangingEnsurer
    .EnsureDocumentUploadingStatusChangingAllowed(
      DocumentUploadingInfo,
      NewStatus
    );

end;

function TBasedOnDatabaseLoodsmanDocumentsUploadingService
  .ExecuteDocumentUploadingInfoAddingQuery(
    const InitiatorId: Variant;
    const DocumentFullInfoDTO: TDocumentFullInfoDTO;
    const Attributes: array of TNameValue
  ): Boolean;
var
    ColumnNames: TStrings;
    ColumnValues: TVariantList;

    ColumnNameListStr, ParamNameListStr, DocumentFullInfoJson: String;

    QueryParams: TQueryParams;
    QueryPattern: String;
begin

  QueryParams := TQueryParams.CreateFrom(Attributes, 'p');

  TNameValue.Deconstruct(Attributes, ColumnNames, ColumnValues);

  try

    ColumnNameListStr := CreateStringFromStringList(ColumnNames);
    ParamNameListStr := CreateStringFromStringList(ColumnNames, ', ', ':p');

    QueryPattern :=
      Format(
        'INSERT INTO %s (%s, %s, %s) VALUES (%s, :p%s, :p%s)',
        [
          FUploadingQueueTableDef.TableName,

          ColumnNameListStr,
          FUploadingQueueTableDef.DocumentIdColumnName,
          FUploadingQueueTableDef.DocumentJsonColumnName,

          ParamNameListStr,
          FUploadingQueueTableDef.DocumentIdColumnName,
          FUploadingQueueTableDef.DocumentJsonColumnName
        ]
      );

    QueryParams.Add(
      'p' + FUploadingQueueTableDef.DocumentIdColumnName,
      DocumentFullInfoDTO.DocumentDTO.Id
    );

    DocumentFullInfoJson :=
      FDocumentFullInfoJsonMapper
        .MapDocumentFullInfoJson(DocumentFullInfoDTO);
        
    QueryParams.Add(
      'p' + FUploadingQueueTableDef.DocumentJsonColumnName,
      DocumentFullInfoJson
    );
    
    Result := FQueryExecutor.ExecuteModificationQuery(QueryPattern, QueryParams) > 0;

  finally

    FreeAndNil(ColumnNames);
    FreeAndNil(ColumnValues);
    FreeAndNil(QueryParams);

  end;

end;

function TBasedOnDatabaseLoodsmanDocumentsUploadingService
  .ExecuteDocumentUploadingInfoSavingQuery(
    const DocumentId: Variant;
    const Attributes: array of TNameValue
  ): Boolean;

  function CreateUpdateSetColumnListString(Attributes: array of TNameValue): String;
  var
      Attribute: TNameValue;
      ColumnSetStr: String;
  begin

    Result := '';

    for Attribute in Attributes do begin

      ColumnSetStr := Attribute.Name + '=:p' + Attribute.Name;

      Result := IfThen(Result = '', ColumnSetStr, Result + ', ' + ColumnSetStr);

    end;

  end;

var
    QueryPattern: String;
    QueryParams: TQueryParams;
begin                                    

  QueryPattern :=
    Format(
      'UPDATE %s ' +
      'SET %s ' + 
      'WHERE %s=:p%s',
      [
        FUploadingQueueTableDef.TableName,

        CreateUpdateSetColumnListString(Attributes),

        FUploadingQueueTableDef.DocumentIdColumnName,
        FUploadingQueueTableDef.DocumentIdColumnName
      ]
    );
    
  QueryParams := TQueryParams.CreateFrom(Attributes, 'p');

  try
  
    QueryParams.Add('p' + FUploadingQueueTableDef.DocumentIdColumnName, DocumentId);

    Result := FQueryExecutor.ExecuteModificationQuery(QueryPattern, QueryParams) > 0;
    
  finally

    FreeAndNil(QueryParams);
    
  end;

end;

end.
