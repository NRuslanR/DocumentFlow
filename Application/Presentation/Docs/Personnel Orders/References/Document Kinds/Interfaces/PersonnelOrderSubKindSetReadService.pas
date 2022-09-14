unit PersonnelOrderSubKindSetReadService;

interface

uses

  PersonnelOrderSubKindSetHolder,
  ApplicationService,
  SysUtils;

type

  IPersonnelOrderSubKindSetReadService = interface (IApplicationService)

    function GetPersonnelOrderSubKindSet: TPersonnelOrderSubKindSetHolder;
        
  end;

implementation

end.
