unit ApproveableDocumentsReferenceFormProcessor;

interface

uses

  DocumentsReferenceFormProcessorDecorator,
  DocumentSetHolder,
  ApproveableDocumentSetHolder,
  DocumentRecordViewModel,
  DocumentRecordViewModelDecorator,
  DocumentsReferenceFormProcessor,
  DocumentsReferenceForm,
  DocumentViewingAccountingService,
  ApproveableDocumentRecordViewModel,
  AbstractDocumentSetHolderDecorator,
  cxGridCustomTableView,
  SysUtils;

type

  TApproveableDocumentsReferenceFormProcessor =
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
  BaseApproveableDocumentsReferenceFormUnit,
  DBDataTableFormUnit;
  
{ TApproveableDocumentsReferenceFormProcessor }

function TApproveableDocumentsReferenceFormProcessor.
  InternalCreateDocumentRecordViewModelFrom(
    DocumentSetHolder: TDocumentSetHolder;
    const DocumentId: Variant
  ): TDocumentRecordViewModel;
begin

  Result := inherited InternalCreateDocumentRecordViewModelFrom(DocumentSetHolder, DocumentId);

  with
    TApproveableDocumentRecordViewModel(Result),
    DocumentSetHolder as TApproveableDocumentSetHolder
  do begin

    SenderDepartmentName := SenderDepartmentNameFieldValue;
    ReceiverDepartmentNames := ReceiverDepartmentNamesFieldValue;

  end;

end;

function TApproveableDocumentsReferenceFormProcessor.
  InternalCreateDocumentRecordViewModelFromGridRecord(
    DocumentsReferenceForm: IDocumentsReferenceForm;
    const GridRecord: TcxCustomGridRecord
  ): TDocumentRecordViewModel;
begin

  Result :=
    inherited InternalCreateDocumentRecordViewModelFromGridRecord(DocumentsReferenceForm, GridRecord);

  with
    TApproveableDocumentRecordViewModel(Result),
    DocumentsReferenceForm.Self as TBaseApproveableDocumentsReferenceForm
  do begin

    SenderDepartmentName := VarToStr(GetRecordCellValue(GridRecord, SenderDepartmentNameColumn.Index));
    ReceiverDepartmentNames := VarToStr(GetRecordCellValue(GridRecord, ReceiverDepartmentNamesColumn.Index));
    
  end;
  
end;

function TApproveableDocumentsReferenceFormProcessor.CreateDocumentRecordViewModelInstance: TDocumentRecordViewModel;
begin

  Result := TApproveableDocumentRecordViewModel.Create;
  
end;

procedure TApproveableDocumentsReferenceFormProcessor.FillDocumentSetRecordByViewModel(
  DocumentSetHolder: TDocumentSetHolder;
  RecordViewModel: TDocumentRecordViewModel
);
begin

  inherited FillDocumentSetRecordByViewModel(DocumentSetHolder, RecordViewModel);

  with
    DocumentSetHolder as TApproveableDocumentSetHolder,
    RecordViewModel as TApproveableDocumentRecordViewModel
  do begin

    SenderDepartmentNameFieldValue := SenderDepartmentName;
    ReceiverDepartmentNamesFieldValue := ReceiverDepartmentNames;

  end;

end;

procedure TApproveableDocumentsReferenceFormProcessor.
  InternalSetDocumentReferenceFormColumns(
    DocumentsReferenceForm: IDocumentsReferenceForm;
    FieldDefs: TDocumentSetFieldDefs
  );
begin

  inherited InternalSetDocumentReferenceFormColumns(DocumentsReferenceForm, FieldDefs);

  with
    TBaseApproveableDocumentsReferenceForm(DocumentsReferenceForm.Self),
    FieldDefs as TApproveableDocumentSetFieldDefs
  do begin

    SenderDepartmentNameColumn.DataBinding.FieldName := SenderDepartmentNameFieldName;
    ReceiverDepartmentNamesColumn.DataBinding.FieldName := ReceiverDepartmentNamesFieldName;
    
  end;

end;

end.
