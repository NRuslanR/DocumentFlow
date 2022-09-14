unit PersonnelOrderSubKindEmployeeGroupRepository;

interface

uses

  PersonnelOrderSubKindEmployeeGroup,
  PersonnelOrderEmployeeGroupRepository;

type

  IPersonnelOrderSubKindEmployeeGroupRepository = interface (IPersonnelOrderEmployeeGroupRepository)

    function FindPersonnelOrderSubKindEmployeeGroupById(
      const Id: Variant
    ): TPersonnelOrderSubKindEmployeeGroup;

    function FindAllPersonnelOrderSubKindEmployeeGroups: TPersonnelOrderSubKindEmployeeGroups;
    
    function FindPersonnelOrderSubKindEmployeeGroupBySubKind(
      const PersonnelOrderSubKindId: Variant
    ): TPersonnelOrderSubKindEmployeeGroup;

    procedure AddPersonnelOrderSubKindEmployeeGroup(
      SubKindEmployeeGroup: TPersonnelOrderSubKindEmployeeGroup
    );

    procedure AddPersonnelOrderSubKindEmployeeGroups(
      SubKindEmployeeGroups: TPersonnelOrderSubKindEmployeeGroups
    );

    procedure UpdatePersonnelOrderSubKindEmployeeGroup(
      SubKindEmployeeGroup: TPersonnelOrderSubKindEmployeeGroup
    );

    procedure UpdatePersonnelOrderSubKindEmployeeGroups(
      SubKindEmployeeGroups: TPersonnelOrderSubKindEmployeeGroups
    );

    procedure RemovePersonnelOrderSubKindEmployeeGroup(
      SubKindEmployeeGroup: TPersonnelOrderSubKindEmployeeGroup
    );

    procedure RemovePersonnelOrderSubKindEmployeeGroups(
      SubKindEmployeeGroups: TPersonnelOrderSubKindEmployeeGroups
    );

  end;
  
implementation

end.
