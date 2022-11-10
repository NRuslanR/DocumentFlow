unit DocumentResponsibleInfoDTOMapper;

interface

uses

  Employee,
  DocumentResponsibleInfoDTO,
  DepartmentInfoDTO,
  IDocumentResponsibleRepositoryUnit,
  SysUtils;

type

  TDocumentResponsibleInfoDTOMapper = class;

  IDocumentResponsibleInfoDTOMapper = interface

    function AsSelf: TDocumentResponsibleInfoDTOMapper;

    function MapDocumentResponsibleInfoDTOById(const EmployeeId: Variant): TDocumentResponsibleInfoDTO; overload;

    function MapDocumentResponsibleInfoDTO(
      DocumentResponsibleInfoDTO: TDocumentResponsibleInfoDTO
    ): TEmployee; overload;

  end;

  TDocumentResponsibleInfoDTOMapper =
    class (TInterfacedObject, IDocumentResponsibleInfoDTOMapper)

      private

        FResponsibleRepository: IDocumentResponsibleRepository;

      public

        constructor Create(ResponsibleRepository: IDocumentResponsibleRepository);

        function AsSelf: TDocumentResponsibleInfoDTOMapper;

        function MapDocumentResponsibleInfoDTOById(const EmployeeId: Variant): TDocumentResponsibleInfoDTO; overload;
        
        function MapDocumentResponsibleInfoDTO(
          DocumentResponsibleInfoDTO: TDocumentResponsibleInfoDTO
        ): TEmployee; overload;

    end;
  
implementation

uses
       
  Variants,
  Department,
  AuxDebugFunctionsUnit,
  IDomainObjectBaseUnit;

{ TDocumentResponsibleInfoDTOMapper }

constructor TDocumentResponsibleInfoDTOMapper.Create(
  ResponsibleRepository: IDocumentResponsibleRepository);
begin

  inherited Create;

  FResponsibleRepository := ResponsibleRepository;

end;

function TDocumentResponsibleInfoDTOMapper.AsSelf: TDocumentResponsibleInfoDTOMapper;
begin

  Result := Self;

end;

function TDocumentResponsibleInfoDTOMapper.MapDocumentResponsibleInfoDTO(
  DocumentResponsibleInfoDTO: TDocumentResponsibleInfoDTO
): TEmployee;
begin

  Result := TEmployee.Create;

  try

    Result.Identity := DocumentResponsibleInfoDTO.Id;
    Result.Name := DocumentResponsibleInfoDTO.Name;
    Result.TelephoneNumber := DocumentResponsibleInfoDTO.TelephoneNumber;
    Result.DepartmentIdentity := DocumentResponsibleInfoDTO.DepartmentInfoDTO.Id;

  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;

end;

function TDocumentResponsibleInfoDTOMapper.MapDocumentResponsibleInfoDTOById(
  const EmployeeId: Variant): TDocumentResponsibleInfoDTO;
var
    Employee: TEmployee;
    FreeEmployee: IDomainObjectBase;

    Department: TDepartment;
    FreeDepartment: IDomainObjectBase;
begin

  Result := TDocumentResponsibleInfoDTO.Create;

  if VarIsNull(EmployeeId) then Exit;
  
  try

    Employee := FResponsibleRepository.FindDocumentResponsibleById(EmployeeId);

    if not Assigned(Employee) then Exit;
    
    FreeEmployee := Employee;

    Result.Id := Employee.Identity;
    Result.Name := Employee.FullName;
    Result.TelephoneNumber := Employee.TelephoneNumber;

    Department :=
      FResponsibleRepository
        .FindDocumentResponsibleDepartmentById(Employee.DepartmentIdentity);

    if not Assigned(Department) then Exit;

    FreeDepartment := Department;
    
    Result.DepartmentInfoDTO :=
      TDepartmentInfoDTO.CreateFrom(
        Department.Identity, Department.Code, Department.ShortName
      );

  except

    on E: Exception do begin

      if
        (E is TDocumentResponsibleNotFoundException)
        or (E is TDocumentResponsibleDepartmentNotFoundException)
      then begin

        Result.DepartmentInfoDTO := TDepartmentInfoDTO.Create;
        
      end

      else begin

        FreeAndNil(Result);

        Raise;

      end;

    end;

  end;

end;

end.
