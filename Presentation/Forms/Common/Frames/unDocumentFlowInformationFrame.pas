unit unDocumentFlowInformationFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unScrollableFrame, ExtCtrls, cxButtons, StdCtrls,
  ComCtrls, DocumentKinds, UserInterfaceSwitch;

type
  
  TDocumentFlowInformationFrame = class(TScrollableFrame, IUserInterfaceSwitch)

  protected

    FRestoreUIControlPropertiesOnCreate: Boolean;
    FSaveUIControlPropertiesOnDestroy: Boolean;

    FRestoreUIControlPropertiesEnabled: Boolean;
    FSaveUIControlPropertiesEnabled: Boolean;

    FUIControlPropertiesRestored: Boolean;

    FPreviousUserInterfaceKind: TUserInterfaceKind;
    FUserInterfaceKind: TUserInterfaceKind;
    
  protected
  
    function GetFont: TFont;
    procedure SetFont(const Value: TFont); virtual;

  protected

    function GetUserInterfaceKind: TUserInterfaceKind;
    procedure SetUserInterfaceKind(Value: TUserInterfaceKind);
    procedure ChangeUserInterfaceKind(Value: TUserInterfaceKind); virtual;
    procedure SwitchUserInterfaceTo(Value: TUserInterfaceKind); virtual;

  protected

    FWorkingEmployeeId: Variant;

    procedure Initialize; virtual;

    procedure ApplyUIStyles; virtual;

    procedure SetWorkingEmployeeId(const Value: Variant); virtual;

  public

    destructor Destroy; override;
    constructor Create(AOwner: TComponent); overload; override;

    constructor Create(
      AOwner: TComponent;
      const RestoreUIControlPropertiesOnCreate: Boolean;
      const SaveUIControlPropertiesOnDestroy: Boolean
    ); overload;

    procedure CopyUISettings(
      DocumentFlowInformationFrame: TDocumentFlowInformationFrame
    ); virtual;


    procedure RestoreUIControlProperties; virtual;
    procedure SaveUIControlProperties; virtual;

    procedure RestoreDefaultUIControlProperties; virtual;
    procedure SaveDefaultUIControlProperties; virtual;

  public

    procedure OnClose; virtual;
    procedure OnShow; virtual;

  public
	
	  function EncloseInForm(
      FormOwner: TComponent = nil
    ): TForm; overload;

    function EncloseInForm(
      FormOwner: TComponent;
      const FormCaption: String
    ): TForm; overload;

    function EncloseInForm(
      FormOwner: TComponent;
      const FormCaption: String;
      ParentControl: TWinControl
    ): TForm; overload;

    function EncloseInForm(
      FormOwner: TComponent;
      const FormCaption: String;
      ParentControl: TWinControl;
      FormClass: TFormClass
    ): TForm; overload;

  public

    property RestoreUIControlPropertiesOnCreate: Boolean
    read FRestoreUIControlPropertiesOnCreate;

    property RestoreUIControlPropertiesEnabled: Boolean
    read FRestoreUIControlPropertiesEnabled
    write FRestoreUIControlPropertiesEnabled;

    property SaveUIControlPropertiesOnDestroy: Boolean
    read FSaveUIControlPropertiesOnDestroy
    write FSaveUIControlPropertiesOnDestroy;

    property SaveUIControlPropertiesEnabled: Boolean
    read FSaveUIControlPropertiesEnabled
    write FSaveUIControlPropertiesEnabled;

  public

    property UserInterfaceKind: TUserInterfaceKind
    read GetUserInterfaceKind write SetUserInterfaceKind;
    
  public

    property WorkingEmployeeId: Variant
    read FWorkingEmployeeId write SetWorkingEmployeeId;

  published

    property Font: TFont
    read GetFont write SetFont;
    
  end;

implementation

{$R *.dfm}

uses

  AuxDebugFunctionsUnit,
  AuxWindowsFunctionsUnit,
  IObjectPropertiesStorageUnit,
  DefaultObjectPropertiesStorage,
  CommonControlStyles,
  ApplicationPropertiesStorageRegistry,
  ObjectPropertiesStorageRegistry,
  IObjectPropertiesStorageRegistryUnit;

{ TDocumentFlowInformationFrame }

procedure TDocumentFlowInformationFrame.ApplyUIStyles;
begin

  TDocumentFlowCommonControlStyles.ApplyStylesToFrame(Self);
  
end;

procedure TDocumentFlowInformationFrame.CopyUISettings(
  DocumentFlowInformationFrame: TDocumentFlowInformationFrame);
begin

end;

constructor TDocumentFlowInformationFrame.Create(
  AOwner: TComponent;
  const RestoreUIControlPropertiesOnCreate,
  SaveUIControlPropertiesOnDestroy: Boolean
);
begin

  inherited Create(AOwner);

  FRestoreUIControlPropertiesOnCreate := RestoreUIControlPropertiesOnCreate;
  FSaveUIControlPropertiesOnDestroy := SaveUIControlPropertiesOnDestroy;

  Initialize;

end;

constructor TDocumentFlowInformationFrame.Create(AOwner: TComponent);
begin

  Create(AOwner, True, True);

end;

destructor TDocumentFlowInformationFrame.Destroy;
begin

  if FSaveUIControlPropertiesOnDestroy then
    SaveUIControlProperties;

  inherited Destroy;

end;

function TDocumentFlowInformationFrame.EncloseInForm(
  FormOwner: TComponent
): TForm;
begin

  Result := EncloseInForm(FormOwner, '');

end;

function TDocumentFlowInformationFrame.EncloseInForm(
  FormOwner: TComponent;
  const FormCaption: String
): TForm;
begin

  Result := EncloseInForm(FormOwner, FormCaption, nil);

end;

function TDocumentFlowInformationFrame.EncloseInForm(
  FormOwner: TComponent;
  const FormCaption: String;
  ParentControl: TWinControl
): TForm;
begin

  Result := EncloseInForm(FormOwner, FormCaption, ParentControl, nil);

end;

function TDocumentFlowInformationFrame.EncloseInForm(
  FormOwner: TComponent;
  const FormCaption: String;
  ParentControl: TWinControl;
  FormClass: TFormClass
): TForm;
var
    InstanceClass: TFormClass;
begin

  if Assigned(FormClass) then
    InstanceClass := FormClass

  else InstanceClass := TForm;

  Result := InstanceClass.Create(FormOwner);

  try

    Result.Parent := ParentControl;
    Result.Caption := FormCaption;

    Align := alClient;
    Parent := Result;
 
  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;

end;

function TDocumentFlowInformationFrame.GetFont: TFont;
begin

  Result := inherited Font;
  
end;

function TDocumentFlowInformationFrame.GetUserInterfaceKind: TUserInterfaceKind;
begin

  Result := FUserInterfaceKind;
  
end;

procedure TDocumentFlowInformationFrame.Initialize;
begin

  FWorkingEmployeeId := Null;
  FPreviousUserInterfaceKind := uiUnknown;
  FUserInterfaceKind := uiOld;

  SaveUIControlPropertiesEnabled := True;
  RestoreUIControlPropertiesEnabled := True;

  if FRestoreUIControlPropertiesOnCreate then
    RestoreUIControlProperties;
    
  ApplyUIStyles;
  
end;

procedure TDocumentFlowInformationFrame.OnClose;
begin


end;

procedure TDocumentFlowInformationFrame.OnShow;
begin
  
  Show;
  
end;

procedure TDocumentFlowInformationFrame.RestoreDefaultUIControlProperties;
var
    PropertiesStorage: IDefaultObjectPropertiesStorage;
begin

  if not Assigned(TApplicationPropertiesStorageRegistry.Current) then Exit;

  PropertiesStorage :=
    TApplicationPropertiesStorageRegistry
      .Current
        .GetDefaultObjectPropertiesStorage(Self.ClassType);

  if Assigned(PropertiesStorage) then 
    PropertiesStorage.RestoreDefaultObjectProperties(Self);

end;

procedure TDocumentFlowInformationFrame.RestoreUIControlProperties;
var
    PropertiesStorage: IObjectPropertiesStorage;
begin

  if not FUIControlPropertiesRestored then begin

    SaveDefaultUIControlProperties;

    FUIControlPropertiesRestored := True;
    
  end;

  if not RestoreUIControlPropertiesEnabled then Exit;

  if not Assigned(TApplicationPropertiesStorageRegistry.Current) then
    Exit;

  PropertiesStorage :=
    TApplicationPropertiesStorageRegistry.
      Current.GetPropertiesStorageForObjectClass(Self.ClassType);

  if Assigned(PropertiesStorage) then
    PropertiesStorage.RestorePropertiesForObject(Self);

end;

procedure TDocumentFlowInformationFrame.SaveDefaultUIControlProperties;
var
    PropertiesStorage: IDefaultObjectPropertiesStorage;
begin

  if not Assigned(TApplicationPropertiesStorageRegistry.Current) then Exit;

  PropertiesStorage :=
    TApplicationPropertiesStorageRegistry
      .Current
        .GetDefaultObjectPropertiesStorage(Self.ClassType);

  if Assigned(PropertiesStorage) then 
    PropertiesStorage.SaveDefaultObjectProperties(Self);
  
end;

procedure TDocumentFlowInformationFrame.SaveUIControlProperties;
var
    PropertiesStorage: IObjectPropertiesStorage;
begin

  if not SaveUIControlPropertiesEnabled then Exit;
  
  if not Assigned(TApplicationPropertiesStorageRegistry.Current) then
    Exit;

  PropertiesStorage :=
    TApplicationPropertiesStorageRegistry.
      Current.
      GetPropertiesStorageForObjectClass(Self.ClassType);

  if Assigned(PropertiesStorage) then
    PropertiesStorage.SaveObjectProperties(Self);
    
end;

procedure TDocumentFlowInformationFrame.SetFont(const Value: TFont);
begin

  inherited Font := Value;
  
end;

procedure TDocumentFlowInformationFrame.SetUserInterfaceKind(
  Value: TUserInterfaceKind);
begin

  if
    not (FPreviousUserInterfaceKind <> uiUnknown)
    and (FUserInterfaceKind = Value)
  then Exit;

  ChangeUserInterfaceKind(Value);

end;

procedure TDocumentFlowInformationFrame.ChangeUserInterfaceKind(
  Value: TUserInterfaceKind);
begin

  FPreviousUserInterfaceKind := FUserInterfaceKind;
  FUserInterfaceKind := Value;

  SwitchUserInterfaceTo(FUserInterfaceKind);
  
end;

procedure TDocumentFlowInformationFrame.SetWorkingEmployeeId(const Value: Variant);
begin

  FWorkingEmployeeId := Value;
  
end;

procedure TDocumentFlowInformationFrame.SwitchUserInterfaceTo(
  Value: TUserInterfaceKind);
begin

end;

end.
