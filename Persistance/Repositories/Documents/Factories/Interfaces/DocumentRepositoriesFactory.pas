unit DocumentRepositoriesFactory;

interface

uses

  QueryExecutor,
  DocumentRepository,
  DocumentApprovingCycleResultRepository,
  DocumentApprovingRepository,
  DocumentChargeSheetRepository,
  DocumentFilesRepository,
  DocumentKindRepository,
  DocumentRelationsRepository,
  DocumentWorkCycleRepository,
  DocumentWorkCycleStagesRepository,
  IDocumentResponsibleRepositoryUnit,
  DocumentChargeRepository,
  DocumentChargeKindRepository,
  IncomingDocumentRepository,
  SysUtils;

type

  IDocumentRepositoriesFactory = interface

    function CreateDocumentRepository(QueryExecutor: IQueryExecutor): IDocumentRepository;
    function CreateDocumentApprovingCycleResultRepository(QueryExecutor: IQueryExecutor): IDocumentApprovingCycleResultRepository;
    function CreateDocumentApprovingRepository(QueryExecutor: IQueryExecutor): IDocumentApprovingRepository;
    function CreateDocumentChargeSheetRepository(QueryExecutor: IQueryExecutor): IDocumentChargeSheetRepository;
    function CreateDocumentChargeRepository(QueryExecutor: IQueryExecutor): IDocumentChargeRepository;
    function CreateDocumentChargeKindRepository(QueryExecutor: IQueryExecutor): IDocumentChargeKindRepository;
    function CreateDocumentFilesRepository(QueryExecutor: IQueryExecutor): IDocumentFilesRepository;
    function CreateDocumentKindRepository(QueryExecutor: IQueryExecutor): IDocumentKindRepository;
    function CreateDocumentRelationsRepository(QueryExecutor: IQueryExecutor): IDocumentRelationsRepository;
    function CreateDocumentWorkCycleRepository(QueryExecutor: IQueryExecutor): IDocumentWorkCycleRepository;
    function CreateDocumentResponsibleRepository(QueryExecutor: IQueryExecutor): IDocumentResponsibleRepository;
    function CreateIncomingDocumentRepository(QueryExecutor: IQueryExecutor): IIncomingDocumentRepository;
    
  end;

implementation

end.
