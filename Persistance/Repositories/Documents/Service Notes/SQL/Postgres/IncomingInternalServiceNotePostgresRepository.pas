unit IncomingInternalServiceNotePostgresRepository;

interface

uses

  IncomingServiceNotePostgresRepository,
  IncomingInternalServiceNote,
  IncomingServiceNote,
  IncomingDocument,
  Document,
  SysUtils,
  Classes;

type

  TIncomingInternalServiceNotePostgresRepository =
    class (TIncomingServiceNotePostgresRepository)

      protected

        function GetDocumentTypeId: Variant; override;

      protected

        procedure GetDocumentTableNameMapping(
          var TableName: String;
          var DocumentClass: TDocumentClass;
          var DocumentsClass: TDocumentsClass
        ); override;
        
      public

        function FindDocumentById(
          const DocumentId: Variant
        ): TDocument; override;

    end;

implementation

uses BaseDocumentPostgresRepository, IncomingDocumentPostgresRepository;

{ TIncomingInternalServiceNotePostgresRepository }

procedure TIncomingInternalServiceNotePostgresRepository.
  GetDocumentTableNameMapping(
    var TableName: String;
    var DocumentClass: TDocumentClass;
    var DocumentsClass: TDocumentsClass
  );
begin

  inherited;

  DocumentsClass := TIncomingInternalServiceNotes;
  
end;

function TIncomingInternalServiceNotePostgresRepository.
  GetDocumentTypeId: Variant;
begin

  Result :=
    FDocumentTypeIdentityResolver.ResolveDocumentTypeIdentity(
      TIncomingInternalServiceNote
    );

end;

function TIncomingInternalServiceNotePostgresRepository.
  FindDocumentById(
    const DocumentId: Variant
  ): TDocument;
var IncomingServiceNote: TIncomingServiceNote;
begin

  IncomingServiceNote :=
    TIncomingServiceNote(inherited FindDocumentById(DocumentId));

  if Assigned(IncomingServiceNote) then
    Result := TIncomingInternalServiceNote.Create(IncomingServiceNote)

  else Result := nil;
  
end;

end.
