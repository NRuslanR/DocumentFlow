unit ServiceNotePostgresRepository;

interface

uses

  Document,
  DocumentPostgresRepository,
  AbstractDBRepository,
  AbstractPostgresRepository,
  QueryExecutor,
  DocumentChargePostgresRepository,
  DocumentSigningPostgresRepository,
  DocumentApprovingPostgresRepository,
  ServiceNote,
  SysUtils,
  Classes;

type

  TServiceNotePostgresRepository = class (TDocumentPostgresRepository)

    protected

      procedure GetDocumentTableNameMapping(
        var TableName: string;
        var DocumentClass: TDocumentClass;
        var DocumentsClass: TDocumentsClass
      ); override;

    protected

      function CreateDocumentChargePostgresRepository(
        QueryExecutor: IQueryExecutor
      ): TDocumentChargePostgresRepository; override;

      function CreateDocumentSigningPostgresRepository(
        QueryExecutor: IQueryExecutor
      ): TDocumentSigningPostgresRepository; override;

      function CreateDocumentApprovingPostgresRepository(
        QueryExecutor: IQueryExecutor
      ): TDocumentApprovingPostgresRepository; override;
                                       
    public

      function LoadAllServiceNotes: TServiceNotes;

      function FindServiceNoteById(const ServiceNoteId: Variant): TServiceNote;

      procedure AddServiceNote(ServiceNote: TServiceNote);
      procedure AddServiceNotes(ServiceNotes: TServiceNotes);

      procedure UpdateServiceNote(ServiceNote: TServiceNote);
      procedure UpdateServiceNotes(ServiceNotes: TServiceNotes);

      procedure RemoveServiceNote(ServiceNote: TServiceNote);
      procedure RemoveServiceNotes(ServiceNotes: TServiceNotes);
      
  end;

implementation

uses

  ServiceNoteTable,
  ServiceNoteChargePostgresRepository,
  ServiceNoteApprovingPostgresRepository,
  ServiceNoteSigningPostgresRepository;

{ TServiceNotePostgresRepository }

procedure TServiceNotePostgresRepository.AddServiceNote(
  ServiceNote: TServiceNote);
begin

  AddDocument(ServiceNote);
  
end;

procedure TServiceNotePostgresRepository.AddServiceNotes(
  ServiceNotes: TServiceNotes);
begin

  AddDocuments(ServiceNotes);
  
end;

function TServiceNotePostgresRepository.CreateDocumentApprovingPostgresRepository(
  QueryExecutor: IQueryExecutor): TDocumentApprovingPostgresRepository;
begin

  Result := TServiceNoteApprovingPostgresRepository.Create(QueryExecutor);
  
end;

function TServiceNotePostgresRepository.CreateDocumentChargePostgresRepository(
  QueryExecutor: IQueryExecutor): TDocumentChargePostgresRepository;
begin

  Result := TServiceNoteChargePostgresRepository.Create(QueryExecutor);
  
end;

function TServiceNotePostgresRepository.CreateDocumentSigningPostgresRepository(
  QueryExecutor: IQueryExecutor): TDocumentSigningPostgresRepository;
begin

  Result := TServiceNoteSigningPostgresRepository.Create(QueryExecutor);
  
end;

function TServiceNotePostgresRepository.FindServiceNoteById(
  const ServiceNoteId: Variant): TServiceNote;
begin

  Result := FindDocumentById(ServiceNoteId) as TServiceNote;
  
end;

procedure TServiceNotePostgresRepository.GetDocumentTableNameMapping(
  var TableName: string;
  var DocumentClass: TDocumentClass;
  var DocumentsClass: TDocumentsClass
);
begin

  TableName := SERVICE_NOTE_TABLE_NAME;
  DocumentClass := TServiceNote;
  DocumentsClass := TServiceNotes;

end;

function TServiceNotePostgresRepository.LoadAllServiceNotes: TServiceNotes;
begin

  Result := LoadAllDocuments as TServiceNotes;

end;

procedure TServiceNotePostgresRepository.RemoveServiceNote(
  ServiceNote: TServiceNote);
begin

  RemoveDocument(ServiceNote);
  
end;

procedure TServiceNotePostgresRepository.RemoveServiceNotes(
  ServiceNotes: TServiceNotes);
begin

  RemoveDocuments(ServiceNotes);

end;

procedure TServiceNotePostgresRepository.UpdateServiceNote(
  ServiceNote: TServiceNote);
begin

  UpdateDocument(ServiceNote);
  
end;

procedure TServiceNotePostgresRepository.UpdateServiceNotes(
  ServiceNotes: TServiceNotes);
begin

  UpdateDocuments(ServiceNotes);

end;                        

end.
