unit unDocumentChargeSheetsFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unDocumentChargesFrame, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxCustomData, cxStyles, cxTL, cxMaskEdit,
  cxTLdxBarBuiltInMenu, dxSkinsCore, dxSkinsDefaultPainters, Menus, DB,
  ZSqlUpdate, ZAbstractRODataset, ZAbstractDataset, ZDataset, StdCtrls,
  cxButtons, cxInplaceContainer, cxDBTL, cxTLData, ExtCtrls, cxTextEdit,
  cxCalendar, cxMemo, cxDropDownEdit, cxLabel, cxButtonEdit, ActnList,
  unDocumentChargeSheetPerformersReferenceForm,
  unDocumentFlowInformationFrame,
  DocumentChargeSetHolder,
  DocumentChargePerformersReferenceFormUnit, unDocumentCardInformationFrame,
  VariantListUnit, EmployeesReferenceFormUnit, EmployeeSetHolder,
  Disposable,
  DocumentChargeSheetsFormViewModel,
  DocumentChargeSheetSetHolder;

type

  TChargeSheetNodePredicate = function(Node: TcxDBTreeListNode): Boolean of object;

  TDocumentChargeSheetsFrame = class(TDocumentChargesFrame)
    SaveChargesChangesButton: TcxButton;
    IssuerNameColumn: TcxDBTreeListColumn;
    actSaveChargeSheetRecordsChanges: TAction;
    TopLevelChargeSheetIdColumn: TcxDBTreeListColumn;
    ViewDateByPerformerColumn: TcxDBTreeListColumn;
    IssuingDateTimeColumn: TcxDBTreeListColumn;
    DocumentIdColumn: TcxDBTreeListColumn;
    PerformingAllowedColumn: TcxDBTreeListColumn;
    IsEmployeePerformerColumn: TcxDBTreeListColumn;
    ChargeSectionAccessibleColumn: TcxDBTreeListColumn;
    SubordinateChargeSheetsIssuingAllowedColumn: TcxDBTreeListColumn;

    procedure actSaveChargeSheetRecordsChangesExecute(Sender: TObject);
    procedure ChargeTreeListCustomDrawDataCell(
      Sender: TcxCustomTreeList; ACanvas: TcxCanvas;
      AViewInfo: TcxTreeListEditCellViewInfo; var ADone: Boolean);
    procedure actAddReceiversExecute(Sender: TObject);
    procedure ChargeTreeListDblClick(Sender: TObject);

  private

    FViewModel: TDocumentChargeSheetsFormViewModel;
    FFreeViewModel: IDisposable;
    
    function GetViewModel: TDocumentChargeSheetsFormViewModel;
    procedure SetViewModel(const Value: TDocumentChargeSheetsFormViewModel);

    function IsFocusedColumn(const FieldName: String): Boolean;
    function GetFocusedColumnCaption: String;
    function GetFocusedColumnFieldName: String;

    function CanUserEditFocusedColumnField: Boolean;

    procedure SaveChargeRecordsChanges;

    procedure HighlightDocumentChargeRecordWith(
      Canvas: TcxCanvas;
      RecordViewInfo: TcxTreeListEditCellViewInfo
    );

  protected

    function IsRecordPerformable(const RecordId: Variant): Boolean;
    function AnyPerformableRecordsExists: Boolean;

  protected

    function GetDocumentChargePerformerSetHolder: TEmployeeSetHolder; override;

  protected

    function CreateDocumentChargePerformersReferenceForm:
      TDocumentChargePerformersReferenceForm; override;

  protected

    procedure InternalSetChargeRecordFieldsFromEmployeeReferenceRecord(
      SelectedEmployeeRecord: TEmployeesReferenceFormRecord
    );  override;

    function CanChoosePerformersForChargeIssuing(
      var ErrorMessage: String
    ): Boolean; override;

    function CanIssueChargeForPerformer(
      const EmployeeRecord: TEmployeesReferenceFormRecord;
      var ErrorMessage: String
    ): Boolean; override;

    function GetAccessibleRecordFieldNames: String; override;
    function GetCanRecordRemoveFieldName: String; override;

  protected

    function CanPerformerCommentBeChangedFieldName: String; override;
    function CanChargeTextBeChangedFieldName: String; override;

  protected

    procedure InitializeLayout; override;
    procedure SetEnabled(Value: Boolean); override;

    procedure SetViewOnly(const Value: Boolean); override;

    procedure SetTableColumnLayout(FieldDefs: TDocumentChargeSheetSetFieldDefs);

    procedure SetCurrentRecordAccessRightsFieldValues; override;
                                               {
    function WasDocumentChargeRecordAddedByWorkingEmployeeInPast(
      SelectedDocumentReceiverNode: TcxTreeListNode
    ): Boolean; override;             }

  protected

    procedure ReLayoutDocumentChargeControlPanel; override;
    procedure UpdateDocumentChargeControlPanelVisibility; override;

  protected

    function GetIssuingChargeSheetToolVisible: Boolean;
    function GetRemovingChargeSheetToolVisible: Boolean;

    procedure SetIssuingChargeSheetToolVisible(const Value: Boolean);
    procedure SetRemovingChargeSheetToolVisible(const Value: Boolean);

    function GetSaveChargeSheetChangesToolVisible: Boolean;
    procedure SetSaveChargeSheetChangesToolVisible(const Value: Boolean);

  protected

    function DataSetHolder: TDocumentChargeSheetSetHolder;

  public

    destructor Destroy; override;

    procedure CopyUISettings(
      DocumentInformationFrame: TDocumentFlowInformationFrame
    ); override;

    function ValidateAllowableForPerformingChargeSheetsSelected: Boolean;

    function FetchSelectedAccessibleChargeSheetIds: TVariantList;
    function FetchPerformableChargeSheetIds: TVariantList;
    function FetchSelectedPerformableChargeSheetIds: TVariantList;
    function FetchChargeSheetIdsForSubordinatesIssuing: TVariantList;
    function FetchChargeSheetIds(const Predicate: TChargeSheetNodePredicate): TVariantList;

    function IsChargeSheetNodeForSubordinatesIssuing(Node: TcxDBTreeListNode): Boolean;
    function IsChargeSheetNodePerformable(Node: TcxDBTreeListNode): Boolean;

    property ViewModel: TDocumentChargeSheetsFormViewModel
    read GetViewModel write SetViewModel;

  public

    property IssuingChargeSheetToolVisible: Boolean
    read GetIssuingChargeSheetToolVisible write SetIssuingChargeSheetToolVisible;

    property RemovingChargeSheetToolVisible: Boolean
    read GetRemovingChargeSheetToolVisible write SetRemovingChargeSheetToolVisible;

    property SaveChargeSheetChangesToolVisible: Boolean
    read GetSaveChargeSheetChangesToolVisible
    write SetSaveChargeSheetChangesToolVisible;
    
  end;

var
  IncomingDocumentChargesFrame: TDocumentChargeSheetsFrame;

implementation

uses

  VariantFunctions,
  DocumentChargeSheetPerformerSetReadService,
  AuxDebugFunctionsUnit,
  AuxWindowsFunctionsUnit,
  InputMemoFormUnit,
  DocumentFlowSystemInputMemoFormUnit,
  EmployeeSetReadService,
  ApplicationServiceRegistries,
  WorkingEmployeeUnit,
  CommonControlStyles,
  DocumentChargePerformerSetReadService,
  AbstractDataSetHolder;

{$R *.dfm}

{ TDocumentChargeSheetsFrame }

procedure TDocumentChargeSheetsFrame.actAddReceiversExecute(
  Sender: TObject);
begin

  if not ValidateAccessibleChargeRecordFocused then Exit;
  
  if
    (GetWorkingEmployeeChargeCount > 1) and
    not ValidateFocusedChargeRecordNotPerformed
                      
  then Exit;

  AddChargesForPerformersFromEmployeesReference;

end;

procedure TDocumentChargeSheetsFrame.actSaveChargeSheetRecordsChangesExecute(
  Sender: TObject);
begin

  SaveChargeRecordsChanges;

end;

function TDocumentChargeSheetsFrame.AnyPerformableRecordsExists: Boolean;
var
    PerformableChargeSheetIds: TVariantList;
begin

  PerformableChargeSheetIds := FetchPerformableChargeSheetIds;

  try

    Result := not PerformableChargeSheetIds.IsEmpty;

  finally

    FreeAndNil(PerformableChargeSheetIds);

  end;

end;

function TDocumentChargeSheetsFrame.CanChoosePerformersForChargeIssuing(
  var ErrorMessage: String
): Boolean;
var
    ChargeSheetIds: TVariantList;
    ChargeSheetNode: TcxDBTreeListNode;
    I: Integer;
    FocusedRecordId: Variant;
begin

  Result := False;
    
  ChargeSheetIds := FetchChargeSheetIdsForSubordinatesIssuing;
    
  if ChargeSheetIds.IsEmpty then begin

    Result := DataSetHolder.HeadChargeSheetsIssuingAllowed;

    if not Result then begin

      ErrorMessage :=
        'Отсутствуют поручения, по которым ' +
        'можно было бы выдать подчинённые поручения';

    end;

  end

  else if ChargeSheetIds.Count = 1 then
    Result := True

  else if Assigned(ChargeTreeList.FocusedNode) then
  begin

    FocusedRecordId := ChargeTreeList.FocusedNode.Values[IdColumn.ItemIndex];

    Result := ChargeSheetIds.Contains(FocusedRecordId);

  end

  else if not Result then begin

    ErrorMessage :=
      'Не выбрано поручение, по которому ' +
      'необходимо выдать подчинённое';

  end;

end;

function TDocumentChargeSheetsFrame.CanIssueChargeForPerformer(
  const EmployeeRecord: TEmployeesReferenceFormRecord;
  var ErrorMessage: String
): Boolean;
begin

  Result :=
    inherited CanIssueChargeForPerformer(EmployeeRecord, ErrorMessage);

end;

procedure TDocumentChargeSheetsFrame.InternalSetChargeRecordFieldsFromEmployeeReferenceRecord(
  SelectedEmployeeRecord: TEmployeesReferenceFormRecord
);
var
    FocusedRecordId: Variant;
    WorkingEmployeeRecordId: Variant;
    AccessibleChargeRecordIds: TVariantList;
    TopLevelRecordId: Variant;
    TopLevelNode: TcxDBTreeListNode;
begin
                                 
  inherited InternalSetChargeRecordFieldsFromEmployeeReferenceRecord(SelectedEmployeeRecord);

  TopLevelRecordId := Null;
  
  AccessibleChargeRecordIds :=
    FetchChargeSheetIdsForSubordinatesIssuing;

  if AccessibleChargeRecordIds.IsEmpty then begin

    if not ViewModel.DocumentChargeSheetSetHolder.HeadChargeSheetsIssuingAllowed
    then Exit;
    
  end

  else if AccessibleChargeRecordIds.Count = 1 then
    TopLevelRecordId := AccessibleChargeRecordIds.First

  else begin

    TopLevelRecordId := ChargeTreeList.FocusedNode.Values[IdColumn.ItemIndex];

  end;

  with DataSetHolder do begin

    if not VarIsNull(TopLevelRecordId) then begin

      TopLevelNode :=
        ChargeTreeList.FindNodeByKeyValue(TopLevelRecordId);

      IsForAcquaitanceFieldValue :=
        TopLevelNode.Values[IsForAcquaitanceColumn.ItemIndex];

    end;
                                              
    TopLevelChargeSheetIdFieldValue := TopLevelRecordId;
    IssuerIdFieldValue := WorkingEmployeeId;
                           
  end;

end;

function TDocumentChargeSheetsFrame.CanChargeTextBeChangedFieldName: String;
begin

  Result := DataSetHolder.ChargeSectionAccessibleFieldName;

end;

function TDocumentChargeSheetsFrame.CanPerformerCommentBeChangedFieldName: String;
begin

  Result := DataSetHolder.ResponseSectionAccessibleFieldName;

end;

function TDocumentChargeSheetsFrame.CanUserEditFocusedColumnField: Boolean;
begin

  with DataSetHolder do begin

    if not (IsFocusedColumn(PerformerCommentFieldName) or
            IsFocusedColumn(ChargeTextFieldName))
    then begin

      Result := False;
      Exit;

    end;

    if IsFocusedColumn(PerformerCommentFieldName) then
      Result := CanChangeCommentFieldForNode(ChargeTreeList.FocusedNode)

    else
      Result := CanChangeChargeFieldForNode(ChargeTreeList.FocusedNode);

  end;

end;

procedure TDocumentChargeSheetsFrame.CopyUISettings(
  DocumentInformationFrame: TDocumentFlowInformationFrame);
begin

  inherited;

end;

function TDocumentChargeSheetsFrame.
  CreateDocumentChargePerformersReferenceForm:
    TDocumentChargePerformersReferenceForm;
begin

  Result :=
    TDocumentChargeSheetPerformersReferenceForm.Create(Self);
    
end;

function TDocumentChargeSheetsFrame.DataSetHolder: TDocumentChargeSheetSetHolder;
begin

  if Assigned(ViewModel) then
    Result := ViewModel.DocumentChargeSheetSetHolder

  else Result := nil;

end;

destructor TDocumentChargeSheetsFrame.Destroy;
begin

  inherited;

end;

procedure TDocumentChargeSheetsFrame.ChargeTreeListCustomDrawDataCell(
  Sender: TcxCustomTreeList; ACanvas: TcxCanvas;
  AViewInfo: TcxTreeListEditCellViewInfo; var ADone: Boolean);
var RecordId: Variant;
    ReplaceableChargeRecordIds: TVariantList;
begin

  inherited ChargeTreeListCustomDrawDataCell(
    Sender, ACanvas, AViewInfo, ADone
  );
  
  HighlightDocumentChargeRecordWith(ACanvas, AViewInfo);

end;

procedure TDocumentChargeSheetsFrame.ChargeTreeListDblClick(
  Sender: TObject);
var FieldText: String;
    FieldTextAccepted: Boolean;
begin

  if not Enabled or ViewOnly or not IsDataSetHolderAssigned then Exit;

  with DataSetHolder do begin

    if not CanUserEditFocusedColumnField then Exit;

    FieldText :=
      GetInputFieldTextForm(
        GetFocusedColumnCaption,
        DataSet.FieldByName(
          GetFocusedColumnFieldName
        ).AsString,
        FieldTextAccepted
      );

    if not FieldTextAccepted then Exit;

    DataSetHolder.SetFieldValue(GetFocusedColumnFieldName, FieldText);

    MarkCurrentRecordAsChangedIfIdIsNotGenerated;

  end;

end;

function TDocumentChargeSheetsFrame.FetchChargeSheetIds(
  const Predicate: TChargeSheetNodePredicate
): TVariantList;
var
    I: Integer;
    ChargeSheetNode: TcxDBTreeListNode;
    RecordId: Variant;
begin

  Result := TVariantList.Create;

  try

    for I := 0 to ChargeTreeList.AbsoluteCount - 1 do
    begin

      ChargeSheetNode := TcxDBTreeListNode(ChargeTreeList.AbsoluteItems[I]);

      RecordId := ChargeSheetNode.Values[IdColumn.ItemIndex];

      if Predicate(ChargeSheetNode) then
        Result.Add(RecordId)
        
    end;

  except

    FreeAndNil(Result);

    Raise;

  end;
    
end;

function TDocumentChargeSheetsFrame.FetchChargeSheetIdsForSubordinatesIssuing: TVariantList;
begin

  Result := FetchChargeSheetIds(IsChargeSheetNodeForSubordinatesIssuing);

end;

function TDocumentChargeSheetsFrame.FetchPerformableChargeSheetIds: TVariantList;
var
    ChargeTreeNode: TcxDBTreeListNode;
    I: Integer;
begin

  Result := FetchChargeSheetIds(IsChargeSheetNodePerformable);

end;

function TDocumentChargeSheetsFrame.FetchSelectedAccessibleChargeSheetIds: TVariantList;
var
    ChargeTreeNode: TcxDBTreeListNode;
    I: Integer;
    RecordId: Variant;
    AccessibleChargeRecordIds: TVariantList;
    SelectedRecordId: Variant;
begin

  AccessibleChargeRecordIds :=
    FindAccessibleChargeRecordIdsByPerformer(WorkingEmployeeId);

  Result := TVariantList.Create;

  try

    if AccessibleChargeRecordIds.IsEmpty then Exit;

    try

      for I := 0 to ChargeTreeList.SelectionCount - 1 do begin

        ChargeTreeNode := ChargeTreeList.Selections[I] as TcxDBTreeListNode;

        SelectedRecordId := ChargeTreeNode.Values[IdColumn.ItemIndex];

        if AccessibleChargeRecordIds.Contains(SelectedRecordId) then
          Result.Add(ChargeTreeNode.Values[IdColumn.ItemIndex]);

      end;

    except

      FreeAndNil(Result);

      Raise;

    end;

  finally

    FreeAndNil(AccessibleChargeRecordIds);
    
  end;

end;

function TDocumentChargeSheetsFrame.FetchSelectedPerformableChargeSheetIds: TVariantList;
var
    PerformableChargeSheetIds: TVariantList;

    I: Integer;
    ChargeTreeNode: TcxDBTreeListNode;
    SelectedRecordId: Variant;
begin

  PerformableChargeSheetIds := FetchPerformableChargeSheetIds;

  Result := TVariantList.Create;

  try

    try

      if PerformableChargeSheetIds.Count = 1 then begin

        Result.Add(PerformableChargeSheetIds.First);
        Exit;

      end;

      for I := 0 to ChargeTreeList.SelectionCount - 1 do begin

        ChargeTreeNode := TcxDBTreeListNode(ChargeTreeList.Selections[I]);

        SelectedRecordId := ChargeTreeNode.Values[IdColumn.ItemIndex];

        if PerformableChargeSheetIds.Contains(SelectedRecordId) then
          Result.Add(SelectedRecordId);

      end;

    except

      FreeAndNil(Result);

      Raise;

    end;

  finally

    FreeAndNil(PerformableChargeSheetIds);

  end;

end;

function TDocumentChargeSheetsFrame.GetAccessibleRecordFieldNames: String;
begin

  with DataSetHolder do begin

    Result :=
      ChargeSectionAccessibleFieldName + ';' +
      ResponseSectionAccessibleFieldName + ';' +
      RemovingAllowedFieldName + ';' +
      PerformingAllowedFieldName;

  end;

end;

function TDocumentChargeSheetsFrame.GetCanRecordRemoveFieldName: String;
begin

  Result := DataSetHolder.RemovingAllowedFieldName;
  
end;

function TDocumentChargeSheetsFrame.GetDocumentChargePerformerSetHolder: TEmployeeSetHolder;
var
    DocumentChargeSheetPerformerSetReadService: IDocumentChargeSheetPerformerSetReadService;
begin

  {
    refactor:
      add interface tools for issuing not only
      subordinate charge sheets but head charge sheets too.
      Provide related reference forms to select appropriate
      performers to users
  }
  
  DocumentChargeSheetPerformerSetReadService :=
    TApplicationServiceRegistries
      .Current
        .GetPresentationServiceRegistry
          .GetDocumentChargeSheetPerformerSetReadService(ServiceDocumentKind);

  if AnyPerformableRecordsExists then begin

    Result :=
      DocumentChargeSheetPerformerSetReadService
        .FindDocumentChargeSheetPerformerSetForEmployee(WorkingEmployeeId);
        
  end

  else begin

    Result :=
      DocumentChargeSheetPerformerSetReadService
        .FindChargeSheetPerformerSetForDocumentAndEmployee(
          DocumentId,
          WorkingEmployeeId
        );

  end;

end;

function TDocumentChargeSheetsFrame.GetFocusedColumnCaption: String;
begin

  Result := ChargeTreeList.FocusedColumn.Caption.Text;
  
end;

function TDocumentChargeSheetsFrame.GetFocusedColumnFieldName: String;
begin

  if not Assigned(ChargeTreeList.FocusedColumn) then
    Result := ''

  else begin

    Result :=
      TcxDBTreeListColumn(ChargeTreeList.FocusedColumn).DataBinding.FieldName;

  end;

end;

function TDocumentChargeSheetsFrame.GetIssuingChargeSheetToolVisible: Boolean;
begin

  Result := AddingChargeToolVisible;

end;

function TDocumentChargeSheetsFrame.GetRemovingChargeSheetToolVisible: Boolean;
begin

  Result := RemovingChargeToolVisible;

end;

function TDocumentChargeSheetsFrame.GetSaveChargeSheetChangesToolVisible: Boolean;
begin

  Result := SaveChargesChangesButton.Visible;
  
end;

function TDocumentChargeSheetsFrame.GetViewModel: TDocumentChargeSheetsFormViewModel;
begin

  Result := FViewModel;

end;

procedure TDocumentChargeSheetsFrame.HighlightDocumentChargeRecordWith(
  Canvas: TcxCanvas;
  RecordViewInfo: TcxTreeListEditCellViewInfo
);
var
    RecordId: Variant;
    ChargeIsPerformed: Boolean;
    ChargeRecordColor: TColor;
    IsEmployeePerformer: Variant;
begin

  ChargeIsPerformed :=
    not VarIsNull(
      RecordViewInfo.Node.Values[PerformingDateTimeColumn.ItemIndex]
    );

  if not ChargeIsPerformed then
    ChargeRecordColor := $0081e0ff

  else ChargeRecordColor := $0077ffda;

  IsEmployeePerformer :=
    RecordViewInfo.Node.Values[IsEmployeePerformerColumn.ItemIndex];

  if not VarIsNull(IsEmployeePerformer) and IsEmployeePerformer  then begin

    if not (RecordViewInfo.Focused or RecordViewInfo.Selected) then
      Canvas.FillRect(RecordViewInfo.BoundsRect, ChargeRecordColor)

    else Canvas.Font.Color := ChargeRecordColor;

  end;

end;

procedure TDocumentChargeSheetsFrame.InitializeLayout;
begin

  inherited;

  SaveChargesChangesButton.Colors.Default := DEFAULT_BACKGROUND_BUTTON_COLOR;

end;

function TDocumentChargeSheetsFrame.IsChargeSheetNodeForSubordinatesIssuing(
  Node: TcxDBTreeListNode): Boolean;
begin

  Result :=
    VarOrDefault(
      Node.Values[
        SubordinateChargeSheetsIssuingAllowedColumn.ItemIndex
      ],
      False
    );

end;

function TDocumentChargeSheetsFrame.IsChargeSheetNodePerformable(
  Node: TcxDBTreeListNode): Boolean;
begin

  Result :=
    VarOrDefault(Node.Values[PerformingAllowedColumn.ItemIndex], False);

end;

function TDocumentChargeSheetsFrame.IsFocusedColumn(
  const FieldName: String
): Boolean;
var FocusedFieldColumn: TcxDBTreeListColumn;
begin

  Result := GetFocusedColumnFieldName = FieldName;

end;

function TDocumentChargeSheetsFrame.IsRecordPerformable(
  const RecordId: Variant): Boolean;
var
    IsPerformableResult: Variant;
begin

  if not Assigned(ViewModel) then begin

    Result := False;
    Exit;
    
  end;

  IsPerformableResult :=
    DataSetHolder.LookupByRecordId(RecordId, DataSetHolder.PerformingAllowedFieldName);

  Result := not VarIsNullOrEmpty(IsPerformableResult) and IsPerformableResult;

end;

procedure TDocumentChargeSheetsFrame.ReLayoutDocumentChargeControlPanel;
begin

  ApplyHorizontalLayoutToControls(
    [
      AddChargesButton,
      RemoveChargesButton,
      SaveChargesChangesButton
    ],
    10
  );

end;

procedure TDocumentChargeSheetsFrame.SaveChargeRecordsChanges;
begin

  if not IsDataChanged then begin

    ShowInfoMessage(
      Self.Handle,
      'Внесённых изменений не обнаружено',
      'Сообщение'
    );
    Exit;

  end;

  if Assigned(FOnDocumentPerformingsChangesSavingRequestedEventHandler) then begin

    try
    
      FOnDocumentPerformingsChangesSavingRequestedEventHandler(Self);

      FIsDocumentChargeSetChanged := False;
                   
      ShowInfoMessage(
        Self.Handle,
        'Изменения были сохранены',
        'Сообщение'
      );

    finally

      DataSetHolder.RevealNonRemovedRecords;

      SelectRecordByPerformer(WorkingEmployeeId);
      
    end;

  end

  else raise Exception.Create('Не задан обработчик сохранения поручений для документа');

end;

procedure TDocumentChargeSheetsFrame.SetCurrentRecordAccessRightsFieldValues;
begin

  with DataSetHolder do begin

    ChargeSectionAccessibleFieldValue := True;
    ResponseSectionAccessibleFieldValue := False;
    RemovingAllowedFieldValue := True;
    PerformingAllowedFieldValue := False;
    ViewingAllowedFieldValue := True;
    
  end;

end;

procedure TDocumentChargeSheetsFrame.SetEnabled(Value: Boolean);
begin

  inherited;

end;

procedure TDocumentChargeSheetsFrame.SetIssuingChargeSheetToolVisible(
  const Value: Boolean);
begin

  AddingChargeToolVisible := Value;

end;

procedure TDocumentChargeSheetsFrame.SetRemovingChargeSheetToolVisible(
  const Value: Boolean);
begin

  RemovingChargeToolVisible := Value;
  
end;

procedure TDocumentChargeSheetsFrame.SetSaveChargeSheetChangesToolVisible(
  const Value: Boolean);
begin

  SaveChargesChangesButton.Visible := Value;

  UpdateDocumentChargeControlPanel;
  
end;

procedure TDocumentChargeSheetsFrame.SetTableColumnLayout(
  FieldDefs: TDocumentChargeSheetSetFieldDefs
);
begin

  with FieldDefs do begin

    IssuingDateTimeColumn.DataBinding.FieldName := IssuingDateTimeFieldName;
    IssuerNameColumn.DataBinding.FieldName := IssuerNameFieldName;
    DocumentIdColumn.DataBinding.FieldName := DocumentIdFieldName;
    TopLevelChargeSheetIdColumn.DataBinding.FieldName := TopLevelChargeSheetIdFieldName;
    ViewDateByPerformerColumn.DataBinding.FieldName := ViewDateByPerformerFieldName;
    ChargeSectionAccessibleColumn.DataBinding.FieldName := ChargeSectionAccessibleFieldName;
    PerformingAllowedColumn.DataBinding.FieldName := PerformingAllowedFieldName;
    SubordinateChargeSheetsIssuingAllowedColumn.DataBinding.FieldName := SubordinateChargeSheetsIssuingAllowedFieldName;
    IsEmployeePerformerColumn.DataBinding.FieldName := IsEmployeePerformerFieldName;
    ChargeTreeList.DataController.KeyField := IdFieldName;
    ChargeTreeList.DataController.ParentField := TopLevelChargeSheetIdFieldName;

  end;

end;

procedure TDocumentChargeSheetsFrame.SetViewModel(
  const Value: TDocumentChargeSheetsFormViewModel);
begin

  FViewModel := Value;
  FFreeViewModel := Value;

  inherited ViewModel := Value.ChargesFormViewModel;

  SetTableColumnLayout(Value.DocumentChargeSheetSetHolder.FieldDefs);
  
end;

procedure TDocumentChargeSheetsFrame.SetViewOnly(
  const Value: Boolean);
begin

  inherited SetViewOnly(Value);

  SaveChargesChangesButton.Visible := not Value;
  
end;

procedure TDocumentChargeSheetsFrame.UpdateDocumentChargeControlPanelVisibility;
begin

  inherited UpdateDocumentChargeControlPanelVisibility;

  PerformerControlToolPanel.Visible :=
    PerformerControlToolPanel.Visible or SaveChargesChangesButton.Visible;

end;

function TDocumentChargeSheetsFrame
  .ValidateAllowableForPerformingChargeSheetsSelected: Boolean;

var
    PerformableChargeSheetIds, SelectedPerformableChargeSheetIds: TVariantList;
begin

  PerformableChargeSheetIds := FetchPerformableChargeSheetIds;

  try

    if PerformableChargeSheetIds.IsEmpty then begin

      ShowWarningMessage(
        Self.Handle,
        'Не найдены поручения для выполнения',
        'Сообщение'
      );

      Result := False;
      Exit;

    end;


    if
      (ChargeTreeList.SelectionCount = 0)
      and (PerformableChargeSheetIds.Count > 1)
    then
    begin

      ShowWarningMessage(
        Self.Handle,
        'Вы не выбрали поручения, которые ' +
        'хотите выполнить',
        'Сообщение'
      );

      Result := False;
      Exit;

    end;

    SelectedPerformableChargeSheetIds :=
      FetchSelectedPerformableChargeSheetIds;

    Result := not SelectedPerformableChargeSheetIds.IsEmpty;

    if not Result then begin

      ShowWarningMessage(
        Self.Handle,
        'Вы не можете выполнять ' +
        'недоступные Вам поручения',
        'Сообщение'
      );

    end;

  finally

    FreeAndNil(PerformableChargeSheetIds);

  end;

end;
                     {
function TDocumentChargeSheetsFrame.WasDocumentChargeRecordAddedByWorkingEmployeeInPast(
  SelectedDocumentReceiverNode: TcxTreeListNode): Boolean;
var CurrentWorkingEmployeeRecordId: Variant;
    DocumentSenderIdFieldIndex: Integer;
    ReplaceableChargeRecordIds: TVariantList;
    ReceiverSenderRecordId: Variant;
begin

  CurrentWorkingEmployeeRecordId :=
    FindRecordIdByReceiverId(WorkingEmployeeId);

  DocumentSenderIdFieldIndex :=
    DocumentReceiversTreeList.GetColumnByFieldName(
      DataSetHolder.TopLevelChargeSheetIdFieldName
    ).ItemIndex;

  ReceiverSenderRecordId :=
      SelectedDocumentReceiverNode.Values[DocumentSenderIdFieldIndex];

  ReplaceableChargeRecordIds :=
    FindReplaceableChargeRecordIdsByGivenReceiverId(WorkingEmployeeId);

  try

    Result :=
      (not VarIsNull(ReceiverSenderRecordId)) and
      ((ReceiverSenderRecordId = CurrentWorkingEmployeeRecordId) or
      ReplaceableChargeRecordIds.Contains(ReceiverSenderRecordId));
      
  finally

    FreeAndNil(ReplaceableChargeRecordIds);

  end;

end;    }

end.
