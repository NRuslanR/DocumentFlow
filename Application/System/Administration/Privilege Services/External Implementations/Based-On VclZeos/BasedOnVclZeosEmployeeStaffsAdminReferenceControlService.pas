unit BasedOnVclZeosEmployeeStaffsAdminReferenceControlService;

interface

uses

  AbstractApplicationService,
  Controls,
  ZConnection,
  EmployeeStaffsAdminReferenceControlService,
  SysUtils;

type

  TBasedOnVclZeosEmployeeStaffsAdminReferenceControlService =
    class (TAbstractApplicationService, IEmployeeStaffsAdminReferenceControlService)

      private

        FZConnection: TZConnection;
        
      public

        constructor Create(ZConnection: TZConnection);
        
        function GetEmployeeStaffsAdminReferenceControl(const ClientId: Variant): TControl;
        
    end;
  
implementation

uses

  UnPodrPeopleRoles;
  
{ TBasedOnVclZeosEmployeeStaffsAdminReferenceControlService }

constructor TBasedOnVclZeosEmployeeStaffsAdminReferenceControlService.Create(
  ZConnection: TZConnection
);
begin

  inherited Create;

  FZConnection := ZConnection;

end;

function TBasedOnVclZeosEmployeeStaffsAdminReferenceControlService.GetEmployeeStaffsAdminReferenceControl(
  const ClientId: Variant
): TControl;
begin

  Result := InitPodrPeopleRoles(FZConnection);

  with TfrmPodrPeopleRoles(Result) do ExitToolVisible := False;
  
end;

end.
