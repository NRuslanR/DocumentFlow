unit PersonnelOrderEmployeeGroupRepository;

interface

uses

  PersonnelOrderEmployeeGroup,
  SysUtils;

type

  IPersonnelOrderEmployeeGroupRepository = interface

    function FindPersonnelOrderEmployeeGroupById(
      const Id: Variant
    ): TPersonnelOrderEmployeeGroup;

    function FindAllPersonnelOrderEmployeeGroups: TPersonnelOrderEmployeeGroups;

    procedure AddPersonnelOrderEmployeeGroup(
      EmployeeGroup: TPersonnelOrderEmployeeGroup
    );

    procedure AddPersonnelOrderEmployeeGroups(
      EmployeeGroups: TPersonnelOrderEmployeeGroups
    );

    procedure UpdatePersonnelOrderEmployeeGroup(
      EmployeeGroup: TPersonnelOrderEmployeeGroup
    );

    procedure UpdatePersonnelOrderEmployeeGroups(
      EmployeeGroups: TPersonnelOrderEmployeeGroups
    );

    procedure RemovePersonnelOrderEmployeeGroup(
      EmployeeGroup: TPersonnelOrderEmployeeGroup
    );

    procedure RemovePersonnelOrderEmployeeGroups(
      EmployeeGroups: TPersonnelOrderEmployeeGroups
    );

  end;

implementation

end.
