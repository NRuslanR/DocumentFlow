unit PersonnelOrderEmployeeGroup;

interface

uses

  PersonnelOrderEmployeeList,
  VariantListUnit,
  Employee,
  DomainObjectUnit,
  DomainObjectListUnit,
  DomainException,
  SysUtils;

type

  TPersonnelOrderEmployeeGroups = class;
  TPersonnelOrderEmployeeGroupsClass = class of TPersonnelOrderEmployeeGroups;

  TPersonnelOrderEmployeeGroupException = class (TDomainException)

  end;
  
  TPersonnelOrderEmployeeGroup = class (TDomainObject)

    protected

      FName: String;
      FEmployeeList: TPersonnelOrderEmployeeList;

      function GetPersonnelOrderEmployeeListClass: TPersonnelOrderEmployeeListClass; virtual;

    protected

      function GetEmployeeIds: TVariantList;
      function GetName: String;

      procedure SetName(const Value: String);

    protected

      procedure RaiseNotValidEmployeeGroupNameException(const NotValidName: String); virtual;

    public

      destructor Destroy; override;
      
      constructor Create; overload; override;
      constructor Create(AIdentity: Variant); overload; override;

      procedure AddEmployee(const EmployeeId: Variant); overload;
      procedure AddEmployee(const Employee: TEmployee); overload;

      procedure RemoveEmployee(const EmployeeId: Variant); overload;
      procedure RemoveEmployee(const Employee: TEmployee); overload;

      function ContainsEmployee(const EmployeeId: Variant): Boolean; overload;
      function ContainsEmployee(const Employee: TEmployee): Boolean; overload;

      procedure Clear;

    public

      class function ListType: TPersonnelOrderEmployeeGroupsClass; virtual;

    published

      property Name: String read GetName write SetName;
      property EmployeeIds: TVariantList read GetEmployeeIds;
    
  end;

  TPersonnelOrderEmployeeGroupClass = class of TPersonnelOrderEmployeeGroup;
  
  TPersonnelOrderEmployeeGroupsEnumerator = class (TDomainObjectListEnumerator)

    protected

      function GetCurrentPersonnelOrderEmployeeGroup: TPersonnelOrderEmployeeGroup;

    public

      constructor Create(PersonnelOrderEmployeeGroups: TPersonnelOrderEmployeeGroups);

      property Current: TPersonnelOrderEmployeeGroup
      read GetCurrentPersonnelOrderEmployeeGroup;
      
  end;

  TPersonnelOrderEmployeeGroups = class (TDomainObjectList)

    protected

      function GetPersonnelOrderEmployeeGroupByIndex(
        Index: Integer
      ): TPersonnelOrderEmployeeGroup;

      procedure SetPersonnelOrderEmployeeGroupByIndex(
        Index: Integer;
        const Value: TPersonnelOrderEmployeeGroup
      );

    public

      function First: TPersonnelOrderEmployeeGroup;
      function Last: TPersonnelOrderEmployeeGroup;

      procedure Add(EmployeeGroup: TPersonnelOrderEmployeeGroup);

      function Contains(EmployeeGroup: TPersonnelOrderEmployeeGroup): Boolean;

      procedure Remove(EmployeeGroup: TPersonnelOrderEmployeeGroup);
      procedure RemoveById(const Identity: Variant);

      function FindByIdentity(const Identity: Variant): TPersonnelOrderEmployeeGroup;
      function FindByIdentities(const Identities: TVariantList): TPersonnelOrderEmployeeGroups; virtual;
      function GetEnumerator: TPersonnelOrderEmployeeGroupsEnumerator; virtual;

      property Items[Index: Integer]: TPersonnelOrderEmployeeGroup
      read GetPersonnelOrderEmployeeGroupByIndex
      write SetPersonnelOrderEmployeeGroupByIndex; default;

  end;

implementation

{ TPersonnelOrderEmployeeGroup }

procedure TPersonnelOrderEmployeeGroup.AddEmployee(const Employee: TEmployee);
begin

  FEmployeeList.AddEmployee(Employee);

end;

procedure TPersonnelOrderEmployeeGroup.AddEmployee(const EmployeeId: Variant);
begin

  FEmployeeList.AddEmployee(EmployeeId);

end;

procedure TPersonnelOrderEmployeeGroup.Clear;
begin

  FEmployeeList.Clear;

end;

function TPersonnelOrderEmployeeGroup.ContainsEmployee(
  const Employee: TEmployee): Boolean;
begin

  Result := FEmployeeList.Contains(Employee);

end;

function TPersonnelOrderEmployeeGroup.ContainsEmployee(
  const EmployeeId: Variant): Boolean;
begin

  Result := FEmployeeList.Contains(EmployeeId);

end;

constructor TPersonnelOrderEmployeeGroup.Create;
begin

  inherited Create;

  FEmployeeList := GetPersonnelOrderEmployeeListClass.Create;

end;

constructor TPersonnelOrderEmployeeGroup.Create(AIdentity: Variant);
begin

  inherited Create(AIdentity);

  FEmployeeList := GetPersonnelOrderEmployeeListClass.Create;
  
end;

destructor TPersonnelOrderEmployeeGroup.Destroy;
begin

  FreeAndNil(FEmployeeList);
  
  inherited;

end;

function TPersonnelOrderEmployeeGroup.GetEmployeeIds: TVariantList;
begin

  if Assigned(FEmployeeList) then
    Result := FEmployeeList.EmployeeIds

  else Result := nil;

end;

function TPersonnelOrderEmployeeGroup.GetName: String;
begin

  Result := FName;

end;

function TPersonnelOrderEmployeeGroup.GetPersonnelOrderEmployeeListClass: TPersonnelOrderEmployeeListClass;
begin

  Result := TPersonnelOrderEmployeeList;
  
end;

class function TPersonnelOrderEmployeeGroup.ListType: TPersonnelOrderEmployeeGroupsClass;
begin

  Result := TPersonnelOrderEmployeeGroups;
  
end;

procedure TPersonnelOrderEmployeeGroup.RemoveEmployee(
  const EmployeeId: Variant);
begin

  FEmployeeList.RemoveEmployee(EmployeeId);

end;

procedure TPersonnelOrderEmployeeGroup.RemoveEmployee(
  const Employee: TEmployee);
begin

  FEmployeeList.RemoveEmployee(Employee);

end;

procedure TPersonnelOrderEmployeeGroup.SetName(const Value: String);
begin

  if Trim(Value) = '' then
    RaiseNotValidEmployeeGroupNameException(Value);

  FName := Value;
  
end;

procedure TPersonnelOrderEmployeeGroup.RaiseNotValidEmployeeGroupNameException(
  const NotValidName: String);
begin

  Raise TPersonnelOrderEmployeeGroupException.Create(
    'Некорректное наименование группы'
  );

end;

{ TPersonnelOrderEmployeeGroupsEnumerator }

constructor TPersonnelOrderEmployeeGroupsEnumerator.Create(
  PersonnelOrderEmployeeGroups: TPersonnelOrderEmployeeGroups);
begin

  inherited Create(PersonnelOrderEmployeeGroups);

end;

function TPersonnelOrderEmployeeGroupsEnumerator.
  GetCurrentPersonnelOrderEmployeeGroup: TPersonnelOrderEmployeeGroup;
begin

  Result := TPersonnelOrderEmployeeGroup(GetCurrentDomainObject);
  
end;

{ TPersonnelOrderEmployeeGroups }

procedure TPersonnelOrderEmployeeGroups.Add(
  EmployeeGroup: TPersonnelOrderEmployeeGroup);
begin

  AddDomainObject(EmployeeGroup);

end;

function TPersonnelOrderEmployeeGroups.Contains(
  EmployeeGroup: TPersonnelOrderEmployeeGroup): Boolean;
begin

  Result := inherited Contains(EmployeeGroup);

end;

function TPersonnelOrderEmployeeGroups.FindByIdentities(
  const Identities: TVariantList): TPersonnelOrderEmployeeGroups;
begin

  Result := TPersonnelOrderEmployeeGroups(inherited FindByIdentities(Identities));

end;

function TPersonnelOrderEmployeeGroups.FindByIdentity(
  const Identity: Variant): TPersonnelOrderEmployeeGroup;
begin

  Result := TPersonnelOrderEmployeeGroup(inherited FindByIdentity(Identity));
  
end;

function TPersonnelOrderEmployeeGroups.First: TPersonnelOrderEmployeeGroup;
begin

  Result := TPersonnelOrderEmployeeGroup(inherited First);

end;

function TPersonnelOrderEmployeeGroups.GetEnumerator: TPersonnelOrderEmployeeGroupsEnumerator;
begin

  Result := TPersonnelOrderEmployeeGroupsEnumerator.Create(Self);
  
end;

function TPersonnelOrderEmployeeGroups.GetPersonnelOrderEmployeeGroupByIndex(
  Index: Integer): TPersonnelOrderEmployeeGroup;
begin

  Result := TPersonnelOrderEmployeeGroup(GetDomainObjectByIndex(Index));
  
end;

function TPersonnelOrderEmployeeGroups.Last: TPersonnelOrderEmployeeGroup;
begin

  Result := TPersonnelOrderEmployeeGroup(inherited Last);
  
end;

procedure TPersonnelOrderEmployeeGroups.Remove(
  EmployeeGroup: TPersonnelOrderEmployeeGroup);
begin

  DeleteDomainObject(EmployeeGroup);
  
end;

procedure TPersonnelOrderEmployeeGroups.RemoveById(const Identity: Variant);
begin

  DeleteDomainObjectByIdentity(Identity);
  
end;

procedure TPersonnelOrderEmployeeGroups.SetPersonnelOrderEmployeeGroupByIndex(
  Index: Integer; const Value: TPersonnelOrderEmployeeGroup);
begin

  SetDomainObjectByIndex(Index, Value);
  
end;

end.
