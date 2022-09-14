unit IEmployeeRepositoryUnit;

interface

uses

  Employee,
  VariantListUnit;
  
type

  IEmployeeRepository = interface

    function FindLeaderByDepartmentId(const DepartmentId: Variant): TEmployee;
    function FindLeaderByDepartmentCode(const DepartmentCode: String): TEmployee;
    
    function FindLeadersForEmployee(const EmployeeId: Variant): TEmployees;
    function FindAllTopLevelEmployeesForEmployee(const EmployeeId: Variant): TEmployees;

    function FindAllTopLevelEmployeesFromSameHeadKindredDepartmentForEmployee(
      const EmployeeId: Variant
    ): TEmployees;
    
    function FindEmployeeById(const Id: Variant): TEmployee;
    function FindEmployeesByIdentities(const Identities: TVariantList): TEmployees;

    function FindLeadersByIdentities(const Identities: TVariantList): TEmployees;
        
    function FindEmployeesByIdentitiesAndRoles(
      const Identities:  TVariantList;
      const RoleIds: TVariantList
    ): TEmployees;
    
    function FindLeadershipEmployeesForLeader(const LeaderId: Variant): TEmployees;

    function FindEmployeesForLeaderByRoles(
      const LeaderId: Variant;
      const RoleIds: TVariantList
    ): TEmployees;
    
    function LoadAllEmployees: TEmployees;
    procedure AddEmployee(Employee: TEmployee);
    procedure UpdateEmployee(Employee: TEmployee);
    procedure RemoveEmployee(Employee: TEmployee);
    
  end;

implementation

end.
