unit BasedOnVclZeosEmployeesWorkGroupsAdminReferenceControlService;

interface

uses

  AbstractApplicationService,
  EmployeesWorkGroupsAdminReferenceControlService,
  Controls,
  ZConnection,
  SysUtils;

type

  TBasedOnVclZeosEmployeesWorkGroupsAdminReferenceControlService =
    class (TAbstractApplicationService, IEmployeesWorkGroupsAdminReferenceControlService)

      private

        FZConnection: TZConnection;
        
      public

        constructor Create(ZConnection: TZConnection);
        
        function GetEmployeesWorkGroupsAdminReferenceControl(
          const ClientId: Variant
        ): TControl;

    end;

implementation

uses

  UnWorkGroups;
  
{ TBasedOnVclZeosEmployeesWorkGroupsAdminReferenceControlService }

constructor TBasedOnVclZeosEmployeesWorkGroupsAdminReferenceControlService.Create(
  ZConnection: TZConnection);
begin

  inherited Create;

  FZConnection := ZConnection;
  
end;

function TBasedOnVclZeosEmployeesWorkGroupsAdminReferenceControlService.
  GetEmployeesWorkGroupsAdminReferenceControl(
    const ClientId: Variant
  ): TControl;
begin

  Result := InitWorkGroups(FZConnection);

  with TfrmWorkGroup(Result) do ExitToolVisible := False;
  
end;

end.
