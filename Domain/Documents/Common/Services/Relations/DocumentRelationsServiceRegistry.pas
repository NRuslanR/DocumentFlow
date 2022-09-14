unit DocumentRelationsServiceRegistry;

interface

uses

  DocumentRelationsFinder,
  Document,
  TypeObjectRegistry,
  SysUtils;

type

  TDocumentRelationsServiceRegistry = class

    private

      class var FInstance: TDocumentRelationsServiceRegistry;

      class function GetInstance: TDocumentRelationsServiceRegistry; static;

    private

      FInternalRegistry: TTypeObjectRegistry;

    public

      destructor Destroy; override;
      constructor Create;

    public

      procedure RegisterDocumentRelationsFinder(
        DocumentKind: TDocumentClass;
        DocumentRelationsFinder: IDocumentRelationsFinder
      );

      function GetDocumentRelationsFinder(
        DocumentKind: TDocumentClass
      ): IDocumentRelationsFinder;

    public

      class property Instance: TDocumentRelationsServiceRegistry
      read GetInstance;


  end;
  
implementation

{ TDocumentRelationsServiceRegistry }

constructor TDocumentRelationsServiceRegistry.Create;
begin

  inherited;

  FInternalRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  
end;

destructor TDocumentRelationsServiceRegistry.Destroy;
begin

  FreeAndNil(FInternalRegistry);
  
  inherited;

end;

function TDocumentRelationsServiceRegistry.
  GetDocumentRelationsFinder(
    DocumentKind: TDocumentClass
  ): IDocumentRelationsFinder;
begin

  Result :=
    IDocumentRelationsFinder(
      FInternalRegistry.GetInterface(DocumentKind)
    );

end;

class function TDocumentRelationsServiceRegistry.
  GetInstance: TDocumentRelationsServiceRegistry;
begin

  if not Assigned(FInstance) then
    FInstance := TDocumentRelationsServiceRegistry.Create;

  Result := FInstance;

end;

procedure TDocumentRelationsServiceRegistry.RegisterDocumentRelationsFinder(
  DocumentKind: TDocumentClass;
  DocumentRelationsFinder: IDocumentRelationsFinder
);
begin

  FInternalRegistry.RegisterInterface(
    DocumentKind,
    DocumentRelationsFinder
  );

end;

end.
