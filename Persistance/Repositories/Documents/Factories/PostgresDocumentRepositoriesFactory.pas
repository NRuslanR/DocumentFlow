unit PostgresDocumentRepositoriesFactory;

interface

uses

  AbstractDocumentRepositoriesFactory,
  DocumentRepositoriesFactory,
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
  DocumentChargeKindRepository,
  DocumentChargeKindPostgresRepository,
  DocumentChargeRepository,
  IDocumentResponsibleRepositoryUnit,
  IncomingDocumentRepository,
  SysUtils;

type

  TPostgresDocumentRepositoriesFactory = class (TAbstractDocumentRepositoriesFactory)

    protected
    
      function InternalCreateDocumentRepository(QueryExecutor: IQueryExecutor): IDocumentRepository; override;
      function InternalCreateDocumentApprovingCycleResultRepository(QueryExecutor: IQueryExecutor): IDocumentApprovingCycleResultRepository; override;
      function InternalCreateDocumentApprovingRepository(QueryExecutor: IQueryExecutor): IDocumentApprovingRepository; override;
      function InternalCreateDocumentChargeSheetRepository(QueryExecutor: IQueryExecutor): IDocumentChargeSheetRepository; override;
      function InternalCreateDocumentChargeRepository(QueryExecutor: IQueryExecutor): IDocumentChargeRepository; override;
      function InternalCreateDocumentChargeKindRepository(QueryExecutor: IQueryExecutor): IDocumentChargeKindRepository; override;
      function InternalCreateDocumentFilesRepository(QueryExecutor: IQueryExecutor): IDocumentFilesRepository; override;
      function InternalCreateDocumentKindRepository(QueryExecutor: IQueryExecutor): IDocumentKindRepository; override;
      function InternalCreateDocumentRelationsRepository(QueryExecutor: IQueryExecutor): IDocumentRelationsRepository; override;
      function InternalCreateDocumentWorkCycleRepository(QueryExecutor: IQueryExecutor): IDocumentWorkCycleRepository; override;
      function InternalCreateDocumentResponsibleRepository(QueryExecutor: IQueryExecutor): IDocumentResponsibleRepository; override;
      function InternalCreateIncomingDocumentRepository(QueryExecutor: IQueryExecutor): IIncomingDocumentRepository; override;

  end;

implementation

uses

  IncomingDocument,
  DocumentCharges,
  DocumentPerforming,
  DocumentApprovingCycleResultPostgresRepository,
  DocumentApprovingPostgresRepository,
  DocumentChargeSheetPostgresRepository,
  DocumentFilesPostgresRepository,
  DocumentKindPostgresRepository,
  DocumentRelationsPostgresRepository,
  DocumentWorkCycleStagesPostgresRepository,
  StandardDocumentWorkCycleRepository,
  DocumentResponsiblePostgresRepository,
  DocumentPostgresRepository,
  IncomingDocumentPostgresRepository,
  DocumentChargePostgresRepository,
  DocumentSigningPostgresRepository;

{ TPostgresDocumentRepositoriesFactory }

function TPostgresDocumentRepositoriesFactory.InternalCreateDocumentApprovingCycleResultRepository(
  QueryExecutor: IQueryExecutor): IDocumentApprovingCycleResultRepository;
begin

  Result :=
    TDocumentApprovingCycleResultPostgresRepository.Create(
      QueryExecutor,
      FDocumentTableDefsFactory.GetDocumentApprovingsTableDef,
      FDocumentTableDefsFactory.GetDocumentApprovingResultsTableDef
    );

end;

function TPostgresDocumentRepositoriesFactory.InternalCreateDocumentApprovingRepository(
  QueryExecutor: IQueryExecutor): IDocumentApprovingRepository;
begin

  Result :=
    TDocumentApprovingPostgresRepository.Create(
      QueryExecutor,
      FDocumentTableDefsFactory.GetDocumentApprovingsTableDef,
      FDocumentTableDefsFactory.GetDocumentApprovingResultsTableDef
    );
    
end;

function TPostgresDocumentRepositoriesFactory.InternalCreateDocumentChargeKindRepository(
  QueryExecutor: IQueryExecutor): IDocumentChargeKindRepository;
begin

  Result :=
    TDocumentChargeKindPostgresRepository.Create(
      QueryExecutor,
      FDocumentTableDefsFactory.GetDocumentChargeKindTableDef
    );
    
end;

function TPostgresDocumentRepositoriesFactory.InternalCreateDocumentChargeRepository(
  QueryExecutor: IQueryExecutor): IDocumentChargeRepository;
begin

  Result :=
    TDocumentChargePostgresRepository.Create(
      TDocumentChargeKindPostgresRepository(
        InternalCreateDocumentChargeKindRepository(QueryExecutor).Self
      ),
      QueryExecutor,
      FDocumentTableDefsFactory.GetDocumentChargeTableDef,
      FDocumentTableDefsFactory.GetDocumentChargeSheetTableDef
    );

end;

function TPostgresDocumentRepositoriesFactory.InternalCreateDocumentChargeSheetRepository(
  QueryExecutor: IQueryExecutor): IDocumentChargeSheetRepository;
begin

  Result :=
    TDocumentChargeSheetPostgresRepository.Create(
      InternalCreateDocumentChargeRepository(QueryExecutor),
      QueryExecutor,
      FDocumentTableDefsFactory.GetDocumentChargeSheetTableDef
    );

end;

function TPostgresDocumentRepositoriesFactory.InternalCreateDocumentFilesRepository(
  QueryExecutor: IQueryExecutor): IDocumentFilesRepository;
begin

  Result :=
    TDocumentFilesPostgresRepository.Create(
      QueryExecutor,
      FDocumentTableDefsFactory.GetDocumentFilesTableDef
    );
    
end;

function TPostgresDocumentRepositoriesFactory.InternalCreateDocumentKindRepository(
  QueryExecutor: IQueryExecutor): IDocumentKindRepository;
begin

  Result :=
    TDocumentKindPostgresRepository.Create(
      QueryExecutor,
      FDocumentTableDefsFactory.GetDocumentTypesTableDef
    );

end;

function TPostgresDocumentRepositoriesFactory.InternalCreateDocumentRelationsRepository(
  QueryExecutor: IQueryExecutor): IDocumentRelationsRepository;
begin

  Result :=
    TDocumentRelationsPostgresRepository.Create(
      QueryExecutor,
      FDocumentTableDefsFactory.GetDocumentRelationsTableDef
    );
    
end;

function TPostgresDocumentRepositoriesFactory.InternalCreateDocumentRepository(
  QueryExecutor: IQueryExecutor): IDocumentRepository;
var
    DocumentApprovingReposiory: IDocumentApprovingRepository;
begin

  DocumentApprovingReposiory :=
    CreateDocumentApprovingRepository(QueryExecutor);
    
  Result :=
    TDocumentPostgresRepository.Create(
      QueryExecutor,
      FDocumentTableDefsFactory.GetDocumentTableDef,
      FDocumentTableDefsFactory.GetDocumentTypeStageTableDef,
      FDocumentType,

      TDocumentApprovingPostgresRepository(DocumentApprovingReposiory.Self),

      TDocumentSigningPostgresRepository.Create(
        QueryExecutor,
        FDocumentTableDefsFactory.GetDocumentSigningTableDef
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

function TPostgresDocumentRepositoriesFactory.InternalCreateDocumentResponsibleRepository(
  QueryExecutor: IQueryExecutor): IDocumentResponsibleRepository;
begin

  Result :=
    TDocumentResponsiblePostgresRepository.Create(QueryExecutor);
    
end;

function TPostgresDocumentRepositoriesFactory.InternalCreateDocumentWorkCycleRepository(
  QueryExecutor: IQueryExecutor): IDocumentWorkCycleRepository;
begin

  Result :=
    TStandardDocumentWorkCycleRepository.Create(
      CreateDocumentKindRepository(QueryExecutor),
      TDocumentWorkCycleStagesPostgresRepository.Create(
        QueryExecutor,
        FDocumentTableDefsFactory.GetDocumentTypeStageTableDef
      )
    );
    
end;

function TPostgresDocumentRepositoriesFactory.InternalCreateIncomingDocumentRepository(
  QueryExecutor: IQueryExecutor
): IIncomingDocumentRepository;
var
    OriginalDocumentPostgresRepository: TDocumentPostgresRepository;
begin

  OriginalDocumentPostgresRepository :=
    TDocumentPostgresRepository(CreateDocumentRepository(QueryExecutor).Self);
    
  Result :=
    TIncomingDocumentPostgresRepository.Create(
      OriginalDocumentPostgresRepository,
      FDocumentTableDefsFactory.GetIncomingDocumentTableDef,
      FDocumentTableDefsFactory.GetDocumentChargeSheetTableDef,
      TIncomingDocumentClass(FDocumentType.IncomingDocumentType)
    );
    
end;

end.
