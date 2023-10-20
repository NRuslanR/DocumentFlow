unit PostgresPersonnelOrderRepositoriesFactory;

interface

uses

  PostgresDocumentRepositoriesFactory,
  DocumentRepositoriesFactory,
  QueryExecutor,
  DocumentRepository,
  DocumentApprovingCycleResultRepository,
  DocumentApprovingRepository,
  DocumentChargeSheetRepository,
  DocumentChargeSheetPostgresRepository,
  DocumentFilesRepository,
  DocumentKindRepository,
  DocumentRelationsRepository,
  DocumentWorkCycleRepository,
  DocumentWorkCycleStagesRepository,
  IDocumentResponsibleRepositoryUnit,
  DocumentTableDefsFactory,
  IncomingDocumentRepository,
  PersonnelOrderTableDefsFactory,
  PersonnelOrder,
  PersonnelOrderPostgresRepository,
  DocumentApprovingPostgresRepository,
  PersonnelOrderSubKindEmployeeGroupRepository,
  PersonnelOrderSubKindEmployeeListRepository,
  PersonnelOrderSingleEmployeeListRepository,
  DocumentChargePostgresRepository,
  PersonnelOrderApproverList,
  PersonnelOrderSignerList,
  PersonnelOrderControlGroup,
  PersonnelOrderCreatingAccessEmployeeList,
  DocumentSigningPostgresRepository,
  PersonnelOrderSignerListPostgresRepository,
  PersonnelOrderRepositoriesFactory,
  PersonnelOrderSubKindRepository,
  PersonnelOrderSubKindPostgresRepository,
  SysUtils;

type

  TPostgresPersonnelOrderRepositoriesFactory =
    class (
      TPostgresDocumentRepositoriesFactory,
      IPersonnelOrderRepositoriesFactory,
      IDocumentRepositoriesFactory
    )

      protected

        function InternalCreateDocumentRepository(QueryExecutor: IQueryExecutor): IDocumentRepository; override;

      protected

        function TableDefsFactory: TPersonnelOrderTableDefsFactory;

      public

        constructor Create(TableDefsFactory: TPersonnelOrderTableDefsFactory);

        function CreatePersonnelOrderSubKindRepository(QueryExecutor: IQueryExecutor): IPersonnelOrderSubKindRepository;
        function CreatePersonnelOrderCreatingAccessEmployeeRepository(QueryExecutor: IQueryExecutor): IPersonnelOrderSingleEmployeeListRepository;
        function CreatePersonnelOrderSignerListRepository(QueryExecutor: IQueryExecutor): IPersonnelOrderSingleEmployeeListRepository;
        function CreatePersonnelOrderApproverListRepository(QueryExecutor: IQueryExecutor): IPersonnelOrderSubKindEmployeeListRepository;
        function CreatePersonnelOrderControlGroupRepository(QueryExecutor: IQueryExecutor): IPersonnelOrderSubKindEmployeeGroupRepository;

    end;
  
implementation

uses

  DocumentAcquaitance,
  PersonnelOrdersTableDef,
  PersonnelOrderSubKindEmployeeGroupPostgresRepository,
  PersonnelOrderEmployeeGroupSubKindAssociationRepository,
  PersonnelOrderEmployeeGroupSubKindAssociationPostgresRepository,
  PersonnelOrderEmployeeGroupEmployeeAssociationRepository,
  PersonnelOrderEmployeeGroupEmployeeAssociationPostgresRepository,
  PersonnelOrderSubKindEmployeeListPostgresRepository,
  PersonnelOrderSingleEmployeeListPostgresRepository;

{ TPostgresPersonnelOrderRepositoriesFactory }

constructor TPostgresPersonnelOrderRepositoriesFactory.Create(
  TableDefsFactory: TPersonnelOrderTableDefsFactory);
begin
  
  inherited Create(TableDefsFactory, TPersonnelOrder);
  
end;

function TPostgresPersonnelOrderRepositoriesFactory.InternalCreateDocumentRepository(
  QueryExecutor: IQueryExecutor): IDocumentRepository;
begin

  Result :=
    TPersonnelOrderPostgresRepository.Create(
      QueryExecutor,
      
      TPersonnelOrdersTableDef(
        TableDefsFactory.GetDocumentTableDef
      ),

      TableDefsFactory.GetDocumentTypeStageTableDef,

      TDocumentApprovingPostgresRepository.Create(
        QueryExecutor,
        TableDefsFactory.GetDocumentApprovingsTableDef,
        TableDefsFactory.GetDocumentApprovingResultsTableDef
      ),

      TDocumentSigningPostgresRepository.Create(
        QueryExecutor,
        TableDefsFactory.GetDocumentSigningTableDef
      ),

      TDocumentChargePostgresRepository(
        InternalCreateDocumentChargeRepository(QueryExecutor).Self
      ),

      TDocumentChargeSheetPostgresRepository(
        InternalCreateDocumentChargeSheetRepository(QueryExecutor).Self
      ),

      CreateDocumentWorkCycleRepository(QueryExecutor)
    );

end;

function TPostgresPersonnelOrderRepositoriesFactory.CreatePersonnelOrderApproverListRepository(
  QueryExecutor: IQueryExecutor): IPersonnelOrderSubKindEmployeeListRepository;
begin

  Result :=
    TPersonnelOrderSubKindEmployeeListPostgresRepository.Create(
      QueryExecutor,
      TableDefsFactory.CreatePersonnelOrderApproverListTableDef,
      TPersonnelOrderApproverList
    );
    
end;

function TPostgresPersonnelOrderRepositoriesFactory.CreatePersonnelOrderControlGroupRepository(
  QueryExecutor: IQueryExecutor): IPersonnelOrderSubKindEmployeeGroupRepository;
begin

  Result :=
    TPersonnelOrderSubKindEmployeeGroupPostgresRepository.Create(

      TPersonnelOrderEmployeeGroupSubKindAssociationPostgresRepository.Create(
        QueryExecutor,
        TableDefsFactory.CreatePersonnelOrderControlGroupSubKindAssociationTableDef,
        TPersonnelOrderEmployeeGroupSubKindAssociation,
        TPersonnelOrderEmployeeGroupSubKindAssociations
      ),

      TPersonnelOrderEmployeeGroupEmployeeAssociationPostgresRepository.Create(
        QueryExecutor,
        TableDefsFactory.CreatePersonnelOrderControlGroupEmployeeAssociationTableDef,
        TPersonnelOrderEmployeeGroupEmployeeAssociation,
        TPersonnelOrderEmployeeGroupEmployeeAssociations
      ),

      QueryExecutor,
      TableDefsFactory.CreatePersonnelOrderControlGroupTableDef,
      TPersonnelOrderControlGroup,
      TPersonnelOrderControlGroups
      
    );

end;

function TPostgresPersonnelOrderRepositoriesFactory.
  CreatePersonnelOrderCreatingAccessEmployeeRepository(
    QueryExecutor: IQueryExecutor
  ): IPersonnelOrderSingleEmployeeListRepository;
begin

  Result :=
    TPersonnelOrderSingleEmployeeListPostgresRepository.Create(
      QueryExecutor,
      TableDefsFactory.CreatePersonnelOrderCreatingAccessEmployeeTableDef,
      TPersonnelOrderCreatingAccessEmployeeList
    );

end;

function TPostgresPersonnelOrderRepositoriesFactory.CreatePersonnelOrderSignerListRepository(
  QueryExecutor: IQueryExecutor): IPersonnelOrderSingleEmployeeListRepository;
begin

  Result :=
    TPersonnelOrderSignerListPostgresRepository.Create(
      QueryExecutor,
      TableDefsFactory.CreatePersonnelOrderSignerListTableDef
    );

end;

function TPostgresPersonnelOrderRepositoriesFactory.CreatePersonnelOrderSubKindRepository(
  QueryExecutor: IQueryExecutor): IPersonnelOrderSubKindRepository;
begin

  Result :=
    TPersonnelOrderSubKindPostgresRepository.Create(
      QueryExecutor,
      TableDefsFactory.CreatePersonnelOrderSubKindTableDef
    );
    
end;

function TPostgresPersonnelOrderRepositoriesFactory.TableDefsFactory: TPersonnelOrderTableDefsFactory;
begin

  Result := TPersonnelOrderTableDefsFactory(FDocumentTableDefsFactory);

end;

end.
