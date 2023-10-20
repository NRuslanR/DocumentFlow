unit DocumentApprovingsFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unDocumentCardInformationFrame, ExtCtrls,
  DocumentApprovingCyclesReferenceFormUnit,
  DocumentApproversInfoFormUnit,
  DocumentApprovingsFormViewModel,
  DocumentApprovingViewModel,
  DocumentApprovingCycleViewModel,
  EmployeesReferenceFormUnit,
  AbstractDataSetHolder,
  DocumentApprovingCycleSetHolder,
  VariantListUnit,
  EmployeeSetHolder,
  StdCtrls, unDocumentFlowCardInformationFrame;

type

  TOnDocumentApprovingChangingRequestedEventHandler =
    procedure (
      Sender: TObject;
      CurrentApprovingCycleViewModel: TDocumentApprovingCycleViewModel;
      ApprovingViewModel: TDocumentApprovingViewModel
    ) of object;
    
  TOnDocumentApprovingsRemovingRequestedEventHandler =
    procedure (
      Sender: TObject;
      CurrentApprovingCycleViewModel: TDocumentApprovingCycleViewModel;
      DocumentApprovingsViewModel: TDocumentApprovingsViewModel
    ) of object;

type

  TDocumentApprovingsFrame = class(TDocumentCardInformationFrame)
    DocumentApprovingCyclesInfoArea: TPanel;
    Splitter1: TSplitter;
    DocumentApproversInfoArea: TPanel;
    DocumentApprovingCyclesLabel: TLabel;
    DocumentApproversLabel: TLabel;
    DocumentApprovingCyclesFormPanel: TPanel;
    DocumentApproversFormPanel: TPanel;
    procedure FrameResize(Sender: TObject);

  protected

    FGettingDocumentApprovingsOfNewCycleRequested: Boolean;
    FIsNewDocumentApprovingCycleCreatingRequested: Boolean;
    FIsDocumentApprovingDataChanged: Boolean;

    procedure Initialize; override;
    procedure ApplyUIStyles; override;
    procedure SetFont(const Value: TFont); override;

    procedure SetFormStyles(Form: TForm);

    procedure SubscribeOnEvents;

  protected

    FOnDocumentApprovingChangingRequestedEventHandler:
      TOnDocumentApprovingChangingRequestedEventHandler;

    FOnDocumentApprovingCompletingRequestedEventHandler:
      TOnDocumentApprovingCompletingRequestedEventHandler;

    FOnDocumentApprovingCycleRemovingRequestedEventHandler:
      TOnDocumentApprovingCycleRemovingRequestedEventHandler;

    FOnDocumentApprovingCycleRemovedEventHandler:
      TOnDocumentApprovingCycleRemovedEventHandler;

    FOnDocumentApprovingsRemovingRequestedEventHandler:
      TOnDocumentApprovingsRemovingRequestedEventHandler;

    FOnEmployeeReferenceForApprovingRequestedEventHandler:
      TOnEmployeeReferenceForApprovingRequestedEventHandler;

    FOnEmployeesAddingForApprovingRequestedEventHandler:
      TOnEmployeesAddingForApprovingRequestedEventHandler;

    FOnNewDocumentApprovingCycleCreatingRequestedEventHandler:
      TOnNewDocumentApprovingCycleCreatingRequestedEventHandler;

    FOnDocumentApprovingCycleSelectedEventHandler:
      TOnDocumentApprovingCycleSelectedEventHandler;

    FOnEmployeesAddedForApprovingEventHandler:
      TOnEmployeesAddedForApprovingEventHandler;

    FOnDocumentApprovingsRemovedEventHandler:
      TOnDocumentApprovingsRemovedEventHandler;

  protected

    FViewModel: TDocumentApprovingsFormViewModel;

    FDocumentApprovingCyclesReferenceForm: TDocumentApprovingCyclesReferenceForm;
    FDocumentApproversInfoForm: TDocumentApproversInfoForm;

    procedure SetViewModel(Value: TDocumentApprovingsFormViewModel);

    procedure SetDocumentApprovingCyclesReferenceForm(
      Value: TDocumentApprovingCyclesReferenceForm
    );

    procedure SetDocumentApproversInfoForm(
      Value: TDocumentApproversInfoForm
    );

    procedure InflateDocumentApprovingCyclesReferenceForm(
      DocumentApprovingCyclesReferenceForm: TDocumentApprovingCyclesReferenceForm
    );

    procedure InflateDocumentApproversInfoForm(
      DocumentApproversInfoForm: TDocumentApproversInfoForm
    );

    procedure InitializeFromViewModel(
      ViewModel: TDocumentApprovingsFormViewModel
    );

    procedure SetDocumentApprovingCyclesReferenceFormViewModel(
      DocumentApprovingCyclesReferenceForm: TDocumentApprovingCyclesReferenceForm;
      DocumentApprovingCycleSetHolder: TDocumentApprovingCycleSetHolder
    );
    
    procedure SetDocumentApproversInfoFormViewModel(
      DocumentApproversInfoForm: TDocumentApproversInfoForm;
      DocumentApprovingSetHolder: TDocumentApprovingSetHolder
    );

    procedure BeginUpdate;
    procedure EndUpdate;
    
  protected

    procedure SubscribeOnDocumentApproversInfoFormEvents(
      DocumentApproversInfoForm: TDocumentApproversInfoForm
    );

    procedure OnDocumentApprovingChangingRequestedEventHandle(
      Sender: TObject;
      ApprovingViewModel: TDocumentApprovingViewModel
    );

    procedure OnDocumentApprovingChangedEventHandler(
      Sender: TObject;
      ChangedApprovingViewModel: TDocumentApprovingViewModel
    );

    procedure OnEmployeeReferenceForApprovingRequestedEventHandle(
      Sender: TObject;
      var EmployeeReference: TEmployeesReferenceForm
    );

    procedure OnDocumentApprovingsRemovingRequestedEventHandle(
      Sender: TObject;
      DocumentApprovingsViewModel: TDocumentApprovingsViewModel
    );

    procedure OnDocumentApprovingsRemovedEventHandle(
      Sender: TObject;
      RemovedApprovingsViewModel: TDocumentApprovingsViewModel
    );

    procedure OnEmployeesAddingForApprovingRequestedEventHandle(
      Sender: TObject;
      EmployeeIds: TVariantList
    );

    procedure OnEmployeesAddedForApprovingEventHandle(
      Sender: TObject;
      EmployeeIds: TVariantList
    );

  protected

    procedure SubscribeOnDocumentApprovingCyclesReferenceFormEvents(
      DocumentApprovingCyclesReferenceForm: TDocumentApprovingCyclesReferenceForm
    );

    procedure OnNewDocumentApprovingCycleInfoAddedEventHandle(
      Sender: TObject;
      NewDocumentApprovingCycleViewModel: TDocumentApprovingCycleViewModel
    );

    procedure OnDocumentApprovingCycleRemovingRequestedEventHandle(
      Sender: TObject;
      CycleViewModel: TDocumentApprovingCycleViewModel
    );

    procedure OnDocumentApprovingCompletingRequestedEventHandle(
      Sender: TObject;
      CycleViewModel: TDocumentApprovingCycleViewModel
    );

    procedure OnNewDocumentApprovingCycleCreatingRequestedEventHandle(
      Sender: TObject;
      var NewDocumentApprovingCycleViewModel: TDocumentApprovingCycleViewModel
    );

    procedure OnDocumentApprovingCycleSelectedEventHandle(
      Sender: TObject;
      SelectedCycleViewModel: TDocumentApprovingCycleViewModel
    );

    procedure OnDocumentApprovingCycleRemovedEventHandle(
      Sender: TObject;
      RemovedDocumentApprovingCycleViewModel: TDocumentApprovingCycleViewModel
    );

  protected

    procedure OnEmployeeReferenceForApprovingRequested_ControllerEventHandler(
      Sender: TObject;
      var EmployeeReference: TEmployeesReferenceForm
    ); virtual;

  protected

    procedure RemoveDocumentApproversByCycleId(
      const CycleId: Variant
    );

    procedure SetCycleIdForAddedApprovings(
      const CycleId: Variant
    );
    
  protected

    function GetViewOnly: Boolean; override;
    procedure SetViewOnly(const Value: Boolean); override;

  public

    destructor Destroy; override;
    
    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(
      AOwner: TComponent;
      DocumentApprovingCyclesReferenceForm: TDocumentApprovingCyclesReferenceForm;
      DocumentApproversInfoForm: TDocumentApproversInfoForm;
      ViewModel: TDocumentApprovingsFormViewModel
    ); overload;

    function IsDataChanged: Boolean; override;
    procedure OnChangesApplied; override;
    procedure OnChangesApplyingFailed; override;
    procedure RaisePendingEvents; override;

  public

    function IsNewApprovingCycleSelected: Boolean;
    function GetApprovingsOfNewCycle: TDocumentApprovingsViewModel;
    function GetApprovingsOfFocusedCycle: TDocumentApprovingsViewModel;

    function GetAccessibleDocumentApprovingsOfNewCycle: TDocumentApprovingsViewModel;

    procedure AddDocumentApprovingCycleWithApprovers(
      const ApprovingCycleViewModel: TDocumentApprovingCycleViewModel;
      const ApproverSetHolder: TEmployeeSetHolder
    );

    procedure UpdateNewCycleDocumentApproving(
      DocumentApproving : TDocumentApprovingViewModel
    );
    
    property DocumentApprovingCyclesReferenceForm: TDocumentApprovingCyclesReferenceForm
    read FDocumentApprovingCyclesReferenceForm write SetDocumentApprovingCyclesReferenceForm;

    property DocumentApproversInfoForm: TDocumentApproversInfoForm
    read FDocumentApproversInfoForm write SetDocumentApproversInfoForm;
    
    property ViewModel: TDocumentApprovingsFormViewModel
    read FViewModel write SetViewModel;

  published

    property OnDocumentApprovingCycleSelectedEventHandler:
      TOnDocumentApprovingCycleSelectedEventHandler
    read FOnDocumentApprovingCycleSelectedEventHandler
    write FOnDocumentApprovingCycleSelectedEventHandler;

    property OnDocumentApprovingChangingRequestedEventHandler:
      TOnDocumentApprovingChangingRequestedEventHandler
    read FOnDocumentApprovingChangingRequestedEventHandler
    write FOnDocumentApprovingChangingRequestedEventHandler;

    property OnDocumentApprovingCompletingRequestedEventHandler:
      TOnDocumentApprovingCompletingRequestedEventHandler
    read FOnDocumentApprovingCompletingRequestedEventHandler
    write FOnDocumentApprovingCompletingRequestedEventHandler;

    property OnDocumentApprovingCycleRemovingRequestedEventHandler:
      TOnDocumentApprovingCycleRemovingRequestedEventHandler
    read FOnDocumentApprovingCycleRemovingRequestedEventHandler
    write FOnDocumentApprovingCycleRemovingRequestedEventHandler;

    property OnDocumentApprovingCycleRemovedEventHandler:
      TOnDocumentApprovingCycleRemovedEventHandler
    read FOnDocumentApprovingCycleRemovedEventHandler
    write FOnDocumentApprovingCycleRemovedEventHandler;
    
    property OnDocumentApprovingsRemovingRequestedEventHandler:
      TOnDocumentApprovingsRemovingRequestedEventHandler
    read FOnDocumentApprovingsRemovingRequestedEventHandler
    write FOnDocumentApprovingsRemovingRequestedEventHandler;

    property OnEmployeeReferenceForApprovingRequestedEventHandler:
      TOnEmployeeReferenceForApprovingRequestedEventHandler
    read FOnEmployeeReferenceForApprovingRequestedEventHandler
    write FOnEmployeeReferenceForApprovingRequestedEventHandler;

    property OnEmployeesAddingForApprovingRequestedEventHandler:
      TOnEmployeesAddingForApprovingRequestedEventHandler
    read FOnEmployeesAddingForApprovingRequestedEventHandler
    write FOnEmployeesAddingForApprovingRequestedEventHandler;

    property OnNewDocumentApprovingCycleCreatingRequestedEventHandler:
      TOnNewDocumentApprovingCycleCreatingRequestedEventHandler
    read FOnNewDocumentApprovingCycleCreatingRequestedEventHandler
    write FOnNewDocumentApprovingCycleCreatingRequestedEventHandler;

    property OnEmployeesAddedForApprovingEventHandler:
      TOnEmployeesAddedForApprovingEventHandler
    read FOnEmployeesAddedForApprovingEventHandler
    write FOnEmployeesAddedForApprovingEventHandler;

    property OnDocumentApprovingsRemovedEventHandler:
      TOnDocumentApprovingsRemovedEventHandler
    read FOnDocumentApprovingsRemovedEventHandler
    write FOnDocumentApprovingsRemovedEventHandler;

  end;

implementation

uses

  unDocumentCardFrame,
  ApplicationServiceRegistries,
  CommonControlStyles,
  DocumentApproverSetReadService,
  AuxDebugFunctionsUnit,
  AuxWindowsFunctionsUnit, PresentationServiceRegistry;
  
{$R *.dfm}

{ TDocumentApprovingsFrame }

constructor TDocumentApprovingsFrame.Create(AOwner: TComponent);
begin

  inherited;

end;

procedure TDocumentApprovingsFrame.AddDocumentApprovingCycleWithApprovers(
  const ApprovingCycleViewModel: TDocumentApprovingCycleViewModel;
  const ApproverSetHolder: TEmployeeSetHolder
);
begin

  if
    not Assigned(FDocumentApprovingCyclesReferenceForm) or
    not Assigned(FDocumentApproversInfoForm) or
    ApproverSetHolder.IsEmpty
  then Exit;

  FDocumentApprovingCyclesReferenceForm.AddDocumentApprovingCycleRecordFrom(
    ApprovingCycleViewModel
  );

  try

    FDocumentApproversInfoForm.AddApproversFromEmployeeSetHolder(ApproverSetHolder);

  except

    FDocumentApprovingCyclesReferenceForm.RemoveApprovingCycleRecordBy(
      ApprovingCycleViewModel
    );

    Raise;

  end;

end;

procedure TDocumentApprovingsFrame.ApplyUIStyles;
begin

  inherited ApplyUIStyles;

  if Assigned(FDocumentApprovingCyclesReferenceForm) then
    SetFormStyles(FDocumentApprovingCyclesReferenceForm);

  if Assigned(FDocumentApproversInfoForm) then
    SetFormStyles(FDocumentApproversInfoForm);

  DocumentApproversLabel.Font.Style := [fsBold];
  DocumentApprovingCyclesLabel.Font.Style := [fsBold];
  
end;

procedure TDocumentApprovingsFrame.BeginUpdate;
begin

  if Assigned(FDocumentApprovingCyclesReferenceForm) then
    FDocumentApprovingCyclesReferenceForm.BeginUpdate;

  if Assigned(FDocumentApproversInfoForm) then
    FDocumentApproversInfoForm.BeginUpdate;
  
end;

constructor TDocumentApprovingsFrame.Create(
  AOwner: TComponent;
  DocumentApprovingCyclesReferenceForm: TDocumentApprovingCyclesReferenceForm;
  DocumentApproversInfoForm: TDocumentApproversInfoForm;
  ViewModel: TDocumentApprovingsFormViewModel
);
begin

  inherited Create(AOwner);

  Self.DocumentApproversInfoForm := DocumentApproversInfoForm;
  Self.DocumentApprovingCyclesReferenceForm := DocumentApprovingCyclesReferenceForm;
  
  Self.ViewModel := ViewModel;
  
end;

destructor TDocumentApprovingsFrame.Destroy;
begin

  { FreeAndNil(FViewModel);
    пока удаляется внутри объемлющей карточки,
    в будущем воспользоваться интерфейсами
  }

  if Assigned(FDocumentApprovingCyclesReferenceForm) then begin

    FDocumentApprovingCyclesReferenceForm.Parent.RemoveControl(
      FDocumentApprovingCyclesReferenceForm
    );

    if Assigned(FDocumentApprovingCyclesReferenceForm.Owner) then begin

      FDocumentApprovingCyclesReferenceForm.Owner.RemoveComponent(
        FDocumentApprovingCyclesReferenceForm
      );

    end;

    FDocumentApprovingCyclesReferenceForm.SafeDestroy;

  end;

  inherited;

end;

procedure TDocumentApprovingsFrame.EndUpdate;
begin

  if Assigned(FDocumentApprovingCyclesReferenceForm) then
    FDocumentApprovingCyclesReferenceForm.EndUpdate;

  if Assigned(FDocumentApproversInfoForm) then
    FDocumentApproversInfoForm.EndUpdate;

end;

procedure TDocumentApprovingsFrame.FrameResize(Sender: TObject);
begin

  inherited;

  CenterWindowRelativeByHorz(
    DocumentApprovingCyclesLabel,
    DocumentApprovingCyclesInfoArea
  );

  CenterWindowRelativeByHorz(
    DocumentApproversLabel,
    DocumentApproversInfoArea
  );

end;

function TDocumentApprovingsFrame.GetApprovingsOfNewCycle: TDocumentApprovingsViewModel;
var PreviousSelectedApprovingCycleViewModel:
      TDocumentApprovingCycleViewModel;
begin

  if not Assigned(FDocumentApprovingCyclesReferenceForm) or
     not Assigned(FDocumentApproversInfoForm)

  then begin

    Result := nil;
    Exit;

  end;

  if not FDocumentApprovingCyclesReferenceForm.IsNewApprovingCycleRecordFocused
  then begin

    PreviousSelectedApprovingCycleViewModel :=
      FDocumentApprovingCyclesReferenceForm.GetFocusedApprovingCycleViewModel;
      
    try

      FGettingDocumentApprovingsOfNewCycleRequested := True;

      if FDocumentApprovingCyclesReferenceForm.SelectNewApprovingCycleRecord
      then begin

        Result := FDocumentApproversInfoForm.GetAllApprovingsViewModel;
        
        FDocumentApprovingCyclesReferenceForm.SelectApprovingCycleByNumber(
          PreviousSelectedApprovingCycleViewModel.CycleNumber
        );

      end

      else Result := nil;

    finally

      FGettingDocumentApprovingsOfNewCycleRequested := False;

      FreeAndNil(PreviousSelectedApprovingCycleViewModel);

    end;

  end

  else Result := FDocumentApproversInfoForm.GetAllApprovingsViewModel;
  
end;

function TDocumentApprovingsFrame.GetAccessibleDocumentApprovingsOfNewCycle: TDocumentApprovingsViewModel;
var PreviousSelectedApprovingCycleViewModel:
      TDocumentApprovingCycleViewModel;
 begin

  if
      not Assigned(FDocumentApprovingCyclesReferenceForm) or
      not Assigned(FDocumentApproversInfoForm)
  then begin

    Result := nil;
    Exit;

  end;

  if not FDocumentApprovingCyclesReferenceForm.IsNewApprovingCycleRecordFocused
  then begin

    PreviousSelectedApprovingCycleViewModel :=
      FDocumentApprovingCyclesReferenceForm.GetFocusedApprovingCycleViewModel;

    try

      FGettingDocumentApprovingsOfNewCycleRequested := True;

      if FDocumentApprovingCyclesReferenceForm.SelectNewApprovingCycleRecord
      then begin

        Result := FDocumentApproversInfoForm.GetAccessibleApprovingsViewModel;

        FDocumentApprovingCyclesReferenceForm.SelectApprovingCycleByNumber(
          PreviousSelectedApprovingCycleViewModel.CycleNumber
        );
        
      end

      else Result := nil;

    finally

      FGettingDocumentApprovingsOfNewCycleRequested := False;

      FreeAndNil(PreviousSelectedApprovingCycleViewModel);
      
    end;
    
  end

  else
    Result := FDocumentApproversInfoForm.GetAccessibleApprovingsViewModel;

end;

function TDocumentApprovingsFrame.GetApprovingsOfFocusedCycle: TDocumentApprovingsViewModel;
begin

  if not Assigned(FDocumentApprovingCyclesReferenceForm) or
     not Assigned(FDocumentApproversInfoForm)

  then begin

    Result := nil;
    Exit;

  end;

  Result := FDocumentApproversInfoForm.GetAllApprovingsViewModel;

end;

function TDocumentApprovingsFrame.GetViewOnly: Boolean;
begin

  Result :=
    Assigned(FDocumentApprovingCyclesReferenceForm) and
    FDocumentApprovingCyclesReferenceForm.ViewOnly and
    Assigned(FDocumentApproversInfoForm) and
    FDocumentApproversInfoForm.ViewOnly;
  
end;

procedure TDocumentApprovingsFrame.InflateDocumentApproversInfoForm(
  DocumentApproversInfoForm: TDocumentApproversInfoForm);
begin

  DocumentApproversInfoForm.Parent := DocumentApproversFormPanel;
  DocumentApproversInfoForm.Align := alClient;
  DocumentApproversInfoForm.BorderStyle := bsNone;

  DocumentApproversInfoForm.Show;
  
end;

procedure TDocumentApprovingsFrame.InflateDocumentApprovingCyclesReferenceForm(
  DocumentApprovingCyclesReferenceForm: TDocumentApprovingCyclesReferenceForm);
begin

  DocumentApprovingCyclesReferenceForm.Parent := DocumentApprovingCyclesFormPanel;
  DocumentApprovingCyclesReferenceForm.Align := alClient;
  DocumentApprovingCyclesReferenceForm.BorderStyle := bsNone;

  DocumentApprovingCyclesReferenceForm.Show;
  
end;

procedure TDocumentApprovingsFrame.Initialize;
begin

  inherited;

  FGettingDocumentApprovingsOfNewCycleRequested := False;
  FIsNewDocumentApprovingCycleCreatingRequested := False;
  FIsDocumentApprovingDataChanged := False;

  SubscribeOnEvents;
  
end;

procedure TDocumentApprovingsFrame.InitializeFromViewModel(
  ViewModel: TDocumentApprovingsFormViewModel
);
begin

  BeginUpdate;

  try

    if Assigned(FDocumentApprovingCyclesReferenceForm) then begin

      SetDocumentApprovingCyclesReferenceFormViewModel(
        FDocumentApprovingCyclesReferenceForm,
        ViewModel.DocumentApprovingCycleSetHolder
      );

    end;

    if Assigned(FDocumentApproversInfoForm) then begin

      SetDocumentApproversInfoFormViewModel(
        FDocumentApproversInfoForm,
        ViewModel.DocumentApprovingSetHolder
      );

    end;

  finally

    EndUpdate;
    
  end;

end;

function TDocumentApprovingsFrame.IsDataChanged: Boolean;
begin

  Result := FIsDocumentApprovingDataChanged;
  
end;

function TDocumentApprovingsFrame.IsNewApprovingCycleSelected: Boolean;
begin

  if not Assigned(FDocumentApprovingCyclesReferenceForm) then
  begin

    Result := False;
    Exit;
    
  end;

  Result :=
    FDocumentApprovingCyclesReferenceForm.IsNewApprovingCycleRecordFocused;
  
end;

procedure TDocumentApprovingsFrame.OnChangesApplied;
begin

  FIsDocumentApprovingDataChanged := False;

end;

procedure TDocumentApprovingsFrame.OnChangesApplyingFailed;
begin

  inherited;

end;

procedure TDocumentApprovingsFrame.OnDocumentApprovingChangedEventHandler(
  Sender: TObject;
  ChangedApprovingViewModel: TDocumentApprovingViewModel
);
begin

  FIsDocumentApprovingDataChanged := True;

end;

procedure TDocumentApprovingsFrame.
  OnDocumentApprovingChangingRequestedEventHandle(
    Sender: TObject;
    ApprovingViewModel: TDocumentApprovingViewModel
  );
var CurrentApprovingCycleViewModel: TDocumentApprovingCycleViewModel;
begin

  if Assigned(FOnDocumentApprovingChangingRequestedEventHandler) then begin

    CurrentApprovingCycleViewModel :=
      FDocumentApprovingCyclesReferenceForm.GetFocusedApprovingCycleViewModel;

    try

      FOnDocumentApprovingChangingRequestedEventHandler(
        Self, CurrentApprovingCycleViewModel, ApprovingViewModel
      );

    finally

      FreeAndNil(CurrentApprovingCycleViewModel);
      
    end;

  end;
end;

procedure TDocumentApprovingsFrame.
  OnDocumentApprovingCompletingRequestedEventHandle(
    Sender: TObject;
    CycleViewModel: TDocumentApprovingCycleViewModel
  );
begin

  if Assigned(FOnDocumentApprovingCompletingRequestedEventHandler) then
    FOnDocumentApprovingCompletingRequestedEventHandler(
      Self, CycleViewModel
    );
    
end;

procedure TDocumentApprovingsFrame.OnDocumentApprovingCycleRemovedEventHandle(
  Sender: TObject;
  RemovedDocumentApprovingCycleViewModel: TDocumentApprovingCycleViewModel
);
begin

  RemoveDocumentApproversByCycleId(
    RemovedDocumentApprovingCycleViewModel.CycleId
  );

  FDocumentApproversInfoForm.ApprovingsControlPanelVisible := False;

  if Assigned(FOnDocumentApprovingCycleRemovedEventHandler) then begin
  
    FOnDocumentApprovingCycleRemovedEventHandler(
      Sender, RemovedDocumentApprovingCycleViewModel
    );

  end;

end;

procedure TDocumentApprovingsFrame.
  OnDocumentApprovingCycleRemovingRequestedEventHandle(
    Sender: TObject;
    CycleViewModel: TDocumentApprovingCycleViewModel
  );
begin

  if Assigned(FOnDocumentApprovingCycleRemovingRequestedEventHandler) then
    OnDocumentApprovingCycleRemovingRequestedEventHandler(
      Self, CycleViewModel
    );

end;

procedure TDocumentApprovingsFrame.
  OnDocumentApprovingCycleSelectedEventHandle(
    Sender: TObject;
    SelectedCycleViewModel: TDocumentApprovingCycleViewModel
  );
var AddingApproversOptionsEnabled: Boolean;
    RemovingApproversOptionsEnabled: Boolean;
begin

  if not Assigned(FDocumentApproversInfoForm) then Exit;

  if not FGettingDocumentApprovingsOfNewCycleRequested then begin

    if Assigned(FOnDocumentApprovingCycleSelectedEventHandler) then
      FOnDocumentApprovingCycleSelectedEventHandler(
        Self, SelectedCycleViewModel
      );

  end;

  FViewModel.DocumentApprovingSetHolder.FilterByCycleId(
    SelectedCycleViewModel.CycleId
  );

  if VarIsNull(SelectedCycleViewModel.CanBeChanged) then begin

    AddingApproversOptionsEnabled := SelectedCycleViewModel.IsNew;
    RemovingApproversOptionsEnabled := SelectedCycleViewModel.IsNew;

  end

  else begin

    AddingApproversOptionsEnabled := SelectedCycleViewModel.CanBeChanged;
    RemovingApproversOptionsEnabled := SelectedCycleViewModel.CanBeChanged;

  end;

  FDocumentApproversInfoForm.AddingApproversOptionsVisible :=
    AddingApproversOptionsEnabled;

  FDocumentApproversInfoForm.RemovingApproversOptionsVisible :=
    RemovingApproversOptionsEnabled;

end;

procedure TDocumentApprovingsFrame.OnDocumentApprovingsRemovedEventHandle(
  Sender: TObject;
  RemovedApprovingsViewModel: TDocumentApprovingsViewModel
);
begin

  FIsDocumentApprovingDataChanged := True;

  if Assigned(FOnDocumentApprovingsRemovedEventHandler) then
    FOnDocumentApprovingsRemovedEventHandler(
      Self, RemovedApprovingsViewModel
    );
    
end;

procedure TDocumentApprovingsFrame.
  OnDocumentApprovingsRemovingRequestedEventHandle(
    Sender: TObject;
    DocumentApprovingsViewModel: TDocumentApprovingsViewModel
  );
var CurrentApprovingCycleViewModel: TDocumentApprovingCycleViewModel;
begin

  if Assigned(FOnDocumentApprovingsRemovingRequestedEventHandler) then begin

    CurrentApprovingCycleViewModel :=
      FDocumentApprovingCyclesReferenceForm.GetFocusedApprovingCycleViewModel;

    try

      FOnDocumentApprovingsRemovingRequestedEventHandler(
        Self, CurrentApprovingCycleViewModel, DocumentApprovingsViewModel
      );

    finally

      FreeAndNil(CurrentApprovingCycleViewModel);

    end;

  end;

end;

procedure TDocumentApprovingsFrame.
  OnEmployeeReferenceForApprovingRequestedEventHandle(
    Sender: TObject;
    var EmployeeReference: TEmployeesReferenceForm
  );
begin

  if Assigned(FOnEmployeeReferenceForApprovingRequestedEventHandler) then
    FOnEmployeeReferenceForApprovingRequestedEventHandler(
      Self, EmployeeReference
    );
  
end;

procedure TDocumentApprovingsFrame.
  OnEmployeeReferenceForApprovingRequested_ControllerEventHandler(
    Sender: TObject;
    var EmployeeReference: TEmployeesReferenceForm
  );
var DocumentApproverSetReadService: IDocumentApproverSetReadService;
begin

  { refactor:
    создать контроллер фрейма согласования документа<
    перенести обработчики событий в этот контроллер
  }
  
  try

    Screen.Cursor := crHourGlass;

    DocumentApproverSetReadService :=
      TApplicationServiceRegistries
      .Current
      .GetPresentationServiceRegistry
      .GetDocumentApproverSetReadService(ServiceDocumentKind);

    EmployeeReference := TEmployeesReferenceForm.Create(Self, 'Выбор согласовантов', True);

    EmployeeReference.DataSetHolder :=
      DocumentApproverSetReadService.GetDocumentApproverSetForEmployee(
        WorkingEmployeeId
      );

  finally

    Screen.Cursor := crDefault;

  end;
    
end;

procedure TDocumentApprovingsFrame.
  OnEmployeesAddedForApprovingEventHandle(
    Sender: TObject;
    EmployeeIds: TVariantList
  );
var ApprovingCycleViewModel: TDocumentApprovingCycleViewModel;
    DocumentApprovingSetHolder: TDocumentApprovingSetHolder;
    FocusedApprovingCycleId: Variant;
begin

  FIsDocumentApprovingDataChanged := True;

  if FIsNewDocumentApprovingCycleCreatingRequested then Exit;

  ApprovingCycleViewModel :=
    FDocumentApprovingCyclesReferenceForm.GetFocusedApprovingCycleViewModel;

  if not Assigned(ApprovingCycleViewModel) then Exit;

  FocusedApprovingCycleId := ApprovingCycleViewModel.CycleId;

  ApprovingCycleViewModel.Destroy;

  SetCycleIdForAddedApprovings(FocusedApprovingCycleId);

  if Assigned(FOnEmployeesAddedForApprovingEventHandler) then
    FOnEmployeesAddedForApprovingEventHandler(
      Sender, EmployeeIds
    );

end;

procedure TDocumentApprovingsFrame.
  OnEmployeesAddingForApprovingRequestedEventHandle(
    Sender: TObject;
    EmployeeIds: TVariantList
  );
begin

  if Assigned(FOnEmployeesAddingForApprovingRequestedEventHandler) then
    FOnEmployeesAddingForApprovingRequestedEventHandler(
      Self, EmployeeIds
    );

end;

procedure TDocumentApprovingsFrame.
  OnNewDocumentApprovingCycleCreatingRequestedEventHandle(
    Sender: TObject;
    var NewDocumentApprovingCycleViewModel: TDocumentApprovingCycleViewModel
  );

begin

  if not Assigned(FDocumentApproversInfoForm) then Exit;
  
  if not Assigned(OnNewDocumentApprovingCycleCreatingRequestedEventHandler)
  then begin

    Raise Exception.Create(
      'OnNewDocumentApprovingCycleCreatingRequestedEventHandler not assigned'
    );

  end;

  FIsNewDocumentApprovingCycleCreatingRequested := True;

  try

    FViewModel.DocumentApprovingSetHolder.FilterByNewApprovings(
      True, famDisableControls
    );

    if FDocumentApproversInfoForm.AddApproversFromEmployeeReference
    then begin

      FOnNewDocumentApprovingCycleCreatingRequestedEventHandler(
        Self, NewDocumentApprovingCycleViewModel
      );

    end;

  except

    on e: Exception do begin

      FIsNewDocumentApprovingCycleCreatingRequested := False;

      raise;
      
    end;

  end;

end;

procedure TDocumentApprovingsFrame.
  OnNewDocumentApprovingCycleInfoAddedEventHandle(
    Sender: TObject;
    NewDocumentApprovingCycleViewModel: TDocumentApprovingCycleViewModel
  );
begin

  try

    SetCycleIdForAddedApprovings(NewDocumentApprovingCycleViewModel.CycleId);

  finally

    FIsNewDocumentApprovingCycleCreatingRequested := False;
    
  end;
  
end;

{ refactor: Реализовать механизм ожидающих событий (
 тех, для которых не был задан обработчик в то
 время, когда они были опубликованы }
procedure TDocumentApprovingsFrame.RaisePendingEvents;
begin

  if not Assigned(FDocumentApprovingCyclesReferenceForm) then Exit;
  if not Assigned(FViewModel) then Exit;
  
  FDocumentApprovingCyclesReferenceForm.
    DocumentApprovingCycleSetHolder :=
      FViewModel.DocumentApprovingCycleSetHolder;

end;

procedure TDocumentApprovingsFrame.RemoveDocumentApproversByCycleId(
  const CycleId: Variant);
var DocumentApprovingSetHolder:
      TDocumentApprovingSetHolder;
begin

  if not Assigned(FDocumentApproversInfoForm) then Exit;

  DocumentApprovingSetHolder :=
    FDocumentApproversInfoForm.DocumentApprovingSetHolder;

  DocumentApprovingSetHolder.FilterByCycleId(
    CycleId, famDisableControls
  );

  try

    DocumentApprovingSetHolder.First;

    while not DocumentApprovingSetHolder.Eof do begin

      DocumentApprovingSetHolder.Delete;

      FIsDocumentApprovingDataChanged := True;

    end;

  finally

    DocumentApprovingSetHolder.EnableControls;
    
  end;

end;

procedure TDocumentApprovingsFrame.SetCycleIdForAddedApprovings(
  const CycleId: Variant);
var
    CurrentDocumentApprovingRecordPointer: Pointer;
    DocumentApprovingSetHolder: TDocumentApprovingSetHolder;
begin

  DocumentApprovingSetHolder :=
    FViewModel.DocumentApprovingSetHolder;

  CurrentDocumentApprovingRecordPointer :=
    DocumentApprovingSetHolder.GetBookmark;

  try

    DocumentApprovingSetHolder.RevealRecordsWithGeneratedId;

    while not DocumentApprovingSetHolder.Eof do begin

      if VarIsNull(DocumentApprovingSetHolder.ApprovingCycleIdFieldValue) 
      then begin

        DocumentApprovingSetHolder.Edit;

        DocumentApprovingSetHolder.ApprovingCycleIdFieldValue := CycleId;

        DocumentApprovingSetHolder.Post;

      end;

      DocumentApprovingSetHolder.Next;
      
    end;
    
  finally

    try

      DocumentApprovingSetHolder.FilterByCycleId(CycleId);

    finally

      if
        not DocumentApprovingSetHolder.GotoBookmarkAndFree(
          CurrentDocumentApprovingRecordPointer
        )
      then DocumentApprovingSetHolder.First;
      
    end;

  end;

end;

procedure TDocumentApprovingsFrame.SetDocumentApproversInfoForm(
  Value: TDocumentApproversInfoForm);
begin

  FreeAndNil(FDocumentApproversInfoForm);

  FDocumentApproversInfoForm := Value;

  FDocumentApproversInfoForm.Font := Font;

  InflateDocumentApproversInfoForm(FDocumentApproversInfoForm);

  SubscribeOnDocumentApproversInfoFormEvents(FDocumentApproversInfoForm);

  SetFormStyles(FDocumentApproversInfoForm);

  FDocumentApproversInfoForm.ViewOnly := ViewOnly;

  FDocumentApproversInfoForm.ApprovingsControlPanelVisible := not ViewOnly;

  if Assigned(FViewModel) then begin

    SetDocumentApproversInfoFormViewModel(
      FDocumentApproversInfoForm,
      FViewModel.DocumentApprovingSetHolder
    );

  end;
  
end;

procedure TDocumentApprovingsFrame.SetDocumentApproversInfoFormViewModel(
  DocumentApproversInfoForm: TDocumentApproversInfoForm;
  DocumentApprovingSetHolder: TDocumentApprovingSetHolder
);
begin

  if Assigned(DocumentApprovingSetHolder)
  then begin

    FDocumentApproversInfoForm.DocumentApprovingSetHolder :=
      DocumentApprovingSetHolder;

    if FViewModel.DocumentApprovingCycleSetHolder.IsEmpty then
      FDocumentApproversInfoForm.AddApproversButton.Enabled := False;

  end;
  
end;

procedure TDocumentApprovingsFrame.SetDocumentApprovingCyclesReferenceForm(
  Value: TDocumentApprovingCyclesReferenceForm);
begin

  FreeAndNil(FDocumentApprovingCyclesReferenceForm);

  FDocumentApprovingCyclesReferenceForm := Value;
  
  FDocumentApprovingCyclesReferenceForm.Font := Font;
  
  InflateDocumentApprovingCyclesReferenceForm(FDocumentApprovingCyclesReferenceForm);
  
  SubscribeOnDocumentApprovingCyclesReferenceFormEvents(FDocumentApprovingCyclesReferenceForm);

  FDocumentApprovingCyclesReferenceForm.ViewOnly := ViewOnly;

  if Assigned(FViewModel)
  then begin

    SetDocumentApprovingCyclesReferenceFormViewModel(
      FDocumentApprovingCyclesReferenceForm,
      FViewModel.DocumentApprovingCycleSetHolder
    );

  end;
  
end;

procedure TDocumentApprovingsFrame.SetDocumentApprovingCyclesReferenceFormViewModel(
  DocumentApprovingCyclesReferenceForm: TDocumentApprovingCyclesReferenceForm;
  DocumentApprovingCycleSetHolder: TDocumentApprovingCycleSetHolder
);
begin
  
  if Assigned(DocumentApprovingCycleSetHolder)
  then begin
              
    FDocumentApprovingCyclesReferenceForm.DocumentApprovingCycleSetHolder :=
      DocumentApprovingCycleSetHolder;
            
    if DocumentApprovingCycleSetHolder.IsEmpty then begin
                     
      if Assigned(FDocumentApproversInfoForm) then
        FDocumentApproversInfoForm.AddApproversButton.Enabled := False;
                       
    end;

  end;
  
end;

procedure TDocumentApprovingsFrame.SetFont(const Value: TFont);
begin

  inherited;

  if Assigned(FDocumentApprovingCyclesReferenceForm) then
    FDocumentApprovingCyclesReferenceForm.Font := Value;

  if Assigned(FDocumentApproversInfoForm) then
    FDocumentApproversInfoForm.Font := Value;
    
end;

procedure TDocumentApprovingsFrame.SetFormStyles(Form: TForm);
begin

  TDocumentFlowCommonControlStyles.ApplyStylesToForm(Form);
  
end;

procedure TDocumentApprovingsFrame.SetViewModel(
  Value: TDocumentApprovingsFormViewModel);
begin

  FViewModel := Value;

  InitializeFromViewModel(FViewModel);
  
end;

procedure TDocumentApprovingsFrame.SetViewOnly(const Value: Boolean);
begin

  if Assigned(FDocumentApprovingCyclesReferenceForm) then
    FDocumentApprovingCyclesReferenceForm.ViewOnly := Value;

  if Assigned(FDocumentApproversInfoForm) then
    FDocumentApproversInfoForm.ViewOnly := Value;

end;

procedure TDocumentApprovingsFrame.SubscribeOnDocumentApproversInfoFormEvents(
  DocumentApproversInfoForm: TDocumentApproversInfoForm);
begin

  DocumentApproversInfoForm.
    OnDocumentApprovingChangingRequestedEventHandler :=
      OnDocumentApprovingChangingRequestedEventHandle;

  DocumentApproversInfoForm.OnDocumentApprovingChangedEventHandler :=
    OnDocumentApprovingChangedEventHandler;
    
  DocumentApproversInfoForm.
    OnEmployeeReferenceForApprovingRequestedEventHandler :=
      OnEmployeeReferenceForApprovingRequestedEventHandle;

  DocumentApproversInfoForm.
    OnDocumentApprovingsRemovingRequestedEventHandler :=
      OnDocumentApprovingsRemovingRequestedEventHandle;

  DocumentApproversInfoForm.OnDocumentApprovingsRemovedEventHandler :=
    OnDocumentApprovingsRemovedEventHandle;
    
  DocumentApproversInfoForm.
    OnEmployeesAddingForApprovingRequestedEventHandler :=
      OnEmployeesAddingForApprovingRequestedEventHandle;

  DocumentApproversInfoForm.OnEmployeesAddedForApprovingEventHandler :=
    OnEmployeesAddedForApprovingEventHandle;

end;

procedure TDocumentApprovingsFrame.
  SubscribeOnDocumentApprovingCyclesReferenceFormEvents(
    DocumentApprovingCyclesReferenceForm: TDocumentApprovingCyclesReferenceForm
  );
begin

  DocumentApprovingCyclesReferenceForm.
    OnNewDocumentApprovingCycleInfoAddedEventHandler :=
      OnNewDocumentApprovingCycleInfoAddedEventHandle;

  DocumentApprovingCyclesReferenceForm.
    OnDocumentApprovingCycleRemovingRequestedEventHandler :=
      OnDocumentApprovingCycleRemovingRequestedEventHandle;

  DocumentApprovingCyclesReferenceForm.
    OnDocumentApprovingCompletingRequestedEventHandler :=
      OnDocumentApprovingCompletingRequestedEventHandle;

  DocumentApprovingCyclesReferenceForm.
    OnNewDocumentApprovingCycleCreatingRequestedEventHandler :=
      OnNewDocumentApprovingCycleCreatingRequestedEventHandle;

  DocumentApprovingCyclesReferenceForm.
    OnDocumentApprovingCycleSelectedEventHandler :=
      OnDocumentApprovingCycleSelectedEventHandle;

  DocumentApprovingCyclesReferenceForm.
    OnDocumentApprovingCycleRemovedEventHandler :=
      OnDocumentApprovingCycleRemovedEventHandle;
      
end;

procedure TDocumentApprovingsFrame.SubscribeOnEvents;
begin

  FOnEmployeeReferenceForApprovingRequestedEventHandler :=
    OnEmployeeReferenceForApprovingRequested_ControllerEventHandler;
    
end;

procedure TDocumentApprovingsFrame.UpdateNewCycleDocumentApproving(
  DocumentApproving: TDocumentApprovingViewModel
);
var PreviousFocusedCycleViewModel: TDocumentApprovingCycleViewModel;
begin

  if not Assigned(FDocumentApprovingCyclesReferenceForm) or
     not Assigned(FDocumentApproversInfoForm)
  then Exit;

  PreviousFocusedCycleViewModel := nil;

  try

    if not
       FDocumentApprovingCyclesReferenceForm.IsNewApprovingCycleRecordFocused
    then begin

      PreviousFocusedCycleViewModel :=
        DocumentApprovingCyclesReferenceForm.GetFocusedApprovingCycleViewModel;

      FGettingDocumentApprovingsOfNewCycleRequested := True;

      if not
         DocumentApprovingCyclesReferenceForm.SelectNewApprovingCycleRecord
      then Exit;
      
    end;

    FDocumentApproversInfoForm.UpdateApprovingRecordFrom(
      DocumentApproving
    );

  finally

    try
    
      if Assigned(PreviousFocusedCycleViewModel) then begin

        FDocumentApprovingCyclesReferenceForm.SelectApprovingCycleByNumber(
          PreviousFocusedCycleViewModel.CycleNumber
        );
      
      end;

    finally

      FGettingDocumentApprovingsOfNewCycleRequested := False;

      FreeAndNil(PreviousFocusedCycleViewModel);
      
    end;


  end;

end;

end.
