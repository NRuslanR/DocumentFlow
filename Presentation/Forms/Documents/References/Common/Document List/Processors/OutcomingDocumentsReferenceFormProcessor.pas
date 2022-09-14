unit OutcomingDocumentsReferenceFormProcessor;

interface

uses

  DocumentsReferenceFormProcessorDecorator,
  DocumentSetHolder,
  OutcomingDocumentSetHolder,
  DocumentRecordViewModel,
  DocumentRecordViewModelDecorator,
  DocumentsReferenceFormProcessor,
  DocumentsReferenceForm,
  DocumentViewingAccountingService,
  OutcomingDocumentRecordViewModel,
  AbstractDocumentSetHolderDecorator,
  cxGridCustomTableView,
  SysUtils;

type

  TOutcomingDocumentsReferenceFormProcessor =
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
  AuxDebugFunctionsUnit,
  BaseOutcomingDocumentsReferenceFormUnit,
  DBDataTableFormUnit;

{ TOutcomingDocumentsReferenceFormProcessor }

function TOutcomingDocumentsReferenceFormProcessor.InternalCreateDocumentRecordViewModelFrom(
  DocumentSetHolder: TDocumentSetHolder;
  const DocumentId: Variant
): TDocumentRecordViewModel;
begin

  Result := inherited InternalCreateDocumentRecordViewModelFrom(DocumentSetHolder, DocumentId);

  with
    TOutcomingDocumentRecordViewModel(Result),
    DocumentSetHolder as TOutcomingDocumentSetHolder
  do begin

    ReceivingDepartmentNames := ReceivingDepartmentNamesFieldValue;

  end;
  
end;

function TOutcomingDocumentsReferenceFormProcessor.InternalCreateDocumentRecordViewModelFromGridRecord(
  DocumentsReferenceForm: IDocumentsReferenceForm;
  const GridRecord: TcxCustomGridRecord
): TDocumentRecordViewModel;
begin

  Result := inherited InternalCreateDocumentRecordViewModelFromGridRecord(DocumentsReferenceForm, GridRecord);

  with
    TOutcomingDocumentRecordViewModel(Result),
    DocumentsReferenceForm.Self as TBaseOutcomingDocumentsReferenceForm
  do begin

    ReceivingDepartmentNames :=
      VarToStr(GetRecordCellValue(GridRecord, ReceivingDepartmentNamesColumn.Index));

  end;

end;

function TOutcomingDocumentsReferenceFormProcessor.
CreateDocumentRecordViewModelInstance: TDocumentRecordViewModel;
begin

  Result := TOutcomingDocumentRecordViewModel.Create;

end;

procedure TOutcomingDocumentsReferenceFormProcessor.FillDocumentSetRecordByViewModel(
  DocumentSetHolder: TDocumentSetHolder;
  RecordViewModel: TDocumentRecordViewModel
);
begin

  inherited FillDocumentSetRecordByViewModel(DocumentSetHolder, RecordViewModel);

  with
    DocumentSetHolder as TOutcomingDocumentSetHolder,
    RecordViewModel as TOutcomingDocumentRecordViewModel
  do begin

    ReceivingDepartmentNamesFieldValue := ReceivingDepartmentNames;
    
  end;

end;

procedure TOutcomingDocumentsReferenceFormProcessor.InternalSetDocumentReferenceFormColumns(
  DocumentsReferenceForm: IDocumentsReferenceForm;
  FieldDefs: TDocumentSetFieldDefs);
begin

  inherited InternalSetDocumentReferenceFormColumns(DocumentsReferenceForm, FieldDefs);

  with
    DocumentsReferenceForm.Self as TBaseOutcomingDocumentsReferenceForm,
    FieldDefs as TOutcomingDocumentSetFieldDefs
  do begin

    ReceivingDepartmentNamesColumn.DataBinding.FieldName := ReceivingDepartmentNamesFieldName;

  end;

end;

end.
