unit PersonnelOrderSubKindEmployeeList;

interface

uses

  PersonnelOrderEmployeeList,
  VariantListUnit,
  SysUtils;

type

  TPersonnelOrderSubKindEmployeeListException = class (TPersonnelOrderEmployeeListException)

  end;

  TPersonnelOrderSubKindEmployeeList = class (TPersonnelOrderEmployeeList)

    protected

      FPersonnelOrderSubKindId: Variant;

      function GetPersonnelOrderSubKindId: Variant;
      procedure SetPersonnelOrderSubKindId(const Value: Variant);

      function GetIdentity: Variant; override;
      procedure SetIdentity(Identity: Variant); override;

    protected

      procedure RaiseEmployeeAlreadyExistsException; override;

    public

      class function ListType: TPersonnelOrderEmployeeListsClass; override;

    published

      property PersonnelOrderSubKindId: Variant
      read GetPersonnelOrderSubKindId write SetPersonnelOrderSubKindId;

  end;

  TPersonnelOrderSubKindEmployeeListClass = class of TPersonnelOrderSubKindEmployeeList;
  
  TPersonnelOrderSubKindEmployeeLists = class;

  TPersonnelOrderSubKindEmployeeListsEnumerator = class (TPersonnelOrderEmployeeListsEnumerator)

    protected

      function GetCurrentPersonnelOrderSubKindEmployeeList: TPersonnelOrderSubKindEmployeeList;

    public

      constructor Create(PersonnelOrderSubKindEmployeeLists: TPersonnelOrderSubKindEmployeeLists);

      property Current: TPersonnelOrderSubKindEmployeeList
      read GetCurrentPersonnelOrderSubKindEmployeeList;
      
  end;

  TPersonnelOrderSubKindEmployeeLists = class (TPersonnelOrderEmployeeLists)

    protected

      function GetPersonnelOrderSubKindEmployeeListByIndex(
        Index: Integer
      ): TPersonnelOrderSubKindEmployeeList;

      procedure SetPersonnelOrderSubKindEmployeeListByIndex(
        Index: Integer;
        const Value: TPersonnelOrderSubKindEmployeeList
      );

    public

      function First: TPersonnelOrderSubKindEmployeeList;
      function Last: TPersonnelOrderSubKindEmployeeList;

      procedure Add(EmployeeList: TPersonnelOrderSubKindEmployeeList);

      function Contains(EmployeeList: TPersonnelOrderSubKindEmployeeList): Boolean;

      procedure Remove(EmployeeList: TPersonnelOrderSubKindEmployeeList);
      procedure RemoveById(const Identity: Variant);

      function FindByIdentity(const Identity: Variant): TPersonnelOrderSubKindEmployeeList;
      function FindByIdentities(const Identities: TVariantList): TPersonnelOrderSubKindEmployeeLists; virtual;
      function GetEnumerator: TPersonnelOrderSubKindEmployeeListsEnumerator; virtual;

      property Items[Index: Integer]: TPersonnelOrderSubKindEmployeeList
      read GetPersonnelOrderSubKindEmployeeListByIndex
      write SetPersonnelOrderSubKindEmployeeListByIndex; default;
    
  end;
  
implementation

{ TPersonnelOrderSubKindEmployeeList }

function TPersonnelOrderSubKindEmployeeList.GetIdentity: Variant;
begin

  Result := PersonnelOrderSubKindId;
  
end;

function TPersonnelOrderSubKindEmployeeList.GetPersonnelOrderSubKindId: Variant;
begin

  Result := FPersonnelOrderSubKindId;
  
end;

class function TPersonnelOrderSubKindEmployeeList.ListType: TPersonnelOrderEmployeeListsClass;
begin

  Result := TPersonnelOrderSubKindEmployeeLists;
  
end;

procedure TPersonnelOrderSubKindEmployeeList.RaiseEmployeeAlreadyExistsException;
begin

  raise TPersonnelOrderSubKindEmployeeListException.Create(
    'Сотрудник уже был ранее добавлен в ' +
    'группу для данного подтипа кадрового пркиаза'
  );

end;

procedure TPersonnelOrderSubKindEmployeeList.SetIdentity(Identity: Variant);
begin

  PersonnelOrderSubKindId := Identity;

end;

procedure TPersonnelOrderSubKindEmployeeList.SetPersonnelOrderSubKindId(
  const Value: Variant);
begin

  FPersonnelOrderSubKindId := Value;
  
end;

{ TPersonnelOrderSubKindEmployeeListsEnumerator }

constructor TPersonnelOrderSubKindEmployeeListsEnumerator.Create(
  PersonnelOrderSubKindEmployeeLists: TPersonnelOrderSubKindEmployeeLists);
begin

  inherited Create(PersonnelOrderSubKindEmployeeLists);
  
end;

function TPersonnelOrderSubKindEmployeeListsEnumerator.
  GetCurrentPersonnelOrderSubKindEmployeeList: TPersonnelOrderSubKindEmployeeList;
begin

  Result := TPersonnelOrderSubKindEmployeeList(GetCurrentPersonnelOrderEmployeeList);

end;

{ TPersonnelOrderSubKindEmployeeLists }

procedure TPersonnelOrderSubKindEmployeeLists.Add(
  EmployeeList: TPersonnelOrderSubKindEmployeeList);
begin

  inherited Add(EmployeeList);
  
end;

function TPersonnelOrderSubKindEmployeeLists.Contains(
  EmployeeList: TPersonnelOrderSubKindEmployeeList): Boolean;
begin

  Result := inherited Contains(EmployeeList);
  
end;

function TPersonnelOrderSubKindEmployeeLists.FindByIdentities(
  const Identities: TVariantList): TPersonnelOrderSubKindEmployeeLists;
begin

  Result := TPersonnelOrderSubKindEmployeeLists(inherited FindByIdentities(Identities));

end;

function TPersonnelOrderSubKindEmployeeLists.FindByIdentity(
  const Identity: Variant): TPersonnelOrderSubKindEmployeeList;
begin

  Result := TPersonnelOrderSubKindEmployeeList(inherited FindByIdentity(Identity));

end;

function TPersonnelOrderSubKindEmployeeLists.First: TPersonnelOrderSubKindEmployeeList;
begin

  Result := TPersonnelOrderSubKindEmployeeList(inherited First);

end;

function TPersonnelOrderSubKindEmployeeLists.GetEnumerator: TPersonnelOrderSubKindEmployeeListsEnumerator;
begin

  Result := TPersonnelOrderSubKindEmployeeListsEnumerator.Create(Self);

end;

function TPersonnelOrderSubKindEmployeeLists.GetPersonnelOrderSubKindEmployeeListByIndex(
  Index: Integer): TPersonnelOrderSubKindEmployeeList;
begin

  Result := TPersonnelOrderSubKindEmployeeList(GetPersonnelOrderEmployeeListByIndex(Index));

end;

function TPersonnelOrderSubKindEmployeeLists.Last: TPersonnelOrderSubKindEmployeeList;
begin

  Result := TPersonnelOrderSubKindEmployeeList(inherited Last);

end;

procedure TPersonnelOrderSubKindEmployeeLists.Remove(
  EmployeeList: TPersonnelOrderSubKindEmployeeList);
begin

  inherited Remove(EmployeeList);

end;

procedure TPersonnelOrderSubKindEmployeeLists.RemoveById(
  const Identity: Variant);
begin

  inherited RemoveById(Identity);

end;

procedure TPersonnelOrderSubKindEmployeeLists.SetPersonnelOrderSubKindEmployeeListByIndex(
  Index: Integer; const Value: TPersonnelOrderSubKindEmployeeList);
begin

  SetPersonnelOrderEmployeeListByIndex(Index, Value);
  
end;

end.
