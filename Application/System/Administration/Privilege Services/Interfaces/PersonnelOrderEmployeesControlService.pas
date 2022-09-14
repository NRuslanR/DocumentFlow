unit PersonnelOrderEmployeesControlService;

interface

uses

  ApplicationService,
  Controls,
  SysUtils;

type

  IPersonnelOrderEmployeesControlService = interface (IApplicationService)

    function CreatePersonnelOrderEmployeesControl(const ClientId: Variant): TControl;

  end;

implementation

end.
