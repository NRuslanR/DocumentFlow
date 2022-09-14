unit PersonnelOrderEmployeeList;

interface

uses

  DomainObjectUnit,
  DomainObjectListUnit,
  DomainException,
  VariantListUnit,
  Employee,
  SysUtils;

type

  TPersonnelOrderEmployeeListException = class (TDomainException)

  end;

  TPersonnelOrderEmployeeLists = class;
  TPersonnelOrderEmployeeListsClass = class of TPersonnelOrderEmployeeLists;
  
  TPersonnelOrderEmployeeList = class (TDomainObject)

    protected

      FEmployeeIds: TVariantList;

    protected

      procedure RaiseEmployeeAlreadyExistsException; virtual;

    public

      destructor Destroy; override;
      
      constructor Create; overload; override;
      constructor Create(AIdentity: Variant); overload; override;

      procedure AddEmployee(const EmployeeId: Variant); overload;
      procedure AddEmployee(const Employee: TEmployee); overload;

      procedure RemoveEmployee(const EmployeeId: Variant); overload;
      procedure RemoveEmployee(const Employee: TEmployee); overload;

      function Contains(const EmployeeId: Variant): Boolean; overload;
      function Contains(const Employee: TEmployee): Boolean; overload;

      procedure Clear;

    public

      class function ListType: TPersonnelOrderEmployeeListsClass; virtual;
      
    published

      property EmployeeIds: TVariantList read FEmployeeIds;

  end;

  TPersonnelOrderEmployeeListClass = class of TPersonnelOrderEmployeeList;

  TPersonnelOrderEmployeeListsEnumerator = class (TDomainObjectListEnumerator)

    protected

      function GetCurrentPersonnelOrderEmployeeList: TPersonnelOrderEmployeeList;

    public

      constructor Create(PersonnelOrderEmployeeLists: TPersonnelOrderEmployeeLists);

      property Current: TPersonnelOrderEmployeeList
      read GetCurrentPersonnelOrderEmployeeList;
      
  end;

  TPersonnelOrderEmployeeLists = class (TDomainObjectList)

    protected

      function GetPersonnelOrderEmployeeListByIndex(
        Index: Integer
      ): TPersonnelOrderEmployeeList;

      procedure SetPersonnelOrderEmployeeListByIndex(
        Index: Integer;
        const Value: TPersonnelOrderEmployeeList
      );

    public

      function First: TPersonnelOrderEmployeeList;
      function Last: TPersonnelOrderEmployeeList;

      procedure Add(EmployeeList: TPersonnelOrderEmployeeList);

      function Contains(EmployeeList: TPersonnelOrderEmployeeList): Boolean;

      procedure Remove(EmployeeList: TPersonnelOrderEmployeeList);
      procedure RemoveById(const Identity: Variant);

      function FindByIdentity(const Identity: Variant): TPersonnelOrderEmployeeList;
      function FindByIdentities(const Identities: TVariantList): TPersonnelOrderEmployeeLists; virtual;
      function GetEnumerator: TPersonnelOrderEmployeeListsEnumerator; virtual;

      property Items[Index: Integer]: TPersonnelOrderEmployeeList
      read GetPersonnelOrderEmployeeListByIndex
      write SetPersonnelOrderEmployeeListByIndex; default;
      
  end;
  
implementation

{ TPersonnelOrderEmployeeList }

procedure TPersonnelOrderEmployeeList.AddEmployee(
  const Employee: TEmployee);
begin

  AddEmployee(Employee.Identity);
  
end;

procedure TPersonnelOrderEmployeeList.AddEmployee(
  const EmployeeId: Variant);
begin

  if Contains(EmployeeId) then
    RaiseEmployeeAlreadyExistsException;

  FEmployeeIds.Add(EmployeeId);
  
end;

procedure TPersonnelOrderEmployeeList.RaiseEmployeeAlreadyExistsException;
begin

  raise TPersonnelOrderEmployeeListException.Create(
    'Сотрудник уже был ранее добавлен в группу'
  );
    
end;

procedure TPersonnelOrderEmployeeList.Clear;
begin

  FEmployeeIds.Clear;
  
end;

function TPersonnelOrderEmployeeList.Contains(
  const Employee: TEmployee): Boolean;
begin

  Result := Contains(Employee.Identity);
  
end;

constructor TPersonnelOrderEmployeeList.Create;
begin

  inherited;

  FEmployeeIds := TVariantList.Create;
  
end;

constructor TPersonnelOrderEmployeeList.Create(AIdentity: Variant);
begin

  inherited Create(AIdentity);

  FEmployeeIds := TVariantList.Create;

end;

destructor TPersonnelOrderEmployeeList.Destroy;
begin

  FreeAndNil(FEmployeeIds);

  inherited;

end;

class function TPersonnelOrderEmployeeList.ListType: TPersonnelOrderEmployeeListsClass;
begin

  Result := TPersonnelOrderEmployeeLists;
  
end;

function TPersonnelOrderEmployeeList.Contains(
  const EmployeeId: Variant): Boolean;
begin

  Result := FEmployeeIds.Contains(EmployeeId);
  
end;

procedure TPersonnelOrderEmployeeList.RemoveEmployee(
  const Employee: TEmployee);
begin

  RemoveEmployee(Employee.Identity);

end;

procedure TPersonnelOrderEmployeeList.RemoveEmployee(
  const EmployeeId: Variant);
begin

  FEmployeeIds.Remove(EmployeeId);
  
end;

{ TPersonnelOrderEmployeeListsEnumerator }

constructor TPersonnelOrderEmployeeListsEnumerator.Create(
  PersonnelOrderEmployeeLists: TPersonnelOrderEmployeeLists);
begin

  inherited Create(PersonnelOrderEmployeeLists);
  
end;

function TPersonnelOrderEmployeeListsEnumerator.
  GetCurrentPersonnelOrderEmployeeList: TPersonnelOrderEmployeeList;
begin

  Result := TPersonnelOrderEmployeeList(GetCurrentDomainObject);
  
end;

{ TPersonnelOrderEmployeeLists }

procedure TPersonnelOrderEmployeeLists.Add(
  EmployeeList: TPersonnelOrderEmployeeList);
begin

  AddDomainObject(EmployeeList);
  
end;

function TPersonnelOrderEmployeeLists.Contains(
  EmployeeList: TPersonnelOrderEmployeeList): Boolean;
begin

  Result := inherited Contains(EmployeeList);
  
end;

function TPersonnelOrderEmployeeLists.FindByIdentities(
  const Identities: TVariantList): TPersonnelOrderEmployeeLists;
begin

  Result := TPersonnelOrderEmployeeLists(inherited FindByIdentities(Identities));
  
end;

function TPersonnelOrderEmployeeLists.FindByIdentity(
  const Identity: Variant): TPersonnelOrderEmployeeList;
begin

  Result := TPersonnelOrderEmployeeList(inherited FindByIdentity(Identity));

end;

function TPersonnelOrderEmployeeLists.First: TPersonnelOrderEmployeeList;
begin

  Result := TPersonnelOrderEmployeeList(inherited First);

end;

function TPersonnelOrderEmployeeLists.GetEnumerator: TPersonnelOrderEmployeeListsEnumerator;
begin

  Result := TPersonnelOrderEmployeeListsEnumerator.Create(Self);

end;

function TPersonnelOrderEmployeeLists.GetPersonnelOrderEmployeeListByIndex(
  Index: Integer): TPersonnelOrderEmployeeList;
begin

  Result := TPersonnelOrderEmployeeList(GetDomainObjectByIndex(Index));

end;

function TPersonnelOrderEmployeeLists.Last: TPersonnelOrderEmployeeList;
begin

  Result := TPersonnelOrderEmployeeList(inherited Last);

end;

procedure TPersonnelOrderEmployeeLists.Remove(
  EmployeeList: TPersonnelOrderEmployeeList);
begin

  DeleteDomainObject(EmployeeList);

end;

procedure TPersonnelOrderEmployeeLists.RemoveById(const Identity: Variant);
begin

  DeleteDomainObjectByIdentity(Identity);

end;

procedure TPersonnelOrderEmployeeLists.SetPersonnelOrderEmployeeListByIndex(
  Index: Integer; const Value: TPersonnelOrderEmployeeList);
begin

  SetDomainObjectByIndex(Index, Value);
  
end;

end.
