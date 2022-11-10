unit unDocumentKindsFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxCustomData, cxStyles, cxTL, cxMaskEdit, cxTLdxBarBuiltInMenu, dxSkinsCore,
  dxSkinsDefaultPainters, cxInplaceContainer, cxDBTL, cxTLData, StdCtrls,
  ExtCtrls, DB, UIDocumentKindResolver, UIDocumentKinds, DocumentKinds,
  NativeDocumentKindDto, GlobalDocumentKindDto,
  DocumentKindsPanelController, EmployeeDocumentWorkStatisticsService,
  EmployeeDocumentWorkStatistics, UINativeDocumentKindResolver,
  DocumentKindsFormViewModel, DocumentKindSetHolder,
  unDocumentFlowInformationFrame, OperationalDocumentKindInfo,
  DocumentKindsFormViewModelMapper, ClientDataSetBuilder;

const

  WM_DOCUMENT_KIND_SELECTED_MESSAGE = WM_USER + 4;

type

  TOnDocumentKindsFillEventHandler =
    procedure (
      Sender: TObject
    ) of object;
    
  TOnDocumentKindSelectedEventHandler =
    procedure (
      Sender: TObject;
      SelectedDocumentKindInfo: TOperationalDocumentKindInfo
    ) of object;

  TDocumentKindsFrame = class(TDocumentFlowInformationFrame)
    DocumentTypesPanel: TPanel;
    DocumentKindsLabel: TLabel;
    DocumentKindTreeList: TcxDBTreeList;
    DocumentKindNameColumn: TcxDBTreeListColumn;
    DocumentKindIdColumn: TcxDBTreeListColumn;
    TopLevelDocumentKindIdColumn: TcxDBTreeListColumn;
    DocumentKindOriginalNameColumn: TcxDBTreeListColumn;
    DocumentKindsDataSource: TDataSource;
    procedure DocumentKindTreeListCustomDrawDataCell(Sender: TcxCustomTreeList;
      ACanvas: TcxCanvas; AViewInfo: TcxTreeListEditCellViewInfo;
      var ADone: Boolean);
    procedure DocumentKindTreeListFocusedNodeChanged(Sender: TcxCustomTreeList;
      APrevFocusedNode, AFocusedNode: TcxTreeListNode);
    procedure DocumentKindTreeListResize(Sender: TObject);

  private

    FViewModel: TDocumentKindsFormViewModel;

    procedure SetViewModel(const Value: TDocumentKindsFormViewModel);

    procedure InitFromViewModel(ViewModel: TDocumentKindsFormViewModel);

    procedure SetColumnLayout(DocumentKindSetFieldDefs: TDocumentKindSetFieldDefs);

  private

    FDocumentKindsGettingWaitingCount: Integer;
    FDestroyingRequested: Boolean;
    
  private

    FUIDocumentKindResolver: IUIDocumentKindResolver;
    FUINativeDocumentKindResolver: IUINativeDocumentKindResolver;
    
    FNativeDocumentKindDtos: TNativeDocumentKindDtos;
    FGlobalDocumentKindDtos: TGlobalDocumentKindDtos;
    
    FDocumentKindsPanelController: TDocumentKindsPanelController;
    FFreeDocumentKindsPanelController: IDocumentKindsPanelController;
    
  private

    FOnFillEventHandler: TOnDocumentKindsFillEventHandler;
    FOnDocumentKindSelectedEventHandler: TOnDocumentKindSelectedEventHandler;

    procedure RaiseOnFillEventHandler;
    
    procedure RaiseOnDocumentKindSelectedEventHandler(
      OperationalDocumentKindInfo: TOperationalDocumentKindInfo
    );

    procedure QueueDocumentKindSelectedMessage(
      OperationalDocumentKindInfo: TOperationalDocumentKindInfo
    );

    procedure HandleDocumentKindSelectedMessage(var Message: TMessage); message WM_DOCUMENT_KIND_SELECTED_MESSAGE;
    
  private

    function GetGetCurrentNativeDocumentKindId: Variant;
    procedure SetCurrentNativeDocumentKindId(const Value: Variant);
    
    function GetCurrentDocumentKindId: Variant;
    procedure SetCurrentDocumentKindId(const Value: Variant);

    function GetCurrentUIDocumentKind: TUIDocumentKindClass;

    function GetUIDocumentKind(const DocumentKindId: Variant): TUIDocumentKindClass;
    function GetServiceDocumentKind(const DocumentKindId: Variant): TDocumentKindClass;

    function GetWorkingDocumentKindIdByGlobal(const GlobalDocumentKindId: Variant): Variant;

    function GetNativeDocumentKindIdByGlobalDocumentKindId(const GlobalDocumentKindId: Variant): Variant;
    function GetGlobalDocumentKindIdByNativeDocumentKindId(const NativeDocumentKindId: Variant): Variant;

  private

    function GetCurrentServiceDocumentKind: TDocumentKindClass;

  private

    procedure OnDocumentWorkStatisticsFetchedEventHandler(
      Sender: Tobject;
      EmployeeDocumentWorkStatisticsList:
        TEmployeeDocumentWorkStatisticsList
    );

    procedure OnDocumentWorkStatisticsFetchingErrorEventHandler(
      Sender: TObject;
      const Error: Exception
    );

  private

    procedure GetEmployeeDocumentWorkStatisticsAsync;

    procedure SetCurrentUIDocumentKind(
      const Value: TUIDocumentKindClass
    );
    
    procedure SetDocumentKindsPanelController(
      const Value: TDocumentKindsPanelController);

  protected

    procedure ApplyUIStyles; override;

  protected

    procedure RestoreUIControlProperties; override;
    procedure SaveUIControlProperties; override;

    procedure RestoreDefaultUIControlProperties; override;
    procedure SaveDefaultUIControlProperties; override;

  public

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SafeDestroy;
    
  public

    procedure UpdateEmployeeDocumentWorkStatistics;
    procedure UpdateCurrentEmployeeDocumentKindWorkStatistics;
    procedure UpdateEmployeeDocumentKindWorkStatistics(const DocumentKindId: Variant);

  public

    procedure RefreshDocumentKindSetIfNecessary;
    
  public

    function IsDocumentKindsEmpty: Boolean;

    procedure OnShow; override;
    
  public

    property CurrentDocumentKindId: Variant
    read GetCurrentDocumentKindId write SetCurrentDocumentKindId;

    property CurrentUIDocumentKind: TUIDocumentKindClass
    read GetCurrentUIDocumentKind write SetCurrentUIDocumentKind;

  public

    property CurrentNativeDocumentKindId: Variant
    read GetGetCurrentNativeDocumentKindId write SetCurrentNativeDocumentKindId;

  public

    function IsCurrentDocumentKindValid: Boolean;

  public

    property UIDocumentKindResolver: IUIDocumentKindResolver
    read FUIDocumentKindResolver write FUIDocumentKindResolver;

    property UINativeDocumentKindResolver: IUINativeDocumentKindResolver
    read FUINativeDocumentKindResolver write FUINativeDocumentKindResolver;
    
  public

    property NativeDocumentKindDtos: TNativeDocumentKindDtos read FNativeDocumentKindDtos;
    property GlobalDocumentKindDtos: TGlobalDocumentKindDtos read FGlobalDocumentKindDtos;

  public

    property OnFillEventHandler: TOnDocumentKindsFillEventHandler
    read FOnFillEventHandler write FOnFillEventHandler;
    
    property OnDocumentKindSelectedEventHandler: TOnDocumentKindSelectedEventHandler
    read FOnDocumentKindSelectedEventHandler write FOnDocumentKindSelectedEventHandler;

  public

    property ViewModel: TDocumentKindsFormViewModel
    read FViewModel write SetViewModel;

    property DocumentKindsPanelController: TDocumentKindsPanelController
    read FDocumentKindsPanelController write SetDocumentKindsPanelController;
    
  end;

implementation

{$R *.dfm}

uses

  CommonControlStyles,
  AuxDebugFunctionsUnit,
  AuxWindowsFunctionsUnit,
  ApplicationServiceRegistries,
  GlobalDocumentKindsReadService,
  UIDocumentKindMapper,
  StandardUIDocumentKindResolver,
  StandardUIDocumentKindMapper,
  StandardUINativeDocumentKindResolver;

function TDocumentKindsFrame.IsCurrentDocumentKindValid: Boolean;
begin

  try

    GetCurrentUIDocumentKind;

    Result := True;
    
  except

    on E: TUIDocumentKindResolverException do Result := False;

  end;

end;

function TDocumentKindsFrame.IsDocumentKindsEmpty: Boolean;
begin

  Result :=
      not Assigned(DocumentKindsDataSource) or
      not Assigned(DocumentKindsDataSource.DataSet) or
      not DocumentKindsDataSource.DataSet.Active or
      DocumentKindsDataSource.DataSet.IsEmpty;
    
end;

procedure TDocumentKindsFrame.ApplyUIStyles;
begin

  inherited;

  DocumentTypesPanel.Color :=
    TDocumentFlowCommonControlStyles.GetPrimaryFrameBackgroundColor;

  DocumentKindsLabel.Font.Style := [fsBold];
  
end;

constructor TDocumentKindsFrame.Create(AOwner: TComponent);
begin

  inherited;

end;

procedure TDocumentKindsFrame.SafeDestroy;
begin

  if FDocumentKindsGettingWaitingCount > 0 then
    FDestroyingRequested := True

  else
    Destroy;

end;

procedure TDocumentKindsFrame.SaveDefaultUIControlProperties;
begin

  RefreshDocumentKindSetIfNecessary;
  
  inherited SaveDefaultUIControlProperties;

end;

procedure TDocumentKindsFrame.SaveUIControlProperties;
begin

  //RefreshDocumentKindSetIfNecessary;

  inherited SaveUIControlProperties;

end;

destructor TDocumentKindsFrame.Destroy;
begin

  FreeAndNil(FGlobalDocumentKindDtos);
  FreeAndNil(FNativeDocumentKindDtos);

  inherited;

end;

procedure TDocumentKindsFrame.DocumentKindTreeListCustomDrawDataCell(
  Sender: TcxCustomTreeList; ACanvas: TcxCanvas;
  AViewInfo: TcxTreeListEditCellViewInfo;
  var ADone: Boolean
);
begin

  if AViewInfo.Focused or AViewInfo.Selected then begin

    ACanvas.Brush.Color := TDocumentFlowCommonControlStyles.GetDocumentFlowBaseReferenceFormFocusedRecordColor;
    ACanvas.Font.Color := TDocumentFlowCommonControlStyles.GetDocumentFlowBaseReferenceFormFocusedCellTextColor;
    
  end;

end;

procedure TDocumentKindsFrame.DocumentKindTreeListFocusedNodeChanged(
  Sender: TcxCustomTreeList;
  APrevFocusedNode, AFocusedNode: TcxTreeListNode
);
var
  ChoosedDocumentKind: Variant;

  function SelectedDocumentKindAbsent: Boolean;
  begin

    Result := DocumentKindTreeList.SelectionCount = 0;

  end;

  function SelectedDocumentKindHasSubKinds: Boolean;
  begin

    Result := DocumentKindTreeList.Selections[0].Count >= 1;

  end;

begin
  
  if SelectedDocumentKindAbsent or SelectedDocumentKindHasSubKinds then
  begin

    if Assigned(APrevFocusedNode) then
      DocumentKindTreeList.FocusedNode := APrevFocusedNode;

    Exit;

  end;

  if APrevFocusedNode = AFocusedNode
  then Exit;

  ChoosedDocumentKind := AFocusedNode.Values[DocumentKindIdColumn.ItemIndex];

  if ViewModel.DocumentKindSetHolder.DocumentKindIdFieldValue <> ChoosedDocumentKind
  then begin
  
    ViewModel.DocumentKindSetHolder.LocateByDocumentKindId(
      AFocusedNode.Values[DocumentKindIdColumn.ItemIndex]
    );

  end;

  QueueDocumentKindSelectedMessage(
    TOperationalDocumentKindInfo.Create(
      ChoosedDocumentKind,
      GetWorkingDocumentKindIdByGlobal(ChoosedDocumentKind),
      GetServiceDocumentKind(ChoosedDocumentKind),
      GetUIDocumentKind(ChoosedDocumentKind)
    )
  );

end;

procedure TDocumentKindsFrame.DocumentKindTreeListResize(Sender: TObject);
begin

  inherited;

  //DocumentKindNameColumn.Width := DocumentKindTreeList.ClientWidth - 2;

end;

function TDocumentKindsFrame.GetCurrentDocumentKindId: Variant;
begin

  if not Assigned(DocumentKindTreeList.FocusedNode) then begin

    Result :=
      FUIDocumentKindResolver.ResolveIdForUIDocumentKind(
        TUIOutcomingServiceNoteKind
      )
  end

  else begin

    Result :=
      DocumentKindTreeList.FocusedNode.Values[
        DocumentKindIdColumn.ItemIndex
      ];

  end;
  
end;

function TDocumentKindsFrame.GetCurrentUIDocumentKind: TUIDocumentKindClass;
begin

  Result := GetUIDocumentKind(GetCurrentDocumentKindId);

end;

procedure TDocumentKindsFrame.UpdateCurrentEmployeeDocumentKindWorkStatistics;
begin

  UpdateEmployeeDocumentKindWorkStatistics(GetCurrentDocumentKindId);

end;

procedure TDocumentKindsFrame.UpdateEmployeeDocumentKindWorkStatistics(
  const DocumentKindId: Variant
);
var
    CurrentDocumentKind: TDocumentKindClass;

    EmployeeDocumentWorkStatisticsService:
      IEmployeeDocumentWorkStatisticsService;

    OutcommingDocumentKinds: array of Variant;
    IncommingDocumentKinds: array of Variant;

    EmployeeDocumentWorkStatisticsList: TEmployeeDocumentWorkStatisticsList;
begin

  CurrentDocumentKind := GetServiceDocumentKind(DocumentKindId);

  if not CurrentDocumentKind.InheritsFrom(TNativeDocumentKind) then Exit;
  
  EmployeeDocumentWorkStatisticsService :=
    TApplicationServiceRegistries.
    Current.
    GetStatisticsServiceRegistry.
    GetEmployeeDocumentWorkStatisticsService;


  if CurrentDocumentKind.InheritsFrom(TOutcomingDocumentKind) then begin

      EmployeeDocumentWorkStatisticsService.
        GetDocumentKindsWorkStatisticsForEmployeeAsync(
          [
            TOutcomingDocumentKindClass(CurrentDocumentKind)
          ],
          [],
          [],
          WorkingEmployeeId,
          OnDocumentWorkStatisticsFetchedEventHandler,
          OnDocumentWorkStatisticsFetchingErrorEventHandler
        );

  end

  else if CurrentDocumentKind.InheritsFrom(TIncomingDocumentKind)
  then begin

    EmployeeDocumentWorkStatisticsService.
      GetDocumentKindsWorkStatisticsForEmployeeAsync(
        [],
        [],
        [
          TIncomingDocumentKindClass(CurrentDocumentKind)
        ],
        WorkingEmployeeId,
        OnDocumentWorkStatisticsFetchedEventHandler,
        OnDocumentWorkStatisticsFetchingErrorEventHandler
      );

  end

  else if CurrentDocumentKind.InheritsFrom(TApproveableServiceNoteKind)
  then begin

    EmployeeDocumentWorkStatisticsService.
      GetDocumentKindsWorkStatisticsForEmployeeAsync(
        [],
        [
          TApproveableDocumentKindClass(CurrentDocumentKind)
        ],
        [],
        WorkingEmployeeId,
        OnDocumentWorkStatisticsFetchedEventHandler,
        OnDocumentWorkStatisticsFetchingErrorEventHandler
      );

  end

  else begin

    { refactor: }
    
    if
      CurrentDocumentKind.InheritsFrom(TInternalDocumentKind) or
      CurrentDocumentKind.InheritsFrom(TPersonnelOrderKind)
    then Exit;

    ShowErrorMessage(
      Self.Handle,
      Format(
        'Не распознан вид документов ' +
        'с идентификатором %s для ' +
        'сбора статистики работ по ' +
        'документам этого вида',
        [
          CurrentDocumentKindId
        ]
      ),
      'Ошибка'
    );

    Exit;

  end;

  FDocumentKindsPanelController.
    ShowLoadingEmployeeDocumentKindWorkStatisticsLabel(
      Self,
      GetUIDocumentKind(DocumentKindId),
      '(...)'
    );

  Inc(FDocumentKindsGettingWaitingCount);

end;

procedure TDocumentKindsFrame.GetEmployeeDocumentWorkStatisticsAsync;

var EmployeeDocumentWorkStatisticsService:
      IEmployeeDocumentWorkStatisticsService;
begin

  EmployeeDocumentWorkStatisticsService :=

    TApplicationServiceRegistries.
    Current.
    GetStatisticsServiceRegistry.
    GetEmployeeDocumentWorkStatisticsService;

  EmployeeDocumentWorkStatisticsService.
    GetDocumentWorkStatisticsForEmployeeAsync(
      WorkingEmployeeId,
      OnDocumentWorkStatisticsFetchedEventHandler,
      OnDocumentWorkStatisticsFetchingErrorEventHandler
    );

  FDocumentKindsPanelController.
    ShowLoadingEmployeeDocumentWorkStatisticsLabel(
      Self,
      '(...)'
    );

  Inc(FDocumentKindsGettingWaitingCount);

end;

function TDocumentKindsFrame.GetGetCurrentNativeDocumentKindId: Variant;
begin

  Result :=
    GetNativeDocumentKindIdByGlobalDocumentKindId(GetCurrentDocumentKindId);

end;

function TDocumentKindsFrame.GetGlobalDocumentKindIdByNativeDocumentKindId(
  const NativeDocumentKindId: Variant): Variant;
begin

  Result :=
    FGlobalDocumentKindDtos.FindByServiceTypeOrRaise(
      FNativeDocumentKindDtos.FindByIdOrRaise(NativeDocumentKindId).ServiceType
    ).Id;
    
end;

function TDocumentKindsFrame.GetNativeDocumentKindIdByGlobalDocumentKindId(
  const GlobalDocumentKindId: Variant): Variant;
begin

  Result := FGlobalDocumentKindDtos.FindByIdOrRaise(GlobalDocumentKindId).WorkingId;
  
end;

function TDocumentKindsFrame.GetServiceDocumentKind(
  const DocumentKindId: Variant
): TDocumentKindClass;
begin

  Result := FGlobalDocumentKindDtos.FindByIdOrRaise(DocumentKindId).ServiceType;

end;

function TDocumentKindsFrame.GetUIDocumentKind(
  const DocumentKindId: Variant
): TUIDocumentKindClass;
begin

  Result := FUIDocumentKindResolver.ResolveUIDocumentKindFromId(DocumentKindId);

end;

function TDocumentKindsFrame.GetWorkingDocumentKindIdByGlobal(
  const GlobalDocumentKindId: Variant): Variant;
begin

  Result :=
    FGlobalDocumentKindDtos.FindByIdOrRaise(GlobalDocumentKindId).WorkingId;
    
end;

procedure TDocumentKindsFrame.HandleDocumentKindSelectedMessage(
  var Message: TMessage
);
var
    OperationalDocumentKindInfo: TOperationalDocumentKindInfo;
begin

  OperationalDocumentKindInfo := TOperationalDocumentKindInfo(Message.LParam);

  RaiseOnDocumentKindSelectedEventHandler(OperationalDocumentKindInfo);

end;

procedure TDocumentKindsFrame.
  OnDocumentWorkStatisticsFetchedEventHandler(
    Sender: Tobject;
    EmployeeDocumentWorkStatisticsList: TEmployeeDocumentWorkStatisticsList
  );
begin

  Dec(FDocumentKindsGettingWaitingCount);

  if FDestroyingRequested then begin

    SafeDestroy;

    Exit;

  end;

  try

    if not Assigned(EmployeeDocumentWorkStatisticsList) then Exit;

    FDocumentKindsPanelController.SetEmployeeDocumentWorkStatistics(
      Self,
      EmployeeDocumentWorkStatisticsList
    );

  finally

    FreeAndNil(EmployeeDocumentWorkStatisticsList);
    
  end;

end;

procedure TDocumentKindsFrame.
  OnDocumentWorkStatisticsFetchingErrorEventHandler(
    Sender: TObject;
    const Error: Exception
  );
begin

  Dec(FDocumentKindsGettingWaitingCount);

  if FDestroyingRequested then begin

    SafeDestroy;

    Exit;
    
  end;

  ShowErrorMessage(
    Self.Handle, Error.Message, 'Ошибка'
  );

end;

procedure TDocumentKindsFrame.OnShow;
begin

  RefreshDocumentKindSetIfNecessary;
  
  inherited OnShow;

  if not IsDocumentKindsEmpty then
    DocumentKindTreeList.Root.Expand(True);

  RaiseOnFillEventHandler;

end;

procedure TDocumentKindsFrame.QueueDocumentKindSelectedMessage(
  OperationalDocumentKindInfo: TOperationalDocumentKindInfo);
begin

  PostMessage(
    Self.Handle,
    WM_DOCUMENT_KIND_SELECTED_MESSAGE,
    0,
    Integer(OperationalDocumentKindInfo)
  );
  
end;

function TDocumentKindsFrame.
  GetCurrentServiceDocumentKind: TDocumentKindClass;
begin

  Result := GetServiceDocumentKind(GetCurrentDocumentKindId);

end;

procedure TDocumentKindsFrame.UpdateEmployeeDocumentWorkStatistics;
begin

  GetEmployeeDocumentWorkStatisticsAsync;

end;

procedure TDocumentKindsFrame.RaiseOnDocumentKindSelectedEventHandler(
  OperationalDocumentKindInfo: TOperationalDocumentKindInfo
);
begin

  if Assigned(FOnDocumentKindSelectedEventHandler) then begin

    FOnDocumentKindSelectedEventHandler(
      Self,
      OperationalDocumentKindInfo
    );
    
  end;
  
end;

procedure TDocumentKindsFrame.RaiseOnFillEventHandler;
begin

  if Assigned(FOnFillEventHandler) then
    FOnFillEventHandler(Self);
    
end;

procedure TDocumentKindsFrame.RefreshDocumentKindSetIfNecessary;

var
    GlobalDocumentKindsReadService: IGlobalDocumentKindsReadService;
    UIDocumentKindMapper: IUIDocumentKindMapper;
begin

  if not IsDocumentKindsEmpty then Exit;

  GlobalDocumentKindsReadService :=
    TApplicationServiceRegistries
    .Current
    .GetPresentationServiceRegistry
    .GetGlobalDocumentKindsReadService;

  FGlobalDocumentKindDtos :=
    GlobalDocumentKindsReadService.GetGlobalDocumentKindDtos(
      WorkingEmployeeId
    );

  FNativeDocumentKindDtos :=
    FGlobalDocumentKindDtos.FetchNativeDocumentKindDtos;

  UIDocumentKindMapper := TStandardUIDocumentKindMapper.Create;

  FUIDocumentKindResolver :=
    TStandardUIDocumentKindResolver.Create(
      UIDocumentKindMapper,
      FGlobalDocumentKindDtos
    );

  FUINativeDocumentKindResolver :=
    TStandardUINativeDocumentKindResolver.Create(
      UIDocumentKindMapper,
      FNativeDocumentKindDtos
    );

  FDocumentKindsPanelController :=
    TDocumentKindsPanelController.Create(
      FUIDocumentKindResolver,
      FUINativeDocumentKindResolver,
      TDocumentKindsFormViewModelMapper.Create(
        TClientDataSetBuilder.Create
      )
    );
  
  FDocumentKindsPanelController.FillDocumentKindsControlFrom(
    Self,
    FGlobalDocumentKindDtos
  );

end;

procedure TDocumentKindsFrame.RestoreDefaultUIControlProperties;
begin

  RefreshDocumentKindSetIfNecessary;
  
  inherited RestoreDefaultUIControlProperties;

end;

procedure TDocumentKindsFrame.RestoreUIControlProperties;
begin

  RefreshDocumentKindSetIfNecessary;
  
  inherited RestoreUIControlProperties;

end;

procedure TDocumentKindsFrame.SetCurrentDocumentKindId(
  const Value: Variant
);
var
    DocumentKindTreeNode: TcxDBTreeListNode;
begin

  DocumentKindTreeList.BeginUpdate;

  try

    RefreshDocumentKindSetIfNecessary;

    ViewModel.DocumentKindSetHolder.LocateByDocumentKindId(Value);

  finally

    DocumentKindTreeList.EndUpdate;
    
  end;

end;

procedure TDocumentKindsFrame.SetCurrentUIDocumentKind(
  const Value: TUIDocumentKindClass
);
begin

  RefreshDocumentKindSetIfNecessary;
  
  SetCurrentDocumentKindId(
    FUIDocumentKindResolver.ResolveIdForUIDocumentKind(Value)
  );

end;

procedure TDocumentKindsFrame.SetDocumentKindsPanelController(
  const Value: TDocumentKindsPanelController);
begin

  FDocumentKindsPanelController := Value;

  FFreeDocumentKindsPanelController := FDocumentKindsPanelController;

end;

procedure TDocumentKindsFrame.SetCurrentNativeDocumentKindId(
  const Value: Variant);
begin

  CurrentDocumentKindId :=
    GetGlobalDocumentKindIdByNativeDocumentKindId(Value);
    
end;

procedure TDocumentKindsFrame.SetViewModel(
  const Value: TDocumentKindsFormViewModel);
begin

  if FViewModel = Value then Exit;

  FreeAndNil(FViewModel);
  
  FViewModel := Value;

  InitFromViewModel(Value);

end;

procedure TDocumentKindsFrame.InitFromViewModel(
  ViewModel: TDocumentKindsFormViewModel);
begin

  SetColumnLayout(ViewModel.DocumentKindSetHolder.FieldDefs);

  DocumentKindTreeList.BeginUpdate;

  try

    DocumentKindsDataSource.DataSet := ViewModel.DocumentKindSetHolder.DataSet;

  finally

    DocumentKindTreeList.EndUpdate;
    
  end;

end;

procedure TDocumentKindsFrame.SetColumnLayout(
  DocumentKindSetFieldDefs: TDocumentKindSetFieldDefs);
begin

  with DocumentKindSetFieldDefs do begin

    DocumentKindIdColumn.DataBinding.FieldName := DocumentKindIdFieldName;
    TopLevelDocumentKindIdColumn.DataBinding.FieldName := TopLevelDocumentKindIdFieldName;
    DocumentKindNameColumn.DataBinding.FieldName := DocumentKindNameFieldName;
    DocumentKindOriginalNameColumn.DataBinding.FieldName := OriginalDocumentKindNameFieldName;

    DocumentKindTreeList.DataController.KeyField := DocumentKindIdFieldName;
    DocumentKindTreeList.DataController.ParentField := TopLevelDocumentKindIdFieldName;

  end;

end;

end.
