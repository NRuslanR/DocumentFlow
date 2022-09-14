unit StandardDocumentChargePerformerSetReadService;

interface

uses

  AbstractDocumentEmployeeSetReadService,
  DocumentChargePerformerSetReadService,
  EmployeeStaff,
  EmployeeStaffDto,
  EmployeeChargePerformingService,
  EmployeeChargePerformingUnit,
  EmployeeChargePerformingUnitDto,
  IEmployeeRepositoryUnit,
  EmployeeSetReadService,
  EmployeeSetHolder,
  Employee,
  VariantListUnit,
  SysUtils,
  Classes;

type

  TStandardDocumentChargePerformerSetReadService =
    class (
      TAbstractDocumentEmployeeSetReadService,
      IDocumentChargePerformerSetReadService
    )

      protected

        FEmployeeRepository: IEmployeeRepository;
        FEmployeeChargePerformingService: IEmployeeChargePerformingService;

      protected

        function GetChargePerformingUnitForEmployee(
          Employee: TEmployee
        ): TEmployeeChargePerformingUnit; virtual;

      protected

        procedure RaiseEmployeeNotFoundException;
        procedure RaiseChargePerformingUnitNotFoundException(Employee: TEmployee); 
        
      protected

        function MapEmployeeStaffDtosFrom(
          EmployeeStaffs: TEmployeeStaffs
        ): TEmployeeStaffDtos;

        function MapEmployeeChargePerformingUnitDtoFrom(
          EmployeeChargePerformingUnit: TEmployeeChargePerformingUnit
        ): TEmployeeChargePerformingUnitDto;

      public

        constructor Create(
          EmployeeRepository: IEmployeeRepository;
          EmployeeChargePerformingService: IEmployeeChargePerformingService;
          EmployeeSetReadService: IEmployeeSetReadService
        );
        
        function FindAllPossibleDocumentChargePerformerSetForEmployee(
          const EmployeeId: Variant
        ): TEmployeeSetHolder; virtual;

    end;

implementation

{ TStandardDocumentChargePerformerSetReadService }

constructor TStandardDocumentChargePerformerSetReadService.Create(
  EmployeeRepository: IEmployeeRepository;
  EmployeeChargePerformingService: IEmployeeChargePerformingService;
  EmployeeSetReadService: IEmployeeSetReadService);
begin

  inherited Create(EmployeeSetReadService);

  FEmployeeRepository := EmployeeRepository;
  FEmployeeChargePerformingService := EmployeeChargePerformingService;
  
end;

function TStandardDocumentChargePerformerSetReadService.
  FindAllPossibleDocumentChargePerformerSetForEmployee(
    const EmployeeId: Variant
  ): TEmployeeSetHolder;

var PerformingUnit: TEmployeeChargePerformingUnit;
    PerformingUnitDto: TEmployeeChargePerformingUnitDto;
    Employee: TEmployee;
begin

  Employee := nil;
  PerformingUnit := nil;

  try

    Employee :=
      FEmployeeRepository.FindEmployeeById(EmployeeId);

    if not Assigned(Employee) then RaiseEmployeeNotFoundException;

    PerformingUnit := GetChargePerformingUnitForEmployee(Employee);

    if not Assigned(PerformingUnit) then
      RaiseChargePerformingUnitNotFoundException(Employee);

    PerformingUnitDto :=
      MapEmployeeChargePerformingUnitDtoFrom(
        PerformingUnit
      );
        
    Result :=
      FEmployeeSetReadService.GetEmployeeSetFromChargePerformingUnit(
        PerformingUnitDto
      );

  finally

    FreeAndNil(Employee);
    FreeAndNil(PerformingUnit);
    FreeAndNil(PerformingUnitDto);

  end;

end;

function TStandardDocumentChargePerformerSetReadService.
  GetChargePerformingUnitForEmployee(
    Employee: TEmployee
  ): TEmployeeChargePerformingUnit;
begin

  Result :=
    FEmployeeChargePerformingService.
      FindChargePerformingUnitForEmployeeLeader(
        Employee
      );
    
end;

function TStandardDocumentChargePerformerSetReadService.
  MapEmployeeChargePerformingUnitDtoFrom(
    EmployeeChargePerformingUnit: TEmployeeChargePerformingUnit
  ): TEmployeeChargePerformingUnitDto;
begin

  Result :=
    TEmployeeChargePerformingUnitDto.Create(
      MapEmployeeStaffDtosFrom(
        EmployeeChargePerformingUnit.PerformingStaffs
      ),
      EmployeeChargePerformingUnit.EmployeeWorkGroupIds.Clone
    );

end;

function TStandardDocumentChargePerformerSetReadService.
  MapEmployeeStaffDtosFrom(
    EmployeeStaffs: TEmployeeStaffs
  ): TEmployeeStaffDtos;
var EmployeeStaff: TEmployeeStaff;
    DepartmentIds, EmployeeRoleIds: TVariantList;
begin

  DepartmentIds := nil;
  EmployeeRoleIds := nil;

  Result := TEmployeeStaffDtos.Create;

  try

    for EmployeeStaff in EmployeeStaffs do begin

      DepartmentIds := EmployeeStaff.DepartmentIds.Clone;
      EmployeeRoleIds := EmployeeStaff.EmployeeRoles.CreateDomainObjectIdentityList;

      Result.Add(
        TEmployeeStaffDto.Create(
          DepartmentIds,
          EmployeeRoleIds
        )
      );

      DepartmentIds := nil;
      EmployeeRoleIds := nil;
    
    end;

  except

    on e: Exception do begin

      FreeAndNil(Result);
      FreeAndNil(DepartmentIds);
      FreeAndNil(EmployeeRoleIds);

      raise;

    end;

  end;

end;

procedure TStandardDocumentChargePerformerSetReadService.
  RaiseChargePerformingUnitNotFoundException(Employee: TEmployee);
begin

  raise TDocumentChargePerformerSetReadServiceException.CreateFmt(
    '�� ������� ���������� ����������� ��������� ' +
    '��� ���������� "%s"',
    [
      Employee.FullName
    ]
  );
      
end;

procedure TStandardDocumentChargePerformerSetReadService.
  RaiseEmployeeNotFoundException;
begin

  raise TDocumentChargePerformerSetReadServiceException.Create(
    '�� ������ ���������, ��� �������� ' +
    '����������� ���������� ����������� ���������'
  );
      
end;

end.
