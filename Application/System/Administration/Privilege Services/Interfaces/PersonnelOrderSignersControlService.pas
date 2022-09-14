unit PersonnelOrderSignersControlService;

interface

uses

  ApplicationService,
  Controls,
  SysUtils;

type

  IPersonnelOrderSignersControlService = interface (IApplicationService)

    function CreatePersonnelOrderSignersControl(const ClientId: Variant): TControl;
    
  end;

implementation

end.
