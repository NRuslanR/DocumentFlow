unit UserNotificationsSettingsFormViewModelMapper;

interface

uses

  UserNotificationsSettingsFormViewModel,
  UserNotificationProfileService,
  UserNotificationProfile,
  VariantListUnit,
  SysUtils;

type

  TUserNotificationsSettingsFormViewModelMapper = class

    private

      FUserNotificationProfileService: IUserNotificationProfileService;

    public

      constructor Create(UserNotificationProfileService: IUserNotificationProfileService);

      function MapUserNotificationsSettingsFormViewModelFrom(
        UserNotificationProfile: TUserNotificationProfile
      ): TUserNotificationsSettingsFormViewModel;

      procedure UpdateUserNotificationProfileByViewModel(
        UserNotificationProfile: TUserNotificationProfile;
        ViewModel: TUserNotificationsSettingsFormViewModel
      );
      
  end;
  
implementation

{ TUserNotificationsSettingsFormViewModelMapper }

constructor TUserNotificationsSettingsFormViewModelMapper.Create(
  UserNotificationProfileService: IUserNotificationProfileService);
begin

  inherited Create;

  FUserNotificationProfileService := UserNotificationProfileService;
  
end;

function TUserNotificationsSettingsFormViewModelMapper.MapUserNotificationsSettingsFormViewModelFrom(
  UserNotificationProfile: TUserNotificationProfile): TUserNotificationsSettingsFormViewModel;
begin

  Result := TUserNotificationsSettingsFormViewModel.Create;

  try

    with UserNotificationProfile do begin

      Result.ReceiveNotifications :=
        ReceivingNotificationsEnabled;

      Result.OwnNotificationsReceivingUsersEditingVisible :=
        AccessRights.OwnNotificationsReceivingUsersEditingAllowed;

      Result.OwnNotificationsReceivingUserSet :=
        FUserNotificationProfileService
          .GetAllowedOwnNotificationsReceivingUserSetForUser(
            UserNotificationProfile.UserId
          );

      Result.SelectedOwnNotificationsReceivingUserIds :=
        TVariantList.CreateFrom(PermissibleReceivingOwnNotificationsUserIds);
        
    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

procedure TUserNotificationsSettingsFormViewModelMapper.UpdateUserNotificationProfileByViewModel(
  UserNotificationProfile: TUserNotificationProfile;
  ViewModel: TUserNotificationsSettingsFormViewModel
);
begin

  with UserNotificationProfile do begin

    ReceivingNotificationsEnabled := ViewModel.ReceiveNotifications;
    PermissibleReceivingOwnNotificationsUserIds :=
      TVariantList.CreateFrom(ViewModel.SelectedOwnNotificationsReceivingUserIds);
    
  end;

end;

end.
