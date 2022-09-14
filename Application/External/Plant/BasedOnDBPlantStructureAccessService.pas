unit BasedOnDBPlantStructureAccessService;

interface

uses

  PlantStructureAccessService,
  QueryExecutor,
  SysUtils;

type

  TBasedOnDBPlantStructureAccessService =
    class (TInterfacedObject, IPlantStructureAccessService)

      private

        FQueryExecutor: IQueryExecutor;

      public

        constructor Create(QueryExecutor: IQueryExecutor);

        procedure EnsureEmployeeHasPlantStructureAccess(const EmployeeId: Variant);
        function HasEmployeePlantStructureAccess(const EmployeeId: Variant): Boolean;

    end;

  
implementation

{ TBasedOnDBPlantStructureAccessService }

constructor TBasedOnDBPlantStructureAccessService.Create(
  QueryExecutor: IQueryExecutor);
begin

  inherited Create;

  FQueryExecutor := QueryExecutor;

end;

procedure TBasedOnDBPlantStructureAccessService.EnsureEmployeeHasPlantStructureAccess(
  const EmployeeId: Variant);
begin

  if not HasEmployeePlantStructureAccess(EmployeeId) then begin

    Raise TPlantStructureAccessDeniedException.Create(
      'Сотрудник не имеет доступа к структуре предприятия'
    );
    
  end;

end;

function TBasedOnDBPlantStructureAccessService.HasEmployeePlantStructureAccess(
  const EmployeeId: Variant
): Boolean;
var
    QueryParams: TQueryParams;
begin

  QueryParams := TQueryParams.Create;

  try
  
    QueryParams.Add('pemployee_id', EmployeeId);
    
    Result :=
      
      FQueryExecutor.ExecuteSelectionQuery(
        'SELECT 1 FROM doc.plant_structure_access_employees WHERE employee_id = :pemployee_id',
        QueryParams
      ).RecordCount > 0;
      
  finally

    FreeAndNil(QueryParams);
    
  end;
  
end;

end.
