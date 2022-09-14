unit PostgresIncomingDocumentFullInfoFetchingQueryBuilder;

interface

uses

  PostgresDocumentFullInfoFetchingQueryBuilder,
  DocumentFullInfoDataSetHolder,
  DocumentTableDefsFactory,
  SysUtils,
  Classes;

type

  TPostgresIncomingDocumentFullInfoFetchingQueryBuilder =
    class (TPostgresDocumentInfoFetchingQueryBuilder)

      protected

        function GetDocumentFullInfoFieldNameListExpression(
          DocumentFullInfoDataSetFieldNames: TDocumentFullInfoDataSetFieldNames
        ): String; override;

        function GetDocumentFullInfoTableExpression(
          DocumentFullInfoDataSetFieldNames: TDocumentFullInfoDataSetFieldNames;
          const DocumentIdParamName: String
        ): String; override;

        function GetDocumentFullInfoWhereExpression(
          DocumentFullInfoDataSetFieldNames: TDocumentFullInfoDataSetFieldNames;
          const DocumentIdParamName: String
        ): String; override;
      
    end;

implementation

uses

  IncomingDocumentFullInfoDataSetHolder,
  BasedOnDatabaseDocumentInfoReadService;

{ TPostgresIncomingDocumentFullInfoFetchingQueryBuilder }

function TPostgresIncomingDocumentFullInfoFetchingQueryBuilder.GetDocumentFullInfoFieldNameListExpression(
  DocumentFullInfoDataSetFieldNames: TDocumentFullInfoDataSetFieldNames): String;
begin

  with TIncomingDocumentFullInfoDataSetFieldNames(DocumentFullInfoDataSetFieldNames) do begin

    Result :=
      inherited GetDocumentFullInfoFieldNameListExpression(
        TIncomingDocumentFullInfoDataSetFieldNames(DocumentFullInfoDataSetFieldNames)
          .OriginalDocumentFullInfoDataSetFieldNames
      ) + ',' + #13#10 +
      'inc_doc.incoming_document_id as ' + IncomingDocumentIdFieldName + ',' +
      'inc_doc.document_kind_id as ' + IncomingDocumentKindIdFieldName + ',' +
      'inc_doc.document_kind_name as ' + IncomingDocumentKindNameFieldName + ',' +
      'inc_doc.incoming_number as ' + IncomingNumberFieldName + ',' +
      'inc_doc.receipt_date as ' + ReceiptDateFieldName + ',' +
      'inc_doc.incoming_doc_stage_number as ' + IncomingDocumentStageNumberFieldName + ',' +
      'inc_doc.incoming_doc_stage_name as ' + IncomingDocumentStageNameFieldName;
      
  end;
  
end;

function TPostgresIncomingDocumentFullInfoFetchingQueryBuilder.GetDocumentFullInfoTableExpression(
  DocumentFullInfoDataSetFieldNames: TDocumentFullInfoDataSetFieldNames;
  const DocumentIdParamName: String
): String;
begin

  with FDocumentTableDefsFactory do begin

    Result :=
      GetDocumentTableExpression(DocumentFullInfoDataSetFieldNames, DocumentIdParamName) + #13#10 +
      GetCurrentEmployeeTableJoinExpression + #13#10 +

      'join lateral (' + #13#10 +
        'select' + #13#10 +
        'doc_rec.id as incoming_document_id,' +
        'doc_rec.incoming_document_type_id as document_kind_id,' +
        'dt.short_full_name as document_kind_name,' +
        'doc_rec.document_id as base_document_id,' + #13#10 +
        'doc_rec.input_number as incoming_number,' + #13#10 +
        'doc_rec.input_number_date as receipt_date,' + #13#10 +
        'dtwcs.stage_number as incoming_doc_stage_number,' +
        'dtwcs.stage_name as incoming_doc_stage_name ' +
        'from ' + GetDocumentChargeTableDef.TableName + ' doc_rec ' +
        'join doc.document_types dt on dt.id = doc_rec.incoming_document_type_id ' +
        'join lateral (' + #13#10 +
          'select bool_or(snr1.performing_date is null) not_performed_charges_exists' + #13#10 +
          'from ' + GetDocumentChargeTableDef.TableName + ' snr1' + #13#10 +
          'where snr1.document_id = doc_rec.document_id' + #13#10 + 
          'and' + #13#10 +
          '((cur_emp.id = snr1.performer_id) or' + #13#10 + 
            'doc.is_employee_acting_for_other_or_vice_versa(cur_emp.id, snr1.performer_id))' + #13#10 +
        ') in_doc_charges (not_performed_charges_exists) on true' + #13#10 +
        '' + #13#10 + 
        'join doc.document_type_work_cycle_stages dtwcs on dtwcs.document_type_id = doc_rec.incoming_document_type_id ' + #13#10 +
        ' and dtwcs.service_stage_name = case when in_doc_charges.not_performed_charges_exists is null' + #13#10 +
        'then case when doc_rec.performing_date is null then ''IsPerforming'' else ''Performed'' end' + #13#10 +
        'else' + #13#10 +
          'case when in_doc_charges.not_performed_charges_exists' + #13#10 + 
            'then ''IsPerforming''' + #13#10 +
            'else ''Performed''' + #13#10 +
          'end' + #13#10 +
        'end ' +
        'where doc_rec.id = :' + DocumentIdParamName +
        ' and doc_rec.top_level_charge_sheet_id is null and doc_rec.issuer_id is not null ' +
      ') inc_doc on inc_doc.incoming_document_id is not null ' + #13#10 +

      GetRestTableJoinExpression(DocumentFullInfoDataSetFieldNames, DocumentIdParamName);

  end;

end;

function TPostgresIncomingDocumentFullInfoFetchingQueryBuilder.GetDocumentFullInfoWhereExpression(
  DocumentFullInfoDataSetFieldNames: TDocumentFullInfoDataSetFieldNames;
  const DocumentIdParamName: String): String;
begin

  Result := 'inc_doc.base_document_id = doc.id';

end;

end.