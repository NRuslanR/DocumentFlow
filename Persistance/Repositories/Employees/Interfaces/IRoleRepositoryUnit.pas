unit IRoleRepositoryUnit;

interface

uses

  RoleUnit,
  VariantListUnit,
  Employee;

type

  IRoleRepository = interface

    procedure AddRoleForEmployee(Employee: TEmployee);
    procedure RemoveRoleFromEmployee(Employee: TEmployee);
    procedure RemoveAllRolesFromEmployee(Employee: TEmployee);
    function FindRoleForEmployee(Employee: TEmployee): TRole;
    function FindRoleById(const Id: Variant): TRole;
    function FindRolesByIds(const Ids: TVariantList): TRoleList;
    function FindRoleByName(const RoleName: String): TRole;
    function LoadAllRoles: TRoleList;

  end;

implementation

end.
