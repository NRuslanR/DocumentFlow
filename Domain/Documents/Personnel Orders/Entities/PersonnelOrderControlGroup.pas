unit PersonnelOrderControlGroup;

interface

uses

  DomainException,
  DomainObjectListUnit,
  PersonnelOrderEmployeeGroup,
  PersonnelOrderSubKindEmployeeGroup,
  DomainObjectUnit,
  Employee,
  VariantListUnit,
  SysUtils;

type

  TPersonnelOrderControlGroupException = class (TPersonnelOrderSubKindEmployeeGroupException)

  end;
  
  TPersonnelOrderControlGroup = class (TPersonnelOrderSubKindEmployeeGroup)

    protected

      procedure RaiseNotValidEmployeeGroupNameException(const NotValidName: String); override;

    public

      class function ListType: TPersonnelOrderEmployeeGroupsClass; override;
      
  end;

  TPersonnelOrderControlGroups = class;

  TPersonnelOrderControlGroupsEnumerator = class (TPersonnelOrderSubKindEmployeeGroupsEnumerator)

    private

      function GetCurrentPersonnelOrderControlGroup: TPersonnelOrderControlGroup;
      
    public

      constructor Create(PersonnelOrderControlGroups: TPersonnelOrderControlGroups);

      property Current: TPersonnelOrderControlGroup
      read GetCurrentPersonnelOrderControlGroup;
      
  end;
  
  TPersonnelOrderControlGroups = class (TPersonnelOrderSubKindEmployeeGroups)

    private

      function GetPersonnelOrderControlGroupByIndex(
        Index: Integer
      ): TPersonnelOrderControlGroup;

      procedure SetPersonnelOrderControlGroupByIndex(
        Index: Integer;
        const Value: TPersonnelOrderControlGroup
      );

    public

      function First: TPersonnelOrderControlGroup;
      function Last: TPersonnelOrderControlGroup;

      procedure Add(ControlGroup: TPersonnelOrderControlGroup);

      function Contains(ControlGroup: TPersonnelOrderControlGroup): Boolean;

      procedure Remove(ControlGroup: TPersonnelOrderControlGroup);
      procedure RemoveById(const Identity: Variant);

      function FindByIdentity(const Identity: Variant): TPersonnelOrderControlGroup;
      function FindByIdentities(const Identities: TVariantList): TPersonnelOrderControlGroups; virtual;
      function GetEnumerator: TPersonnelOrderControlGroupsEnumerator; virtual;

      property Items[Index: Integer]: TPersonnelOrderControlGroup
      read GetPersonnelOrderControlGroupByIndex
      write SetPersonnelOrderControlGroupByIndex; default;


  end;

implementation

{ TPersonnelOrderControlGroup }

class function TPersonnelOrderControlGroup.ListType: TPersonnelOrderEmployeeGroupsClass;
begin

  Result := TPersonnelOrderControlGroups;
  
end;

procedure TPersonnelOrderControlGroup.RaiseNotValidEmployeeGroupNameException(
  const NotValidName: String);
begin

  Raise TPersonnelOrderEmployeeGroupException.Create(
    'Наименование группы контроля кадровых приказов некорректно'
  );

end;

{ TPersonnelOrderControlGroupsEnumerator }

constructor TPersonnelOrderControlGroupsEnumerator.Create(
  PersonnelOrderControlGroups: TPersonnelOrderControlGroups);
begin

  inherited Create(PersonnelOrderControlGroups);
  
end;

function TPersonnelOrderControlGroupsEnumerator.
  GetCurrentPersonnelOrderControlGroup: TPersonnelOrderControlGroup;
begin

  Result := TPersonnelOrderControlGroup(GetCurrentPersonnelOrderSubKindEmployeeGroup);

end;

{ TPersonnelOrderControlGroups }

procedure TPersonnelOrderControlGroups.Add(
  ControlGroup: TPersonnelOrderControlGroup);
begin

  inherited Add(ControlGroup);

end;

function TPersonnelOrderControlGroups.Contains(
  ControlGroup: TPersonnelOrderControlGroup): Boolean;
begin

  Result := inherited Contains(ControlGroup);
  
end;

function TPersonnelOrderControlGroups.FindByIdentities(
  const Identities: TVariantList): TPersonnelOrderControlGroups;
begin

  Result := TPersonnelOrderControlGroups(inherited FindByIdentities(Identities));
  
end;

function TPersonnelOrderControlGroups.FindByIdentity(
  const Identity: Variant): TPersonnelOrderControlGroup;
begin

  Result := TPersonnelOrderControlGroup(inherited FindByIdentity(Identity));
  
end;

function TPersonnelOrderControlGroups.First: TPersonnelOrderControlGroup;
begin

  Result := TPersonnelOrderControlGroup(inherited First);
  
end;

function TPersonnelOrderControlGroups.GetEnumerator: TPersonnelOrderControlGroupsEnumerator;
begin

  Result := TPersonnelOrderControlGroupsEnumerator.Create(Self);

end;

function TPersonnelOrderControlGroups.GetPersonnelOrderControlGroupByIndex(
  Index: Integer): TPersonnelOrderControlGroup;
begin

  Result :=
    TPersonnelOrderControlGroup(
      GetPersonnelOrderSubKindEmployeeGroupByIndex(Index)
    );

end;

function TPersonnelOrderControlGroups.Last: TPersonnelOrderControlGroup;
begin

  Result := TPersonnelOrderControlGroup(inherited Last);
  
end;

procedure TPersonnelOrderControlGroups.Remove(
  ControlGroup: TPersonnelOrderControlGroup);
begin

  inherited Remove(ControlGroup);
  
end;

procedure TPersonnelOrderControlGroups.RemoveById(const Identity: Variant);
begin

  inherited RemoveById(Identity);
  
end;

procedure TPersonnelOrderControlGroups.SetPersonnelOrderControlGroupByIndex(
  Index: Integer; const Value: TPersonnelOrderControlGroup);
begin

  SetPersonnelOrderSubKindEmployeeGroupByIndex(Index, Value);
  
end;

end.
