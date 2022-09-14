unit ProgramChangesNotificationControlService;

interface

uses

  ApplicationService,
  Controls;

type
    
  IProgramChangesNotificationControlService = interface (IApplicationService)
    ['{D95D4B81-A0FD-4A9C-9D97-241009993A3A}']

    {
      Для пользователя UserId возвращает
      Control с описанием изменений в
      пользовательском функционале программы.

      В случае, если пользователь UserId недействительный (не найден),
      возвращает nil.

    }
    function GetProgramChangesNotificationControlForUser(const UserId: Variant): TControl;

  end;
  
implementation

end.
