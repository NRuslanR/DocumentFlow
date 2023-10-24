unit DocumentApprovingCycleResultFinder;

interface

uses

  Employee,
  DocumentApprovingCycleResult,
  IDocumentUnit;

type

  IDocumentApprovingCycleResultFinder = interface

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

end.
