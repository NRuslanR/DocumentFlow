{ refactor:
  придумать удобный, минимизирующий дублирования кода в производных классах,
  типизированный механизм составления запросов
}
unit BasedOnDatabaseDocumentInfoReadService;

interface

uses

  DB,
  DocumentFullInfoDTO,
  DocumentFullInfoDataSetHolder,
  DocumentFullInfoDTOFromDataSetMapper,
  DocumentInfoReadService,
  AbstractQueryExecutor,
  AbstractApplicationService,
  QueryExecutor,
  DataReader,
  AbstractDataReader,
  DocumentTableDefsFactory,
  Disposable,
  SysUtils,
  Classes;

type

  TDocumentDbSchemaData = class (TInterfacedObject, IDisposable)

    public

      DocumentTableName: String;
      DocumentChargesTableName: String;
      DocumentSigningsTableName: String;
      DocumentLinksTableName: String;
      DocumentApprovingsTableName: String;
      DocumentFileMetadataTableName: String;
      LookedDocumentsTableName: String;

      function SetDocumentTableName(const Value: String): TDocumentDbSchemaData;
      function SetDocumentChargesTableName(const Value: String): TDocumentDbSchemaData;
      function SetDocumentLinksTableName(const Value: String): TDocumentDbSchemaData;
      function SetDocumentApprovingsTableName(const Value: String): TDocumentDbSchemaData;
      function SetDocumentFileMetadataTableName(const Value: String): TDocumentDbSchemaData;
      function SetLookedDocumentsTableName(const Value: String): TDocumentDbSchemaData;
      function SetDocumentSigningsTableName(const Value: String): TDocumentDbSchemaData;

  end;

  TDocumentFullInfoFetchingQueryPatternInfo = record

    QueryPattern: String;
    DocumentIdParamName: String;
            
  end;

  TDocumentInfoFetchingQueryBuilder = class abstract

    protected

      FDocumentTableDefsFactory: TDocumentTableDefsFactory;
      
    protected

      function GetDocumentFullInfoFieldNameListExpression(
        DocumentFullInfoDataSetFieldNames: TDocumentFullInfoDataSetFieldNames
      ): String; virtual; abstract;

      function GetDocumentSignerInfoFieldNameListExpression(
        DocumentFullInfoDataSetFieldNames: TDocumentFullInfoDataSetFieldNames
      ): String; virtual; abstract;

      function GetDocumentFullInfoTableExpression(
        DocumentFullInfoDataSetFieldNames: TDocumentFullInfoDataSetFieldNames;
        const DocumentIdParamName: String
      ): String; virtual; abstract;

      function GetDocumentFullInfoWhereExpression(
        DocumentFullInfoDataSetFieldNames: TDocumentFullInfoDataSetFieldNames;
        const DocumentIdParamName: String
      ): String; virtual; abstract;

    public

      constructor Create(DocumentTableDefsFactory: TDocumentTableDefsFactory);

      function BuildDocumentInfoFetchingQuery(
        DocumentFullInfoDataSetFieldNames: TDocumentFullInfoDataSetFieldNames;
        const DocumentIdParamName: String
      ): String; virtual;

  end;

  TBasedOnDatabaseDocumentInfoReadService =
    class abstract (TAbstractApplicationService, IDocumentInfoReadService)

      protected

        FDocumentFullInfoFetchingQueryPatternInfo:
          TDocumentFullInfoFetchingQueryPatternInfo;

        FQueryExecutor: IQueryExecutor;

        FDocumentDbSchemaData: TDocumentDbSchemaData;
        FFreeDocumentDbSchemaData: IDisposable;

        FDocumentInfoFetchingQueryBuilder: TDocumentInfoFetchingQueryBuilder;

        FDocumentFullInfoDTOFromDataSetMapper: TDocumentFullInfoDTOFromDataSetMapper;

      protected

        function PrepareDocumentFullInfoFetchingQueryPattern(
          DocumentDbSchemaData: TDocumentDbSchemaData
        ): TDocumentFullInfoFetchingQueryPatternInfo; virtual; abstract;

        function ExecuteDocumentFullInfoFetchingQuery(
          const QueryPattern: String;
          const DocumentIdParamName: String;
          const DocumentId: Variant
        ): IDataReader; virtual;

      protected

        function GetDocumentFullInfoDataSetHolder(
          const DocumentId: Variant
        ): TDocumentFullInfoDataSetHolder; virtual;

        function CreateDocumentFullInfoDataSetHolder:
          TDocumentFullInfoDataSetHolder;

        function CreateDocumentFullInfoDataSetHolderInstance:
          TDocumentFullInfoDataSetHolder; virtual;
          
      protected

        procedure FillDocumentFullInfoDataSetFieldNames(
          FieldNames: TDocumentFullInfoDataSetFieldNames
        ); virtual;

      public

        constructor Create(
          QueryExecutor: TAbstractQueryExecutor;
          DocumentInfoFetchingQueryBuilder: TDocumentInfoFetchingQueryBuilder;
          DocumentFullInfoDTOFromDataSetMapper: TDocumentFullInfoDTOFromDataSetMapper
        ); virtual;

        destructor Destroy; override;

        function GetDocumentFullInfo(const DocumentId: Variant): TDocumentFullInfoDTO;
        
    end;
    
implementation

uses

  StrUtils,
  AuxiliaryStringFunctions,
  SQLCastingFunctions,
  AuxDebugFunctionsUnit;
  
{ TBasedOnDatabaseDocumentInfoReadService }

constructor TBasedOnDatabaseDocumentInfoReadService.Create(
  QueryExecutor: TAbstractQueryExecutor;
  DocumentInfoFetchingQueryBuilder: TDocumentInfoFetchingQueryBuilder;
  DocumentFullInfoDTOFromDataSetMapper: TDocumentFullInfoDTOFromDataSetMapper
);
begin

  inherited Create;

  FQueryExecutor := QueryExecutor;

  FDocumentInfoFetchingQueryBuilder := DocumentInfoFetchingQueryBuilder;

  FDocumentFullInfoDTOFromDataSetMapper := DocumentFullInfoDTOFromDataSetMapper;

end;

function TBasedOnDatabaseDocumentInfoReadService.CreateDocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder;
begin

  Result := CreateDocumentFullInfoDataSetHolderInstance;

  FillDocumentFullInfoDataSetFieldNames(Result.FieldNames);
  
end;

function TBasedOnDatabaseDocumentInfoReadService
  .CreateDocumentFullInfoDataSetHolderInstance: TDocumentFullInfoDataSetHolder;
begin

  Result := TDocumentFullInfoDataSetHolder.Create;
  
end;

destructor TBasedOnDatabaseDocumentInfoReadService.Destroy;
begin

  FreeAndNil(FDocumentInfoFetchingQueryBuilder);
  
  inherited;

end;

function TBasedOnDatabaseDocumentInfoReadService.ExecuteDocumentFullInfoFetchingQuery(
  const QueryPattern: String;
  const DocumentIdParamName: String;
  const DocumentId: Variant
): IDataReader;
var QueryParams: TQueryParams;
begin

  QueryParams := TQueryParams.Create;

  try

    QueryParams.Add(DocumentIdParamName, DocumentId);

    Result := FQueryExecutor.ExecuteSelectionQuery(QueryPattern, QueryParams);
      
  finally

    FreeAndNil(QueryParams);

  end;

end;

procedure TBasedOnDatabaseDocumentInfoReadService.FillDocumentFullInfoDataSetFieldNames(
  FieldNames: TDocumentFullInfoDataSetFieldNames);
begin

  FieldNames.IdFieldName := 'document_id';
  FieldNames.BaseIdFieldName := 'base_document_id';
  FieldNames.NumberFieldName := 'document_number';
  FieldNames.NameFieldName := 'document_name';
  FieldNames.ProductCodeFieldName := 'product_code';
  FieldNames.ContentFieldName := 'document_content';
  FieldNames.NoteFieldName := 'document_note';
  FieldNames.IsSelfRegisteredFieldName := 'is_self_registered';
  FieldNames.CreationDateFieldName := 'document_creation_date';
  FieldNames.DateFieldName := 'document_date';
  FieldNames.KindFieldName := 'document_kind';
  FieldNames.KindIdFieldName := 'document_kind_id';
  FieldNames.CurrentWorkCycleStageNameFieldName := 'document_current_work_cycle_stage_name';
  FieldNames.CurrentWorkCycleStageNumberFieldName := 'document_current_work_cycle_stage_number';

  FieldNames.AuthorIdFieldName := 'document_author_id';
  FieldNames.AuthorLeaderIdFieldName := 'doc_author_leader_id';
  FieldNames.AuthorNameFieldName := 'document_author_name';
  FieldNames.AuthorSpecialityFieldName := 'document_author_speciality';
  FieldNames.AuthorDepartmentIdFieldName := 'document_author_department_id';
  FieldNames.AuthorDepartmentCodeFieldName := 'document_author_department_code';
  FieldNames.AuthorDepartmentNameFieldName := 'document_author_department_name';

  FieldNames.ResponsibleIdFieldName := 'document_responsible_id';
  FieldNames.ResponsibleNameFieldName := 'document_responsible_name';
  FieldNames.ResponsibleTelephoneNumberFieldName := 'document_responsible_telephone_number';
  FieldNames.ResponsibleDepartmentIdFieldName := 'document_responsible_department_id';
  FieldNames.ResponsibleDepartmentCodeFieldName := 'document_responsible_department_code';
  FieldNames.ResponsibleDepartmentNameFieldName := 'document_responsible_department_name';

  FieldNames.SigningIdFieldName := 'document_signing_id';
  FieldNames.SigningDateFieldName := 'document_signing_performing_date';
  FieldNames.SignerIdFieldName := 'document_signer_id';
  FieldNames.SignerLeaderIdFieldName := 'document_signer_leader_id';
  FieldNames.SignerNameFieldName := 'document_signer_name';
  FieldNames.SignerSpecialityFieldName := 'signer_speciality';
  FieldNames.SignerDepartmentIdFieldName := 'document_signer_dep_id';
  FieldNames.SignerDepartmentCodeFieldName := 'document_signer_dep_code';
  FieldNames.SignerDepartmentNameFieldName := 'document_signer_dep_name';

  FieldNames.ActualSignerIdFieldName := 'document_fact_signer_id';
  FieldNames.ActualSignerLeaderIdFieldName := 'document_fact_signer_leader_id';
  FieldNames.ActualSignerNameFieldName := 'document_fact_signer_name';
  FieldNames.ActualSignerSpecialityFieldName := 'fact_signer_speciality';
  FieldNames.ActualSignerDepartmentIdFieldName := 'document_fact_signer_dep_id';
  FieldNames.ActualSignerDepartmentCodeFieldName := 'document_fact_signer_dep_code';
  FieldNames.ActualSignerDepartmentNameFieldName := 'document_charge_fact_perf_dep_name';

  FieldNames.FileIdFieldName := 'document_file_id';
  FieldNames.FileNameFieldName := 'document_file_name';
  FieldNames.FilePathFieldName := 'document_file_path';

  FieldNames.RelationIdFieldName := 'document_relation_id';
  FieldNames.RelatedDocumentIdFieldName := 'related_document_id';
  FieldNames.RelatedDocumentKindIdFieldName := 'related_document_kind_id';
  FieldNames.RelatedDocumentKindNameFieldName := 'related_document_kind_name';
  FieldNames.RelatedDocumentNumberFieldName := 'related_document_number';
  FieldNames.RelatedDocumentNameFieldName := 'related_document_name';
  FieldNames.RelatedDocumentDateFieldName := 'related_document_date';

  with FieldNames.ChargesInfoFieldNames do begin

    IdFieldName := 'document_charge_id';
    KindIdFieldName := 'document_charge_kind_id';
    KindNameFieldName := 'document_charge_kind_name';
    ServiceKindNameFieldName := 'document_charge_service_kind_name';
    ChargeTextFieldName := 'document_charge_text';
    IsForAcquaitanceFieldName := 'document_charge_is_for_acquaitance';
    ResponseFieldName := 'document_charge_response';
    TimeFrameStartFieldName := 'document_charge_period_start';
    TimeFrameDeadlineFieldName := 'document_charge_period_end';
    PerformingDateTimeFieldName := 'document_charge_performing_date';

    PerformerIdFieldName := 'document_charge_performer_id';
    PerformerIsForeignFieldName := 'document_charge_perf_is_foreign';
    PerformerNameFieldName := 'document_charge_performer_name';
    PerformerSpecialityFieldName := 'document_charge_performer_speciality';
    PerformerDepartmentIdFieldName := 'document_charge_perf_dep_id';
    PerformerDepartmentCodeFieldName := 'document_charge_perf_dep_code';
    PerformerDepartmentNameFieldName := 'document_charge_perf_dep_name';

    ActualPerformerIdFieldName := 'document_charge_fact_perf_id';
    ActualPerformerIsForeignFieldName := 'document_charge_fact_perf_is_foreign';
    ActualPerformerNameFieldName := 'document_charge_fact_perf_name';
    ActualPerformerSpecialityFieldName := 'document_charge_fact_perf_speciality';
    ActualPerformerDepartmentIdFieldName := 'document_charge_fact_perf_dep_id';
    ActualPerformerDepartmentCodeFieldName := 'document_charge_fact_perf_dep_code';
    ActualPerformerDepartmentNameFieldName := 'document_charge_fact_perf_dep_name';

  end;

  with FieldNames.ChargeSheetsInfoFieldNames do begin

    IdFieldName := 'document_charge_sheet_id';
    ChargeIdFieldName := 'document_charge_sheet_charge_id';
    KindIdFieldName := 'document_charge_sheet_kind_id';
    KindNameFieldName := 'document_charge_sheet_kind_name';
    ServiceKindNameFieldName := 'document_charge_sheet_service_kind_name';
    DocumentIdFieldName := 'charge_sheet_document_id';
    DocumentKindIdFieldName := 'charge_sheet_document_kind_id';
    TopLevelChargeSheetIdFieldName := 'top_level_document_charge_sheet_id';
    ChargeTextFieldName := 'document_charge_sheet_text';
    ResponseFieldName := 'document_charge_sheet_response';
    IsForAcquaitanceFieldName := 'document_charge_sheet_is_for_acquaitance';
    TimeFrameStartFieldName := 'document_charge_sheet_period_start';
    TimeFrameDeadlineFieldName := 'document_charge_sheet_period_end';
    IssuingDateTimeFieldName := 'document_charge_sheet_issuing_datetime';
    PerformingDateTimeFieldName := 'document_charge_sheet_performing_date';
    ViewDateByPerformerFieldName := 'document_charge_sheet_viewing_date';

    PerformerIdFieldName := 'document_charge_sheet_performer_id';
    PerformerIsForeignFieldName := 'document_charge_sheet_perf_is_foreign';
    PerformerNameFieldName := 'document_charge_sheet_performer_name';
    PerformerSpecialityFieldName := 'document_charge_sheet_performer_speciality';
    PerformerDepartmentIdFieldName := 'document_charge_sheet_perf_dep_id';
    PerformerDepartmentCodeFieldName := 'document_charge_sheet_perf_dep_code';
    PerformerDepartmentNameFieldName := 'document_charge_sheet_perf_dep_name';

    ActualPerformerIdFieldName := 'document_charge_sheet_fact_perf_id';
    ActualPerformerIsForeignFieldName := 'document_charge_sheet_fact_perf_is_foreign';
    ActualPerformerNameFieldName := 'document_charge_sheet_fact_perf_name';
    ActualPerformerSpecialityFieldName := 'document_charge_sheet_fact_perf_speciality';
    ActualPerformerDepartmentIdFieldName := 'document_charge_sheet_fact_perf_dep_id';
    ActualPerformerDepartmentCodeFieldName := 'document_charge_sheet_fact_perf_dep_code';
    ActualPerformerDepartmentNameFieldName := 'document_charge_sheet_fact_perf_dep_name';

    IssuerIdFieldName := 'charge_sheet_sender_id';
    IssuerIsForeignFieldName := 'charge_sheet_sender_is_foreign';
    IssuerNameFieldName := 'charge_sheet_sender_name';
    IssuerSpecialityFieldName := 'charge_sheet_sender_speciality';
    IssuerDepartmentIdFieldName := 'charge_sheet_sender_dep_id';
    IssuerDepartmentCodeFieldName := 'charge_sheet_sender_dep_code';
    IssuerDepartmentNameFieldName := 'charge_sheet_sender_dep_name';

  end;

  FieldNames.ApprovingIdFieldName := 'approving_id';
  FieldNames.ApprovingPerformingDateTimeFieldName := 'approving_performing_date';
  FieldNames.ApprovingPerformingResultIdFieldName := 'approving_performing_result_id';
  FieldNames.ApprovingIsAccessibleFieldName := 'document_approving_accessible';
  FieldNames.ApprovingPerformingResultFieldName := 'approving_performing_result';
  FieldNames.ApprovingNoteFieldName := 'approving_note';
  FieldNames.ApprovingCycleIdFieldName := 'approving_cycle_id';
  FieldNames.ApprovingCycleNumberFieldName := 'approving_cycle_number';
  FieldNames.ApprovingIsCompletedFieldName := 'approving_is_completed';
  FieldNames.ApprovingIsLookedByApproverFieldName := 'approving_is_looked_by_approver';
  
  FieldNames.ApproverIdFieldName := 'approver_id';
  FieldNames.ApproverLeaderIdFieldName := 'approver_leader_id';
  FieldNames.ApproverIsForeignFieldName := 'approver_is_foreign';
  FieldNames.ApproverNameFieldName := 'approver_name';
  FieldNames.ApproverSpecialityFieldName := 'approver_speciality';
  FieldNames.ApproverDepartmentIdFieldName := 'approver_dep_id';
  FieldNames.ApproverDepartmentCodeFieldName := 'approver_dep_code';
  FieldNames.ApproverDepartmentNameFieldName := 'approver_dep_name';

  FieldNames.ActualApproverIdFieldName := 'fact_approver_id';
  FieldNames.ActualApproverLeaderIdFieldName := 'fact_approver_leader_id';
  FieldNames.ActualApproverIsForeignFieldName := 'fact_approver_is_foreign';
  FieldNames.ActualApproverNameFieldName := 'fact_approver_name';
  FieldNames.ActualApproverSpecialityFieldName := 'fact_approver_speciality';
  FieldNames.ActualApproverDepartmentIdFieldName := 'fact_approver_dep_id';
  FieldNames.ActualApproverDepartmentCodeFieldName := 'fact_approver_dep_code';
  FieldNames.ActualApproverDepartmentNameFieldName := 'fact_approver_dep_name';
  
end;

function TBasedOnDatabaseDocumentInfoReadService.GetDocumentFullInfo(
  const DocumentId: Variant): TDocumentFullInfoDTO;
var DocumentFullInfoDataSetHolder: TDocumentFullInfoDataSetHolder;
begin

  DocumentFullInfoDataSetHolder := GetDocumentFullInfoDataSetHolder(DocumentId);

  try

    Result := FDocumentFullInfoDTOFromDataSetMapper.MapDocumentFullInfoDTOFrom(
                DocumentFullInfoDataSetHolder
              );

  finally

    FreeAndNil(DocumentFullInfoDataSetHolder);
    
  end;

end;

function TBasedOnDatabaseDocumentInfoReadService.GetDocumentFullInfoDataSetHolder(
  const DocumentId: Variant): TDocumentFullInfoDataSetHolder;
var
    QueryPattern: String;

    DataReader: IDataReader;
    DocumentFullInfoDataSet: TDataSet;
begin

  DocumentFullInfoDataSet := nil;
  Result := nil;

  Result := CreateDocumentFullInfoDataSetHolder;
  
  try

    QueryPattern :=
      FDocumentInfoFetchingQueryBuilder.BuildDocumentInfoFetchingQuery(
        Result.FieldNames,
        'pdocument_id'
      );

    DataReader :=
      ExecuteDocumentFullInfoFetchingQuery(
        QueryPattern,
        'pdocument_id',
        DocumentId
      );

    DocumentFullInfoDataSet := TAbstractDataReader(DataReader.Self).ToDataSet;;

    Result.DataSet := DocumentFullInfoDataSet;

  except

    on e: Exception do begin

      if not Assigned(Result.DataSet) then
        FreeAndNil(DocumentFullInfoDataSet);
        
      FreeAndNil(Result);
        
      Raise;

    end;

  end;

end;

{ TDocumentDbSchemaData }

function TDocumentDbSchemaData.SetDocumentApprovingsTableName(
  const Value: String): TDocumentDbSchemaData;
begin

  DocumentApprovingsTableName := Value;

  Result := Self;
  
end;

function TDocumentDbSchemaData.SetDocumentFileMetadataTableName(
  const Value: String): TDocumentDbSchemaData;
begin

  DocumentFileMetadataTableName := Value;

  Result := Self;
  
end;

function TDocumentDbSchemaData.SetDocumentLinksTableName(
  const Value: String): TDocumentDbSchemaData;
begin

  DocumentLinksTableName := Value;

  Result := Self;

end;

function TDocumentDbSchemaData.SetDocumentChargesTableName(
  const Value: String): TDocumentDbSchemaData;
begin

  DocumentChargesTableName := Value;

  Result := Self;
  
end;

function TDocumentDbSchemaData.SetDocumentSigningsTableName(
  const Value: String): TDocumentDbSchemaData;
begin

  DocumentSigningsTableName := Value;

  Result := Self;

end;

function TDocumentDbSchemaData.SetDocumentTableName(
  const Value: String): TDocumentDbSchemaData;
begin

  DocumentTableName := Value;

  Result := Self;
  
end;

function TDocumentDbSchemaData.SetLookedDocumentsTableName(
  const Value: String): TDocumentDbSchemaData;
begin

  LookedDocumentsTableName := Value;

  Result := Self;

end;

{ TDocumentInfoFetchingQueryBuilder }

function TDocumentInfoFetchingQueryBuilder.BuildDocumentInfoFetchingQuery(
  DocumentFullInfoDataSetFieldNames: TDocumentFullInfoDataSetFieldNames;
  const DocumentIdParamName: String
): String;
begin

  Result :=
    'select distinct ' +
    GetDocumentFullInfoFieldNameListExpression(DocumentFullInfoDataSetFieldNames) +
    ' from ' +
    GetDocumentFullInfoTableExpression(DocumentFullInfoDataSetFieldNames, DocumentIdParamName) +
    ' where ' +
    GetDocumentFullInfoWhereExpression(DocumentFullInfoDataSetFieldNames, DocumentIdParamName);

end;

constructor TDocumentInfoFetchingQueryBuilder.Create(DocumentTableDefsFactory: TDocumentTableDefsFactory);
begin

  inherited Create;

  FDocumentTableDefsFactory := DocumentTableDefsFactory;

end;

end.
