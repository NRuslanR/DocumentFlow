unit DocumentApprovingSheetViewModelMapperFactories;

interface

uses

  DocumentApprovingSheetViewModelMapperFactory,
  UIDocumentKinds,
  TypeObjectRegistry,
  SysUtils;

type

  TDocumentApprovingSheetViewModelMapperFactories = class

    private

      class var FFactoryRegistry: TTypeObjectRegistry;

      class procedure InitializeIfNecessary;
      
    public

      class procedure SetDocumentApprovingSheetViewModelMapperFactory(
        DocumentKind: TUIDocumentKindClass;
        Factory: TDocumentApprovingSheetViewModelMapperFactory
      );

      class function GetDocumentApprovingSheetViewModelMapperFactory(
        DocumentKind: TUIDocumentKindClass
      ): TDocumentApprovingSheetViewModelMapperFactory;

  end;
  
implementation

{ TDocumentApprovingSheetViewModelMapperFactories }

class procedure TDocumentApprovingSheetViewModelMapperFactories.InitializeIfNecessary;
begin

  if Assigned(FFactoryRegistry) then Exit;

  FFactoryRegistry :=
    TTypeObjectRegistry
      .CreateInMemoryTypeObjectRegistry(ltoFreeRegisteredObjectsOnDestroy);

  FFactoryRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  
end;

class function TDocumentApprovingSheetViewModelMapperFactories.
  GetDocumentApprovingSheetViewModelMapperFactory(
    DocumentKind: TUIDocumentKindClass
  ): TDocumentApprovingSheetViewModelMapperFactory;
begin

  InitializeIfNecessary;
  
  Result :=
    TDocumentApprovingSheetViewModelMapperFactory(
      FFactoryRegistry.GetObject(DocumentKind)
    );

end;

class procedure TDocumentApprovingSheetViewModelMapperFactories.
  SetDocumentApprovingSheetViewModelMapperFactory(
    DocumentKind: TUIDocumentKindClass;
    Factory: TDocumentApprovingSheetViewModelMapperFactory
  );
begin

  InitializeIfNecessary;

  FFactoryRegistry.RegisterObject(DocumentKind, Factory);

end;

end.
