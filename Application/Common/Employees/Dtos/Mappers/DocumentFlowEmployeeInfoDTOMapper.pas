unit DocumentFlowEmployeeInfoDTOMapper;

interface

uses

  DocumentFlowEmployeeInfoDTO,
  DepartmentRepository,
  DepartmentInfoDTO,
  Department,
  Employee,
  Disposable,
  IGetSelfUnit,
  SysUtils,
  Classes;

type

  IDocumentFlowEmployeeInfoDTOMapper = interface (IGetSelf)
    ['{D3E9F830-4B51-42DE-848B-8EBE49029DA6}']

    function EmptyDocumentFlowEmployeeInfoDTO: TDocumentFlowEmployeeInfoDTO;

    function MapDocumentFlowEmployeeInfoDTOFrom(
      Employee: TEmployee
    ): TDocumentFlowEmployeeInfoDTO;

  end;

  TDocumentFlowEmployeeInfoDTOMapper =
    class (
      TInterfacedObject,
      IDocumentFlowEmployeeInfoDTOMapper,
      IDisposable
    )

      private

        FDepartmentRepository: IDepartmentRepository;

        function GetDepartmentInfoDTOBy(const DepartmentId: Variant): TDepartmentInfoDTO;

      public

        constructor Create(DepartmentRepository: IDepartmentRepository);

        function GetSelf: TObject;

        function EmptyDocumentFlowEmployeeInfoDTO: TDocumentFlowEmployeeInfoDTO;
        
        function MapDocumentFlowEmployeeInfoDTOFrom(
          Employee: TEmployee
        ): TDocumentFlowEmployeeInfoDTO; virtual;

    end;
  
implementation

uses

  Variants,
  IDomainObjectBaseUnit;
  
{ TDocumentFlowEmployeeInfoDTOMapper }

constructor TDocumentFlowEmployeeInfoDTOMapper.Create(
  DepartmentRepository: IDepartmentRepository);
begin

  inherited Create;

  FDepartmentRepository := DepartmentRepository;
  
end;

function TDocumentFlowEmployeeInfoDTOMapper.
  MapDocumentFlowEmployeeInfoDTOFrom(
    Employee: TEmployee
  ): TDocumentFlowEmployeeInfoDTO;
begin

  Result := EmptyDocumentFlowEmployeeInfoDTO;

  try

    Result.RoleId := Employee.Role.Identity;
    Result.IsForeign := Employee.IsForeign;
    Result.Id := Employee.Identity;

    if Assigned(Employee.TopLevelEmployee) then
      Result.LeaderId := Employee.TopLevelEmployee.Identity;

    Result.PersonnelNumber := Employee.PersonnelNumber;
    Result.Name := Employee.Name;
    Result.Surname := Employee.Surname;
    Result.Patronymic := Employee.Patronymic;
    Result.FullName := Employee.FullName;
    Result.Speciality := Employee.Speciality;

    Result.DepartmentInfoDTO := GetDepartmentInfoDTOBy(Employee.DepartmentIdentity);

  except

    on e: Exception do begin

      FreeAndNil(Result);
      raise;
      
    end;

  end;

end;

function TDocumentFlowEmployeeInfoDTOMapper.EmptyDocumentFlowEmployeeInfoDTO: TDocumentFlowEmployeeInfoDTO;
begin

  Result := TDocumentFlowEmployeeInfoDTO.Create;
  
end;

function TDocumentFlowEmployeeInfoDTOMapper.GetDepartmentInfoDTOBy(
  const DepartmentId: Variant
): TDepartmentInfoDTO;
var
    Department: TDepartment;
    Free: IDomainObjectBase;
begin

  if VarIsNull(DepartmentId) then begin

    Result := nil;
    Exit;
    
  end;
  
  Department := FDepartmentRepository.FindDepartmentById(DepartmentId);

  if not Assigned(Department) then begin

    raise Exception.Create(
      'Не удалось найти информацию о подразделении ' +
      'сотрудника'
    );
    
  end;

  Free := Department;

  Result :=
    TDepartmentInfoDTO.CreateFrom(
      Department.Identity, Department.Code, Department.ShortName
    );
  
end;

function TDocumentFlowEmployeeInfoDTOMapper.GetSelf: TObject;
begin

  Result := Self;
  
end;

end.
