unit BasedOnVclZeosPersonnelOrderEmployeesControlService;

interface

uses

  AbstractApplicationService,
  PersonnelOrderEmployeesControlService,
  ZConnection,
  Controls,
  SysUtils;

type

  TBasedOnVclZeosPersonnelOrderEmployeesControlService =
    class (TAbstractApplicationService, IPersonnelOrderEmployeesControlService)

      private

        FZConnection: TZConnection;
        
      public

        constructor Create(ZConnection: TZConnection);

        function CreatePersonnelOrderEmployeesControl(const ClientId: Variant): TControl;

    end;


implementation

uses

  UnKadrEditPersonList;

{ TBasedOnVclZeosPersonnelOrderEmployeesControlService }

constructor TBasedOnVclZeosPersonnelOrderEmployeesControlService.Create(
  ZConnection: TZConnection);
begin

  inherited Create;

  FZConnection := ZConnection;
  
end;

function TBasedOnVclZeosPersonnelOrderEmployeesControlService.
  CreatePersonnelOrderEmployeesControl(const ClientId: Variant): TControl;
begin

  Result := InitKadrEditPersonList(FZConnection, '');

  with TfrmKadrPersonList(Result) do ExitToolVisible := False;

end;

end.
