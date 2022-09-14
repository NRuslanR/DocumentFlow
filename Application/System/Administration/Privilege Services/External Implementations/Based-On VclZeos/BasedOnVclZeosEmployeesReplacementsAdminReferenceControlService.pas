unit BasedOnVclZeosEmployeesReplacementsAdminReferenceControlService;

interface

uses

  AbstractApplicationService,
  EmployeesReplacementsAdminReferenceControlService,
  Controls,
  ZConnection,
  SysUtils;

type

  TBasedOnVclZeosEmployeesReplacementsAdminReferenceControlService =
    class (TAbstractApplicationService, IEmployeesReplacementsAdminReferenceControlService)

      private

        FZConnection: TZConnection;
        
      public

        constructor Create(ZConnection: TZConnection);
        
        function GetEmployeesReplacementsAdminReferenceControl(
          const ClientId: Variant
        ): TControl;

    end;

implementation

uses

  UnReplacements;
  
{ TBasedOnVclZeosEmployeesReplacementsAdminReferenceControlService }

constructor TBasedOnVclZeosEmployeesReplacementsAdminReferenceControlService.Create(
  ZConnection: TZConnection
);
begin

  inherited Create;

  FZConnection := ZConnection;
  
end;

function TBasedOnVclZeosEmployeesReplacementsAdminReferenceControlService.
  GetEmployeesReplacementsAdminReferenceControl(
    const ClientId: Variant
  ): TControl;
begin

  Result := InitReplacements(FZConnection, '');

  TfrmReplacements(Result).ExitToolVisible := False;

end;

end.
