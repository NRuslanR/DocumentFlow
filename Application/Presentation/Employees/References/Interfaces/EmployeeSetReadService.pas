unit EmployeeSetReadService;

interface

uses

  EmployeeStaffDto,
  EmployeeChargePerformingUnitDto,
  ApplicationService,
  EmployeeSetHolder,
  VariantListUnit,
  SysUtils,
  Classes;

type

  IEmployeeSetReadService = interface (IApplicationService)

    function GetAllEmployeeSet: TEmployeeSetHolder;

    function GetAllEmployeeSetByGivenRoles(
      EmployeeRoleIds: TVariantList
    ): TEmployeeSetHolder;

    function GetAllLeaderSet: TEmployeeSetHolder;
    
    function GetAllPlantEmployeeSet: TEmployeeSetHolder;

    function GetAllPlantEmployeeSetFromHeadKindredDepartmentOfOtherEmployee(
      const OtherEmployeeId: Variant
    ): TEmployeeSetHolder;
    
    function GetEmployeeSetFromHeadKindredDepartmentOfOtherEmployee(
      const OtherEmployeeId: Variant
    ): TEmployeeSetHolder;

    function GetEmployeeSetByIds(
      const EmployeeIds: TVariantList
    ): TEmployeeSetHolder;

    function GetLeaderSetForEmployeeFromSameHeadKindredDepartment(
      const EmployeeId: Variant
    ): TEmployeeSetHolder;

    function GetAllNotForeignEmployeeSet: TEmployeeSetHolder;

    function GetAllEmployeeWithRoleSet: TEmployeeSetHolder;

    function GetEmployeeSetFromEmployeeStaffs(
      const EmployeeStaffDtos: TEmployeeStaffDtos
    ): TEmployeeSetHolder;

    function GetEmployeeSetFromChargePerformingUnit(
      EmployeeChargePerformingUnitDto: TEmployeeChargePerformingUnitDto
    ): TEmployeeSetHolder;

    function GetLeadershipEmployeeSetForLeader(const LeaderId: Variant): TEmployeeSetHolder;
    function PrepareLeadershipEmployeeSetForLeader(const LeaderId: Variant): TEmployeeSetHolder;
    
  end;
  
implementation

end.
