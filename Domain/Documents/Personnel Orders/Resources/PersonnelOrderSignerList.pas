unit PersonnelOrderSignerList;

interface

uses

  PersonnelOrderEmployeeList,
  DomainObjectUnit,
  VariantListUnit,
  Employee,
  SysUtils;

type

  TPersonnelOrderSignerListException = class (TPersonnelOrderEmployeeListException)

  end;

  TPersonnelOrderSignerList = class (TPersonnelOrderEmployeeList)

    protected

      FDefaultSignerId: Variant;

      procedure SetDefaultSignerId(const Value: Variant);
      
    protected

      procedure RaiseEmployeeAlreadyExistsException; override;

    public

      constructor Create; overload; override;
      constructor Create(AIdentity: Variant); overload; override;
      
      function IsEmployeeDefaultSigner(const Employee: TEmployee): Boolean; overload;
      function IsEmployeeDefaultSigner(const EmployeeId: Variant): Boolean; overload;
      
      property DefaultSignerId: Variant
      read FDefaultSignerId write SetDefaultSignerId;
      
    public

      class function ListType: TPersonnelOrderEmployeeListsClass; override;
      
  end;

  TPersonnelOrderSignerLists = class;
  
  TPersonnelOrderSignerListsEnumerator = class (TPersonnelOrderEmployeeListsEnumerator)

    protected

      function GetCurrentPersonnelOrderSignerList: TPersonnelOrderSignerList;

    public

      constructor Create(PersonnelOrderSignerLists: TPersonnelOrderSignerLists);

      property Current: TPersonnelOrderSignerList
      read GetCurrentPersonnelOrderSignerList;
      
  end;

  TPersonnelOrderSignerLists = class (TPersonnelOrderEmployeeLists)

    protected

      function GetPersonnelOrderSignerListByIndex(
        Index: Integer
      ): TPersonnelOrderSignerList;

      procedure SetPersonnelOrderSignerListByIndex(
        Index: Integer;
        const Value: TPersonnelOrderSignerList
      );

    public

      function First: TPersonnelOrderSignerList;
      function Last: TPersonnelOrderSignerList;

      procedure Add(SignerList: TPersonnelOrderSignerList);

      function Contains(SignerList: TPersonnelOrderSignerList): Boolean;

      procedure Remove(SignerList: TPersonnelOrderSignerList);
      procedure RemoveById(const Identity: Variant);

      function FindByIdentity(const Identity: Variant): TPersonnelOrderSignerList;
      function FindByIdentities(const Identities: TVariantList): TPersonnelOrderSignerLists; virtual;
      function GetEnumerator: TPersonnelOrderSignerListsEnumerator; virtual;

      property Items[Index: Integer]: TPersonnelOrderSignerList
      read GetPersonnelOrderSignerListByIndex
      write SetPersonnelOrderSignerListByIndex; default;
      
  end;

implementation

uses

  Variants;
  
{ TPersonnelOrderSignerListsEnumerator }

constructor TPersonnelOrderSignerListsEnumerator.Create(
  PersonnelOrderSignerLists: TPersonnelOrderSignerLists
);
begin

  inherited Create(PersonnelOrderSignerLists);
  
end;

function TPersonnelOrderSignerListsEnumerator.
  GetCurrentPersonnelOrderSignerList: TPersonnelOrderSignerList;
begin

  Result :=
    TPersonnelOrderSignerList(
      inherited GetCurrentPersonnelOrderEmployeeList
    );
  
end;

{ TPersonnelOrderSignerLists }

procedure TPersonnelOrderSignerLists.Add(
  SignerList: TPersonnelOrderSignerList);
begin

  inherited Add(SignerList);
  
end;

function TPersonnelOrderSignerLists.Contains(
  SignerList: TPersonnelOrderSignerList): Boolean;
begin

  Result := inherited Contains(SignerList);
  
end;

function TPersonnelOrderSignerLists.FindByIdentities(
  const Identities: TVariantList): TPersonnelOrderSignerLists;
begin

  Result := TPersonnelOrderSignerLists(inherited FindByIdentities(Identities));
  
end;

function TPersonnelOrderSignerLists.FindByIdentity(
  const Identity: Variant): TPersonnelOrderSignerList;
begin

  Result := TPersonnelOrderSignerList(inherited FindByIdentity(Identity));

end;

function TPersonnelOrderSignerLists.First: TPersonnelOrderSignerList;
begin

  Result := TPersonnelOrderSignerList(inherited First);
  
end;

function TPersonnelOrderSignerLists.GetEnumerator: TPersonnelOrderSignerListsEnumerator;
begin

  Result := TPersonnelOrderSignerListsEnumerator.Create(Self);

end;

function TPersonnelOrderSignerLists.GetPersonnelOrderSignerListByIndex(
  Index: Integer): TPersonnelOrderSignerList;
begin

  Result := TPersonnelOrderSignerList(GetPersonnelOrderEmployeeListByIndex(Index));

end;

function TPersonnelOrderSignerLists.Last: TPersonnelOrderSignerList;
begin

  Result := TPersonnelOrderSignerList(inherited Last);

end;

procedure TPersonnelOrderSignerLists.Remove(
  SignerList: TPersonnelOrderSignerList);
begin

  inherited Remove(SignerList);
  
end;

procedure TPersonnelOrderSignerLists.RemoveById(const Identity: Variant);
begin

  inherited RemoveById(Identity);
  
end;

procedure TPersonnelOrderSignerLists.SetPersonnelOrderSignerListByIndex(
  Index: Integer; const Value: TPersonnelOrderSignerList);
begin

  SetPersonnelOrderEmployeeListByIndex(Index, Value);
  
end;

{ TPersonnelOrderSignerList }

function TPersonnelOrderSignerList.IsEmployeeDefaultSigner(
  const Employee: TEmployee): Boolean;
begin

  Result := IsEmployeeDefaultSigner(Employee.Identity);
  
end;

constructor TPersonnelOrderSignerList.Create;
begin

  inherited;

  FDefaultSignerId := Null;
  
end;

constructor TPersonnelOrderSignerList.Create(AIdentity: Variant);
begin

  inherited;

  FDefaultSignerId := Null;
  
end;

function TPersonnelOrderSignerList.IsEmployeeDefaultSigner(
  const EmployeeId: Variant): Boolean;
begin

  Result := FDefaultSignerId = EmployeeId;
  
end;

class function TPersonnelOrderSignerList.ListType: TPersonnelOrderEmployeeListsClass;
begin

  Result := TPersonnelOrderSignerLists;
  
end;

procedure TPersonnelOrderSignerList.RaiseEmployeeAlreadyExistsException;
begin

  raise TPersonnelOrderSignerListException.Create(
    'Сотрудник уже был ранее добавлен в ' +
    'группу подписантов'
  );

end;

procedure TPersonnelOrderSignerList.SetDefaultSignerId(const Value: Variant);
begin

  if not Contains(Value) then begin

      Raise TPersonnelOrderSignerListException.Create(
        'Не найден сотрудник из списка подписантов ' +
        'кадровых приказов для назначения его ' +
        'подписантом по умолчанию'
      );
      
  end;

  FDefaultSignerId := Value;

end;

end.
