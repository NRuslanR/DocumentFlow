unit ResourceRequestsAccessService;

interface

uses

  SysUtils;

type           

  TRequestsInteractMode = (
    rimView,
    rimEdit
  );

  TResourceRequestsAccessDeniedException = class (Exception)
  
  end;

  TUnknownRequestInteractModeException = class (Exception)

  end;

  IResourceRequestsAccessService = interface

    function GetRequestsInteractMode(const EmployeeId: Variant): TRequestsInteractMode;

    procedure EnsureEmployeeHasResourceRequestsAccess(const EmployeeId: Variant);
    function HasEmployeeResourceRequestsAccess(const EmployeeId: Variant): Boolean;

  end;

implementation

end.
