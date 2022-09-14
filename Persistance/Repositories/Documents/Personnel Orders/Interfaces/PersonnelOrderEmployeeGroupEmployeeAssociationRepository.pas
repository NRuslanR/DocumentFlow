unit PersonnelOrderEmployeeGroupEmployeeAssociationRepository;

interface

uses

  DomainObjectUnit,
  DomainObjectListUnit,
  ReflectionServicesUnit,
  SysUtils;

type

  TPersonnelOrderEmployeeGroupEmployeeAssociation = class (TDomainObject)

    protected

      FGroupId: Variant;
      FEmployeeId: Variant;
      
      function GetEmployeeId: Variant;
      function GetGroupId: Variant;

      procedure SetEmployeeId(const Value: Variant);
      procedure SetGroupId(const Value: Variant);

    public

      constructor Create(
        GroupId: Variant;
        EmployeeId: Variant
      );
      
    published

      property GroupId: Variant read GetGroupId write SetGroupId;
      property EmployeeId: Variant read GetEmployeeId write SetEmployeeId;
      
  end;

  TPersonnelOrderEmployeeGroupEmployeeAssociationClass = class of TPersonnelOrderEmployeeGroupEmployeeAssociation;

  TPersonnelOrderEmployeeGroupEmployeeAssociations = class;

  TPersonnelOrderEmployeeGroupEmployeeAssociationsEnumerator =
    class (TDomainObjectListEnumerator)

      protected

        function GetCurrentPersonnelOrderEmployeeGroupEmployeeAssociation:
          TPersonnelOrderEmployeeGroupEmployeeAssociation;

      public

        constructor Create(Associations: TPersonnelOrderEmployeeGroupEmployeeAssociations);
        
        property Current: TPersonnelOrderEmployeeGroupEmployeeAssociation
        read GetCurrentPersonnelOrderEmployeeGroupEmployeeAssociation;

    end;

  TPersonnelOrderEmployeeGroupEmployeeAssociations = class (TDomainObjectList)

    public

      function GetEnumerator: TPersonnelOrderEmployeeGroupEmployeeAssociationsEnumerator;
      
  end;

  TPersonnelOrderEmployeeGroupEmployeeAssociationsClass = class of TPersonnelOrderEmployeeGroupEmployeeAssociations;
  
  IPersonnelOrderEmployeeGroupEmployeeAssociationRepository = interface

    function FindPersonnelOrderEmployeeGroupEmployeeAssociationsByGroup(
      const GroupId: Variant
    ): TPersonnelOrderEmployeeGroupEmployeeAssociations;

    procedure AddPersonnelOrderEmployeeGroupEmployeeAssociations(
      PersonnelOrderEmployeeGroupEmployeeAssociations: TPersonnelOrderEmployeeGroupEmployeeAssociations
    );

    procedure RemovePersonnelOrderEmployeeGroupEmployeeAssociations(
      PersonnelOrderEmployeeGroupEmployeeAssociations: TPersonnelOrderEmployeeGroupEmployeeAssociations
    );

    procedure RemovePersonnelOrderEmployeeGroupEmployeeAssociationsByGroup(
      const GroupId: Variant
    );

  end;
  
implementation

{ TPersonnelOrderEmployeeGroupEmployeeAssociation }

constructor TPersonnelOrderEmployeeGroupEmployeeAssociation.Create(
  GroupId, EmployeeId: Variant
);
begin

  inherited Create;

  FGroupId := GroupId;
  FEmployeeId := EmployeeId;
  
end;

function TPersonnelOrderEmployeeGroupEmployeeAssociation.GetEmployeeId: Variant;
begin

  Result := FEmployeeId;

end;

function TPersonnelOrderEmployeeGroupEmployeeAssociation.GetGroupId: Variant;
begin

  Result := FGroupId;
  
end;

procedure TPersonnelOrderEmployeeGroupEmployeeAssociation.SetEmployeeId(
  const Value: Variant);
begin

  FEmployeeId := Value;
  
end;

procedure TPersonnelOrderEmployeeGroupEmployeeAssociation.SetGroupId(
  const Value: Variant);
begin

  FGroupId := Value;
  
end;

{ TPersonnelOrderEmployeeGroupEmployeeAssociationsEnumerator }

constructor TPersonnelOrderEmployeeGroupEmployeeAssociationsEnumerator.Create(
  Associations: TPersonnelOrderEmployeeGroupEmployeeAssociations);
begin

  inherited Create(Associations);

end;

function TPersonnelOrderEmployeeGroupEmployeeAssociationsEnumerator.
  GetCurrentPersonnelOrderEmployeeGroupEmployeeAssociation: TPersonnelOrderEmployeeGroupEmployeeAssociation;
begin

  Result := TPersonnelOrderEmployeeGroupEmployeeAssociation(GetCurrentDomainObject);
  
end;

{ TPersonnelOrderEmployeeGroupEmployeeAssociations }

function TPersonnelOrderEmployeeGroupEmployeeAssociations.
  GetEnumerator: TPersonnelOrderEmployeeGroupEmployeeAssociationsEnumerator;
begin

  Result := TPersonnelOrderEmployeeGroupEmployeeAssociationsEnumerator.Create(Self);
  
end;

end.
