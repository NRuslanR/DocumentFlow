unit BasedOnRepositoryDepartmentFinder;

interface

uses

  DepartmentFinder,
  DepartmentRepository,
  SysUtils,
  Classes,
  DepartmentUnit;

type

  TBasedOnRepositoryDepartmentFinder = class (TInterfacedObject, IDepartmentFinder)

    protected

      FDepartmentRepository: IDepartmentRepository;

    public

      constructor Create(DepartmentRepository: IDepartmentRepository);

      function FindDepartmentByCode(const Code: String): TDepartment;
      function FindDepartment(const DepartmentId: Variant): TDepartment;
      function FindHeadKindredDepartmentForInnerDepartment(const InnerDepartmentId: Variant): TDepartment;

      function FindAllDepartmentsBeginningWith(
        const TargetDepartmentId: Variant
      ): TDepartments;

      function FindAllKindredDepartmentsBeginningWith(
        const TargetDepartmentId: Variant
      ): TDepartments;

      function FindAllNotKindredInnerDepartmentsForDepartment(
        const TargetDepartmentId: Variant
      ): TDepartments;

  end;

implementation

{ TBasedOnRepositoryDepartmentFinder }

constructor TBasedOnRepositoryDepartmentFinder.Create(
  DepartmentRepository: IDepartmentRepository);
begin

  inherited Create;

  FDepartmentRepository := DepartmentRepository;
  
end;

function TBasedOnRepositoryDepartmentFinder.FindAllDepartmentsBeginningWith(
  const TargetDepartmentId: Variant
): TDepartments;
begin

  Result :=
    FDepartmentRepository.FindAllDepartmentsBeginningWith(
      TargetDepartmentId
    );
    
end;

function TBasedOnRepositoryDepartmentFinder.
  FindAllKindredDepartmentsBeginningWith(
    const TargetDepartmentId: Variant
  ): TDepartments;
begin

  Result :=
    FDepartmentRepository.FindAllKindredDepartmentsBeginningWith(
      TargetDepartmentId
    );

end;

function TBasedOnRepositoryDepartmentFinder.FindAllNotKindredInnerDepartmentsForDepartment(
  const TargetDepartmentId: Variant): TDepartments;
begin

  Result :=
    FDepartmentRepository.FindAllNotKindredInnerDepartmentsForDepartment(
      TargetDepartmentId
    );
    
end;

function TBasedOnRepositoryDepartmentFinder.FindDepartment(
  const DepartmentId: Variant): TDepartment;
begin

  Result := FDepartmentRepository.FindDepartmentById(DepartmentId);
  
end;

function TBasedOnRepositoryDepartmentFinder.FindDepartmentByCode(
  const Code: String): TDepartment;
begin

  Result := FDepartmentRepository.FindDepartmentByCode(Code);
  
end;

function TBasedOnRepositoryDepartmentFinder.FindHeadKindredDepartmentForInnerDepartment(
  const InnerDepartmentId: Variant): TDepartment;
begin

  Result := FDepartmentRepository.FindHeadKindredDepartmentForGivenDepartment(InnerDepartmentId);

end;

end.
