unit DocumentRelationDirectory;

interface

uses

  Document,
  DocumentRelationsUnit;

type

  IDocumentRelationDirectory = interface

    procedure AddDocumentRelations(DocumentRelations: TDocumentRelations);
    procedure UpdateDocumentRelations(DocumentRelations: TDocumentRelations);
    procedure RemoveDocumentRelations(DocumentRelations: TDocumentRelations);

    procedure RemoveAllRelationsForDocument(const DocumentId: Variant);
    function FindRelationsForDocument(const DocumentId: Variant): TDocumentRelations;

  end;

implementation

end.
