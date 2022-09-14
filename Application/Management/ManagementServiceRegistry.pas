unit ManagementServiceRegistry;

interface

uses

  _ApplicationServiceRegistry,
  UserNotificationProfileService,
  EmployeeDepartmentManagementService;
  
type

  TManagementServiceRegistry = class (TApplicationServiceRegistry)

    public

      procedure RegisterEmployeeDepartmentManagementService(
        EmployeeDepartmentManagementService:
          IEmployeeDepartmentManagementService
      );

      function GetEmployeeDepartmentManagementService:
        IEmployeeDepartmentManagementService;

      procedure RegisterUserNotificationProfileService(
        UserNotificationProfileService: IUserNotificationProfileService
      );

      function GetUserNotificationProfileService: IUserNotificationProfileService;
      
  end;
  
implementation

type

  TManagementServiceType = class

  end;

  TEmployeeDepartmentManagementServiceType = class (TManagementServiceType)
  
  end;

  TUserNotificationProfileServiceType = class

  end;

{ TEmployeeManagementServiceRegistry }

function TManagementServiceRegistry.GetEmployeeDepartmentManagementService: IEmployeeDepartmentManagementService;
begin

  Result :=
    IEmployeeDepartmentManagementService(
      GetApplicationService(TEmployeeDepartmentManagementServiceType)
    );

end;

function TManagementServiceRegistry.GetUserNotificationProfileService: IUserNotificationProfileService;
begin

  Result :=
    IUserNotificationProfileService(
      FInternalRegsitry.GetInterface(TUserNotificationProfileServiceType)
    );
    
end;

procedure TManagementServiceRegistry.
  RegisterEmployeeDepartmentManagementService(
    EmployeeDepartmentManagementService: IEmployeeDepartmentManagementService
  );
begin

  RegisterApplicationService(
    TEmployeeDepartmentManagementServiceType,
    EmployeeDepartmentManagementService
  );

end;

procedure TManagementServiceRegistry.RegisterUserNotificationProfileService(
  UserNotificationProfileService: IUserNotificationProfileService);
begin

  FInternalRegsitry.RegisterInterface(
    TUserNotificationProfileServiceType, UserNotificationProfileService
  );
  
end;

end.
