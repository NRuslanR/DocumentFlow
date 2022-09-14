unit PersonnelOrderSignerSetReadService;

interface

uses


  PersonnelOrderEmployeeSetReadService,
  EmployeeSetHolder,
  SysUtils;

type

  IPersonnelOrderSignerSetReadService = interface (IPersonnelOrderEmployeeSetReadService)

    function GetPersonnelOrderSignerSet: TEmployeeSetHolder;

  end;

implementation

end.
