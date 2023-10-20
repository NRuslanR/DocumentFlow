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
  Disposable,
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
    ChargeTreeList: TcxDBTreeList;
    AddChargesButton: TcxButton;
    RemoveChargesButton: TcxButton;
    PerformerFullNameColumn: TcxDBTreeListColumn;
    PerformerSpecialityColumn: TcxDBTreeListColumn;
    PerformerDepartmentNameColumn: TcxDBTreeListColumn;
    ChargeSetSource: TDataSource;
    PerformerResolutionColumn: TcxDBTreeListColumn;
    PerformerIdColumn: TcxDBTreeListColumn;
    IdColumn: TcxDBTreeListColumn;
    PerformingDateTimeColumn: TcxDBTreeListColumn;
    RecordStatusColumn: TcxDBTreeListColumn;
    ChargeRecordsHandlingPopupMenu: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    IsPerformerForeignColumn: TcxDBTreeListColumn;
    PerformedEmployeeNameColumn: TcxDBTreeListColumn;
    IsForAcquaitanceColumn: TcxDBTreeListColumn;
    ChargeActionList: TActionList;
    actChangeSelectedChargeTexts: TAction;
    N3: TMenuItem;
    ChargeTextColumn: TcxDBTreeListColumn;
    PerformerControlToolPanel: TPanel;
    actAddCharges: TAction;
    actRemoveSelectedCharges: TAction;
    {
    procedure DocumentPerformerResolutionColumnPropertiesEditValueChanged(
      Sender: TObject);                  }
    procedure actAddChargesExecute(Sender: TObject);
    procedure actRemoveSelectedChargesExecute(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure ChargeTreeListCustomDrawDataCell(
      Sender: TcxCustomTreeList; ACanvas: TcxCanvas;
      AViewInfo: TcxTreeListEditCellViewInfo; var ADone: Boolean);
    procedure ChargeTreeListEditValueChanged(
      Sender: TcxCustomTreeList; AColumn: TcxTreeListColumn);
    procedure ChargeTreeListSelectionChanged(Sender: TObject);
    procedure actChangeSelectedChargeTextsExecute(Sender: TObject);

  private

  protected

    FIsAlreadyShowed: Boolean;
    FIsDocumentChargeSetChanged: Boolean;

    FViewModel: TDocumentChargesFormViewModel;
    FFreeViewModel: IDisposable;

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

    { refactor: RecordProcessor similar DocumentsReferenceForm's processor add and inject for this and ChargeSheetsFrame }
    function CreateDocumentChargePerformersReferenceForm: TDocumentChargePerformersReferenceForm; virtual;

    function GetDocumentChargePerformerSetHolder: TEmployeeSetHolder; virtual;

    procedure WndProc(var Message: TMessage); override;

    function GetHorizontalScrollingMinWidth: Integer; override;
    function GetVerticalScrollingMinHeight: Integer; override;

    procedure OnChargeSetChangedEventHandler(
      DataSet: TDataSet
    );

    procedure OnChargeSetRecordRemovedEventHandler(
      DataSet: TDataSet
    );

    procedure SubscribeOnChargeSetDataEvents;

    procedure Initialize; override;
    procedure InitializeLayout; virtual;
    procedure SetEnabled(Value: Boolean); override;
    
    procedure AddChargesForPerformersFromEmployeesReference;

    procedure AddChargesForPerformersFromEmployeesReferenceRecords(
      SelectedEmployeeRecords: TEmployeesReferenceFormRecords
    );

    function IsDocumentPerformerRecordAlreadyExists(
      const EmployeeId: Variant
    ): Boolean;

    { refactor: RecordProcessor similar DocumentsReferenceForm's processor add and inject for this and ChargeSheetsFrame }
    function AddChargeForPerformerFromEmployeeReferenceRecord(
      SelectedEmployeeRecord: TEmployeesReferenceFormRecord;
      var ErrorMessage: String
    ): Boolean; virtual;

    function CanChoosePerformersForChargeIssuing(
      var ErrorMessage: String
    ): Boolean; virtual;
    
    function CanIssueChargeForPerformer(
      const EmployeeRecord: TEmployeesReferenceFormRecord;
      var ErrorMessage: String
    ): Boolean; virtual;

    procedure InternalSetChargeRecordFieldsFromEmployeeReferenceRecord(
      SelectedEmployeeRecord: TEmployeesReferenceFormRecord
    );  virtual;

    procedure SetCurrentRecordAccessRightsFieldValues; virtual;

    procedure RemoveChoosenCharges;
    
    function FindRecordIdByPerformer(const PerformerId: Variant): Variant;

    function FindAccessibleChargeRecordIdsByPerformer(
      const PerformerId: Variant
    ): TVariantList;

    { refactor }

    function IsRecordAccessible(const RecordId: Variant): Boolean; virtual;
    function IsRecordRemoveable(const RecordId: Variant): Boolean;

    { refactor: RecordProcessor similar DocumentsReferenceForm's processor add and inject for this and ChargeSheetsFrame }
    function GetAccessibleRecordFieldNames: String; virtual;
    function GetCanRecordRemoveFieldName: String; virtual;

    function ValidateAccessibleChargeRecordFocused: Boolean;
    function ValidateFocusedChargeRecordNotPerformed: Boolean;

    procedure UpdateByViewModel(const ViewModel: TDocumentChargesFormViewModel);

    function DataSetHolder: TDocumentChargeSetHolder;
    function IsDataSetHolderAssigned: Boolean;

    procedure MarkCurrentChargeRecordAsRemovedOrDeleteIfIdIsGenerated; virtual;

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

    function IsAccessibleChargeNode(ChargeTreeNode: TcxTreeListNode): Boolean;

    function CanChangeChargeFieldForNode(ChargeTreeNode: TcxTreeListNode): Boolean;
    function CanChangeChargeTextRecordField(const RecordId: Variant): Boolean;
    function CanChangeCommentFieldForNode(ChargeTreeNode: TcxTreeListNode): Boolean;

    function CanPerformerCommentBeChangedFieldName: String; virtual;
    function CanChargeTextBeChangedFieldName: String; virtual;

    function GetInputFieldTextForm(
      const Caption: String;
      const InputFieldText: string;
      var Accepted: Boolean
    ): String;

  protected

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

    procedure OnChangesApplied; override;
    procedure OnChangesApplyingFailed; override;
    function IsDataChanged: Boolean; override;

    procedure SelectRecordByPerformer(
      const PerformerId: Variant
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

  StrUtils,
  VariantFunctions,
  AuxDebugFunctionsUnit,
  AuxWindowsFunctionsUnit,
  WorkingEmployeeUnit,
  AuxDataSetFunctionsUnit,
  ApplicationServiceRegistries,
  EmployeeSetReadService,
  AbstractDataSetHolder;
  
{$R *.dfm}

{ TDocumentChargesFrame }

procedure TDocumentChargesFrame.actAddChargesExecute(Sender: TObject);
begin

  AddChargesForPerformersFromEmployeesReference;

end;

procedure TDocumentChargesFrame.actChangeSelectedChargeTextsExecute(Sender: TObject);
begin

  HandleChangeSelectedChargeTextsAction;
  
end;

procedure TDocumentChargesFrame.actRemoveSelectedChargesExecute(
  Sender: TObject);
begin

  RemoveChoosenCharges;

end;

procedure TDocumentChargesFrame.AddChargesForPerformersFromEmployeesReference;
var
    EmployeesReferenceForm: TEmployeesReferenceForm;
    ErrorMessage: String;
begin

  if
    not Assigned(
      FOnDocumentChargePerformersReferenceRequestedEventHandler
    )
  then Exit;

  if not CanChoosePerformersForChargeIssuing(ErrorMessage) then
  begin

    ShowWarningMessage(
      Self.Handle,
      ErrorMessage,
      'Сообщение'
    );

    Exit;

  end;
  
  EmployeesReferenceForm := nil;

  FOnDocumentChargePerformersReferenceRequestedEventHandler(
    Self,
    EmployeesReferenceForm
  );

  if not Assigned(EmployeesReferenceForm) then Exit;

  try

    if EmployeesReferenceForm.ShowModal <> mrOk then Exit;

    AddChargesForPerformersFromEmployeesReferenceRecords(
      EmployeesReferenceForm.SelectedEmployeesRecords
    );

    ChargeTreeList.LayoutChanged;

  finally

    FreeAndNil(EmployeesReferenceForm);

  end;

end;

procedure TDocumentChargesFrame.AddChargesForPerformersFromEmployeesReferenceRecords(
  SelectedEmployeeRecords: TEmployeesReferenceFormRecords
);
var
    SelectedEmployeeRecord: TEmployeesReferenceFormRecord;
    FullErrorMessage, ErrorMessage: String;
begin

  for SelectedEmployeeRecord in SelectedEmployeeRecords do begin

    { refactor: specify whether can be multiple charges for one performer in domain }
    if
      not AddChargeForPerformerFromEmployeeReferenceRecord(
        SelectedEmployeeRecord, ErrorMessage
      )
    then begin

      FullErrorMessage :=
        IfThen(
          FullErrorMessage = '',
          ErrorMessage,
          FullErrorMessage + sLineBreak + ErrorMessage
        );

    end;

  end;

  if FullErrorMessage <> '' then begin

    ShowWarningMessage(
      Self.Handle,
      'Не удалось добавить следующих сотрудников:' +
      sLineBreak +
      FullErrorMessage,
      'Сообщение'
    );

  end;

end;

function TDocumentChargesFrame.AddChargeForPerformerFromEmployeeReferenceRecord(
  SelectedEmployeeRecord: TEmployeesReferenceFormRecord;
  var ErrorMessage: String
): Boolean;
var
    DocumentSenderIdValue: Variant;
    RemovedChargeRecordId: Variant;
    IsAddableChargeRecordMarkedAsRemovedNow: Boolean;
    ReplaceableChargeRecordIds: TVariantList;
    TopLevelChargeId: Variant;
    WorkingEmployeeRecordId: Variant;
    DocumentSenderNode: TcxDBTreeListNode;
begin

  Result := CanIssueChargeForPerformer(SelectedEmployeeRecord, ErrorMessage);

  if not Result then Exit;

  with DataSetHolder do begin

    DisableControls;

    try

      RevealRemovedRecords;

      IsAddableChargeRecordMarkedAsRemovedNow :=
        Locate(PerformerIdFieldName, SelectedEmployeeRecord.Id, []);

      if IsAddableChargeRecordMarkedAsRemovedNow then
        MarkCurrentRecordAsNonChanged;

      RevealNonRemovedRecords;

      if IsAddableChargeRecordMarkedAsRemovedNow then Exit;

      Append;

      InternalSetChargeRecordFieldsFromEmployeeReferenceRecord(SelectedEmployeeRecord);

      MarkCurrentRecordAsAdded;
      
      Post;
      
    finally

      EnableControls;

    end;

  end;

end;

function TDocumentChargesFrame.CanIssueChargeForPerformer(
  const EmployeeRecord: TEmployeesReferenceFormRecord;
  var ErrorMessage: String): Boolean;
begin

  Result := not IsDocumentPerformerRecordAlreadyExists(EmployeeRecord.Id);

  if not Result then begin

    ErrorMessage :=
      Format(
        'Сотрудник "%s" уже был ранее добавлен',
        [
          EmployeeRecord.Surname + ' ' +
          EmployeeRecord.Name + ' ' +
          EmployeeRecord.Patronymic
        ]
      );

  end;

end;

procedure TDocumentChargesFrame.InternalSetChargeRecordFieldsFromEmployeeReferenceRecord(
  SelectedEmployeeRecord: TEmployeesReferenceFormRecord);
begin

  with DataSetHolder do begin

    KindIdFieldValue := ViewModel.DocumentChargeKindDto.Id;
    KindNameFieldValue := ViewModel.DocumentChargeKindDto.Name;

    { refactor }
    
    SetCurrentRecordAccessRightsFieldValues;

    PerformerFullNameFieldValue :=
      SelectedEmployeeRecord.Surname + ' ' +
      SelectedEmployeeRecord.Name + ' ' +
      SelectedEmployeeRecord.Patronymic;

    PerformerSpecialityFieldValue := SelectedEmployeeRecord.Speciality;

    IsForAcquaitanceFieldValue := False;

    PerformerDepartmentNameFieldValue :=
      SelectedEmployeeRecord.DepartmentShortName;

    PerformerIdFieldValue := SelectedEmployeeRecord.Id;

    IsPerformerForeignFieldValue := SelectedEmployeeRecord.IsForeign;

    if SelectedEmployeeRecord.IsForeign then
      PerformerCommentFieldValue := 'Уведомление по почте';

  end;

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

function TDocumentChargesFrame.CanChangeChargeFieldForNode(
  ChargeTreeNode: TcxTreeListNode): Boolean;
begin

  Result :=
    CanChangeChargeTextRecordField(ChargeTreeNode.Values[IdColumn.ItemIndex]);

end;

function TDocumentChargesFrame.CanChangeChargeTextRecordField(
  const RecordId: Variant): Boolean;
var
    CanChangeResult: Variant;
begin

  if not Assigned(ViewModel) then begin

    Result := False;
    Exit;
    
  end;

  CanChangeResult :=
    DataSetHolder.LookupByRecordId(RecordId, CanChargeTextBeChangedFieldName);

  if VarIsNullOrEmpty(CanChangeResult) then
    Result := False

  else Result := CanChangeResult;

end;

function TDocumentChargesFrame.CanChangeCommentFieldForNode(
  ChargeTreeNode: TcxTreeListNode): Boolean;
var
    CanChangeResult: Variant;
begin

  if not Assigned(ChargeTreeNode) or not Assigned(ViewModel)
  then begin

    Result := False;
    Exit;

  end;

  CanChangeResult :=
    DataSetHolder.LookupByRecordId(
      ChargeTreeNode.Values[IdColumn.ItemIndex],
      CanPerformerCommentBeChangedFieldName
    );

  if VarIsNullOrEmpty(CanChangeResult) then
    Result := False

  else Result := CanChangeResult;
     
end; 

function TDocumentChargesFrame.CanChargeTextBeChangedFieldName: String;
begin

  Result := DataSetHolder.CanBeChangedFieldName;

end;

function TDocumentChargesFrame.CanChoosePerformersForChargeIssuing(
  var ErrorMessage: String
): Boolean;
begin

  Result := True;

end;

function TDocumentChargesFrame.CanPerformerCommentBeChangedFieldName: String;
begin

  Result := DataSetHolder.CanBeChangedFieldName;

end;

procedure TDocumentChargesFrame.ChangeChargeTextsForSelectedChargeNodes(const ChargeText: string);
begin

  ChangeChargeTextsForChargeNodes(ChargeTreeList.SelectionList, ChargeText);

end;

procedure TDocumentChargesFrame.ChangeChargeTextsForChargeNodes(
  ChargeTreeNodes: TList;
  const ChargeText: string
);
var
    NodePointer: Pointer;
    PreviousCurrentRecordBookmark: Pointer;
    ChargeTreeNode: TcxTreeListNode;
begin

  if not Assigned(ChargeTreeNodes) then Exit;

  PreviousCurrentRecordBookmark := ChargeSet.GetBookmark;

  with DataSetHolder do begin

    try

      DisableControls;

      for NodePointer in ChargeTreeNodes do begin

        ChargeTreeNode := TcxTreeListNode(NodePointer);

        if CanChangeChargeFieldForNode(ChargeTreeNode) then begin

          if  not
              Locate(
                IdFieldName,
                ChargeTreeNode.Values[IdColumn.ItemIndex],
                []
              )
          then Continue;

          ChargeTextFieldValue := ChargeText;

          MarkCurrentRecordAsChangedIfIdIsNotGenerated;

        end;

      end;

    finally

      try

        GotoBookmarkAndFree(PreviousCurrentRecordBookmark);

      finally

        ChargeSet.EnableControls;

      end;

    end;

  end;
  
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

  if ClassType <> DocumentInformationFrame.ClassType then Exit;

  OtherDocumentChargesFrame := TDocumentChargesFrame(DocumentInformationFrame);

  ChargeTreeList.DataController.DataSource := ChargeSetSource;

  SelectRecordByPerformer(WorkingEmployeeId);
  
end;

function TDocumentChargesFrame.CreateDocumentChargePerformersReferenceForm: TDocumentChargePerformersReferenceForm;
begin

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

  inherited;

end;

procedure TDocumentChargesFrame.ChargeTreeListCustomDrawDataCell(
  Sender: TcxCustomTreeList; ACanvas: TcxCanvas;
  AViewInfo: TcxTreeListEditCellViewInfo; var ADone: Boolean);
begin

  if AViewInfo.Node.Focused or AViewInfo.Selected then begin

    ACanvas.Brush.Color := $00c56a31;
    ACanvas.Font.Color := $00ffffff;

  end;

end;

procedure TDocumentChargesFrame.ChargeTreeListEditValueChanged(
  Sender: TcxCustomTreeList;
  AColumn: TcxTreeListColumn
);
begin

  inherited;

  if not Assigned(ViewModel) then Exit;
  
  ChargeSetSource.DataSet.Post;

  ViewModel.DocumentChargeSetHolder.MarkCurrentRecordAsChangedIfIdIsNotGenerated;

end;

procedure TDocumentChargesFrame.ChargeTreeListSelectionChanged(
  Sender: TObject);
begin

  inherited;

  actChangeSelectedChargeTexts.Visible :=
    CanChangeChargeFieldForAnyOfNodes(ChargeTreeList.SelectionList);

end;

function TDocumentChargesFrame.
  ValidateAccessibleChargeRecordFocused: Boolean;
var
    AccessibleChargeRecordIds: TVariantList;
    FocusedRecordId: Variant;
begin
  
  AccessibleChargeRecordIds :=
    FindAccessibleChargeRecordIdsByPerformer(WorkingEmployeeId);

  try

    if AccessibleChargeRecordIds.Count <= 1 then begin

      Result := True;
      Exit;

    end;

    FocusedRecordId := ChargeTreeList.FocusedNode.Values[IdColumn.ItemIndex];

    Result :=
      not VarIsNull(FocusedRecordId) and
      AccessibleChargeRecordIds.Contains(FocusedRecordId);

    if not Result then begin

      ShowWarningMessage(
        Self.Handle,
        'Вам доступно более одного поручения. ' +
        'Выберите нужное поручение и повторите ' +
        'действие',
        'Сообщение'
      );

    end;

  finally

    FreeAndNil(AccessibleChargeRecordIds);
    
  end;
  
end;                                        

function TDocumentChargesFrame.ValidateFocusedChargeRecordNotPerformed: Boolean;
begin

  if not
     VarIsNull(
        ChargeTreeList.FocusedNode.Values[
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

function TDocumentChargesFrame.FindRecordIdByPerformer(
  const PerformerId: Variant
): Variant;
var
    Bookmark: Pointer;
    PreviousFilter: String;
    LookupResult: Variant;
begin

  if VarIsNullOrEmpty(PerformerId) then begin

    Result := False;
    Exit;
    
  end;

  with DataSetHolder do begin

    LookupResult := Lookup(PerformerIdFieldName, PerformerId, IdFieldName);

    if VarIsEmpty(LookupResult) then
      Result := Null

    else Result := LookupResult;
          
  end;

end;

function TDocumentChargesFrame.FindAccessibleChargeRecordIdsByPerformer(
  const PerformerId: Variant): TVariantList;
var
    Bookmark: Pointer;
    PreviousFilter: String;
    Node: TcxDBTreeListNode;
    I: Integer;
begin

  Result := TVariantList.Create;

  try

    for I := 0 to ChargeTreeList.AbsoluteCount - 1 do begin

      Node := TcxDBTreeListNode(ChargeTreeList.AbsoluteItems[I]);

      if IsRecordAccessible(Node.Values[IdColumn.ItemIndex])
      then Result.Add(Node.Values[IdColumn.ItemIndex])

    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TDocumentChargesFrame.IsRecordAccessible(
  const RecordId: Variant): Boolean;
var
    AccessibleRecordFieldValues: Variant;
begin

  AccessibleRecordFieldValues :=
    DataSetHolder.LookupByRecordId(RecordId, GetAccessibleRecordFieldNames);

  Result := IsVariantContainsValue(AccessibleRecordFieldValues, True);

end;

function TDocumentChargesFrame.IsRecordRemoveable(
  const RecordId: Variant): Boolean;
var
    RecordRemoveableResult: Variant;
begin

  RecordRemoveableResult :=
    DataSetHolder.LookupByRecordId(RecordId, GetCanRecordRemoveFieldName);

  Result := not VarIsNullOrEmpty(RecordRemoveableResult) and RecordRemoveableResult;
  
end;

procedure TDocumentChargesFrame.MarkCurrentChargeRecordAsRemovedOrDeleteIfIdIsGenerated;
begin

  DataSetHolder.MarkCurrentRecordAsRemovedOrDeleteIfIdIsGenerated;
  
end;

function TDocumentChargesFrame.GetAccessibleRecordFieldNames: String;
begin

  with DataSetHolder do begin

    Result :=
      CanBeChangedFieldName + ';' +
      CanBeRemovedFieldName;
      
  end;

end;

procedure TDocumentChargesFrame.FrameResize(Sender: TObject);
begin

  inherited;

  ChargeTreeList.Width := Width - ChargeTreeList.Left - 7;
  ChargeTreeList.Height := Height - ChargeTreeList.Top - 7;

end;

function TDocumentChargesFrame.GetAddingChargeToolVisible: Boolean;
begin

  Result := AddChargesButton.Visible;

end;

function TDocumentChargesFrame.GetCanRecordRemoveFieldName: String;
begin

  Result := DataSetHolder.CanBeRemovedFieldName;
  
end;

function TDocumentChargesFrame.GetRemovingChargeToolVisible: Boolean;
begin

  Result := RemoveChargesButton.Visible;
  
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

function TDocumentChargesFrame.GetSameChargeTextFromChargeNodes(
  ChargeNodes: TList
): String;
var
    ChargeText: String;
    NodePointer: Pointer;
    ChargeNode: TcxTreeListNode;
begin

  for NodePointer in ChargeNodes do begin

    ChargeNode := TcxTreeListNode(NodePointer);

    if not CanChangeChargeFieldForNode(ChargeNode) then Continue;

    if not VarIsNull(ChargeNode.Values[ChargeTextColumn.ItemIndex]) then
      ChargeText := ChargeNode.Values[ChargeTextColumn.ItemIndex]

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

  with ViewModel do begin

    SubscribeOnChargeSetDataEvents;

    ChargeSetSource.DataSet := DocumentChargeSetHolder.DataSet;

  end;

end;

procedure TDocumentChargesFrame.UpdateDocumentChargeControlPanel;
begin

  UpdateDocumentChargeControlPanelVisibility;
  ReLayoutDocumentChargeControlPanel;
    
end;

procedure TDocumentChargesFrame.UpdateDocumentChargeControlPanelVisibility;
begin

  PerformerControlToolPanel.Visible :=
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

function TDocumentChargesFrame.GetViewOnly: Boolean;
begin

  Result := inherited GetViewOnly;
  
end;

function TDocumentChargesFrame.GetWorkingEmployeeChargeCount: Integer;
var
    AccessibleChargeRecordIds: TVariantList;
begin

  AccessibleChargeRecordIds :=
   FindAccessibleChargeRecordIdsByPerformer(WorkingEmployeeId);

  try

    Result := AccessibleChargeRecordIds.Count;
    
  finally

    FreeAndNil(AccessibleChargeRecordIds);

  end;

end;

function TDocumentChargesFrame.GetWorkingEmployeePerformedChargeCount: Integer;
var
    ChargeTreeNode: TcxDBTreeListNode;
    AccessibleChargeRecordIds: TVariantList;
    RecordId: Variant;
begin

  Result := 0;

  AccessibleChargeRecordIds :=
    FindAccessibleChargeRecordIdsByPerformer(
      WorkingEmployeeId
    );

  try

    for RecordId in AccessibleChargeRecordIds do begin

      ChargeTreeNode :=
        ChargeTreeList.FindNodeByKeyValue(RecordId);

      if not VarIsNull(ChargeTreeNode.Values[PerformingDateTimeColumn.ItemIndex])

      then Inc(Result);

    end;
    
  finally

    FreeAndNil(AccessibleChargeRecordIds);
    
  end;

end;

procedure TDocumentChargesFrame.HandleChangeSelectedChargeTextsAction;
var Accepted: Boolean;
    ChargeText: String;
begin

  ChargeText := GetSameChargeTextFromChargeNodes(ChargeTreeList.SelectionList);

  ChargeText := GetInputFieldTextForm('Текст поручения', ChargeText, Accepted);

  if  Accepted then
    ChangeChargeTextsForSelectedChargeNodes(ChargeText);

end;

procedure TDocumentChargesFrame.SetViewModel(
  ViewModel: TDocumentChargesFormViewModel
);
begin

  FViewModel := ViewModel;
  FFreeViewModel := ViewModel;

  SetTableColumnLayout(FViewModel.DocumentChargeSetHolder.FieldDefs);

  UpdateByViewModel(FViewModel);

end;

procedure TDocumentChargesFrame.SetViewOnly(const Value: Boolean);
begin

  inherited;

  ChargeTreeList.OptionsData.Editing := not Value;

  if Value then begin

    PerformerControlToolPanel.BevelKind := bkNone;

  end

  else begin

    PerformerControlToolPanel.BevelKind := bkFlat;
    PerformerControlToolPanel.BevelEdges := [beTop];
    PerformerControlToolPanel.BevelInner := bvNone;
    PerformerControlToolPanel.BevelOuter := bvNone;
    
  end;

  if Value then
    ChargeTreeList.PopupMenu := nil

  else
    ChargeTreeList.PopupMenu := ChargeRecordsHandlingPopupMenu;

  actAddCharges.Enabled := not Value;
  actRemoveSelectedCharges.Enabled := not Value;

  if Value then
    PerformerControlToolPanel.Visible := False

  else PerformerControlToolPanel.Visible := True;

end;

procedure TDocumentChargesFrame.SubscribeOnChargeSetDataEvents;
begin

  DataSetHolder.DataSet.AfterPost := OnChargeSetChangedEventHandler;
  DataSetHolder.DataSet.AfterDelete := OnChargeSetRecordRemovedEventHandler;
    
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

procedure TDocumentChargesFrame.Initialize;
begin

  inherited;

  InitializeLayout;
  SubscribeOnEvents;
  
  EnableScrolling := False;
  
end;

procedure TDocumentChargesFrame.InitializeLayout;
begin

  AddChargesButton.Colors.Default := DEFAULT_BACKGROUND_BUTTON_COLOR;
  RemoveChargesButton.Colors.Default := DEFAULT_BACKGROUND_BUTTON_COLOR;

end;

function TDocumentChargesFrame.IsDataChanged: Boolean;
begin

  Result :=
    Assigned(FViewModel)
    and
    ViewModel
      .DocumentChargeSetHolder
        .AreChangedRecordsExists;

end;

function TDocumentChargesFrame.IsDocumentPerformerRecordAlreadyExists(
  const EmployeeId: Variant): Boolean;
var LookupResult: Variant;
begin

  LookupResult :=
    DataSetHolder.Lookup(
      DataSetHolder.PerformerIdFieldName,
      EmployeeId,
      DataSetHolder.PerformerIdFieldName
    );
          
  Result :=
    not VarIsNull(LookupResult) and not VarIsEmpty(LookupResult);

end;

function TDocumentChargesFrame.IsDataSetHolderAssigned: Boolean;
begin

  Result := Assigned(FViewModel) and Assigned(FViewModel.DocumentChargeSetHolder);
  
end;

function TDocumentChargesFrame.IsAccessibleChargeNode(
  ChargeTreeNode: TcxTreeListNode
): Boolean;
var
    AccessibleChargeRecordIds: TVariantList;
begin

  Result := IsRecordAccessible(ChargeTreeNode.Values[IdColumn.ItemIndex]);

end;

procedure TDocumentChargesFrame.
  OnDocumentChargePerformerRecordsRefreshRequestedEventHandler(
    Sender: TObject
  );
var
    DocumentChargePerformersReferenceForm: TDocumentChargePerformersReferenceForm;
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

procedure TDocumentChargesFrame.OnChargeSetChangedEventHandler(
  DataSet: TDataSet);
begin

  FIsDocumentChargeSetChanged := True;

end;

procedure TDocumentChargesFrame.OnChargeSetRecordRemovedEventHandler(
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

procedure TDocumentChargesFrame.ReLayoutDocumentChargeControlPanel;
begin

  ApplyHorizontalLayoutToControls(
    [AddChargesButton, RemoveChargesButton], 10
  );
  
end;

{
  refactor: возвращать список идентфикаторов тех поручений, которые
  были удалены, чтобы при восстановлении записей в наборе данных
  в случае неудачного удаления всех
  затребованных поручений оставить только те, которые удалить не получилось
}
procedure TDocumentChargesFrame.RemoveChoosenCharges;

  procedure DeleteChargeNodes(
    RemoveableChargeNodeList: TList
  );
  var
      RemoveableChargeNode: TcxTreeListNode;
      I: Integer;
  begin

    with DataSetHolder do begin

      DisableControls;

      for I := 0 to RemoveableChargeNodeList.Count - 1 do begin

        RemoveableChargeNode := RemoveableChargeNodeList[I];

        LocateByRecordId(
          RemoveableChargeNode.Values[IdColumn.ItemIndex],
          []
        );

        MarkCurrentChargeRecordAsRemovedOrDeleteIfIdIsGenerated;

      end;

      EnableControls;

    end;
    
  end;

var
    I: Integer;
    SelectedChargeNode: TcxTreeListNode;
    ChargeNodesToRemove: TList;
    IsDisAllowedRemovingAttemptRaised: Boolean;
begin

  ChargeNodesToRemove := TList.Create;

  try

    IsDisAllowedRemovingAttemptRaised := False;

    with DataSetHolder do begin

      DisableControls;

      for I := 0 to ChargeTreeList.SelectionCount - 1 do begin

        SelectedChargeNode := ChargeTreeList.Selections[I];

        if

          IsRecordRemoveable(SelectedChargeNode.Values[IdColumn.ItemIndex])
        then begin

          ChargeNodesToRemove.Add(SelectedChargeNode);

        end

        else begin

          IsDisAllowedRemovingAttemptRaised := True;

        end;

      end;

      DeleteChargeNodes(ChargeNodesToRemove);

      RevealNonRemovedRecords;

      if IsDisAllowedRemovingAttemptRaised then begin

        ShowWarningMessage(
          Self.Handle,
          VarIfThen(
            ChargeNodesToRemove.Count > 0,
            'Некоторые из поручений',
            'Поручения'
          ) +
          ' не были отозваны, ' +
          'поскольку у Вас отсутствуют соответствующие права',
          'Замечание'
        );

      end;

    end;

  finally

    FreeAndNil(ChargeNodesToRemove);
    
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

  DataSetHolder.MarkRemovedRecordsAsNonChanged;
  DataSetHolder.RevealNonRemovedRecords;

end;

procedure TDocumentChargesFrame.SaveUIControlProperties;
begin

  inherited;

end;

procedure TDocumentChargesFrame.SelectRecordByPerformer(
  const PerformerId: Variant
);
var
    RecordId: Variant;
    AccessibleRecordIds: TVariantList;
begin

  if not IsDataSetHolderAssigned then Exit;

  with DataSetHolder do begin

    if Assigned(DataSet) and DataSet.Active
    then  begin

      RecordId := FindRecordIdByPerformer(PerformerId);

      if VarIsNull(RecordId) then begin

        AccessibleRecordIds :=
          FindAccessibleChargeRecordIdsByPerformer(PerformerId);
          
        if not AccessibleRecordIds.IsEmpty then
          RecordId := AccessibleRecordIds[0];

        AccessibleRecordIds.Destroy;
        
      end;

      if not VarIsNull(RecordId) then
        Locate(IdFieldName, RecordId, []);

      if Assigned(ChargeTreeList.FocusedNode) then
        ChargeTreeList.FocusedNode.Expand(True);

    end;

  end;
  
end;

procedure TDocumentChargesFrame.SetAddingChargeToolVisible(
  const Value: Boolean);
begin

  AddChargesButton.Visible := Value;

  UpdateDocumentChargeControlPanel;

end;

procedure TDocumentChargesFrame.SetCurrentRecordAccessRightsFieldValues;
begin

  with DataSetHolder do begin

    CanBeChangedFieldValue := True;
    CanBeRemovedFieldValue := True;

  end;

end;

procedure TDocumentChargesFrame.SetRemovingChargeToolVisible(
  const Value: Boolean);
begin

  RemoveChargesButton.Visible := Value;

  UpdateDocumentChargeControlPanel;
  
end;

procedure TDocumentChargesFrame.SetEnabled(Value: Boolean);
begin

  inherited;

end;

procedure TDocumentChargesFrame.SetIgnorableViewOnlyControls(Controls: TList);
begin

  Controls.Add(ChargeTreeList);

end;

procedure TDocumentChargesFrame.SetTableColumnLayout(
  FieldDefs: TDocumentChargeSetFieldDefs);
begin

  ChargeTextColumn.DataBinding.FieldName := FieldDefs.ChargeTextFieldName;
  PerformerResolutionColumn.DataBinding.FieldName := FieldDefs.PerformerCommentFieldName;
  IsForAcquaitanceColumn.DataBinding.FieldName := FieldDefs.IsForAcquaitanceFieldName;
  IsPerformerForeignColumn.DataBinding.FieldName := FieldDefs.IsPerformerForeignFieldName;
  PerformedEmployeeNameColumn.DataBinding.FieldName := FieldDefs.ActualPerformerFullNameFieldName;
  PerformingDateTimeColumn.DataBinding.FieldName := FieldDefs.PerformingDateTimeFieldName;
  PerformerDepartmentNameColumn.DataBinding.FieldName := FieldDefs.PerformerDepartmentNameFieldName;
  PerformerFullNameColumn.DataBinding.FieldName := FieldDefs.PerformerFullNameFieldName;
  PerformerIdColumn.DataBinding.FieldName := FieldDefs.PerformerIdFieldName;
  PerformerSpecialityColumn.DataBinding.FieldName := FieldDefs.PerformerSpecialityFieldName;
  IdColumn.DataBinding.FieldName := FieldDefs.IdFieldName;
  RecordStatusColumn.DataBinding.FieldName := FieldDefs.RecordStatusFieldName;

  ChargeTreeList.DataController.KeyField := FieldDefs.IdFieldName;
  ChargeTreeList.DataController.ParentField := FieldDefs.IdFieldName;

end;

procedure TDocumentChargesFrame.WndProc(var Message: TMessage);
begin

  if Message.Msg = WM_PAINT then begin

    if not IsDataSetHolderAssigned then begin

      inherited;
      Exit;

    end;

    if not FIsAlreadyShowed then begin

      FIsAlreadyShowed := True;

    end;

  end;
  
  inherited;

end;

end.
