unit PersonnelOrderRepositoryRegistryInitializer;

interface

uses

  AbstractDocumentRepositoriesFactoryRegistry,
  PersonnelOrderRepositoryRegistry,
  PersonnelOrderRepositoriesFactory,
  QueryExecutor,
  SysUtils;

type

  IPersonnelOrderRepositoryRegistryInitializer = interface

    procedure InitializePersonnelOrderRepositoryRegistry(
      PersonnelOrderRepositoryRegistry: IPersonnelOrderRepositoryRegistry
    );

  end;

  TPersonnelOrderRepositoryRegistryInitializer =
    class (TInterfacedObject, IPersonnelOrderRepositoryRegistryInitializer)

      private

        FPersonnelOrderRepositoriesFactory: IPersonnelOrderRepositoriesFactory;
        FQueryExecutor: IQueryExecutor;
         
      public

        constructor Create(
          PersonnelOrderRepositoriesFactory: IPersonnelOrderRepositoriesFactory;
          QueryExecutor: IQueryExecutor
        );
        
        procedure InitializePersonnelOrderRepositoryRegistry(
          PersonnelOrderRepositoryRegistry: IPersonnelOrderRepositoryRegistry
        );

    end;


implementation

{ TPersonnelOrderRepositoryRegistryInitializer }

constructor TPersonnelOrderRepositoryRegistryInitializer.Create(
  PersonnelOrderRepositoriesFactory: IPersonnelOrderRepositoriesFactory;
  QueryExecutor: IQueryExecutor
);
begin

  inherited Create;

  FPersonnelOrderRepositoriesFactory := PersonnelOrderRepositoriesFactory;
  FQueryExecutor := QueryExecutor;

end;

procedure TPersonnelOrderRepositoryRegistryInitializer.InitializePersonnelOrderRepositoryRegistry(
  PersonnelOrderRepositoryRegistry: IPersonnelOrderRepositoryRegistry);
begin

  PersonnelOrderRepositoryRegistry.RegisterPersonnelOrderSignerListRepository(

    FPersonnelOrderRepositoriesFactory
      .CreatePersonnelOrderSignerListRepository(FQueryExecutor)

  );

  PersonnelOrderRepositoryRegistry.RegisterPersonnelOrderApproverListRepository(

    FPersonnelOrderRepositoriesFactory
      .CreatePersonnelOrderApproverListRepository(FQueryExecutor)

  );

  PersonnelOrderRepositoryRegistry.RegisterPersonnelOrderControlGroupRepository(

    FPersonnelOrderRepositoriesFactory
      .CreatePersonnelOrderControlGroupRepository(FQueryExecutor)

  );

  PersonnelOrderRepositoryRegistry
    .RegisterPersonnelOrderCreatingAccessEmployeeRepository(

      FPersonnelOrderRepositoriesFactory
        .CreatePersonnelOrderCreatingAccessEmployeeRepository(FQueryExecutor)

    );

  PersonnelOrderRepositoryRegistry.RegisterPersonnelOrderSubKindRepository(
    FPersonnelOrderRepositoriesFactory.CreatePersonnelOrderSubKindRepository(
      FQueryExecutor
    )
  );

end;

end.
