unit EmployeeDepartmentManagementService;

interface

uses

  DepartmentInfoDTO,
  ApplicationService;

type

  IEmployeeDepartmentManagementService = interface (IApplicationService)

    function FindAllKindredDepartmentsBeginningWithEmployeeDepartment(
      const EmployeeId: Variant
    ): TDepartmentsInfoDTO;
    
  end;
  
implementation

end.
