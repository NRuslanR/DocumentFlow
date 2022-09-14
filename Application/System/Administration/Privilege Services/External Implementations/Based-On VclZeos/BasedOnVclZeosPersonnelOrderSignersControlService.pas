unit BasedOnVclZeosPersonnelOrderSignersControlService;

interface

uses

  AbstractApplicationService,
  PersonnelOrderSignersControlService,
  ZConnection,
  Controls,
  SysUtils;

type

  TBasedOnVclZeosPersonnelOrderSignersControlService =
    class (TAbstractApplicationService, IPersonnelOrderSignersControlService)

      private

        FZConnection: TZConnection;

      public

        constructor Create(ZConnection: TZConnection);
        
        function CreatePersonnelOrderSignersControl(const ClientId: Variant): TControl;

    end;

implementation

uses

  UnKadrSignersList;

{ TBasedOnVclZeosPersonnelOrderSignersControlService }

constructor TBasedOnVclZeosPersonnelOrderSignersControlService.Create(
  ZConnection: TZConnection);
begin

  inherited Create;

  FZConnection := ZConnection;
  
end;

function TBasedOnVclZeosPersonnelOrderSignersControlService.CreatePersonnelOrderSignersControl(
  const ClientId: Variant): TControl;
begin

  Result := InitKadrSignersList(FZConnection, '');

  with TfrmKadrSignersList(Result) do ExitToolVisible := False;

end;

end.
