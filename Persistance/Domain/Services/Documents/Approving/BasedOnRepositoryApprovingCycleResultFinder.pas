unit BasedOnRepositoryApprovingCycleResultFinder;

interface

uses

  IDocumentUnit,
  Employee,
  DocumentApprovingCycleResult,
  DocumentApprovingCycleResultFinder,
  DocumentApprovingCycleResultRepository,
  SysUtils,
  Classes;

type

  TBasedOnRepositoryApprovingCycleResultFinder =
    class (TInterfacedObject, IDocumentApprovingCycleResultFinder)

      protected

        FDocumentApprovingCycleResultRepository:
          IDocumentApprovingCycleResultRepository;
          
      public

        constructor Create(
          DocumentApprovingCycleResultRepository:
            IDocumentApprovingCycleResultRepository
        );
        
        function GetPassedApprovingCycleCountForDocument(
          Document: IDocument
        ): Integer; 

        function AreDocumentApprovingCycleResultsExistsForEmployee(
          Document: IDocument;
          Employee: TEmployee
        ): Boolean;

        function FindAllApprovingCycleResultsForDocument(
          const DocumentId: Variant
        ): TDocumentApprovingCycleResults;

    end;

implementation

{ TBasedOnRepositoryApprovingCycleResultFinder }

function TBasedOnRepositoryApprovingCycleResultFinder.
  AreDocumentApprovingCycleResultsExistsForEmployee(
    Document: IDocument;
    Employee: TEmployee
  ): Boolean;
begin

  Result :=
    FDocumentApprovingCycleResultRepository.
      AreDocumentApprovingCycleResultsExistsForEmployee(
        Document.Identity, Employee.Identity
      );
      
end;

constructor TBasedOnRepositoryApprovingCycleResultFinder.Create(
  DocumentApprovingCycleResultRepository: IDocumentApprovingCycleResultRepository);
begin

  inherited Create;

  FDocumentApprovingCycleResultRepository :=
    DocumentApprovingCycleResultRepository;
    
end;

function TBasedOnRepositoryApprovingCycleResultFinder.FindAllApprovingCycleResultsForDocument(
  const DocumentId: Variant): TDocumentApprovingCycleResults;
begin

  Result :=
    FDocumentApprovingCycleResultRepository
      .FindAllApprovingCycleResultsForDocument(DocumentId);
      
end;

function TBasedOnRepositoryApprovingCycleResultFinder.
  GetPassedApprovingCycleCountForDocument(
    Document: IDocument
  ): Integer;
begin

  Result :=
    FDocumentApprovingCycleResultRepository.
      GetApprovingCycleResultCountForDocument(Document.Identity);
      
end;

end.
