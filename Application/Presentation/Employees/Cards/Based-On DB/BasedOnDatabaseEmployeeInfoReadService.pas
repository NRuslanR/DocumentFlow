unit BasedOnDatabaseEmployeeInfoReadService;

interface

uses

  EmployeeInfoReadService,
  DocumentFlowEmployeeInfoDTO,
  DocumentFlowEmployeeInfoDTOMapper,
  AbstractApplicationService,
  Employee,
  EmployeeFinder,
  SysUtils;

type

  TBasedOnDatabaseEmployeeInfoReadService =
    class (TAbstractApplicationService, IEmployeeInfoReadService)

      private

        FEmployeeFinder: IEmployeeFinder;
        FEmployeeInfoDTOMapper: TDocumentFlowEmployeeInfoDTOMapper;
        
      public

        constructor Create(
          EmployeeFinder: IEmployeeFinder;
          EmployeeInfoDTOMapper: TDocumentFlowEmployeeInfoDTOMapper
        );

        function GetEmployeeInfo(const EmployeeId: Variant): TDocumentFlowEmployeeInfoDTO;

    end;

implementation

uses

  IDomainObjectBaseUnit;

{ TBasedOnDatabaseEmployeeInfoReadService }

constructor TBasedOnDatabaseEmployeeInfoReadService.Create(
  EmployeeFinder: IEmployeeFinder;
  EmployeeInfoDTOMapper: TDocumentFlowEmployeeInfoDTOMapper);
begin

  inherited Create;

  FEmployeeFinder := EmployeeFinder;
  FEmployeeInfoDTOMapper := EmployeeInfoDTOMapper;

end;

function TBasedOnDatabaseEmployeeInfoReadService.GetEmployeeInfo(
  const EmployeeId: Variant): TDocumentFlowEmployeeInfoDTO;
var
    Employee: TEmployee;
    Free: IDomainObjectBase;
begin

  Employee := FEmployeeFinder.FindEmployee(EmployeeId);

  Free := Employee;

  if Assigned(Employee) then
    Result := FEmployeeInfoDTOMapper.MapDocumentFlowEmployeeInfoDTOFrom(Employee)

  else Result := FEmployeeInfoDTOMapper.EmptyDocumentFlowEmployeeInfoDTO;

end;

end.
