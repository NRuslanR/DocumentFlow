unit PersonnelOrderKindApproversControlService;

interface

uses

  ApplicationService,
  Controls,
  SysUtils;

type

  IPersonnelOrderKindApproversControlService = interface (IApplicationService)

    function CreatePersonnelOrderKindApproversControl(const ClientId: Variant): TControl;
    
  end;

implementation

end.
