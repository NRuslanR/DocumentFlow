unit InternalServiceNotePostgresRepository;

interface

uses

  Document,
  InternalServiceNote,
  ZConnection,
  DocumentPostgresRepository,
  ServiceNotePostgresRepository,
  SysUtils,
  Classes;

type

  TInternalServiceNotePostgresRepository =
    class (TServiceNotePostgresRepository)

      protected

        procedure GetDocumentTableNameMapping(
          var TableName: string;
          var DocumentClass: TDocumentClass;
          var DocumentsClass: TDocumentsClass
        ); override;

        function GetDocumentTypeId: Variant; override;

      public

        function FindDocumentById(
          const DocumentId: Variant
        ): TDocument; override;
          
    end;
  
implementation

uses

  DocumentTypesDBTableUnit,
  //ServiceNoteWorkCycle,
  DocumentTypeStageTable, BaseDocumentPostgresRepository,
  AbstractRepository;

{ TInternalServiceNotePostgresRepository }

function TInternalServiceNotePostgresRepository.FindDocumentById(
  const DocumentId: Variant): TDocument;
var Document: TDocument;
begin

  Document := inherited FindDocumentById(DocumentId);

  if Assigned(Document) then
    Result := TInternalServiceNote.Create(Document)

  else Result := nil;
  
end;

procedure TInternalServiceNotePostgresRepository.
  GetDocumentTableNameMapping(
    var TableName: string;
    var DocumentClass: TDocumentClass;
    var DocumentsClass: TDocumentsClass
  );
begin

  inherited;

  DocumentsClass := TInternalServiceNotes;
  
end;

function TInternalServiceNotePostgresRepository.GetDocumentTypeId: Variant;
begin

  Result :=
    FDocumentTypeIdentityResolver.ResolveDocumentTypeIdentity(
      TInternalServiceNote
    );
    
end;

end.
