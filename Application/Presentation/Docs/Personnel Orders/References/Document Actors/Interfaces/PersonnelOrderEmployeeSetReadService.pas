unit PersonnelOrderEmployeeSetReadService;

interface

uses

  ApplicationService,
  EmployeeSetHolder;

type

  IPersonnelOrderEmployeeSetReadService = interface (IApplicationService)

    function GetPersonnelOrderEmployeeSet: TEmployeeSetHolder;

  end;

implementation

end.
