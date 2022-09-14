unit DepartmentRepository;

interface

uses

  DepartmentUnit;

type

  IDepartmentRepository = interface

    function LoadAllDepartments: TDepartments;
    function FindDepartmentById(const Id: Variant): TDepartment;

    function IsDepartmentIncludesOtherDepartment(
      const TargetDepartmentId, OtherDepartmentId: Variant
    ): Boolean;

    function FindDepartmentByCode(const Code: String): TDepartment;
    function FindAllDepartmentsBeginningWith(
      const TargetDepartmentId: Variant
    ): TDepartments;

    function FindAllKindredDepartmentsBeginningWith(
      const TargetDepartmentId: Variant
    ): TDepartments;

    function FindAllNotKindredInnerDepartmentsForDepartment(
      const TargetDepartmentId: Variant
    ): TDepartments;
    
    function FindHeadKindredDepartmentForGivenDepartment(
      const DepartmentId: Variant
    ): TDepartment;

    procedure AddDepartment(Department: TDepartment);
    procedure UpdateDepartment(Department: TDepartment);
    procedure RemoveDepartment(Department: TDepartment);

  end;
  
implementation

end.
