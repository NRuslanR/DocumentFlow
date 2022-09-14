unit EmployeesWorkGroupRepository;

interface

uses

  EmployeesWorkGroup,
  VariantListUnit;

type

  IEmployeesWorkGroupRepository = interface

    function FindEmployeesWorkGroupByIdentity(const Identity: Variant): TEmployeesWorkGroup;
    function FindEmployeesWorkGroupsByIdentities(const Identities: TVariantList): TEmployeesWorkGroups;

  end;

implementation

end.
