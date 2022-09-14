unit IncomingDocumentsReferenceFormProcessor;

interface

uses

  DocumentsReferenceFormProcessorDecorator,
  DocumentsReferenceFormProcessor,
  DocumentSetHolder,
  AbstractDocumentSetHolderDecorator,
  DocumentRecordViewModel,
  DocumentRecordViewModelDecorator,
  DocumentsReferenceForm,
  IncomingDocumentRecordViewModel,
  cxGridCustomTableView,
  IncomingDocumentSetHolder;

type

  TIncomingDocumentsReferenceFormProcessor =
    class (TDocumentsReferenceFormProcessorDecorator)

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
  BaseIncomingDocumentsReferenceFormUnit;
  
{ TIncomingDocumentsReferenceFormProcessor }

function TIncomingDocumentsReferenceFormProcessor.InternalCreateDocumentRecordViewModelFrom(
  DocumentSetHolder: TDocumentSetHolder;
  const DocumentId: Variant
): TDocumentRecordViewModel;
begin

  Result := inherited InternalCreateDocumentRecordViewModelFrom(DocumentSetHolder, DocumentId);

  with
    TIncomingDocumentRecordViewModel(Result),
    DocumentSetHolder as TIncomingDocumentSetHolder
  do begin

    IncomingNumber := IncomingNumberFieldValue;
    ReceiptDate := ReceiptDateFieldValue;
    SendingDepartmentName := SendingDepartmentNameFieldValue;

  end;

end;

function TIncomingDocumentsReferenceFormProcessor.InternalCreateDocumentRecordViewModelFromGridRecord(
  DocumentsReferenceForm: IDocumentsReferenceForm;
  const GridRecord: TcxCustomGridRecord
): TDocumentRecordViewModel;
begin

  Result := inherited InternalCreateDocumentRecordViewModelFromGridRecord(DocumentsReferenceForm, GridRecord);

  with
    TIncomingDocumentRecordViewModel(Result),
    DocumentsReferenceForm.Self as TBaseIncomingDocumentsReferenceForm
  do begin

    IncomingNumber := VarToStr(GetRecordCellValue(GridRecord, IncomingDocumentNumberColumn.Index));
    ReceiptDate := GetRecordCellValue(GridRecord, ReceiptDateColumn.Index);
    SendingDepartmentName := VarToStr(GetRecordCellValue(GridRecord, SendingDepartmentNameColumn.Index));

  end;

end;

function TIncomingDocumentsReferenceFormProcessor.CreateDocumentRecordViewModelInstance: TDocumentRecordViewModel;
begin

  Result := TIncomingDocumentRecordViewModel.Create;
  
end;

procedure TIncomingDocumentsReferenceFormProcessor.FillDocumentSetRecordByViewModel(
  DocumentSetHolder: TDocumentSetHolder;
  RecordViewModel: TDocumentRecordViewModel);
begin

  inherited FillDocumentSetRecordByViewModel(DocumentSetHolder, RecordViewModel);

  with
    DocumentSetHolder as TIncomingDocumentSetHolder,
    RecordViewModel as TIncomingDocumentRecordViewModel
  do begin

    IncomingNumberFieldValue := IncomingNumber;
    ReceiptDateFieldValue := ReceiptDate;
    SendingDepartmentNameFieldValue := SendingDepartmentName;

  end;

end;

procedure TIncomingDocumentsReferenceFormProcessor.InternalSetDocumentReferenceFormColumns(
  DocumentsReferenceForm: IDocumentsReferenceForm;
  FieldDefs: TDocumentSetFieldDefs);
begin

  inherited InternalSetDocumentReferenceFormColumns(DocumentsReferenceForm, FieldDefs);

  with
    DocumentsReferenceForm.Self as TBaseIncomingDocumentsReferenceForm,
    FieldDefs as TIncomingDocumentSetFieldDefs
  do begin

    ReceiptDateColumn.DataBinding.FieldName := ReceiptDateFieldName;
    IncomingDocumentNumberColumn.DataBinding.FieldName := IncomingNumberFieldName;
    SendingDepartmentNameColumn.DataBinding.FieldName := SendingDepartmentNameFieldName;

  end;

end;

end.
