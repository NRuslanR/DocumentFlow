unit DocumentKind;

interface

uses

  Document,
  DomainException,
  DomainObjectUnit,
  DomainObjectListUnit;

type

  TDocumentKind = class (TDomainObject)

    private

      FParentDocumentKindId: Variant;
      FName: String;
      FServiceName: String;
      FDescription: String;
      FClass: TDocumentClass;
      
      procedure SetDocumentClass(const Value: TDocumentClass);
      procedure SetName(const Value: String);
      procedure SetDescription(const Value: String);
      procedure SetParentDocumentKindId(const Value: Variant);
      procedure SetServiceName(const Value: String);

    public

      constructor Create; override;

      function Clone: TObject; override;
      
    published

      property Name: String
      read FName write SetName;

      property ServiceName: String
      read FServiceName write SetServiceName;
      
      property ParentDocumentKindId: Variant
      read FParentDocumentKindId write SetParentDocumentKindId;

      property Description: String
      read FDescription write SetDescription;

      property DocumentClass: TDocumentClass
      read FClass write SetDocumentClass;
      
  end;

  TDocumentKinds = class;
  
  TDocumentKindsEnumerator = class (TDomainObjectListEnumerator)

    private

      function GetCurrentDocumentKind: TDocumentKind;

    public

      constructor Create(DocumentKinds: TDocumentKinds);

      property Current: TDocumentKind
      read GetCurrentDocumentKind;
      
  end;

  TDocumentKinds = class (TDomainObjectList)

    private

      function GetDocumentKindByIndex(Index: Integer): TDocumentKind;
      procedure SetDocumentKindByIndex(Index: Integer;
        const Value: TDocumentKind);

    public

      function First: TDocumentKind;
      
      procedure Add(DocumentKind: TDocumentKind);

      function Contains(DocumentKind: TDocumentKind): Boolean;

      procedure Remove(DocumentKind: TDocumentKind);
      procedure RemoveByIdentity(const Identity: Variant);

      function FindByIdentity(const Identity: Variant): TDocumentKind;

      function FetchDocumentClasses: TDocumentClasses;
      
      function GetEnumerator: TDocumentKindsEnumerator; 

      property Items[Index: Integer]: TDocumentKind
      read GetDocumentKindByIndex
      write SetDocumentKindByIndex; default;
      
  end;

implementation

uses

  Variants;

{ TDocumentKind }

function TDocumentKind.Clone: TObject;
var
    ClonedDocumentKind: TDocumentKind;
begin

  Result := inherited Clone;

  ClonedDocumentKind := TDocumentKind(Result);

  ClonedDocumentKind.InvariantsComplianceRequested := False;

  ClonedDocumentKind.DocumentClass := DocumentClass;

  ClonedDocumentKind.InvariantsComplianceRequested := True;
  
end;

constructor TDocumentKind.Create;
begin

  inherited;

  FParentDocumentKindId := Null;
  
end;

procedure TDocumentKind.SetDescription(const Value: String);
begin

  if InvariantsComplianceRequested then begin

    raise TDomainException.Create(
      'Программная ошибка. ' +
      'Описание вида документов ' +
      'не может изменяться ' +
      'непосредственно'
    );
    
  end;

  FDescription := Value;

end;

procedure TDocumentKind.SetParentDocumentKindId(const Value: Variant);
begin

  if InvariantsComplianceRequested then begin

    raise TDomainException.Create(
      'Программная ошибка. ' +
      'Ссылка на родительский ' +
      'вид документов не может ' +
      'изменяться непосредственно'
    );
    
  end;

  FParentDocumentKindId := Value;

end;


procedure TDocumentKind.SetServiceName(const Value: String);
begin

  RaiseExceptionIfInvariantsComplianceRequested(
    TDomainException,
    'Программная ошибка. Служебное наименование ' +
    'типа документа не может устанавливаться ' +
    'непосредственно'
  );

  FServiceName := Value;

end;

procedure TDocumentKind.SetDocumentClass(const Value: TDocumentClass);
begin

  if InvariantsComplianceRequested then begin

    raise TDomainException.Create(
      'Программная ошибка. ' +
      'Класс документа не может ' +
      'быть изменен непосредственно'
    );
    
  end;

  FClass := Value;


end;

procedure TDocumentKind.SetName(const Value: String);
begin

  if InvariantsComplianceRequested then begin

    raise TDomainException.Create(
      'Программная ошибка. ' +
      'Наименование вида документов ' +
      'не может быть изменено ' +
      'непосредственно'
    );
    
  end;

  FName := Value;

end;

{ TDocumentKinds }

procedure TDocumentKinds.Add(DocumentKind: TDocumentKind);
begin

  AddDomainObject(DocumentKind);
  
end;

function TDocumentKinds.Contains(DocumentKind: TDocumentKind): Boolean;
begin

  Result := inherited Contains(DocumentKind);
  
end;

function TDocumentKinds.FetchDocumentClasses: TDocumentClasses;
var
    I: Integer;
begin

  SetLength(Result, Count);

  for I := 0 to Count - 1 do
    Result[I] := Self[I].DocumentClass;

end;

function TDocumentKinds.FindByIdentity(const Identity: Variant): TDocumentKind;
begin

  Result := TDocumentKind(inherited FindByIdentity(Identity));
  
end;

function TDocumentKinds.First: TDocumentKind;
begin

  Result := TDocumentKind(inherited First);
  
end;

function TDocumentKinds.GetDocumentKindByIndex(Index: Integer): TDocumentKind;
begin

  Result := TDocumentKind(GetDomainObjectByIndex(Index));
  
end;

function TDocumentKinds.GetEnumerator: TDocumentKindsEnumerator;
begin

  Result := TDocumentKindsEnumerator.Create(Self);
  
end;

procedure TDocumentKinds.Remove(DocumentKind: TDocumentKind);
begin

  DeleteDomainObject(DocumentKind);
  
end;

procedure TDocumentKinds.RemoveByIdentity(const Identity: Variant);
begin

  DeleteDomainObjectByIdentity(Identity);

end;

procedure TDocumentKinds.SetDocumentKindByIndex(Index: Integer;
  const Value: TDocumentKind);
begin

  SetDomainObjectByIndex(Index, Value);
  
end;

{ TDocumentKindsEnumerator }

constructor TDocumentKindsEnumerator.Create(DocumentKinds: TDocumentKinds);
begin

  inherited Create(DocumentKinds);
  
end;

function TDocumentKindsEnumerator.GetCurrentDocumentKind: TDocumentKind;
begin

  Result := TDocumentKind(GetCurrentDomainObject);
  
end;

end.
