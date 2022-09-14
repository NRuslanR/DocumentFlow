unit DocumentsReferenceFormProcessor;

interface

uses

  DocumentSetHolder,
  DocumentRecordViewModel,
  DocumentsReferenceForm,
  IGetSelfUnit,
  cxGridCustomTableView,
  SysUtils;

type

  IDocumentsReferenceFormFieldOptions = interface (IGetSelf)

    function Visible: Boolean; overload;
    function Visible(const Value: Boolean): IDocumentsReferenceFormFieldOptions; overload;

    function Required: Boolean; overload;
    function Required(const Value: Boolean): IDocumentsReferenceFormFieldOptions; overload;

  end;

  TDocumentsReferenceFormFieldOptions = class (TInterfacedObject, IDocumentsReferenceFormFieldOptions)

    protected

      FVisible: Boolean;
      FRequired: Boolean;

    public

      function GetSelf: TObject;
      
    public

      function Visible: Boolean; overload;
      function Visible(const Value: Boolean): IDocumentsReferenceFormFieldOptions; overload;

      function Required: Boolean; overload;
      function Required(const Value: Boolean): IDocumentsReferenceFormFieldOptions; overload;

  end;

  IDocumentsReferenceFormProcessorOptions = interface (IGetSelf)
    ['{4E04352D-7FBD-4E0D-B38B-095849625BE4}']
    
    function IsSelfRegisteredFieldRequired: Boolean; overload;
    function IsSelfRegisteredFieldRequired(const Value: Boolean): IDocumentsReferenceFormProcessorOptions; overload;

    function ChargesPerformingStatisticsFieldRequired: Boolean; overload;
    function ChargesPerformingStatisticsFieldRequired(const Value: Boolean): IDocumentsReferenceFormProcessorOptions; overload;

  end;

  TDocumentsReferenceFormProcessorOptions =
    class (TInterfacedObject, IDocumentsReferenceFormProcessorOptions)

      private

        FIsSelfRegisteredFieldRequired: Boolean;
        FChargesPerformingStatisticsFieldRequired: Boolean;
        
      public

        function GetSelf: TObject;
        
      public

        function IsSelfRegisteredFieldRequired: Boolean; overload; virtual;
        function IsSelfRegisteredFieldRequired(const Value: Boolean): IDocumentsReferenceFormProcessorOptions; overload; virtual;

        function ChargesPerformingStatisticsFieldRequired: Boolean; overload; virtual;
        function ChargesPerformingStatisticsFieldRequired(const Value: Boolean): IDocumentsReferenceFormProcessorOptions; overload; virtual;

    end;

  IDocumentsReferenceFormProcessor = interface (IGetSelf)

    procedure OnDocumentRecordFocused(
      DocumentsReferenceForm: IDocumentsReferenceForm
    ); 

    procedure SetDocumentReferenceFormColumns(
      DocumentsReferenceForm: IDocumentsReferenceForm;
      FieldDefs: TDocumentSetFieldDefs
    );

    procedure FillDocumentSetRecordByViewModel(
      DocumentSetHolder: TDocumentSetHolder;
      RecordViewModel: TDocumentRecordViewModel
    );

    function CreateDocumentRecordViewModelFrom(
      DocumentSetHolder: TDocumentSetHolder;
      const DocumentId: Variant
    ): TDocumentRecordViewModel;

    function CreateDocumentRecordViewModelFromGridRecord(
      DocumentsReferenceForm: IDocumentsReferenceForm;
      const GridRecord: TcxCustomGridRecord
    ): TDocumentRecordViewModel;

    function CreateCurrentDocumentRecordViewModelFrom(
      DocumentSetHolder: TDocumentSetHolder
    ): TDocumentRecordViewModel;


    function GetOptions: IDocumentsReferenceFormProcessorOptions;
    procedure SetOptions(Value: IDocumentsReferenceFormProcessorOptions);

    property Options: IDocumentsReferenceFormProcessorOptions
    read GetOptions write SetOptions;
    
  end;

  TDocumentsReferenceFormProcessor =
    class (TInterfacedObject, IDocumentsReferenceFormProcessor)

      protected

        FOptions: IDocumentsReferenceFormProcessorOptions;
        
        function CreateDefaultOptions: IDocumentsReferenceFormProcessorOptions;

        function CreateDefaultOptionsInstance: IDocumentsReferenceFormProcessorOptions; virtual;
        procedure FillDefaultOptions(Options: IDocumentsReferenceFormProcessorOptions); virtual;

        function GetOptions: IDocumentsReferenceFormProcessorOptions; virtual;
        procedure SetOptions(Value: IDocumentsReferenceFormProcessorOptions); virtual;

      protected

        procedure FillViewModelByDocumentSetRecord(
          RecordViewModel: TDocumentRecordViewModel;
          DocumentSetHolder: TDocumentSetHolder
        ); virtual;

        procedure FillViewModelByGridRecord(
          RecordViewModel: TDocumentRecordViewModel;
          DocumentsReferenceForm: IDocumentsReferenceForm;
          const GridRecord: TcxCustomGridRecord
        ); virtual;

        function CreateDocumentRecordViewModelInstance: TDocumentRecordViewModel; virtual;

        function InternalCreateDocumentRecordViewModelFrom(
          DocumentSetHolder: TDocumentSetHolder;
          const DocumentId: Variant
        ): TDocumentRecordViewModel; virtual;

        function InternalCreateDocumentRecordViewModelFromGridRecord(
          DocumentsReferenceForm: IDocumentsReferenceForm;
          const GridRecord: TcxCustomGridRecord
        ): TDocumentRecordViewModel; virtual;
        
      public

        constructor Create(Options: IDocumentsReferenceFormProcessorOptions = nil);

        procedure OnDocumentRecordFocused(
          DocumentsReferenceForm: IDocumentsReferenceForm
        ); virtual;
        
        procedure SetDocumentReferenceFormColumns(
          DocumentsReferenceForm: IDocumentsReferenceForm;
          FieldDefs: TDocumentSetFieldDefs
        );

        protected

          procedure InternalSetDocumentReferenceFormColumns(
            DocumentsReferenceForm: IDocumentsReferenceForm;
            FieldDefs: TDocumentSetFieldDefs
          ); virtual;

      public

        procedure FillDocumentSetRecordByViewModel(
          DocumentSetHolder: TDocumentSetHolder;
          RecordViewModel: TDocumentRecordViewModel
        ); virtual;

        function CreateDocumentRecordViewModelFromGridRecord(
          DocumentsReferenceForm: IDocumentsReferenceForm;
          const GridRecord: TcxCustomGridRecord
        ): TDocumentRecordViewModel;

        function CreateDocumentRecordViewModelFrom(
          DocumentSetHolder: TDocumentSetHolder;
          const DocumentId: Variant
        ): TDocumentRecordViewModel;

        function CreateCurrentDocumentRecordViewModelFrom(
          DocumentSetHolder: TDocumentSetHolder
        ): TDocumentRecordViewModel;

        function GetSelf: TObject;

        property Options: IDocumentsReferenceFormProcessorOptions
        read GetOptions write SetOptions;

    end;

implementation

uses

  Variants,
  AuxDebugFunctionsUnit,
  BaseDocumentsReferenceFormUnit, DBDataTableFormUnit, AbstractDataSetHolder;

{ TDocumentsReferenceFormProcessor }

procedure TDocumentsReferenceFormProcessor.SetDocumentReferenceFormColumns(
  DocumentsReferenceForm: IDocumentsReferenceForm;
  FieldDefs: TDocumentSetFieldDefs
);
begin

  InternalSetDocumentReferenceFormColumns(DocumentsReferenceForm, FieldDefs);

end;

procedure TDocumentsReferenceFormProcessor.SetOptions(
  Value: IDocumentsReferenceFormProcessorOptions);
begin

  FOptions := Value;
  
end;

procedure TDocumentsReferenceFormProcessor.FillDefaultOptions(
  Options: IDocumentsReferenceFormProcessorOptions);
begin

  Options
    .IsSelfRegisteredFieldRequired(False)
    .ChargesPerformingStatisticsFieldRequired(True);
  
end;

procedure TDocumentsReferenceFormProcessor.FillDocumentSetRecordByViewModel(
  DocumentSetHolder: TDocumentSetHolder;
  RecordViewModel: TDocumentRecordViewModel
);
var
    IsPrevDataSetStateInEditOrAppend: Boolean;
begin

  with DocumentSetHolder, RecordViewModel do begin

    IsPrevDataSetStateInEditOrAppend := IsInEditOrAppend;

    if not IsInEditOrAppend then Edit;
    
    RecordIdFieldValue := DocumentId;
    BaseDocumentIdFieldValue := BaseDocumentId;
    KindFieldValue := Kind;
    KindIdFieldValue := KindId;
    DocumentDateFieldValue := DocumentDate;
    CreationDateFieldValue := CreationDate;
    CreationDateYearFieldValue := CreationDateYear;
    CreationDateMonthFieldValue := CreationDateMonth;
    CurrentWorkCycleStageNumberFieldValue := CurrentWorkCycleStageNumber;
    CurrentWorkCycleStageNameFieldValue := CurrentWorkCycleStageName;
    NumberFieldValue := Number;
    NameFieldValue := Name;
    AuthorIdFieldValue := AuthorId;
    AuthorNameFieldValue := AuthorName;
    ProductCodeFieldValue := ProductCode;
    CanBeRemovedFieldValue := CanBeRemoved;

    if DocumentSetHolder.IsFieldExists(DocumentSetHolder.AreApplicationsExistsFieldName) then
      AreApplicationsExistsFieldValue := AreApplicationsExists;

    if Options.IsSelfRegisteredFieldRequired then begin

      IsSelfRegisteredFieldValue := IsSelfRegistered;

    end;

    if Options.ChargesPerformingStatisticsFieldRequired then begin

      ChargePerformingStatisticsFieldValue := ChargePerformingStatistics;

    end;

    if not IsPrevDataSetStateInEditOrAppend then Post;

  end;

end;

constructor TDocumentsReferenceFormProcessor.Create(
  Options: IDocumentsReferenceFormProcessorOptions);
begin

  inherited Create;

  if Assigned(Options) then
    Self.Options := Options

  else Self.Options := CreateDefaultOptions;
  
end;

function TDocumentsReferenceFormProcessor.CreateCurrentDocumentRecordViewModelFrom(
  DocumentSetHolder: TDocumentSetHolder): TDocumentRecordViewModel;
begin

  if not DocumentSetHolder.IsEmpty then
    Result := CreateDocumentRecordViewModelFrom(DocumentSetHolder, DocumentSetHolder.DocumentIdFieldValue)

  else Result := nil;

end;

function TDocumentsReferenceFormProcessor.CreateDefaultOptions: IDocumentsReferenceFormProcessorOptions;
begin

  Result := CreateDefaultOptionsInstance;

  FillDefaultOptions(Result);
  
end;

function TDocumentsReferenceFormProcessor.CreateDefaultOptionsInstance: IDocumentsReferenceFormProcessorOptions;
begin

  Result := TDocumentsReferenceFormProcessorOptions.Create;
  
end;

function TDocumentsReferenceFormProcessor.CreateDocumentRecordViewModelFrom(
  DocumentSetHolder: TDocumentSetHolder;
  const DocumentId: Variant
): TDocumentRecordViewModel;
var
    PreviousFocusedRecordPointer: Pointer;
begin

  if VarIsNull(DocumentId) or DocumentSetHolder.IsEmpty then begin

    Result := nil;
    Exit;
    
  end;

  PreviousFocusedRecordPointer := DocumentSetHolder.GetBookmark;

  try

    DocumentSetHolder.DisableControls;

    if DocumentSetHolder.RecordIdFieldValue <> DocumentId
    then begin

      DocumentSetHolder.LocateByRecordId(DocumentId);

    end;

    Result := InternalCreateDocumentRecordViewModelFrom(DocumentSetHolder, DocumentId);

  finally

    try

      DocumentSetHolder.GotoBookmarkAndFree(PreviousFocusedRecordPointer);

    finally

      DocumentSetHolder.EnableControls;
      
    end;

  end;

end;

function TDocumentsReferenceFormProcessor.CreateDocumentRecordViewModelFromGridRecord(
  DocumentsReferenceForm: IDocumentsReferenceForm;
  const GridRecord: TcxCustomGridRecord
): TDocumentRecordViewModel;
begin

  if not Assigned(GridRecord) then begin

    Result := nil;
    Exit;

  end;

  Result := InternalCreateDocumentRecordViewModelFromGridRecord(DocumentsReferenceForm, GridRecord);

end;

function TDocumentsReferenceFormProcessor.
  CreateDocumentRecordViewModelInstance: TDocumentRecordViewModel;
begin

  Result := TDocumentRecordViewModel.Create;
  
end;

procedure TDocumentsReferenceFormProcessor.FillViewModelByDocumentSetRecord(
  RecordViewModel: TDocumentRecordViewModel;
  DocumentSetHolder: TDocumentSetHolder
);
begin

  with RecordViewModel, DocumentSetHolder do begin

    DocumentId := RecordIdFieldValue;
    BaseDocumentId := BaseDocumentIdFieldValue;
    Kind := KindFieldValue;
    KindId := KindIdFieldValue;
    DocumentDate := DocumentDateFieldValue;
    CreationDate := CreationDateFieldValue;
    CreationDateYear := CreationDateYearFieldValue;
    CreationDateMonth := CreationDateMonthFieldValue;
    CurrentWorkCycleStageNumber := CurrentWorkCycleStageNumberFieldValue;
    CurrentWorkCycleStageName := CurrentWorkCycleStageNameFieldValue;
    Number := NumberFieldValue;
    Name := NameFieldValue;
    AuthorId := AuthorIdFieldValue;
    AuthorName:= AuthorNameFieldValue;
    ProductCode := ProductCodeFieldValue;

    if DocumentSetHolder.IsFieldExists(DocumentSetHolder.AreApplicationsExistsFieldName) then
      AreApplicationsExists := AreApplicationsExistsFieldValue;

    if Options.ChargesPerformingStatisticsFieldRequired then begin

      ChargePerformingStatistics := ChargePerformingStatisticsFieldValue;

    end;

    CanBeRemoved := CanBeRemovedFieldValue;

    if Options.IsSelfRegisteredFieldRequired then begin

      IsSelfRegistered := IsSelfRegisteredFieldValue;

    end;

  end;

end;

procedure TDocumentsReferenceFormProcessor.FillViewModelByGridRecord(
  RecordViewModel: TDocumentRecordViewModel;
  DocumentsReferenceForm: IDocumentsReferenceForm;
  const GridRecord: TcxCustomGridRecord
);
begin

  with
    DocumentsReferenceForm.Self as TBaseDocumentsReferenceForm,
    RecordViewModel
  do begin

    DocumentId := GetRecordCellValue(GridRecord, IdColumn.Index);
    BaseDocumentId := GetRecordCellValue(GridRecord, BaseDocumentIdColumn.Index);
    Kind := GetRecordCellValue(GridRecord, DocumentTypeNameColumn.Index);
    KindId := GetRecordCellValue(GridRecord, DocumentTypeIdColumn.Index);
    DocumentDate := GetRecordCellValue(GridRecord, DocumentDateColumn.Index);
    CreationDate := GetRecordCellValue(GridRecord, DocumentCreationDateColumn.Index);
    CreationDateYear := GetRecordCellValue(GridRecord, DocumentCreationDateYearColumn.Index);
    CreationDateMonth := GetRecordCellValue(GridRecord, DocumentCreationDateMonthColumn.Index);
    CurrentWorkCycleStageNumber := GetRecordCellValue(GridRecord, CurrentWorkCycleStageNumberColumn.Index);
    CurrentWorkCycleStageName := GetRecordCellValue(GridRecord, CurrentWorkCycleStageNameColumn.Index);
    Number := GetRecordCellValue(GridRecord, DocumentNumberColumn.Index);
    Name := GetRecordCellValue(GridRecord, DocumentNameColumn.Index);
    AuthorId := GetRecordCellValue(GridRecord, DocumentAuthorIdColumn.Index);
    AuthorName := GetRecordCellValue(GridRecord, DocumentAuthorShortNameColumn.Index);
    CanBeRemoved := GetRecordCellValue(GridRecord, ChargePerformingStatsColumn.Index);
    AreApplicationsExists := GetRecordCellValue(GridRecord, ApplicationsExistsColumn.Index);
    ProductCode := GetRecordCellValue(GridRecord, ProductCodeColumn.Index);

    if Options.IsSelfRegisteredFieldRequired then begin

      IsSelfRegistered := GetRecordCellValue(GridRecord, IsSelfRegisteredColumn.Index);

    end;

    if Options.ChargesPerformingStatisticsFieldRequired then begin

      ChargePerformingStatistics :=
        GetRecordCellValue(GridRecord, ChargePerformingStatsColumn.Index);
        
    end;

  end;

end;

function TDocumentsReferenceFormProcessor.GetOptions: IDocumentsReferenceFormProcessorOptions;
begin

  Result := FOptions;
  
end;

function TDocumentsReferenceFormProcessor.GetSelf: TObject;
begin

  Result := Self;
  
end;

function TDocumentsReferenceFormProcessor.InternalCreateDocumentRecordViewModelFrom(
  DocumentSetHolder: TDocumentSetHolder;
  const DocumentId: Variant): TDocumentRecordViewModel;
begin

  Result := CreateDocumentRecordViewModelInstance;

  try

    FillViewModelByDocumentSetRecord(Result, DocumentSetHolder);

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TDocumentsReferenceFormProcessor.InternalCreateDocumentRecordViewModelFromGridRecord(
  DocumentsReferenceForm: IDocumentsReferenceForm;
  const GridRecord: TcxCustomGridRecord): TDocumentRecordViewModel;
begin

  Result := CreateDocumentRecordViewModelInstance;

  try

    FillViewModelByGridRecord(Result, DocumentsReferenceForm, GridRecord);

  except

    FreeAndNil(Result);

    Raise;

  end;
  
end;

procedure TDocumentsReferenceFormProcessor.InternalSetDocumentReferenceFormColumns(
  DocumentsReferenceForm: IDocumentsReferenceForm;
  FieldDefs: TDocumentSetFieldDefs
);
begin

   with
    DocumentsReferenceForm.Self as TBaseDocumentsReferenceForm,
    FieldDefs
  do begin

    IdColumn.DataBinding.FieldName := RecordIdFieldName;
    BaseDocumentIdColumn.DataBinding.FieldName := BaseDocumentIdFieldName;
    DocumentTypeNameColumn.DataBinding.FieldName := KindFieldName;
    DocumentTypeIdColumn.DataBinding.FieldName := KindIdFieldName;
    DocumentDateColumn.DataBinding.FieldName := DocumentDateFieldName;
    DocumentCreationDateColumn.DataBinding.FieldName := CreationDateFieldName;
    DocumentCreationDateYearColumn.DataBinding.FieldName := CreationDateYearFieldName;
    DocumentCreationDateMonthColumn.DataBinding.FieldName := CreationDateMonthFieldName;
    CurrentWorkCycleStageNumberColumn.DataBinding.FieldName := CurrentWorkCycleStageNumberFieldName;
    CurrentWorkCycleStageNameColumn.DataBinding.FieldName := CurrentWorkCycleStageNameFieldName;
    DocumentNumberColumn.DataBinding.FieldName := NumberFieldName;
    DocumentNameColumn.DataBinding.FieldName := NameFieldName;
    DocumentAuthorIdColumn.DataBinding.FieldName := AuthorIdFieldName;
    DocumentAuthorShortNameColumn.DataBinding.FieldName := AuthorNameFieldName;

    ApplicationsExistsColumn.DataBinding.FieldName := AreApplicationsExistsFieldName;
    ProductCodeColumn.DataBinding.FieldName := ProductCodeFieldName;
    
//    ChargePerformingStatsColumn.Visible := Options.ChargesPerformingStatisticsFieldRequired;
//    ChargePerformingStatsColumn.VisibleForCustomization := Options.ChargesPerformingStatisticsFieldRequired;

    ChargePerformingStatsColumn.VisibleForCustomization := Options.ChargesPerformingStatisticsFieldRequired;
    if not Options.ChargesPerformingStatisticsFieldRequired then
      ChargePerformingStatsColumn.Visible := False;

    if Options.ChargesPerformingStatisticsFieldRequired then begin

      ChargePerformingStatsColumn.DataBinding.FieldName := ChargePerformingStatisticsFieldName;

    end;

//    IsSelfRegisteredColumn.Visible := Options.IsSelfRegisteredFieldRequired;
//    IsSelfRegisteredColumn.VisibleForCustomization := Options.IsSelfRegisteredFieldRequired;

    IsSelfRegisteredColumn.VisibleForCustomization := Options.IsSelfRegisteredFieldRequired;
    if not Options.IsSelfRegisteredFieldRequired then
      IsSelfRegisteredColumn.Visible := False;

    if Options.IsSelfRegisteredFieldRequired then begin

      IsSelfRegisteredColumn.DataBinding.FieldName := IsSelfRegisteredFieldName;

    end;

    DataRecordGridTableView.DataController.KeyFieldNames := RecordIdFieldName;
    
  end;
  
end;

procedure TDocumentsReferenceFormProcessor.OnDocumentRecordFocused(
  DocumentsReferenceForm: IDocumentsReferenceForm
);
begin

end;

{ TDocumentsReferenceFormProcessorOptions }

function TDocumentsReferenceFormProcessorOptions.IsSelfRegisteredFieldRequired: Boolean;
begin

  Result := FIsSelfRegisteredFieldRequired;
  
end;

function TDocumentsReferenceFormProcessorOptions.ChargesPerformingStatisticsFieldRequired: Boolean;
begin

  Result := FChargesPerformingStatisticsFieldRequired;
  
end;

function TDocumentsReferenceFormProcessorOptions.ChargesPerformingStatisticsFieldRequired(
  const Value: Boolean): IDocumentsReferenceFormProcessorOptions;
begin

  FChargesPerformingStatisticsFieldRequired := Value;

  Result := Self;

end;

function TDocumentsReferenceFormProcessorOptions.GetSelf: TObject;
begin

  Result := Self;

end;

function TDocumentsReferenceFormProcessorOptions.IsSelfRegisteredFieldRequired(
  const Value: Boolean): IDocumentsReferenceFormProcessorOptions;
begin

  FIsSelfRegisteredFieldRequired := Value;

  Result := Self;

end;

{ TDocumentsReferenceFormFieldOptions }

function TDocumentsReferenceFormFieldOptions.GetSelf: TObject;
begin

  Result := Self;

end;

function TDocumentsReferenceFormFieldOptions.Required: Boolean;
begin

  Result := FRequired;

end;

function TDocumentsReferenceFormFieldOptions.Required(
  const Value: Boolean
): IDocumentsReferenceFormFieldOptions;
begin

  FRequired := Value;

  Result := Self;

end;

function TDocumentsReferenceFormFieldOptions.Visible: Boolean;
begin

  Result := FVisible;

end;

function TDocumentsReferenceFormFieldOptions.Visible(
  const Value: Boolean): IDocumentsReferenceFormFieldOptions;
begin

  FVisible := Value;

  Result := Self;
  
end;

end.

