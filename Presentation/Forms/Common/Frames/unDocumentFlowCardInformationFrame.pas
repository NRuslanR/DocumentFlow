unit unDocumentFlowCardInformationFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, cxButtons, StdCtrls,
  ComCtrls, DocumentKinds, unScrollableFrame, unDocumentFlowInformationFrame,
  DB, DBClient;

type

  TOnChangedEventHandler = procedure (Sender: TObject) of object;
  
  TDocumentFlowCardInformationFrame = class(TDocumentFlowInformationFrame)
    DocumentInfoPanel: TPanel;

    procedure FrameResize(Sender: TObject);
    
    procedure FrameMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean
    );
  private

    function GetScrollingEnabled: Boolean;
    procedure SetScrollingEnabled(const Value: Boolean);

  protected
    
    FViewOnly: Boolean;
    FIgnorableViewOnlyControls: TList;
    FNotAllowedForEditingControls: TList;
    
    FHorizontalScrollingMinWidth: Integer;
    FVerticalScrollingMinHeight: Integer;

    FOnChangedEventHandler: TOnChangedEventHandler;

    procedure Initialize; override;

    function GetHorizontalScrollingMinWidth: Integer; virtual;
    function GetVerticalScrollingMinHeight: Integer; virtual;

    procedure SetFocusForMouseScrollingControlIfNecessary;

    procedure OnHorizontalScrollingShowed; virtual;
    procedure OnVerticalScrollingShowed; virtual;

    procedure OnHorizontalScrollingHided; virtual;
    procedure OnVerticalScrollingHided; virtual;

    procedure CallOnHorizontalScrollingShowedIfNecessary;
    procedure CallOnVerticalScrollingShowedIfNecessary;

    procedure CallOnHorizontalScrollingHidedIfNecessary;
    procedure CallOnVerticalScrollingHidedIfNecessary;

    procedure SetReadOnlyModeForTextFieldsAndEnabledForOthers(
      const ReadOnly: Boolean
    );

    function GetViewOnly: Boolean; virtual;
    procedure SetViewOnly(const Value: Boolean); virtual;

    procedure SetIgnorableViewOnlyControls(Controls:  TList); virtual;
    procedure SetNotAllowedForEditingControls(Controls:  TList); virtual;

  public

    destructor Destroy; override;

    procedure ChangeLayoutScrollnessIfNecassary;
    
    procedure OnChangesApplied; virtual; abstract;
    procedure OnChangesApplyingFailed; virtual; abstract;
    
    function IsDataChanged: Boolean; virtual; abstract;

    procedure RaisePendingEvents; virtual;

    function ValidateInput: Boolean; virtual;
    
  public

    property HorizontalScrollingMinWidth: Integer
    read GetHorizontalScrollingMinWidth;

    property VerticalScrollingMinHeight: Integer
    read GetVerticalScrollingMinHeight;

    property ViewOnly: Boolean read GetViewOnly write SetViewOnly;
    
  published

  public

    property EnableScrolling: Boolean
    read GetScrollingEnabled write SetScrollingEnabled;
    
    property OnChangedEventHandler: TOnChangedEventHandler
    read FOnChangedEventHandler write FOnChangedEventHandler;
    
  end;

implementation

uses

  AuxDebugFunctionsUnit,
  AuxWindowsFunctionsUnit,
  IObjectPropertiesStorageUnit,
  CommonControlStyles,
  ApplicationPropertiesStorageRegistry;


{$R *.dfm}

{ TDocumentFlowInformationFrame }

procedure TDocumentFlowCardInformationFrame.CallOnHorizontalScrollingHidedIfNecessary;
begin

  if ScrollBox.HorzScrollBar.Visible then
    OnHorizontalScrollingHided;

end;

procedure TDocumentFlowCardInformationFrame.CallOnHorizontalScrollingShowedIfNecessary;
begin

  if not ScrollBox.HorzScrollBar.Visible then
    OnHorizontalScrollingShowed;

end;

procedure TDocumentFlowCardInformationFrame.CallOnVerticalScrollingHidedIfNecessary;
begin

  if ScrollBox.VertScrollBar.Visible then
    OnVerticalScrollingHided;

end;

procedure TDocumentFlowCardInformationFrame.CallOnVerticalScrollingShowedIfNecessary;
begin

  if not ScrollBox.VertScrollBar.Visible then
    OnVerticalScrollingShowed;

end;

procedure TDocumentFlowCardInformationFrame.ChangeLayoutScrollnessIfNecassary;
begin

  if (Width >= GetHorizontalScrollingMinWidth) and
      (Width > DocumentInfoPanel.Width) then begin

      DocumentInfoPanel.Width := ScrollBox.ClientWidth;

      CallOnHorizontalScrollingHidedIfNecessary;
      
  end

  else CallOnHorizontalScrollingShowedIfNecessary;

  if (Height >= GetVerticalScrollingMinHeight) and
     (Height > DocumentInfoPanel.Height) then begin

      DocumentInfoPanel.Height := ScrollBox.ClientHeight;
      
      CallOnVerticalScrollingHidedIfNecessary;

  end

  else CallOnVerticalScrollingShowedIfNecessary;    

end;

destructor TDocumentFlowCardInformationFrame.Destroy;
begin

  SaveUIControlProperties;

  FreeAndNil(FNotAllowedForEditingControls);
  FreeAndNil(FIgnorableViewOnlyControls);

  inherited;

end;

procedure TDocumentFlowCardInformationFrame.FrameMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta:
  Integer; MousePos: TPoint;
  var Handled: Boolean
);
begin

  ScrollBox.VertScrollBar.Position :=
    ScrollBox.VertScrollBar.Position - WheelDelta;

  Handled := True;

end;

procedure TDocumentFlowCardInformationFrame.FrameResize(Sender: TObject);
begin

  if (not Visible) or (ClientWidth = 0) or not ScrollBox.AutoScroll then
    Exit;
  
  if FHorizontalScrollingMinWidth = 0 then begin

    FHorizontalScrollingMinWidth := ClientWidth;
    FVerticalScrollingMinHeight := ClientHeight;
    
  end;

  ChangeLayoutScrollnessIfNecassary;

end;

function TDocumentFlowCardInformationFrame.GetHorizontalScrollingMinWidth: Integer;
begin

  Result := FHorizontalScrollingMinWidth;

end;

function TDocumentFlowCardInformationFrame.GetScrollingEnabled: Boolean;
begin

  Result := ScrollBox.AutoScroll;
  
end;

function TDocumentFlowCardInformationFrame.GetVerticalScrollingMinHeight: Integer;
begin

  Result := FVerticalScrollingMinHeight;
  
end;

function TDocumentFlowCardInformationFrame.GetViewOnly: Boolean;
begin

  Result := FViewOnly
  
end;

procedure TDocumentFlowCardInformationFrame.Initialize;
begin

  inherited Initialize;

  FIgnorableViewOnlyControls := TList.Create;
  FNotAllowedForEditingControls := TList.Create;
  
  SetIgnorableViewOnlyControls(FIgnorableViewOnlyControls);
  SetNotAllowedForEditingControls(FNotAllowedForEditingControls);
  
  RestoreUIControlProperties;

  EnableScrolling := True;
  
  ApplyUIStyles;
  
end;

procedure TDocumentFlowCardInformationFrame.OnHorizontalScrollingHided;
begin

end;

procedure TDocumentFlowCardInformationFrame.OnHorizontalScrollingShowed;
begin

end;

procedure TDocumentFlowCardInformationFrame.OnVerticalScrollingHided;
begin

end;

procedure TDocumentFlowCardInformationFrame.OnVerticalScrollingShowed;
begin

end;

procedure TDocumentFlowCardInformationFrame.RaisePendingEvents;
begin

end;

procedure TDocumentFlowCardInformationFrame.SetFocusForMouseScrollingControlIfNecessary;
begin

  SetFocus;
  
end;

procedure TDocumentFlowCardInformationFrame.SetNotAllowedForEditingControls(
  Controls: TList);
begin

end;

procedure TDocumentFlowCardInformationFrame.SetIgnorableViewOnlyControls(
  Controls: TList);
begin

end;

procedure TDocumentFlowCardInformationFrame.SetReadOnlyModeForTextFieldsAndEnabledForOthers(
  const ReadOnly: Boolean);
var I: Integer;
    Control: TControl;

    function IsControlViewOnlyIgnorable(Control: TControl): Boolean;
    begin

      Result := FIgnorableViewOnlyControls.IndexOf(Control) >= 0;
      
    end;

    function IsControlNotAllowedForEditing(Control: TControl): Boolean;
    begin

      Result := FNotAllowedForEditingControls.IndexOf(Control) >= 0;
      
    end;

var RealReadOnly: Boolean;
begin

  for I := 0 to DocumentInfoPanel.ControlCount - 1 do begin

    Control := DocumentInfoPanel.Controls[I];

    if (Control is TLabel) or IsControlViewOnlyIgnorable(Control)  then
      Continue;

    if not ReadOnly then
      RealReadOnly := IsControlNotAllowedForEditing(Control)

    else RealReadOnly := True;

    if Control is TCustomEdit then begin

      (Control as TCustomEdit).ReadOnly := RealReadOnly

    end

    else Control.Enabled := not RealReadOnly;

  end;

end;

procedure TDocumentFlowCardInformationFrame.SetScrollingEnabled(
  const Value: Boolean);
begin

  ScrollBox.AutoScroll := Value;

  if Value then begin

    DocumentInfoPanel.Align := alNone;
    DocumentInfoPanel.Anchors := [akLeft, akTop];

  end

  else DocumentInfoPanel.Align := alClient;

end;

procedure TDocumentFlowCardInformationFrame.SetViewOnly(const Value: Boolean);
begin

  SetReadOnlyModeForTextFieldsAndEnabledForOthers(Value);

  FViewOnly := Value;
  
end;

function TDocumentFlowCardInformationFrame.ValidateInput: Boolean;
begin

  Result := True;
  
end;

end.
