unit BasedOnZeosPostgresProgramChangesNotificationControlService;

interface

uses

  AbstractApplicationService,
  ProgramChangesNotificationControlService,
  ZConnection,
  Controls,
  SysUtils,
  Classes;

type

  TBasedOnZeosPostgresProgramChangesNotificationControlService =
    class (TAbstractApplicationService, IProgramChangesNotificationControlService)

      private

        FZConnection: TZConnection;
        
      public

        constructor Create(ZConnection: TZConnection);

        function GetProgramChangesNotificationControlForUser(const UserId: Variant): TControl;

    end;

implementation

{ TBasedOnZeosPostgresProgramChangesNotificationControlService }

constructor TBasedOnZeosPostgresProgramChangesNotificationControlService.Create(
  ZConnection: TZConnection
);
begin

  inherited Create;

  FZConnection := ZConnection;
  
end;

function TBasedOnZeosPostgresProgramChangesNotificationControlService.
  GetProgramChangesNotificationControlForUser(
    const UserId: Variant
  ): TControl;
begin

  raise Exception.Create('GetProgramChangesNotificationControlForUser not implemented');
  
end;

end.
