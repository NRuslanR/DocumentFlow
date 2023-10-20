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

        function FindEmployeeByIdOrRaise(const EmployeeId: Variant): TEmployee;
        function FindChargePerformingUnitForEmployeeOrRaise(Employee: TEmployee): TEmployeeChargePerformingUnit;

        function GetEmployeeSetFromChargePerformingUnit(PerformingUnit: TEmployeeChargePerformingUnit): TEmployeeSetHolder;
        
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

uses

  IDomainObjectBaseUnit;

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

var
    Employee: TEmployee;
    FreeEmployee: IDomainObjectBase;

    PerformingUnit: TEmployeeChargePerformingUnit;
    FreePerformingUnit: IDomainObjectBase;
begin

  Employee := FindEmployeeByIdOrRaise(EmployeeId);

  FreeEmployee := Employee;

  PerformingUnit := FindChargePerformingUnitForEmployeeOrRaise(Employee);

  FreePerformingUnit := PerformingUnit;
  
  Result := GetEmployeeSetFromChargePerformingUnit(PerformingUnit);

end;

function TStandardDocumentChargePerformerSetReadService.FindChargePerformingUnitForEmployeeOrRaise(
  Employee: TEmployee): TEmployeeChargePerformingUnit;
begin

  Result := GetChargePerformingUnitForEmployee(Employee);

  if not Assigned(Result) then
    RaiseChargePerformingUnitNotFoundException(Employee);

end;

function TStandardDocumentChargePerformerSetReadService.FindEmployeeByIdOrRaise(
  const EmployeeId: Variant): TEmployee;
begin

  Result :=FEmployeeRepository.FindEmployeeById(EmployeeId);

  if not Assigned(Result) then RaiseEmployeeNotFoundException;

end;

function TStandardDocumentChargePerformerSetReadService.GetEmployeeSetFromChargePerformingUnit(
  PerformingUnit: TEmployeeChargePerformingUnit): TEmployeeSetHolder;
var
    PerformingUnitDto: TEmployeeChargePerformingUnitDto;
begin

  PerformingUnitDto :=
    MapEmployeeChargePerformingUnitDtoFrom(
      PerformingUnit
    );

  try

    Result :=
      FEmployeeSetReadService.GetEmployeeSetFromChargePerformingUnit(
        PerformingUnitDto
      );

  finally

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
    'Не удалось определить получателей документа ' +
    'для сотрудника "%s"',
    [
      Employee.FullName
    ]
  );
      
end;

procedure TStandardDocumentChargePerformerSetReadService.
  RaiseEmployeeNotFoundException;
begin

  raise TDocumentChargePerformerSetReadServiceException.Create(
    'Не найден сотрудник, для которого ' +
    'требовалось определить получателей документа'
  );
      
end;

end.
