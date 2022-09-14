unit EmployeeStaffsAdminReferenceControlService;

interface

uses

  ApplicationService,
  Controls,
  SysUtils;

type

  TEmployeeStaffsAdminReferenceControlServiceException =
    class (TApplicationServiceException)

    end;
    
  IEmployeeStaffsAdminReferenceControlService = interface (IApplicationService)
    ['{C26C774B-E5AF-47EA-8857-6428B8647504}']

    function GetEmployeeStaffsAdminReferenceControl(const ClientId: Variant): TControl;
      
  end;

  
implementation

end.
