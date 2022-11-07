unit StandardEmployeeDepartmentManagementService;

interface

uses

  EmployeeDepartmentManagementService,
  DepartmentRepository,
  IEmployeeRepositoryUnit,
  DepartmentInfoDTO,
  Department,
  Session,
  SysUtils,
  Classes;

type

  TStandardEmployeeDepartmentManagementService =
    class (TInterfacedObject, IEmployeeDepartmentManagementService)

      private

        FDepartmentRepository: IDepartmentRepository;
        FEmployeeRepository: IEmployeeRepository;
        FSession: ISession;

        function MapDepartmentsInfoDTOFrom(
          Departments: TDepartments
        ): TDepartmentsInfoDTO;
        
      public

        constructor Create(
          Session: ISession;
          DepartmentRepository: IDepartmentRepository;
          EmployeeRepository: IEmployeeRepository
        );

        function FindAllKindredDepartmentsBeginningWithEmployeeDepartment(
          const EmployeeId: Variant
        ): TDepartmentsInfoDTO;

        function GetSelf: TObject;
        
    end;
    
implementation

uses

  Employee;
  
{ TStandardEmployeeDepartmentManagementService }

constructor TStandardEmployeeDepartmentManagementService.Create(
  Session: ISession;
  DepartmentRepository: IDepartmentRepository;
  EmployeeRepository: IEmployeeRepository);
begin

  inherited Create;

  FSession := Session;
  FDepartmentRepository := DepartmentRepository;
  FEmployeeRepository := EmployeeRepository;
  
end;

function TStandardEmployeeDepartmentManagementService.
  FindAllKindredDepartmentsBeginningWithEmployeeDepartment(
    const EmployeeId: Variant
  ): TDepartmentsInfoDTO;
var Employee: TEmployee;
    Departments: TDepartments;
begin

  try

    FSession.Start;

    Employee := FEmployeeRepository.FindEmployeeById(EmployeeId);
    Departments :=
      FDepartmentRepository.FindAllKindredDepartmentsBeginningWith(
        Employee.DepartmentIdentity
      );

    FSession.Commit;

    Result := MapDepartmentsInfoDTOFrom(Departments);

  except

    on e: Exception do begin

      FSession.Rollback;
      
      raise;

    end;
    
  end;

end;

function TStandardEmployeeDepartmentManagementService.GetSelf: TObject;
begin

  Result := Self;
  
end;

function TStandardEmployeeDepartmentManagementService.MapDepartmentsInfoDTOFrom(
  Departments: TDepartments
): TDepartmentsInfoDTO;
var Department: TDepartment;
begin

  if not Assigned(Departments) then begin

    Result := nil;
    Exit;
    
  end;

  Result := TDepartmentsInfoDTO.Create;

  for Department in Departments do begin

    Result.Add(
      TDepartmentInfoDTO.CreateFrom(
        Department.Identity,
        Department.Code,
        Department.ShortName
      )
    );
    
  end;

end;

end.
