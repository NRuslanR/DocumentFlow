unit PersonnelOrderControlGroupsControlService;

interface

uses

  ApplicationService,
  Controls,
  SysUtils;

type

  IPersonnelOrderControlGroupsControlService = interface

    function CreatePersonnelOrderControlGroupsControlService(
      const ClientId: Variant
    ): TControl;
    
  end;

implementation

end.
