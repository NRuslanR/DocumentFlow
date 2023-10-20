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

    DocumentChargeSheetsInfoHolder.ChargesInfoHolder := DocumentChargesInfoHolder;
    
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
  Result.ChargeInfoFieldDefs := CreateDocumentChargesInfoFieldNamesInstance;
  
end;

procedure TDocumentPerformingInfoHolderBuilder.FillDocumentChargeSheetsInfoFieldNames(
  FieldNames: TDocumentChargeSheetsInfoFieldNames);
begin

  FieldNames.IdFieldName := 'document_charge_sheet_id';
  FieldNames.ChargeIdFieldName := 'document_charge_sheet_charge_id';
  FieldNames.KindIdFieldName := 'document_charge_sheet_kind_id';
  FieldNames.KindNameFieldName := 'document_charge_sheet_kind_name';
  FieldNames.ServiceKindNameFieldName := 'document_charge_sheet_service_kind_name';
  FieldNames.DocumentIdFieldName := 'charge_sheet_document_id';
  FieldNames.DocumentKindIdFieldName := 'charge_sheet_document_kind_id';
  FieldNames.TopLevelChargeSheetIdFieldName := 'top_level_document_charge_sheet_id';
  FieldNames.ChargeTextFieldName := 'document_charge_sheet_text';
  FieldNames.ResponseFieldName := 'document_charge_sheet_response';
  FieldNames.IsForAcquaitanceFieldName := 'document_charge_sheet_is_for_acquaitance';
  FieldNames.TimeFrameStartFieldName := 'document_charge_sheet_period_start';
  FieldNames.TimeFrameDeadlineFieldName := 'document_charge_sheet_period_end';
  FieldNames.IssuingDateTimeFieldName := 'document_charge_sheet_issuing_datetime';
  FieldNames.PerformingDateTimeFieldName := 'document_charge_sheet_performing_date';
  FieldNames.ViewDateByPerformerFieldName := 'document_charge_sheet_viewing_date';
  
  FieldNames.PerformerIdFieldName := 'document_charge_sheet_performer_id';
  FieldNames.PerformerIsForeignFieldName := 'document_charge_sheet_perf_is_foreign';
  FieldNames.PerformerNameFieldName := 'document_charge_sheet_performer_name';
  FieldNames.PerformerSpecialityFieldName := 'document_charge_sheet_performer_speciality';
  FieldNames.PerformerDepartmentIdFieldName := 'document_charge_sheet_perf_dep_id';
  FieldNames.PerformerDepartmentCodeFieldName := 'document_charge_sheet_perf_dep_code';
  FieldNames.PerformerDepartmentNameFieldName := 'document_charge_sheet_perf_dep_name';

  FieldNames.ActualPerformerIdFieldName := 'document_charge_sheet_fact_perf_id';
  FieldNames.ActualPerformerIsForeignFieldName := 'document_charge_sheet_fact_perf_is_foreign';
  FieldNames.ActualPerformerNameFieldName := 'document_charge_sheet_fact_perf_name';
  FieldNames.ActualPerformerSpecialityFieldName := 'document_charge_sheet_fact_perf_speciality';
  FieldNames.ActualPerformerDepartmentIdFieldName := 'document_charge_sheet_fact_perf_dep_id';
  FieldNames.ActualPerformerDepartmentCodeFieldName := 'document_charge_sheet_fact_perf_dep_code';
  FieldNames.ActualPerformerDepartmentNameFieldName := 'document_charge_sheet_fact_perf_dep_name';

  FieldNames.IssuerIdFieldName := 'charge_sheet_sender_id';
  FieldNames.IssuerIsForeignFieldName := 'charge_sheet_sender_is_foreign';
  FieldNames.IssuerNameFieldName := 'charge_sheet_sender_name';
  FieldNames.IssuerSpecialityFieldName := 'charge_sheet_sender_speciality';
  FieldNames.IssuerDepartmentIdFieldName := 'charge_sheet_sender_dep_id';
  FieldNames.IssuerDepartmentCodeFieldName := 'charge_sheet_sender_dep_code';
  FieldNames.IssuerDepartmentNameFieldName := 'charge_sheet_sender_dep_name';

  FieldNames.ViewingAllowedFieldName := 'can_charge_sheet_view';
  FieldNames.ChargeSectionAccessibleFieldName := 'has_charge_section_access';
  FieldNames.ResponseSectionAccessibleFieldName := 'has_response_section_access';
  FieldNames.RemovingAllowedFieldName := 'can_charge_sheet_remove';
  FieldNames.PerformingAllowedFieldName := 'can_charge_sheet_perform';
  FieldNames.IsEmployeePerformerFieldName := 'is_employee_performer';
  FieldNames.SubordinateChargeSheetsIssuingAllowedFieldName := 'subord_charge_sheets_issuing_allowed';

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

  FieldNames.IdFieldName := 'document_charge_id';
  FieldNames.KindIdFieldName := 'document_charge_kind_id';
  FieldNames.KindNameFieldName := 'document_charge_kind_name';
  FieldNames.ServiceKindNameFieldName := 'document_charge_service_kind_name';
  FieldNames.ChargeTextFieldName := 'document_charge_text';
  FieldNames.IsForAcquaitanceFieldName := 'document_charge_is_for_acquaitance';
  FieldNames.ResponseFieldName := 'document_charge_response';
  FieldNames.TimeFrameStartFieldName := 'document_charge_period_start';
  FieldNames.TimeFrameDeadlineFieldName := 'document_charge_period_end';
  FieldNames.PerformingDateTimeFieldName := 'document_charge_performing_date';

  FieldNames.PerformerIdFieldName := 'document_charge_performer_id';
  FieldNames.PerformerIsForeignFieldName := 'document_charge_perf_is_foreign';
  FieldNames.PerformerNameFieldName := 'document_charge_performer_name';
  FieldNames.PerformerSpecialityFieldName := 'document_charge_performer_speciality';
  FieldNames.PerformerDepartmentIdFieldName := 'document_charge_perf_dep_id';
  FieldNames.PerformerDepartmentCodeFieldName := 'document_charge_perf_dep_code';
  FieldNames.PerformerDepartmentNameFieldName := 'document_charge_perf_dep_name';

  FieldNames.ActualPerformerIdFieldName := 'document_charge_fact_perf_id';
  FieldNames.ActualPerformerIsForeignFieldName := 'document_charge_fact_perf_is_foreign';
  FieldNames.ActualPerformerNameFieldName := 'document_charge_fact_perf_name';
  FieldNames.ActualPerformerSpecialityFieldName := 'document_charge_fact_perf_speciality';
  FieldNames.ActualPerformerDepartmentIdFieldName := 'document_charge_fact_perf_dep_id';
  FieldNames.ActualPerformerDepartmentCodeFieldName := 'document_charge_fact_perf_dep_code';
  FieldNames.ActualPerformerDepartmentNameFieldName := 'document_charge_fact_perf_dep_name';
  
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
