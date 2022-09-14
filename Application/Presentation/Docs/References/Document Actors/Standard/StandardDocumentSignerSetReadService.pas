unit StandardDocumentSignerSetReadService;

interface

uses

  DocumentSignerSetReadService,
  EmployeeSetHolder,
  EmployeeSetReadService,
  EmployeeSubordinationService,
  AbstractDocumentEmployeeSetReadService,
  IEmployeeRepositoryUnit,
  VariantListUnit,
  Employee,
  SysUtils,
  Classes;

type

  TStandardDocumentSignerSetReadService =
    class (TAbstractDocumentEmployeeSetReadService, IDocumentSignerSetReadService)

      protected

        FEmployeeRepository: IEmployeeRepository;
        FEmployeeSubordinationService: IEmployeeSubordinationService;

      protected

        function FindAllBusinessLeadersForEmployee(Employee: TEmployee): TEmployees; virtual;
        
      public

        constructor Create(
          EmployeeRepository: IEmployeeRepository;
          EmployeeSubordinationService: IEmployeeSubordinationService;
          EmployeeSetReadService: IEmployeeSetReadService
        );

        function FindAllPossibleDocumentSignerSetForEmployee(
          const EmployeeId: Variant
        ): TEmployeeSetHolder; virtual;

    end;


implementation

uses

  IDomainObjectUnit,
  IDomainObjectListUnit;

{ TStandardDocumentSignerSetReadService }

constructor TStandardDocumentSignerSetReadService.Create(
  EmployeeRepository: IEmployeeRepository;
  EmployeeSubordinationService: IEmployeeSubordinationService;
  EmployeeSetReadService: IEmployeeSetReadService);
begin

  inherited Create(EmployeeSetReadService);

  FEmployeeRepository := EmployeeRepository;
  FEmployeeSubordinationService := EmployeeSubordinationService;

end;

function TStandardDocumentSignerSetReadService.
  FindAllBusinessLeadersForEmployee(
    Employee: TEmployee
  ): TEmployees;
begin

  Result :=
    FEmployeeSubordinationService.FindAllBusinessLeadersForEmployee(
      Employee
    )

end;

function TStandardDocumentSignerSetReadService.
  FindAllPossibleDocumentSignerSetForEmployee(
    const EmployeeId: Variant
  ): TEmployeeSetHolder;
var Employee: TEmployee;
    FreeEmployee: IDomainObject;

    EmployeeBusinessLeaders: TEmployees;
    FreeEmployees: IDomainObjectList;

    EmployeeIdList: TVariantList;
begin

  Employee := FEmployeeRepository.FindEmployeeById(EmployeeId);

  FreeEmployee := Employee;

  EmployeeBusinessLeaders :=
    FindAllBusinessLeadersForEmployee(Employee);

  FreeEmployees := EmployeeBusinessLeaders;

  EmployeeIdList := EmployeeBusinessLeaders.CreateDomainObjectIdentityList;

  try

    Result :=
      FEmployeeSetReadService.GetEmployeeSetByIds(EmployeeIdList);
      
  finally

    FreeAndNil(EmployeeIdList);
    
  end;
  
end;

end.
