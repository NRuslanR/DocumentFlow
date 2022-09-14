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

  FieldNames.DocumentIdFieldName := 'document_id';
  FieldNames.BaseDocumentIdFieldName := 'base_document_id';
  FieldNames.DocumentNumberFieldName := 'document_number';
  FieldNames.DocumentNameFieldName := 'document_name';
  FieldNames.DocumentProductCodeFieldName := 'product_code';
  FieldNames.DocumentContentFieldName := 'document_content';
  FieldNames.DocumentNoteFieldName := 'document_note';
  FieldNames.DocumentIsSelfRegisteredFieldName := 'is_self_registered'; { refactor: набор полей передавать конструктор, поле is_self_registered актуально на данный момент только для служебок }
  FieldNames.DocumentCreationDateFieldName := 'document_creation_date';
  FieldNames.DocumentDateFieldName := 'document_date';
  FieldNames.DocumentKindFieldName := 'document_kind';
  FieldNames.DocumentKindIdFieldName := 'document_kind_id';
  FieldNames.DocumentCurrentWorkCycleStageNameFieldName := 'document_current_work_cycle_stage_name';
  FieldNames.DocumentCurrentWorkCycleStageNumberFieldName := 'document_current_work_cycle_stage_number';

  FieldNames.DocumentAuthorIdFieldName := 'document_author_id';
  FieldNames.DocumentAuthorLeaderIdFieldName := 'doc_author_leader_id';
  FieldNames.DocumentAuthorNameFieldName := 'document_author_name';
  FieldNames.DocumentAuthorSpecialityFieldName := 'document_author_speciality';
  FieldNames.DocumentAuthorDepartmentIdFieldName := 'document_author_department_id';
  FieldNames.DocumentAuthorDepartmentCodeFieldName := 'document_author_department_code';
  FieldNames.DocumentAuthorDepartmentNameFieldName := 'document_author_department_name';

  FieldNames.DocumentResponsibleIdFieldName := 'document_responsible_id';
  FieldNames.DocumentResponsibleNameFieldName := 'document_responsible_name';
  FieldNames.DocumentResponsibleTelephoneNumberFieldName := 'document_responsible_telephone_number';
  FieldNames.DocumentResponsibleDepartmentIdFieldName := 'document_responsible_department_id';
  FieldNames.DocumentResponsibleDepartmentCodeFieldName := 'document_responsible_department_code';
  FieldNames.DocumentResponsibleDepartmentNameFieldName := 'document_responsible_department_name';

  FieldNames.DocumentChargeIdFieldName := 'document_charge_id';
  FieldNames.DocumentChargesInfoFieldNames.DocumentChargeKindIdFieldName := 'document_charge_kind_id';
  FieldNames.DocumentChargesInfoFieldNames.DocumentChargeKindNameFieldName := 'document_charge_kind_name';
  FieldNames.DocumentChargesInfoFieldNames.DocumentChargeServiceKindNameFieldName := 'document_charge_service_kind_name';
  FieldNames.DocumentChargeTextFieldName := 'document_charge_text';
  FieldNames.DocumentChargeIsForAcquaitanceFieldName := 'document_charge_is_for_acquaitance';
  FieldNames.DocumentChargeResponseFieldName := 'document_charge_response';
  FieldNames.DocumentChargePeriodStartFieldName := 'document_charge_period_start';
  FieldNames.DocumentChargePeriodEndFieldName := 'document_charge_period_end';
  FieldNames.DocumentChargePerformingDateTimeFieldName := 'document_charge_performing_date';

  FieldNames.DocumentChargePerformerIdFieldName := 'document_charge_performer_id';
  FieldNames.DocumentChargePerformerIsForeignFieldName := 'document_charge_perf_is_foreign';
  FieldNames.DocumentChargePerformerLeaderIdFieldName := 'document_charge_perf_leader_id';
  FieldNames.DocumentChargePerformerNameFieldName := 'document_charge_performer_name';
  FieldNames.DocumentChargePerformerSpecialityFieldName := 'document_charge_performer_speciality';
  FieldNames.DocumentChargePerformerDepartmentIdFieldName := 'document_charge_perf_dep_id';
  FieldNames.DocumentChargePerformerDepartmentCodeFieldName := 'document_charge_perf_dep_code';
  FieldNames.DocumentChargePerformerDepartmentNameFieldName := 'document_charge_perf_dep_name';

  FieldNames.DocumentChargeActualPerformerIdFieldName := 'document_charge_fact_perf_id';
  FieldNames.DocumentChargeActualPerformerLeaderIdFieldName := 'document_charge_fact_perf_leader_id';
  FieldNames.DocumentChargeActualPerformerIsForeignFieldName := 'document_charge_fact_perf_is_foreign';
  FieldNames.DocumentChargeActualPerformerNameFieldName := 'document_charge_fact_perf_name';
  FieldNames.DocumentChargeActualPerformerSpecialityFieldName := 'document_charge_fact_perf_speciality';
  FieldNames.DocumentChargeActualPerformerDepartmentIdFieldName := 'document_charge_fact_perf_dep_id';
  FieldNames.DocumentChargeActualPerformerDepartmentCodeFieldName := 'document_charge_fact_perf_dep_code';
  FieldNames.DocumentChargeActualPerformerDepartmentNameFieldName := 'document_charge_fact_perf_dep_name';

  FieldNames.DocumentSigningIdFieldName := 'document_signing_id';
  FieldNames.DocumentSigningDateFieldName := 'document_signing_performing_date';
  FieldNames.DocumentSignerIdFieldName := 'document_signer_id';
  FieldNames.DocumentSignerLeaderIdFieldName := 'document_signer_leader_id';
  FieldNames.DocumentSignerNameFieldName := 'document_signer_name';
  FieldNames.DocumentSignerSpecialityFieldName := 'signer_speciality';
  FieldNames.DocumentSignerDepartmentIdFieldName := 'document_signer_dep_id';
  FieldNames.DocumentSignerDepartmentCodeFieldName := 'document_signer_dep_code';
  FieldNames.DocumentSignerDepartmentNameFieldName := 'document_signer_dep_name';

  FieldNames.DocumentActualSignerIdFieldName := 'document_fact_signer_id';
  FieldNames.DocumentActualSignerLeaderIdFieldName := 'document_fact_signer_leader_id';
  FieldNames.DocumentActualSignerNameFieldName := 'document_fact_signer_name';
  FieldNames.DocumentActualSignerSpecialityFieldName := 'fact_signer_speciality';
  FieldNames.DocumentActualSignerDepartmentIdFieldName := 'document_fact_signer_dep_id';
  FieldNames.DocumentActualSignerDepartmentCodeFieldName := 'document_fact_signer_dep_code';
  FieldNames.DocumentActualSignerDepartmentNameFieldName := 'document_charge_fact_perf_dep_name';

  FieldNames.DocumentFileIdFieldName := 'document_file_id';
  FieldNames.DocumentFileNameFieldName := 'document_file_name';
  FieldNames.DocumentFilePathFieldName := 'document_file_path';

  FieldNames.DocumentRelationIdFieldName := 'document_relation_id';
  FieldNames.RelatedDocumentIdFieldName := 'related_document_id';
  FieldNames.RelatedDocumentKindIdFieldName := 'related_document_kind_id';
  FieldNames.RelatedDocumentKindNameFieldName := 'related_document_kind_name';
  FieldNames.RelatedDocumentNumberFieldName := 'related_document_number';
  FieldNames.RelatedDocumentNameFieldName := 'related_document_name';
  FieldNames.RelatedDocumentDateFieldName := 'related_document_date';

  FieldNames.DocumentChargeSheetIdFieldName := 'document_charge_sheet_id';
  FieldNames.DocumentChargeSheetsInfoFieldNames.DocumentChargeSheetKindIdFieldName := 'document_charge_sheet_kind_id';
  FieldNames.DocumentChargeSheetsInfoFieldNames.DocumentChargeSheetKindNameFieldName := 'document_charge_sheet_kind_name';
  FieldNames.DocumentChargeSheetsInfoFieldNames.DocumentChargeSheetServiceKindNameFieldName := 'document_charge_sheet_service_kind_name';
  FieldNames.ChargeSheetDocumentIdFieldName := 'charge_sheet_document_id';
  FieldNames.TopLevelDocumentChargeSheetIdFieldName := 'top_level_document_charge_sheet_id';
  FieldNames.DocumentChargeSheetTextFieldName := 'document_charge_sheet_text';
  FieldNames.DocumentChargeSheetResponseFieldName := 'document_charge_sheet_response';
  FieldNames.DocumentChargeSheetIsForAcquaitanceFieldName := 'document_charge_sheet_is_for_acquaitance';
  FieldNames.DocumentChargeSheetPeriodStartFieldName := 'document_charge_sheet_period_start';
  FieldNames.DocumentChargeSheetPeriodEndFieldName := 'document_charge_sheet_period_end';
  FieldNames.DocumentChargeSheetIssuingDateTimeFieldName := 'document_charge_sheet_issuing_datetime';
  FieldNames.DocumentChargeSheetPerformingDateTimeFieldName := 'document_charge_sheet_performing_date';
  FieldNames.DocumentChargeSheetViewingDateByPerformerFieldName := 'document_charge_sheet_viewing_date';
  
  FieldNames.DocumentChargeSheetPerformerIdFieldName := 'document_charge_sheet_performer_id';
  FieldNames.DocumentChargeSheetPerformerLeaderIdFieldName := 'document_charge_sheet_perf_leader_id';
  FieldNames.DocumentChargeSheetPerformerIsForeignFieldName := 'document_charge_sheet_perf_is_foreign';
  FieldNames.DocumentChargeSheetPerformerNameFieldName := 'document_charge_sheet_performer_name';
  FieldNames.DocumentChargeSheetPerformerSpecialityFieldName := 'document_charge_sheet_performer_speciality';
  FieldNames.DocumentChargeSheetPerformerDepartmentIdFieldName := 'document_charge_sheet_perf_dep_id';
  FieldNames.DocumentChargeSheetPerformerDepartmentCodeFieldName := 'document_charge_sheet_perf_dep_code';
  FieldNames.DocumentChargeSheetPerformerDepartmentNameFieldName := 'document_charge_sheet_perf_dep_name';
  FieldNames.DocumentChargeSheetPerformerRoleIdFieldName := 'document_charge_sheet_performer_role_id';

  FieldNames.DocumentChargeSheetActualPerformerIdFieldName := 'document_charge_sheet_fact_perf_id';
  FieldNames.DocumentChargeSheetActualPerformerLeaderIdFieldName := 'document_charge_sheet_fact_perf_leader_id';
  FieldNames.DocumentChargeSheetActualPerformerIsForeignFieldName := 'document_charge_sheet_fact_perf_is_foreign';
  FieldNames.DocumentChargeSheetActualPerformerNameFieldName := 'document_charge_sheet_fact_perf_name';
  FieldNames.DocumentChargeSheetActualPerformerSpecialityFieldName := 'document_charge_sheet_fact_perf_speciality';
  FieldNames.DocumentChargeSheetActualPerformerDepartmentIdFieldName := 'document_charge_sheet_fact_perf_dep_id';
  FieldNames.DocumentChargeSheetActualPerformerDepartmentCodeFieldName := 'document_charge_sheet_fact_perf_dep_code';
  FieldNames.DocumentChargeSheetActualPerformerDepartmentNameFieldName := 'document_charge_sheet_fact_perf_dep_name';

  FieldNames.DocumentChargeSheetSenderIdFieldName := 'charge_sheet_sender_id';
  FieldNames.DocumentChargeSheetSenderLeaderIdFieldName := 'charge_sheet_sender_leader_id';
  FieldNames.DocumentChargeSheetSenderIsForeignFieldName := 'charge_sheet_sender_is_foreign';
  FieldNames.DocumentChargeSheetSenderNameFieldName := 'charge_sheet_sender_name';
  FieldNames.DocumentChargeSheetSenderSpecialityFieldName := 'charge_sheet_sender_speciality';
  FieldNames.DocumentChargeSheetSenderDepartmentIdFieldName := 'charge_sheet_sender_dep_id';
  FieldNames.DocumentChargeSheetSenderDepartmentCodeFieldName := 'charge_sheet_sender_dep_code';
  FieldNames.DocumentChargeSheetSenderDepartmentNameFieldName := 'charge_sheet_sender_dep_name';

  FieldNames.DocumentApprovingIdFieldName := 'approving_id';
  FieldNames.DocumentApprovingPerformingDateTimeFieldName := 'approving_performing_date';
  FieldNames.DocumentApprovingPerformingResultIdFieldName := 'approving_performing_result_id';
  FieldNames.DocumentApprovingIsAccessibleFieldName := 'document_approving_accessible';
  FieldNames.DocumentApprovingPerformingResultFieldName := 'approving_performing_result';
  FieldNames.DocumentApprovingNoteFieldName := 'approving_note';
  FieldNames.DocumentApprovingCycleIdFieldName := 'approving_cycle_id';
  FieldNames.DocumentApprovingCycleNumberFieldName := 'approving_cycle_number';
  FieldNames.DocumentApprovingIsCompletedFieldName := 'approving_is_completed';
  FieldNames.DocumentApprovingIsLookedByApproverFieldName := 'approving_is_looked_by_approver';
  
  FieldNames.DocumentApproverIdFieldName := 'approver_id';
  FieldNames.DocumentApproverLeaderIdFieldName := 'approver_leader_id';
  FieldNames.DocumentApproverIsForeignFieldName := 'approver_is_foreign';
  FieldNames.DocumentApproverNameFieldName := 'approver_name';
  FieldNames.DocumentApproverSpecialityFieldName := 'approver_speciality';
  FieldNames.DocumentApproverDepartmentIdFieldName := 'approver_dep_id';
  FieldNames.DocumentApproverDepartmentCodeFieldName := 'approver_dep_code';
  FieldNames.DocumentApproverDepartmentNameFieldName := 'approver_dep_name';

  FieldNames.DocumentActualApproverIdFieldName := 'fact_approver_id';
  FieldNames.DocumentActualApproverLeaderIdFieldName := 'fact_approver_leader_id';
  FieldNames.DocumentActualApproverIsForeignFieldName := 'fact_approver_is_foreign';
  FieldNames.DocumentActualApproverNameFieldName := 'fact_approver_name';
  FieldNames.DocumentActualApproverSpecialityFieldName := 'fact_approver_speciality';
  FieldNames.DocumentActualApproverDepartmentIdFieldName := 'fact_approver_dep_id';
  FieldNames.DocumentActualApproverDepartmentCodeFieldName := 'fact_approver_dep_code';
  FieldNames.DocumentActualApproverDepartmentNameFieldName := 'fact_approver_dep_name';
  
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
