unit UserNotificationsSettingsFrameFactory;

interface

uses

  unUserNotificationsSettingsFrame,
  Classes;

type

  IUserNotificationsSettingsFrameFactory = interface

    function CreateUserNotificationsSettingsFrame(
      Owner: TComponent;
      UserId: Variant
    ): TUserNotificationsSettingsFrame;

  end;

implementation

end.
