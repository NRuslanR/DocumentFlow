unit BasedOnVclZeosPersonnelOrderControlGroupsControlService;

interface

uses

  AbstractApplicationService,
  PersonnelOrderControlGroupsControlService,
  ZConnection,
  Controls,
  SysUtils;

type

  TBasedOnVclZeosPersonnelOrderControlGroupsControlService =
    class (
      TAbstractApplicationService,
      IPersonnelOrderControlGroupsControlService
    )

      private

        FZConnection: TZConnection;

      public


        constructor Create(ZConnection: TZConnection);

        function CreatePersonnelOrderControlGroupsControlService(
          const ClientId: Variant
        ): TControl;

    end;

implementation

uses

  UnKadrGroup, UnGroupTempl;

{ TBasedOnVclZeosPersonnelOrderControlGroupsControlService }

constructor TBasedOnVclZeosPersonnelOrderControlGroupsControlService.Create(
  ZConnection: TZConnection);
begin

  inherited Create;

  FZConnection := ZConnection;
  
end;

function TBasedOnVclZeosPersonnelOrderControlGroupsControlService.
  CreatePersonnelOrderControlGroupsControlService(const ClientId: Variant): TControl;
begin

  Result := InitControlGroups(FZConnection);

  with TfrmKadrGroup(Result) do ExitToolVisible := False;

end;

end.
