unit BasedOnRepositoryDocumentRelationDirectory;

interface

uses

  DocumentRelationDirectory,
  DocumentRelationsUnit,
  DocumentRelationsRepository,
  SysUtils;

type

  TBasedOnRepositoryDocumentRelationDirectory =
    class (TInterfacedObject, IDocumentRelationDirectory)

      protected

        FDocumentRelationsRepository: IDocumentRelationsRepository;

      public

        constructor Create(DocumentRelationsRepository: IDocumentRelationsRepository);
        
        procedure AddDocumentRelations(DocumentRelations: TDocumentRelations);
        procedure UpdateDocumentRelations(DocumentRelations: TDocumentRelations);
        procedure RemoveDocumentRelations(DocumentRelations: TDocumentRelations);

        procedure RemoveAllRelationsForDocument(const DocumentId: Variant);
        function FindRelationsForDocument(const DocumentId: Variant): TDocumentRelations;

    end;

implementation

{ TBasedOnRepositoryDocumentRelationDirectory }

constructor TBasedOnRepositoryDocumentRelationDirectory.Create(
  DocumentRelationsRepository: IDocumentRelationsRepository);
begin

  inherited Create;

  FDocumentRelationsRepository := DocumentRelationsRepository;
  
end;

procedure TBasedOnRepositoryDocumentRelationDirectory.AddDocumentRelations(
  DocumentRelations: TDocumentRelations);
begin

  FDocumentRelationsRepository.AddDocumentRelations(DocumentRelations);
  
end;

function TBasedOnRepositoryDocumentRelationDirectory.FindRelationsForDocument(
  const DocumentId: Variant): TDocumentRelations;
begin

  Result := FDocumentRelationsRepository.FindRelationsForDocument(DocumentId);
  
end;

procedure TBasedOnRepositoryDocumentRelationDirectory.RemoveAllRelationsForDocument(
  const DocumentId: Variant);
begin

  FDocumentRelationsRepository.RemoveAllRelationsForDocument(DocumentId);

end;

procedure TBasedOnRepositoryDocumentRelationDirectory.RemoveDocumentRelations(
  DocumentRelations: TDocumentRelations);
begin

  FDocumentRelationsRepository.RemoveDocumentRelations(DocumentRelations);

end;

procedure TBasedOnRepositoryDocumentRelationDirectory.UpdateDocumentRelations(
  DocumentRelations: TDocumentRelations
);
begin

  FDocumentRelationsRepository.RemoveAllRelationsForDocument(
    DocumentRelations.TargetDocumentId
  );

  FDocumentRelationsRepository.AddDocumentRelations(DocumentRelations);

end;

end.
