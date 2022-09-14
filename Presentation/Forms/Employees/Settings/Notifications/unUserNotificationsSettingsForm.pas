unit unUserNotificationsSettingsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DialogFormUnit,
  Menus, StdCtrls,
  UserNotificationsSettingsFormViewModel, LayoutManager, VerticalBoxLayoutManager,
  UserNotificationProfileService, UserNotificationsSettingsFormViewModelMapper,
  Disposable,
  UserNotificationProfile, cxButtons, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters, cxControls,
  dxSkinscxPCPainter, dxLayoutControlAdapters, dxLayoutControl, ExtCtrls,
  dxLayoutLookAndFeels, unUserNotificationsSettingsFrame;

type

  TUserNotificationsSettingsForm = class(TDialogForm)
    UserNotificationsSettingsFramePanel: TPanel;
    procedure FormShow(Sender: TObject);

  private

    FUserNotificationsSettingsFrame: TUserNotificationsSettingsFrame;
    FViewModel: TUserNotificationsSettingsFormViewModel;

    procedure CreateUserNotificationsSettingsFrameFrom(
      Owner: TComponent;
      UserNotificationProfileService: IUserNotificationProfileService;
      ViewModelMapper: TUserNotificationsSettingsFormViewModelMapper;
      UserId: Variant
    );
    
    procedure NotificationsReceivingEnabledCheckBoxClick(Sender: TObject);

    procedure SetViewModel(
      const Value: TUserNotificationsSettingsFormViewModel);

  protected

    procedure OnOKButtonClicked; override;

  public

    destructor Destroy; override;
    
    constructor Create(
      Owner: TComponent;
      UserNotificationProfileService: IUserNotificationProfileService;
      ViewModelMapper: TUserNotificationsSettingsFormViewModelMapper;
      UserId: Variant
    );

    property ViewModel: TUserNotificationsSettingsFormViewModel
    read FViewModel write SetViewModel;

  end;

var
  UserNotificationsSettingsForm: TUserNotificationsSettingsForm;

implementation

{$R *.dfm}

constructor TUserNotificationsSettingsForm.Create(
  Owner: TComponent;
  UserNotificationProfileService: IUserNotificationProfileService;
  ViewModelMapper: TUserNotificationsSettingsFormViewModelMapper;
  UserId: Variant
);
begin

  inherited Create(Owner);

  CreateUserNotificationsSettingsFrameFrom(
    Owner,
    UserNotificationProfileService,
    ViewModelMapper,
    UserId
  );
  
end;

procedure TUserNotificationsSettingsForm.FormShow(Sender: TObject);
begin

  FUserNotificationsSettingsFrame.UpdateViewModel;

end;

procedure TUserNotificationsSettingsForm.NotificationsReceivingEnabledCheckBoxClick(
  Sender: TObject);
begin

  inherited;

end;

procedure TUserNotificationsSettingsForm.CreateUserNotificationsSettingsFrameFrom(
  Owner: TComponent;
  UserNotificationProfileService: IUserNotificationProfileService;
  ViewModelMapper: TUserNotificationsSettingsFormViewModelMapper;
  UserId: Variant);
begin

  FUserNotificationsSettingsFrame :=
    TUserNotificationsSettingsFrame.Create(
      UserNotificationsSettingsFramePanel,
      UserNotificationProfileService,
      ViewModelMapper,
      UserId
    );

  FUserNotificationsSettingsFrame.Parent := UserNotificationsSettingsFramePanel;
  FUserNotificationsSettingsFrame.Align := alClient;
  
end;

destructor TUserNotificationsSettingsForm.Destroy;
begin

  inherited;

end;

procedure TUserNotificationsSettingsForm.OnOKButtonClicked;
begin

  FUserNotificationsSettingsFrame.SaveUserNotificationProfile;
  
  inherited OnOKButtonClicked;

end;

procedure TUserNotificationsSettingsForm.SetViewModel(
  const Value: TUserNotificationsSettingsFormViewModel);
begin

  FUserNotificationsSettingsFrame.ViewModel := Value;

end;

end.
