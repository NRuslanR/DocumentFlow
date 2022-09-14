unit BasedOnRepositoryEmployeeFinder;

interface

uses

  Employee,
  EmployeeFinder,
  IEmployeeRepositoryUnit,
  VariantListUnit,
  SysUtils,
  Classes;

type

  TBasedOnRepositoryEmployeeFinder = class (TInterfacedObject, IEmployeeFinder)

    protected

      FEmployeeRepository: IEmployeeRepository;

    public

      constructor Create(EmployeeRepository: IEmployeeRepository);

      function FindLeaderByDepartmentId(const DepartmentId: Variant): TEmployee;
      function FindLeaderByDepartmentCode(const DepartmentCode: String): TEmployee;
      
      function FindEmployee(const EmployeeId: Variant): TEmployee; virtual;
      function FindEmployees(const Identities: TVariantList): TEmployees; virtual;

      function FindAllTopLevelEmployeesForEmployee(const EmployeeId: Variant): TEmployees; virtual;

      function FindAllTopLevelEmployeesFromSameHeadKindredDepartmentForEmployee(
        const EmployeeId: Variant
      ): TEmployees;

  end;

implementation

{ TBasedOnRepositoryEmployeeFinder }

constructor TBasedOnRepositoryEmployeeFinder.Create(
  EmployeeRepository: IEmployeeRepository);
begin

  inherited Create;

  FEmployeeRepository := EmployeeRepository;
  
end;

function TBasedOnRepositoryEmployeeFinder.FindAllTopLevelEmployeesForEmployee(
  const EmployeeId: Variant): TEmployees;
begin

  Result := FEmployeeRepository.FindAllTopLevelEmployeesForEmployee(EmployeeId);
  
end;

function TBasedOnRepositoryEmployeeFinder.FindAllTopLevelEmployeesFromSameHeadKindredDepartmentForEmployee(
  const EmployeeId: Variant): TEmployees;
begin

  Result :=
    FEmployeeRepository.
      FindAllTopLevelEmployeesFromSameHeadKindredDepartmentForEmployee(
        EmployeeId
      );
    
end;

function TBasedOnRepositoryEmployeeFinder.FindEmployee(
  const EmployeeId: Variant): TEmployee;
begin

  Result := FEmployeeRepository.FindEmployeeById(EmployeeId);
  
end;

function TBasedOnRepositoryEmployeeFinder.FindEmployees(
  const Identities: TVariantList): TEmployees;
begin

  Result := FEmployeeRepository.FindEmployeesByIdentities(Identities);
  
end;

function TBasedOnRepositoryEmployeeFinder.FindLeaderByDepartmentCode(
  const DepartmentCode: String
): TEmployee;
begin

  Result := FEmployeeRepository.FindLeaderByDepartmentCode(DepartmentCode);

end;

function TBasedOnRepositoryEmployeeFinder.FindLeaderByDepartmentId(
  const DepartmentId: Variant
): TEmployee;
begin

  Result := FEmployeeRepository.FindLeaderByDepartmentId(DepartmentId);
  
end;

end.
