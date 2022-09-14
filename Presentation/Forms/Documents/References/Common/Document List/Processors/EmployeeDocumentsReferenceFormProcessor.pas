unit EmployeeDocumentsReferenceFormProcessor;

interface

uses

  DocumentsReferenceFormProcessorDecorator,
  DocumentSetHolder,
  DocumentRecordViewModel,
  DocumentRecordViewModelDecorator,
  DocumentsReferenceFormProcessor,
  DocumentsReferenceForm,
  DocumentViewingAccountingService,
  cxGridCustomTableView,
  SysUtils;

type

  IEmployeeDocumentsReferenceFormProcessorOptions = interface (IDocumentsReferenceFormProcessorOptions)
    ['{DDC7A7EB-B1B4-4A77-9B67-BE025DE20AE1}']
    
    function OwnChargeSheetFieldRequired: Boolean; overload;
    function OwnChargeSheetFieldRequired(const Value: Boolean): IEmployeeDocumentsReferenceFormProcessorOptions; overload;

    function AllChargeSheetsPerformedFieldOptions: IDocumentsReferenceFormFieldOptions; overload;
    function AllChargeSheetsPerformedFieldOptions(const Value: IDocumentsReferenceFormFieldOptions): IEmployeeDocumentsReferenceFormProcessorOptions; overload;

    function AllSubordinateChargeSheetsPerformedFieldOptions: IDocumentsReferenceFormFieldOptions; overload;
    function AllSubordinateChargeSheetsPerformedFieldOptions(const Value: IDocumentsReferenceFormFieldOptions): IEmployeeDocumentsReferenceFormProcessorOptions; overload;

  end;

  TEmployeeDocumentsReferenceFormProcessorOptions =
    class (
      TDocumentsReferenceFormProcessorOptionsDecorator,
      IEmployeeDocumentsReferenceFormProcessorOptions,
      IDocumentsReferenceFormProcessorOptions
    )

      private

        FOwnChargeSheetFieldRequired: Boolean;
        FAllChargeSheetsPerformedFieldOptions: IDocumentsReferenceFormFieldOptions;
        FAllSubordinateChargeSheetsPerformedFieldOptions: IDocumentsReferenceFormFieldOptions;
        
      public

        function OwnChargeSheetFieldRequired: Boolean; overload;
        function OwnChargeSheetFieldRequired(const Value: Boolean): IEmployeeDocumentsReferenceFormProcessorOptions; overload;

        function AllChargeSheetsPerformedFieldOptions: IDocumentsReferenceFormFieldOptions; overload;
        function AllChargeSheetsPerformedFieldOptions(const Value: IDocumentsReferenceFormFieldOptions): IEmployeeDocumentsReferenceFormProcessorOptions; overload;

        function AllSubordinateChargeSheetsPerformedFieldOptions: IDocumentsReferenceFormFieldOptions; overload;
        function AllSubordinateChargeSheetsPerformedFieldOptions(const Value: IDocumentsReferenceFormFieldOptions): IEmployeeDocumentsReferenceFormProcessorOptions; overload;

    end;

  TEmployeeDocumentsReferenceFormProcessor =
    class (TDocumentsReferenceFormProcessorDecorator)

      protected

        function CreateDefaultOptionsInstance: IDocumentsReferenceFormProcessorOptions; override;
        procedure FillDefaultOptions(Options: IDocumentsReferenceFormProcessorOptions); override;

        function GetEmployeeDocumentsReferenceFormProcessorOptions: IEmployeeDocumentsReferenceFormProcessorOptions;
        procedure SetEmployeeDocumentsReferenceFormProcessorOptions(Value: IEmployeeDocumentsReferenceFormProcessorOptions);
        
      protected

        FDocumentViewingAccountingService: IDocumentViewingAccountingService;
        
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

        constructor Create(
          InternalProcessor: IDocumentsReferenceFormProcessor;
          DocumentViewingAccountingService: IDocumentViewingAccountingService;
          Options: IEmployeeDocumentsReferenceFormProcessorOptions = nil
        );

        procedure OnDocumentRecordFocused(
          DocumentsReferenceForm: IDocumentsReferenceForm
        ); override;

        procedure FillDocumentSetRecordByViewModel(
          DocumentSetHolder: TDocumentSetHolder;
          RecordViewModel: TDocumentRecordViewModel
        ); override;

      public

        property Options: IEmployeeDocumentsReferenceFormProcessorOptions
        read GetEmployeeDocumentsReferenceFormProcessorOptions
        write SetEmployeeDocumentsReferenceFormProcessorOptions;
        
    end;
    
implementation

uses

  AuxDebugFunctionsUnit,
  BaseDocumentsReferenceFormUnit,
  EmployeeDocumentSetHolder,
  EmployeeDocumentRecordViewModel, DBDataTableFormUnit;

{ TEmployeeDocumentsReferenceFormProcessor }

constructor TEmployeeDocumentsReferenceFormProcessor.Create(
  InternalProcessor: IDocumentsReferenceFormProcessor;
  DocumentViewingAccountingService: IDocumentViewingAccountingService;
  Options: IEmployeeDocumentsReferenceFormProcessorOptions
);
begin

  inherited Create(
    InternalProcessor,
    TEmployeeDocumentsReferenceFormProcessorOptions(Options.Self)
  );

  FDocumentViewingAccountingService := DocumentViewingAccountingService;
  
end;

function TEmployeeDocumentsReferenceFormProcessor.InternalCreateDocumentRecordViewModelFrom(
  DocumentSetHolder: TDocumentSetHolder;
  const DocumentId: Variant
): TDocumentRecordViewModel;
begin                  

  Result := inherited InternalCreateDocumentRecordViewModelFrom(DocumentSetHolder, DocumentId);

  with
    TEmployeeDocumentRecordViewModel(Result),
    DocumentSetHolder as TEmployeeDocumentSetHolder
  do begin

    IsViewed := IsViewedFieldValue;

    if Options.OwnChargeSheetFieldRequired then
      OwnChargeSheet := OwnChargeSheetFieldValue;

    if Options.AllChargeSheetsPerformedFieldOptions.Required then
      AllChargeSheetsPerformed := AllChargeSheetsPerformedFieldValue;

    if Options.AllSubordinateChargeSheetsPerformedFieldOptions.Required then
      AllSubordinateChargeSheetsPerformed := AllSubordinateChargeSheetsPerformedFieldValue;
    
  end;

end;

function TEmployeeDocumentsReferenceFormProcessor.InternalCreateDocumentRecordViewModelFromGridRecord(
  DocumentsReferenceForm: IDocumentsReferenceForm;
  const GridRecord: TcxCustomGridRecord
): TDocumentRecordViewModel;
begin

  Result := inherited InternalCreateDocumentRecordViewModelFromGridRecord(DocumentsReferenceForm, GridRecord);

  with
    TEmployeeDocumentRecordViewModel(Result),
    DocumentsReferenceForm.Self as TBaseDocumentsReferenceForm
  do begin

    IsViewed := GetRecordCellValue(GridRecord, IsDocumentViewedColumn.Index);

    if Options.OwnChargeSheetFieldRequired then
      OwnChargeSheet := GetRecordCellValue(GridRecord, OwnChargeSheetColumn.Index);

    if Options.AllChargeSheetsPerformedFieldOptions.Required then
      AllChargeSheetsPerformed := GetRecordCellValue(GridRecord, AllChargeSheetsPerformedColumn.Index);

    if Options.AllSubordinateChargeSheetsPerformedFieldOptions.Required then
      AllSubordinateChargeSheetsPerformed := GetRecordCellValue(GridRecord, AllSubordinateChargeSheetsPerformedColumn.Index);
    
  end;
  
end;

function TEmployeeDocumentsReferenceFormProcessor.CreateDefaultOptionsInstance: IDocumentsReferenceFormProcessorOptions;
begin

  Result := TEmployeeDocumentsReferenceFormProcessorOptions.Create;
  
end;

function TEmployeeDocumentsReferenceFormProcessor.CreateDocumentRecordViewModelInstance: TDocumentRecordViewModel;
begin

  Result := TEmployeeDocumentRecordViewModel.Create;

end;

procedure TEmployeeDocumentsReferenceFormProcessor.FillDefaultOptions(
  Options: IDocumentsReferenceFormProcessorOptions);
begin

  inherited FillDefaultOptions(Options);

  with IEmployeeDocumentsReferenceFormProcessorOptions(Options) do begin

    OwnChargeSheetFieldRequired(True);
    AllChargeSheetsPerformedFieldOptions(
      TDocumentsReferenceFormFieldOptions.Create.Visible(False).Required(True)
    );
    AllSubordinateChargeSheetsPerformedFieldOptions(
      TDocumentsReferenceFormFieldOptions.Create.Visible(False).Required(True)
    );
    
  end;

end;

procedure TEmployeeDocumentsReferenceFormProcessor.FillDocumentSetRecordByViewModel(
  DocumentSetHolder: TDocumentSetHolder;
  RecordViewModel: TDocumentRecordViewModel
);
begin

  inherited FillDocumentSetRecordByViewModel(DocumentSetHolder, RecordViewModel);

  with
    DocumentSetHolder as TEmployeeDocumentSetHolder,
    RecordViewModel as TEmployeeDocumentRecordViewModel
  do begin

    IsViewedFieldValue := IsViewed;

    if Options.OwnChargeSheetFieldRequired then
      OwnChargeSheetFieldValue := OwnChargeSheet;

    if Options.AllChargeSheetsPerformedFieldOptions.Required then
      AllChargeSheetsPerformedFieldValue := AllChargeSheetsPerformed;

    if Options.AllSubordinateChargeSheetsPerformedFieldOptions.Required then
      AllSubordinateChargeSheetsPerformedFieldValue := AllSubordinateChargeSheetsPerformed;
    
  end;
  
end;

function TEmployeeDocumentsReferenceFormProcessor.GetEmployeeDocumentsReferenceFormProcessorOptions: IEmployeeDocumentsReferenceFormProcessorOptions;
begin

  Supports(inherited Options, IEmployeeDocumentsReferenceFormProcessorOptions, Result);

end;

procedure TEmployeeDocumentsReferenceFormProcessor.OnDocumentRecordFocused(
  DocumentsReferenceForm: IDocumentsReferenceForm);
begin

  inherited OnDocumentRecordFocused(DocumentsReferenceForm);

  with
    DocumentsReferenceForm.Self as TBaseDocumentsReferenceForm,
    TBaseDocumentsReferenceForm(DocumentsReferenceForm.Self).DocumentSetHolder as TEmployeeDocumentSetHolder
  do begin

    if not IsViewedFieldValue then begin

      FDocumentViewingAccountingService.
        MarkDocumentAsViewedByEmployeeIfItIsNotViewed(
          DocumentIdFieldValue,
          WorkingEmployeeId,
          Now
        );

      IsViewedFieldValue := True;

    end;

  end;

end;

procedure TEmployeeDocumentsReferenceFormProcessor.InternalSetDocumentReferenceFormColumns(
  DocumentsReferenceForm: IDocumentsReferenceForm;
  FieldDefs: TDocumentSetFieldDefs
);
begin

  inherited InternalSetDocumentReferenceFormColumns(DocumentsReferenceForm, FieldDefs);

  with
    DocumentsReferenceForm.Self as TBaseDocumentsReferenceForm,
    FieldDefs as TEmployeeDocumentSetFieldDefs
  do begin

//    IsDocumentViewedColumn.Visible := True;
    IsDocumentViewedColumn.VisibleForCustomization := True;
    IsDocumentViewedColumn.DataBinding.FieldName := IsViewedFieldName;

//    OwnChargeSheetColumn.Visible := Options.OwnChargeSheetFieldRequired;
//    OwnChargeSheetColumn.VisibleForCustomization := Options.OwnChargeSheetFieldRequired;

    OwnChargeSheetColumn.VisibleForCustomization := Options.OwnChargeSheetFieldRequired;
    if not Options.OwnChargeSheetFieldRequired then
      OwnChargeSheetColumn.Visible := False;
    

    if Options.OwnChargeSheetFieldRequired then
      OwnChargeSheetColumn.DataBinding.FieldName := OwnChargeSheetFieldName;

//    AllChargeSheetsPerformedColumn.Visible := Options.AllChargeSheetsPerformedFieldOptions.Visible;
//    AllChargeSheetsPerformedColumn.VisibleForCustomization := Options.AllChargeSheetsPerformedFieldOptions.Visible;

    AllChargeSheetsPerformedColumn.VisibleForCustomization := Options.AllChargeSheetsPerformedFieldOptions.Visible;
    if not Options.AllChargeSheetsPerformedFieldOptions.Visible then
      AllChargeSheetsPerformedColumn.Visible := False;

    if Options.AllChargeSheetsPerformedFieldOptions.Required then
      AllChargeSheetsPerformedColumn.DataBinding.FieldName := AllChargeSheetsPerformedFieldName;

//    AllSubordinateChargeSheetsPerformedColumn.Visible := Options.AllSubordinateChargeSheetsPerformedFieldOptions.Visible;
//    AllSubordinateChargeSheetsPerformedColumn.VisibleForCustomization := Options.AllSubordinateChargeSheetsPerformedFieldOptions.Visible;

    AllSubordinateChargeSheetsPerformedColumn.VisibleForCustomization := Options.AllSubordinateChargeSheetsPerformedFieldOptions.Visible;
    if not Options.AllSubordinateChargeSheetsPerformedFieldOptions.Visible then
      AllSubordinateChargeSheetsPerformedColumn.Visible := False;
    
    if Options.AllSubordinateChargeSheetsPerformedFieldOptions.Required then
      AllSubordinateChargeSheetsPerformedColumn.DataBinding.FieldName := AllSubordinateChargeSheetsPerformedFieldName;
    
  end;
  
end;

procedure TEmployeeDocumentsReferenceFormProcessor.SetEmployeeDocumentsReferenceFormProcessorOptions(
  Value: IEmployeeDocumentsReferenceFormProcessorOptions);
begin

  inherited Options := Value;
  
end;

{ TEmployeeDocumentsReferenceFormProcessorOptions }

function TEmployeeDocumentsReferenceFormProcessorOptions.AllChargeSheetsPerformedFieldOptions(
  const Value: IDocumentsReferenceFormFieldOptions): IEmployeeDocumentsReferenceFormProcessorOptions;
begin

  FAllChargeSheetsPerformedFieldOptions := Value;

  Result := Self;

end;

function TEmployeeDocumentsReferenceFormProcessorOptions
  .AllChargeSheetsPerformedFieldOptions: IDocumentsReferenceFormFieldOptions;
begin

  Result := FAllChargeSheetsPerformedFieldOptions;
  
end;

function TEmployeeDocumentsReferenceFormProcessorOptions.AllSubordinateChargeSheetsPerformedFieldOptions(
  const Value: IDocumentsReferenceFormFieldOptions): IEmployeeDocumentsReferenceFormProcessorOptions;
begin

  FAllSubordinateChargeSheetsPerformedFieldOptions := Value;

  Result := Self;

end;

function TEmployeeDocumentsReferenceFormProcessorOptions
  .AllSubordinateChargeSheetsPerformedFieldOptions: IDocumentsReferenceFormFieldOptions;
begin

  Result := FAllSubordinateChargeSheetsPerformedFieldOptions;
  
end;

function TEmployeeDocumentsReferenceFormProcessorOptions.OwnChargeSheetFieldRequired: Boolean;
begin

  Result := FOwnChargeSheetFieldRequired;
  
end;

function TEmployeeDocumentsReferenceFormProcessorOptions.OwnChargeSheetFieldRequired(
  const Value: Boolean): IEmployeeDocumentsReferenceFormProcessorOptions;
begin

  FOwnChargeSheetFieldRequired := Value;

  Result := Self;
  
end;

end.

