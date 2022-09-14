unit PersonnelOrderSubKindEmployeeGroup;

interface

uses

  PersonnelOrderEmployeeGroup,
  PersonnelOrderSubKind,
  VariantListUnit,
  SysUtils;

type

  TPersonnelOrderSubKindEmployeeGroupException = class (TPersonnelOrderEmployeeGroupException)

  end;
  
  TPersonnelOrderSubKindEmployeeGroup = class (TPersonnelOrderEmployeeGroup)

    protected

      FPersonnelOrderSubKindIds: TVariantList;

    private

      function GetPersonnelOrderSubKindIds: TVariantList;

    public

      destructor Destroy; override;

      constructor Create; overload; override;
      constructor Create(AIdentity: Variant); overload; override;

      procedure AddPersonnelOrderSubKind(PersonnelOrderSubKind: TPersonnelOrderSubKind); overload;
      procedure AddPersonnelOrderSubKind(const SubKindId: Variant); overload;

      procedure RemovePersonnelOrderSubKind(PersonnelOrderSubKind: TPersonnelOrderSubKind); overload;
      procedure RemovePersonnelOrderSubKind(const SubKindId: Variant); overload;

      function ContainsPersonnelOrderSubKind(PersonnelOrderSubKind: TPersonnelOrderSubKind): Boolean; overload;
      function ContainsPersonnelOrderSubKind(const SubKindId: Variant): Boolean; overload;

    public

      class function ListType: TPersonnelOrderEmployeeGroupsClass; override;
      
    published

      property PersonnelOrderSubKindIds: TVariantList
      read GetPersonnelOrderSubKindIds;
  
  end;

  TPersonnelOrderSubKindEmployeeGroupClass = class of TPersonnelOrderSubKindEmployeeGroup;

  TPersonnelOrderSubKindEmployeeGroups = class;

  TPersonnelOrderSubKindEmployeeGroupsEnumerator = class (TPersonnelOrderEmployeeGroupsEnumerator)

    protected

      function GetCurrentPersonnelOrderSubKindEmployeeGroup: TPersonnelOrderSubKindEmployeeGroup;

    public

      constructor Create(PersonnelOrderSubKindEmployeeGroups: TPersonnelOrderSubKindEmployeeGroups);

      property Current: TPersonnelOrderSubKindEmployeeGroup
      read GetCurrentPersonnelOrderSubKindEmployeeGroup;
      
  end;

  TPersonnelOrderSubKindEmployeeGroups = class (TPersonnelOrderEmployeeGroups)

    protected

      function GetPersonnelOrderSubKindEmployeeGroupByIndex(
        Index: Integer
      ): TPersonnelOrderSubKindEmployeeGroup;

      procedure SetPersonnelOrderSubKindEmployeeGroupByIndex(
        Index: Integer;
        const Value: TPersonnelOrderSubKindEmployeeGroup
      );

    public

      function First: TPersonnelOrderSubKindEmployeeGroup;
      function Last: TPersonnelOrderSubKindEmployeeGroup;

      procedure Add(EmployeeGroup: TPersonnelOrderSubKindEmployeeGroup);

      function Contains(EmployeeGroup: TPersonnelOrderSubKindEmployeeGroup): Boolean;

      procedure Remove(EmployeeGroup: TPersonnelOrderSubKindEmployeeGroup);
      procedure RemoveById(const Identity: Variant);

      function FindByIdentity(const Identity: Variant): TPersonnelOrderSubKindEmployeeGroup;
      function FindByIdentities(const Identities: TVariantList): TPersonnelOrderSubKindEmployeeGroups; virtual;
      function GetEnumerator: TPersonnelOrderSubKindEmployeeGroupsEnumerator; virtual;

      property Items[Index: Integer]: TPersonnelOrderSubKindEmployeeGroup
      read GetPersonnelOrderSubKindEmployeeGroupByIndex
      write SetPersonnelOrderSubKindEmployeeGroupByIndex; default;

  end;

  TPersonnelOrderSubKindEmployeeGroupsClass = class of TPersonnelOrderSubKindEmployeeGroups;

implementation

{ TPersonnelOrderSubKindEmployeeGroup }

procedure TPersonnelOrderSubKindEmployeeGroup.AddPersonnelOrderSubKind(
  PersonnelOrderSubKind: TPersonnelOrderSubKind);
begin

  AddPersonnelOrderSubKind(PersonnelOrderSubKind.Identity);
  
end;

procedure TPersonnelOrderSubKindEmployeeGroup.AddPersonnelOrderSubKind(
  const SubKindId: Variant);
begin

  FPersonnelOrderSubKindIds.Add(SubKindId);
  
end;

function TPersonnelOrderSubKindEmployeeGroup.ContainsPersonnelOrderSubKind(
  const SubKindId: Variant): Boolean;
begin

  Result := FPersonnelOrderSubKindIds.Contains(SubKindId);
  
end;

function TPersonnelOrderSubKindEmployeeGroup.ContainsPersonnelOrderSubKind(
  PersonnelOrderSubKind: TPersonnelOrderSubKind): Boolean;
begin

  Result := ContainsPersonnelOrderSubKind(PersonnelOrderSubKind.Identity);
  
end;

constructor TPersonnelOrderSubKindEmployeeGroup.Create(AIdentity: Variant);
begin

  inherited Create(Identity);

  FPersonnelOrderSubKindIds := TVariantList.Create;

end;

constructor TPersonnelOrderSubKindEmployeeGroup.Create;
begin

  inherited Create;

  FPersonnelOrderSubKindIds := TVariantList.Create;
  
end;

destructor TPersonnelOrderSubKindEmployeeGroup.Destroy;
begin

  FreeAndNil(FPersonnelOrderSubKindIds);
  
  inherited;

end;

function TPersonnelOrderSubKindEmployeeGroup.GetPersonnelOrderSubKindIds: TVariantList;
begin

  Result := FPersonnelOrderSubKindIds;
  
end;


class function TPersonnelOrderSubKindEmployeeGroup.ListType: TPersonnelOrderEmployeeGroupsClass;
begin

  Result := TPersonnelOrderSubKindEmployeeGroups;
  
end;

procedure TPersonnelOrderSubKindEmployeeGroup.RemovePersonnelOrderSubKind(
  const SubKindId: Variant);
begin

  FPersonnelOrderSubKindIds.Remove(SubKindId);
  
end;

procedure TPersonnelOrderSubKindEmployeeGroup.RemovePersonnelOrderSubKind(
  PersonnelOrderSubKind: TPersonnelOrderSubKind);
begin

  FPersonnelOrderSubKindIds.Remove(PersonnelOrderSubKind.Identity);

end;

{ TPersonnelOrderSubKindEmployeeGroupsEnumerator }

constructor TPersonnelOrderSubKindEmployeeGroupsEnumerator.Create(
  PersonnelOrderSubKindEmployeeGroups: TPersonnelOrderSubKindEmployeeGroups);
begin

  inherited Create(PersonnelOrderSubKindEmployeeGroups);

end;

function TPersonnelOrderSubKindEmployeeGroupsEnumerator.
  GetCurrentPersonnelOrderSubKindEmployeeGroup: TPersonnelOrderSubKindEmployeeGroup;
begin

  Result := TPersonnelOrderSubKindEmployeeGroup(GetCurrentPersonnelOrderEmployeeGroup);

end;

{ TPersonnelOrderSubKindEmployeeGroups }

procedure TPersonnelOrderSubKindEmployeeGroups.Add(
  EmployeeGroup: TPersonnelOrderSubKindEmployeeGroup);
begin

  inherited Add(EmployeeGroup);
  
end;

function TPersonnelOrderSubKindEmployeeGroups.Contains(
  EmployeeGroup: TPersonnelOrderSubKindEmployeeGroup): Boolean;
begin

  Result := inherited Contains(EmployeeGroup);
  
end;

function TPersonnelOrderSubKindEmployeeGroups.FindByIdentities(
  const Identities: TVariantList): TPersonnelOrderSubKindEmployeeGroups;
begin

  Result := TPersonnelOrderSubKindEmployeeGroups(inherited FindByIdentities(Identities));
  
end;

function TPersonnelOrderSubKindEmployeeGroups.FindByIdentity(
  const Identity: Variant): TPersonnelOrderSubKindEmployeeGroup;
begin

  Result := TPersonnelOrderSubKindEmployeeGroup(inherited FindByIdentity(Identity));
  
end;

function TPersonnelOrderSubKindEmployeeGroups.First: TPersonnelOrderSubKindEmployeeGroup;
begin

  Result := TPersonnelOrderSubKindEmployeeGroup(inherited First);
  
end;

function TPersonnelOrderSubKindEmployeeGroups.GetEnumerator: TPersonnelOrderSubKindEmployeeGroupsEnumerator;
begin

  Result := TPersonnelOrderSubKindEmployeeGroupsEnumerator.Create(Self);

end;

function TPersonnelOrderSubKindEmployeeGroups.GetPersonnelOrderSubKindEmployeeGroupByIndex(
  Index: Integer): TPersonnelOrderSubKindEmployeeGroup;
begin

  Result := TPersonnelOrderSubKindEmployeeGroup(GetPersonnelOrderEmployeeGroupByIndex(Index));
  
end;

function TPersonnelOrderSubKindEmployeeGroups.Last: TPersonnelOrderSubKindEmployeeGroup;
begin

  Result := TPersonnelOrderSubKindEmployeeGroup(inherited Last);

end;

procedure TPersonnelOrderSubKindEmployeeGroups.Remove(
  EmployeeGroup: TPersonnelOrderSubKindEmployeeGroup);
begin

  inherited Remove(EmployeeGroup);

end;

procedure TPersonnelOrderSubKindEmployeeGroups.RemoveById(
  const Identity: Variant);
begin

  inherited RemoveById(Identity);
  
end;

procedure TPersonnelOrderSubKindEmployeeGroups.SetPersonnelOrderSubKindEmployeeGroupByIndex(
  Index: Integer; const Value: TPersonnelOrderSubKindEmployeeGroup);
begin

  SetPersonnelOrderEmployeeGroupByIndex(Index, Value);
  
end;

end.
