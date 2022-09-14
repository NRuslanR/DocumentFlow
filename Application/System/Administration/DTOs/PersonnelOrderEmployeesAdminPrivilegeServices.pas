unit PersonnelOrderEmployeesAdminPrivilegeServices;

interface

uses

  DocumentFlowAdminPrivilegeServices,
  PersonnelOrderEmployeesControlService;

type

  TPersonnelOrderEmployeesAdminPrivilegeServices =
    class (TDocumentFlowAdminPrivilegeServices)

      public

        PersonnelOrderEmployeesControlService: IPersonnelOrderEmployeesControlService;

        constructor Create(
        const PrivilegeId: Variant;
        const WorkingPrivilegeId: Variant;
        PersonnelOrderEmployeesControlService: IPersonnelOrderEmployeesControlService
      );


    end;

implementation

{ TPersonnelOrderEmployeesAdminPrivilegeServices }

constructor TPersonnelOrderEmployeesAdminPrivilegeServices.Create(
  const PrivilegeId, WorkingPrivilegeId: Variant;
  PersonnelOrderEmployeesControlService: IPersonnelOrderEmployeesControlService);
begin

  inherited Create(PrivilegeId, WorkingPrivilegeId);

  Self.PersonnelOrderEmployeesControlService := PersonnelOrderEmployeesControlService;
  
end;

end.
