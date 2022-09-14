unit DocumentChargeKind;

interface

uses

  DomainObjectUnit,
  DomainObjectListUnit,
  DomainObjectValueUnit,
  DocumentCharges,
  AbstractObjectRegistry,
  DomainException,
  InMemoryObjectRegistry,
  VariantListUnit,
  SysUtils,
  Classes;

type

  TDocumentChargeKind = class (TDomainObject)

    private

      FName: String;
      FServiceName: String;
      FChargeClass: TDocumentChargeClass;

      procedure SetChargeClass(const Value: TDocumentChargeClass);
      procedure SetName(const Value: String);
      procedure SetServiceName(const Value: String);

    public

      property ChargeClass: TDocumentChargeClass read FChargeClass write SetChargeClass;
      
    published

      property Name: String read FName write SetName;
      property ServiceName: String read FServiceName write SetServiceName;

  end;

  TDocumentChargeKinds = class;
  TDocumentChargeKindsEnumerator = class (TDomainObjectListEnumerator)

    private

      function GetCurrentChargeKind: TDocumentChargeKind;
      
    public

      constructor Create(ChargeKinds: TDocumentChargeKinds);

      property Current: TDocumentChargeKind read GetCurrentChargeKind;

  end;

  TDocumentChargeKinds = class (TDomainObjectList)

    private

      function GetDocumentChargeKindByIndex(Index: Integer): TDocumentChargeKind;

      procedure SetDocumentChargeKindByIndex(
        Index: Integer;
        const Value: TDocumentChargeKind
      );
    
    public

      destructor Destroy; override;
      
      procedure Add(ChargeKind: TDocumentChargeKind);
      procedure Remove(ChargeKind: TDocumentChargeKind);

      function First: TDocumentChargeKind;
      
      function FindByIdentity(const Identity: Variant): TDocumentChargeKind;
      function FindByIdentities(const Identities: TVariantList): TDocumentChargeKinds;

      function GetEnumerator: TDocumentChargeKindsEnumerator;

      property Items[Index: Integer]: TDocumentChargeKind
      read GetDocumentChargeKindByIndex
      write SetDocumentChargeKindByIndex; default;

  end;

  TDocumentKindChargeKindAllowingsException = class (TDomainException)

  end;
  
  TDocumentKindChargeKindAllowings = class (TDomainObjectValue)

    private

      FAllowingRegistry: IObjectRegistry;
      
    public

      constructor Create;

      procedure AddDocumentKindChargeKindAllowing(
        const DocumentKindId: Variant;
        DocumentChargeKinds: TDocumentChargeKinds
      );

      procedure RemoveDocumentKindChargeKindAllowing(const DocumentKindId: Variant);
      
      function FindAllowedDocumentChargeKindsForDocument(const DocumentKindId: Variant): TDocumentChargeKinds;
      
  end;

implementation

uses

  IDomainObjectBaseListUnit;

type

  IDocumentChargeKindsHolder = interface

    function GetDocumentChargeKinds: TDocumentChargeKinds;
    procedure SetDocumentChargeKinds(Value: TDocumentChargeKinds);
    
    property DocumentChargeKinds: TDocumentChargeKinds
    read GetDocumentChargeKinds write SetDocumentChargeKinds;
    
  end;

  TDocumentChargeKindsHolder = class (TInterfacedObject, IDocumentChargeKindsHolder)

    private

      FDocumentChargeKinds: TDocumentChargeKinds;
      FFreeDocumentChargeKinds: IDomainObjectBaseList;

    public

      constructor Create(DocumentChargeKinds: TDocumentChargeKinds);

      function GetDocumentChargeKinds: TDocumentChargeKinds;
      procedure SetDocumentChargeKinds(Value: TDocumentChargeKinds);

      property DocumentChargeKinds: TDocumentChargeKinds
      read GetDocumentChargeKinds write SetDocumentChargeKinds;

  end;
  
{ TDocumentChargeKind }

procedure TDocumentChargeKind.SetChargeClass(const Value: TDocumentChargeClass);
begin

  FChargeClass := Value;

end;

procedure TDocumentChargeKind.SetName(const Value: String);
begin

  FName := Value;

end;

procedure TDocumentChargeKind.SetServiceName(const Value: String);
begin

  FServiceName := Value;
  
end;

{ TDocumentChargeKinds }

procedure TDocumentChargeKinds.Add(ChargeKind: TDocumentChargeKind);
begin

  AddDomainObject(ChargeKind);

end;

destructor TDocumentChargeKinds.Destroy;
begin

  inherited;

end;

function TDocumentChargeKinds.FindByIdentities(
  const Identities: TVariantList): TDocumentChargeKinds;
begin

  Result := TDocumentChargeKinds(inherited FindByIdentities(Identities));

end;

function TDocumentChargeKinds.FindByIdentity(
  const Identity: Variant): TDocumentChargeKind;
begin

  Result := TDocumentChargeKind(inherited FindByIdentity(Identity));

end;

function TDocumentChargeKinds.First: TDocumentChargeKind;
begin

  Result := TDocumentChargeKind(inherited First);
  
end;

function TDocumentChargeKinds.GetDocumentChargeKindByIndex(
  Index: Integer): TDocumentChargeKind;
begin

  Result := TDocumentChargeKind(GetDomainObjectByIndex(Index));

end;

function TDocumentChargeKinds.GetEnumerator: TDocumentChargeKindsEnumerator;
begin

  Result := TDocumentChargeKindsEnumerator.Create(Self);

end;

procedure TDocumentChargeKinds.Remove(ChargeKind: TDocumentChargeKind);
begin

end;

procedure TDocumentChargeKinds.SetDocumentChargeKindByIndex(Index: Integer;
  const Value: TDocumentChargeKind);
begin

  DeleteDomainObject(Value);
  
end;

{ TDocumentChargeKindsEnumerator }

constructor TDocumentChargeKindsEnumerator.Create(
  ChargeKinds: TDocumentChargeKinds);
begin

  inherited Create(ChargeKinds);

end;

function TDocumentChargeKindsEnumerator.GetCurrentChargeKind: TDocumentChargeKind;
begin

  Result := TDocumentChargeKind(inherited GetCurrentDomainObject);
  
end;

{ TDocumentKindChargeKindAllowings }

constructor TDocumentKindChargeKindAllowings.Create;
begin

  inherited;

  FAllowingRegistry := TInMemoryObjectRegistry.Create;

end;

procedure TDocumentKindChargeKindAllowings.AddDocumentKindChargeKindAllowing(
  const DocumentKindId: Variant; DocumentChargeKinds: TDocumentChargeKinds);
begin

  if not Assigned(DocumentChargeKinds) then begin

    Raise TDocumentKindChargeKindAllowingsException.Create(
      'DocumentChargeKinds not assigned for adding'
    );
    
  end;

  FAllowingRegistry.RegisterInterface(
    TObjectRegistryVariantKey.From(DocumentKindId),
    TDocumentChargeKindsHolder.Create(DocumentChargeKinds)
  );
  
end;

function TDocumentKindChargeKindAllowings.FindAllowedDocumentChargeKindsForDocument(
  const DocumentKindId: Variant): TDocumentChargeKinds;
var
    ChargeKindsHolder: IDocumentChargeKindsHolder;
begin

  ChargeKindsHolder :=
    IDocumentChargeKindsHolder(
      FAllowingRegistry.GetInterface(
        TObjectRegistryVariantKey.From(DocumentKindId)
      )
    );

  if Assigned(ChargeKindsHolder) then
    Result := ChargeKindsHolder.DocumentChargeKinds

  else Result := nil;
  
end;

procedure TDocumentKindChargeKindAllowings.RemoveDocumentKindChargeKindAllowing(
  const DocumentKindId: Variant);
begin

  FAllowingRegistry.UnregisterInterface(TObjectRegistryVariantKey.From(DocumentKindId));

end;

{ TDocumentChargeKindsHolder }

constructor TDocumentChargeKindsHolder.Create(
  DocumentChargeKinds: TDocumentChargeKinds);
begin

  inherited Create;

  Self.DocumentChargeKinds := DocumentChargeKinds;
  
end;

function TDocumentChargeKindsHolder.GetDocumentChargeKinds: TDocumentChargeKinds;
begin

  Result := FDocumentChargeKinds;

end;

procedure TDocumentChargeKindsHolder.SetDocumentChargeKinds(
  Value: TDocumentChargeKinds);
begin

  FDocumentChargeKinds := Value;
  FFreeDocumentChargeKinds := FDocumentChargeKinds;
  
end;

end.
