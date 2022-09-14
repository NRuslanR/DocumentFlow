unit PersonnelOrdersReferenceFormProcessor;

interface

uses

  DocumentSetHolder,
  DocumentRecordViewModel,
  DocumentsReferenceForm,
  IGetSelfUnit,
  cxGridCustomTableView,
  DocumentsReferenceFormProcessor,
  PersonnelOrderSetHolder,
  PersonnelOrderRecordViewModel,
  SysUtils;

type

  TPersonnelOrdersReferenceFormProcessor =
    class (TDocumentsReferenceFormProcessor)

      protected

        procedure FillDefaultOptions(Options: IDocumentsReferenceFormProcessorOptions); override;
        
      protected

        function CreateDocumentRecordViewModelInstance:
          TDocumentRecordViewModel; override;

        function InternalCreateDocumentRecordViewModelFrom(
          DocumentSetHolder: TDocumentSetHolder;
          const DocumentId: Variant
        ): TDocumentRecordViewModel; override;

        function InternalCreateDocumentRecordViewModelFromGridRecord(
          DocumentsReferenceForm: IDocumentsReferenceForm;
          const GridRecord: TcxCustomGridRecord
        ): TDocumentRecordViewModel; override;

        procedure InternalSetDocumentReferenceFormColumns(
          DocumentsReferenceForm: IDocumentsReferenceForm;
          FieldDefs: TDocumentSetFieldDefs
        ); override;
        
      public

        procedure FillDocumentSetRecordByViewModel(
          DocumentSetHolder: TDocumentSetHolder;
          RecordViewModel: TDocumentRecordViewModel
        ); override;

    end;

implementation

uses

  Variants,
  AuxDebugFunctionsUnit,
  unPersonnelOrdersReferenceForm;

{ TPersonnelOrdersReferenceFormProcessor }

function TPersonnelOrdersReferenceFormProcessor.
  CreateDocumentRecordViewModelInstance: TDocumentRecordViewModel;
begin

  Result := TPersonnelOrderRecordViewModel.Create;
  
end;

procedure TPersonnelOrdersReferenceFormProcessor.FillDefaultOptions(
  Options: IDocumentsReferenceFormProcessorOptions);
begin

  inherited FillDefaultOptions(Options);

  Options.ChargesPerformingStatisticsFieldRequired(False);
  
end;

procedure TPersonnelOrdersReferenceFormProcessor.FillDocumentSetRecordByViewModel(
  DocumentSetHolder: TDocumentSetHolder;
  RecordViewModel: TDocumentRecordViewModel
);
begin

  inherited FillDocumentSetRecordByViewModel(DocumentSetHolder, RecordViewModel);

  with
    DocumentSetHolder as TPersonnelOrderSetHolder,
    RecordViewModel as TPersonnelOrderRecordViewModel
  do begin

    SubKindIdFieldValue := SubKindId;
    SubKindNameFieldValue := SubKindName;

  end;

end;

function TPersonnelOrdersReferenceFormProcessor.InternalCreateDocumentRecordViewModelFrom(
  DocumentSetHolder: TDocumentSetHolder;
  const DocumentId: Variant
): TDocumentRecordViewModel;
begin

  Result := inherited InternalCreateDocumentRecordViewModelFrom(DocumentSetHolder, DocumentId);

  with
    DocumentSetHolder as TPersonnelOrderSetHolder,
    Result as TPersonnelOrderRecordViewModel
  do begin

    SubKindId := SubKindIdFieldValue;
    SubKindName := SubKindNameFieldValue;

  end;
  
end;

function TPersonnelOrdersReferenceFormProcessor.InternalCreateDocumentRecordViewModelFromGridRecord(
  DocumentsReferenceForm: IDocumentsReferenceForm;
  const GridRecord: TcxCustomGridRecord
): TDocumentRecordViewModel;
begin

  Result := inherited InternalCreateDocumentRecordViewModelFromGridRecord(DocumentsReferenceForm, GridRecord);

  with
    DocumentsReferenceForm.Self as TPersonnelOrdersReferenceForm,
    Result as TPersonnelOrderRecordViewModel
  do begin

    SubKindId := GetRecordCellValue(GridRecord, SubKindIdColumn.Index);
    SubKindName := GetRecordCellValue(GridRecord, SubKindNameColumn.Index);

  end;
  
end;

procedure TPersonnelOrdersReferenceFormProcessor.InternalSetDocumentReferenceFormColumns(
  DocumentsReferenceForm: IDocumentsReferenceForm;
  FieldDefs: TDocumentSetFieldDefs
);
begin

  inherited InternalSetDocumentReferenceFormColumns(DocumentsReferenceForm, FieldDefs);
  
  with
    DocumentsReferenceForm.Self as TPersonnelOrdersReferenceForm,
    FieldDefs as TPersonnelOrderSetFieldDefs
  do begin

    SubKindIdColumn.DataBinding.FieldName := SubKindIdFieldName;
    SubKindNameColumn.DataBinding.FieldName := SubKindNameFieldName;

  end;

end;

end.
