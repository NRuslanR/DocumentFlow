unit BaseDocumentsReferenceFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, cxControls, cxStyles, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, ActnList, ImgList, PngImageList, cxGridLevel, cxClasses,
  cxGridCustomView, cxGrid, cxButtons, ComCtrls, pngimage, ExtCtrls, StdCtrls,
  ToolWin, ZAbstractRODataset, ZAbstractDataset, ZDataset,
  TableViewFilterFormUnit,
  BaseDocumentsReferenceFilterFormUnit, cxSpinEdit,
  cxTextEdit,
  DocumentsReferenceViewModel,
  DBDataTableFormUnit,
  cxCheckBox, cxLocalization, DocumentRecordViewModel,
  DocumentFlowBaseReferenceFormUnit,
  UIDocumentKindResolver,
  unDocumentCardFrame,
  EmployeeDocumentChargesWorkStatistics,
  DocumentKindWorkCycleColors,
  OperationalDocumentKindInfo,
  DocumentSetHolder,
  DocumentKinds,
  DocumentCardFormUnit,
  EmployeeDocumentRecordViewModel,
  DocumentsReferenceFormProcessor,
  DocumentsReferenceForm,
  UIDocumentKinds, cxImageComboBox,
  Hashes;

type

  TOnNewDocumentCreatingRequestedEventHandler =
    procedure (
      Sender:  TObject;
      var DocumentCardFrame: TDocumentCardFrame
    ) of object;

  TOnNewDocumentCreatingConfirmedEventHandler =
    procedure (
      Sender:  TObject;
      DocumentCardFrame: TDocumentCardFrame
    ) of object;

  TOnNewDocumentCreatingFinishedEventHandler =
    procedure (
      Sender: TObject;
      DocumentCardFrame: TDocumentCardFrame
    ) of object;

  TOnSelectedDocumentRecordChangedEventHandler =
    procedure (
      Sender: TObject
    ) of object;

  TOnSelectedDocumentRecordChangingEventHandler =
    procedure (
      Sender: TObject
    ) of object;

  TOnDocumentRecordsLoadingSuccessEventHandler =
    procedure (
      Sender: TObject
    ) of object;

  TOnDocumentRecordsLoadingFailedEventHandler =
    procedure (
      Sender: TObject;
      const Error: Exception
    ) of object;

  TOnDocumentRecordsLoadingCanceledEventHandler =
    procedure (
      Sender: TObject
    ) of object;

  TOnDocumentDeletingRequestedEventHandler =
    procedure (
      Sender: TObject;
      const DocumentId: Variant
    ) of object;

  TOnDocumentRecordDeletedEventHandler =
    procedure (
      Sender: TObject
    ) of object;

  TOnDocumentRecordsRefreshRequestedEventHandler =
    procedure (
      Sender: TObject;
      CurrentViewModel: TDocumentsReferenceViewModel;
      var UpdatedViewModel: TDocumentsReferenceViewModel
    ) of object;

  TOnDocumentRecordsRefreshedEventHandler =
    procedure (
      Sender: TObject
    ) of object;

  TOnDocumentRecordFocusedEventHandler =
    procedure (
      Sender: TObject;
      PreviousFocusedDocumentRecordViewModel: TDocumentRecordViewModel;
      FocusedDocumentRecordViewModel: TDocumentRecordViewModel
    ) of object;

  TOnDocumentRecordChangingRequestedEventHandler =
    procedure (
      Sender: TObject;
      DocumentRecordViewModel: TDocumentRecordViewModel
    ) of object;

  TOnDocumentCardRefreshRequestedEventHandler =
    procedure (
      Sender: TObject;
      const DocumentId: Variant;
      const DocumentKindId: Variant
    ) of object;

  TBaseDocumentsReferenceForm = class(TDocumentFlowBaseReferenceForm, IDocumentsReferenceForm)
    IdColumn: TcxGridDBColumn;
    DocumentTypeIdColumn: TcxGridDBColumn;
    DocumentNumberColumn: TcxGridDBColumn;
    DocumentNameColumn: TcxGridDBColumn;
    DocumentCreationDateColumn: TcxGridDBColumn;
    DocumentTypeNameColumn: TcxGridDBColumn;
    CurrentWorkCycleStageNameColumn: TcxGridDBColumn;
    CurrentWorkCycleStageNumberColumn: TcxGridDBColumn;
    DocumentCreationDateYearColumn: TcxGridDBColumn;
    DocumentCreationDateMonthColumn: TcxGridDBColumn;
    DocumentAuthorShortNameColumn: TcxGridDBColumn;
    DocumentAuthorIdColumn: TcxGridDBColumn;
    CanBeRemovedColumn: TcxGridDBColumn;
    ChargePerformingStatsColumn: TcxGridDBColumn;
    DataRecordGridDBTableView1: TcxGridDBTableView;
    IsDocumentViewedColumn: TcxGridDBColumn;
    BaseDocumentIdColumn: TcxGridDBColumn;
    OwnChargeSheetColumn: TcxGridDBColumn;
    AllChargeSheetsPerformedColumn: TcxGridDBColumn;
    AllSubordinateChargeSheetsPerformedColumn: TcxGridDBColumn;
    IsSelfRegisteredColumn: TcxGridDBColumn;
    DocumentDateColumn: TcxGridDBColumn;
    ApplicationsExistsColumn: TcxGridDBColumn;
    ApplicationsImageList: TPngImageList;
    ProductCodeColumn: TcxGridDBColumn;
    actRefreshDocumentCard: TAction;
    RefreshDocumentCardToolButton: TToolButton;
    N5: TMenuItem;
    DocumentWorkCycleStageNamesPopupMenu: TPopupMenu;
    procedure DataRecordGridTableViewGetStoredPropertyValue(
      Sender: TcxCustomGridView; const AName: string; var AValue: Variant);
    procedure DataRecordGridTableViewDataControllerCompare(
      ADataController: TcxCustomDataController; ARecordIndex1, ARecordIndex2,
      AItemIndex: Integer; const V1, V2: Variant; var Compare: Integer);
    procedure DataRecordGridTableViewCustomDrawCell(
      Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
    procedure DataRecordGridTableViewFocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure actRefreshDataExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DataOperationToolBarAdvancedCustomDrawButton(Sender: TToolBar;
      Button: TToolButton; State: TCustomDrawState; Stage: TCustomDrawStage;
      var Flags: TTBCustomDrawFlags; var DefaultDraw: Boolean);
    procedure actRefreshDocumentCardExecute(Sender: TObject);

  protected

    FOnDocumentDeletingRequestedEventHandler:
      TOnDocumentDeletingRequestedEventHandler;
      
    FOnSelectedDocumentRecordChangingEventHandler:
      TOnSelectedDocumentRecordChangingEventHandler;

    FOnSelectedDocumentRecordChangedEventHandler:
      TOnSelectedDocumentRecordChangedEventHandler;

    FOnNewDocumentCreatingRequestedEventHandler:
      TOnNewDocumentCreatingRequestedEventHandler;

    FOnNewDocumentCreatingConfirmedEventHandler:
      TOnNewDocumentCreatingConfirmedEventHandler;

    FOnNewDocumentCreatingFinishedEventHandler:
      TOnNewDocumentCreatingFinishedEventHandler;

    FOnDocumentRecordsLoadingSuccessEventHandler:
      TOnDocumentRecordsLoadingSuccessEventHandler;

    FOnDocumentRecordsLoadingFailedEventHandler:
      TOnDocumentRecordsLoadingFailedEventHandler;

    FOnDocumentRecordsLoadingCanceledEventHandler:
      TOnDocumentRecordsLoadingCanceledEventHandler;

    FOnDocumentRecordDeletedEventHandler:
      TOnDocumentRecordDeletedEventHandler;

    FOnDocumentRecordsRefreshRequestedEventHandler:
      TOnDocumentRecordsRefreshRequestedEventHandler;

    FOnDocumentRecordsRefreshedEventHandler:
      TOnDocumentRecordsRefreshedEventHandler;

    FOnDocumentRecordFocusedEventHandler:
      TOnDocumentRecordFocusedEventHandler;

    FOnDocumentRecordChangingRequestedEventHandler:
      TOnDocumentRecordChangingRequestedEventHandler;

    FOnDocumentCardRefreshRequestedEventHandler:
      TOnDocumentCardRefreshRequestedEventHandler;

  protected

    FRequestedFocuseableDocumentId: Variant;
    FDocumentsReferenceFormProcessor: IDocumentsReferenceFormProcessor;
    FOperationalDocumentKindInfo: IOperationalDocumentKindInfo;
    FUIDocumentKindResolver: IUIDocumentKindResolver;
    FIsDocumentRecordsRefreshRequested: Boolean;

    function DocumentKindWorkCycleColors: TDocumentKindWorkCycleColors;

  protected

    function OnAddRecord: Boolean; override;

    procedure UpdateDataOperationControls; override;

    procedure SetActivatedDataOperationControls(const Activated: Boolean); override;

    procedure OnDataLoadingSuccessHandle(
      Sender: TObject;
      DataSet: TDataSet;
      RelatedState: TObject;
      const IsDestroyingRequested: Boolean
    ); override;

    procedure OnDataLoadingCancelledHandle(
      Sender: TObject;
      const IsDestroyingRequested: Boolean
    ); override;

    procedure OnDataLoadingErrorOccurredHandle(
      Sender: TObject;
      DataSet: TDataSet;
      const Error: Exception;
      RelatedState: TObject;
      const IsDestroyingRequested: Boolean
    ); override;

    procedure OnDocumentChargeWorkStatisticsRecordCellChanging(
      const RecordIndex: Integer;
      const TotalChargeCount: Integer;
      const PerformedChargeCount: Integer
    ); virtual;

  protected

    function AreAllChargePerformed(
      const TotalChargeCount, PerformedChargeCount: Integer
    ): boolean; virtual;

  protected

    function OnChangeRecord: Boolean; override;
    procedure OnRefreshRecords; override;

    function OnDeleteCurrentRecord: Boolean; override;

  protected

    procedure CustomizeNewDocumentCardForm(NewDocumentCardForm: TDocumentCardForm);
    
  protected

    FEmployeeId: Variant;
    FViewModel: TDocumentsReferenceViewModel;

    FSelectedWorkStageNames: TStrings;

    function CompareColumnCellValues(
      const FirstCellValue, SecondCellValue: Variant;
      const FieldName: String
    ): Integer;

    function GetViewModel: TDocumentsReferenceViewModel;
    procedure SetViewModel(const Value: TDocumentsReferenceViewModel);

    function GetSelectedDocumentWorkCycleStageNames: TStrings;

    function GetSelectedWorkCycleStageNames: TStrings;
    procedure SetSelectedWorkCycleStageNames(const Value: TStrings);

    procedure FillControlsByViewModel(ViewModel: TDocumentsReferenceViewModel); virtual;
    procedure FillDocumentWorkCycleStagesPopupMenuByViewModel(ViewModel: TDocumentsReferenceViewModel); virtual;
    procedure OnDocumentWorkCycleStagesClick(Sender: TObject); virtual;
    procedure UpdateUISelectedDocumentWorkCycleStages; virtual;

    procedure UpdateDocumentToolButtonsVisibilityBy(DocumentSetHolder: TDocumentSetHolder); virtual;

    procedure SetTableColumnLayoutFrom(FieldDefs: TDocumentSetFieldDefs);

  protected

    function GetMessageAboutThatUserAssuredThatWantDeleteSelectedRecords: String; override;
    procedure Init(const Caption: String; ADataSet: TDataSet); override;

    class function GetTableViewFilterFormClass: TTableViewFilterFormClass; override;
    procedure CustomizeTableViewFilterForm(ATableViewFilterForm: TTableViewFilterForm); override;

    function GetDocumentKindIdFromCurrentRecord: Variant;
    function GetDocumentKindIdFromGridRecord(const GridRecord: TcxCustomGridRecord): Variant;
    function ResolveUIDocumentKindFromCurrentRecord: TUIDocumentKindClass;
    function ResolveUIDocumentKindFromGridRecord(const GridRecord: TcxCustomGridRecord): TUIDocumentKindClass;
    function GetDocumentWorkCycleStageNumberFromCurrentRecord: Variant;

    function GetDocumentRecordColor(
      GridRecord: TcxCustomGridRecord
    ): TColor;

    function GetDocumentChargeSheetPerformingStatusColor(
      GridRecord: TcxCustomGridRecord
    ): TColor;

    procedure HighlightDocumentRecordCellTexts(
      Canvas: TcxCanvas;
      GridRecord: TcxCustomGridRecord
    );

    function HighlightDocumentRecordWith(
      Canvas: TcxCanvas;
      GridRecord: TcxCustomGridRecord
    ): Boolean;

    function GetCurrentDocumentRecordId: Variant;

    procedure SetDocumentRemoveToolVisibleForGridRecord(GridRecord: TcxCustomGridRecord);

    procedure RaiseOnDocumentRecordFocusedEventHandler(
      PreviousFocusedDocumentRecordViewModel: TDocumentRecordViewModel;
      FocusedDocumenRecordViewModel: TDocumentRecordViewModel
    );

    procedure RaiseOnNewDocumentCreatingFinishedEventHandler(
      DocumentCardFrame: TDocumentCardFrame
    );
    
    procedure OnDocumentInfoSavingRequestedEventHandler(
      Sender: TObject
    );

    procedure RaiseOnSelectedDocumentRecordChangingEventHandler;
    procedure RaiseOnSelectedDocumentRecordChangedEventHandler;
    procedure RaiseOnDocumentDeletingRequestedEventHandler;
    procedure RaiseOnDocumentRecordDeletedEventHandler;

    function RaiseOnNewDocumentCreatingConfirmedEventHandler(
      NewDocumentCardFrame: TDocumentCardFrame
    ): Boolean;

  public

    destructor Destroy; override;

    constructor Create(
      DocumentsReferenceFormProcessor: IDocumentsReferenceFormProcessor;
      Owner: TComponent
    );

    function GetSelf: TObject;
    
    procedure Show; overload;
    procedure Show(const FocuseableDocumentId: Variant); overload;

    function DocumentSetHolder: TDocumentSetHolder;

    property UIDocumentKindResolver: IUIDocumentKindResolver
    read FUIDocumentKindResolver write FUIDocumentKindResolver;

  protected

    function CreateDocumentRecordViewModelFromGridRecord(const GridRecord: TcxCustomGridRecord): TDocumentRecordViewModel;
    function CreateFocusedDocumentRecordViewModel: TDocumentRecordViewModel;

  public

    procedure AddNewDocumentRecord(
      DocumentRecordViewModel: TDocumentRecordViewModel
    );

    procedure ChangeFocusedDocumentRecordByViewModel(
      DocumentRecordViewModel: TDocumentRecordViewModel
    );

    procedure ChangeDocumentRecordByViewModel(
      DocumentRecordViewModel: TDocumentRecordViewModel
    );

    function GetDocumentRecordViewModel(const DocumentId: Variant): TDocumentRecordViewModel;

  public
  
    procedure ChangeCurrentDocumentChargesWorkStatisticsRecordCell(
      EmployeeDocumentChargesWorkStatistics:
        TEmployeeDocumentChargesWorkStatistics
    );

    procedure ChangeDocumentChargesWorkStatisticsRecordCell(
      const DocumentId: Variant;
      EmployeeDocumentChargesWorkStatistics:
        TEmployeeDocumentChargesWorkStatistics
    );
    
  published

    property EmployeeId: Variant
    read FEmployeeId write FEmployeeId;

    property ViewModel: TDocumentsReferenceViewModel
    read GetViewModel write SetViewModel;

    property DocumentsReferenceFormProcessor: IDocumentsReferenceFormProcessor
    read FDocumentsReferenceFormProcessor write FDocumentsReferenceFormProcessor;
    
    property OperationalDocumentKindInfo: IOperationalDocumentKindInfo
    read FOperationalDocumentKindInfo write FOperationalDocumentKindInfo;

    function SelectedDocumentRecordViewModels: TDocumentRecordViewModels;

    property SelectedWorkCycleStageNames: TStrings
    read GetSelectedWorkCycleStageNames write SetSelectedWorkCycleStageNames;

  published

    property OnDocumentRecordFocusedEventHandler:
      TOnDocumentRecordFocusedEventHandler
    read FOnDocumentRecordFocusedEventHandler
    write FOnDocumentRecordFocusedEventHandler;
    
    property OnNewDocumentCreatingRequestedEventHandler: TOnNewDocumentCreatingRequestedEventHandler
    read FOnNewDocumentCreatingRequestedEventHandler
    write FOnNewDocumentCreatingRequestedEventHandler;

    property OnNewDocumentCreatingConfirmedEventHandler: TOnNewDocumentCreatingConfirmedEventHandler
    read FOnNewDocumentCreatingConfirmedEventHandler
    write FOnNewDocumentCreatingConfirmedEventHandler;

    property OnNewDocumentCreatingFinishedEventHandler:
      TOnNewDocumentCreatingFinishedEventHandler
    read FOnNewDocumentCreatingFinishedEventHandler
    write FOnNewDocumentCreatingFinishedEventHandler;
    
    property OnSelectedDocumentRecordChangingEventHandler:
      TOnSelectedDocumentRecordChangingEventHandler
    read FOnSelectedDocumentRecordChangingEventHandler
    write FOnSelectedDocumentRecordChangingEventHandler;

    property OnSelectedDocumentRecordChangedEventHandler:
      TOnSelectedDocumentRecordChangedEventHandler
    read FOnSelectedDocumentRecordChangedEventHandler
    write FOnSelectedDocumentRecordChangedEventHandler;

    property OnDocumentRecordsLoadingSuccessEventHandler:
      TOnDocumentRecordsLoadingSuccessEventHandler
    read FOnDocumentRecordsLoadingSuccessEventHandler
    write FOnDocumentRecordsLoadingSuccessEventHandler;

    property OnDocumentRecordsLoadingFailedEventHandler:
      TOnDocumentRecordsLoadingFailedEventHandler
    read FOnDocumentRecordsLoadingFailedEventHandler
    write FOnDocumentRecordsLoadingFailedEventHandler;

    property OnDocumentRecordsLoadingCanceledEventHandler:
      TOnDocumentRecordsLoadingCanceledEventHandler
    read FOnDocumentRecordsLoadingCanceledEventHandler
    write FOnDocumentRecordsLoadingCanceledEventHandler;

    property OnDocumentDeletingRequestedEventHandler:
      TOnDocumentDeletingRequestedEventHandler
    read FOnDocumentDeletingRequestedEventHandler
    write FOnDocumentDeletingRequestedEventHandler;

    property OnDocumentRecordDeletedEventHandler:
      TOnDocumentRecordDeletedEventHandler
    read FOnDocumentRecordDeletedEventHandler
    write FOnDocumentRecordDeletedEventHandler;

    property OnDocumentRecordsRefreshRequestedEventHandler:
      TOnDocumentRecordsRefreshRequestedEventHandler
    read FOnDocumentRecordsRefreshRequestedEventHandler
    write FOnDocumentRecordsRefreshRequestedEventHandler;

    property OnDocumentRecordsRefreshedEventHandler:
      TOnDocumentRecordsRefreshedEventHandler

    read FOnDocumentRecordsRefreshedEventHandler
    write FOnDocumentRecordsRefreshedEventHandler;

    property OnDocumentRecordChangingRequestedEventHandler:
      TOnDocumentRecordChangingRequestedEventHandler
    read FOnDocumentRecordChangingRequestedEventHandler
    write FOnDocumentRecordChangingRequestedEventHandler;

    property OnDocumentCardRefreshRequestedEventHandler:
      TOnDocumentCardRefreshRequestedEventHandler
    read FOnDocumentCardRefreshRequestedEventHandler
    write FOnDocumentCardRefreshRequestedEventHandler;
    
  end;

  TBaseDocumentsReferenceFormClass = class of TBaseDocumentsReferenceForm;

implementation

{$R *.dfm}

uses

  StrUtils,
  DocumentViewingAccountingService,
  ApplicationServiceRegistries,
  DocumentKindWorkCycleInfoAppService,
  EmployeeDocumentSetReadService,
  AuxDebugFunctionsUnit,
  WorkingEmployeeUnit,
  SelectDocumentRecordsViewQueries,
  cxGridDBDataDefinitions,
  AbstractDataSetHolder;

{ TEmployeeDocumentsDBTableForm }

procedure TBaseDocumentsReferenceForm.RaiseOnDocumentDeletingRequestedEventHandler;
var DocumentId: Variant;
begin

  DocumentId :=
    DataRecordGridTableView.
      Controller.FocusedRecord.Values[IdColumn.Index];

  if Assigned(FOnDocumentDeletingRequestedEventHandler) then
    FOnDocumentDeletingRequestedEventHandler(Self, DocumentId);

end;

procedure TBaseDocumentsReferenceForm.RaiseOnDocumentRecordDeletedEventHandler;
begin

  if Assigned(FOnDocumentRecordDeletedEventHandler) then
    FOnDocumentRecordDeletedEventHandler(Self);
  
end;

procedure TBaseDocumentsReferenceForm.RaiseOnSelectedDocumentRecordChangedEventHandler;
begin

  FOnSelectedDocumentRecordChangedEventHandler(Self);
  
end;

procedure TBaseDocumentsReferenceForm.
  RaiseOnSelectedDocumentRecordChangingEventHandler;
begin

  FOnSelectedDocumentRecordChangingEventHandler(Self);

end;

function TBaseDocumentsReferenceForm.
  ResolveUIDocumentKindFromCurrentRecord: TUIDocumentKindClass;
begin

  Result :=
    ResolveUIDocumentKindFromGridRecord(
      DataRecordGridTableView.Controller.FocusedRecord
    );
    
end;

function TBaseDocumentsReferenceForm.ResolveUIDocumentKindFromGridRecord(
  const GridRecord: TcxCustomGridRecord): TUIDocumentKindClass;
begin

  Result :=
    FUIDocumentKindResolver.ResolveUIDocumentKindFromId(
      GetDocumentKindIdFromGridRecord(GridRecord)
    );

end;

procedure TBaseDocumentsReferenceForm.actRefreshDataExecute(
  Sender: TObject);
begin

  FIsDocumentRecordsRefreshRequested := True;

  inherited;

end;

procedure TBaseDocumentsReferenceForm.actRefreshDocumentCardExecute(
  Sender: TObject);
begin

  if not HasDataSetRecords then Exit;

  if Assigned(FOnDocumentCardRefreshRequestedEventHandler) then begin

    FOnDocumentCardRefreshRequestedEventHandler(
      Self,
      DocumentSetHolder.DocumentIdFieldValue,
      DocumentSetHolder.KindIdFieldValue
    );

  end;

end;

procedure TBaseDocumentsReferenceForm.AddNewDocumentRecord(
  DocumentRecordViewModel: TDocumentRecordViewModel);
begin

  DocumentSetHolder.DisableControls;

  try

    DocumentSetHolder.Append;

    FDocumentsReferenceFormProcessor.FillDocumentSetRecordByViewModel(
      DocumentSetHolder, DocumentRecordViewModel
    );

    DocumentSetHolder.Post;

    SelectCurrentDataRecord;
    UpdateLayout;

  finally

    DocumentSetHolder.EnableControls;

  end;
  
end;

function TBaseDocumentsReferenceForm.AreAllChargePerformed(
  const TotalChargeCount, PerformedChargeCount: Integer): boolean;
begin

  Result := TotalChargeCount = PerformedChargeCount;
  
end;

procedure TBaseDocumentsReferenceForm.
  ChangeCurrentDocumentChargesWorkStatisticsRecordCell(
    EmployeeDocumentChargesWorkStatistics:
      TEmployeeDocumentChargesWorkStatistics
  );
begin
                              
  ChangeDocumentChargesWorkStatisticsRecordCell(
    GetCurrentDocumentRecordId,
    EmployeeDocumentChargesWorkStatistics
  );
  
end;

{ refactor: remove after updating single record functional }
procedure TBaseDocumentsReferenceForm.
  ChangeDocumentChargesWorkStatisticsRecordCell(
    const DocumentId: Variant;
    EmployeeDocumentChargesWorkStatistics:
      TEmployeeDocumentChargesWorkStatistics
  );
var PreviousFocusedRecordPointer: Pointer;
begin

  PreviousFocusedRecordPointer := nil;

  with DataRecordGridTableView do begin

    BeginUpdate;

    try

      if GetCurrentDocumentRecordId <> DocumentId then begin

        PreviousFocusedRecordPointer := DocumentSetHolder.GetBookmark;

        LocateRecordById(DocumentId);
        
      end;

      OnDocumentChargeWorkStatisticsRecordCellChanging(
        DataRecordGridTableView.DataController.FindRecordIndexByKey(DocumentId),
        EmployeeDocumentChargesWorkStatistics.TotalChargeCount,
        EmployeeDocumentChargesWorkStatistics.PerformedChargeCount
      );

    finally

      try

        DocumentSetHolder.GotoBookmarkAndFree(PreviousFocusedRecordPointer);

      finally

        EndUpdate;

      end;

    end;

  end;

end;

procedure TBaseDocumentsReferenceForm.
  ChangeFocusedDocumentRecordByViewModel(
    DocumentRecordViewModel: TDocumentRecordViewModel
  );
var FocusedRecord: TcxCustomGridRecord;
begin

  FocusedRecord := DataRecordGridTableView.Controller.FocusedRecord;

  if not Assigned(FocusedRecord) then Exit;

  ChangeDocumentRecordByViewModel(DocumentRecordViewModel);

end;

procedure TBaseDocumentsReferenceForm.
  ChangeDocumentRecordByViewModel(
    DocumentRecordViewModel: TDocumentRecordViewModel
  );
var RecordIndex: Integer;
    PreviousFocusedRecordPointer: Pointer;
begin

  if VarIsNull(DocumentRecordViewModel.DocumentId) then Exit;

  PreviousFocusedRecordPointer := DataSet.GetBookmark;

  try

    DocumentSetHolder.DisableControls;
    
    if GetCurrentRecordKeyValue <> DocumentRecordViewModel.DocumentId
    then begin

      LocateRecord(
        DataRecordGridTableView.DataController.KeyFieldNames,
        DocumentRecordViewModel.DocumentId
      );

    end;

    FDocumentsReferenceFormProcessor.FillDocumentSetRecordByViewModel(
      DocumentSetHolder, DocumentRecordViewModel
    );

    SelectCurrentDataRecord;
    UpdateLayout;

  finally

    try

      DocumentSetHolder.GotoBookmarkAndFree(PreviousFocusedRecordPointer);

    finally

      DocumentSetHolder.EnableControls;

    end;

  end;

end;

function TBaseDocumentsReferenceForm.CreateFocusedDocumentRecordViewModel: TDocumentRecordViewModel;
begin

  Result :=
    CreateDocumentRecordViewModelFromGridRecord(
      DataRecordGridTableView.Controller.FocusedRecord
    );

end;

function TBaseDocumentsReferenceForm.CreateDocumentRecordViewModelFromGridRecord(
  const GridRecord: TcxCustomGridRecord
): TDocumentRecordViewModel;
begin

  Result :=
    FDocumentsReferenceFormProcessor
      .CreateDocumentRecordViewModelFromGridRecord(Self, GridRecord);

end;

function TBaseDocumentsReferenceForm.CompareColumnCellValues(
  const FirstCellValue, SecondCellValue: Variant;
  const FieldName: String
): Integer;
begin

  Result :=

    ViewModel.DocumentTableViewModel.ColumnCellComparator.Compare(
      FirstCellValue, SecondCellValue, FieldName
    );

end;

function TBaseDocumentsReferenceForm.OnChangeRecord: Boolean;
begin

  if Assigned(FOnDocumentRecordChangingRequestedEventHandler) then
  begin

    FOnDocumentRecordChangingRequestedEventHandler(
      Self,
      CreateFocusedDocumentRecordViewModel
    );

  end;

end;

procedure TBaseDocumentsReferenceForm.OnRefreshRecords;
var
    UpdatedViewModel: TDocumentsReferenceViewModel;
begin

  GetSelectedWorkCycleStageNames;

  if Assigned(FOnDocumentRecordsRefreshRequestedEventHandler) then begin

    UpdatedViewModel := nil;

    FOnDocumentRecordsRefreshRequestedEventHandler(Self, ViewModel, UpdatedViewModel);

    if Assigned(UpdatedViewModel) then

      ViewModel := UpdatedViewModel;

    FIsFilterFormLastStateApplyingRequested := True;

  end;

  inherited OnRefreshRecords;

end;

function TBaseDocumentsReferenceForm.OnDeleteCurrentRecord: Boolean;
begin

  RaiseOnDocumentDeletingRequestedEventHandler;

  Result := inherited OnDeleteCurrentRecord;

  RaiseOnDocumentRecordDeletedEventHandler;

end;

constructor TBaseDocumentsReferenceForm.Create(
  DocumentsReferenceFormProcessor: IDocumentsReferenceFormProcessor;
  Owner: TComponent
);
begin

  inherited Create(Owner);

  FDocumentsReferenceFormProcessor := DocumentsReferenceFormProcessor;
  
end;

procedure TBaseDocumentsReferenceForm.CustomizeNewDocumentCardForm(
  NewDocumentCardForm: TDocumentCardForm
);
begin

  NewDocumentCardForm.DeleteOnClose := True;
  NewDocumentCardForm.Position := poMainFormCenter;
  NewDocumentCardForm.FormStyle := fsStayOnTop;
  NewDocumentCardForm.OnCloseFormChangedDocumentDataSaveMessage :=
    'В открытой карточке обнаружены изменения. ' +
    'Создать документ перед закрытием карточки ?';

end;

procedure TBaseDocumentsReferenceForm.CustomizeTableViewFilterForm(
  ATableViewFilterForm: TTableViewFilterForm);
begin

  inherited;

  with ATableViewFilterForm as TBaseDocumentsReferenceFilterForm do begin

    DocumentWorkCycleStageNames :=
      ViewModel.DocumentTableViewModel.FilterDocumentWorkCycleStageNames;

    SelectedDocumentWorkCycleStageNames :=
      GetSelectedDocumentWorkCycleStageNames;

  end;

end;

procedure TBaseDocumentsReferenceForm.DataOperationToolBarAdvancedCustomDrawButton(
  Sender: TToolBar; Button: TToolButton; State: TCustomDrawState;
  Stage: TCustomDrawStage; var Flags: TTBCustomDrawFlags;
  var DefaultDraw: Boolean);
begin

  inherited DataOperationToolBarAdvancedCustomDrawButton(
    Sender, Button, State, Stage, Flags, DefaultDraw
  );

end;

procedure TBaseDocumentsReferenceForm.
  DataRecordGridTableViewCustomDrawCell(
    Sender: TcxCustomGridTableView;
    ACanvas: TcxCanvas;
    AViewInfo: TcxGridTableDataCellViewInfo;
    var ADone: Boolean
  );
begin

  if AViewInfo.GridRecord.Selected then begin

    inherited;

    HighlightDocumentRecordCellTexts(ACanvas, AViewInfo.GridRecord);

  end

  else if not HighlightDocumentRecordWith(ACanvas, AViewInfo.GridRecord)

  then inherited;

end;

procedure TBaseDocumentsReferenceForm.DataRecordGridTableViewDataControllerCompare(
  ADataController: TcxCustomDataController;
  ARecordIndex1, ARecordIndex2, AItemIndex: Integer;
  const V1, V2: Variant;
  var Compare: Integer);
var GridDBDataController: TcxGridDBDataController;
begin

  inherited;

  Compare :=
  
    CompareColumnCellValues(
      V1,
      V2,
      DataRecordGridTableView.Columns[AItemIndex].DataBinding.FieldName
    );

end;

procedure TBaseDocumentsReferenceForm.DataRecordGridTableViewFocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
var
    PreviousFocusedRecordViewModel: TDocumentRecordViewModel;
    FocusedRecordViewModel: TDocumentRecordViewModel;
    RequestedFocuseableDocumentId: Variant;
begin

  inherited DataRecordGridTableViewFocusedRecordChanged(
    Sender, APrevFocusedRecord, AFocusedRecord, ANewItemRecordFocusingChanged
  );

  if not VarIsNull(FRequestedFocuseableDocumentId) then begin

    RequestedFocuseableDocumentId := FRequestedFocuseableDocumentId;

    FRequestedFocuseableDocumentId := Null;

    LocateRecordById(RequestedFocuseableDocumentId);

    Exit;
    
  end;

  PreviousFocusedRecordViewModel := nil;                        
  FocusedRecordViewModel := nil;

  SetDocumentRemoveToolVisibleForGridRecord(AFocusedRecord);

  try

    PreviousFocusedRecordViewModel :=
      CreateDocumentRecordViewModelFromGridRecord(APrevFocusedRecord);

    FocusedRecordViewModel :=
      CreateDocumentRecordViewModelFromGridRecord(AFocusedRecord);


    RaiseOnDocumentRecordFocusedEventHandler(
      PreviousFocusedRecordViewModel, FocusedRecordViewModel
    );

    if Assigned(AFocusedRecord) then
      FDocumentsReferenceFormProcessor.OnDocumentRecordFocused(Self);
    
  finally

    FreeAndNil(PreviousFocusedRecordViewModel);
    FreeAndNil(FocusedRecordViewModel);

  end;

end;

procedure TBaseDocumentsReferenceForm.DataRecordGridTableViewGetStoredPropertyValue(
  Sender: TcxCustomGridView; const AName: string; var AValue: Variant);
begin

  inherited;
   //
end;

destructor TBaseDocumentsReferenceForm.Destroy;
begin

  //FreeAndNil(FDocumentRecordViewModelMapper);

  FreeAndNil(FSelectedWorkStageNames);
  
  inherited;

end;

function TBaseDocumentsReferenceForm.
  DocumentKindWorkCycleColors: TDocumentKindWorkCycleColors;
begin

  if
    not Assigned(ViewModel)
    or not Assigned(ViewModel.DocumentTableViewModel)
    or not Assigned(ViewModel.DocumentKindWorkCycleColors)
  then
    Result := nil

  else
    Result := ViewModel.DocumentKindWorkCycleColors;
  
end;

function TBaseDocumentsReferenceForm.
  DocumentSetHolder: TDocumentSetHolder;
begin

  if
    not Assigned(ViewModel)
    or not Assigned(ViewModel.DocumentTableViewModel)
    or not Assigned(ViewModel.DocumentTableViewModel.DocumentSetHolder)
  then
    Result := nil

  else
    Result := ViewModel.DocumentTableViewModel.DocumentSetHolder;

end;

procedure TBaseDocumentsReferenceForm.FillControlsByViewModel(
  ViewModel: TDocumentsReferenceViewModel);
begin

  SetTableColumnLayoutFrom(
    ViewModel.DocumentTableViewModel.DocumentSetHolder.FieldDefs
  );

  DataSet := ViewModel.DocumentTableViewModel.DocumentSetHolder.DataSet;

  UpdateDocumentToolButtonsVisibilityBy(ViewModel.DocumentTableViewModel.DocumentSetHolder);

  FillDocumentWorkCycleStagesPopupMenuByViewModel(ViewModel);

end;

procedure TBaseDocumentsReferenceForm.FillDocumentWorkCycleStagesPopupMenuByViewModel(
  ViewModel: TDocumentsReferenceViewModel);
var
  MenuItem: TMenuItem;
  I: Integer;
begin

  DocumentWorkCycleStageNamesPopupMenu.Items.Clear;

  for I := 0 to ViewModel.DocumentTableViewModel.FilterDocumentWorkCycleStageNames.Count - 1 do
  begin
    MenuItem := TMenuItem.Create(DocumentWorkCycleStageNamesPopupMenu);
    MenuItem.Caption := ViewModel.DocumentTableViewModel.FilterDocumentWorkCycleStageNames[I];
    MenuItem.OnClick := OnDocumentWorkCycleStagesClick;
    MenuItem.Checked := (ViewModel.SelectedDocumentWorkCycleStageNames.IndexOf(MenuItem.Caption) >= 0);

    DocumentWorkCycleStageNamesPopupMenu.Items.Add(MenuItem);
  end;

end;

procedure TBaseDocumentsReferenceForm.UpdateDataOperationControls;
begin

  inherited;

  actRefreshDocumentCard.Enabled := HasDataSetRecords;
  RefreshDocumentCardToolButton.Enabled := HasDataSetRecords;
    
end;

procedure TBaseDocumentsReferenceForm.UpdateDocumentToolButtonsVisibilityBy(
  DocumentSetHolder: TDocumentSetHolder);
begin

  with DocumentSetHolder do begin

    actAddData.Visible := AddingAllowed;
    actChangeData.Visible := True;
    actDeleteData.Visible := RemovingAllowed;

  end;

end;

procedure TBaseDocumentsReferenceForm.UpdateUISelectedDocumentWorkCycleStages;
var
  MenuItem: TMenuItem;
  I: Integer;
begin

  for I := 0 to DocumentWorkCycleStageNamesPopupMenu.Items.Count - 1 do
  begin
    DocumentWorkCycleStageNamesPopupMenu.Items[I].Checked :=
      (FSelectedWorkStageNames.IndexOf(DocumentWorkCycleStageNamesPopupMenu.Items[I].Caption) >= 0);
  end;
//  GetSelectedWorkCycleStageNames;

end;


procedure TBaseDocumentsReferenceForm.FormShow(Sender: TObject);
begin

  inherited;

  Font := Application.MainForm.Font;
  
end;

function TBaseDocumentsReferenceForm.GetCurrentDocumentRecordId: Variant;
begin

  Result := GetCurrentRecordKeyValue;
  
end;

function TBaseDocumentsReferenceForm.GetDocumentChargeSheetPerformingStatusColor(
  GridRecord: TcxCustomGridRecord): TColor;
var

  AllSubordinateChargeSheetsPerformed: Variant;
  AllChargeSheetsPerformed: Variant;

  DocumentKind: TUIDocumentKindClass;
begin

  AllChargeSheetsPerformed :=
    GridRecord.Values[AllChargeSheetsPerformedColumn.Index];

  if VarIsNull(AllChargeSheetsPerformed) then begin

    Result := clDefault;
    Exit;

  end;

  AllSubordinateChargeSheetsPerformed :=
    GridRecord.Values[AllSubordinateChargeSheetsPerformedColumn.Index];

  DocumentKind := ResolveUIDocumentKindFromGridRecord(GridRecord);

  if not VarIsNull(AllSubordinateChargeSheetsPerformed) and
     AllSubordinateChargeSheetsPerformed and
     not AllChargeSheetsPerformed
  then begin

    Result :=
      DocumentKindWorkCycleColors
        .GetDocumentKindPerformedSubordinateChargeSheetsColor(DocumentKind);

  end

  else if AllChargeSheetsPerformed then begin

    Result :=
      DocumentKindWorkCycleColors
        .GetDocumentKindPerformedChargeSheetsColor(DocumentKind);

  end

  else begin

    Result :=
      DocumentKindWorkCycleColors
        .GetDocumentKindNotPerformedChargeSheetsColor(DocumentKind);

  end;

end;

function TBaseDocumentsReferenceForm.GetDocumentKindIdFromCurrentRecord: Variant;
begin

  Result :=
    GetDocumentKindIdFromGridRecord(
      DataRecordGridTableView.Controller.FocusedRecord
    );

end;

function TBaseDocumentsReferenceForm.GetDocumentKindIdFromGridRecord(
  const GridRecord: TcxCustomGridRecord): Variant;
begin

  Result := GetRecordCellValue(GridRecord, DocumentTypeIdColumn.Index);
  
end;

function TBaseDocumentsReferenceForm.GetDocumentRecordColor(
  GridRecord: TcxCustomGridRecord
): TColor;
var
    DocumentWorkCycleStageName: String;
begin

  Result := GetDocumentChargeSheetPerformingStatusColor(GridRecord);

  if Result = clDefault then  begin

    DocumentWorkCycleStageName :=
      GetRecordCellValue(GridRecord, CurrentWorkCycleStageNameColumn.Index);

    Result :=
      ViewModel
        .DocumentKindWorkCycleColors
          .GetDocumentKindWorkCycleStageColor(
            ResolveUIDocumentKindFromGridRecord(GridRecord),
            DocumentWorkCycleStageName
          );

  end;

end;

function TBaseDocumentsReferenceForm.GetDocumentRecordViewModel(
  const DocumentId: Variant
): TDocumentRecordViewModel;

begin

  Result :=
    FDocumentsReferenceFormProcessor.CreateDocumentRecordViewModelFrom(
      DocumentSetHolder, DocumentId
    );

end;

function TBaseDocumentsReferenceForm.GetDocumentWorkCycleStageNumberFromCurrentRecord: Variant;
begin

  if not Assigned(DataRecordGridTableView.Controller.FocusedRecord) then
    Result := Null

  else
    Result :=
      DataRecordGridTableView.Controller.FocusedRecord.Values[CurrentWorkCycleStageNumberColumn.Index];

end;

function TBaseDocumentsReferenceForm.GetMessageAboutThatUserAssuredThatWantDeleteSelectedRecords: String;
begin

  Result := 'Вы уверены, что хотите удалить выбранные документы ?';

end;

function TBaseDocumentsReferenceForm.GetSelectedDocumentWorkCycleStageNames: TStrings;
var
  MenuItem: TMenuItem;
begin
  Result := TStringList.Create;

  for MenuItem in DocumentWorkCycleStageNamesPopupMenu.Items do
  begin
    if MenuItem.Checked then
      Result.Add(MenuItem.Caption);
  end;

end;

function TBaseDocumentsReferenceForm.GetSelectedWorkCycleStageNames: TStrings;
var
  MenuItem: TMenuItem;
begin

  if not Assigned(FSelectedWorkStageNames) then
    FSelectedWorkStageNames := TStringList.Create;
    
//  заполняем список выбранных статусов из меню(если это меню еще существует и не пустое)
  if Assigned(DocumentWorkCycleStageNamesPopupMenu) and
    (DocumentWorkCycleStageNamesPopupMenu.Items.Count > 0) then
  begin

    FSelectedWorkStageNames.Clear;

    for MenuItem in DocumentWorkCycleStageNamesPopupMenu.Items do
    begin
      if MenuItem.Checked then
        FSelectedWorkStageNames.Add(MenuItem.Caption);
    end;
  end;

  Result := FSelectedWorkStageNames;

end;

function TBaseDocumentsReferenceForm.GetSelf: TObject;
begin

  Result := Self;
  
end;

class function TBaseDocumentsReferenceForm.GetTableViewFilterFormClass: TTableViewFilterFormClass;
begin

  Result := TBaseDocumentsReferenceFilterForm;

end;

function TBaseDocumentsReferenceForm.GetViewModel: TDocumentsReferenceViewModel;
begin

  Result := FViewModel;

  if not Assigned(Result) then Exit;

  Result.SelectedDocumentWorkCycleStageNames :=
    GetSelectedDocumentWorkCycleStageNames;

  { Сделать актуальной модель, обновив SelectedDocumentKindWorkCycleStageInfoDtos }

end;

procedure TBaseDocumentsReferenceForm.HighlightDocumentRecordCellTexts(
  Canvas: TcxCanvas; GridRecord: TcxCustomGridRecord);
var DocumentColor: TColor;
begin

  DocumentColor := GetDocumentRecordColor(GridRecord);

  if DocumentColor = clDefault then begin

    if GridRecord.Selected then
      DocumentColor := SelectedRecordsTextColor

    else if GridRecord.Focused then
      DocumentColor := FocusedCellTextColor

  end;

  Canvas.Font.Color := DocumentColor;

end;

function TBaseDocumentsReferenceForm.HighlightDocumentRecordWith(
  Canvas: TcxCanvas; GridRecord: TcxCustomGridRecord): Boolean;
var DocumentRecordColor: TColor;
begin

  DocumentRecordColor := GetDocumentRecordColor(GridRecord);

  if DocumentRecordColor <> clDefault then begin

    Canvas.Brush.Color := DocumentRecordColor;

    Result := True;

  end

  else Result := False;

end;

procedure TBaseDocumentsReferenceForm.Init(
  const Caption: String;
  ADataSet: TDataSet
);
begin

  inherited Init(Caption, ADataSet);

  actChangeData.Visible := True;

  FRequestedFocuseableDocumentId := Null;
  
end;

procedure TBaseDocumentsReferenceForm.OnDataLoadingCancelledHandle(
  Sender: TObject; const IsDestroyingRequested: Boolean);
begin

  inherited;

  if IsDestroyingRequested then Exit;

  if Assigned(FOnDocumentRecordsLoadingCanceledEventHandler) then
    FOnDocumentRecordsLoadingCanceledEventHandler(Self);
    
end;

procedure TBaseDocumentsReferenceForm.OnDataLoadingErrorOccurredHandle(
  Sender: TObject;
  DataSet: TDataSet;
  const Error: Exception;
  RelatedState: TObject;
  const IsDestroyingRequested: Boolean
);
begin

  inherited;

  if IsDestroyingRequested then Exit;

  if Assigned(FOnDocumentRecordsLoadingFailedEventHandler) then
    FOnDocumentRecordsLoadingFailedEventHandler(Self, Error);

end;

procedure TBaseDocumentsReferenceForm.OnDataLoadingSuccessHandle(
  Sender: TObject;
  DataSet: TDataSet;
  RelatedState: TObject;
  const IsDestroyingRequested: Boolean
);
begin

  inherited OnDataLoadingSuccessHandle(Sender, DataSet, RelatedState, IsDestroyingRequested);

  if IsDestroyingRequested then Exit;
  
  if FIsDocumentRecordsRefreshRequested then begin
    
    FIsDocumentRecordsRefreshRequested := False;

    if Assigned(FOnDocumentRecordsRefreshedEventHandler) then
      FOnDocumentRecordsRefreshedEventHandler(Self);
    
  end;

  if Assigned(FOnDocumentRecordsLoadingSuccessEventHandler) then
    FOnDocumentRecordsLoadingSuccessEventHandler(Self);

  SelectCurrentDataRecord;
  UpdateLayout;

end;

{ refactor: удалить после рефакторинга }
procedure TBaseDocumentsReferenceForm.
  OnDocumentChargeWorkStatisticsRecordCellChanging(
    const RecordIndex: Integer;
    const TotalChargeCount, PerformedChargeCount: Integer
  );
begin

  if
    (RecordIndex < 0) or
    not Assigned(
      DataSet.Fields.FindField(
        DocumentSetHolder.ChargePerformingStatisticsFieldName
      )
    )
  then Exit;

  with DocumentSetHolder do begin

    if AreAllChargePerformed(TotalChargeCount, PerformedChargeCount) then
      ChargePerformingStatisticsFieldValue := ''

    else begin

      ChargePerformingStatisticsFieldValue :=

        IntToStr(PerformedChargeCount)
        +
        ' из '
        +
        IntToStr(TotalChargeCount);

    end;

  end;

end;

procedure TBaseDocumentsReferenceForm.OnDocumentInfoSavingRequestedEventHandler(
  Sender: TObject);
var 
    NewDocumentCardFrame: TDocumentCardFrame;
begin

  NewDocumentCardFrame := Sender as TDocumentCardFrame;

  if RaiseOnNewDocumentCreatingConfirmedEventHandler(NewDocumentCardFrame) then
    RaiseOnNewDocumentCreatingFinishedEventHandler(NewDocumentCardFrame);
  
end;

procedure TBaseDocumentsReferenceForm.OnDocumentWorkCycleStagesClick(
  Sender: TObject);
begin

  (Sender as TMenuItem).Checked := not (Sender as TMenuItem).Checked;

  DocumentWorkCycleStageNamesPopupMenu.Popup(
    DocumentWorkCycleStageNamesPopupMenu.PopupPoint.X,
    DocumentWorkCycleStageNamesPopupMenu.PopupPoint.Y
  );

end;

procedure TBaseDocumentsReferenceForm.RaiseOnDocumentRecordFocusedEventHandler(
  PreviousFocusedDocumentRecordViewModel,
  FocusedDocumenRecordViewModel: TDocumentRecordViewModel);
begin

  if Assigned(FOnDocumentRecordFocusedEventHandler) then begin

    FOnDocumentRecordFocusedEventHandler(
      Self,
      PreviousFocusedDocumentRecordViewModel,
      FocusedDocumenRecordViewModel
    );

  end;

end;

function TBaseDocumentsReferenceForm.RaiseOnNewDocumentCreatingConfirmedEventHandler(
  NewDocumentCardFrame: TDocumentCardFrame
): Boolean;
var
    NewDocumentCardForm: TDocumentCardForm;
begin

  if not Assigned(FOnNewDocumentCreatingConfirmedEventHandler) then begin

    raise Exception.Create(
      'Не задан обработчик запроса ' +
      'подтверждения внесения изменений ' +
      'в карточку документа'
    );

  end;

  try

    Screen.Cursor := crHourGlass;
    
    FOnNewDocumentCreatingConfirmedEventHandler(
      Self, NewDocumentCardFrame
    );

    NewDocumentCardForm := NewDocumentCardFrame.Parent as TDocumentCardForm;

    NewDocumentCardForm.Close;

    Result := True;
    
  finally

    Screen.Cursor := crDefault;
        
  end;
  
end;

procedure TBaseDocumentsReferenceForm.RaiseOnNewDocumentCreatingFinishedEventHandler(
  DocumentCardFrame: TDocumentCardFrame);
begin

  if Assigned(FOnNewDocumentCreatingFinishedEventHandler) then
    FOnNewDocumentCreatingFinishedEventHandler(Self, DocumentCardFrame);
    
end;

function TBaseDocumentsReferenceForm.
  SelectedDocumentRecordViewModels: TDocumentRecordViewModels;
var
    I: Integer;
begin

  Result := TDocumentRecordViewModels.Create;

  try

    with DataRecordGridTableView.Controller do begin

      for I := 0 to SelectedRecordCount - 1 do begin

        Result.Add(
          CreateDocumentRecordViewModelFromGridRecord(SelectedRecords[I])
        );

      end;

    end;

  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;

end;

procedure TBaseDocumentsReferenceForm.SetActivatedDataOperationControls(
  const Activated: Boolean);
begin

  inherited SetActivatedDataOperationControls(Activated);

  SetEnabledToActionTools(Activated, [actRefreshDocumentCard]);
  RefreshDocumentCardToolButton.Enabled := Activated;

end;

procedure TBaseDocumentsReferenceForm.
  SetDocumentRemoveToolVisibleForGridRecord(GridRecord: TcxCustomGridRecord);
var DocumentCanBeRemovedVariant: Variant;
begin

  if not Assigned(GridRecord) then Exit;

  DocumentCanBeRemovedVariant := GetRecordCellValue(GridRecord, CanBeRemovedColumn.Index);

  actDeleteData.Visible :=
    (not VarIsNull(DocumentCanBeRemovedVariant)) and DocumentCanBeRemovedVariant;
    
end;

procedure TBaseDocumentsReferenceForm.SetSelectedWorkCycleStageNames(
  const Value: TStrings);
var
  MenuItem: TMenuItem;
  I: Integer;
begin
  FreeAndNil(FSelectedWorkStageNames);

  FSelectedWorkStageNames := Value;

  UpdateUISelectedDocumentWorkCycleStages;

end;

procedure TBaseDocumentsReferenceForm.SetTableColumnLayoutFrom(
  FieldDefs: TDocumentSetFieldDefs
);
begin

  FDocumentsReferenceFormProcessor.SetDocumentReferenceFormColumns(Self, FieldDefs);

end;

procedure TBaseDocumentsReferenceForm.SetViewModel(
  const Value: TDocumentsReferenceViewModel);
begin

//  FillControlsByViewModel(Value);

  FreeAndNil(FViewModel);

  FViewModel := Value;

//  получив список статусов из ini-файла,
//  объединяем список выбранных статусов в форме и модели(они могут различаться и вполне возможно содержать статусы,
//    которых нет у данного типа документа),

  FViewModel.SelectedDocumentWorkCycleStageNames.AddStrings(FSelectedWorkStageNames);
//  а потом обновляем форму из модели
  FillControlsByViewModel(FViewModel);

//  актуализируем список выбранных статусов в форме
  GetSelectedWorkCycleStageNames;

  SaveUIControlProperties;

end;

procedure TBaseDocumentsReferenceForm.Show;
begin

  inherited;

end;

procedure TBaseDocumentsReferenceForm.Show(
  const FocuseableDocumentId: Variant
);
begin

  inherited Show;

  FRequestedFocuseableDocumentId := FocuseableDocumentId;
  
end;

function TBaseDocumentsReferenceForm.OnAddRecord: Boolean;
var DocumentCardFrame: TDocumentCardFrame;
    DocumentCardForm: TDocumentCardForm;
begin

  if not Assigned(FOnNewDocumentCreatingRequestedEventHandler) then begin

    raise Exception.Create(
      'Не задан обработчик запроса ' +
      'документа'
    );

  end;

  try

    { refactor: вынести в контроллер карточки (создать если его нет)
      логику создания карточки для нового док-а и отображения }
    
    Screen.Cursor := crHourGlass;

    FOnNewDocumentCreatingRequestedEventHandler(
      Self, DocumentCardFrame
    );

    Screen.Cursor := crDefault;

    DocumentCardForm := TDocumentCardForm.Create(DocumentCardFrame, Self);

    CustomizeNewDocumentCardForm(DocumentCardForm);

    DocumentCardFrame.OnDocumentInfoSavingRequestedEventHandler :=
      OnDocumentInfoSavingRequestedEventHandler;

    DocumentCardForm.ShowModal;

  finally

    Screen.Cursor := crDefault;

  end;

end;

end.
