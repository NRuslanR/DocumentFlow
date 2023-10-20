unit DocumentChargeSheetSetHolderFactory;

interface

uses

  AbstractDataSetHolder,
  DocumentChargeSetHolder,
  DocumentChargeSheetSetHolder,
  DocumentChargeSetHolderFactory,
  AbstractDataSetHolderFactory,
  DB,
  DataSetBuilder,
  SysUtils,
  Classes;

type

  IDocumentChargeSheetSetHolderFactory = interface (IDataSetHolderFactory)
    ['{200DB9D9-773E-460C-A6E9-5711E0BEA55C}']

    function CreateDocumentChargeSheetSetHolder: TDocumentChargeSheetSetHolder;
    
  end;
  
  TDocumentChargeSheetSetHolderFactory =
    class (TAbstractDataSetHolderFactory, IDocumentChargeSheetSetHolderFactory)

      protected

        FChargeSetHolderFactory: IDocumentChargeSetHolderFactory;

        function InternalCreateDataSetHolderInstance: TAbstractDataSetHolder; override;
        procedure FillDataSetFieldDefs(FieldDefs: TAbstractDataSetFieldDefs); override;

        procedure CustomizeDataSetBuilder(
          DataSetBuilder: IDataSetBuilder;
          DataSetHolder: TAbstractDataSetHolder
        ); override;

      public

        constructor Create(
          ChargeSetHolderFactory: IDocumentChargeSetHolderFactory;
          DataSetBuilder: IDataSetBuilder;
          Options: IDataSetHolderFactoryOptions = nil
        );

        function CreateDocumentChargeSheetSetHolder: TDocumentChargeSheetSetHolder;

    end;

implementation

{ TDocumentChargeSheetSetHolderFactory }

constructor TDocumentChargeSheetSetHolderFactory.Create(
  ChargeSetHolderFactory: IDocumentChargeSetHolderFactory;
  DataSetBuilder: IDataSetBuilder;
  Options: IDataSetHolderFactoryOptions
);
begin

  inherited Create(DataSetBuilder, Options);

  FChargeSetHolderFactory := ChargeSetHolderFactory;
  
end;

function TDocumentChargeSheetSetHolderFactory.CreateDocumentChargeSheetSetHolder: TDocumentChargeSheetSetHolder;
begin

  Result := TDocumentChargeSheetSetHolder(CreateDataSetHolder);

  with Result.ChargeSetHolder do begin
  
    if FChargeSetHolderFactory.Options.EnableRecordStatus then begin

      with Result.ChargeSetHolder do begin

        Result.RecordStatusFieldName := RecordStatusFieldName;

        Result.RecordAddedStatusValue := RecordAddedStatusValue;
        Result.RecordChangedStatusValue := RecordChangedStatusValue;
        Result.RecordNonChangedStatusValue := RecordNonChangedStatusValue;
        Result.RecordRemovedStatusValue := RecordRemovedStatusValue;

        Result.IsRecordIdGeneratedFieldName := IsRecordIdGeneratedFieldName;
        Result.GenerateRecordIdOnAdding := GenerateRecordIdOnAdding;
        Result.RecordIdGenerator := RecordIdGenerator;

      end;

    end;

  end;

end;

function TDocumentChargeSheetSetHolderFactory.InternalCreateDataSetHolderInstance: TAbstractDataSetHolder;
begin

  Result := TDocumentChargeSheetSetHolder.Create;

  with TDocumentChargeSheetSetHolder(Result) do begin

    ChargeSetHolder :=
      TDocumentChargeSetHolder(
        FChargeSetHolderFactory.CreateDataSetHolderWithoutDataSet
      );

  end;
  
end;

procedure TDocumentChargeSheetSetHolderFactory.FillDataSetFieldDefs(
  FieldDefs: TAbstractDataSetFieldDefs);
begin

  inherited FillDataSetFieldDefs(FieldDefs);

  with TDocumentChargeSheetSetFieldDefs(FieldDefs) do begin

    ChargeIdFieldName := 'charge_id';
    DocumentIdFieldName := 'document_id';
    TopLevelChargeSheetIdFieldName := 'top_level_charge_sheet_id';
    ViewDateByPerformerFieldName := 'view_date_by_performer';
    IssuerNameFieldName := 'issuer_name';
    IssuerIdFieldName := 'issuer_id';
    IssuingDateTimeFieldName := 'issuing_datetime';

    ViewingAllowedFieldName := 'viewing_allowed';
    ChargeSectionAccessibleFieldName := 'charge_section_accessible';
    ResponseSectionAccessibleFieldName := 'response_section_accessible';
    RemovingAllowedFieldName := 'removing_allowed';
    PerformingAllowedFieldName := 'performing_allowed';
    IsEmployeePerformerFieldName := 'is_employee_performer';
    SubordinateChargeSheetsIssuingAllowedFieldName := 'subord_issuing_allowed';

  end;

end;

procedure TDocumentChargeSheetSetHolderFactory.CustomizeDataSetBuilder(
  DataSetBuilder: IDataSetBuilder;
  DataSetHolder: TAbstractDataSetHolder
);
begin

  FChargeSetHolderFactory.CustomizeExternalDataSetBuilder(
    DataSetBuilder,
    TDocumentChargeSheetSetHolder(DataSetHolder).ChargeSetHolder
  );

  with TDocumentChargeSheetSetHolder(DataSetHolder) do begin

    DataSetBuilder
      .AddField(DocumentIdFieldName, ftInteger)            
      .AddField(TopLevelChargeSheetIdFieldName, ftInteger)
      .AddField(ViewDateByPerformerFieldName, ftDateTime)
      .AddField(IssuerNameFieldName, ftString, 200)
      .AddField(IssuerIdFieldName, ftInteger)
      .AddField(IssuingDateTimeFieldName, ftDateTime)
      .AddField(ViewingAllowedFieldName, ftBoolean)
      .AddField(ChargeSectionAccessibleFieldName, ftBoolean)
      .AddField(ResponseSectionAccessibleFieldName, ftBoolean)
      .AddField(RemovingAllowedFieldName, ftBoolean)
      .AddField(PerformingAllowedFieldName, ftBoolean)
      .AddField(IsEmployeePerformerFieldName, ftBoolean)
      .AddField(SubordinateChargeSheetsIssuingAllowedFieldName, ftBoolean);

  end;

end;

end.
