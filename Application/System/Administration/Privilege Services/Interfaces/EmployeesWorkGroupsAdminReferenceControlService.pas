unit EmployeesWorkGroupsAdminReferenceControlService;

interface

uses

  ApplicationService,
  Controls,
  SysUtils;

type

  TEmployeesWorkGroupsAdminReferenceControlServiceException =
    class (TApplicationServiceException)

    end;
    
  IEmployeesWorkGroupsAdminReferenceControlService =
    interface (IApplicationService)
      ['{89BA4745-9DCC-4892-BE14-9A95FF7786E0}']  

      function GetEmployeesWorkGroupsAdminReferenceControl(
        const ClientId: Variant
      ): TControl;
      
    end;

implementation

end.
