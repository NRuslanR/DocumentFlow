unit EmployeesAdminReferenceControlService;

interface

uses

  ApplicationService,
  Controls,
  SysUtils;

type

  TEmployeesAdminReferenceControlServiceException = class (TApplicationServiceException)

  end;
  
  IEmployeesAdminReferenceControlService = interface (IApplicationService)
    ['{EA3E1D1D-6BBE-4A37-98DA-626E171F49FB}']

    function GetEmployeesAdminReferenceControl(const ClientId: Variant): TControl;
    
  end;

implementation

end.
