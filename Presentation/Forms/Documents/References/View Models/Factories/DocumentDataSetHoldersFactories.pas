unit DocumentDataSetHoldersFactories;

interface

uses

  DocumentDataSetHoldersFactory,
  UIDocumentKinds,
  TypeObjectRegistry,
  SysUtils,
  Classes;

type

  IDocumentDataSetHoldersFactories = interface

    procedure SetDocumentDataSetHoldersFactory(
      const UIDocumentKind: TUIDocumentKindClass;
      DocumentDataSetHoldersFactory: IDocumentDataSetHoldersFactory
    );

    function GetDocumentDataSetHoldersFactory(
      const UIDocumentKind: TUIDocumentKindClass
    ): IDocumentDataSetHoldersFactory;
    
  end;
  
  TDocumentDataSetHoldersFactories = class (TInterfacedObject, IDocumentDataSetHoldersFactories)

    private

      class var FInstance: TDocumentDataSetHoldersFactories;

      class function GetInstance: TDocumentDataSetHoldersFactories; static;

    private

      FFactoryRegistry: TTypeObjectRegistry;

    public

      destructor Destroy; override;
      constructor Create;
      
      procedure SetDocumentDataSetHoldersFactory(
        const UIDocumentKind: TUIDocumentKindClass;
        DocumentDataSetHoldersFactory: IDocumentDataSetHoldersFactory
      );

      function GetDocumentDataSetHoldersFactory(
        const UIDocumentKind: TUIDocumentKindClass
      ): IDocumentDataSetHoldersFactory;

    public

      class property Instance: TDocumentDataSetHoldersFactories
      read GetInstance;
      
  end;

implementation

{ TDocumentDataSetHoldersFactories }

constructor TDocumentDataSetHoldersFactories.Create;
begin

  inherited;

  FFactoryRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;

  FFactoryRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  
end;

destructor TDocumentDataSetHoldersFactories.Destroy;
begin

  FreeAndNil(FFactoryRegistry);
  
  inherited;

end;

function TDocumentDataSetHoldersFactories.GetDocumentDataSetHoldersFactory(
  const UIDocumentKind: TUIDocumentKindClass): IDocumentDataSetHoldersFactory;
begin

  Result :=
    IDocumentDataSetHoldersFactory(
      FFactoryRegistry.GetInterface(UIDocumentKind)
    );

end;

procedure TDocumentDataSetHoldersFactories.SetDocumentDataSetHoldersFactory(
  const UIDocumentKind: TUIDocumentKindClass;
  DocumentDataSetHoldersFactory: IDocumentDataSetHoldersFactory);
begin

  FFactoryRegistry.RegisterInterface(UIDocumentKind, DocumentDataSetHoldersFactory);

end;

class function TDocumentDataSetHoldersFactories.GetInstance: TDocumentDataSetHoldersFactories;
begin

  if not Assigned(FInstance) then
    FInstance := TDocumentDataSetHoldersFactories.Create;

  Result := FInstance;

end;

end.
