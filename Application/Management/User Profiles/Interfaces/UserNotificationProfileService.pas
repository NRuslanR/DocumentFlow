unit UserNotificationProfileService;

interface

uses

  UserNotificationProfile,
  UserNotificationProfileGroup,
  EmployeeSetHolder,
  ApplicationService,
  IGetSelfUnit,
  VariantListUnit,
  SysUtils,
  Classes;

type

  TUserNotificationProfileServiceException = class (Exception)

  end;

  IUserNotificationProfileGettingOptions = interface

    function ReceivingNotificationsEnabled: Variant; overload;
    function ReceivingNotificationsEnabledAssigned: Boolean;
    function ReceivingNotificationsEnabled(const Value: Variant): IUserNotificationProfileGettingOptions; overload;

  end;

  TUserNotificationProfileGettingOptions =
    class (TInterfacedObject, IUserNotificationProfileGettingOptions)

      private

        FReceivingNotificationsEnabled: Variant;
        FLeaderDocumentsNotificationsReceivingEnabled: Variant;

      public

        constructor Create;
        constructor CreateAsStandard;
        constructor CreateForLeaderDocumentsNotificationsReceivingEnabledChecking;

        function ReceivingNotificationsEnabled: Variant; overload;
        function ReceivingNotificationsEnabledAssigned: Boolean;
        function ReceivingNotificationsEnabled(const Value: Variant): IUserNotificationProfileGettingOptions; overload;

    end;

  IUserNotificationProfileService = interface (IApplicationService)

    function GetNotificationProfilesForUsersAndThoseWhoCanReceiveNotificationsForThem(
      UserIds: TVariantList;
      Options: IUserNotificationProfileGettingOptions = nil
    ): TUserNotificationProfiles;
    
    function GetNotificationProfileForUser(const UserId: Variant): TUserNotificationProfile;
    procedure SaveUserNotificationProfile(UserNotificationProfile: TUserNotificationProfile);

    function GetAllowedOwnNotificationsReceivingUserSetForUser(const UserId: Variant): TEmployeeSetHolder;
    
  end;

implementation

uses

  Variants;
  
{ TUserNotificationProfileGettingOptions }

function TUserNotificationProfileGettingOptions.ReceivingNotificationsEnabled: Variant;
begin

  Result := FReceivingNotificationsEnabled;
  
end;

function TUserNotificationProfileGettingOptions.ReceivingNotificationsEnabled(
  const Value: Variant): IUserNotificationProfileGettingOptions;
begin

  FReceivingNotificationsEnabled := Value;

  Result := Self;

end;

function TUserNotificationProfileGettingOptions.ReceivingNotificationsEnabledAssigned: Boolean;
begin

  Result := not VarIsNull(ReceivingNotificationsEnabled);

end;

constructor TUserNotificationProfileGettingOptions.Create;
begin

  inherited Create;

  FReceivingNotificationsEnabled := Null;
  FLeaderDocumentsNotificationsReceivingEnabled := Null;
  
end;

constructor TUserNotificationProfileGettingOptions.CreateAsStandard;
begin

  Create;

  ReceivingNotificationsEnabled(True);

end;

constructor TUserNotificationProfileGettingOptions.CreateForLeaderDocumentsNotificationsReceivingEnabledChecking;
begin

  inherited Create;

  ReceivingNotificationsEnabled(True);

end;

end.
