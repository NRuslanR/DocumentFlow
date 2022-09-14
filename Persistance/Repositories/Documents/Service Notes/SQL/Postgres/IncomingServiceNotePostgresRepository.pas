unit IncomingServiceNotePostgresRepository;

interface

uses

  IncomingDocumentPostgresRepository,
  AbstractDBRepository,
  ServiceNotePostgresRepository,
  AbstractPostgresRepository,
  IncomingDocument,
  Document,
  IncomingServiceNote,
  SysUtils,
  Classes;

type

  TIncomingServiceNotePostgresRepository =
    class (TIncomingDocumentPostgresRepository)

      protected

        procedure GetDocumentTableNameMapping(
          var TableName: String;
          var DocumentClass: TDocumentClass;
          var DocumentsClass: TDocumentsClass
        ); override;

      public

        constructor Create(
          ServiceNotePostgresRepository: TServiceNotePostgresRepository
        );

        function LoadAllIncomingServiceNotes: TIncomingServiceNotes;
      
        function FindIncomingServiceNoteById(
          const IncomingServiceNoteId: Variant
        ): TIncomingServiceNote;

        procedure AddIncomingServiceNote(
          IncomingServiceNote: TIncomingServiceNote
        );

        procedure AddIncomingServiceNotes(
          IncomingServiceNotes: TIncomingServiceNotes
        );
        
        procedure UpdateIncomingServiceNote(
          IncomingServiceNote: TIncomingServiceNote
        );

        procedure UpdateIncomingServiceNotes(
          IncomingServiceNotes: TIncomingServiceNotes
        );
        
        procedure RemoveIncomingServiceNote(
          IncomingServiceNote: TIncomingServiceNote
        );

        procedure RemoveIncomingServiceNotes(
          IncomingServiceNotes: TIncomingServiceNotes
        );

    end;

implementation

uses

  IncomingServiceNoteTable;
  
{ TIncomingServiceNotePostgresRepository }

procedure TIncomingServiceNotePostgresRepository.AddIncomingServiceNote(
  IncomingServiceNote: TIncomingServiceNote);
begin

  AddIncomingDocument(IncomingServiceNote);
  
end;

procedure TIncomingServiceNotePostgresRepository.AddIncomingServiceNotes(
  IncomingServiceNotes: TIncomingServiceNotes);
begin

  AddIncomingDocuments(IncomingServiceNotes);
  
end;

constructor TIncomingServiceNotePostgresRepository.Create(
  ServiceNotePostgresRepository: TServiceNotePostgresRepository);
begin

  inherited Create(ServiceNotePostgresRepository);
  
end;

function TIncomingServiceNotePostgresRepository.FindIncomingServiceNoteById(
  const IncomingServiceNoteId: Variant): TIncomingServiceNote;
begin

  Result :=
    TIncomingServiceNote(FindIncomingDocumentById(IncomingServiceNoteId));

end;

procedure TIncomingServiceNotePostgresRepository.
  GetDocumentTableNameMapping(
    var TableName: String;
    var DocumentClass: TDocumentClass;
    var DocumentsClass: TDocumentsClass
  );
begin

  TableName := INCOMING_SERVICE_NOTE_TABLE_NAME;
  DocumentClass := TIncomingServiceNote;
  DocumentsClass := TIncomingServiceNotes;

end;

function TIncomingServiceNotePostgresRepository.
  LoadAllIncomingServiceNotes: TIncomingServiceNotes;
begin

  Result := TIncomingServiceNotes(LoadAllIncomingDocuments);

end;

procedure TIncomingServiceNotePostgresRepository.RemoveIncomingServiceNote(
  IncomingServiceNote: TIncomingServiceNote);
begin

  RemoveIncomingDocument(IncomingServiceNote);
  
end;

procedure TIncomingServiceNotePostgresRepository.RemoveIncomingServiceNotes(
  IncomingServiceNotes: TIncomingServiceNotes);
begin

  RemoveIncomingDocuments(IncomingServiceNotes);
  
end;

procedure TIncomingServiceNotePostgresRepository.UpdateIncomingServiceNote(
  IncomingServiceNote: TIncomingServiceNote);
begin

  UpdateIncomingDocument(IncomingServiceNote);
  
end;

procedure TIncomingServiceNotePostgresRepository.UpdateIncomingServiceNotes(
  IncomingServiceNotes: TIncomingServiceNotes);
begin

  UpdateIncomingDocuments(IncomingServiceNotes);
  
end;

end.
