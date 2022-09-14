unit EmployeesReplacementsAdminReferenceControlService;

interface

uses

  ApplicationService,
  Controls,
  SysUtils;

type

  TEmployeesReplacementsAdminReferenceControlServiceException =
    class (TApplicationServiceException)

    end;

  IEmployeesReplacementsAdminReferenceControlService =
    interface (IApplicationService)
      ['{97DD9371-E200-4BDF-95A2-B1B0E52D8E25}']

      function GetEmployeesReplacementsAdminReferenceControl(
        const ClientId: Variant
      ): TControl;
      
    end;

implementation

end.
