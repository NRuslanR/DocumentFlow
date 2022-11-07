unit StandardUserNotificationProfileAccessRightsService;

interface

uses

  IEmployeeRepositoryUnit,
  UserNotificationProfileAccessRightsService,
  UserNotificationProfile,
  IDomainObjectBaseListUnit,
  Role,
  Employee,
  SysUtils;

type

  TStandardUserNotificationProfileAccessRightsService =
    class (TInterfacedObject, IUserNotificationProfileAccessRightsService)

      private

        FAllowedOwnNotificationsReceivingUserRoles: TRoleList;
        FFreeAllowedOwnNotificationsReceivingUserRoles: IDomainObjectBaseList;
        
        FEmployeeRepository: IEmployeeRepository;

      public

        destructor Destroy; override;
        constructor Create(
          AllowedOwnNotificationsReceivingUserRoles: TRoleList;
          EmployeeRepository: IEmployeeRepository
        );

        function GetUserNotificationProfileAccessRights(const Employee: TEmployee): TUserNotificationProfileAccessRights;

    end;
    
implementation

uses

  VariantListUnit;
  
{ TStandardUserNotificationProfileAccessRightsService }

constructor TStandardUserNotificationProfileAccessRightsService.Create(
  AllowedOwnNotificationsReceivingUserRoles: TRoleList; EmployeeRepository: IEmployeeRepository);
begin

  inherited Create;

  FAllowedOwnNotificationsReceivingUserRoles := AllowedOwnNotificationsReceivingUserRoles;
  FFreeAllowedOwnNotificationsReceivingUserRoles := FAllowedOwnNotificationsReceivingUserRoles;

  FEmployeeRepository := EmployeeRepository;
  
end;

destructor TStandardUserNotificationProfileAccessRightsService.Destroy;
begin

  inherited;
end;

function TStandardUserNotificationProfileAccessRightsService.GetUserNotificationProfileAccessRights(
  const Employee: TEmployee): TUserNotificationProfileAccessRights;
begin

  Result := TUserNotificationProfileAccessRights.Create;

  try

    Result.OwnNotificationsReceivingUsersEditingAllowed := Employee.IsLeader;
      
  except

    FreeAndNil(Result);

    Raise;

  end;

end;

end.
