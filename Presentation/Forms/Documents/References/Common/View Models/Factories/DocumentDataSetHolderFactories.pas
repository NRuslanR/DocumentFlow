unit DocumentDataSetHolderFactories;

interface

uses

  DocumentDataSetHoldersFactory,
  UIDocumentKinds,
  TypeObjectRegistry,
  SysUtils,
  Classes;

type

  IDocumentDataSetHolderFactories = interface

    procedure SetDocumentDataSetHolderFactory(
      const UIDocumentKind: TUIDocumentKindClass;
      DocumentDataSetHoldersFactory: IDocumentDataSetHoldersFactory
    );

    function GetDocumentDataSetHolderFactory(
      const UIDocumentKind: TUIDocumentKindClass
    ): IDocumentDataSetHoldersFactory;
    
  end;
  
  TDocumentDataSetHolderFactories = class (TInterfacedObject, IDocumentDataSetHolderFactories)

    private

      class var FInstance: TDocumentDataSetHolderFactories;

      class function GetInstance: TDocumentDataSetHolderFactories; static;

    private

      FFactoryRegistry: TTypeObjectRegistry;

    public

      destructor Destroy; override;
      constructor Create;
      
      procedure SetDocumentDataSetHolderFactory(
        const UIDocumentKind: TUIDocumentKindClass;
        DocumentDataSetHoldersFactory: IDocumentDataSetHoldersFactory
      );

      function GetDocumentDataSetHolderFactory(
        const UIDocumentKind: TUIDocumentKindClass
      ): IDocumentDataSetHoldersFactory;

    public

      class property Instance: TDocumentDataSetHolderFactories
      read GetInstance;
      
  end;

implementation

{ TDocumentDataSetHolderFactories }

constructor TDocumentDataSetHolderFactories.Create;
begin

  inherited;

  FFactoryRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;

  FFactoryRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  
end;

destructor TDocumentDataSetHolderFactories.Destroy;
begin

  FreeAndNil(FFactoryRegistry);
  
  inherited;

end;

function TDocumentDataSetHolderFactories.GetDocumentDataSetHolderFactory(
  const UIDocumentKind: TUIDocumentKindClass): IDocumentDataSetHoldersFactory;
begin

  Result :=
    IDocumentDataSetHoldersFactory(
      FFactoryRegistry.GetInterface(UIDocumentKind)
    );

end;

procedure TDocumentDataSetHolderFactories.SetDocumentDataSetHolderFactory(
  const UIDocumentKind: TUIDocumentKindClass;
  DocumentDataSetHoldersFactory: IDocumentDataSetHoldersFactory);
begin

  FFactoryRegistry.RegisterInterface(UIDocumentKind, DocumentDataSetHoldersFactory);

end;

class function TDocumentDataSetHolderFactories.GetInstance: TDocumentDataSetHolderFactories;
begin

  if not Assigned(FInstance) then
    FInstance := TDocumentDataSetHolderFactories.Create;

  Result := FInstance;

end;

end.
