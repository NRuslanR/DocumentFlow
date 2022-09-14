unit PersonnelOrderControlGroupsAdminPrivilegeServices;

interface

uses

  DocumentFlowAdminPrivilegeServices,
  PersonnelOrderControlGroupsControlService,
  SysUtils;

type

  TPersonnelOrderControlGroupsAdminPrivilegeServices =
    class (TDocumentFlowAdminPrivilegeServices)

      public

        PersonnelOrderControlGroupsControlService: IPersonnelOrderControlGroupsControlService;

      public

        constructor Create(
          const PrivilegeId: Variant;
          const WorkingPrivilegeId: Variant;
          PersonnelOrderControlGroupsControlService: IPersonnelOrderControlGroupsControlService
        );
      
    end;

implementation

{ TPersonnelOrderControlGroupsAdminPrivilegeServices }

constructor TPersonnelOrderControlGroupsAdminPrivilegeServices.Create(
  const PrivilegeId, WorkingPrivilegeId: Variant;
  PersonnelOrderControlGroupsControlService: IPersonnelOrderControlGroupsControlService
);
begin

  inherited Create(PrivilegeId, WorkingPrivilegeId);

  Self.PersonnelOrderControlGroupsControlService := PersonnelOrderControlGroupsControlService;

end;

end.
