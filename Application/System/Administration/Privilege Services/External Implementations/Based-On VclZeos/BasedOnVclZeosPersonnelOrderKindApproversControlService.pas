unit BasedOnVclZeosPersonnelOrderKindApproversControlService;

interface

uses

  AbstractApplicationService,
  PersonnelOrderKindApproversControlService,
  ZConnection,
  Controls,
  SysUtils;

type

  TBasedOnVclZeosPersonnelOrderKindApproversControlService =
    class (TAbstractApplicationService, IPersonnelOrderKindApproversControlService)

      private

        FZConnection: TZConnection;

      public

        constructor Create(ZConnection: TZConnection);
        
        function CreatePersonnelOrderKindApproversControl(const ClientId: Variant): TControl;

    end;

implementation

uses

  UnKadrTypeApprovers, UnGroupTempl;

{ TBasedOnVclZeosPersonnelOrderKindApproversControlService }

constructor TBasedOnVclZeosPersonnelOrderKindApproversControlService.Create(
  ZConnection: TZConnection);
begin

  inherited Create;

  FZConnection := ZConnection;

end;

function TBasedOnVclZeosPersonnelOrderKindApproversControlService.CreatePersonnelOrderKindApproversControl(
  const ClientId: Variant): TControl;
begin

  Result := InitKadrTypeApprovers(FZConnection);

  with TfrmKadrTypeApprovers(Result) do ExitToolVisible := False;

end;

end.
