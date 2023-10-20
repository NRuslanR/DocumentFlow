unit PersonnelOrderRepositoriesFactory;

interface

uses

  DocumentRepositoriesFactory,
  QueryExecutor,
  PersonnelOrderSingleEmployeeListRepository,
  PersonnelOrderSubKindEmployeeListRepository,
  PersonnelOrderSubKindEmployeeGroupRepository,
  PersonnelOrderSubKindRepository,
  SysUtils;

type

  IPersonnelOrderRepositoriesFactory = interface (IDocumentRepositoriesFactory)

    function CreatePersonnelOrderCreatingAccessEmployeeRepository(QueryExecutor: IQueryExecutor): IPersonnelOrderSingleEmployeeListRepository;
    function CreatePersonnelOrderSignerListRepository(QueryExecutor: IQueryExecutor): IPersonnelOrderSingleEmployeeListRepository;
    function CreatePersonnelOrderApproverListRepository(QueryExecutor: IQueryExecutor): IPersonnelOrderSubKindEmployeeListRepository;
    function CreatePersonnelOrderControlGroupRepository(QueryExecutor: IQueryExecutor): IPersonnelOrderSubKindEmployeeGroupRepository;
    function CreatePersonnelOrderSubKindRepository(QueryExecutor: IQueryExecutor): IPersonnelOrderSubKindRepository;

  end;
  
implementation

end.
