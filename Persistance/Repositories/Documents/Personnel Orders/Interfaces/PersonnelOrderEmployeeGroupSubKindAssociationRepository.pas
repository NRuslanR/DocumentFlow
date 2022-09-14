unit PersonnelOrderEmployeeGroupSubKindAssociationRepository;

interface

uses

  DomainObjectUnit,
  DomainObjectListUnit,
  VariantListUnit,
  SysUtils;

type

  TPersonnelOrderEmployeeGroupSubKindAssociation = class (TDomainObject)

    protected

      FGroupId: Variant;
      FPersonnelOrderSubKindId: Variant;

      function GetGroupId: Variant;
      function GetPersonnelOrderSubKindId: Variant;
      
      procedure SetGroupId(const Value: Variant);
      procedure SetPersonnelOrderSubKindId(const Value: Variant);

    public

      constructor Create(
        GroupId: Variant;
        PersonnelOrderSubKindId: Variant
      );

    published

      property GroupId: Variant read GetGroupId write SetGroupId;
      property PersonnelOrderSubKindId: Variant read GetPersonnelOrderSubKindId write SetPersonnelOrderSubKindId;
       
  end;

  TPersonnelOrderEmployeeGroupSubKindAssociationClass = class of TPersonnelOrderEmployeeGroupSubKindAssociation;

  TPersonnelOrderEmployeeGroupSubKindAssociations = class;
  
  TPersonnelOrderEmployeeGroupSubKindAssociationsEnumerator = class (TDomainObjectListEnumerator)

    protected

      function GetCurrentPersonnelOrderEmployeeGroupSubKindAssociation: TPersonnelOrderEmployeeGroupSubKindAssociation;
    public

      constructor Create(PersonnelOrderEmployeeGroupSubKindAssociations: TPersonnelOrderEmployeeGroupSubKindAssociations);

      property Current: TPersonnelOrderEmployeeGroupSubKindAssociation
      read GetCurrentPersonnelOrderEmployeeGroupSubKindAssociation;

  end;
  
  TPersonnelOrderEmployeeGroupSubKindAssociations = class (TDomainObjectList)

    private

      function GetPersonnelOrderEmployeeGroupSubKindAssociationByIndex(
        Index: Integer
      ): TPersonnelOrderEmployeeGroupSubKindAssociation;

      procedure SetPersonnelOrderEmployeeGroupSubKindAssociationByIndex(
        Index: Integer;
        const Value: TPersonnelOrderEmployeeGroupSubKindAssociation
      );

    public

      function GetEnumerator: TPersonnelOrderEmployeeGroupSubKindAssociationsEnumerator;

      property Items[Index: Integer]: TPersonnelOrderEmployeeGroupSubKindAssociation
      read GetPersonnelOrderEmployeeGroupSubKindAssociationByIndex
      write SetPersonnelOrderEmployeeGroupSubKindAssociationByIndex; default;
    
  end;

  TPersonnelOrderEmployeeGroupSubKindAssociationsClass = class of TPersonnelOrderEmployeeGroupSubKindAssociations;

  IPersonnelOrderEmployeeGroupSubKindAssociationRepository = interface

    function FindPersonnelOrderEmployeeGroupSubKindAssociationsByGroup(
      const GroupId: Variant
    ): TPersonnelOrderEmployeeGroupSubKindAssociations;

    function FindPersonnelOrderEmployeeGroupSubKindAssociationsBySubKinds(
      const PersonnelOrderSubKindIds: array of Variant
    ): TPersonnelOrderEmployeeGroupSubKindAssociations; overload;

    function FindPersonnelOrderEmployeeGroupSubKindAssociationsBySubKinds(
      const PersonnelOrderSubKindIds: TVariantList
    ): TPersonnelOrderEmployeeGroupSubKindAssociations; overload;

    procedure AddPersonnelOrderEmployeeGroupSubKindAssociations(
      PersonnelOrderEmployeeGroupSubKindAssociations: TPersonnelOrderEmployeeGroupSubKindAssociations
    );

    procedure RemovePersonnelOrderEmployeeGroupSubKindAssociations(
      PersonnelOrderEmployeeGroupSubKindAssociations: TPersonnelOrderEmployeeGroupSubKindAssociations
    );

    procedure RemovePersonnelOrderEmployeeGroupSubKindAssociationsByGroup(
      const GroupId: Variant
    );

  end;
  
implementation

{ TPersonnelOrderEmployeeGroupSubKindAssociation }

constructor TPersonnelOrderEmployeeGroupSubKindAssociation.Create(
  GroupId, PersonnelOrderSubKindId: Variant
);
begin

  inherited Create;

  Self.GroupId := GroupId;
  Self.PersonnelOrderSubKindId := PersonnelOrderSubKindId;
  
end;

function TPersonnelOrderEmployeeGroupSubKindAssociation.GetGroupId: Variant;
begin

  Result := FGroupId;
  
end;

function TPersonnelOrderEmployeeGroupSubKindAssociation.GetPersonnelOrderSubKindId: Variant;
begin

  Result := FPersonnelOrderSubKindId;
  
end;

procedure TPersonnelOrderEmployeeGroupSubKindAssociation.SetGroupId(
  const Value: Variant);
begin

  FGroupId := Value;
  
end;

procedure TPersonnelOrderEmployeeGroupSubKindAssociation.SetPersonnelOrderSubKindId(
  const Value: Variant);
begin

  FPersonnelOrderSubKindId := Value;

end;

{ TPersonnelOrderEmployeeGroupSubKindAssociations }

function TPersonnelOrderEmployeeGroupSubKindAssociations.GetEnumerator: TPersonnelOrderEmployeeGroupSubKindAssociationsEnumerator;
begin

  Result := TPersonnelOrderEmployeeGroupSubKindAssociationsEnumerator.Create(Self);

end;

function TPersonnelOrderEmployeeGroupSubKindAssociations.GetPersonnelOrderEmployeeGroupSubKindAssociationByIndex(
  Index: Integer): TPersonnelOrderEmployeeGroupSubKindAssociation;
begin

  Result := TPersonnelOrderEmployeeGroupSubKindAssociation(GetDomainObjectByIndex(Index));

end;

procedure TPersonnelOrderEmployeeGroupSubKindAssociations.SetPersonnelOrderEmployeeGroupSubKindAssociationByIndex(
  Index: Integer; const Value: TPersonnelOrderEmployeeGroupSubKindAssociation);
begin

  SetDomainObjectByIndex(Index, Value);
  
end;

{ TPersonnelOrderEmployeeGroupSubKindAssociationsEnumerator }

constructor TPersonnelOrderEmployeeGroupSubKindAssociationsEnumerator.Create(
  PersonnelOrderEmployeeGroupSubKindAssociations: TPersonnelOrderEmployeeGroupSubKindAssociations);
begin

  inherited Create(PersonnelOrderEmployeeGroupSubKindAssociations);

end;

function TPersonnelOrderEmployeeGroupSubKindAssociationsEnumerator.GetCurrentPersonnelOrderEmployeeGroupSubKindAssociation: TPersonnelOrderEmployeeGroupSubKindAssociation;
begin

  Result := TPersonnelOrderEmployeeGroupSubKindAssociation(GetCurrentDomainObject);
  
end;

end.
