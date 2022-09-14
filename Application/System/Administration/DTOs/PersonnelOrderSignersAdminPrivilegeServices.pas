unit PersonnelOrderSignersAdminPrivilegeServices;

interface

uses

  DocumentFlowAdminPrivilegeServices,
  PersonnelOrderSignersControlService,
  SysUtils;

type

  TPersonnelOrderSignersAdminPrivilegeServices =
    class (TDocumentFlowAdminPrivilegeServices)

      public

        PersonnelOrderSignersControlService: IPersonnelOrderSignersControlService;

        constructor Create(
          const PrivilegeId: Variant;
          const WorkingPrivilegeId: Variant;
          PersonnelOrderSignersControlService: IPersonnelOrderSignersControlService
        );


    end;

implementation

{ TPersonnelOrderSignersAdminPrivilegeServices }

constructor TPersonnelOrderSignersAdminPrivilegeServices.Create(
  const PrivilegeId, WorkingPrivilegeId: Variant;
  PersonnelOrderSignersControlService: IPersonnelOrderSignersControlService
);
begin

  inherited Create(PrivilegeId, WorkingPrivilegeId);

  Self.PersonnelOrderSignersControlService := PersonnelOrderSignersControlService;

end;

end.
