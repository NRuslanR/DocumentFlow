unit BasedOnRepositoryDocumentRelationsFinder;

interface

uses

  DocumentRelationsUnit,
  DocumentRelationsFinder,
  DocumentRelationsRepository,
  Document,
  SysUtils,
  Classes;

type

  TBasedOnRepositoryDocumentRelationsFinder =
    class (TInterfacedObject, IDocumentRelationsFinder)

      private

        FDocumentRelationsRepository: IDocumentRelationsRepository;

      public

        constructor Create(
          DocumentRelationsRepository: IDocumentRelationsRepository
        );

        function FindRelationsForDocument(const DocumentId: Variant): TDocumentRelations; overload;
        function FindRelationsForDocument(Document: TDocument): TDocumentRelations; overload;
    
    end;
  
implementation

{ TBasedOnRepositoryDocumentRelationsFinder }

constructor TBasedOnRepositoryDocumentRelationsFinder.Create(
  DocumentRelationsRepository: IDocumentRelationsRepository);
begin

  inherited Create;

  FDocumentRelationsRepository := DocumentRelationsRepository;

end;

function TBasedOnRepositoryDocumentRelationsFinder.FindRelationsForDocument(
  Document: TDocument
): TDocumentRelations;
begin

  Result := FindRelationsForDocument(Document.Identity);

end;

function TBasedOnRepositoryDocumentRelationsFinder.FindRelationsForDocument(
  const DocumentId: Variant): TDocumentRelations;
begin

  Result := FDocumentRelationsRepository.FindRelationsForDocument(DocumentId);
  
end;


end.
