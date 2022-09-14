unit DepartmentsAdminReferenceControlService;

interface

uses

  ApplicationService,
  Controls,
  SysUtils;

type

  TDepartmentsAdminReferenceControlServiceException =
    class (TApplicationServiceException)

    end;

  IDepartmentsAdminReferenceControlService = interface (IApplicationService)
    ['{DEDEE9E6-17C3-46AF-A2D7-2F449690437A}']

    function GetDepartmentsAdminReferenceControl(const ClientId: Variant): TControl;
    
  end;

implementation

end.
