unit UserNotificationProfileAccessRightsService;

interface

uses

  Employee,
  UserNotificationProfile,
  SysUtils;

type

  IUserNotificationProfileAccessRightsService = interface

    function GetUserNotificationProfileAccessRights(const Employee: TEmployee): TUserNotificationProfileAccessRights;
    
  end;
  
implementation

end.
