unit PersonnelOrderSubKindEmployeeSetReadService;

interface

uses

  EmployeeSetHolder,
  ApplicationService,
  SysUtils;

type

  IPersonnelOrderSubKindEmployeeSetReadService = interface (IApplicationService)

    function GetEmployeeSetForPersonnelOrderSubKind(
      const PersonnelOrderSubKindId: Variant
    ): TEmployeeSetHolder;
    
  end;
  

implementation

end.
