unit DocumentRelationsRepository;

interface

uses

  DocumentRelationsUnit,
  Document;

type

  IDocumentRelationsRepository = interface

    procedure AddDocumentRelations(DocumentRelations: TDocumentRelations);
    procedure RemoveDocumentRelations(DocumentRelations: TDocumentRelations);
    procedure RemoveAllRelationsForDocument(const DocumentId: Variant);
    function FindRelationsForDocument(const DocumentId: Variant): TDocumentRelations;
      
  end;

implementation

end.
