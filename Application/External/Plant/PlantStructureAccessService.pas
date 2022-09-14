unit PlantStructureAccessService;

interface

uses

  SysUtils;
  
type

  TPlantStructureAccessDeniedException = class (Exception)
  
  end;

  IPlantStructureAccessService = interface

    procedure EnsureEmployeeHasPlantStructureAccess(const EmployeeId: Variant);
    function HasEmployeePlantStructureAccess(const EmployeeId: Variant): Boolean;

  end;

implementation

end.
