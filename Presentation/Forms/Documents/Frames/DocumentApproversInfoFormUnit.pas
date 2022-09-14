unit DocumentApproversInfoFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxCustomData, cxStyles, cxTL, cxMaskEdit, cxTLdxBarBuiltInMenu, dxSkinsCore,
  dxSkinsDefaultPainters, Menus, cxInplaceContainer, cxDBTL, StdCtrls,
  cxButtons, cxTLData, ExtCtrls, ActnList,
  DocumentApprovingCycleSetHolder, DB,
  EmployeesReferenceFormUnit, VariantListUnit,
  DocumentApprovingViewModel,
  AbstractDataSetHolder,
  InputMemoFormUnit,
  DocumentFlowSystemInputMemoFormUnit,
  EmployeeSetHolder;

type

  TOnEmployeeReferenceForApprovingRequestedEventHandler =
    procedure (
      Sender: TObject;
      var EmployeeReference: TEmployeesReferenceForm
    ) of object;

  TOnEmployeesAddedForApprovingEventHandler =
    procedure (
      Sender: TObject;
      EmployeeIds: TVariantList
    ) of object;

  TOnEmployeesAddingForApprovingRequestedEventHandler =
    procedure (
      Sender: TObject;
      EmployeeIds: TVariantList
    ) of object;
    
  TOnDocumentApprovingsRemovingRequestedEventHandler =
    procedure (
      Sender: TObject;
      DocumentApprovingsViewModel: TDocumentApprovingsViewModel
    ) of object;

  TOnDocumentApprovingsRemovedEventHandler =
    procedure (
      Sender: TObject;
      RemovedApprovingsViewModel: TDocumentApprovingsViewModel
    ) of object;

  TOnDocumentApprovingChangingRequestedEventHandler =
    procedure (
      Sender: TObject;
      ApprovingViewModel: TDocumentApprovingViewModel
    ) of object;

  TOnDocumentApprovingChangedEventHandler =
    procedure (
      Sender: TObject;
      ChangedApprovingViewModel: TDocumentApprovingViewModel
    ) of object;
    
type

  TDocumentApproversInfoForm = class(TForm)
    DocumentApproversControlPanel: TPanel;
    DocumentApproversTreeList: TcxDBTreeList;
    AddApproversButton: TcxButton;
    RemoveApproversButton: TcxButton;
    RecordIdColumn: TcxDBTreeListColumn;
    ApproverNameColumn: TcxDBTreeListColumn;
    ApproverIdColumn: TcxDBTreeListColumn;
    ApproverSpecialityColumn: TcxDBTreeListColumn;
    ApproverDepartmentNameColumn: TcxDBTreeListColumn;
    ApprovingPerformingResultIdColumn: TcxDBTreeListColumn;
    ApprovingPerformingResultColumn: TcxDBTreeListColumn;
    ApprovingPerformingDateColumn: TcxDBTreeListColumn;
    ActuallyPerformedEmployeeIdColumn: TcxDBTreeListColumn;
    ActuallyPerformedEmployeeColumn: TcxDBTreeListColumn;
    NoteColumn: TcxDBTreeListColumn;
    IsViewedByApproverColumn: TcxDBTreeListColumn;
    TopLevelRecordIdColumn: TcxDBTreeListColumn;
    ApproversControlPopupMenu: TPopupMenu;
    ApproverControlActionList: TActionList;
    actAddApprovers: TAction;
    actRemoveApprovers: TAction;
    actSaveChanges: TAction;
    mniAddApprovers: TMenuItem;
    mniRemoveApprovers: TMenuItem;
    DocumentApproversDataSource: TDataSource;
    CanBeChangedColumn: TcxDBTreeListColumn;
    CanBeRemovedColumn: TcxDBTreeListColumn;
    IsApprovingAccessibleColumn: TcxDBTreeListColumn;

    procedure actAddApproversExecute(Sender: TObject);
    procedure actRemoveApproversExecute(Sender: TObject);
    procedure DocumentApproversTreeListDblClick(Sender: TObject);
    procedure DocumentApproversTreeListFocusedNodeChanged(
      Sender: TcxCustomTreeList; APrevFocusedNode,
      AFocusedNode: TcxTreeListNode);
    procedure DocumentApproversTreeListCustomDrawDataCell(
      Sender: TcxCustomTreeList; ACanvas: TcxCanvas;
      AViewInfo: TcxTreeListEditCellViewInfo; var ADone: Boolean);

  protected

    FViewOnly : Boolean;
    
    FOnEmployeeReferenceForApprovingRequestedEventHandler:
      TOnEmployeeReferenceForApprovingRequestedEventHandler;

    FOnEmployeesAddingForApprovingRequestedEventHandler:
      TOnEmployeesAddingForApprovingRequestedEventHandler;

    FOnEmployeesAddedForApprovingEventHandler:
      TOnEmployeesAddedForApprovingEventHandler;
      
    FOnDocumentApprovingsRemovingRequestedEventHandler:
      TOnDocumentApprovingsRemovingRequestedEventHandler;

    FOnDocumentApprovingsRemovedEventHandler:
      TOnDocumentApprovingsRemovedEventHandler;
      
    FOnDocumentApprovingChangingRequestedEventHandler:
      TOnDocumentApprovingChangingRequestedEventHandler;

    FOnDocumentApprovingChangedEventHandler:
      TOnDocumentApprovingChangedEventHandler;

    procedure RaiseOnDocumentApprovingsRemovingRequestedEventHandler(
      DocumentApprovingsViewModel: TDocumentApprovingsViewModel
    );

    procedure RaiseOnEmployeesAddingForApprovingRequestedEventHandler(
      EmployeeIds: TVariantList
    );

    procedure RaiseOnDocumentApprovingChangingRequestedEventHandler(
      ApprovingViewModel: TDocumentApprovingViewModel
    );

    procedure RaiseOnDocumentApprovingChangedEventHandler(
      ChangedApprovingViewModel: TDocumentApprovingViewModel
    );

    procedure RaiseOnEmployeesAddedForApprovingEventHandler(
      AddedEmployeeIds: TVariantList
    );

    procedure RaiseOnDocumentApprovingsRemovedEventHandler(
      RemovedApprovingsViewModel: TDocumentApprovingsViewModel
    );
    
  protected

    procedure SubscribeOnApprovingsDataChangesEvents(
      DocumentApprovingSetHolder: TDocumentApprovingSetHolder
    );

    procedure OnDocumentApprovingRecordInserted(DataSet: TDataSet);

    procedure OnDocumentApprovingRecordChanged(DataSet: TDataSet);

    procedure OnDocumentApprovingRecordRemoved(DataSet: TDataSet);

  protected

    FDocumentApprovingSetHolder: TDocumentApprovingSetHolder;

    procedure SetDocumentApprovingSetHolder(
      Value: TDocumentApprovingSetHolder
    );

    function IsFocusedColumn(const FieldName: String): Boolean;

    function GetFocusedColumn: TcxDBTreeListColumn;
    
    function DocumentApproversDataSet: TDataSet;

    function LocateApprovingRecordByApproverId(
      const ApproverId: Variant
    ): Boolean;

    function LocateApprovingRecordByField(
      const FieldName: String;
      const FieldValue: Variant
    ): Boolean;

  protected

    function GetViewOnly: Boolean;
    procedure SetViewOnly(const Value: Boolean);

    function GetApprovingRecordColumnByField(
      const FieldName: String
    ): TcxDBTreeListColumn;

    procedure ApplyUIVisiblity;
    procedure SetVisibilityForDocumentApproversControlPanelDependsOnItsControlsActivity;

    procedure HighlightDocumentApprovingRecords(
      ACanvas: TcxCanvas;
      AViewInfo: TcxTreeListEditCellViewInfo
    );
      
    function GetAddingApproversOptionsEnabled: Boolean;
    function GetRemovingApproversOptionsEnabled: Boolean;
    procedure SetAddingApproversOptionsEnabled(const Value: Boolean);
    procedure SetRemovingApproversOptionsEnabled(const Value: Boolean);

    
  protected

    procedure AddApprovingRecordsFrom(
      EmployeeRecords: TEmployeesReferenceFormRecords
    );
   
    procedure RemoveSelectedApprovers;

    procedure RemoveApprovingRecordsBy(
      DocumentApprovingsViewModel: TDocumentApprovingsViewModel
    );

    function IsApproverAlreadyAdded(const ApproverId: Variant): Boolean;

  protected

    function CreateDocumentApprovingViewModelFrom(
      Node: TcxDBTreeListNode
    ): TDocumentApprovingViewModel;

    function CreateDocumentApprovingViewModelFromCurrentDataSetRecord: TDocumentApprovingViewModel;

    function CreateDocumentApprovingsViewModelFromAllRecords:
      TDocumentApprovingsViewModel;

    procedure CreateDocumentApprovingsViewModelFromAllRecordsTraverseHandler(
      DataSetHolder: TAbstractDataSetHolder;
      Context: TObject
    );
      
    function CreateDocumentApprovingsViewModelFromSelectedRecords:
      TDocumentApprovingsViewModel;
      
  public

    constructor Create(AOwner: TComponent); override;

    property ViewOnly: Boolean
    read GetViewOnly write SetViewOnly;

    function AddApproversFromEmployeeReference: Boolean;

    procedure AddApproversFromEmployeeSetHolder(const EmployeeSetHolder: TEmployeeSetHolder);

    function GetAllApprovingsViewModel: TDocumentApprovingsViewModel;

    function GetAccessibleApprovingsViewModel: TDocumentApprovingsViewModel;

    procedure UpdateApprovingRecordsFrom(
      DocumentApprovingsViewModel: TDocumentApprovingsViewModel
    );

    procedure UpdateApprovingRecordFrom(
      DocumentApprovingViewModel: TDocumentApprovingViewModel
    );

  public

    procedure BeginUpdate;
    procedure EndUpdate;

  public
  
    property DocumentApprovingSetHolder: TDocumentApprovingSetHolder
    read FDocumentApprovingSetHolder
    write SetDocumentApprovingSetHolder;

    property AddingApproversOptionsEnabled: Boolean
    read GetAddingApproversOptionsEnabled
    write SetAddingApproversOptionsEnabled;

    property RemovingApproversOptionsEnabled: Boolean
    read GetRemovingApproversOptionsEnabled
    write SetRemovingApproversOptionsEnabled;

  public

    property OnDocumentApprovingChangingRequestedEventHandler:
      TOnDocumentApprovingChangingRequestedEventHandler
    read FOnDocumentApprovingChangingRequestedEventHandler
    write FOnDocumentApprovingChangingRequestedEventHandler;

    property OnDocumentApprovingChangedEventHandler:
      TOnDocumentApprovingChangedEventHandler
    read FOnDocumentApprovingChangedEventHandler
    write FOnDocumentApprovingChangedEventHandler;
    
    property OnEmployeeReferenceForApprovingRequestedEventHandler:
      TOnEmployeeReferenceForApprovingRequestedEventHandler
    read FOnEmployeeReferenceForApprovingRequestedEventHandler
    write FOnEmployeeReferenceForApprovingRequestedEventHandler;

    property OnDocumentApprovingsRemovingRequestedEventHandler:
      TOnDocumentApprovingsRemovingRequestedEventHandler
    read FOnDocumentApprovingsRemovingRequestedEventHandler
    write FOnDocumentApprovingsRemovingRequestedEventHandler;

    property OnDocumentApprovingsRemovedEventHandler:
      TOnDocumentApprovingsRemovedEventHandler
    read FOnDocumentApprovingsRemovedEventHandler
    write FOnDocumentApprovingsRemovedEventHandler;
    
    property OnEmployeesAddingForApprovingRequestedEventHandler:
      TOnEmployeesAddingForApprovingRequestedEventHandler
    read FOnEmployeesAddingForApprovingRequestedEventHandler
    write FOnEmployeesAddingForApprovingRequestedEventHandler;

    property OnEmployeesAddedForApprovingEventHandler:
      TOnEmployeesAddedForApprovingEventHandler
    read FOnEmployeesAddedForApprovingEventHandler
    write FOnEmployeesAddedForApprovingEventHandler;
    
  end;

var
  DocumentApproversInfoForm: TDocumentApproversInfoForm;

implementation

uses

  CommonControlStyles,
  AuxDebugFunctionsUnit,
  AuxWindowsFunctionsUnit;

{$R *.dfm}

{ TDocumentApproversInfoForm }

procedure TDocumentApproversInfoForm.actAddApproversExecute(Sender: TObject);
begin

  AddApproversFromEmployeeReference;
  
end;

procedure TDocumentApproversInfoForm.actRemoveApproversExecute(Sender: TObject);
begin

  RemoveSelectedApprovers;

end;

function TDocumentApproversInfoForm.AddApproversFromEmployeeReference: Boolean;
var EmployeesReference: TEmployeesReferenceForm;
    SelectedEmployeeRecords: TEmployeesReferenceFormRecords;
    AddableEmployeeIds: TVariantList;
    SelectedEmployeeRecord: TEmployeesReferenceFormRecord;
begin

  if not Assigned(FOnEmployeeReferenceForApprovingRequestedEventHandler)
  then begin

    Result := False;
    Exit;

  end;

  FOnEmployeeReferenceForApprovingRequestedEventHandler(
    Self, EmployeesReference
  );

  AddableEmployeeIds := nil;

  try

    EmployeesReference.EnableChooseRecordAction := True;

    if EmployeesReference.ShowModal <> mrOk then begin

      Result := False;
      Exit;

    end;
    
    AddableEmployeeIds := TVariantList.Create;
    
    SelectedEmployeeRecords := EmployeesReference.SelectedEmployeesRecords;

    for SelectedEmployeeRecord in SelectedEmployeeRecords do begin

      if IsApproverAlreadyAdded(SelectedEmployeeRecord.Id) then
        Continue;
      
      AddableEmployeeIds.Add(SelectedEmployeeRecord.Id);
      
    end;

    if not AddableEmployeeIds.IsEmpty then begin

      RaiseOnEmployeesAddingForApprovingRequestedEventHandler(
        AddableEmployeeIds
      );

      AddApprovingRecordsFrom(SelectedEmployeeRecords);

      RaiseOnEmployeesAddedForApprovingEventHandler(
        AddableEmployeeIds
      );

      Result := True;

    end

    else Result := False;
    
  finally

    FreeAndNil(AddableEmployeeIds);
    FreeAndNil(EmployeesReference);
    
  end;
  
end;

procedure TDocumentApproversInfoForm.AddApproversFromEmployeeSetHolder(
  const EmployeeSetHolder: TEmployeeSetHolder
);
var
    AddableEmployeeIds: TVariantList;
begin

  if EmployeeSetHolder.IsEmpty then Exit;

  with EmployeeSetHolder do begin

    AddableEmployeeIds := TVariantList.Create;

    try

      First;

      while not Eof do begin

        if not IsApproverAlreadyAdded(RecordIdFieldValue) then
          AddableEmployeeIds.Add(RecordIdFieldValue);
        
        Next;

      end;

      if AddableEmployeeIds.IsEmpty then Exit;
      
      RaiseOnEmployeesAddingForApprovingRequestedEventHandler(AddableEmployeeIds);

      First;

      try

        while not Eof do begin

          DocumentApproversDataSet.Append;

          DocumentApprovingSetHolder.TopLevelApprovingIdFieldValue := Null;

          DocumentApprovingSetHolder.PerformerIdFieldValue := RecordIdFieldValue;

          DocumentApprovingSetHolder.PerformerSpecialityFieldValue :=
            SpecialityFieldValue;

          DocumentApprovingSetHolder.PerformerNameFieldValue :=
            SurnameFieldValue + ' ' + NameFieldValue + ' ' + PatronymicFieldValue;

          DocumentApprovingSetHolder.PerformerDepartmentNameFieldValue :=
            DepartmentShortNameFieldValue;

          DocumentApprovingSetHolder.PerformingResultFieldValue :=
            'Не выполнено';

          DocumentApprovingSetHolder.NoteFieldValue := '';

          DocumentApprovingSetHolder.IsViewedByPerformerFieldValue := False;

          DocumentApprovingSetHolder.CanBeChangedFieldValue := False;
          DocumentApprovingSetHolder.CanBeRemovedFieldValue := True;

          DocumentApproversDataSet.Post;
        
          Next;

        end;

      except

        DocumentApprovingSetHolder.Delete;

        Raise;

      end;

      RaiseOnEmployeesAddedForApprovingEventHandler(AddableEmployeeIds);

    finally

      FreeAndNil(AddableEmployeeIds);

      First;

    end;

  end;

end;

procedure TDocumentApproversInfoForm.AddApprovingRecordsFrom(
  EmployeeRecords: TEmployeesReferenceFormRecords
);
var EmployeeRecord: TEmployeesReferenceFormRecord;
begin

  for EmployeeRecord in EmployeeRecords do begin

    DocumentApprovingSetHolder.Append;

    DocumentApprovingSetHolder.TopLevelApprovingIdFieldValue := Null;

    DocumentApprovingSetHolder.PerformerIdFieldValue :=
      EmployeeRecord.Id;
      
    DocumentApprovingSetHolder.PerformerSpecialityFieldValue :=
      EmployeeRecord.Speciality;
                
    DocumentApprovingSetHolder.PerformerNameFieldValue :=
      EmployeeRecord.Surname + ' ' +
      EmployeeRecord.Name + ' ' +
      EmployeeRecord.Patronymic;

    DocumentApprovingSetHolder.PerformerDepartmentNameFieldValue :=
      EmployeeRecord.DepartmentShortName;

    DocumentApprovingSetHolder.PerformingResultFieldValue :=
      'Не выполнено';

    DocumentApprovingSetHolder.NoteFieldValue := '';

    DocumentApprovingSetHolder.IsViewedByPerformerFieldValue := False;

    DocumentApprovingSetHolder.CanBeChangedFieldValue := False;
    DocumentApprovingSetHolder.CanBeRemovedFieldValue := True;

    DocumentApprovingSetHolder.Post;

  end;
  
end;

procedure TDocumentApproversInfoForm.ApplyUIVisiblity;
var IsDocumentApproversDataSetActive: Boolean;
    IsDocumentApproversDataSetEmpty: Boolean;
begin

  IsDocumentApproversDataSetActive := DocumentApproversDataSet.Active;
  IsDocumentApproversDataSetEmpty := DocumentApproversDataSet.IsEmpty;

  actRemoveApprovers.Enabled :=
    Assigned(FDocumentApprovingSetHolder.DocumentApprovingSet)
    and IsDocumentApproversDataSetActive
    and (not IsDocumentApproversDataSetEmpty);

  mniRemoveApprovers.Visible := actRemoveApprovers.Enabled;
  
end;

procedure TDocumentApproversInfoForm.BeginUpdate;
begin

  DocumentApproversTreeList.BeginUpdate;

end;

constructor TDocumentApproversInfoForm.Create(AOwner: TComponent);
begin

  inherited;
  
end;

function TDocumentApproversInfoForm.CreateDocumentApprovingsViewModelFromAllRecords: TDocumentApprovingsViewModel;
var ApprovingNode: TcxDBTreeListNode;
    I: Integer;
begin

  Result := TDocumentApprovingsViewModel.Create;

  try

    DocumentApprovingSetHolder.ForEach(
      CreateDocumentApprovingsViewModelFromAllRecordsTraverseHandler, Result
    );

    {
    for I := 0 to DocumentApproversTreeList.AbsoluteVisibleCount - 1 do begin

       ApprovingNode :=
        DocumentApproversTreeList.AbsoluteVisibleItems[I] as
        TcxDBTreeListNode;

       Result.Add(
        CreateDocumentApprovingViewModelFrom(ApprovingNode)
       );

    end;
         }
  except

    on e: Exception do begin

      FreeAndNil(Result);

      Raise;

    end;

  end;

end;

procedure TDocumentApproversInfoForm.CreateDocumentApprovingsViewModelFromAllRecordsTraverseHandler(
  DataSetHolder: TAbstractDataSetHolder; Context: TObject);
var
    ApprovingViewModels: TDocumentApprovingsViewModel;
begin

  ApprovingViewModels := TDocumentApprovingsViewModel(Context);

  ApprovingViewModels.Add(CreateDocumentApprovingViewModelFromCurrentDataSetRecord);

end;

function TDocumentApproversInfoForm.
  CreateDocumentApprovingsViewModelFromSelectedRecords:
    TDocumentApprovingsViewModel;
var I: Integer;
    SelectedApprovingTreeNode: TcxDBTreeListNode;
begin

  Result := TDocumentApprovingsViewModel.Create;

  try

    for I := 0 to DocumentApproversTreeList.SelectionCount - 1 do begin

      SelectedApprovingTreeNode :=
        DocumentApproversTreeList.Selections[I] as TcxDBTreeListNode;

      Result.Add(
        CreateDocumentApprovingViewModelFrom(
          SelectedApprovingTreeNode
        )
      )

    end;

  except

    on e: Exception do begin

      FreeAndNil(Result);
      raise;

    end;

  end;

end;

function TDocumentApproversInfoForm.CreateDocumentApprovingViewModelFrom(
  Node: TcxDBTreeListNode): TDocumentApprovingViewModel;
var ApprovingIdColumn: TcxDBTreeListColumn;
    ApproverIdColumn: TcxDBTreeListColumn;
    CanBeChangedColumn: TcxDBTreeListColumn;
    CanBeRemovedColumn: TcxDBTreeListColumn;
    NoteColumn: TcxDBTreeListColumn;
begin

  Result := TDocumentApprovingViewModel.Create;

  try

    ApprovingIdColumn :=
      GetApprovingRecordColumnByField(
        FDocumentApprovingSetHolder.IdFieldName
      );

    ApproverIdColumn :=
      GetApprovingRecordColumnByField(
        FDocumentApprovingSetHolder.PerformerIdFieldName
      );

    NoteColumn :=
      GetApprovingRecordColumnByField(
        FDocumentApprovingSetHolder.NoteFieldName
      );

    CanBeChangedColumn :=
      GetApprovingRecordColumnByField(
        FDocumentApprovingSetHolder.CanBeChangedFieldName
      );

    CanBeRemovedColumn :=
      GetApprovingRecordColumnByField(
        FDocumentApprovingSetHolder.CanBeRemovedFieldName
      );
      
    Result.ApprovingId := Node.Values[ApprovingIdColumn.ItemIndex];
    Result.ApproverId := Node.Values[ApproverIdColumn.ItemIndex];
    Result.Note := Node.Values[NoteColumn.ItemIndex];
    Result.CanBeChanged := Node.Values[CanBeChangedColumn.ItemIndex];
    Result.CanBeRemoved := Node.Values[CanBeRemovedColumn.ItemIndex];

  except

    on e: Exception do begin

      FreeAndNil(Result);
      raise;
      
    end;

  end;
  
end;

function TDocumentApproversInfoForm
  .CreateDocumentApprovingViewModelFromCurrentDataSetRecord: TDocumentApprovingViewModel;
begin

  Result := TDocumentApprovingViewModel.Create;

  try

    Result.ApprovingId := DocumentApprovingSetHolder.IdFieldValue;
    Result.ApproverId := DocumentApprovingSetHolder.PerformerIdFieldValue;
    Result.Note := DocumentApprovingSetHolder.NoteFieldValue;
    Result.CanBeChanged := DocumentApprovingSetHolder.CanBeChangedFieldValue;
    Result.CanBeRemoved := DocumentApprovingSetHolder.CanBeRemovedFieldValue;
    
  except

    FreeAndNil(Result);

    Raise;    

  end;

end;

function TDocumentApproversInfoForm.DocumentApproversDataSet: TDataSet;
begin

  if not Assigned(FDocumentApprovingSetHolder) then
    Result := nil

  else
    Result := FDocumentApprovingSetHolder.DocumentApprovingSet;
    
end;

procedure TDocumentApproversInfoForm.DocumentApproversTreeListCustomDrawDataCell(
  Sender: TcxCustomTreeList; ACanvas: TcxCanvas;
  AViewInfo: TcxTreeListEditCellViewInfo; var ADone: Boolean);
begin

  inherited;

  if AViewInfo.Node.Focused or AViewInfo.Node.Selected then begin

    ACanvas.Brush.Color := $00c56a31;
    ACanvas.Font.Color := $00ffffff;

  end;

  HighlightDocumentApprovingRecords(ACanvas, AViewInfo);
  
end;

procedure TDocumentApproversInfoForm.DocumentApproversTreeListDblClick(
  Sender: TObject
);
var ApprovingViewModel: TDocumentApprovingViewModel;
    InputMemoForm: TInputMemoForm;
begin

  if ViewOnly or
     not Assigned(FDocumentApprovingSetHolder) or
     FDocumentApprovingSetHolder.IsEmpty

  then Exit;
  
  if not IsFocusedColumn(FDocumentApprovingSetHolder.NoteFieldName)
  then Exit;

  ApprovingViewModel :=
    CreateDocumentApprovingViewModelFrom(
      DocumentApproversTreeList.FocusedNode as TcxDBTreeListNode
    );

  InputMemoForm := nil;

  try

    RaiseOnDocumentApprovingChangingRequestedEventHandler(
      ApprovingViewModel
    );

    if not VarIsNull(ApprovingViewModel.CanBeChanged)
       and not ApprovingViewModel.CanBeChanged
    then Exit;
    
    InputMemoForm :=
      TDocumentFlowSystemInputMemoForm.Create(
        Self,
        GetFocusedColumn.Caption.Text
      );

    InputMemoForm.InputText := ApprovingViewModel.Note;

    if InputMemoForm.ShowModal <> mrOk then Exit;

    ApprovingViewModel.Note := InputMemoForm.InputText;

  finally
    
    UpdateApprovingRecordFrom(ApprovingViewModel);

    FreeAndNil(InputMemoForm);
    FreeAndNil(ApprovingViewModel);
    
  end;

end;

procedure TDocumentApproversInfoForm.
DocumentApproversTreeListFocusedNodeChanged(
  Sender: TcxCustomTreeList;
  APrevFocusedNode, AFocusedNode: TcxTreeListNode
);
var CanBeRemovedColumn: TcxDBTreeListColumn;
    CanBeRemovedVariant: Variant;
begin

  inherited;

  if not Assigned(DocumentApproversDataSource.DataSet) then begin

    actAddApprovers.Enabled := False;
    actRemoveApprovers.Enabled := False;

    Exit;
    
  end;

  if FDocumentApprovingSetHolder.DocumentApprovingSet.IsEmpty then
  begin

    actRemoveApprovers.Enabled := False;
    Exit;
    
  end;

  if not Assigned(AFocusedNode) then Exit;
  
  CanBeRemovedColumn :=
    DocumentApproversTreeList.GetColumnByFieldName(
      FDocumentApprovingSetHolder.CanBeRemovedFieldName
    );

  CanBeRemovedVariant :=
    AFocusedNode.Values[CanBeRemovedColumn.ItemIndex];

  if VarIsNull(CanBeRemovedVariant) then
    Exit;

  actRemoveApprovers.Enabled := CanBeRemovedVariant;

end;

procedure TDocumentApproversInfoForm.EndUpdate;
begin

  DocumentApproversTreeList.EndUpdate;
  
end;

function TDocumentApproversInfoForm.GetAccessibleApprovingsViewModel: TDocumentApprovingsViewModel;
var I: Integer;
    ApprovingNode: TcxDBTreeListNode;
begin

  Result := TDocumentApprovingsViewModel.Create;

  try

    DocumentApproversTreeList.LayoutChanged;
    
    for I := 0 to DocumentApproversTreeList.AbsoluteVisibleCount - 1
    do begin

      ApprovingNode :=
        DocumentApproversTreeList.AbsoluteVisibleItems[I] as
        TcxDBTreeListNode;

      if not ApprovingNode.Values[IsApprovingAccessibleColumn.ItemIndex]
      then Continue;

      Result.Add(CreateDocumentApprovingViewModelFrom(ApprovingNode));

    end;

  except

    FreeAndNil(Result);

    raise;

  end;

end;

function TDocumentApproversInfoForm.GetAddingApproversOptionsEnabled: Boolean;
begin

  Result := actAddApprovers.Enabled;
  
end;

function TDocumentApproversInfoForm.GetAllApprovingsViewModel: TDocumentApprovingsViewModel;
begin

  Result := CreateDocumentApprovingsViewModelFromAllRecords;
  
end;

function TDocumentApproversInfoForm.GetApprovingRecordColumnByField(
  const FieldName: String): TcxDBTreeListColumn;
begin

  Result :=
    DocumentApproversTreeList.GetColumnByFieldName(FieldName);

end;

function TDocumentApproversInfoForm.GetFocusedColumn: TcxDBTreeListColumn;
begin

  Result := TcxDBTreeListColumn(DocumentApproversTreeList.FocusedColumn);
  
end;

function TDocumentApproversInfoForm.GetRemovingApproversOptionsEnabled: Boolean;
begin

  Result := actRemoveApprovers.Enabled;
  
end;

function TDocumentApproversInfoForm.GetViewOnly: Boolean;
begin

  Result := FViewOnly;
  
end;

procedure TDocumentApproversInfoForm.HighlightDocumentApprovingRecords(
  ACanvas: TcxCanvas;
  AViewInfo: TcxTreeListEditCellViewInfo
);
var IsApprovingAccessible: Variant;
    ApprovingRecordColor: TColor;
begin

  IsApprovingAccessible :=
    AViewInfo.Node.Values[IsApprovingAccessibleColumn.ItemIndex];

  if VarIsNull(IsApprovingAccessible) or (not IsApprovingAccessible)
  then Exit;
  
  if AViewInfo.Node.Values[ApprovingPerformingResultIdColumn.ItemIndex] =
     DocumentApprovingSetHolder.PerformingResultIsNotPerformedValue
  then
    ApprovingRecordColor := $0081e0ff

  else
    ApprovingRecordColor := $0077ffda;

  if not AViewInfo.Node.Focused then begin

    ACanvas.FillRect(AViewInfo.BoundsRect, ApprovingRecordColor);

  end

  else begin

    ACanvas.Font.Color := ApprovingRecordColor;

  end;

end;

function TDocumentApproversInfoForm.IsApproverAlreadyAdded(
  const ApproverId: Variant
): Boolean;
var ResultVariant: Variant;
begin

  ResultVariant :=
    DocumentApproversDataSet.Lookup(
      DocumentApprovingSetHolder.PerformerIdFieldName,
      ApproverId,
      DocumentApprovingSetHolder.PerformerIdFieldName
    );

  Result :=
    not VarIsEmpty(ResultVariant)
    and not VarIsNull(ResultVariant);

end;

function TDocumentApproversInfoForm.IsFocusedColumn(
  const FieldName: String): Boolean;
var Column: TcxDBTreeListColumn;
begin

  Column := GetApprovingRecordColumnByField(FieldName);

  Result := Column.Focused;
  
end;

function TDocumentApproversInfoForm.LocateApprovingRecordByApproverId(
  const ApproverId: Variant): Boolean;
var ApproverIdColumn: TcxDBTreeListColumn;
begin

  Result :=
    LocateApprovingRecordByField(
      FDocumentApprovingSetHolder.PerformerIdFieldName,
      ApproverId
    );
  
end;

function TDocumentApproversInfoForm.LocateApprovingRecordByField(
  const FieldName: String;
  const FieldValue: Variant
): Boolean;
var FieldColumn: TcxDBTreeListColumn;
begin

  if not Assigned(FDocumentApprovingSetHolder) then begin

    Result := False;
    Exit;

  end;
  
  FieldColumn :=
    DocumentApproversTreeList.GetColumnByFieldName(FieldName);

  Result :=
    DocumentApproversDataSet.Locate(FieldName, FieldValue, []);

end;

procedure TDocumentApproversInfoForm.OnDocumentApprovingRecordChanged(
  DataSet: TDataSet
);
begin

  
end;

procedure TDocumentApproversInfoForm.OnDocumentApprovingRecordInserted(
  DataSet: TDataSet
);
begin

  actRemoveApprovers.Enabled := True;
  mniRemoveApprovers.Visible := True;
  
end;

procedure TDocumentApproversInfoForm.OnDocumentApprovingRecordRemoved(
  DataSet: TDataSet
);
begin

  ApplyUIVisiblity;
  
end;

procedure TDocumentApproversInfoForm.
  RaiseOnDocumentApprovingChangedEventHandler(
    ChangedApprovingViewModel: TDocumentApprovingViewModel
  );
begin

  if Assigned(FOnDocumentApprovingChangedEventHandler) then
    FOnDocumentApprovingChangedEventHandler(
      Self, ChangedApprovingViewModel
    );
    
end;

procedure TDocumentApproversInfoForm.RaiseOnDocumentApprovingChangingRequestedEventHandler(
  ApprovingViewModel: TDocumentApprovingViewModel);
begin

  if Assigned(FOnDocumentApprovingChangingRequestedEventHandler) then
    FOnDocumentApprovingChangingRequestedEventHandler(
      Self, ApprovingViewModel
    );
  
end;

procedure TDocumentApproversInfoForm.
  RaiseOnDocumentApprovingsRemovedEventHandler(
    RemovedApprovingsViewModel: TDocumentApprovingsViewModel
  );
begin

  if Assigned(FOnDocumentApprovingsRemovedEventHandler) then
    FOnDocumentApprovingsRemovedEventHandler(
      Self, RemovedApprovingsViewModel
    );
    
end;

procedure TDocumentApproversInfoForm.
  RaiseOnDocumentApprovingsRemovingRequestedEventHandler(
    DocumentApprovingsViewModel: TDocumentApprovingsViewModel
  );
begin

  if Assigned(FOnDocumentApprovingsRemovingRequestedEventHandler) then
    FOnDocumentApprovingsRemovingRequestedEventHandler(
      Self, DocumentApprovingsViewModel
    );
    
end;

procedure TDocumentApproversInfoForm.
  RaiseOnEmployeesAddedForApprovingEventHandler(
    AddedEmployeeIds: TVariantList
  );
begin

  if Assigned(FOnEmployeesAddedForApprovingEventHandler) then
    FOnEmployeesAddedForApprovingEventHandler(
      Self, AddedEmployeeIds
    );
    
end;

procedure TDocumentApproversInfoForm.
  RaiseOnEmployeesAddingForApprovingRequestedEventHandler(
    EmployeeIds: TVariantList
  );
begin

  if Assigned(FOnEmployeesAddingForApprovingRequestedEventHandler) then
    FOnEmployeesAddingForApprovingRequestedEventHandler(
      Self, EmployeeIds
    );
    
end;

procedure TDocumentApproversInfoForm.
  RemoveApprovingRecordsBy(
    DocumentApprovingsViewModel: TDocumentApprovingsViewModel
  );
var DocumentApprovingViewModel: TDocumentApprovingViewModel;
begin

  for DocumentApprovingViewModel in DocumentApprovingsViewModel do begin

    if

      LocateApprovingRecordByApproverId(
        DocumentApprovingViewModel.ApproverId
      )

    then begin

      DocumentApproversDataSet.Delete;

    end;
    
  end;

end;

procedure TDocumentApproversInfoForm.RemoveSelectedApprovers;
var I: Integer;
    SelectedApprovingTreeNode: TcxDBTreeListNode;
    ApproverIdColumn: TcxDBTreeListColumn;
    ApprovingIdColumn: TcxDBTreeListColumn;
    RemoveableDocumentApprovingsViewModel: TDocumentApprovingsViewModel;
begin

  if DocumentApproversTreeList.SelectionCount = 0 then Exit;

  RemoveableDocumentApprovingsViewModel :=
    CreateDocumentApprovingsViewModelFromSelectedRecords;

  try

    RaiseOnDocumentApprovingsRemovingRequestedEventHandler(
      RemoveableDocumentApprovingsViewModel
    );

    RemoveApprovingRecordsBy(
      RemoveableDocumentApprovingsViewModel
    );

    RaiseOnDocumentApprovingsRemovedEventHandler(
      RemoveableDocumentApprovingsViewModel
    );
    
  finally

    UpdateApprovingRecordsFrom(RemoveableDocumentApprovingsViewModel);
    
    FreeAndNil(RemoveableDocumentApprovingsViewModel);
    
  end;

end;

procedure TDocumentApproversInfoForm.SetAddingApproversOptionsEnabled(
  const Value: Boolean);
begin

  actAddApprovers.Enabled := Value;
  AddApproversButton.Enabled := Value;
  mniAddApprovers.Visible := Value;

  SetVisibilityForDocumentApproversControlPanelDependsOnItsControlsActivity;

end;

procedure TDocumentApproversInfoForm.SetRemovingApproversOptionsEnabled(
  const Value: Boolean);
begin

  actRemoveApprovers.Enabled := Value;
  mniRemoveApprovers.Visible := Value;

  SetVisibilityForDocumentApproversControlPanelDependsOnItsControlsActivity;
  
end;

procedure TDocumentApproversInfoForm.SetDocumentApprovingSetHolder(
  Value: TDocumentApprovingSetHolder);
begin

  FDocumentApprovingSetHolder := Value;

  DocumentApproversDataSource.DataSet :=
    FDocumentApprovingSetHolder.DocumentApprovingSet;

  SubscribeOnApprovingsDataChangesEvents(FDocumentApprovingSetHolder);

  ApplyUIVisiblity;

end;

procedure TDocumentApproversInfoForm.SetViewOnly(const Value: Boolean);
begin

  FViewOnly := Value;
  
  DocumentApproversControlPanel.Visible := not Value;

  actAddApprovers.Visible := not Value;
  actRemoveApprovers.Visible := not Value;
  actSaveChanges.Visible := not Value;

  if Value then begin

    DocumentApproversTreeList.PopupMenu := nil;

    DocumentApproversControlPanel.Align := alNone;
    
  end

  else begin

    DocumentApproversTreeList.PopupMenu := ApproversControlPopupMenu;

    DocumentApproversControlPanel.Align := alTop;
    
  end;

  DocumentApproversTreeList.OptionsData.Editing := not Value;
  
end;

procedure TDocumentApproversInfoForm.SetVisibilityForDocumentApproversControlPanelDependsOnItsControlsActivity;
var Control: TControl;
    I: Integer;
begin

  for I := 0 to DocumentApproversControlPanel.ControlCount - 1 do begin

    Control := DocumentApproversControlPanel.Controls[I];

    if Control.Enabled then begin

      //DocumentApproversControlPanel.Show;
      Exit;
      
    end;

  end;

  //DocumentApproversControlPanel.Hide;
  
end;

procedure TDocumentApproversInfoForm.SubscribeOnApprovingsDataChangesEvents(
  DocumentApprovingSetHolder: TDocumentApprovingSetHolder);
begin

  DocumentApprovingSetHolder.OnDataSetRecordInsertedEventHandler :=
    OnDocumentApprovingRecordInserted;

  DocumentApprovingSetHolder.OnDataSetRecordChangedEventHandler :=
    OnDocumentApprovingRecordChanged;

  DocumentApprovingSetHolder.OnDataSetRecordRemovedEventHandler :=
    OnDocumentApprovingRecordRemoved;
    
end;

procedure TDocumentApproversInfoForm.UpdateApprovingRecordFrom(
  DocumentApprovingViewModel: TDocumentApprovingViewModel);
var IsDocumentApprovingChanged: Boolean;
begin

  if

    LocateApprovingRecordByField(
      FDocumentApprovingSetHolder.PerformerIdFieldName,
      DocumentApprovingViewModel.ApproverId
    )

  then begin

    DocumentApprovingSetHolder.Edit;

    IsDocumentApprovingChanged :=
      DocumentApprovingSetHolder.IdFieldValue <>
      DocumentApprovingViewModel.ApprovingId;

    DocumentApprovingSetHolder.IdFieldValue :=
      DocumentApprovingViewModel.ApprovingId;

    IsDocumentApprovingChanged :=
      IsDocumentApprovingChanged or
      (DocumentApprovingSetHolder.PerformerIdFieldValue <>
      DocumentApprovingViewModel.ApproverId);
      
    DocumentApprovingSetHolder.PerformerIdFieldValue :=
      DocumentApprovingViewModel.ApproverId;

    IsDocumentApprovingChanged :=
      IsDocumentApprovingChanged or
      (DocumentApprovingSetHolder.NoteFieldValue <>
      DocumentApprovingViewModel.Note);
      
    DocumentApprovingSetHolder.NoteFieldValue :=
      DocumentApprovingViewModel.Note;
      
    DocumentApprovingSetHolder.CanBeChangedFieldValue :=
      DocumentApprovingViewModel.CanBeChanged;

    DocumentApprovingSetHolder.CanBeRemovedFieldValue :=
      DocumentApprovingViewModel.CanBeRemoved;
      
    DocumentApprovingSetHolder.Post;

    if IsDocumentApprovingChanged then
      RaiseOnDocumentApprovingChangedEventHandler(
        DocumentApprovingViewModel
      );

  end;
  
end;

procedure TDocumentApproversInfoForm.UpdateApprovingRecordsFrom(
  DocumentApprovingsViewModel: TDocumentApprovingsViewModel);
var DocumentApprovingViewModel: TDocumentApprovingViewModel;
begin

  for DocumentApprovingViewModel in DocumentApprovingsViewModel do
    UpdateApprovingRecordFrom(DocumentApprovingViewModel);
    
end;

end.
