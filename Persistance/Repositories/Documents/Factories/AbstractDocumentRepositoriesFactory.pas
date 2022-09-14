unit AbstractDocumentRepositoriesFactory;

interface

uses

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
  IDocumentResponsibleRepositoryUnit,
  DocumentTableDefsFactory,
  DocumentChargeKindRepository,
  DocumentChargeRepository,
  IncomingDocumentRepository,
  Document,
  SysUtils;

type

  TAbstractDocumentRepositoriesFactory =
    class (TInterfacedObject, IDocumentRepositoriesFactory)

      protected

        FDocumentTableDefsFactory: TDocumentTableDefsFactory;
        FDocumentType: TDocumentClass;

        function InternalCreateDocumentRepository(QueryExecutor: IQueryExecutor): IDocumentRepository; virtual; abstract;
        function InternalCreateDocumentApprovingCycleResultRepository(QueryExecutor: IQueryExecutor): IDocumentApprovingCycleResultRepository; virtual; abstract;
        function InternalCreateDocumentApprovingRepository(QueryExecutor: IQueryExecutor): IDocumentApprovingRepository; virtual; abstract;
        function InternalCreateDocumentChargeSheetRepository(QueryExecutor: IQueryExecutor): IDocumentChargeSheetRepository; virtual; abstract;
        function InternalCreateDocumentChargeRepository(QueryExecutor: IQueryExecutor): IDocumentChargeRepository; virtual; abstract;
        function InternalCreateDocumentChargeKindRepository(QueryExecutor: IQueryExecutor): IDocumentChargeKindRepository; virtual; abstract;
        function InternalCreateDocumentFilesRepository(QueryExecutor: IQueryExecutor): IDocumentFilesRepository; virtual; abstract;
        function InternalCreateDocumentKindRepository(QueryExecutor: IQueryExecutor): IDocumentKindRepository; virtual; abstract;
        function InternalCreateDocumentRelationsRepository(QueryExecutor: IQueryExecutor): IDocumentRelationsRepository; virtual; abstract;
        function InternalCreateDocumentWorkCycleRepository(QueryExecutor: IQueryExecutor): IDocumentWorkCycleRepository; virtual; abstract;
        function InternalCreateDocumentResponsibleRepository(QueryExecutor: IQueryExecutor): IDocumentResponsibleRepository; virtual; abstract;
        function InternalCreateIncomingDocumentRepository(QueryExecutor: IQueryExecutor): IIncomingDocumentRepository; virtual; abstract;

      protected

        procedure RaiseExceptionIfDocumentTypeNotAssigned;
        
      public

        constructor Create(
          DocumentTableDefsFactory: TDocumentTableDefsFactory;
          DocumentType: TDocumentClass = nil
        );

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

    TAbstractDocumentRepositoriesFactoryClass = class of TAbstractDocumentRepositoriesFactory;
    
implementation

{ TAbstractDocumentRepositoriesFactory }

constructor TAbstractDocumentRepositoriesFactory.Create(
  DocumentTableDefsFactory: TDocumentTableDefsFactory;
  DocumentType: TDocumentClass
);
begin

  inherited Create;

  FDocumentTableDefsFactory := DocumentTableDefsFactory;
  FDocumentType := DocumentType;
  
end;

function TAbstractDocumentRepositoriesFactory.CreateDocumentApprovingCycleResultRepository(
  QueryExecutor: IQueryExecutor): IDocumentApprovingCycleResultRepository;
begin

  Result := InternalCreateDocumentApprovingCycleResultRepository(QueryExecutor);
  
end;

function TAbstractDocumentRepositoriesFactory.CreateDocumentApprovingRepository(
  QueryExecutor: IQueryExecutor): IDocumentApprovingRepository;
begin

  Result := InternalCreateDocumentApprovingRepository(QueryExecutor);
  
end;

function TAbstractDocumentRepositoriesFactory.CreateDocumentChargeKindRepository(
  QueryExecutor: IQueryExecutor): IDocumentChargeKindRepository;
begin

  Result := InternalCreateDocumentChargeKindRepository(QueryExecutor);
  
end;

function TAbstractDocumentRepositoriesFactory.CreateDocumentChargeRepository(
  QueryExecutor: IQueryExecutor): IDocumentChargeRepository;
begin

  Result := InternalCreateDocumentChargeRepository(QueryExecutor);
  
end;

function TAbstractDocumentRepositoriesFactory.CreateDocumentChargeSheetRepository(
  QueryExecutor: IQueryExecutor): IDocumentChargeSheetRepository;
begin

  Result := InternalCreateDocumentChargeSheetRepository(QueryExecutor);
  
end;

function TAbstractDocumentRepositoriesFactory.CreateDocumentFilesRepository(
  QueryExecutor: IQueryExecutor): IDocumentFilesRepository;
begin

  Result := InternalCreateDocumentFilesRepository(QueryExecutor);
  
end;

function TAbstractDocumentRepositoriesFactory.CreateDocumentKindRepository(
  QueryExecutor: IQueryExecutor): IDocumentKindRepository;
begin

  Result := InternalCreateDocumentKindRepository(QueryExecutor);
  
end;

function TAbstractDocumentRepositoriesFactory.CreateDocumentRelationsRepository(
  QueryExecutor: IQueryExecutor): IDocumentRelationsRepository;
begin

  Result := InternalCreateDocumentRelationsRepository(QueryExecutor);
  
end;

function TAbstractDocumentRepositoriesFactory.CreateDocumentRepository(
  QueryExecutor: IQueryExecutor): IDocumentRepository;
begin

  RaiseExceptionIfDocumentTypeNotAssigned;
  
  Result := InternalCreateDocumentRepository(QueryExecutor);
  
end;

function TAbstractDocumentRepositoriesFactory.CreateDocumentResponsibleRepository(
  QueryExecutor: IQueryExecutor): IDocumentResponsibleRepository;
begin

  Result := InternalCreateDocumentResponsibleRepository(QueryExecutor);

end;

function TAbstractDocumentRepositoriesFactory.CreateDocumentWorkCycleRepository(
  QueryExecutor: IQueryExecutor): IDocumentWorkCycleRepository;
begin

  Result := InternalCreateDocumentWorkCycleRepository(QueryExecutor);

end;

function TAbstractDocumentRepositoriesFactory.CreateIncomingDocumentRepository(
  QueryExecutor: IQueryExecutor): IIncomingDocumentRepository;
begin

  RaiseExceptionIfDocumentTypeNotAssigned;
  
  Result := InternalCreateIncomingDocumentRepository(QueryExecutor);

end;

procedure TAbstractDocumentRepositoriesFactory.RaiseExceptionIfDocumentTypeNotAssigned;
begin

  if not Assigned(FDocumentType) then begin

    raise Exception.Create(
      'Программная ошибка. Во время создания репозитория ' +
      'обнаружен неинициализированный вид документов'
    );

  end;

end;

end.
