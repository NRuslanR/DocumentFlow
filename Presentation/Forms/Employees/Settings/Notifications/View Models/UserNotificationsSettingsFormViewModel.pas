unit UserNotificationsSettingsFormViewModel;

interface

uses

  SysUtils,
  EmployeeSetHolder,
  VariantListUnit,
  Classes;

type

  TUserNotificationsSettingsFormViewModel = class

    private

      FSelectedOwnNotificationsReceivingUserIds: TVariantList;

      FOwnNotificationsReceivingUserSet: TEmployeeSetHolder;

      procedure SetOwnNotificationsReceivingUserSet(const Value: TEmployeeSetHolder);
      procedure SetSelectedOwnNotificationsReceivingUserIds(const Value: TVariantList);

    public

      ReceiveNotifications: Boolean;
      OwnNotificationsReceivingUsersEditingVisible: Boolean;

    public

      destructor Destroy; override;

      constructor Create;

      property OwnNotificationsReceivingUserSet: TEmployeeSetHolder
      read FOwnNotificationsReceivingUserSet write SetOwnNotificationsReceivingUserSet;

      property SelectedOwnNotificationsReceivingUserIds: TVariantList
      read FSelectedOwnNotificationsReceivingUserIds
      write SetSelectedOwnNotificationsReceivingUserIds;

  end;

implementation

{ TUserNotificationsSettingsFormViewModel }

constructor TUserNotificationsSettingsFormViewModel.Create;
begin

  inherited Create;
  
end;

destructor TUserNotificationsSettingsFormViewModel.Destroy;
begin

  FreeAndNil(FOwnNotificationsReceivingUserSet);

  inherited;

end;

procedure TUserNotificationsSettingsFormViewModel.SetOwnNotificationsReceivingUserSet(
  const Value: TEmployeeSetHolder);
begin

  if FOwnNotificationsReceivingUserSet = Value then Exit;

  FreeAndNil(FOwnNotificationsReceivingUserSet);
  
  FOwnNotificationsReceivingUserSet := Value;

end;

procedure TUserNotificationsSettingsFormViewModel.SetSelectedOwnNotificationsReceivingUserIds(
  const Value: TVariantList);
begin

  if FSelectedOwnNotificationsReceivingUserIds = Value then Exit;

  FreeAndNil(FSelectedOwnNotificationsReceivingUserIds);

  FSelectedOwnNotificationsReceivingUserIds := Value;

end;

end.
