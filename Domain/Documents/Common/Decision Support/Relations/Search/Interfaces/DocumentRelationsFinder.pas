unit DocumentRelationsFinder;

interface

uses

  Document,
  DocumentRelationsUnit;

type

  IDocumentRelationsFinder = interface

    function FindRelationsForDocument(const DocumentId: Variant): TDocumentRelations; overload;
    function FindRelationsForDocument(Document: TDocument): TDocumentRelations; overload;
    
  end;
  
implementation

end.
