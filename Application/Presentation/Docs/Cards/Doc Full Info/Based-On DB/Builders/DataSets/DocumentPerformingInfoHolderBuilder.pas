unit DocumentPerformingInfoHolderBuilder;

interface

uses

  DocumentPerformingInfoQueryBuilder,
  DocumentChargesInfoHolder,
  DocumentChargeSheetsInfoHolder,
  DB,
  DataSetQueryExecutor,
  QueryExecutor,
  DataSetDataReader,
  SysUtils,
  Classes;

type

  IDocumentPerformingInfoHolderBuilder = interface

    procedure BuildDocumentPerformingInfoHolder(
      DocumentId: Variant;
      var DocumentChargesInfoHolder: TDocumentChargesInfoHolder;
      var DocumentChargeSheetsInfoHolder: TDocumentChargeSheetsInfoHolder
    );
    
  end;

  TDocumentPerformingInfoHolderBuilder =
    class (TInterfacedObject, IDocumentPerformingInfoHolderBuilder)

      protected

        FQueryBuilder: IDocumentPerformingInfoQueryBuilder;
        FQueryExecutor: TDataSetQueryExecutor;

      protected

        function CreateDocumentChargesInfoHolder: TDocumentChargesInfoHolder;
        function CreateDocumentChargeSheetsInfoHolderInstance: TDocumentChargeSheetsInfoHolder; virtual;

        function CreateDocumentChargeSheetsInfoFieldNames: TDocumentChargeSheetsInfoFieldNames;
        function CreateDocumentChargeSheetsInfoFieldNamesInstance: TDocumentChargeSheetsInfoFieldNames; virtual;
        procedure FillDocumentChargeSheetsInfoFieldNames(FieldNames: TDocumentChargeSheetsInfoFieldNames); virtual;

      protected

        function CreateDocumentChargeSheetsInfoHolder: TDocumentChargeSheetsInfoHolder;
        function CreateDocumentChargesInfoHolderInstance: TDocumentChargesInfoHolder; virtual;

        function CreateDocumentChargesInfoFieldNames: TDocumentChargesInfoFieldNames;
        function CreateDocumentChargesInfoFieldNamesInstance: TDocumentChargesInfoFieldNames; virtual;
        procedure FillDocumentChargesInfoFieldNames(FieldNames: TDocumentChargesInfoFieldNames); virtual;

      protected

        function GetDocumentPerformingInfoDataSet(
          DocumentChargesInfoFieldNames: TDocumentChargesInfoFieldNames;
          DocumentChargeSheetsInfoFieldNames: TDocumentChargeSheetsInfoFieldNames;
          DocumentId: Variant
        ): TDataSet;

      public

        constructor Create(
          QueryBuilder: IDocumentPerformingInfoQueryBuilder;
          QueryExecutor: TDataSetQueryExecutor
        );
        
        procedure BuildDocumentPerformingInfoHolder(
          DocumentId: Variant;
          var DocumentChargesInfoHolder: TDocumentChargesInfoHolder;
          var DocumentChargeSheetsInfoHolder: TDocumentChargeSheetsInfoHolder
        );

    end;

implementation

uses

  AuxiliaryStringFunctions;

{ TDocumentPerformingInfoHolderBuilder }

procedure TDocumentPerformingInfoHolderBuilder.BuildDocumentPerformingInfoHolder(
  DocumentId: Variant;
  var DocumentChargesInfoHolder: TDocumentChargesInfoHolder;
  var DocumentChargeSheetsInfoHolder: TDocumentChargeSheetsInfoHolder
);
begin

  DocumentChargesInfoHolder := nil;
  DocumentChargeSheetsInfoHolder := nil;

  try

    DocumentChargesInfoHolder := CreateDocumentChargesInfoHolder;
    DocumentChargeSheetsInfoHolder := CreateDocumentChargeSheetsInfoHolder;

    DocumentChargesInfoHolder.DataSet :=
      GetDocumentPerformingInfoDataSet(
        DocumentChargesInfoHolder.FieldNames,
        DocumentChargeSheetsInfoHolder.FieldNames,
        DocumentId
      );

    DocumentChargeSheetsInfoHolder.DataSet := DocumentChargesInfoHolder.DataSet;
    
  except

    FreeAndNil(DocumentChargesInfoHolder);
    FreeAndNil(DocumentChargeSheetsInfoHolder);

    Raise;
    
  end;
  
end;

constructor TDocumentPerformingInfoHolderBuilder.Create(
  QueryBuilder: IDocumentPerformingInfoQueryBuilder;
  QueryExecutor: TDataSetQueryExecutor);
begin

  inherited Create;

  FQueryBuilder := QueryBuilder;
  FQueryExecutor := QueryExecutor;
  
end;

function TDocumentPerformingInfoHolderBuilder.CreateDocumentChargeSheetsInfoHolder: TDocumentChargeSheetsInfoHolder;
begin

  Result := CreateDocumentChargeSheetsInfoHolderInstance;

  Result.FieldNames := CreateDocumentChargeSheetsInfoFieldNames;

end;

function TDocumentPerformingInfoHolderBuilder.
  CreateDocumentChargeSheetsInfoHolderInstance: TDocumentChargeSheetsInfoHolder;
begin

  Result := TDocumentChargeSheetsInfoHolder.Create;
  
end;

function TDocumentPerformingInfoHolderBuilder.
  CreateDocumentChargeSheetsInfoFieldNames: TDocumentChargeSheetsInfoFieldNames;
begin

  Result := CreateDocumentChargeSheetsInfoFieldNamesInstance;

  FillDocumentChargeSheetsInfoFieldNames(Result);

end;

function TDocumentPerformingInfoHolderBuilder.
  CreateDocumentChargeSheetsInfoFieldNamesInstance: TDocumentChargeSheetsInfoFieldNames;
begin

  Result := TDocumentChargeSheetsInfoFieldNames.Create;

end;

procedure TDocumentPerformingInfoHolderBuilder.FillDocumentChargeSheetsInfoFieldNames(
  FieldNames: TDocumentChargeSheetsInfoFieldNames);
begin

  FieldNames.DocumentChargeSheetIdFieldName := 'document_charge_sheet_id';
  FieldNames.DocumentChargeSheetKindIdFieldName := 'document_charge_sheet_kind_id';
  FieldNames.DocumentChargeSheetKindNameFieldName := 'document_charge_sheet_kind_name';
  FieldNames.DocumentChargeSheetServiceKindNameFieldName := 'document_charge_sheet_service_kind_name';
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

end;

function TDocumentPerformingInfoHolderBuilder.CreateDocumentChargesInfoHolder: TDocumentChargesInfoHolder;
begin

  Result := CreateDocumentChargesInfoHolderInstance;

  Result.FieldNames := CreateDocumentChargesInfoFieldNames;

end;

function TDocumentPerformingInfoHolderBuilder.CreateDocumentChargesInfoHolderInstance: TDocumentChargesInfoHolder;
begin

  Result := TDocumentChargesInfoHolder.Create;
  
end;

function TDocumentPerformingInfoHolderBuilder.CreateDocumentChargesInfoFieldNames: TDocumentChargesInfoFieldNames;
begin

  Result := CreateDocumentChargesInfoFieldNamesInstance;

  FillDocumentChargesInfoFieldNames(Result);

end;

function TDocumentPerformingInfoHolderBuilder.CreateDocumentChargesInfoFieldNamesInstance: TDocumentChargesInfoFieldNames;
begin

  Result := TDocumentChargesInfoFieldNames.Create;

end;

procedure TDocumentPerformingInfoHolderBuilder.FillDocumentChargesInfoFieldNames(
  FieldNames: TDocumentChargesInfoFieldNames);
begin

  FieldNames.DocumentChargeIdFieldName := 'document_charge_id';
  FieldNames.DocumentChargeKindIdFieldName := 'document_charge_kind_id';
  FieldNames.DocumentChargeKindNameFieldName := 'document_charge_kind_name';
  FieldNames.DocumentChargeServiceKindNameFieldName := 'document_charge_service_kind_name';
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
  
end;

function TDocumentPerformingInfoHolderBuilder.GetDocumentPerformingInfoDataSet(
  DocumentChargesInfoFieldNames: TDocumentChargesInfoFieldNames;
  DocumentChargeSheetsInfoFieldNames: TDocumentChargeSheetsInfoFieldNames;
  DocumentId: Variant
): TDataSet;
var
    QueryParams: TQueryParams;
    Query: String;
begin

  Query :=
    FQueryBuilder.BuildDocumentPerformingInfoQuery(
      DocumentChargesInfoFieldNames,
      DocumentChargeSheetsInfoFieldNames,
      'pdocument_id'
    );

  QueryParams := TQueryParams.Create;

  try

    QueryParams.Add('pdocument_id', DocumentId);

    Result := TDataSetDataReader(FQueryExecutor.ExecuteSelectionQuery(Query, QueryParams).Self).ToDataSet;

  finally

    FreeAndNil(QueryParams);

  end;

end;

end.
