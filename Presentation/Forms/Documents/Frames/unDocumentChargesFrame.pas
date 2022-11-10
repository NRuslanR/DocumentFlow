{
  refactor(unDocumentChargesFrame, 1):
  изменить в соттветсвии с исправленным функционалом
  поручений и прикладными службами из проекта Application
}
unit unDocumentChargesFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unDocumentCardInformationFrame, ExtCtrls, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxCustomData, cxStyles, cxTL,
  cxMaskEdit, cxTLdxBarBuiltInMenu, dxSkinsCore, dxSkinsDefaultPainters, Menus,
  cxInplaceContainer, cxDBTL, StdCtrls, cxButtons, cxTLData, cxMemo, DB,
  ZSqlUpdate, ZAbstractRODataset, ZAbstractDataset, ZDataset, ZConnection,
  DocumentChargePerformersReferenceFormUnit,
  DBDataTableFormUnit, DocumentChargesFormViewModelUnit, cxTextEdit,
  cxCalendar, cxDropDownEdit, cxButtonEdit,
  DocumentChargeSetHolder, ActnList,
  EmployeesReferenceFormUnit,
  VariantListUnit, EmployeeSetHolder,
  DocumentFlowSystemInputMemoFormUnit,
  unDocumentFlowInformationFrame,
  DocumentChargePerformerSetReadService;

const

  DEFAULT_FOREIGN_RECEIVER_RECORD_BACKGROUND_COLOR = $00fefefe;
  DEFAULT_BACKGROUND_BUTTON_COLOR = $00ebb99d;
  
type

  TOnDocumentPerformingsChangesSavingRequestedEventHandler =
    procedure (
      Sender: TObject
    ) of object;

  TOnDocumentChargePerformersReferenceRequestedEventHandler =
    procedure (
      Sender: TObject;
      var DocumentChargePerformersReference: TEmployeesReferenceForm
    ) of object;
    
  TDocumentChargesFrame = class(TDocumentCardInformationFrame)
    DocumentReceiversTreeList: TcxDBTreeList;
    AddDocumentReceiverButton: TcxButton;                
    RemoveDocumentReceiverButton: TcxButton;
    ReceiverFullNameColumn: TcxDBTreeListColumn;
    ReceiverSpecialityColumn: TcxDBTreeListColumn;
    ReceiverDepartmentColumn: TcxDBTreeListColumn;
    DataSource1: TDataSource;
    DocumentReceiverResolutionColumn: TcxDBTreeListColumn;
    ReceiverIdColumn: TcxDBTreeListColumn;
    TopLevelChargeIdColumn: TcxDBTreeListColumn;
    RecordIdColumn: TcxDBTreeListColumn;
    PerformingDateTimeColumn: TcxDBTreeListColumn;
    RecordStatusColumn: TcxDBTreeListColumn;
    ChargeRecordsHandlingPopupMenu: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    IsReceiverForeignColumn: TcxDBTreeListColumn;
    ViewingDateByPerformerColumn: TcxDBTreeListColumn;
    ReceiverLeaderIdColumn: TcxDBTreeListColumn;
    IsAccessbleChargeColumn: TcxDBTreeListColumn;
    ReceiverDocumentIdColumn: TcxDBTreeListColumn;
    PerformedEmployeeNameColumn: TcxDBTreeListColumn;
    IsForAcquaitanceColumn: TcxDBTreeListColumn;
    ChargeActionList: TActionList;
    actChangeSelectedChargeTexts: TAction;
    N3: TMenuItem;
    DocumentChargeTextColumn: TcxDBTreeListColumn;
    ReceiverControlToolPanel: TPanel;
    IssuingDateTimeColumn: TcxDBTreeListColumn;
    actAddReceivers: TAction;
    actRemoveSelectedReceivers: TAction;

    procedure DocumentReceiverResolutionColumnPropertiesEditValueChanged(
      Sender: TObject);
    procedure actAddReceiversExecute(Sender: TObject);
    procedure actRemoveSelectedReceiversExecute(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure DocumentReceiversTreeListCustomDrawDataCell(
      Sender: TcxCustomTreeList; ACanvas: TcxCanvas;
      AViewInfo: TcxTreeListEditCellViewInfo; var ADone: Boolean);
    procedure DocumentReceiversTreeListEditValueChanged(
      Sender: TcxCustomTreeList; AColumn: TcxTreeListColumn);
    procedure DocumentReceiversTreeListSelectionChanged(Sender: TObject);
    procedure actChangeSelectedChargeTextsExecute(Sender: TObject);

  private

  protected

    FIsAlreadyShowed: Boolean;
    FIsDocumentChargeSetChanged: Boolean;
    FOwnRecordId: Variant;
    FReplaceableChargeRecordIds: TVariantList;
    FViewModel: TDocumentChargesFormViewModel;

    FOnDocumentPerformingsChangesSavingRequestedEventHandler:
      TOnDocumentPerformingsChangesSavingRequestedEventHandler;

    FOnDocumentChargePerformersReferenceRequestedEventHandler:
      TOnDocumentChargePerformersReferenceRequestedEventHandler;

    procedure SubscribeOnEvents;

    procedure OnSelfDocumentChargePerformersReferenceRequestedEventHandler(
      Sender: TObject;
      var DocumentChargePerformersReference: TEmployeesReferenceForm
    ); virtual;

    procedure OnDocumentChargePerformerRecordsRefreshRequestedEventHandler(
      Sender: TObject
    );

    function CreateDocumentChargePerformersReferenceForm: TDocumentChargePerformersReferenceForm; virtual;

    function GetDocumentChargePerformerSetHolder: TEmployeeSetHolder; virtual;

    procedure WndProc(var Message: TMessage); override;

    procedure UpdateOwnRecordIdAndReplaceableChargeRecordIds;
    
    function GetHorizontalScrollingMinWidth: Integer; override;
    function GetVerticalScrollingMinHeight: Integer; override;

    procedure OnDocumentReceiverChangedEventHandler(
      DataSet: TDataSet
    );

    procedure OnDocumentReceiverRemovedEventHandler(
      DataSet: TDataSet
    );

    procedure SubscribeOnDocumentReceiversViewDataSetDataEvents;

    procedure Initialize; override;
    procedure InitializeLayout; virtual;
    procedure SetEnabled(Value: Boolean); override;
    
    procedure AddDocumentReceiverFromEmployeesReference;

    procedure AddDocumentReceiversFromSelectedEmployeeRecords(
      SelectedEmployeeRecords: TDBDataTableRecords
    );

    function IsDocumentReceiverDataAlreadyAdded(
      const EmployeeId: Variant
    ): Boolean;

    procedure AddDocumentReceiverFromSelectedEmployeeRecord(
      SelectedEmployeeRecord: TDBDataTableRecord
    );

    function WasDocumentChargeRecordAddedByWorkingEmployeeInPast(
      SelectedDocumentReceiverNode: TcxTreeListNode
    ): Boolean; virtual;
    
    function WasDocumentChargeRecordAddedByWorkingEmployee(
      SelectedDocumentReceiverNode: TcxTreeListNode
    ): Boolean;

    function WasDocumentChargeRecordAddedBySubordinateOfWorkingEmployee(
      SelectedDocumentReceiverNode: TcxTreeListNode
    ): Boolean;

    function IsDocumentPerformingDateTimeAbsent(
      SelectedDocumentReceiverNode: TcxTreeListNode
    ): Boolean;
    
    procedure RemoveChoosenDocumentReceivers;
    procedure RefreshChargeRecords;
    
    function FindRecordIdByReceiverId(const ReceiverId: Variant): Variant;

    function FindReplaceableChargeRecordIdsByGivenReceiverId(
      const ReceiverId: Variant
    ): TVariantList;

    function IsReceiverDeputyForOtherOrViceVersa(
      const TargetReceiverId: Variant;
      const OtherReceiverId: Variant
    ): Boolean;

    function ValidateFocusedChargeRecordNotPerformed: Boolean;
    function ValidateCurrentChargeRecordOrReplaceableChargeRecordFocusedIfNecessary: Boolean;
    
    function GetReplaceableReceiverCountForReceiver(
      const ReceiverId: Variant
    ): Integer;

    function IsDocumentChargeRecordAboutWorkingEmployee(
      SelectedDocumentReceiverNode: TcxTreeListNode
    ): Boolean;

    function GetViewModelClass: TDocumentChargesFormViewModelClass; virtual;

    procedure UpdateByViewModel(const ViewModel: TDocumentChargesFormViewModel);

    function DataSetHolder: TDocumentChargeSetHolder;
    function IsDataSetHolderAssigned: Boolean;
    
    procedure SetTableColumnLayout(FieldDefs: TDocumentChargeSetFieldDefs); virtual;

    function GetViewModel: TDocumentChargesFormViewModel; virtual;
    procedure SetViewModel(ViewModel: TDocumentChargesFormViewModel); virtual;

    function GetViewOnly: Boolean; override;
    procedure SetViewOnly(const Value: Boolean); override;

    procedure SetIgnorableViewOnlyControls(Controls:  TList); override;

    function GetWorkingEmployeeChargeCount: Integer;
    function GetWorkingEmployeePerformedChargeCount: Integer;
    function GetIsAllChargesPerformedByWorkingEmployee: Boolean;

    procedure ChangeChargeTextsForSelectedChargeNodes(const ChargeText: string);
    procedure ChangeChargeTextsForChargeNodes(ChargeTreeNodes: TList; const ChargeText: string);

    function CanChangeChargeFieldForAnyOfNodes(ChargeTreeNodes: TList): Boolean;

    function IsSubordinateChargeNode(ChargeTreeNode: TcxTreeListNode): Boolean;
    function IsOwnOrReplaceableChargeNode(ChargeTreeNode: TcxTreeListNode): Boolean;
    function CanChangeChargeFieldForNode(ChargeTreeNode: TcxTreeListNode): Boolean;
    function CanChangeCommentFieldForNode(ChargeTreeNode: TcxTreeListNode): Boolean;

    function GetInputFieldTextForm(
      const Caption: String;
      const InputFieldText: string;
      var Accepted: Boolean
    ): String;

  protected

    procedure MarkCurrentChargeRecordAsChanged_RefactorFuture;
    procedure MarkChargeNodeAsChanged(ChargeTreeNode: TcxTreeListNode);

    procedure HandleChangeSelectedChargeTextsAction;

    function ChargeSet: TDataSet;

  protected

    function GetSameChargeTextFromChargeNodes(ChargeNodes: TList): String;

  protected

    function GetAddingChargeToolVisible: Boolean;
    function GetRemovingChargeToolVisible: Boolean;
    
    procedure SetAddingChargeToolVisible(const Value: Boolean);
    procedure SetRemovingChargeToolVisible(const Value: Boolean);

    procedure UpdateDocumentChargeControlPanel;
    procedure ReLayoutDocumentChargeControlPanel; virtual;
    procedure UpdateDocumentChargeControlPanelVisibility; virtual;

  protected

    procedure RestoreUIControlProperties; override;
    procedure SaveUIControlProperties; override;

  public

    destructor Destroy; override;
    constructor Create(AOwner: TComponent); override;

    procedure OnChangesApplied; override;
    procedure OnChangesApplyingFailed; override;
    function IsDataChanged: Boolean; override;

    procedure SelectChargeRecordByReceiverId(
      const ReceiverId: Variant
    );

    procedure CopyUISettings(
      DocumentInformationFrame: TDocumentFlowInformationFrame
    ); override;

    property ViewModel: TDocumentChargesFormViewModel
    read GetViewModel write SetViewModel;

    property OnDocumentPerformingsChangesSavingRequestedEventHandler:
      TOnDocumentPerformingsChangesSavingRequestedEventHandler

    read FOnDocumentPerformingsChangesSavingRequestedEventHandler
    write FOnDocumentPerformingsChangesSavingRequestedEventHandler;

    property WorkingEmployeeChargeCount: Integer
    read GetWorkingEmployeeChargeCount;

    property WorkingEmployeePerformedChargeCount: Integer
    read GetWorkingEmployeePerformedChargeCount;

    property IsAllChargesPerformedByWorkingEmployee: Boolean
    read GetIsAllChargesPerformedByWorkingEmployee;

    property OnDocumentChargePerformersReferenceRequestedEventHandler:
      TOnDocumentChargePerformersReferenceRequestedEventHandler

    read FOnDocumentChargePerformersReferenceRequestedEventHandler
    write FOnDocumentChargePerformersReferenceRequestedEventHandler;

  public

    property AddingChargeToolVisible: Boolean
    read GetAddingChargeToolVisible write SetAddingChargeToolVisible;

    property RemovingChargeToolVisible: Boolean
    read GetRemovingChargeToolVisible write SetRemovingChargeToolVisible;

  end;

var
  DocumentChargesFrame: TDocumentChargesFrame;

implementation

uses

  AuxDebugFunctionsUnit,
  AuxWindowsFunctionsUnit,
  WorkingEmployeeUnit,
  AuxDataSetFunctionsUnit,
  ApplicationServiceRegistries { refactor },
  EmployeeSetReadService;
  
{$R *.dfm}

{ TDocumentChargesFrame }

procedure TDocumentChargesFrame.actAddReceiversExecute(Sender: TObject);
begin

  AddDocumentReceiverFromEmployeesReference;

end;

procedure TDocumentChargesFrame.actChangeSelectedChargeTextsExecute(Sender: TObject);
begin

  HandleChangeSelectedChargeTextsAction;
  
end;

procedure TDocumentChargesFrame.actRemoveSelectedReceiversExecute(
  Sender: TObject);
begin

  RemoveChoosenDocumentReceivers;

end;

procedure TDocumentChargesFrame.AddDocumentReceiverFromEmployeesReference;
var EmployeesReferenceForm: TEmployeesReferenceForm;
begin

  EmployeesReferenceForm := nil;

  try

    if
      not Assigned(
        FOnDocumentChargePerformersReferenceRequestedEventHandler
      )
    then Exit;

    FOnDocumentChargePerformersReferenceRequestedEventHandler(
      Self,
      EmployeesReferenceForm
    );

    if not Assigned(EmployeesReferenceForm) then Exit;

    if EmployeesReferenceForm.ShowModal <> mrOk then
      Exit;

    AddDocumentReceiversFromSelectedEmployeeRecords(
      EmployeesReferenceForm.SelectedRecords
    );

    DocumentReceiversTreeList.LayoutChanged;

  finally

    FreeAndNil(EmployeesReferenceForm);

  end;

end;

procedure TDocumentChargesFrame.AddDocumentReceiverFromSelectedEmployeeRecord(
  SelectedEmployeeRecord: TDBDataTableRecord
);
var DocumentSenderIdValue: Variant;
    RemovedChargeRecordId: Variant;
    IsAddableChargeRecordMarkedAsRemovedNow: Boolean;
    ReplaceableChargeRecordIds: TVariantList;
    TopLevelChargeId: Variant;
    WorkingEmployeeRecordId: Variant;
    DocumentSenderNode: TcxDBTreeListNode;
begin

  with DataSetHolder do begin

    DisableControls;

    try

      RevealRemovedChargeRecords;

      IsAddableChargeRecordMarkedAsRemovedNow :=
        Locate(ReceiverIdFieldName, SelectedEmployeeRecord['id'], []);

      if IsAddableChargeRecordMarkedAsRemovedNow then
        MarkCurrentChargeRecordAsNonChanged;

      RevealNonRemovedChargeRecords;

      if IsAddableChargeRecordMarkedAsRemovedNow then Exit;

      Append;

      ChargeKindIdFieldValue := ViewModel.DocumentChargeKindDto.Id;
      ChargeKindNameFieldValue := ViewModel.DocumentChargeKindDto.Name;
      
      IsAccessibleChargeFieldValue := False;
      
      ReceiverFullNameFieldValue :=
        SelectedEmployeeRecord['surname'] + ' ' +
        SelectedEmployeeRecord['name'] + ' ' +
        SelectedEmployeeRecord['patronymic'];

      ReceiverSpecialityFieldValue := SelectedEmployeeRecord['speciality'];

      IsChargeForAcquaitanceFieldValue := False;
      
      ReceiverDepartmentNameFieldValue :=
        SelectedEmployeeRecord['department_short_name'];

      ReceiverIdFieldValue := SelectedEmployeeRecord['id'];

      IsReceiverForeignFieldValue := SelectedEmployeeRecord['is_foreign'];

      if SelectedEmployeeRecord['is_foreign'] then
        ReceiverCommentFieldValue := 'Уведомление по почте';

      Post;

      if Assigned(DocumentReceiversTreeList.FocusedNode) then begin

        TopLevelChargeId :=
          DocumentReceiversTreeList.FocusedNode.Values[
            RecordIdColumn.ItemIndex
          ];

        if TopLevelChargeId < 0 then
          TopLevelChargeId := Null;

      end

      else TopLevelChargeId := Null;

      try

        ReplaceableChargeRecordIds :=
          FindReplaceableChargeRecordIdsByGivenReceiverId(
            WorkingEmployeeId
          );

        WorkingEmployeeRecordId :=
          FindRecordIdByReceiverId(WorkingEmployeeId);

        if VarIsNull(TopLevelChargeId) then begin

          DocumentSenderIdValue := WorkingEmployeeRecordId

        end

        else begin

          if ReplaceableChargeRecordIds.Contains(TopLevelChargeId) or
             (TopLevelChargeId = WorkingEmployeeRecordId)

          then DocumentSenderIdValue := TopLevelChargeId;

        end;

        if (VarIsNull(DocumentSenderIdValue) or
            VarIsEmpty(DocumentSenderIdValue))

        then begin

          if not VarIsNull(WorkingEmployeeRecordId) then
            DocumentSenderIdValue := WorkingEmployeeRecordId
          
          else if not ReplaceableChargeRecordIds.IsEmpty then
            DocumentSenderIdValue :=  ReplaceableChargeRecordIds[0]

          else DocumentSenderIdValue := Null;

        end;
        
      finally

        FreeAndNil(ReplaceableChargeRecordIds);

      end;

      Edit;

      if not VarIsNull(DocumentSenderIdValue) and
          (DocumentSenderIdValue < 0)
      then
        DocumentSenderIdValue := Null;
      
      TopLevelChargeIdFieldValue := DocumentSenderIdValue;

      if not VarisNull(DocumentSenderIdValue) then begin

        DocumentSenderNode :=
          DocumentReceiversTreeList.FindNodeByKeyValue(
            DocumentSenderIdValue
          );

        ReceiverDocumentIdFieldValue :=
          DocumentSenderNode.Values[
            ReceiverDocumentIdColumn.ItemIndex
          ];

        ChargeSheetSenderEmployeeIdFieldValue :=
          WorkingEmployeeId;

        IsChargeForAcquaitanceFieldValue :=
          DocumentSenderNode.Values[
            IsForAcquaitanceColumn.ItemIndex
          ];

      end;

      MarkCurrentChargeRecordAsAdded;

      Post;
      
    finally

      EnableControls;

    end;

  end;

end;

procedure TDocumentChargesFrame.AddDocumentReceiversFromSelectedEmployeeRecords(
  SelectedEmployeeRecords: TDBDataTableRecords
);
var SelectedEmployeeRecord: TDBDataTableRecord;
    ErrorMessage, DuplicateDocumentReceiversString: String;
begin

  DuplicateDocumentReceiversString := '';

  for SelectedEmployeeRecord in SelectedEmployeeRecords do begin

    if IsDocumentReceiverDataAlreadyAdded(
          SelectedEmployeeRecord['id']
       )
    then begin

      DuplicateDocumentReceiversString :=

        DuplicateDocumentReceiversString +

        '"' + SelectedEmployeeRecord['name'] + ' ' +
        SelectedEmployeeRecord['surname'] + ' ' +
        SelectedEmployeeRecord['patronymic'] + '"' +

        sLineBreak;

    end

    else AddDocumentReceiverFromSelectedEmployeeRecord(
            SelectedEmployeeRecord
          );

  end;

  if DuplicateDocumentReceiversString <> '' then begin

    ShowInfoMessage(
      Self.Handle,
      'Следующие сотрудники уже были ранее добавлены:' +
      sLineBreak +
      DuplicateDocumentReceiversString,
      'Сообщение'
    );

  end;

end;

function TDocumentChargesFrame.CanChangeChargeFieldForNode(
  ChargeTreeNode: TcxTreeListNode): Boolean;
begin

  Result := IsSubordinateChargeNode(ChargeTreeNode);

  Result := Result and VarIsNull(ChargeTreeNode.Values[PerformingDateTimeColumn.ItemIndex]);

end;

function TDocumentChargesFrame.CanChangeChargeFieldForAnyOfNodes(ChargeTreeNodes: TList): Boolean;
var ChargeNode: TcxTreeListNode;
    NodePointer: Pointer;
begin

  if not Assigned(ChargeTreeNodes) then Exit;

  for NodePointer in ChargeTreeNodes do begin

    ChargeNode := TcxTreeListNode(NodePointer);

    if CanChangeChargeFieldForNode(ChargeNode) then begin

      Result := True;
      Exit;

    end;

  end;

  Result := False;

end;

function TDocumentChargesFrame.CanChangeCommentFieldForNode(
  ChargeTreeNode: TcxTreeListNode): Boolean;
begin

  if not Assigned(ChargeTreeNode) then begin

    Result := False;
    Exit;

  end;

  Result :=
    IsOwnOrReplaceableChargeNode(ChargeTreeNode) and
    VarIsNull(ChargeTreeNode.Values[PerformingDateTimeColumn.ItemIndex]) and
    not ChargeTreeNode.Values[IsReceiverForeignColumn.ItemIndex];
     
end;

procedure TDocumentChargesFrame.ChangeChargeTextsForChargeNodes(
  ChargeTreeNodes: TList;
  const ChargeText: string
);
var NodePointer: Pointer;
    PreviousCurrentRecordBookmark: Pointer;
    ChargeTreeNode: TcxTreeListNode;
begin

  if not Assigned(ChargeTreeNodes) then Exit;

  PreviousCurrentRecordBookmark := ChargeSet.GetBookmark;

  try

    ChargeSet.DisableControls;

    for NodePointer in ChargeTreeNodes do begin

      ChargeTreeNode := TcxTreeListNode(NodePointer);

      if CanChangeChargeFieldForNode(ChargeTreeNode) then begin

        if  not
            ChargeSet.Locate(
              DataSetHolder.IdFieldName,
              ChargeTreeNode.Values[RecordIdColumn.ItemIndex],
              []
            )
        then Continue;

        DataSetHolder.ChargeTextFieldValue := ChargeText;

        MarkCurrentChargeRecordAsChanged_RefactorFuture;
                
      end;

    end;

  finally

    try

      if Assigned(PreviousCurrentRecordBookmark) and ChargeSet.BookmarkValid(PreviousCurrentRecordBookmark)
      then begin

        ChargeSet.GotoBookmark(PreviousCurrentRecordBookmark);
        ChargeSet.FreeBookmark(PreviousCurrentRecordBookmark);
        
      end;               

    finally

      ChargeSet.EnableControls;
      
    end;

  end;
  
end;

procedure TDocumentChargesFrame.ChangeChargeTextsForSelectedChargeNodes(const ChargeText: string);
begin

  ChangeChargeTextsForChargeNodes(DocumentReceiversTreeList.SelectionList, ChargeText);
  
end;

function TDocumentChargesFrame.ChargeSet: TDataSet;
begin

  if not Assigned(ViewModel) then begin

    Result := nil;
    Exit;

  end;

  if not Assigned(ViewModel.DocumentChargeSetHolder) then begin

    Result := nil;
    Exit;
    
  end;

  Result := ViewModel.DocumentChargeSetHolder.DataSet;
  

end;

procedure TDocumentChargesFrame.CopyUISettings(
  DocumentInformationFrame: TDocumentFlowInformationFrame);
var OtherDocumentChargesFrame: TDocumentChargesFrame;
begin

  if ClassType <> DocumentInformationFrame.ClassType then
    Exit;

  DebugOutput(ClassName);
  DebugOutput(DocumentInformationFrame.ClassName);
  
  OtherDocumentChargesFrame :=
    DocumentInformationFrame as TDocumentChargesFrame;
                {
  DocumentReceiversTreeList.Assign(
    OtherDocumentChargesFrame.DocumentReceiversTreeList
  );             }

  DocumentReceiversTreeList.DataController.DataSource := DataSource1;

  SelectChargeRecordByReceiverId(WorkingEmployeeId);
  
end;

constructor TDocumentChargesFrame.Create(AOwner: TComponent);
begin

  inherited;

  InitializeLayout;
  SubscribeOnEvents;

end;

function TDocumentChargesFrame.CreateDocumentChargePerformersReferenceForm: TDocumentChargePerformersReferenceForm;
begin

  { Controller !!! }
  Result :=
    TDocumentChargePerformersReferenceForm.Create(Self);

end;

function TDocumentChargesFrame.DataSetHolder: TDocumentChargeSetHolder;
begin

  if not Assigned(ViewModel) then
    Result := nil

  else
    Result := ViewModel.DocumentChargeSetHolder;

end;

destructor TDocumentChargesFrame.Destroy;
begin

  FreeAndNil(FReplaceableChargeRecordIds);
  inherited;

end;

procedure TDocumentChargesFrame.DocumentReceiverResolutionColumnPropertiesEditValueChanged(
  Sender: TObject
);
begin

  with DataSetHolder do begin

    if IdFieldValue < 0 then
      Exit;

    MarkCurrentChargeRecordAsChanged_RefactorFuture;

  end;

end;

procedure TDocumentChargesFrame.DocumentReceiversTreeListCustomDrawDataCell(
  Sender: TcxCustomTreeList; ACanvas: TcxCanvas;
  AViewInfo: TcxTreeListEditCellViewInfo; var ADone: Boolean);
begin

  if AViewInfo.Node.Focused or AViewInfo.Selected then begin

    ACanvas.Brush.Color := $00c56a31;
    ACanvas.Font.Color := $00ffffff;

  end;

end;

procedure TDocumentChargesFrame.DocumentReceiversTreeListEditValueChanged(
  Sender: TcxCustomTreeList;
  AColumn: TcxTreeListColumn
);
begin

  inherited;

  DataSource1.DataSet.Post;

  if not (ViewModel.DocumentChargeSetHolder.IdFieldValue < 0)
  then ViewModel.DocumentChargeSetHolder.MarkCurrentChargeRecordAsChanged;

end;

procedure TDocumentChargesFrame.DocumentReceiversTreeListSelectionChanged(
  Sender: TObject);
begin

  inherited;

  actChangeSelectedChargeTexts.Visible := CanChangeChargeFieldForAnyOfNodes(DocumentReceiversTreeList.SelectionList);

end;

function TDocumentChargesFrame.
  ValidateCurrentChargeRecordOrReplaceableChargeRecordFocusedIfNecessary: Boolean;
var ReplaceableChargeRecordIds: TVariantList;
    CurrentChargeRecordId: Variant;
    FocusedChargeRecordId: Variant;
begin
  
  ReplaceableChargeRecordIds :=
    FindReplaceableChargeRecordIdsByGivenReceiverId(WorkingEmployeeId);

  try

    if ReplaceableChargeRecordIds.IsEmpty then begin

      Result := True;
      Exit;

    end;

    CurrentChargeRecordId := FindRecordIdByReceiverId(WorkingEmployeeId);

    if VarIsNull(CurrentChargeRecordId) and
       (ReplaceableChargeRecordIds.Count = 1)
    then begin

      Result := True;
      Exit;

    end;

    FocusedChargeRecordId :=
      DocumentReceiversTreeList.FocusedNode.Values[
        RecordIdColumn.ItemIndex
      ];

    Result :=

       (not VarIsNull(FocusedChargeRecordId)) and
       ((FocusedChargeRecordId = CurrentChargeRecordId) or
       (ReplaceableChargeRecordIds.Contains(FocusedChargeRecordId)));

    if not Result then
      ShowWarningMessage(
        Self.Handle,
        'Вам доступно более одного поручения. ' +
        'Выберите нужное поручение и повторите ' +
        'действие',
        'Сообщение'
      );
      
  finally

    FreeAndNil(ReplaceableChargeRecordIds);
    
  end;
  
end;

function TDocumentChargesFrame.ValidateFocusedChargeRecordNotPerformed: Boolean;
begin

  if not
     VarIsNull(
        DocumentReceiversTreeList.FocusedNode.Values[
          PerformingDateTimeColumn.ItemIndex
        ]
     )

  then begin

    ShowWarningMessage(
      Self.Handle,
      'Выбранное поручение уже исполнено !',
      'Сообщение'
    );

    Result := False;

  end

  else Result := True;

end;

function TDocumentChargesFrame.FindRecordIdByReceiverId(
  const ReceiverId: Variant
): Variant;
var Bookmark: Pointer;
    PreviousFilter: String;
    LookupResult: Variant;
begin

  with DataSetHolder do begin

    LookupResult :=
      Dataset.Lookup(ReceiverIdFieldName, ReceiverId, IdFieldName);

    if VarIsEmpty(LookupResult) then
      Result := Null

    else Result := LookupResult;
          
  end;

end;

function TDocumentChargesFrame.FindReplaceableChargeRecordIdsByGivenReceiverId(
  const ReceiverId: Variant): TVariantList;
var Bookmark: Pointer;
    PreviousFilter: String;
    Node: TcxDBTreeListNode;
    I: Integer;
begin

  Result := TVariantList.Create;

  for I := 0 to DocumentReceiversTreeList.AbsoluteCount - 1 do begin

    Node := TcxDBTreeListNode(DocumentReceiversTreeList.AbsoluteItems[I]);

    if Node.Values[IsAccessbleChargeColumn.ItemIndex]
    then Result.Add(Node.Values[RecordIdColumn.ItemIndex])

    else if Node.Values[IsAccessbleChargeColumn.ItemIndex]
    then Result.Add(Node.Values[RecordIdColumn.ItemIndex]);

  end;
  
end;

procedure TDocumentChargesFrame.FrameResize(Sender: TObject);
begin

  inherited;

  DocumentReceiversTreeList.Height :=
    Height - DocumentReceiversTreeList.Top - 7;

  DocumentReceiversTreeList.Width :=
    Width - DocumentReceiversTreeList.Left - 7;
    
end;

function TDocumentChargesFrame.GetAddingChargeToolVisible: Boolean;
begin

  Result := AddDocumentReceiverButton.Visible;

end;

function TDocumentChargesFrame.GetRemovingChargeToolVisible: Boolean;
begin

  Result := RemoveDocumentReceiverButton.Visible;
  
end;

function TDocumentChargesFrame.
  GetDocumentChargePerformerSetHolder: TEmployeeSetHolder;
var
    DocumentChargePerformerSetReadService: IDocumentChargePerformerSetReadService;
begin

  DocumentChargePerformerSetReadService :=
    TApplicationServiceRegistries.
    Current.
    GetPresentationServiceRegistry.
    GetDocumentChargePerformerSetReadService(ServiceDocumentKind);

  Result :=
    DocumentChargePerformerSetReadService.
      FindAllPossibleDocumentChargePerformerSetForEmployee(
        WorkingEmployeeId
      );
      
end;

function TDocumentChargesFrame.GetHorizontalScrollingMinWidth: Integer;
begin

  Result := inherited GetHorizontalScrollingMinWidth;
  
end;

function TDocumentChargesFrame.GetInputFieldTextForm(
  const Caption: String;
  const InputFieldText: string;
  var Accepted: Boolean
): String;
var InputTextFieldForm: TDocumentFlowSystemInputMemoForm;
begin

  with TDocumentFlowSystemInputMemoForm.Create(nil, Caption) do begin

    try

      InputText := InputFieldText;
      
      if ShowModal = mrOk then begin

        Result := InputText;
        Accepted := True;

      end

      else begin

        Result := '';
        Accepted := False;
        
      end;

    finally

      Free;
      
    end;

  end;

end;

function TDocumentChargesFrame.GetIsAllChargesPerformedByWorkingEmployee: Boolean;
var LocalWorkingEmployeeChargeCount,
    LocalWorkingEmployeePerformedChargeCount: Integer;
begin

  LocalWorkingEmployeeChargeCount := WorkingEmployeeChargeCount;
  LocalWorkingEmployeePerformedChargeCount :=
    WorkingEmployeePerformedChargeCount;

  Result :=
    LocalWorkingEmployeeChargeCount =
    LocalWorkingEmployeePerformedChargeCount;
    
end;

function TDocumentChargesFrame.GetReplaceableReceiverCountForReceiver(
  const ReceiverId: Variant): Integer;
var ReplaceableChargeRecordIds: TVariantList;
begin

  ReplaceableChargeRecordIds :=
    FindReplaceableChargeRecordIdsByGivenReceiverId(ReceiverId);

  try

    Result := ReplaceableChargeRecordIds.Count;
    
  finally

    FreeAndNil(ReplaceableChargeRecordIds);
    
  end;

end;

function TDocumentChargesFrame.GetSameChargeTextFromChargeNodes(
  ChargeNodes: TList): String;
var ChargeText: String;
    NodePointer: Pointer;
    ChargeNode: TcxTreeListNode;
begin

  for NodePointer in ChargeNodes do begin

    ChargeNode := TcxTreeListNode(NodePointer);

    if not CanChangeChargeFieldForNode(ChargeNode) then Continue;

    if not VarIsNull(ChargeNode.Values[DocumentChargeTextColumn.ItemIndex]) then
      ChargeText := ChargeNode.Values[DocumentChargeTextColumn.ItemIndex]

    else ChargeText := '';

    if Result = '' then
      Result := ChargeText;

    if Result <> ChargeText then begin

      Result := '';
      Exit;
      
    end;

  end;

end;

procedure TDocumentChargesFrame.UpdateByViewModel(
  const ViewModel: TDocumentChargesFormViewModel
);
begin

  SubscribeOnDocumentReceiversViewDataSetDataEvents;
  
  DataSource1.DataSet := DataSetHolder.DataSet;

end;

procedure TDocumentChargesFrame.UpdateDocumentChargeControlPanel;
begin

  UpdateDocumentChargeControlPanelVisibility;
  ReLayoutDocumentChargeControlPanel;
    
end;

procedure TDocumentChargesFrame.UpdateDocumentChargeControlPanelVisibility;
begin

  ReceiverControlToolPanel.Visible :=
    AddingChargeToolVisible or RemovingChargeToolVisible;
    
end;

function TDocumentChargesFrame.GetVerticalScrollingMinHeight: Integer;
begin

  Result := 262;

end;

function TDocumentChargesFrame.GetViewModel: TDocumentChargesFormViewModel;
begin

  Result := FViewModel;

end;

function TDocumentChargesFrame.GetViewModelClass: TDocumentChargesFormViewModelClass;
begin

  Result := TDocumentChargesFormViewModel;

end;

function TDocumentChargesFrame.GetViewOnly: Boolean;
begin

  Result := inherited GetViewOnly;
  
end;

function TDocumentChargesFrame.GetWorkingEmployeeChargeCount: Integer;
var ReplaceableChargeRecordIds: TVariantList;
begin

  if not VarIsNull(FindRecordIdByReceiverId(WorkingEmployeeId)) then
    Inc(Result);
  
  ReplaceableChargeRecordIds :=
   FindReplaceableChargeRecordIdsByGivenReceiverId(WorkingEmployeeId);

  try

    Inc(Result, ReplaceableChargeRecordIds.Count);
    
  finally

    FreeAndNil(ReplaceableChargeRecordIds);

  end;

end;

function TDocumentChargesFrame.GetWorkingEmployeePerformedChargeCount: Integer;
var WorkingEmployeeRecordId: Variant;
    RecordNode: TcxDBTreeListNode;
    ReplaceableChargeRecordIds: TVariantList;
    RecordId: Variant;
begin

  WorkingEmployeeRecordId :=
    FindRecordIdByReceiverId(WorkingEmployeeId);

  if not VarIsNull(WorkingEmployeeRecordId) then begin

    RecordNode :=
      DocumentReceiversTreeList.FindNodeByKeyValue(WorkingEmployeeRecordId);

    if not VarIsNull(RecordNode.Values[PerformingDateTimeColumn.ItemIndex])

    then Inc(Result);
    
  end;

  ReplaceableChargeRecordIds :=
    FindReplaceableChargeRecordIdsByGivenReceiverId(
      WorkingEmployeeId
    );

  try

    for RecordId in ReplaceableChargeRecordIds do begin

      RecordNode :=
        DocumentReceiversTreeList.FindNodeByKeyValue(RecordId);

      if not VarIsNull(RecordNode.Values[PerformingDateTimeColumn.ItemIndex])

      then Inc(Result);

    end;
    
  finally

    FreeAndNil(ReplaceableChargeRecordIds);
    
  end;

end;

procedure TDocumentChargesFrame.HandleChangeSelectedChargeTextsAction;
var Accepted: Boolean;
    ChargeText: String;
begin

  ChargeText := GetSameChargeTextFromChargeNodes(DocumentReceiversTreeList.SelectionList);

  ChargeText := GetInputFieldTextForm('Текст поручения', ChargeText, Accepted);

  if  Accepted then
    ChangeChargeTextsForSelectedChargeNodes(ChargeText);

end;

procedure TDocumentChargesFrame.SetViewModel(
  ViewModel: TDocumentChargesFormViewModel
);
begin

  FViewModel := ViewModel;

  SetTableColumnLayout(FViewModel.DocumentChargeSetHolder.FieldDefs);

  UpdateByViewModel(FViewModel);

end;

procedure TDocumentChargesFrame.SetViewOnly(const Value: Boolean);
begin

  inherited;

  DocumentReceiversTreeList.OptionsData.Editing := not Value;

  if Value then begin

    ReceiverControlToolPanel.BevelKind := bkNone;

  end

  else begin

    ReceiverControlToolPanel.BevelKind := bkFlat;
    ReceiverControlToolPanel.BevelEdges := [beTop];
    ReceiverControlToolPanel.BevelInner := bvNone;
    ReceiverControlToolPanel.BevelOuter := bvNone;
    
  end;

  if Value then
    DocumentReceiversTreeList.PopupMenu := nil

  else
    DocumentReceiversTreeList.PopupMenu := ChargeRecordsHandlingPopupMenu;

  actAddReceivers.Enabled := not Value;
  actRemoveSelectedReceivers.Enabled := not Value;

  if Value then
    ReceiverControlToolPanel.Visible := False

  else ReceiverControlToolPanel.Visible := True;

end;

procedure TDocumentChargesFrame.SubscribeOnDocumentReceiversViewDataSetDataEvents;
begin

  DataSetHolder.DataSet.AfterPost := OnDocumentReceiverChangedEventHandler;

  DataSetHolder.DataSet.AfterDelete := OnDocumentReceiverRemovedEventHandler;
    
end;

procedure TDocumentChargesFrame.SubscribeOnEvents;
begin

  { Refactor: создать контроллер для данного фрейма
    и перенести логику подписки на события в него,
    а также логику обработки пользовательского ввода
  }
  FOnDocumentChargePerformersReferenceRequestedEventHandler :=
    OnSelfDocumentChargePerformersReferenceRequestedEventHandler;
    
end;

procedure TDocumentChargesFrame.UpdateOwnRecordIdAndReplaceableChargeRecordIds;
begin

  FOwnRecordId := FindRecordIdByReceiverId(WorkingEmployeeId);

  FreeAndNil(FReplaceableChargeRecordIds);

  FReplaceableChargeRecordIds :=
    FindReplaceableChargeRecordIdsByGivenReceiverId(WorkingEmployeeId);
    
end;

procedure TDocumentChargesFrame.Initialize;
begin

  inherited;

  EnableScrolling := False;
  
end;

procedure TDocumentChargesFrame.InitializeLayout;
begin

  AddDocumentReceiverButton.Colors.Default := DEFAULT_BACKGROUND_BUTTON_COLOR;
  RemoveDocumentReceiverButton.Colors.Default := DEFAULT_BACKGROUND_BUTTON_COLOR;

end;

function TDocumentChargesFrame.IsDataChanged: Boolean;
begin

  Result :=
    Assigned(FViewModel) and 
    ViewModel.
      DocumentChargeSetHolder.
        AreChargeRecordChangesExisting;

end;

function TDocumentChargesFrame.IsDocumentReceiverDataAlreadyAdded(
  const EmployeeId: Variant): Boolean;
var LookupResult: Variant;
begin

  LookupResult :=
    DataSetHolder.
        DataSet.
          Lookup(
            DataSetHolder.ReceiverIdFieldName,
            EmployeeId,
            DataSetHolder.ReceiverIdFieldName
          );
          
  Result :=
    not VarIsNull(LookupResult) and not VarIsEmpty(LookupResult);

end;

function TDocumentChargesFrame.IsDocumentChargeRecordAboutWorkingEmployee(
  SelectedDocumentReceiverNode: TcxTreeListNode
): Boolean;
var WorkingEmployeeRecordId: Variant;
    RecordIdFieldIndex: Integer;
begin

  WorkingEmployeeRecordId := FindRecordIdByReceiverId(WorkingEmployeeId);

  RecordIdFieldIndex :=
    DocumentReceiversTreeList.GetColumnByFieldName(
      DataSetHolder.IdFieldName
    ).ItemIndex;
                        
  Result := SelectedDocumentReceiverNode.Values[RecordIdFieldIndex] =
            WorkingEmployeeRecordId;
            
end;

function TDocumentChargesFrame.IsDataSetHolderAssigned: Boolean;
begin

  Result := Assigned(FViewModel) and Assigned(FViewModel.DocumentChargeSetHolder);
  
end;

function TDocumentChargesFrame.IsOwnOrReplaceableChargeNode(
  ChargeTreeNode: TcxTreeListNode): Boolean;
var ReplaceableChargeIds: TVariantList;
begin

  ReplaceableChargeIds := FindReplaceableChargeRecordIdsByGivenReceiverId(WorkingEmployeeId);

  try

    Result :=
      (ChargeTreeNode.Values[RecordIdColumn.ItemIndex] = FindRecordIdByReceiverId(WorkingEmployeeId)) or
      ReplaceableChargeIds.Contains(ChargeTreeNode.Values[RecordIdColumn.ItemIndex]);

  finally

    FreeAndNil(ReplaceableChargeIds);
    
  end;

end;

function TDocumentChargesFrame.IsReceiverDeputyForOtherOrViceVersa(
  const TargetReceiverId, OtherReceiverId: Variant): Boolean;
var ReplaceableReceiverIds: TVariantList;
    OtherChargeRecordId: Variant;
begin

  ReplaceableReceiverIds :=
    FindReplaceableChargeRecordIdsByGivenReceiverId(TargetReceiverId);

  try

    OtherChargeRecordId :=
      FindRecordIdByReceiverId(OtherReceiverId);

    Result := ReplaceableReceiverIds.Contains(OtherChargeRecordId);
    
  finally

    FreeAndNil(ReplaceableReceiverIds);
    
  end;

end;

function TDocumentChargesFrame.IsSubordinateChargeNode(
  ChargeTreeNode: TcxTreeListNode): Boolean;
var TopLevelChargeId: Variant;
    OwnChargeId: Variant;
    AccessibleChargeIds: TVariantList;
begin

  TopLevelChargeId := ChargeTreeNode.Values[TopLevelChargeIdColumn.ItemIndex];

  if VarIsNull(TopLevelChargeId) then begin

    Result := False;
    Exit;

  end;

  OwnChargeId := FindRecordIdByReceiverId(WorkingEmployeeId);

  AccessibleChargeIds := FindReplaceableChargeRecordIdsByGivenReceiverId(WorkingEmployeeId);

  try

    Result := (OwnChargeId = TopLevelChargeId) or AccessibleChargeIds.Contains(TopLevelChargeId);

  finally

    FreeAndNil(AccessibleChargeIds);

  end;

end;

procedure TDocumentChargesFrame.MarkChargeNodeAsChanged(
  ChargeTreeNode: TcxTreeListNode);
begin

  if not (ChargeTreeNode.Values[RecordIdColumn.ItemIndex] < 0) then begin

    ChargeTreeNode.Values[RecordStatusColumn.ItemIndex] :=
      DataSetHolder.ChargeRecordChangedStatusValue;

  end;

end;

procedure TDocumentChargesFrame.MarkCurrentChargeRecordAsChanged_RefactorFuture;
begin

  with DataSetHolder do begin

    if not (IdFieldValue < 0) then
      MarkCurrentChargeRecordAsChanged;

  end;

end;

function TDocumentChargesFrame.IsDocumentPerformingDateTimeAbsent(
  SelectedDocumentReceiverNode: TcxTreeListNode): Boolean;
var PerformingDateTime: Variant;
begin                                       

  PerformingDateTime :=
    SelectedDocumentReceiverNode.Values[
      DocumentReceiversTreeList.GetColumnByFieldName(
        DataSetHolder.
          ReceiverPerformingDateTimeFieldName
      ).ItemIndex
    ];

  Result := VarIsNull(PerformingDateTime);

end;

procedure TDocumentChargesFrame.
  OnDocumentChargePerformerRecordsRefreshRequestedEventHandler(
    Sender: TObject
  );
var DocumentChargePerformersReferenceForm: TDocumentChargePerformersReferenceForm;
begin

  try

    Screen.Cursor := crHourGlass;

    DocumentChargePerformersReferenceForm :=
      Sender as TDocumentChargePerformersReferenceForm;

    DocumentChargePerformersReferenceForm.DataSetHolder :=
      GetDocumentChargePerformerSetHolder;

  finally

    Screen.Cursor := crDefault;

  end;

end;

procedure TDocumentChargesFrame.OnDocumentReceiverChangedEventHandler(
  DataSet: TDataSet);
begin

  FIsDocumentChargeSetChanged := True;

end;

procedure TDocumentChargesFrame.OnDocumentReceiverRemovedEventHandler(
  DataSet: TDataSet);
begin

  FIsDocumentChargeSetChanged := True;

end;

procedure TDocumentChargesFrame.
  OnSelfDocumentChargePerformersReferenceRequestedEventHandler(
    Sender: TObject;
    var DocumentChargePerformersReference: TEmployeesReferenceForm
  );
begin

  try

    Screen.Cursor := crHourGlass;
    
    DocumentChargePerformersReference :=
      CreateDocumentChargePerformersReferenceForm;

    DocumentChargePerformersReference.
      OnEmployeeRecordsRefreshRequestedEventHandler :=
        OnDocumentChargePerformerRecordsRefreshRequestedEventHandler;

    DocumentChargePerformersReference.DataSetHolder :=
      GetDocumentChargePerformerSetHolder;

  finally

    Screen.Cursor := crDefault;
    
  end;

end;

procedure TDocumentChargesFrame.RefreshChargeRecords;
begin

  ViewModel.DocumentChargeSetHolder.RefreshChargeRecords;
  
  SelectChargeRecordByReceiverId(WorkingEmployeeId);
  
end;

procedure TDocumentChargesFrame.ReLayoutDocumentChargeControlPanel;
begin

  ApplyHorizontalLayoutToControls(
    [AddDocumentReceiverButton, RemoveDocumentReceiverButton], 10
  );
  
end;

procedure TDocumentChargesFrame.RemoveChoosenDocumentReceivers;
var I: Integer;
    SelectedDocumentReceiverNode: TcxTreeListNode;
    RemovableDocumentReceiverNodes: TList;
    IsDisAllowedRemovingAttemptRaised: Boolean;

  procedure DeleteDocumentReceiverNodes(
    RemovableDocumentReceiverNodeList: TList
  );
  var RemovableDocumentReceiverNode: TcxTreeListNode;
      AddedRemovableDocumentReceiverBookmarks: TVariantList;
      Bookmark: Variant;
      I: Integer;
  begin

    AddedRemovableDocumentReceiverBookmarks := nil;

    try

      with DataSetHolder do begin

        DisableControls;

        AddedRemovableDocumentReceiverBookmarks := TVariantList.Create;

        for I := 0 to RemovableDocumentReceiverNodeList.Count - 1 do begin

          RemovableDocumentReceiverNode := RemovableDocumentReceiverNodeList[I];

          Locate(
            IdFieldName,
            RemovableDocumentReceiverNode.Values[
              DocumentReceiversTreeList.GetColumnByFieldName(
                IdFieldName
              ).ItemIndex
            ],
            []
          );

          if IdFieldValue < 0 then
            AddedRemovableDocumentReceiverBookmarks.Add(IdFieldValue)
          else begin

            MarkCurrentChargeAndAllSubordinateChargeRecordsAsRemoved;

          end;

        end;

        for Bookmark in AddedRemovableDocumentReceiverBookmarks do begin

          Locate(IdFieldName, Bookmark, []);
          Delete;

        end;

        RevealNonRemovedChargeRecords;

        EnableControls;

      end;

    finally

      FreeAndNil(AddedRemovableDocumentReceiverBookmarks);

    end;
    
  end;

begin

  RemovableDocumentReceiverNodes := TList.Create;

  try

    IsDisAllowedRemovingAttemptRaised := False;

    with DataSetHolder do begin

      DisableControls;

      for I := 0 to DocumentReceiversTreeList.SelectionCount - 1 do begin

        SelectedDocumentReceiverNode := DocumentReceiversTreeList.Selections[I];

        if
           (
             WasDocumentChargeRecordAddedByWorkingEmployee(
                SelectedDocumentReceiverNode
             ){ or
             WasDocumentChargeRecordAddedBySubordinateOfWorkingEmployee(
                SelectedDocumentReceiverNode
             )   }
           ) and
           IsDocumentPerformingDateTimeAbsent(
              SelectedDocumentReceiverNode
           )
        then begin

          RemovableDocumentReceiverNodes.Add(SelectedDocumentReceiverNode);

        end

        else begin

          IsDisAllowedRemovingAttemptRaised := True;

        end;

      end;

    end;

    DeleteDocumentReceiverNodes(RemovableDocumentReceiverNodes);

    DataSetHolder.
      RevealNonRemovedChargeRecords;
    
    if IsDisAllowedRemovingAttemptRaised then
      ShowWarningMessage(
        Self.Handle,
        'Некоторые из получателей не были отозваны, ' +
        'поскольку Вы не являетесь отправителем для них, ' +
        'или они уже исполнили поручения',
        'Замечание'
      );

  finally

    FreeAndNil(RemovableDocumentReceiverNodes);
    DataSetHolder.EnableControls;

  end;

end;

procedure TDocumentChargesFrame.RestoreUIControlProperties;
begin

  inherited;

end;

procedure TDocumentChargesFrame.OnChangesApplied;
begin

  if not IsDataSetHolderAssigned then
    Exit;

  DataSetHolder.MarkAllRecordsAsCommited;

end;

procedure TDocumentChargesFrame.OnChangesApplyingFailed;
begin

  if not IsDataSetHolderAssigned then
    Exit;

  DataSetHolder.MarkRemovedChargeRecordsAsNonChanged;
  DataSetHolder.RevealNonRemovedChargeRecords;

end;

procedure TDocumentChargesFrame.SaveUIControlProperties;
begin

  inherited;

end;

procedure TDocumentChargesFrame.SelectChargeRecordByReceiverId(
  const ReceiverId: Variant);
var RecordId: Variant;
    ReplaceableChargeRecordIds: TVariantList;
begin

  if not IsDataSetHolderAssigned then
    Exit;

  with DataSetHolder do begin

    if Assigned(DataSet) and DataSet.Active
    then  begin

      RecordId := FindRecordIdByReceiverId(ReceiverId);

      if VarIsNull(RecordId) then begin

        ReplaceableChargeRecordIds :=
          FindReplaceableChargeRecordIdsByGivenReceiverId(ReceiverId);
          
        if not ReplaceableChargeRecordIds.IsEmpty then
          RecordId := ReplaceableChargeRecordIds[0];

        ReplaceableChargeRecordIds.Destroy;
        
      end;

      if not VarIsNull(RecordId) then
        Locate(IdFieldName, RecordId, []);

      if Assigned(DocumentReceiversTreeList.FocusedNode) then
        DocumentReceiversTreeList.FocusedNode.Expand(True);

    end;

  end;
  
end;

procedure TDocumentChargesFrame.SetAddingChargeToolVisible(
  const Value: Boolean);
begin

  AddDocumentReceiverButton.Visible := Value;

  UpdateDocumentChargeControlPanel;

end;

procedure TDocumentChargesFrame.SetRemovingChargeToolVisible(
  const Value: Boolean);
begin

  RemoveDocumentReceiverButton.Visible := Value;

  UpdateDocumentChargeControlPanel;
  
end;

procedure TDocumentChargesFrame.SetEnabled(Value: Boolean);
begin

  inherited;

end;

procedure TDocumentChargesFrame.SetIgnorableViewOnlyControls(Controls: TList);
begin

  Controls.Add(DocumentReceiversTreeList);

end;

procedure TDocumentChargesFrame.SetTableColumnLayout(
  FieldDefs: TDocumentChargeSetFieldDefs);
begin

  DocumentChargeTextColumn.DataBinding.FieldName := FieldDefs.ChargeTextFieldName;
  DocumentReceiverResolutionColumn.DataBinding.FieldName := FieldDefs.ReceiverCommentFieldName;
  IsAccessbleChargeColumn.DataBinding.FieldName := FieldDefs.IsAccessibleChargeFieldName;
  IsForAcquaitanceColumn.DataBinding.FieldName := FieldDefs.IsChargeForAcquaitanceFieldName;
  IsReceiverForeignColumn.DataBinding.FieldName := FieldDefs.IsReceiverForeignFieldName;
  IssuingDateTimeColumn.DataBinding.FieldName := FieldDefs.ChargeSheetIssuingDateTimeFieldName;
  PerformedEmployeeNameColumn.DataBinding.FieldName := FieldDefs.PerformedChargeEmployeeNameFieldName;
  PerformingDateTimeColumn.DataBinding.FieldName := FieldDefs.ReceiverPerformingDateTimeFieldName;
  ReceiverDepartmentColumn.DataBinding.FieldName := FieldDefs.ReceiverDepartmentNameFieldName;
  ReceiverDocumentIdColumn.DataBinding.FieldName := FieldDefs.ReceiverDocumentIdFieldName;
  ReceiverFullNameColumn.DataBinding.FieldName := FieldDefs.ReceiverFullNameFieldName;
  ReceiverIdColumn.DataBinding.FieldName := FieldDefs.ReceiverIdFieldName;
  ReceiverLeaderIdColumn.DataBinding.FieldName := FieldDefs.ReceiverLeaderIdFieldName;
  ReceiverSpecialityColumn.DataBinding.FieldName := FieldDefs.ReceiverSpecialityFieldName;
  RecordIdColumn.DataBinding.FieldName := FieldDefs.IdFieldName;
  RecordStatusColumn.DataBinding.FieldName := FieldDefs.RecordStatusFieldName;
  TopLevelChargeIdColumn.DataBinding.FieldName := FieldDefs.TopLevelChargeSheetIdFieldName;
  ViewingDateByPerformerColumn.DataBinding.FieldName := FieldDefs.ViewingDateByPerformerFieldName;
  
  DocumentReceiversTreeList.DataController.KeyField := FieldDefs.IdFieldName;
  DocumentReceiversTreeList.DataController.ParentField := FieldDefs.TopLevelChargeSheetIdFieldName;
  
end;

function TDocumentChargesFrame.WasDocumentChargeRecordAddedBySubordinateOfWorkingEmployee(
  SelectedDocumentReceiverNode: TcxTreeListNode
): Boolean;
var TopLevelDocumentReceiverNode: TcxTreeListNode;
begin

  TopLevelDocumentReceiverNode := SelectedDocumentReceiverNode.Parent;

  while Assigned(TopLevelDocumentReceiverNode) do begin

    if WasDocumentChargeRecordAddedByWorkingEmployeeInPast(
          TopLevelDocumentReceiverNode
       )
    then begin

      Result := True;
      Exit;

    end;

    TopLevelDocumentReceiverNode := TopLevelDocumentReceiverNode.Parent;

  end;

  Result := False;

end;

function TDocumentChargesFrame.WasDocumentChargeRecordAddedByWorkingEmployee(
  SelectedDocumentReceiverNode: TcxTreeListNode
): Boolean;
var RecordIdFieldIndex: Integer;
    WasDocumentChargeRecordAddedEarlier,
    WasDocumentChargeRecordAddedInPast: Boolean;
begin

   RecordIdFieldIndex :=
    DocumentReceiversTreeList.GetColumnByFieldName(
      DataSetHolder.IdFieldName
    ).ItemIndex;

   WasDocumentChargeRecordAddedEarlier :=
    SelectedDocumentReceiverNode.Values[RecordIdFieldIndex] < 0;

   WasDocumentChargeRecordAddedInPast :=
     WasDocumentChargeRecordAddedByWorkingEmployeeInPast(
        SelectedDocumentReceiverNode
     );

   Result :=
    WasDocumentChargeRecordAddedEarlier or
    WasDocumentChargeRecordAddedInPast;

end;

function TDocumentChargesFrame.WasDocumentChargeRecordAddedByWorkingEmployeeInPast(
  SelectedDocumentReceiverNode: TcxTreeListNode): Boolean;
begin

  Result := True;
  
end;

procedure TDocumentChargesFrame.WndProc(var Message: TMessage);
begin

  if Message.Msg = WM_PAINT then begin

    if not IsDataSetHolderAssigned then begin

      inherited;
      Exit;

    end;

    if not FIsAlreadyShowed then begin

      //RefreshChargeRecords;

      FIsAlreadyShowed := True;

    end;

  end;
  
  inherited;

end;

end.
