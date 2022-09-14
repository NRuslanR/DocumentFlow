unit unDocumentFlowWorkingFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, unDocumentKindsFrame, cxTL, DocumentsReferenceFormPresenter,
  unDocumentCardListFrame, unScrollableFrame, unDocumentFlowInformationFrame,
  DocumentCardFormViewModel, DocumentKinds, UIDocumentKinds,
  OperationalDocumentKindInfo, UserInterfaceSwitch;

type

  TOnDocumentFlowWorkingFrameLayoutReadyEventHandler =
    procedure (
      Sender: TObject
    ) of object;
    
  TDocumentFlowWorkingFrame = class(TDocumentFlowInformationFrame)
    SeparatorBetweenDocumentTypesAndRest: TSplitter;
    DocumentKindsFrameArea: TPanel;
    DocumentCardListFrameArea: TPanel;

    procedure FormResize(Sender: TObject);

  private

    FIsLayoutReadyEventHandlerAlreadyRaised: Boolean;

    FLayoutReadyEventHandler: TOnDocumentFlowWorkingFrameLayoutReadyEventHandler;

    procedure RaiseLayoutReadyEventHandler;

  private

    FDocumentKindsFrame: TDocumentKindsFrame;
    FDocumentCardListFrame: TDocumentCardListFrame;

    procedure SubscribeOnDocumentKindsFrameEvents(DocumentKindsFrame: TDocumentKindsFrame);
    procedure SubscribeOnDocumentCardListFrameEvents(DocumentCardListFrame: TDocumentCardListFrame);

    procedure InflateDocumentKindsFrame(DocumentKindsFrame: TDocumentKindsFrame);
    procedure InflateDocumentCardListFrame(DocumentCardListFrame: TDocumentCardListFrame);

  private

    FOnDocumentCardListUpdatedEventHandler: TOnDocumentCardListUpdatedEventHandler;
    
  private
  
    procedure UpdateUIForDocumentKind(DocumentKindInfo: TOperationalDocumentKindInfo);

  private
  
    function GetEnableDocumentCardListGroupingTool: Boolean;
    procedure SetEnableDocumentCardListGroupingTool(const Value: Boolean);

    function GetOnDocumentCardListUpdatedEventHandler: TOnDocumentCardListUpdatedEventHandler;
    
    procedure SetOnDocumentCardListUpdatedEventHandler(
      const Value: TOnDocumentCardListUpdatedEventHandler
    );

  protected

    procedure OnRespondingDocumentCreatedEventHandler(
      Sender: TObject;
      RespondingDocumentCardViewModel: TDocumentCardFormViewModel
    );

    procedure OnEmployeeDocumentSetChangedEventHandler(Sender: TObject);

    procedure HandleDocumentCardListUpdatedEvent(Sender: TObject);

    procedure OnEmployeeDocumentChargeSheetSetChangedEventHandler(Sender: TObject);

    procedure OnDocumentKindsFillEventHandler(Sender: TObject); 
    
    procedure OnDocumentKindSelectedEventHandler(
      Sender: TObject;
      SelectedDocumentKindInfo: TOperationalDocumentKindInfo
    );

  protected

    procedure SetWorkingEmployeeId(const Value: Variant); override;

  protected

    procedure SwitchUserInterfaceTo(Value: TUserInterfaceKind); override;

  protected

    procedure SetFont(const Value: TFont); override;

  public

    destructor Destroy; override;
    
    constructor Create(
      AOwner: TComponent;
      DocumentKindsFrame: TDocumentKindsFrame;
      DocumentCardListFrame: TDocumentCardListFrame
    ); overload;

    constructor Create(
      AOwner: TComponent;
      DocumentKindsFrame: TDocumentKindsFrame;
      DocumentCardListFrame: TDocumentCardListFrame;
      const RestoreUIControlPropertiesOnCreate: Boolean;
      const SaveUIControlPropertiesOnDestroy: Boolean
    ); overload;

  public

    procedure OnClose; override;
    procedure OnShow; override;

  public

    procedure RestoreDefaultUIControlProperties; override;

    procedure SaveUIControlProperties; override;

  public

    property EnableDocumentCardListGroupingTool: Boolean
    read GetEnableDocumentCardListGroupingTool write SetEnableDocumentCardListGroupingTool;

  public

    property DocumentKindsFrame: TDocumentKindsFrame
    read FDocumentKindsFrame;

    property DocumentCardListFrame: TDocumentCardListFrame
    read FDocumentCardListFrame;

  public

    property OnLayoutReadyEventHandler: TOnDocumentFlowWorkingFrameLayoutReadyEventHandler
    read FLayoutReadyEventHandler write FLayoutReadyEventHandler;
    
    property OnDocumentCardListUpdatedEventHandler: TOnDocumentCardListUpdatedEventHandler
    read GetOnDocumentCardListUpdatedEventHandler
    write SetOnDocumentCardListUpdatedEventHandler;

  end;

implementation

uses

  AuxDebugFunctionsUnit,
  AuxWindowsFunctionsUnit;
  
{$R *.dfm}

constructor TDocumentFlowWorkingFrame.Create(
  AOwner: TComponent;
  DocumentKindsFrame: TDocumentKindsFrame;
  DocumentCardListFrame: TDocumentCardListFrame
);
begin

  Create(AOwner, DocumentKindsFrame, DocumentCardListFrame, True, True);

end;

constructor TDocumentFlowWorkingFrame.Create(AOwner: TComponent;
  DocumentKindsFrame: TDocumentKindsFrame;
  DocumentCardListFrame: TDocumentCardListFrame;
  const RestoreUIControlPropertiesOnCreate,
  SaveUIControlPropertiesOnDestroy: Boolean
);
begin

  inherited Create(
    AOwner,
    RestoreUIControlPropertiesOnCreate,
    SaveUIControlPropertiesOnDestroy
  );

  FDocumentKindsFrame := DocumentKindsFrame;
  FDocumentCardListFrame := DocumentCardListFrame;

  SubscribeOnDocumentKindsFrameEvents(DocumentKindsFrame);
  SubscribeOnDocumentCardListFrameEvents(DocumentCardListFrame);

  InflateDocumentKindsFrame(DocumentKindsFrame);
  InflateDocumentCardListFrame(DocumentCardListFrame);

end;

destructor TDocumentFlowWorkingFrame.Destroy;
begin

  if Assigned(DocumentKindsFrame) then begin

    if Assigned(DocumentKindsFrame.Owner) then
      DocumentKindsFrame.Owner.RemoveComponent(DocumentKindsFrame);
      
    DocumentKindsFrame.Parent.RemoveControl(DocumentKindsFrame);
    
  end;

  inherited;

  DocumentKindsFrame.SafeDestroy;

end;

procedure TDocumentFlowWorkingFrame.FormResize(Sender: TObject);
begin

  DocumentKindsFrame.Width := SeparatorBetweenDocumentTypesAndRest.Left;

end;

function TDocumentFlowWorkingFrame.GetEnableDocumentCardListGroupingTool: Boolean;
begin

  Result := DocumentCardListFrame.EnableDocumentCardListGroupingTool;
  
end;

function TDocumentFlowWorkingFrame.
  GetOnDocumentCardListUpdatedEventHandler: TOnDocumentCardListUpdatedEventHandler;
begin

  Result := FOnDocumentCardListUpdatedEventHandler;
  
end;

procedure TDocumentFlowWorkingFrame.HandleDocumentCardListUpdatedEvent(
  Sender: TObject);
begin

  DocumentKindsFrame.UpdateEmployeeDocumentWorkStatistics;

  if Assigned(FOnDocumentCardListUpdatedEventHandler) then
    FOnDocumentCardListUpdatedEventHandler(Self);
    
end;

procedure TDocumentFlowWorkingFrame.InflateDocumentCardListFrame(
  DocumentCardListFrame: TDocumentCardListFrame);
begin

  DocumentCardListFrame.Parent := DocumentCardListFrameArea;
  DocumentCardListFrame.Align := alClient;
  
end;

procedure TDocumentFlowWorkingFrame.InflateDocumentKindsFrame(
  DocumentKindsFrame: TDocumentKindsFrame);
begin

  DocumentKindsFrame.Parent := DocumentKindsFrameArea;
  DocumentKindsFrame.Align := alClient;

end;

procedure TDocumentFlowWorkingFrame.SaveUIControlProperties;
begin

  inherited SaveUIControlProperties;

  if Assigned(FDocumentKindsFrame) then
    FDocumentKindsFrame.SaveUIControlProperties;
    
  if Assigned(FDocumentCardListFrame) then
    FDocumentCardListFrame.SaveUIControlProperties;

end;

procedure TDocumentFlowWorkingFrame.SetEnableDocumentCardListGroupingTool(
  const Value: Boolean);
begin

  DocumentCardListFrame.EnableDocumentCardListGroupingTool := Value;
  
end;

procedure TDocumentFlowWorkingFrame.SetFont(const Value: TFont);
begin

  inherited;

  if Assigned(DocumentKindsFrame) then
    DocumentKindsFrame.Font := Value;

  if Assigned(DocumentCardListFrame) then
    DocumentCardListFrame.Font := Value;
    
end;

procedure TDocumentFlowWorkingFrame.SetOnDocumentCardListUpdatedEventHandler(
  const Value: TOnDocumentCardListUpdatedEventHandler);
begin

  FOnDocumentCardListUpdatedEventHandler := Value;
  
end;

procedure TDocumentFlowWorkingFrame.SetWorkingEmployeeId(const Value: Variant);
begin

  inherited;

  if Assigned(DocumentKindsFrame) then
    DocumentKindsFrame.WorkingEmployeeId := Value;

  if Assigned(DocumentCardListFrame) then
    DocumentCardListFrame.WorkingEmployeeId := Value;
    
end;

procedure TDocumentFlowWorkingFrame.SubscribeOnDocumentCardListFrameEvents(
  DocumentCardListFrame: TDocumentCardListFrame);
begin

  DocumentCardListFrame.OnRespondingDocumentCreatedEventHandler :=
    OnRespondingDocumentCreatedEventHandler;

  DocumentCardListFrame.OnDocumentCardListUpdatedEventHandler :=
    HandleDocumentCardListUpdatedEvent;
    
  DocumentCardListFrame.OnEmployeeDocumentSetChangedEventHandler :=
    OnEmployeeDocumentSetChangedEventHandler;

  DocumentCardListFrame.OnEmployeeDocumentChargeSheetSetChangedEventHandler :=
    OnEmployeeDocumentChargeSheetSetChangedEventHandler;

end;

procedure TDocumentFlowWorkingFrame.SubscribeOnDocumentKindsFrameEvents(
  DocumentKindsFrame: TDocumentKindsFrame);
begin

  DocumentKindsFrame.OnFillEventHandler :=
    OnDocumentKindsFillEventHandler;
    
  DocumentKindsFrame.OnDocumentKindSelectedEventHandler :=
    OnDocumentKindSelectedEventHandler;
    
end;

procedure TDocumentFlowWorkingFrame.SwitchUserInterfaceTo(
  Value: TUserInterfaceKind
);
begin

  inherited SwitchUserInterfaceTo(Value);

  if Assigned(FDocumentKindsFrame) then
    FDocumentKindsFrame.UserInterfaceKind := Value;

  if Assigned(FDocumentCardListFrame) then
    FDocumentCardListFrame.UserInterfaceKind := Value;

end;

procedure TDocumentFlowWorkingFrame.UpdateUIForDocumentKind(
  DocumentKindInfo: TOperationalDocumentKindInfo
);
begin

  DocumentCardListFrame.NativeDocumentKindDtos := DocumentKindsFrame.NativeDocumentKindDtos;
  DocumentCardListFrame.GlobalDocumentKindDtos := DocumentKindsFrame.GlobalDocumentKindDtos;
  DocumentCardListFrame.UIDocumentKindResolver := DocumentKindsFrame.UIDocumentKindResolver;
  DocumentCardListFrame.UINativeDocumentKindResolver := DocumentKindsFrame.UINativeDocumentKindResolver;
  DocumentCardListFrame.CurrentDocumentKindInfo := DocumentKindInfo;

end;

procedure TDocumentFlowWorkingFrame.OnClose;
begin

  inherited;
  
  DocumentCardListFrame
    .RequestUserConfirmDocumentCardChangesAndConfirmIfNecessary;

end;

procedure TDocumentFlowWorkingFrame.OnDocumentKindSelectedEventHandler(
  Sender: TObject;
  SelectedDocumentKindInfo: TOperationalDocumentKindInfo
);
begin

  UpdateUIForDocumentKind(SelectedDocumentKindInfo);

  RaiseLayoutReadyEventHandler;
  
end;

procedure TDocumentFlowWorkingFrame.OnDocumentKindsFillEventHandler(
  Sender: TObject);
begin

end;

procedure TDocumentFlowWorkingFrame.
  OnEmployeeDocumentChargeSheetSetChangedEventHandler(
    Sender: TObject
  );
begin

  DocumentKindsFrame.UpdateCurrentEmployeeDocumentKindWorkStatistics;
  
end;

procedure TDocumentFlowWorkingFrame.OnEmployeeDocumentSetChangedEventHandler(
  Sender: TObject
);
begin

  DocumentKindsFrame.UpdateCurrentEmployeeDocumentKindWorkStatistics;

end;

procedure TDocumentFlowWorkingFrame.OnRespondingDocumentCreatedEventHandler(
  Sender: TObject;
  RespondingDocumentCardViewModel: TDocumentCardFormViewModel
);
begin

  DocumentKindsFrame.CurrentNativeDocumentKindId := RespondingDocumentCardViewModel.DocumentKindId;

end;

procedure TDocumentFlowWorkingFrame.OnShow;
begin

  Screen.Cursor := crHourGlass;

  try
    
    if not DocumentKindsFrame.RestoreUIControlPropertiesOnCreate then
      DocumentKindsFrame.RestoreUIControlProperties;

    if not DocumentCardListFrame.RestoreUIControlPropertiesOnCreate then
      DocumentCardListFrame.RestoreUIControlProperties;

    DocumentKindsFrame.OnShow;
    DocumentCardListFrame.OnShow;
    
    inherited OnShow;
    
  finally

    Screen.Cursor := crDefault;

  end;

end;

procedure TDocumentFlowWorkingFrame.RaiseLayoutReadyEventHandler;
begin

  if
    FIsLayoutReadyEventHandlerAlreadyRaised
    or not Assigned(FLayoutReadyEventHandler)
  then Exit;

  FIsLayoutReadyEventHandlerAlreadyRaised := True;

  FLayoutReadyEventHandler(Self);
  
end;

procedure TDocumentFlowWorkingFrame.RestoreDefaultUIControlProperties;
begin

  inherited RestoreDefaultUIControlProperties;
  
  if Assigned(DocumentCardListFrame) then
    DocumentCardListFrame.RestoreDefaultUIControlProperties;
    
  if Assigned(DocumentKindsFrame) then
    DocumentKindsFrame.RestoreDefaultUIControlProperties;

end;

end.
