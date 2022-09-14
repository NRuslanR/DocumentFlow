unit PersonnelOrderApproverList;

interface

uses

  DomainObjectUnit,
  DomainObjectListUnit,
  DomainException,
  VariantListUnit,
  PersonnelOrderEmployeeList,
  PersonnelOrderSubKindEmployeeList,
  Employee,
  SysUtils;

type

  TPersonnelOrderApproverListException = class (TPersonnelOrderSubKindEmployeeListException)


  end;
  
  TPersonnelOrderApproverList = class (TPersonnelOrderSubKindEmployeeList)

    protected

      procedure RaiseEmployeeAlreadyExistsException; override;

    public


      class function ListType: TPersonnelOrderEmployeeListsClass; override;

  end;

  TPersonnelOrderApproverLists = class;

  TPersonnelOrderApproverListsEnumerator = class (TPersonnelOrderSubKindEmployeeListsEnumerator)

    private

      function GetCurrentPersonnelOrderApproverList: TPersonnelOrderApproverList;

    public

      constructor Create(PersonnelOrderApproverLists: TPersonnelOrderApproverLists);

      property Current: TPersonnelOrderApproverList
      read GetCurrentPersonnelOrderApproverList;
      
  end;

  TPersonnelOrderApproverLists = class (TPersonnelOrderSubKindEmployeeLists)

    private

      function GetPersonnelOrderApproverListByIndex(
        Index: Integer
      ): TPersonnelOrderApproverList;

      procedure SetPersonnelOrderApproverListByIndex(
        Index: Integer;
        const Value: TPersonnelOrderApproverList
      );

    public

      function First: TPersonnelOrderApproverList;
      function Last: TPersonnelOrderApproverList;

      procedure Add(ApproverList: TPersonnelOrderApproverList);

      function Contains(ApproverList: TPersonnelOrderApproverList): Boolean;

      procedure Remove(ApproverList: TPersonnelOrderApproverList);
      procedure RemoveById(const Identity: Variant);

      function FindByIdentity(const Identity: Variant): TPersonnelOrderApproverList;
      function FindByIdentities(const Identities: TVariantList): TPersonnelOrderApproverLists; virtual;
      function GetEnumerator: TPersonnelOrderApproverListsEnumerator; virtual;

      property Items[Index: Integer]: TPersonnelOrderApproverList
      read GetPersonnelOrderApproverListByIndex
      write SetPersonnelOrderApproverListByIndex; default;
      
  end;
  
implementation

{ TPersonnelOrderApproverList }

class function TPersonnelOrderApproverList.ListType: TPersonnelOrderEmployeeListsClass;
begin

  Result := TPersonnelOrderApproverLists;
  
end;

procedure TPersonnelOrderApproverList.RaiseEmployeeAlreadyExistsException;
begin

  raise TPersonnelOrderApproverListException.Create(
    '—отрудник уже был ранее добавлен ' +
    'в группу согласовантов дл€ данного подтипа ' +
    'кадрового приказа'
  );
  
end;

{ TPersonnelOrderApproverListsEnumerator }

constructor TPersonnelOrderApproverListsEnumerator.Create(
  PersonnelOrderApproverLists: TPersonnelOrderApproverLists);
begin

  inherited Create(PersonnelOrderApproverLists);
  
end;

function TPersonnelOrderApproverListsEnumerator.
  GetCurrentPersonnelOrderApproverList: TPersonnelOrderApproverList;
begin

  Result :=
    TPersonnelOrderApproverList(GetCurrentPersonnelOrderSubKindEmployeeList);
    
end;

{ TPersonnelOrderApproverLists }

procedure TPersonnelOrderApproverLists.Add(ApproverList: TPersonnelOrderApproverList);
begin

  inherited Add(ApproverList);

end;

function TPersonnelOrderApproverLists.Contains(
  ApproverList: TPersonnelOrderApproverList): Boolean;
begin

  Result := inherited Contains(ApproverList);

end;

function TPersonnelOrderApproverLists.FindByIdentities(
  const Identities: TVariantList): TPersonnelOrderApproverLists;
begin

  Result := TPersonnelOrderApproverLists(inherited FindByIdentities(Identities));

end;

function TPersonnelOrderApproverLists.FindByIdentity(
  const Identity: Variant): TPersonnelOrderApproverList;
begin

  Result := TPersonnelOrderApproverList(inherited FindByIdentity(Identity));
  
end;

function TPersonnelOrderApproverLists.First: TPersonnelOrderApproverList;
begin

  Result := TPersonnelOrderApproverList(inherited First);

end;

function TPersonnelOrderApproverLists.GetEnumerator: TPersonnelOrderApproverListsEnumerator;
begin

  Result := TPersonnelOrderApproverListsEnumerator.Create(Self);
  
end;

function TPersonnelOrderApproverLists.GetPersonnelOrderApproverListByIndex(
  Index: Integer): TPersonnelOrderApproverList;
begin

  Result := TPersonnelOrderApproverList(GetPersonnelOrderSubKindEmployeeListByIndex(Index));
  
end;

function TPersonnelOrderApproverLists.Last: TPersonnelOrderApproverList;
begin

  Result := TPersonnelOrderApproverList(inherited Last);
  
end;

procedure TPersonnelOrderApproverLists.Remove(
  ApproverList: TPersonnelOrderApproverList);
begin

  inherited Remove(ApproverList);
  
end;

procedure TPersonnelOrderApproverLists.RemoveById(const Identity: Variant);
begin

  inherited RemoveById(Identity);
  
end;

procedure TPersonnelOrderApproverLists.SetPersonnelOrderApproverListByIndex(
  Index: Integer; const Value: TPersonnelOrderApproverList);
begin

  SetPersonnelOrderSubKindEmployeeListByIndex(Index, Value);
  
end;

end.
