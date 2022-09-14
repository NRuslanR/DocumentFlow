unit NotificationRegistry;

interface

uses

  ApplicationVersionInfoService,
  _ApplicationServiceRegistry,
  SysUtils,
  Classes;

type

  TNotificationServiceRegistry = class (TApplicationServiceRegistry)

    public

      procedure RegisterApplicationVersionInfoService(
        ApplicationVersionInfoService:
          IApplicationVersionInfoService
      );

      function GetApplicationVersionInfoService:
        IApplicationVersionInfoService;
      
  end;

implementation

uses TypeObjectRegistry;

type

  TApplicationVersionInfoType = class

  end;

{ TNotificationsServiceRegistry }

function TNotificationServiceRegistry.GetApplicationVersionInfoService: IApplicationVersionInfoService;
begin
  Result :=
    IApplicationVersionInfoService(
      FInternalRegsitry.GetInterface(TApplicationVersionInfoType)
    );
end;

procedure TNotificationServiceRegistry.RegisterApplicationVersionInfoService(
  ApplicationVersionInfoService: IApplicationVersionInfoService);
begin
  RegisterApplicationService(
    TApplicationVersionInfoType,
    ApplicationVersionInfoService
  );
end;

end.
