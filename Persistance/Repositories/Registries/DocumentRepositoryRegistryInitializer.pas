unit DocumentRepositoryRegistryInitializer;

interface

uses

  AbstractDocumentRepositoriesFactoryRegistry,
  DocumentRepositoriesFactory,
  QueryExecutor,
  DocumentRepositoryRegistry,
  IncomingDocument,
  Document,
  ServiceNote,
  PersonnelOrder,
  IncomingServiceNote,
  SysUtils;

type

  IDocumentRepositoryRegistryInitializer = interface

    procedure InitializeDocumentRepositoryRegistry(
      DocumentRepositoryRegistry: IDocumentRepositoryRegistry
    );

    procedure InitializeDocumentRepositoryRegistryForDocumentKinds(
      DocumentRepositoryRegistry: IDocumentRepositoryRegistry;
      const DocumentKinds: array of TDocumentClass
    );

  end;
  
  TDocumentRepositoryRegistryInitializer =
    class (TInterfacedObject, IDocumentRepositoryRegistryInitializer)

      private

        FAbstractDocumentRepositoriesFactoryRegistry: TAbstractDocumentRepositoriesFactoryRegistry;
        FQueryExecutor: IQueryExecutor;

        procedure InitializeDocumentRepositoryRegistryForDocumentKind(
          DocumentRepositoryRegistry: IDocumentRepositoryRegistry;
          const DocumentKind: TDocumentClass
        );

      public

        constructor Create(
          AbstractDocumentRepositoriesFactoryRegistry: TAbstractDocumentRepositoriesFactoryRegistry;
          QueryExecutor: IQueryExecutor
        );

        procedure InitializeDocumentRepositoryRegistry(
          DocumentRepositoryRegistry: IDocumentRepositoryRegistry
        );

        procedure InitializeDocumentRepositoryRegistryForDocumentKinds(
          DocumentRepositoryRegistry: IDocumentRepositoryRegistry;
          const DocumentKinds: array of TDocumentClass
        );
      
    end;

implementation

{ TDocumentRepositoryRegistryInitializer }

constructor TDocumentRepositoryRegistryInitializer.Create(
  AbstractDocumentRepositoriesFactoryRegistry: TAbstractDocumentRepositoriesFactoryRegistry;
  QueryExecutor: IQueryExecutor);
begin

  inherited Create;

  FAbstractDocumentRepositoriesFactoryRegistry := AbstractDocumentRepositoriesFactoryRegistry;
  FQueryExecutor := QueryExecutor;
  
end;

procedure TDocumentRepositoryRegistryInitializer.
  InitializeDocumentRepositoryRegistry(
    DocumentRepositoryRegistry: IDocumentRepositoryRegistry
  );
begin

  { refactor: get document kinds from DocumentKindsRepository }
  InitializeDocumentRepositoryRegistryForDocumentKinds(
    DocumentRepositoryRegistry,
    [
      TServiceNote,
      TPersonnelOrder
    ]
  );

end;

procedure TDocumentRepositoryRegistryInitializer.
  InitializeDocumentRepositoryRegistryForDocumentKind(
    DocumentRepositoryRegistry: IDocumentRepositoryRegistry;
    const DocumentKind: TDocumentClass
  );
var
    DocumentRepositoriesFactory: IDocumentRepositoriesFactory;

begin
  
  DocumentRepositoriesFactory :=
    FAbstractDocumentRepositoriesFactoryRegistry.GetDocumentRepositoriesFactory(
      DocumentKind
    );

  if not Assigned(DocumentRepositoriesFactory) then begin

    raise Exception.Create(
      'Программная ошибка. Во время инициализации реестра репозиториев ' +
      'для данного вида документов не найдена фабрика репозиториев'
    );

  end;


  DocumentRepositoryRegistry.RegisterDocumentFilesRepository(
    DocumentKind,
    DocumentRepositoriesFactory.CreateDocumentFilesRepository(FQueryExecutor)
  );

  DocumentRepositoryRegistry.RegisterDocumentRelationsRepository(
    DocumentKind,
    DocumentRepositoriesFactory.CreateDocumentRelationsRepository(FQueryExecutor)
  );

  DocumentRepositoryRegistry.RegisterDocumentWorkCycleRepository(
    DocumentKind,
    DocumentRepositoriesFactory.CreateDocumentWorkCycleRepository(FQueryExecutor)
  );
  
  DocumentRepositoryRegistry.RegisterDocumentRepository(
    DocumentKind,
    DocumentRepositoriesFactory.CreateDocumentRepository(FQueryExecutor)
  );

  DocumentRepositoryRegistry.RegisterDocumentApprovingCycleResultRepository(
    DocumentKind,
    DocumentRepositoriesFactory.CreateDocumentApprovingCycleResultRepository(
      FQueryExecutor
    )
  );

  DocumentRepositoryRegistry.RegisterDocumentChargeSheetRepository(
    DocumentKind,
    DocumentRepositoriesFactory.CreateDocumentChargeSheetRepository(
      FQueryExecutor
    )
  );

  DocumentRepositoryRegistry.RegisterDocumentApprovingRepository(
    DocumentKind,
    DocumentRepositoriesFactory.CreateDocumentApprovingRepository(
      FQueryExecutor
    )
  );

  if DocumentKind.IncomingDocumentType <> nil then begin

    DocumentRepositoryRegistry.RegisterDocumentWorkCycleRepository(
      DocumentKind.IncomingDocumentType,
      DocumentRepositoryRegistry.GetDocumentWorkCycleRepository(DocumentKind)
    );

    DocumentRepositoryRegistry.RegisterDocumentChargeSheetRepository(
      DocumentKind.IncomingDocumentType,
      DocumentRepositoryRegistry.GetDocumentChargeSheetRepository(DocumentKind)
    );
    
    DocumentRepositoryRegistry.RegisterIncomingDocumentRepository(
      TIncomingDocumentClass(DocumentKind.IncomingDocumentType),
      DocumentRepositoriesFactory.CreateIncomingDocumentRepository(
        FQueryExecutor
      )
    );

    DocumentRepositoryRegistry.RegisterDocumentFilesRepository(
      DocumentKind.IncomingDocumentType,
      DocumentRepositoryRegistry.GetDocumentFilesRepository(DocumentKind)
    );

    DocumentRepositoryRegistry.RegisterDocumentRelationsRepository(
      DocumentKind.IncomingDocumentType,
      DocumentRepositoryRegistry.GetDocumentRelationsRepository(DocumentKind)
    );

    DocumentRepositoryRegistry.RegisterDocumentApprovingCycleResultRepository(
      DocumentKind.IncomingDocumentType,
      DocumentRepositoryRegistry.GetDocumentApprovingCycleResultRepository(
        DocumentKind
      )
    );

    DocumentRepositoryRegistry.RegisterDocumentApprovingRepository(
      DocumentKind.IncomingDocumentType,
      DocumentRepositoryRegistry.GetDocumentApprovingRepository(DocumentKind)
    );

  end;

end;

procedure TDocumentRepositoryRegistryInitializer.
  InitializeDocumentRepositoryRegistryForDocumentKinds(
    DocumentRepositoryRegistry: IDocumentRepositoryRegistry;
    const DocumentKinds: array of TDocumentClass
  );
var
    DocumentKind: TDocumentClass;
    SomeDocumentRepositoriesFactory: IDocumentRepositoriesFactory;
begin

  SomeDocumentRepositoriesFactory :=
    FAbstractDocumentRepositoriesFactoryRegistry.GetDocumentRepositoriesFactory(
      DocumentKinds[0]
    );

  DocumentRepositoryRegistry.RegisterDocumentResponsibleRepository(
    SomeDocumentRepositoriesFactory.CreateDocumentResponsibleRepository(
      FQueryExecutor
    )
  );

  DocumentRepositoryRegistry.RegisterDocumentChargeKindRepository(
    SomeDocumentRepositoriesFactory.CreateDocumentChargeKindRepository(
      FQueryExecutor
    )
  );

  DocumentRepositoryRegistry.RegisterDocumentKindRepository(
    SomeDocumentRepositoriesFactory.CreateDocumentKindRepository(FQueryExecutor)
  );
  
  for DocumentKind in DocumentKinds do begin

    InitializeDocumentRepositoryRegistryForDocumentKind(
      DocumentRepositoryRegistry, DocumentKind
    );

  end;
  
end;

end.
