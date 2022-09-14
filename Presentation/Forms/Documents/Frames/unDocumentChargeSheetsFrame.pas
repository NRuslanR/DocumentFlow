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
  VariantListUnit, EmployeesReferenceFormUnit, EmployeeSetHolder;

type

  TDocumentChargeSheetsFrame = class(TDocumentChargesFrame)
    SaveChargesChangesButton: TcxButton;
    DocumentChargeSenderColumn: TcxDBTreeListColumn;
    actSaveChargeRecordsChanges: TAction;

    procedure DocumentReceiversTreeListEditing(Sender: TcxCustomTreeList;
      AColumn: TcxTreeListColumn; var Allow: Boolean);
    procedure DocumentReceiversTreeListDblClick(Sender: TObject);
    procedure actSaveChargeRecordsChangesExecute(Sender: TObject);
    procedure DocumentReceiversTreeListCustomDrawDataCell(
      Sender: TcxCustomTreeList; ACanvas: TcxCanvas;
      AViewInfo: TcxTreeListEditCellViewInfo; var ADone: Boolean);
    procedure actAddReceiversExecute(Sender: TObject);

  private
    { Private declarations }

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

    function GetDocumentChargePerformerSetHolder: TEmployeeSetHolder; override;

  protected

    function CreateDocumentChargePerformersReferenceForm:
      TDocumentChargePerformersReferenceForm; override;

  protected

    procedure InitializeLayout; override;
    procedure SetEnabled(Value: Boolean); override;

    procedure SetViewOnly(const Value: Boolean); override;

    procedure SetTableColumnLayout(FieldDefs: TDocumentChargeSetFieldDefs); override;

    function WasDocumentChargeRecordAddedByWorkingEmployeeInPast(
      SelectedDocumentReceiverNode: TcxTreeListNode
    ): Boolean; override;

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

  public
    { Public declarations }

    destructor Destroy; override;
    constructor Create(AOwner: TComponent); override;
    
    procedure CopyUISettings(
      DocumentInformationFrame: TDocumentFlowInformationFrame
    ); override;

    function ValidateAllowableForPerformingChargesSelected: Boolean;

    function FetchSelectedChargeIds: TVariantList;

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

  DocumentChargeSheetPerformerSetReadService,
  AuxDebugFunctionsUnit,
  AuxWindowsFunctionsUnit,
  InputMemoFormUnit,
  DocumentFlowSystemInputMemoFormUnit,
  EmployeeSetReadService,
  ApplicationServiceRegistries,
  WorkingEmployeeUnit,
  CommonControlStyles,
  DocumentChargePerformerSetReadService;

{$R *.dfm}

{ TDocumentChargesFrame2 }

procedure TDocumentChargeSheetsFrame.actAddReceiversExecute(
  Sender: TObject);
begin

  if not
     ValidateCurrentChargeRecordOrReplaceableChargeRecordFocusedIfNecessary
  then Exit;
  
  if
    (GetWorkingEmployeeChargeCount > 1) and
    not ValidateFocusedChargeRecordNotPerformed
                      
  then Exit;

  AddDocumentReceiverFromEmployeesReference;

end;

procedure TDocumentChargeSheetsFrame.actSaveChargeRecordsChangesExecute(
  Sender: TObject);
begin

  SaveChargeRecordsChanges;

end;

function TDocumentChargeSheetsFrame.CanUserEditFocusedColumnField: Boolean;
begin

  with DataSetHolder do begin

    if not (IsFocusedColumn(ReceiverCommentFieldName) or
            IsFocusedColumn(ChargeTextFieldName))
    then begin

      Result := False;
      Exit;

    end;

    if IsFocusedColumn(ReceiverCommentFieldName) then
      Result := CanChangeCommentFieldForNode(DocumentReceiversTreeList.FocusedNode)

    else
      Result := CanChangeChargeFieldForNode(DocumentReceiversTreeList.FocusedNode);

  end;

end;

procedure TDocumentChargeSheetsFrame.CopyUISettings(
  DocumentInformationFrame: TDocumentFlowInformationFrame);
begin

  inherited;

end;

constructor TDocumentChargeSheetsFrame.Create(
  AOwner: TComponent);
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

destructor TDocumentChargeSheetsFrame.Destroy;
begin

  inherited;

end;

procedure TDocumentChargeSheetsFrame.DocumentReceiversTreeListCustomDrawDataCell(
  Sender: TcxCustomTreeList; ACanvas: TcxCanvas;
  AViewInfo: TcxTreeListEditCellViewInfo; var ADone: Boolean);
var RecordId: Variant;
    ReplaceableChargeRecordIds: TVariantList;
begin

  inherited;

  HighlightDocumentChargeRecordWith(ACanvas, AViewInfo);

end;

procedure TDocumentChargeSheetsFrame.DocumentReceiversTreeListDblClick(
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

    MarkCurrentChargeRecordAsChanged_RefactorFuture;

  end;

end;

procedure TDocumentChargeSheetsFrame.DocumentReceiversTreeListEditing(
  Sender: TcxCustomTreeList;
  AColumn: TcxTreeListColumn;
  var Allow: Boolean
);
var EditingFieldName: String;
begin

  inherited;
  //
  
end;


function TDocumentChargeSheetsFrame.FetchSelectedChargeIds: TVariantList;
var DocumentReceiverTreeNode: TcxDBTreeListNode;
    I: Integer;
    RecordId: Variant;
    ReplaceableChargeRecordIds: TVariantList;
begin

  if DocumentReceiversTreeList.SelectionCount = 0 then begin

    Result := nil;
    Exit;
    
  end;

  Result := TVariantList.Create;

  if GetWorkingEmployeeChargeCount = 1 then begin

    RecordId := FindRecordIdByReceiverId(WorkingEmployeeId);

    if VarIsNull(RecordId) then begin

      ReplaceableChargeRecordIds :=
        FindReplaceableChargeRecordIdsByGivenReceiverId(WorkingEmployeeId);

      RecordId := ReplaceableChargeRecordIds[0];

      ReplaceableChargeRecordIds.Destroy;
      
    end;

    Result.Add(RecordId);
    Exit;
    
  end;

  for I := 0 to DocumentReceiversTreeList.SelectionCount - 1 do begin

    DocumentReceiverTreeNode :=
      DocumentReceiversTreeList.Selections[I] as TcxDBTreeListNode;

    Result.Add(DocumentReceiverTreeNode.Values[RecordIdColumn.ItemIndex]);

  end;

end;

function TDocumentChargeSheetsFrame.GetDocumentChargePerformerSetHolder: TEmployeeSetHolder;
var
    DocumentChargeSheetPerformerSetReadService: IDocumentChargeSheetPerformerSetReadService;
begin

  DocumentChargeSheetPerformerSetReadService :=
    TApplicationServiceRegistries
      .Current
        .GetPresentationServiceRegistry
          .GetDocumentChargeSheetPerformerSetReadService(ServiceDocumentKind);

  Result :=
    DocumentChargeSheetPerformerSetReadService
      .FindDocumentChargeSheetPerformerSetForEmployee(WorkingEmployeeId);

end;

function TDocumentChargeSheetsFrame.GetFocusedColumnCaption: String;
begin

  Result := DocumentReceiversTreeList.FocusedColumn.Caption.Text;
  
end;

function TDocumentChargeSheetsFrame.GetFocusedColumnFieldName: String;
begin

  if not Assigned(DocumentReceiversTreeList.FocusedColumn) then begin
    Result := '';
    

  end

  else
    Result :=
      TcxDBTreeListColumn(
        DocumentReceiversTreeList.FocusedColumn
      ).DataBinding.FieldName;

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

procedure TDocumentChargeSheetsFrame.HighlightDocumentChargeRecordWith(
  Canvas: TcxCanvas; RecordViewInfo: TcxTreeListEditCellViewInfo);
var RecordId: Variant;
    ReplaceableChargeRecordIds: TVariantList;
    ChargeIsPerformed: Boolean;
    ChargeRecordColor: TColor;
begin

  ChargeIsPerformed :=
    not VarIsNull(RecordViewInfo.Node.Values[PerformingDateTimeColumn.ItemIndex]);

  if not ChargeIsPerformed then
    ChargeRecordColor := $0081e0ff

  else ChargeRecordColor := $0077ffda;
  
  RecordId := RecordViewInfo.Node.Values[RecordIdColumn.ItemIndex];

  ReplaceableChargeRecordIds :=
    FindReplaceableChargeRecordIdsByGivenReceiverId(WorkingEmployeeId);

  try

    if (RecordId = FindRecordIdByReceiverId(WorkingEmployeeId))
        or
       ReplaceableChargeRecordIds.Contains(RecordId)
    then begin

      if not (RecordViewInfo.Focused or RecordViewInfo.Selected) then
        Canvas.FillRect(RecordViewInfo.BoundsRect, ChargeRecordColor)

      else Canvas.Font.Color := ChargeRecordColor;

    end;
    
  finally

    FreeAndNil(ReplaceableChargeRecordIds);

  end;

end;

procedure TDocumentChargeSheetsFrame.InitializeLayout;
begin

  inherited;

  SaveChargesChangesButton.Colors.Default := DEFAULT_BACKGROUND_BUTTON_COLOR;

end;

function TDocumentChargeSheetsFrame.IsFocusedColumn(
  const FieldName: String
): Boolean;
var FocusedFieldColumn: TcxDBTreeListColumn;
begin

  Result := GetFocusedColumnFieldName = FieldName;

end;

procedure TDocumentChargeSheetsFrame.ReLayoutDocumentChargeControlPanel;
begin

  ApplyHorizontalLayoutToControls(
    [
      AddDocumentReceiverButton,
      RemoveDocumentReceiverButton,
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

      DataSetHolder.
        RevealNonRemovedChargeRecords;

      SelectChargeRecordByReceiverId(WorkingEmployeeId);
      
    end;

  end

  else raise Exception.Create('Не задан обработчик сохранения поручений для документа');

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
  FieldDefs: TDocumentChargeSetFieldDefs
);
begin

  inherited;

  with FieldDefs do begin

    
  end;

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

  ReceiverControlToolPanel.Visible :=
    ReceiverControlToolPanel.Visible or SaveChargesChangesButton.Visible;

end;

function TDocumentChargeSheetsFrame.ValidateAllowableForPerformingChargesSelected: Boolean;
var ReplaceableChargeRecordIds: TVariantList;
    WorkingEmployeeRecordId: Variant;
    I: Integer;
    DocumentReceiverTreeNode: TcxDBTreeListNode;
    SelectedRecordId: Variant;
begin

  try

    WorkingEmployeeRecordId :=
      FindRecordIdByReceiverId(WorkingEmployeeId);
      
    ReplaceableChargeRecordIds :=
      FindReplaceableChargeRecordIdsByGivenReceiverId(WorkingEmployeeId);

    if (DocumentReceiversTreeList.SelectionCount = 0) and
       (((not VarIsNull(WorkingEmployeeRecordId)) and
        (not ReplaceableChargeRecordIds.IsEmpty)) or
        (VarIsNull(WorkingEmployeeRecordId) and
         (ReplaceableChargeRecordIds.Count > 1)))

    then begin

      ShowWarningMessage(
        Self.Handle,
        'Вы не выбрали поручения, которые ' +
        'хотите исполнить',
        'Сообщение'
      );

      Result := False;
      Exit;
      
    end;

    if (VarIsNull(WorkingEmployeeRecordId) and
       (ReplaceableChargeRecordIds.Count = 1)) or
       ((not VarIsNull(WorkingEmployeeRecordId)) and
        (ReplaceableChargeRecordIds.IsEmpty))

    then begin

      Result := True;
      Exit;
      
    end;

    for I := 0 to DocumentReceiversTreeList.SelectionCount - 1 do begin

      DocumentReceiverTreeNode :=
        TcxDBTreeListNode(DocumentReceiversTreeList.Selections[I]);

      SelectedRecordId :=
        DocumentReceiverTreeNode.Values[RecordIdColumn.ItemIndex];

      if

          (SelectedRecordId <> WorkingEmployeeRecordId) and
          (not ReplaceableChargeRecordIds.Contains(SelectedRecordId))

      then begin

        ShowWarningMessage(
          Self.Handle,
          'Вы не можете исполнять ' +
          'недоступные Вам для работы поручения',
          'Сообщение'
        );
        
        Result := False;
        Exit;

      end;

      if
          not VarIsNull(
            DocumentReceiverTreeNode.Values[PerformingDateTimeColumn.ItemIndex]
          )

      then begin

        ShowWarningMessage(
          Self.Handle,
          'Вы не можете исполнять поручения, ' +
          'которые уже являются исполненными',
          'Сообщение'
        );

        Result := False;
        Exit;
        
      end;

    end;

    Result := True;
    
  finally

    FreeAndNil(ReplaceableChargeRecordIds);

  end;

end;

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

end;

end.
