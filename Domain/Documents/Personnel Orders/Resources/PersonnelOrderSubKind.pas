unit PersonnelOrderSubKind;

interface

uses

  DomainException,
  DomainObjectUnit,
  DomainObjectListUnit,
  SysUtils;

type

  TPersonnelOrderSubKind = class (TDomainObject)

    private

      FName: String;
      
      function GetName: String;
      procedure SetName(const Value: String);

    published

      property Name: String read GetName write SetName;
      
  end;

  TPersonnelOrderSubKinds = class;

  TPersonnelOrderSubKindsEnumerator = class (TDomainObjectListEnumerator)

    private
    
      function GetCurrentPersonnelOrderSubKind: TPersonnelOrderSubKind;

    public

      constructor Create(PersonnelOrderSubKinds: TPersonnelOrderSubKinds);

      property Current: TPersonnelOrderSubKind
      read GetCurrentPersonnelOrderSubKind;
      
  end;
  
  TPersonnelOrderSubKinds = class (TDomainObjectList)

    private

      function GetPersonnelOrderSubKindByIndex(
        Index: Integer
      ): TPersonnelOrderSubKind;

      procedure SetPersonnelOrderSubKindByIndex(
        Index: Integer;
        const Value: TPersonnelOrderSubKind
      );

    public

      procedure Add(PersonnelOrderSubKind: TPersonnelOrderSubKind);

      function Contains(PersonnelOrderSubKind: TPersonnelOrderSubKind): Boolean;

      procedure RemoveById(const PersonnelOrderSubKindId: Variant);
      procedure Remove(PersonnelOrderSubKind: TPersonnelOrderSubKind);
      
      function FindByIdentity(const Identity: Variant): TPersonnelOrderSubKind;

      function GetEnumerator: TPersonnelOrderSubKindsEnumerator;

      property Items[Index: Integer]: TPersonnelOrderSubKind
      read GetPersonnelOrderSubKindByIndex
      write SetPersonnelOrderSubKindByIndex; default;

  end;
  
implementation

{ TPersonnelOrderSubKind }

function TPersonnelOrderSubKind.GetName: String;
begin

  Result := FName;
  
end;

procedure TPersonnelOrderSubKind.SetName(const Value: String);
begin

  if Trim(Value) = '' then begin

    raise TDomainException.Create(
      'Некорректное наименование подтипа кадрового приказа'
    );

  end;

  FName := Value;
  
end;

{ TPersonnelOrderSubKindsEnumerator }

constructor TPersonnelOrderSubKindsEnumerator.Create(
  PersonnelOrderSubKinds: TPersonnelOrderSubKinds);
begin

  inherited Create(PersonnelOrderSubKinds);

end;

function TPersonnelOrderSubKindsEnumerator.GetCurrentPersonnelOrderSubKind: TPersonnelOrderSubKind;
begin

  Result := TPersonnelOrderSubKind(GetCurrentDomainObject);

end;

{ TPersonnelOrderSubKinds }

procedure TPersonnelOrderSubKinds.Add(
  PersonnelOrderSubKind: TPersonnelOrderSubKind);
begin

  AddDomainObject(PersonnelOrderSubKind);

end;

function TPersonnelOrderSubKinds.Contains(
  PersonnelOrderSubKind: TPersonnelOrderSubKind): Boolean;
begin

  Result := inherited Contains(PersonnelOrderSubKind);
  
end;

function TPersonnelOrderSubKinds.FindByIdentity(
  const Identity: Variant): TPersonnelOrderSubKind;
begin

  Result := TPersonnelOrderSubKind(inherited FindByIdentity(Identity));
  
end;

function TPersonnelOrderSubKinds.GetEnumerator: TPersonnelOrderSubKindsEnumerator;
begin

  Result := TPersonnelOrderSubKindsEnumerator.Create(Self);
  
end;

function TPersonnelOrderSubKinds.GetPersonnelOrderSubKindByIndex(
  Index: Integer): TPersonnelOrderSubKind;
begin

  Result := TPersonnelOrderSubKind(GetDomainObjectByIndex(Index));

end;

procedure TPersonnelOrderSubKinds.Remove(
  PersonnelOrderSubKind: TPersonnelOrderSubKind);
begin

  DeleteDomainObject(PersonnelOrderSubKind);

end;

procedure TPersonnelOrderSubKinds.RemoveById(
  const PersonnelOrderSubKindId: Variant);
begin

  DeleteDomainObjectByIdentity(PersonnelOrderSubKindId);
  

end;

procedure TPersonnelOrderSubKinds.SetPersonnelOrderSubKindByIndex(
  Index: Integer; const Value: TPersonnelOrderSubKind);
begin

  SetDomainObjectByIndex(Index, Value);

end;

end.
