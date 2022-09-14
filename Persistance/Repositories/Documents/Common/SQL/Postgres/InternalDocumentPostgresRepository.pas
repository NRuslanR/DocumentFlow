unit InternalDocumentPostgresRepository;

interface

uses

  DocumentPostgresRepository,
  InternalDocument,
  DomainObjectListUnit,
  DomainObjectUnit,
  AbstractRepositoryCriteriaUnit,
  ZConnection,
  QueryExecutor,
  Document,
  SysUtils,
  Classes;

type

  TInternalDocumentPostgresRepository =
    class (TDocumentPostgresRepository)

      protected

        FInternalDocumentClass: TInternalDocumentClass;
        FInternalDocumentsClass: TInternalDocumentsClass;
        
        FOriginalDocumentPostgresRepository: TDocumentPostgresRepository;
        
      protected

        procedure Initialize; override;

      protected
      
        procedure GetDocumentTableNameMapping(
          var TableName: string;
          var DocumentClass: TDocumentClass;
          var DocumentsClass: TDocumentsClass
        ); override;

      public

        destructor Destroy; override;

        function LoadAllDocuments: TDocuments; override;

        function FindDocumentById(const DocumentId: Variant): TDocument; override;

        procedure AddDocument(Document: TDocument); override;
        procedure AddDocuments(Documents: TDocuments); override;

        procedure UpdateDocument(Document: TDocument); override;
        procedure UpdateDocuments(Documents: TDocuments); override;

        procedure RemoveDocument(Document: TDocument); override;
        procedure RemoveDocuments(Documents: TDocuments); override;

        constructor Create(
          QueryExecutor: IQueryExecutor;
          const InternalDocumentTypeId: Variant;
          OriginalDocumentPostgresRepository: TDocumentPostgresRepository
        ); virtual;

    end;
  
implementation

{ TInternalDocumentPostgresRepository }

procedure TInternalDocumentPostgresRepository.AddDocument(
  Document: TDocument);
begin

  FOriginalDocumentPostgresRepository.AddDocument(Document);

end;

procedure TInternalDocumentPostgresRepository.AddDocuments(
  Documents: TDocuments);
begin

  FOriginalDocumentPostgresRepository.AddDocuments(Documents);
  
end;

constructor TInternalDocumentPostgresRepository.Create(
  QueryExecutor: IQueryExecutor;
  const InternalDocumentTypeId: Variant;
  OriginalDocumentPostgresRepository: TDocumentPostgresRepository
);
begin

  inherited Create(QueryExecutor);

  DocumentTypeId := InternalDocumentTypeId;

  FOriginalDocumentPostgresRepository := OriginalDocumentPostgresRepository;

  FOriginalDocumentPostgresRepository.DocumentTypeId := InternalDocumentTypeId;
  
end;

destructor TInternalDocumentPostgresRepository.Destroy;
begin

  FreeAndNil(FOriginalDocumentPostgresRepository);
  
  inherited;

end;

function TInternalDocumentPostgresRepository.FindDocumentById(
  const DocumentId: Variant): TDocument;
begin

  Result :=
    TInternalDocument.Create(
      FOriginalDocumentPostgresRepository.FindDocumentById(DocumentId)
    );
    
end;

procedure TInternalDocumentPostgresRepository.
  GetDocumentTableNameMapping(
    var TableName: string;
    var DocumentClass: TDocumentClass;
    var DocumentsClass: TDocumentsClass
  );
begin

  inherited;

  DocumentClass := TInternalDocument;
  DocumentsClass := TInternalDocuments;

end;

procedure TInternalDocumentPostgresRepository.Initialize;
var Placeholder: String;
    InternalDocumentClass: TDocumentClass;
    InternalDocumentsClass: TDocumentsClass;
begin

  inherited;

  GetDocumentTableNameMapping(
    Placeholder, InternalDocumentClass, InternalDocumentsClass
  );

  FInternalDocumentClass := TInternalDocumentClass(InternalDocumentClass);
  FInternalDocumentsClass := TInternalDocumentsClass(InternalDocumentsClass);
  
  FReturnSurrogateIdOfDomainObjectAfterAdding := True;

end;

function TInternalDocumentPostgresRepository.LoadAllDocuments: TDocuments;
begin

  Result :=
    TInternalDocuments.Create(
      FOriginalDocumentPostgresRepository.LoadAllDocuments
    );
  
end;

procedure TInternalDocumentPostgresRepository.RemoveDocument(
  Document: TDocument);
begin

  FOriginalDocumentPostgresRepository.RemoveDocument(Document);

end;

procedure TInternalDocumentPostgresRepository.RemoveDocuments(
  Documents: TDocuments);
begin

  FOriginalDocumentPostgresRepository.RemoveDocuments(Documents);

end;

procedure TInternalDocumentPostgresRepository.UpdateDocument(
  Document: TDocument);
begin

  FOriginalDocumentPostgresRepository.UpdateDocument(Document);

end;

procedure TInternalDocumentPostgresRepository.UpdateDocuments(
  Documents: TDocuments);
begin

  FOriginalDocumentPostgresRepository.UpdateDocuments(Documents);

end;

end.
