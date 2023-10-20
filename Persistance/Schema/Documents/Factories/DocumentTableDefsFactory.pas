unit DocumentTableDefsFactory;

interface

uses

  Document,

  TableDef,
  
  DocumentTableDef,
  DocumentApprovingsTableDef,
  DocumentApprovingResultsTableDef,
  DocumentChargeSheetTableDef,
  DocumentChargeTableDef,
  DocumentFilesTableDef,
  DocumentRelationsTableDef,
  DocumentSigningTableDef,
  DocumentTypesTableDef,
  LookedDocumentsTableDef,
  DocumentTypeStageTableDef,
  IncomingDocumentTableDef,
  DocumentChargeKindTableDef,
  TypeObjectRegistry,

  SysUtils;

type

  TDocumentTableDefCreationMethod = function : TTableDef of object;
  
  TDocumentTableDefsFactory = class

    protected

      FInternalRegistry: TTypeObjectRegistry;

      function FindTableDef(TableDefType: TTableDefClass): TTableDef;

      procedure SaveTableDef(TableDef: TTableDef);
      
    protected

      function GetTableDef(
        TableDefType: TTableDefClass;
        TableDefCreationMethod: TDocumentTableDefCreationMethod
      ): TTableDef;
      
    protected

      function CreateDocumentTableDef: TTableDef;
      function CreateDocumentApprovingsTableDef: TTableDef;
      function CreateDocumentApprovingResultsTableDef: TTableDef;
      function CreateDocumentChargeSheetTableDef: TTableDef;
      function CreateDocumentChargeTableDef: TTableDef;
      function CreateDocumentChargeKindTableDef: TTableDef;
      function CreateDocumentFilesTableDef: TTableDef;
      function CreateDocumentRelationsTableDef: TTableDef;
      function CreateDocumentSigningTableDef: TTableDef;
      function CreateDocumentTypesTableDef: TTableDef;
      function CreateDocumentTypeStageTableDef: TTableDef;
      function CreateIncomingDocumentTableDef: TTableDef;
      function CreateLookedDocumentsTableDef: TTableDef;
      
    protected

      function CreateDocumentTableDefInstance: TDocumentTableDef; virtual;
      function CreateDocumentApprovingsTableDefInstance: TDocumentApprovingsTableDef; virtual;
      function CreateDocumentApprovingResultsTableDefInstance: TDocumentApprovingResultsTableDef; virtual;
      function CreateDocumentChargeSheetTableDefInstance: TDocumentChargeSheetTableDef; virtual;
      function CreateDocumentChargeTableDefInstance: TDocumentChargeTableDef; virtual;
      function CreateDocumentChargeKindTableDefInstance: TTableDef; virtual;
      function CreateDocumentFilesTableDefInstance: TDocumentFilesTableDef; virtual;
      function CreateDocumentRelationsTableDefInstance: TDocumentRelationsTableDef; virtual;
      function CreateDocumentSigningTableDefInstance: TDocumentSigningTableDef; virtual;
      function CreateDocumentTypesTableDefInstance: TDocumentTypesTableDef; virtual;
      function CreateDocumentTypeStageTableDefInstance: TDocumentTypeStageTableDef; virtual;
      function CreateIncomingDocumentTableDefInstance: TIncomingDocumentTableDef; virtual;

      procedure FillDocumentTableDef(DocumentTableDef: TTableDef); virtual;
      procedure FillLookedDocumentsTableDef(DocumentTableDef: TTableDef); virtual;
      procedure FillDocumentApprovingsTableDef(DocumentApprovingsTableDef: TTableDef); virtual;
      procedure FillDocumentApprovingResultsTableDef(DocumentApprovingResultsTableDef: TTableDef); virtual;
      procedure FillDocumentChargeSheetTableDef(DocumentChargeSheetTableDef: TTableDef); virtual;
      procedure FillDocumentChargeTableDef(DocumentChargeTableDef: TTableDef); virtual;
      procedure FillDocumentChargeKindTableDef(DocumentChargeKindTableDef: TTableDef); virtual;
      procedure FillDocumentFilesTableDef(DocumentFilesTableDef: TTableDef); virtual;
      procedure FillDocumentRelationsTableDef(DocumentRelationsTableDef: TTableDef); virtual;
      procedure FillDocumentSigningTableDef(DocumentSigningTableDef: TTableDef); virtual;
      procedure FillDocumentTypesTableDef(DocumentTypesTableDef: TTableDef); virtual;
      procedure FillDocumentTypeStageTableDef(DocumentTypeStageTableDef: TTableDef); virtual;
      procedure FillIncomingDocumentTableDef(IncomingDocumentTableDef: TTableDef); virtual;

    public

      destructor Destroy; override;

      constructor Create; virtual;
      
      function GetDocumentTableDef: TDocumentTableDef;
      function GetDocumentApprovingsTableDef: TDocumentApprovingsTableDef;
      function GetDocumentApprovingResultsTableDef: TDocumentApprovingResultsTableDef;
      function GetDocumentChargeSheetTableDef: TDocumentChargeSheetTableDef;
      function GetDocumentChargeTableDef: TDocumentChargeTableDef;
      function GetDocumentChargeKindTableDef: TDocumentChargeKindTableDef;
      function GetDocumentFilesTableDef: TDocumentFilesTableDef;
      function GetDocumentRelationsTableDef: TDocumentRelationsTableDef;
      function GetDocumentSigningTableDef: TDocumentSigningTableDef;
      function GetDocumentTypesTableDef: TDocumentTypesTableDef;
      function GetDocumentTypeStageTableDef: TDocumentTypeStageTableDef;
      function GetLookedDocumentsTableDef: TLookedDocumentsTableDef;
      function GetIncomingDocumentTableDef: TIncomingDocumentTableDef;
      
  end;
  
implementation

uses

  IGetSelfUnit;
  
{ TDocumentTableDefsFactory }

function TDocumentTableDefsFactory.GetDocumentApprovingResultsTableDef: TDocumentApprovingResultsTableDef;
begin

  Result := 
    TDocumentApprovingResultsTableDef(
      GetTableDef(
        TDocumentApprovingResultsTableDef,
        CreateDocumentApprovingResultsTableDef
      )
    );
    
end;

function TDocumentTableDefsFactory.GetDocumentApprovingsTableDef: TDocumentApprovingsTableDef;
begin

  Result :=
    TDocumentApprovingsTableDef(
      GetTableDef(
        TDocumentApprovingsTableDef,
        CreateDocumentApprovingsTableDef
      )
    );
    
end;

function TDocumentTableDefsFactory.GetDocumentChargeKindTableDef: TDocumentChargeKindTableDef;
begin

  Result :=
    TDocumentChargeKindTableDef(
      GetTableDef(
        TDocumentChargeKindTableDef,
        CreateDocumentChargeKindTableDef
      )
    );
    
end;

function TDocumentTableDefsFactory.GetDocumentChargeSheetTableDef: TDocumentChargeSheetTableDef;
begin

  Result :=
    TDocumentChargeSheetTableDef(
      GetTableDef(
        TDocumentChargeSheetTableDef,
        CreateDocumentChargeSheetTableDef
      )
    );
    
end;

function TDocumentTableDefsFactory.GetDocumentChargeTableDef: TDocumentChargeTableDef;
begin

  Result :=
    TDocumentChargeTableDef(
      GetTableDef(
        TDocumentChargeTableDef,
        CreateDocumentChargeTableDef
      )
    );

end;

function TDocumentTableDefsFactory.GetDocumentFilesTableDef: TDocumentFilesTableDef;
begin

  Result := 
    TDocumentFilesTableDef(
      GetTableDef(
        TDocumentFilesTableDef,
        CreateDocumentFilesTableDef
      )
    );
    
end;

function TDocumentTableDefsFactory.GetDocumentRelationsTableDef: TDocumentRelationsTableDef;
begin

  Result :=
    TDocumentRelationsTableDef(
      GetTableDef(
        TDocumentRelationsTableDef,
        CreateDocumentRelationsTableDef
      )
    );

end;

function TDocumentTableDefsFactory.GetDocumentSigningTableDef: TDocumentSigningTableDef;
begin

  Result := 
    TDocumentSigningTableDef(
      GetTableDef(
        TDocumentSigningTableDef,
        CreateDocumentSigningTableDef
      )
    );
    
end;

function TDocumentTableDefsFactory.GetDocumentTableDef: TDocumentTableDef;
begin

  Result :=
    TDocumentTableDef(GetTableDef(TDocumentTableDef, CreateDocumentTableDef));
    
end;

function TDocumentTableDefsFactory.GetDocumentTypesTableDef: TDocumentTypesTableDef;
begin

  Result :=
    TDocumentTypesTableDef(
      GetTableDef(
        TDocumentTypesTableDef,
        CreateDocumentTypesTableDef
      )
    );
  
end;

function TDocumentTableDefsFactory.GetDocumentTypeStageTableDef: TDocumentTypeStageTableDef;
begin

  Result :=
    TDocumentTypeStageTableDef(
      GetTableDef(
        TDocumentTypeStageTableDef,
        CreateDocumentTypeStageTableDef
      )
    );

end;

function TDocumentTableDefsFactory.GetIncomingDocumentTableDef: TIncomingDocumentTableDef;
begin

  Result :=
    TIncomingDocumentTableDef(
      GetTableDef(
        TIncomingDocumentTableDef,
        CreateIncomingDocumentTableDef
      )
    );

end;

function TDocumentTableDefsFactory.GetLookedDocumentsTableDef: TLookedDocumentsTableDef;
begin

  Result :=
    TLookedDocumentsTableDef(
      GetTableDef(
        TLookedDocumentsTableDef,
        CreateLookedDocumentsTableDef
      )
    );
    
end;

function TDocumentTableDefsFactory.GetTableDef(
  TableDefType: TTableDefClass;
  TableDefCreationMethod: TDocumentTableDefCreationMethod
): TTableDef;
begin

  Result := FindTableDef(TableDefType);

  if Assigned(Result) then Exit;

  Result := TableDefCreationMethod;

  SaveTableDef(Result);  

end;

function TDocumentTableDefsFactory.FindTableDef(
  TableDefType: TTableDefClass): TTableDef;
var
    TableDefInterface: IGetSelf;
begin

  FInternalRegistry.GetInterface(TableDefType, IGetSelf, TableDefInterface);

  if Assigned(TableDefInterface) then
    Result := TTableDef(TableDefInterface.Self)

  else Result := nil;
  
end;

procedure TDocumentTableDefsFactory.SaveTableDef(TableDef: TTableDef);
begin

  FInternalRegistry.RegisterInterface(TableDef.ClassType, TableDef);

end;

function TDocumentTableDefsFactory.CreateDocumentApprovingResultsTableDef: TTableDef;
begin

  Result := CreateDocumentApprovingResultsTableDefInstance;

  FillDocumentApprovingResultsTableDef(Result);

end;

function TDocumentTableDefsFactory.CreateDocumentApprovingResultsTableDefInstance: TDocumentApprovingResultsTableDef;
begin

  Result := TDocumentApprovingResultsTableDef.Create;
  
end;

function TDocumentTableDefsFactory.CreateDocumentApprovingsTableDef: TTableDef;
begin

  Result := CreateDocumentApprovingsTableDefInstance;

  FillDocumentApprovingsTableDef(Result);
  
end;

function TDocumentTableDefsFactory.CreateDocumentApprovingsTableDefInstance: TDocumentApprovingsTableDef;
begin

  Result := TDocumentApprovingsTableDef.Create;
  
end;

function TDocumentTableDefsFactory.CreateDocumentChargeKindTableDef: TTableDef;
begin

  Result := CreateDocumentChargeKindTableDefInstance;

  FillDocumentChargeKindTableDef(Result);

end;

function TDocumentTableDefsFactory.CreateDocumentChargeKindTableDefInstance: TTableDef;
begin

  Result := TDocumentChargeKindTableDef.Create;
  
end;

function TDocumentTableDefsFactory.CreateDocumentChargeSheetTableDef: TTableDef;
begin

  Result := CreateDocumentChargeSheetTableDefInstance;

  FillDocumentChargeSheetTableDef(Result);
  
end;

function TDocumentTableDefsFactory.CreateDocumentChargeSheetTableDefInstance: TDocumentChargeSheetTableDef;
begin

  Result := TDocumentChargeSheetTableDef.Create;
  
end;

function TDocumentTableDefsFactory.CreateDocumentChargeTableDef: TTableDef;
begin

  Result := CreateDocumentChargeTableDefInstance;

  FillDocumentChargeTableDef(Result);

end;

function TDocumentTableDefsFactory.CreateDocumentChargeTableDefInstance: TDocumentChargeTableDef;
begin

  Result := TDocumentChargeTableDef.Create;

end;

function TDocumentTableDefsFactory.CreateDocumentFilesTableDef: TTableDef;
begin

  Result := CreateDocumentFilesTableDefInstance;

  FillDocumentFilesTableDef(Result);
  
end;

function TDocumentTableDefsFactory.CreateDocumentFilesTableDefInstance: TDocumentFilesTableDef;
begin

  Result := TDocumentFilesTableDef.Create;

end;

function TDocumentTableDefsFactory.CreateDocumentRelationsTableDef: TTableDef;
begin

  Result := CreateDocumentRelationsTableDefInstance;

  FillDocumentRelationsTableDef(Result);

end;

function TDocumentTableDefsFactory.CreateDocumentRelationsTableDefInstance: TDocumentRelationsTableDef;
begin

  Result := TDocumentRelationsTableDef.Create;
  
end;

function TDocumentTableDefsFactory.CreateDocumentSigningTableDef: TTableDef;
begin

  Result := CreateDocumentSigningTableDefInstance;

  FillDocumentSigningTableDef(Result);
  
end;

function TDocumentTableDefsFactory.CreateDocumentSigningTableDefInstance: TDocumentSigningTableDef;
begin

  Result := TDocumentSigningTableDef.Create;
  
end;

function TDocumentTableDefsFactory.CreateDocumentTableDef: TTableDef;
begin

  Result := CreateDocumentTableDefInstance;

  FillDocumentTableDef(Result);
  
end;

function TDocumentTableDefsFactory.CreateDocumentTableDefInstance: TDocumentTableDef;
begin

  Result := TDocumentTableDef.Create;

end;

function TDocumentTableDefsFactory.CreateDocumentTypesTableDef: TTableDef;
begin

  Result := CreateDocumentTypesTableDefInstance;

  FillDocumentTypesTableDef(Result);
  
end;

function TDocumentTableDefsFactory.CreateDocumentTypesTableDefInstance: TDocumentTypesTableDef;
begin

  Result := TDocumentTypesTableDef.Create;
  
end;

function TDocumentTableDefsFactory.CreateDocumentTypeStageTableDef: TTableDef;
begin

  Result := CreateDocumentTypeStageTableDefInstance;

  FillDocumentTypeStageTableDef(Result);
  
end;

function TDocumentTableDefsFactory.CreateDocumentTypeStageTableDefInstance: TDocumentTypeStageTableDef;
begin

  Result := TDocumentTypeStageTableDef.Create;

end;

function TDocumentTableDefsFactory.CreateIncomingDocumentTableDef: TTableDef;
begin

  Result := CreateIncomingDocumentTableDefInstance;

  FillIncomingDocumentTableDef(Result);
  
end;

function TDocumentTableDefsFactory.CreateIncomingDocumentTableDefInstance: TIncomingDocumentTableDef;
begin

  Result := TIncomingDocumentTableDef.Create;
  
end;

function TDocumentTableDefsFactory.CreateLookedDocumentsTableDef: TTableDef;
begin

  Result := TLookedDocumentsTableDef.Create;

  FillLookedDocumentsTableDef(Result);
  
end;

constructor TDocumentTableDefsFactory.Create;
begin

  inherited Create;

  FInternalRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;

end;

destructor TDocumentTableDefsFactory.Destroy;
begin

  FreeAndNil(FInternalRegistry);
  
  inherited;

end;

procedure TDocumentTableDefsFactory.FillDocumentApprovingResultsTableDef(
  DocumentApprovingResultsTableDef: TTableDef);
begin

  with TDocumentApprovingResultsTableDef(DocumentApprovingResultsTableDef) 
  do begin

    TableName := DOCUMENT_APPROVING_RESULTS_TABLE_NAME;
    IdColumnName := DOCUMENT_APPROVING_RESULTS_TABLE_ID_FIELD;
    NameColumnName := DOCUMENT_APPROVING_RESULTS_TABLE_RESULT_NAME_FIELD;
    
  end;
  
end;

procedure TDocumentTableDefsFactory.FillDocumentApprovingsTableDef(
  DocumentApprovingsTableDef: TTableDef);
begin

  with TDocumentApprovingsTableDef(DocumentApprovingsTableDef) do begin

    TableName := DOCUMENT_APPROVINGS_TABLE_NAME;
    IdColumnName := DOCUMENT_APPROVINGS_TABLE_ID_FIELD;
    DocumentIdColumnName := DOCUMENT_APPROVINGS_TABLE_DOCUMENT_ID_FIELD;
    PerformingDateColumnName := DOCUMENT_APPROVINGS_TABLE_PERFORMING_DATE_FIELD;
    PerformingResultIdColumnName := DOCUMENT_APPROVINGS_TABLE_PERFORMING_RESULT_ID_FIELD;
    ApproverIdColumnName := DOCUMENT_APPROVINGS_TABLE_APPROVER_ID_FIELD;
    ActualPerformedEmployeeIdColumnName := DOCUMENT_APPROVINGS_TABLE_ACTUAL_PERFORMED_EMPLOYEE_ID_FIELD;
    NoteColumnName := DOCUMENT_APPROVINGS_TABLE_NOTE_FIELD;
    CycleNumberColumnName := DOCUMENT_APPROVINGS_TABLE_CYCLE_NUMBER_FIELD;
    
  end;

end;

procedure TDocumentTableDefsFactory.FillDocumentChargeKindTableDef(
  DocumentChargeKindTableDef: TTableDef);
begin

  with TDocumentChargeKindTableDef(DocumentChargeKindTableDef) do begin

    TableName := 'doc.document_charge_types';
    IdColumnName := 'id';
    NameColumnName := 'name';
    ServiceNameColumnName := 'service_name';
    
  end;

end;

procedure TDocumentTableDefsFactory.FillDocumentChargeSheetTableDef(
  DocumentChargeSheetTableDef: TTableDef);
begin

  with TDocumentChargeSheetTableDef(DocumentChargeSheetTableDef) do begin

    TableName := DOCUMENT_CHARGE_SHEET_TABLE_NAME;
    IdColumnName := DOCUMENT_CHARGE_SHEET_TABLE_ID_FIELD;
    KindIdColumnName := DOCUMENT_CHARGE_SHEET_TABLE_KIND_ID_FIELD;
    DocumentKindIdColumnName := 'document_kind_id';
    IssuerIdColumnName := DOCUMENT_CHARGE_SHEET_TABLE_ISSUER_ID_FIELD;
    HeadChargeSheetIdColumnName := DOCUMENT_CHARGE_SHEET_TABLE_HEAD_CHARGE_SHEET_ID_FIELD;
    TopLevelChargeSheetIdColumnName := DOCUMENT_CHARGE_SHEET_TABLE_TOP_LEVEL_CHARGE_SHEET_ID_FIELD;
    IssuingDateTimeColumnName := DOCUMENT_CHARGE_SHEET_TABLE_ISSUING_DATETIME_FIELD;
    ChargeColumnName := DOCUMENT_CHARGE_SHEET_TABLE_CHARGE_FIELD;
    ChargePeriodStartColumnName := DOCUMENT_CHARGE_SHEET_TABLE_CHARGE_PERIOD_START_FIELD;
    ChargePeriodEndColumnName := DOCUMENT_CHARGE_SHEET_TABLE_CHARGE_PERIOD_END_FIELD;
    PerformerIdColumnName := DOCUMENT_CHARGE_SHEET_TABLE_PERFORMER_ID_FIELD;
    PerformerResponseColumnName := DOCUMENT_CHARGE_SHEET_TABLE_PERFORMER_RESPONSE_FIELD;
    ActualPerformerIdColumnName := DOCUMENT_CHARGE_SHEET_TABLE_ACTUAL_PERFORMER_ID_FIELD;
    OriginalDocumentIdColumnName := DOCUMENT_CHARGE_SHEET_TABLE_ORIGINAL_DOCUMENT_ID_FIELD;
    PerformingDateTimeColumnName := DOCUMENT_CHARGE_SHEET_TABLE_PERFORMING_DATE_FIELD;
    IsForAcquaitanceColumnName := DOCUMENT_CHARGE_SHEET_TABLE_IS_FOR_ACQUAITANCE_FIELD;
    
  end;

end;

procedure TDocumentTableDefsFactory.FillDocumentChargeTableDef(
  DocumentChargeTableDef: TTableDef);
begin

  with TDocumentChargeTableDef(DocumentChargeTableDef) do begin

    TableName := DOCUMENT_CHARGE_TABLE_NAME;
    IdColumnName := DOCUMENT_CHARGE_TABLE_ID_FIELD;
    KindIdColumnName := DOCUMENT_CHARGE_TABLE_KIND_ID_FIELD;
    ChargeColumnName := DOCUMENT_CHARGE_TABLE_CHARGE_FIELD;
    ChargePeriodStartColumnName := DOCUMENT_CHARGE_TABLE_CHARGE_PERIOD_START_FIELD;
    ChargePeriodEndColumnName := DOCUMENT_CHARGE_TABLE_CHARGE_PERIOD_END_FIELD;
    PerformerIdColumnName := DOCUMENT_CHARGE_TABLE_PERFORMER_ID_FIELD;
    PerformerResponseColumnName := DOCUMENT_CHARGE_TABLE_PERFORMER_RESPONSE_FIELD;
    ActualPerformerIdColumnName := DOCUMENT_CHARGE_TABLE_ACTUAL_PERFORMER_ID_FIELD;
    OriginalDocumentIdColumnName := DOCUMENT_CHARGE_TABLE_ORIGINAL_DOCUMENT_ID_FIELD;
    PerformingDateTimeColumnName := DOCUMENT_CHARGE_TABLE_PERFORMING_DATE_FIELD;
    IsForAcquaitanceColumnName := DOCUMENT_CHARGE_TABLE_IS_FOR_ACQUAITANCE_FIELD;
    
  end;

end;

procedure TDocumentTableDefsFactory.FillDocumentFilesTableDef(
  DocumentFilesTableDef: TTableDef);
begin

  with TDocumentFilesTableDef(DocumentFilesTableDef) do begin

    TableName := DOCUMENT_FILES_TABLE_NAME;
    IdColumnName := DOCUMENT_FILES_TABLE_ID_FIELD;
    DocumentIdColumnName := DOCUMENT_FILES_TABLE_DOCUMENT_ID_FIELD;
    FileNameColumnName := DOCUMENT_FILES_TABLE_FILE_NAME_FIELD;
    FilePathColumnName := DOCUMENT_FILES_TABLE_FILE_PATH_FIELD;
    
  end;

end;

procedure TDocumentTableDefsFactory.FillDocumentRelationsTableDef(
  DocumentRelationsTableDef: TTableDef);
begin

  with TDocumentRelationsTableDef(DocumentRelationsTableDef) do begin

    TableName := DOCUMENT_RELATIONS_TABLE_NAME;
    IdColumnName := DOCUMENT_RELATIONS_TABLE_ID_FIELD;
    TargetDocumentIdColumnName := DOCUMENT_RELATIONS_TABLE_TARGET_DOCUMENT_ID_FIELD;
    RelatedDocumentIdColumnName := DOCUMENT_RELATIONS_TABLE_RELATED_DOCUMENT_ID_FIELD;
    RelatedDocumentTypeIdColumnName := DOCUMENT_RELATIONS_TABLE_RELATED_DOCUMENT_TYPE_ID_FIELD;

  end;
  
end;

procedure TDocumentTableDefsFactory.FillDocumentSigningTableDef(
  DocumentSigningTableDef: TTableDef);
begin

  with TDocumentSigningTableDef(DocumentSigningTableDef) do begin

    TableName := DOCUMENT_SIGNING_TABLE_NAME;
    IdColumnName := DOCUMENT_SIGNING_TABLE_ID_FIELD;
    SignerIdColumnName := DOCUMENT_SIGNING_TABLE_SIGNER_ID_FIELD;
    ActualSignerIdColumnName := DOCUMENT_SIGNING_TABLE_ACTUAL_SIGNER_ID_FIELD;
    DocumentIdColumnName := DOCUMENT_SIGNING_TABLE_DOCUMENT_ID_FIELD;
    SigningDateColumnName := DOCUMENT_SIGNING_TABLE_SIGNING_DATE_FIELD;
    
  end;

end;

procedure TDocumentTableDefsFactory.FillDocumentTableDef(
  DocumentTableDef: TTableDef);
begin

  with TDocumentTableDef(DocumentTableDef) do begin

    TableName := DOCUMENT_TABLE_NAME;
    IdColumnName := DOCUMENT_TABLE_ID_FIELD;
    NameColumnName := DOCUMENT_TABLE_NAME_FIELD;
    FullNameColumnName := DOCUMENT_TABLE_FULL_NAME_FIELD;
    TypeIdColumnName := DOCUMENT_TABLE_TYPE_ID_FIELD;
    NumberColumnName := DOCUMENT_TABLE_DOCUMENT_NUMBER_FIELD;
    CreationDateColumnName := DOCUMENT_TABLE_CREATION_DATE_FIELD;
    DocumentDateColumnName := DOCUMENT_TABLE_DOCUMENT_DATE_FIELD;
    NoteColumnName := DOCUMENT_TABLE_NOTE_FIELD;
    ContentColumnName := DOCUMENT_TABLE_CONTENT_FIELD;
    AuthorIdColumnName := DOCUMENT_TABLE_AUTHOR_ID_FIELD;
    CurrentWorkCycleStageIdColumnName := DOCUMENT_TABLE_CURRENT_WORK_CYCLE_STAGE_ID_FIELD;
    ResponsibleIdColumnName := DOCUMENT_TABLE_RESPONSIBLE_ID_FIELD;
    IsSentToSigningColumnName := DOCUMENT_TABLE_IS_SENT_TO_SIGNING_FIELD;
    IsSelfRegisteredColumnName := '';
    ProductCodeColumnName := DOCUMENT_TABLE_PRODUCT_CODE_FIELD;
    
  end;

end;

procedure TDocumentTableDefsFactory.FillDocumentTypesTableDef(
  DocumentTypesTableDef: TTableDef);
begin

  with TDocumentTypesTableDef(DocumentTypesTableDef) do begin

    TableName := DOCUMENT_TYPES_TABLE_NAME;
    IdColumnName := DOCUMENT_TYPES_TABLE_ID_FIELD;
    NameColumnName := DOCUMENT_TYPES_TABLE_NAME_FIELD;
    ShortFullNameColumnName := DOCUMENT_TYPES_TABLE_SHORT_NAME_FIELD;
    SingleFullNameColumnName := DOCUMENT_TYPES_TABLE_FULL_NAME_FIELD;
    DescriptionColumnName := DOCUMENT_TYPES_TABLE_DESCRIPTION_FIELD;
    ParentTypeIdColumnName := DOCUMENT_TYPES_TABLE_PARENT_TYPE_ID;
    IsPresentedColumnName := DOCUMENT_TYPES_TABLE_IS_PRESENTED_FIELD;
    IsDomainColumnName := DOCUMENT_TYPES_TABLE_IS_DOMAIN_FIELD;
    ServiceNameColumnName := DOCUMENT_TYPES_TABLE_SERVICE_NAME;
    
  end;
  
end;

procedure TDocumentTableDefsFactory.FillDocumentTypeStageTableDef(
  DocumentTypeStageTableDef: TTableDef);
begin

  with TDocumentTypeStageTableDef(DocumentTypeStageTableDef) do begin

    TableName := DOCUMENT_TYPE_WORK_CYCLE_STAGES_TABLE_NAME;
    IdColumnName := DOCUMENT_TYPE_WORK_CYCLE_STAGES_TABLE_ID_FIELD;
    DocumentTypeIdColumnName := DOCUMENT_TYPE_WORK_CYCLE_STAGES_TABLE_DOCUMENT_TYPE_ID;
    StageNameColumnName := DOCUMENT_TYPE_WORK_CYCLE_STAGES_TABLE_NAME_FIELD;
    StageNumberColumnName := DOCUMENT_TYPE_WORK_CYCLE_STAGES_TABLE_NUMBER_FIELD;
    ServiceStageNameColumnName := DOCUMENT_TYPE_WORK_CYCLE_STAGES_TABLE_SERVICE_STAGE_NAME_FIELD;
    
  end;

end;

procedure TDocumentTableDefsFactory.FillIncomingDocumentTableDef(
  IncomingDocumentTableDef: TTableDef);
begin

  with TIncomingDocumentTableDef(IncomingDocumentTableDef) do begin

    TableName := INCOMING_DOCUMENT_TABLE_NAME;
    IdColumnName := INCOMING_DOCUMENT_TABLE_ID_FIELD;
    TypeIdColumnName := INCOMING_DOCUMENT_TABLE_TYPE_ID_FIELD;
    NumberColumnName := INCOMING_DOCUMENT_TABLE_NUMBER_FIELD;
    ReceiptDateColumnName := INCOMING_DOCUMENT_TABLE_RECEIPT_DATE_FIELD;
    ReceiverIdColumnName := INCOMING_DOCUMENT_TABLE_RECEIVER_ID_FIELD;
    OriginalDocumentIdColumnName := INCOMING_DOCUMENT_TABLE_ORIGINAL_DOCUMENT_ID_FIELD;
    
  end;

end;

procedure TDocumentTableDefsFactory.FillLookedDocumentsTableDef(
  DocumentTableDef: TTableDef);
begin

  with TLookedDocumentsTableDef(DocumentTableDef) do begin

    TableName := 'doc.looked_service_notes';
    IdColumnName := 'id';
    DocumentIdColumnName := 'document_id';
    LookedEmployeeIdColumnName := 'looked_employee_id';
    LookDateColumnName := 'look_date';

  end;
  
end;

end.
