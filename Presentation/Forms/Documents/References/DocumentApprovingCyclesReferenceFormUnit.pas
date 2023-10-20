unit DocumentApprovingCyclesReferenceFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, cxControls, cxStyles, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, ActnList, ImgList, PngImageList,
  cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, cxButtons, ComCtrls, pngimage,
  ExtCtrls, StdCtrls, ToolWin, EmployeesReferenceFormUnit,
  DocumentApprovingCycleSetHolder, DocumentApprovingCycleViewModel, cxLocalization,
  DocumentFlowBaseReferenceFormUnit, cxCheckBox;

type

  TOnDocumentApprovingCompletingRequestedEventHandler =
    procedure (
      Sender: TObject;
      CycleViewModel: TDocumentApprovingCycleViewModel
    ) of object;

  TOnNewDocumentApprovingCycleCreatingRequestedEventHandler =
    procedure (
      Sender: TObject;
      var NewDocumentApprovingCycleViewModel: TDocumentApprovingCycleViewModel
    ) of object;

  TOnDocumentApprovingCycleRemovingRequestedEventHandler =
    procedure (
      Sender: TObject;
      CycleViewModel: TDocumentApprovingCycleViewModel
    ) of object;

  TOnDocumentApprovingCycleSelectedEventHandler =
    procedure (
      Sender: TObject;
      SelectedCycleViewModel: TDocumentApprovingCycleViewModel
    ) of object;

  TOnNewDocumentApprovingCycleInfoAddedEventHandler =
    procedure (
      Sender: TObject;
      NewDocumentApprovingCycleViewModel: TDocumentApprovingCycleViewModel
    ) of object;

  TOnDocumentApprovingCycleRemovedEventHandler =
    procedure (
      Sender: TObject;
      RemovedDocumentApprovingCycleViewModel: TDocumentApprovingCycleViewModel
    ) of object;

  TDocumentApprovingCyclesReferenceForm = class(TDocumentFlowBaseReferenceForm)
      actCompleteApproving: TAction;
      DocumentApprovingsDetailTableView: TcxGridDBTableView;
    ApprovingCycleNumberColumn: TcxGridDBColumn;
    PerformerSpecialityColumn: TcxGridDBColumn;
    PerformerNameColumn: TcxGridDBColumn;
    PerformingDateColumn: TcxGridDBColumn;
    NoteColumn: TcxGridDBColumn;
    IsViewedByPerformerColumn: TcxGridDBColumn;
    IdColumn: TcxGridDBColumn;
    PerformerIdColumn: TcxGridDBColumn;
    PerformerDepartmentNameColumn: TcxGridDBColumn;
    PerformingResultIdColumn: TcxGridDBColumn;
    PerformingResultColumn: TcxGridDBColumn;
    ActualPerformerIdColumn: TcxGridDBColumn;
    ActualPerformerNameColumn: TcxGridDBColumn;
    DocumentApprovingCycleNumberColumn: TcxGridDBColumn;
    ApprovingCycleNameColumn: TcxGridDBColumn;
    ApprovingCycleIdColumn: TcxGridDBColumn;
    ApprovingCycleIsNewColumn: TcxGridDBColumn;
    CanBeChangedColumn: TcxGridDBColumn;
    CanBeRemovedColumn: TcxGridDBColumn;
    CanBeCompletedColumn: TcxGridDBColumn;
    procedure actCompleteApprovingExecute(Sender: TObject);
    procedure DataRecordGridTableViewFocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure actDeleteDataExecute(Sender: TObject);
    procedure DataRecordGridTableViewCustomDrawCell(
      Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
      AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
      { Private declarations }

    protected

      FDocumentApprovingCycleSetHolder:
        TDocumentApprovingCycleSetHolder;

      function DocumentApprovingCycleSet: TDataSet;
      
    protected

      FOnDocumentApprovingCycleRemovingRequestedEventHandler:
        TOnDocumentApprovingCycleRemovingRequestedEventHandler;

      FOnDocumentApprovingCycleSelectedEventHandler:
        TOnDocumentApprovingCycleSelectedEventHandler;

      FOnNewDocumentApprovingCycleCreatingRequestedEventHandler:
        TOnNewDocumentApprovingCycleCreatingRequestedEventHandler;

      FOnNewDocumentApprovingCycleInfoAddedEventHandler:
        TOnNewDocumentApprovingCycleInfoAddedEventHandler;

      FOnDocumentApprovingCycleRemovedEventHandler:
        TOnDocumentApprovingCycleRemovedEventHandler;

      FOnDocumentApprovingCompletingRequestedEventHandler:
        TOnDocumentApprovingCompletingRequestedEventHandler;

    protected

      procedure Init(
        const Caption: String = ''; ADataSet:
        TDataSet = nil
      ); override;

      function OnAddRecord: Boolean; override;

      procedure OnDataLoadingSuccessHandle(Sender: TObject; DataSet: TDataSet; RelatedState: TObject; const IsDestroyingRequested: Boolean); overload; override;
      procedure OnDataLoadingCancelledHandle(Sender: TObject; const IsDestroyingRequested: Boolean); overload; override;
      procedure OnDataLoadingErrorOccurredHandle(Sender: TObject; DataSet: TDataSet; const Error: Exception; RelatedState: TObject; const IsDestroyingRequested: Boolean); overload; override;

      procedure UpdateApprovingCycleControlOptionsAccessibilityForRecord(
        ApprovingCycleRow: TcxCustomGridRow
      );
      
      procedure UpdateModificationDataActions; override;
      procedure UpdateDataOperationControls; override;
      
      procedure SetViewOnly(const Value: Boolean); override;
      
    protected

      function GetTotalRecordCountPanelLabel: String; override;
      
    protected

      function CreateApprovingCycleViewModelFrom(
        const CycleRowInfo: TcxRowInfo
      ): TDocumentApprovingCycleViewModel;

      procedure WriteApprovingCycleViewModelToRecord(
        DocumentApprovingCycleViewModel: TDocumentApprovingCycleViewModel
      );
      
    protected

      function IsNewDocumentApprovingCycleAlreadyCreated: Boolean;
      procedure CreateNewApprovingCycle;
      procedure CompleteFocusedDocumentApproving; virtual;

      procedure HandleSelectedApprovingCycleRowForCompletingOfCycles(
        ARowIndex: Integer;
        ARowInfo: TcxRowInfo
      );

    protected

      procedure SetDocumentApprovingCycleSetHolder(
        Value: TDocumentApprovingCycleSetHolder
      );

      procedure SetTableColumnLayout(Value: TDocumentApprovingCycleSetHolder);
      
    protected

      procedure RaiseOnNewDocumentApprovingCycleCreatingRequestedEventHandler(
        var NewDocumentApprovingCycleViewModel: TDocumentApprovingCycleViewModel
      );
   
      procedure RaiseOnDocumentApprovingCompletingRequestedEventHandler(
        const CycleRowInfo: TcxRowInfo
      );

      procedure RaiseOnDocumentApprovingCycleRemovingRequestedEventHandler(
        ApprovingCycleViewModel: TDocumentApprovingCycleViewModel
      );

      procedure RaiseOnDocumentApprovingCycleSelectedEventHandler(
        const CycleRowInfo: TcxRowInfo
      );

      procedure RaiseOnDocumentApprovingCycleRemovedEventHandler(
        DocumentApprovingCycleViewModel: TDocumentApprovingCycleViewModel
      );
      
    public

      destructor Destroy; override;
      constructor Create(AOwner: TComponent); override;

      function SelectNewApprovingCycleRecord: Boolean;

      function SelectApprovingCycleByNumber(const Number: Integer): Boolean;

      function GetNewApprovingCycleRecordViewModel: TDocumentApprovingCycleViewModel;

      function GetFocusedApprovingCycleViewModel:
        TDocumentApprovingCycleViewModel;

      function IsNewApprovingCycleRecordFocused: Boolean;

    public

      procedure AddDocumentApprovingCycleRecordFrom(
        NewDocumentApprovingCycleViewModel: TDocumentApprovingCycleViewModel
      );

      procedure RemoveFocusedDocumentApprovingCycleRecord;
      
      procedure RemoveApprovingCycleRecordBy(
        DocumentApprovingCycleViewModel: TDocumentApprovingCycleViewModel
      );

      procedure UpdateApprovingCycleRecordFrom(
        DocumentApprovingCycleViewModel: TDocumentApprovingCycleViewModel
      );

      procedure UpdateCurrentApprovingCycleRecordFrom(
        DocumentApprovingCycleViewModel: TDocumentApprovingCycleViewModel
      );

    public

      property OnNewDocumentApprovingCycleInfoAddedEventHandler:
        TOnNewDocumentApprovingCycleInfoAddedEventHandler
      read FOnNewDocumentApprovingCycleInfoAddedEventHandler
      write FOnNewDocumentApprovingCycleInfoAddedEventHandler;
      
      property OnDocumentApprovingCycleRemovingRequestedEventHandler:
        TOnDocumentApprovingCycleRemovingRequestedEventHandler
      read FOnDocumentApprovingCycleRemovingRequestedEventHandler
      write FOnDocumentApprovingCycleRemovingRequestedEventHandler;

      property OnDocumentApprovingCompletingRequestedEventHandler:
        TOnDocumentApprovingCompletingRequestedEventHandler
      read FOnDocumentApprovingCompletingRequestedEventHandler
      write FOnDocumentApprovingCompletingRequestedEventHandler;

      property OnNewDocumentApprovingCycleCreatingRequestedEventHandler:
        TOnNewDocumentApprovingCycleCreatingRequestedEventHandler
      read FOnNewDocumentApprovingCycleCreatingRequestedEventHandler
      write FOnNewDocumentApprovingCycleCreatingRequestedEventHandler;

      property OnDocumentApprovingCycleSelectedEventHandler:
        TOnDocumentApprovingCycleSelectedEventHandler
      read FOnDocumentApprovingCycleSelectedEventHandler
      write FOnDocumentApprovingCycleSelectedEventHandler;

      property OnDocumentApprovingCycleRemovedEventHandler:
        TOnDocumentApprovingCycleRemovedEventHandler
      read FOnDocumentApprovingCycleRemovedEventHandler
      write FOnDocumentApprovingCycleRemovedEventHandler;
      
      property DocumentApprovingCycleSetHolder: TDocumentApprovingCycleSetHolder
      read FDocumentApprovingCycleSetHolder
      write SetDocumentApprovingCycleSetHolder;
      
    end;

var
  DocumentApprovingCyclesReferenceForm: TDocumentApprovingCyclesReferenceForm;

implementation

uses

  unDocumentCardFrame,
  DBDataTableFormUnit,
  AuxDebugFunctionsUnit,
  AuxWindowsFunctionsUnit, AbstractDataSetHolder;

{$R *.dfm}

{ TDocumentApprovingsTableForm }

procedure TDocumentApprovingCyclesReferenceForm.actCompleteApprovingExecute(
  Sender: TObject);
begin

  CompleteFocusedDocumentApproving;

end;

procedure TDocumentApprovingCyclesReferenceForm.actDeleteDataExecute(
  Sender: TObject);
begin

  if not Assigned(DataRecordGridTableView.Controller.FocusedRow) then
  begin

    ShowInfoMessage(
      Self.Handle,
      'Не выбраны циклы для удаления',
      'Сообщение'
    );

    Exit;
    
  end;
  
  RemoveFocusedDocumentApprovingCycleRecord;

  UpdateMainUI;
  
end;

procedure TDocumentApprovingCyclesReferenceForm.
  AddDocumentApprovingCycleRecordFrom(
    NewDocumentApprovingCycleViewModel: TDocumentApprovingCycleViewModel
  );
begin

  DocumentApprovingCycleSetHolder.DisableControls;

  try

    DocumentApprovingCycleSetHolder.Append;

    WriteApprovingCycleViewModelToRecord(NewDocumentApprovingCycleViewModel);

    DocumentApprovingCycleSetHolder.Post;

    if Assigned(FOnNewDocumentApprovingCycleInfoAddedEventHandler) then begin
    
      FOnNewDocumentApprovingCycleInfoAddedEventHandler(
        Self, NewDocumentApprovingCycleViewModel
      );

    end;

  finally

    DocumentApprovingCycleSetHolder.EnableControls;

  end;
  
end;

procedure TDocumentApprovingCyclesReferenceForm.CompleteFocusedDocumentApproving;
begin

  if not Assigned(DataRecordGridTableView.Controller.FocusedRow)
  then begin

    ShowInfoMessage(
      Self.Handle,
      'Выберите цикл для завершения',
      'Сообщение'
    );

    Exit;
    
  end;

  RaiseOnDocumentApprovingCompletingRequestedEventHandler(
    DataRecordGridTableView.DataController.GetRowInfo(
      DataRecordGridTableView.Controller.FocusedRowIndex
    )
  );
    
end;

constructor TDocumentApprovingCyclesReferenceForm.Create(AOwner: TComponent);
begin

  inherited;

end;

function TDocumentApprovingCyclesReferenceForm.
  CreateApprovingCycleViewModelFrom(
    const CycleRowInfo: TcxRowInfo
  ): TDocumentApprovingCycleViewModel;
var CycleNameColumn: TcxGridDBColumn;
    CycleName: String;

    CycleIdColumn: TcxGridDBColumn;
    CycleId: Variant;

    CycleNumber: Integer;
    CycleNumberColumn: TcxGridDBColumn;

    CycleIsNew: Boolean;
    CycleIsNewColumn: TcxGridDBColumn;

    CanBeChanged: Variant;
    CanBeChangedColumn: TcxGridDBColumn;

    CanBeRemoved: Variant;
    CanBeRemovedColumn: TcxGridDBColumn;

    CanBeCompleted: Variant;
    CanBeCompletedColumn: TcxGridDBColumn;
begin

    CycleIdColumn :=
      DataRecordGridTableView.GetColumnByFieldName(
        FDocumentApprovingCycleSetHolder.IdFieldName
      );

    CycleNumberColumn :=
      DataRecordGridTableView.GetColumnByFieldName(
        FDocumentApprovingCycleSetHolder.CycleNumberFieldName
      );

    CycleNameColumn :=
      DataRecordGridTableView.GetColumnByFieldName(
        FDocumentApprovingCycleSetHolder.CycleNameFieldName
      );

    CycleIsNewColumn :=
      DataRecordGridTableView.GetColumnByFieldName(
        FDocumentApprovingCycleSetHolder.IsCycleNewFieldName
      );

    CanBeChangedColumn :=
      DataRecordGridTableView.GetColumnByFieldName(
        FDocumentApprovingCycleSetHolder.CanBeChangedFieldName
      );

    CanBeRemovedColumn :=
      DataRecordGridTableView.GetColumnByFieldName(
        FDocumentApprovingCycleSetHolder.CanBeRemovedFieldName
      );

    CanBeCompletedColumn :=
      DataRecordGridTableView.GetColumnByFieldName(
        FDocumentApprovingCycleSetHolder.CanBeCompletedFieldName
      );

    CycleId :=
      DataRecordGridTableView.DataController.GetRowValue(
        CycleRowInfo, CycleIdColumn.Index
      );

    CycleNumber :=
      DataRecordGridTableView.DataController.GetRowValue(
        CycleRowInfo, CycleNumberColumn.Index
      );

    CycleName :=
      DataRecordGridTableView.DataController.GetRowValue(
        CycleRowInfo, CycleNameColumn.Index
      );

    CycleIsNew :=
      DataRecordGridTableView.DataController.GetRowValue(
        CycleRowInfo, CycleIsNewColumn.Index
      );

    CanBeChanged :=
      DataRecordGridTableView.DataController.GetRowValue(
        CycleRowInfo, CanBeChangedColumn.Index
      );

    CanBeRemoved :=
      DataRecordGridTableView.DataController.GetRowValue(
        CycleRowInfo, CanBeRemovedColumn.Index
      );

    CanBeCompleted :=
      DataRecordGridTableView.DataController.GetRowValue(
        CycleRowInfo, CanBeCompletedColumn.Index
      );

    Result :=
      TDocumentApprovingCycleViewModel.CreateFrom(
        CycleId, CycleNumber, CycleName, CycleIsNew
      );

    Result.CanBeChanged := CanBeChanged;
    Result.CanBeRemoved := CanBeRemoved;
    Result.CanBeCompleted := CanBeCompleted;

end;

procedure TDocumentApprovingCyclesReferenceForm.CreateNewApprovingCycle;
var NewDocumentApprovingCycleViewModel: TDocumentApprovingCycleViewModel;
begin

  if IsNewDocumentApprovingCycleAlreadyCreated then begin

    ShowInfoMessage(
      Self.Handle,
      'Создание нового цикла согласования ' +
      'уже было выполнено ранее',
      'Сообщение'
    );

    Exit;

  end;

  NewDocumentApprovingCycleViewModel := nil;
  
  RaiseOnNewDocumentApprovingCycleCreatingRequestedEventHandler(
    NewDocumentApprovingCycleViewModel
  );

  if not Assigned(NewDocumentApprovingCycleViewModel) then Exit;
  
  try

    AddDocumentApprovingCycleRecordFrom(NewDocumentApprovingCycleViewModel);

  finally

    FreeAndNil(NewDocumentApprovingCycleViewModel);
    
  end;

end;

procedure TDocumentApprovingCyclesReferenceForm.DataRecordGridTableViewCustomDrawCell(
  Sender: TcxCustomGridTableView; ACanvas: TcxCanvas;
  AViewInfo: TcxGridTableDataCellViewInfo; var ADone: Boolean);
var CycleIsNewColumn: TcxGridDBColumn;
    CycleRowIndex: Integer;
    CycleRowInfo: TcxRowInfo;
    IsCycleNew: Boolean;
begin

  inherited;

  CycleRowIndex :=
    DataRecordGridTableView.DataController.GetRowIndexByRecordIndex(
      AViewInfo.GridRecord.RecordIndex, False
    );

  CycleRowInfo :=
    DataRecordGridTableView.DataController.GetRowInfo(CycleRowIndex);

  CycleIsNewColumn :=
    DataRecordGridTableView.GetColumnByFieldName(
      FDocumentApprovingCycleSetHolder.IsCycleNewFieldName
    );

  IsCycleNew :=
    DataRecordGridTableView.DataController.GetRowValue(
      CycleRowInfo,
      CycleIsNewColumn.Index
    );

  if IsCycleNew then begin

    if AViewInfo.Selected then
      ACanvas.Font.Color := $00aabeff

    else ACanvas.Brush.Color := $00aabeff;

  end;

end;

procedure TDocumentApprovingCyclesReferenceForm.DataRecordGridTableViewFocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
var
    CycleRowIndex: Integer;
begin

  inherited;
  
  if not IsDataSetActive or not HasDataSetRecords then
  begin

    actCompleteApproving.Enabled := False;
    actDeleteData.Enabled := False;

    actAddData.Enabled := IsDataSetActive;

    Exit;

  end;
    
  UpdateApprovingCycleControlOptionsAccessibilityForRecord(
    DataRecordGridTableView.Controller.FocusedRow
  );
          
  CycleRowIndex :=
    DataRecordGridTableView.DataController.GetRowIndexByRecordIndex(
      AFocusedRecord.RecordIndex, False
    );
             
  RaiseOnDocumentApprovingCycleSelectedEventHandler(
    DataRecordGridTableView.DataController.GetRowInfo(CycleRowIndex)
  );

end;

destructor TDocumentApprovingCyclesReferenceForm.Destroy;
begin

  { FreeAndNil(FDocumentApprovingCycleSetHolder);
    пока удаляется внутри объемлющей карточки,
    в будущем воспользоваться интерфейсами
  }
  inherited;

end;

function TDocumentApprovingCyclesReferenceForm.DocumentApprovingCycleSet: TDataSet;
begin

  Result := FDocumentApprovingCycleSetHolder.DocumentApprovingCycleSet;

end;

function TDocumentApprovingCyclesReferenceForm.GetFocusedApprovingCycleViewModel: TDocumentApprovingCycleViewModel;
var FocusedRowInfo: TcxRowInfo;
begin
        
  if not Assigned(DataRecordGridTableView.Controller.FocusedRow) then
  begin

    Result := nil;
    Exit;
    
  end;
  
  FocusedRowInfo :=
    DataRecordGridTableView.DataController.GetRowInfo(
      DataRecordGridTableView.Controller.FocusedRow.Index
    );

  Result := CreateApprovingCycleViewModelFrom(FocusedRowInfo);
  
end;

function TDocumentApprovingCyclesReferenceForm.GetNewApprovingCycleRecordViewModel: TDocumentApprovingCycleViewModel;
var PreviousApprovingCycleViewModel: TDocumentApprovingCycleViewModel;

begin

  DocumentApprovingCycleSetHolder.DisableControls;

  Result := nil;
  PreviousApprovingCycleViewModel := nil;

  try

    try

      if not IsNewApprovingCycleRecordFocused then begin

        PreviousApprovingCycleViewModel := GetFocusedApprovingCycleViewModel;
      
        SelectNewApprovingCycleRecord;

      end;

      Result := GetFocusedApprovingCycleViewModel;

      if Assigned(PreviousApprovingCycleViewModel) then begin

        SelectApprovingCycleByNumber(
          PreviousApprovingCycleViewModel.CycleNumber
        )

      end;

    except

      on e: Exception do begin

        FreeAndNil(Result);
        raise;

      end;

    end;
    
  finally

    FreeAndNil(PreviousApprovingCycleViewModel);
    
    DocumentApprovingCycleSetHolder.EnableControls;

  end;

end;

function TDocumentApprovingCyclesReferenceForm.GetTotalRecordCountPanelLabel: String;
begin

  Result := 'Количество циклов: ';

end;

procedure TDocumentApprovingCyclesReferenceForm.HandleSelectedApprovingCycleRowForCompletingOfCycles(
  ARowIndex: Integer; ARowInfo: TcxRowInfo);
begin

  RaiseOnDocumentApprovingCompletingRequestedEventHandler(
    ARowInfo
  );

end;

procedure TDocumentApprovingCyclesReferenceForm.Init(
  const Caption: String;
  ADataSet: TDataSet
);
begin

  inherited;

  ReserveToolButton1.Visible := True;

end;

function TDocumentApprovingCyclesReferenceForm.IsNewApprovingCycleRecordFocused: Boolean;
var FocusedRow: TcxCustomGridRow;
    IsNewApprovingCycleColumn: TcxGridDBColumn;
begin

  FocusedRow := DataRecordGridTableView.Controller.FocusedRow;

  if not Assigned(FocusedRow) then
    Result := False

  else begin

    IsNewApprovingCycleColumn :=
      DataRecordGridTableView.GetColumnByFieldName(
        DocumentApprovingCycleSetHolder.IsCycleNewFieldName
      );

    Result :=
      FocusedRow.Values[IsNewApprovingCycleColumn.Index];

  end;

end;

function TDocumentApprovingCyclesReferenceForm.
  IsNewDocumentApprovingCycleAlreadyCreated: Boolean;
var ResultVariant: Variant;
begin

  ResultVariant :=
    DocumentApprovingCycleSetHolder.
      DocumentApprovingCycleSet.Lookup(
        DocumentApprovingCycleSetHolder.IsCycleNewFieldName,
        True,
        DocumentApprovingCycleSetHolder.IsCycleNewFieldName
      );

  Result :=
    not VarIsEmpty(ResultVariant) and not VarIsNull(ResultVariant);
    
end;

function TDocumentApprovingCyclesReferenceForm.OnAddRecord: Boolean;
begin

  CreateNewApprovingCycle;

end;

procedure TDocumentApprovingCyclesReferenceForm.OnDataLoadingCancelledHandle(
  Sender: TObject; const IsDestroyingRequested: Boolean);
begin

  inherited;

end;

procedure TDocumentApprovingCyclesReferenceForm.OnDataLoadingErrorOccurredHandle(
  Sender: TObject; DataSet: TDataSet; const Error: Exception;
  RelatedState: TObject; const IsDestroyingRequested: Boolean);
begin

  inherited;

end;

procedure TDocumentApprovingCyclesReferenceForm.OnDataLoadingSuccessHandle(
  Sender: TObject; DataSet: TDataSet; RelatedState: TObject;
  const IsDestroyingRequested: Boolean);
begin

  inherited;

end;

procedure TDocumentApprovingCyclesReferenceForm.
  RaiseOnDocumentApprovingCompletingRequestedEventHandler(
    const CycleRowInfo: TcxRowInfo
  );
var CycleViewModel: TDocumentApprovingCycleViewModel;
begin

  if not Assigned(FOnDocumentApprovingCompletingRequestedEventHandler)
  then Exit;

  try

    CycleViewModel :=
      CreateApprovingCycleViewModelFrom(CycleRowInfo);

    FOnDocumentApprovingCompletingRequestedEventHandler(
      Self, CycleViewModel
    );

  finally

    UpdateApprovingCycleRecordFrom(CycleViewModel);
    
    FreeAndNil(CycleViewModel);

  end;

end;

procedure TDocumentApprovingCyclesReferenceForm.RaiseOnDocumentApprovingCycleRemovedEventHandler(
  DocumentApprovingCycleViewModel: TDocumentApprovingCycleViewModel);
begin

  if Assigned(FOnDocumentApprovingCycleRemovedEventHandler) then
    FOnDocumentApprovingCycleRemovedEventHandler(
      Self, DocumentApprovingCycleViewModel
    );
    
end;

procedure TDocumentApprovingCyclesReferenceForm.
  RaiseOnDocumentApprovingCycleRemovingRequestedEventHandler(
    ApprovingCycleViewModel: TDocumentApprovingCycleViewModel
  );
begin

  if not Assigned(FOnDocumentApprovingCycleRemovingRequestedEventHandler)
  then Exit;

  FOnDocumentApprovingCycleRemovingRequestedEventHandler(
    Self, ApprovingCycleViewModel
  );

end;

procedure TDocumentApprovingCyclesReferenceForm.
  RaiseOnDocumentApprovingCycleSelectedEventHandler(
    const CycleRowInfo: TcxRowInfo
  );
var CycleViewModel: TDocumentApprovingCycleViewModel;
begin

  if not Assigned(FOnDocumentApprovingCycleSelectedEventHandler) then
    Exit;

  CycleViewModel :=
    CreateApprovingCycleViewModelFrom(CycleRowInfo);

  try

    FOnDocumentApprovingCycleSelectedEventHandler(
      Self, CycleViewModel
    );

  finally

    //UpdateCurrentApprovingCycleRecordFrom(CycleViewModel);
    
    FreeAndNil(CycleViewModel);
    
  end;

end;

procedure TDocumentApprovingCyclesReferenceForm.
  RaiseOnNewDocumentApprovingCycleCreatingRequestedEventHandler(
    var NewDocumentApprovingCycleViewModel: TDocumentApprovingCycleViewModel
  );
begin

  if Assigned(FOnNewDocumentApprovingCycleCreatingRequestedEventHandler) then
    FOnNewDocumentApprovingCycleCreatingRequestedEventHandler(
      Self, NewDocumentApprovingCycleViewModel
    );
  
end;

procedure TDocumentApprovingCyclesReferenceForm.RemoveApprovingCycleRecordBy(
  DocumentApprovingCycleViewModel: TDocumentApprovingCycleViewModel);
begin

  if
    DocumentApprovingCycleSet.Locate(
      DocumentApprovingCycleSetHolder.CycleNumberFieldName,
      DocumentApprovingCycleViewModel.CycleNumber,
      []
    )

  then begin

    DocumentApprovingCycleSet.Delete;
    
    RaiseOnDocumentApprovingCycleRemovedEventHandler(
      DocumentApprovingCycleViewModel
    );

  end;

end;

procedure TDocumentApprovingCyclesReferenceForm.RemoveFocusedDocumentApprovingCycleRecord;
var CycleRowInfo: TcxRowInfo;
    ApprovingCycleViewModel: TDocumentApprovingCycleViewModel;
begin

  CycleRowInfo :=
    DataRecordGridTableView.DataController.GetRowInfo(
      DataRecordGridTableView.Controller.FocusedRowIndex
    );

  ApprovingCycleViewModel :=
    CreateApprovingCycleViewModelFrom(CycleRowInfo);

  try

    RaiseOnDocumentApprovingCycleRemovingRequestedEventHandler(
      ApprovingCycleViewModel
    );

    RemoveApprovingCycleRecordBy(ApprovingCycleViewModel);
    
  finally

    UpdateApprovingCycleRecordFrom(ApprovingCycleViewModel);

    FreeAndNil(ApprovingCycleViewModel);

  end;

end;

function TDocumentApprovingCyclesReferenceForm.
  SelectApprovingCycleByNumber(
    const Number: Integer
  ): Boolean;
begin

  Result :=
    DocumentApprovingCycleSet.Locate(
      DocumentApprovingCycleSetHolder.CycleNumberFieldName,
      Number,
      []
    );

end;

function TDocumentApprovingCyclesReferenceForm.SelectNewApprovingCycleRecord: Boolean;
begin

  if IsNewApprovingCycleRecordFocused then
    Result := True

  else begin

    Result :=
      DocumentApprovingCycleSet.Locate(
        DocumentApprovingCycleSetHolder.IsCycleNewFieldName,
        True,
        []
      );
      
  end;
  
end;

procedure TDocumentApprovingCyclesReferenceForm.
  SetDocumentApprovingCycleSetHolder(
    Value: TDocumentApprovingCycleSetHolder
  );
begin

  FDocumentApprovingCycleSetHolder := Value;

  SetTableColumnLayout(Value);
  
  DataSet := FDocumentApprovingCycleSetHolder.DocumentApprovingCycleSet;
  
  UpdateMainUI; 
  
end;

procedure TDocumentApprovingCyclesReferenceForm.SetTableColumnLayout(
  Value: TDocumentApprovingCycleSetHolder);
begin

  with Value do begin

    ApprovingCycleIdColumn.DataBinding.FieldName := IdFieldName;
    ApprovingCycleNumberColumn.DataBinding.FieldName := CycleNumberFieldName;
    ApprovingCycleNameColumn.DataBinding.FieldName := CycleNameFieldName;
    ApprovingCycleIsNewColumn.DataBinding.FieldName := IsCycleNewFieldName;
    CanBeChangedColumn.DataBinding.FieldName := CanBeChangedFieldName;
    CanBeRemovedColumn.DataBinding.FieldName := CanBeRemovedFieldName;
    CanBeCompletedColumn.DataBinding.FieldName := CanBeCompletedFieldName;

  end;

end;

procedure TDocumentApprovingCyclesReferenceForm.SetViewOnly(const Value: Boolean);
begin

  inherited;

  actCompleteApproving.Visible := not Value;
  
end;

procedure TDocumentApprovingCyclesReferenceForm.UpdateApprovingCycleControlOptionsAccessibilityForRecord(
  ApprovingCycleRow: TcxCustomGridRow
);
var
    CycleCanBeRemovedColumn: TcxGridDBColumn;
    CycleCanBeCompletedColumn: TcxGridDBColumn;

    CycleCanBeRemovedVariant: Variant;
    CycleCanBeCompletedVariant: Variant;
begin

  if not Assigned(ApprovingCycleRow) then Exit;

  CycleCanBeRemovedColumn :=
    DataRecordGridTableView.GetColumnByFieldName(
      FDocumentApprovingCycleSetHolder.CanBeRemovedFieldName
    );

  CycleCanBeRemovedVariant :=
    ApprovingCycleRow.Values[CycleCanBeRemovedColumn.Index];

  CycleCanBeCompletedColumn :=
    DataRecordGridTableView.GetColumnByFieldName(
      FDocumentApprovingCycleSetHolder.CanBeCompletedFieldName
    );

  CycleCanBeCompletedVariant :=
    ApprovingCycleRow.Values[CycleCanBeCompletedColumn.Index];

  if not VarIsNull(CycleCanBeRemovedVariant) then begin

    actDeleteData.Enabled :=
      CycleCanBeRemovedVariant and ApprovingCycleRow.Focused;

  end

  else actDeleteData.Enabled := True;

  if not VarIsNull(CycleCanBeCompletedVariant) then begin

    actCompleteApproving.Enabled := CycleCanBeCompletedVariant and ApprovingCycleRow.Focused;
    ReserveToolButton1.Enabled := CycleCanBeCompletedVariant and ApprovingCycleRow.Focused;

  end;

end;

procedure TDocumentApprovingCyclesReferenceForm.UpdateApprovingCycleRecordFrom(
  DocumentApprovingCycleViewModel: TDocumentApprovingCycleViewModel);
begin

  DocumentApprovingCycleSetHolder.DisableControls;

  try

    if

      DocumentApprovingCycleSet.Locate(
        DocumentApprovingCycleSetHolder.CycleNumberFieldName,
        DocumentApprovingCycleViewModel.CycleNumber,
        []
      )

    then begin

      UpdateCurrentApprovingCycleRecordFrom(DocumentApprovingCycleViewModel);

    end;

  finally

    DocumentApprovingCycleSetHolder.EnableControls;
    
  end;

end;

procedure TDocumentApprovingCyclesReferenceForm.UpdateCurrentApprovingCycleRecordFrom(
  DocumentApprovingCycleViewModel: TDocumentApprovingCycleViewModel);
begin

  if DocumentApprovingCycleSetHolder.IdFieldValue <>
     DocumentApprovingCycleViewModel.CycleId
  then
    raise Exception.Create(
      'Попытка обновления данных о цикле ' +
      'данным другого цикла'
    );

  DocumentApprovingCycleSetHolder.DisableControls;

  try

    DocumentApprovingCycleSetHolder.Edit;

    WriteApprovingCycleViewModelToRecord(DocumentApprovingCycleViewModel);

    DocumentApprovingCycleSetHolder.Post;

  finally

    DocumentApprovingCycleSetHolder.EnableControls;
    
  end;

end;

procedure TDocumentApprovingCyclesReferenceForm.UpdateDataOperationControls;
begin

  inherited;

  actAddData.Enabled := IsDataSetActive;

  if not HasDataSetRecords then
    actDeleteData.Enabled := False;

  if not HasDataSetRecords then
    actCompleteApproving.Enabled := False;

end;

procedure TDocumentApprovingCyclesReferenceForm.UpdateModificationDataActions;
var FocusedRow: TcxCustomGridRow;
    CanBeRemovedColumn, CanBeCompletedColumn: TcxGridDBColumn;
begin

  inherited;

  UpdateApprovingCycleControlOptionsAccessibilityForRecord(
    DataRecordGridTableView.Controller.FocusedRow
  );
  
end;

procedure TDocumentApprovingCyclesReferenceForm.WriteApprovingCycleViewModelToRecord(
  DocumentApprovingCycleViewModel: TDocumentApprovingCycleViewModel);
begin

  if VarIsNull(DocumentApprovingCycleViewModel.CycleId) then begin

    DocumentApprovingCycleViewModel.CycleId :=
      DocumentApprovingCycleSetHolder.IdFieldValue;
      
  end

  else begin

      DocumentApprovingCycleSetHolder.IdFieldValue :=
        DocumentApprovingCycleViewModel.CycleId;

  end;

  DocumentApprovingCycleSetHolder.CycleNumberFieldValue :=
    DocumentApprovingCycleViewModel.CycleNumber;

  DocumentApprovingCycleSetHolder.CycleNameFieldValue :=
    DocumentApprovingCycleViewModel.CycleName;

  DocumentApprovingCycleSetHolder.IsCycleNewFieldValue :=
    DocumentApprovingCycleViewModel.IsNew;

  DocumentApprovingCycleSetHolder.CanBeChangedFieldValue :=
    DocumentApprovingCycleViewModel.CanBeChanged;

  DocumentApprovingCycleSetHolder.CanBeRemovedFieldValue :=
    DocumentApprovingCycleViewModel.CanBeRemoved;

  DocumentApprovingCycleSetHolder.CanBeCompletedFieldValue :=
    DocumentApprovingCycleViewModel.CanBeCompleted;
  
end;

end.
