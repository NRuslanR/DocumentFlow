unit BasedOnVclZeosEmployeesAdminReferenceControlService;

interface

uses

  AbstractApplicationService,
  EmployeesAdminReferenceControlService,
  Controls,
  ZConnection,
  SysUtils;

type

  TBasedOnVclZeosEmployeesAdminReferenceControlService =
    class (TAbstractApplicationService, IEmployeesAdminReferenceControlService)

      private

        FZConnection: TZConnection;
        
      public

        constructor Create(ZConnection: TZConnection);
        
        function GetEmployeesAdminReferenceControl(const ClientId: Variant): TControl;
      
    end;


implementation

uses

  UnAddPers;

{ TBasedOnVclZeosEmployeesAdminReferenceControlService }

constructor TBasedOnVclZeosEmployeesAdminReferenceControlService.Create(
  ZConnection: TZConnection
);
begin

  inherited Create;

  FZConnection := ZConnection;

end;

function TBasedOnVclZeosEmployeesAdminReferenceControlService.GetEmployeesAdminReferenceControl(
  const ClientId: Variant): TControl;
begin

  Result := InitRegDocUser(FZConnection);

  with TfrmAddDocPers(Result) do ExitToolVisible := False;
  
end;

end.
