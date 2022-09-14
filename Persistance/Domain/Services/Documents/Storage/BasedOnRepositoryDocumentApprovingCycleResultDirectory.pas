unit BasedOnRepositoryDocumentApprovingCycleResultDirectory;

interface

uses

  DocumentApprovingCycleResultFinder,
  AbstractDocumentApprovingCycleResultDirectory,
  DocumentApprovingCycleResultRepository,
  DocumentApprovingCycleResult,
  SysUtils,
  Classes;

type

  TBasedOnRepositoryDocumentApprovingCycleResultDirectory =
    class (TAbstractDocumentApprovingCycleResultDirectory)

      private

        FDocumentApprovingCycleResultRepository: IDocumentApprovingCycleResultRepository;
        
      public

        constructor Create(
          DocumentApprovingCycleResultRepository: IDocumentApprovingCycleResultRepository;
          DocumentApprovingCycleResultFinder: IDocumentApprovingCycleResultFinder
        );
        
        procedure AddDocumentApprovingCycleResult(
          DocumentApprovingCycleResult: TDocumentApprovingCycleResult
        ); override;

        procedure RemoveDocumentApprovingCycleResult(
          const DocumentApprovingCycleResult: TDocumentApprovingCycleResult
        );

        procedure RemoveAllApprovingCycleResultsForDocument(
          const DocumentId: Variant
        ); override;

    end;
  
implementation

{ TBasedOnRepositoryDocumentApprovingCycleResultDirectory }

constructor TBasedOnRepositoryDocumentApprovingCycleResultDirectory.Create(
  DocumentApprovingCycleResultRepository: IDocumentApprovingCycleResultRepository;
  DocumentApprovingCycleResultFinder: IDocumentApprovingCycleResultFinder
);
begin

  inherited Create(DocumentApprovingCycleResultFinder);

  FDocumentApprovingCycleResultRepository := DocumentApprovingCycleResultRepository;
  
end;

procedure TBasedOnRepositoryDocumentApprovingCycleResultDirectory.AddDocumentApprovingCycleResult(
  DocumentApprovingCycleResult: TDocumentApprovingCycleResult);
begin

  FDocumentApprovingCycleResultRepository.AddDocumentApprovingCycleResult(
    DocumentApprovingCycleResult
  );

end;

procedure TBasedOnRepositoryDocumentApprovingCycleResultDirectory.RemoveAllApprovingCycleResultsForDocument(
  const DocumentId: Variant);
begin

  FDocumentApprovingCycleResultRepository.RemoveAllApprovingCycleResultsForDocument(
    DocumentId
  );

end;


procedure TBasedOnRepositoryDocumentApprovingCycleResultDirectory.
  RemoveDocumentApprovingCycleResult(
    const DocumentApprovingCycleResult: TDocumentApprovingCycleResult
  );
begin

  FDocumentApprovingCycleResultRepository.RemoveDocumentApprovingCycleResult(
    DocumentApprovingCycleResult
  );
  
end;

end.
