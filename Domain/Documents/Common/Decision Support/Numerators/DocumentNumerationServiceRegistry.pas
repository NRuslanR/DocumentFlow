unit DocumentNumerationServiceRegistry;

interface

uses

  AbstractObjectRegistry,
  DocumentNumeratorRegistry,
  InMemoryObjectRegistry,
  SysUtils;

type

  TDocumentNumerationServiceRegistry = class

    private

      class var FInstance: TDocumentNumerationServiceRegistry;

      class function GetInstance: TDocumentNumerationServiceRegistry; static;

    private

      FInternalRegistry: TInMemoryObjectRegistry;

    public

      procedure RegisterDocumentNumeratorRegistry(
        DocumentNumeratorRegistry: IDocumentNumeratorRegistry
      );

      function GetDocumentNumeratorRegistry: IDocumentNumeratorRegistry;

    public

      destructor Destroy; override;
      constructor Create;

      class property Instance: TDocumentNumerationServiceRegistry
      read GetInstance;

  end;

implementation

{ TDocumentNumerationServiceRegistry }

constructor TDocumentNumerationServiceRegistry.Create;
begin

  inherited;

  FInternalRegistry := TInMemoryObjectRegistry.Create;

end;

destructor TDocumentNumerationServiceRegistry.Destroy;
begin

  FreeAndNil(FInternalRegistry);
  
  inherited;

end;

function TDocumentNumerationServiceRegistry.
  GetDocumentNumeratorRegistry: IDocumentNumeratorRegistry;
begin

  Result :=
    IDocumentNumeratorRegistry(
      FInternalRegistry.GetInterface(
        TObjectRegistryPointerKey.From(
          TypeInfo(IDocumentNumeratorRegistry)
        )
      )
    );
    
end;

class function TDocumentNumerationServiceRegistry.
  GetInstance: TDocumentNumerationServiceRegistry;
begin

  if not Assigned(FInstance) then
    FInstance := TDocumentNumerationServiceRegistry.Create;

  Result := FInstance;
  
end;

procedure TDocumentNumerationServiceRegistry.RegisterDocumentNumeratorRegistry(
  DocumentNumeratorRegistry: IDocumentNumeratorRegistry);
begin

  FInternalRegistry.RegisterInterface(
    TObjectRegistryPointerKey.From(
      TypeInfo(IDocumentNumeratorRegistry)
    ),
    DocumentNumeratorRegistry
  );

end;

end.
