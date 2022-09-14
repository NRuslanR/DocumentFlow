unit DocumentApprovingCycleResultRepository;

interface

uses

  DocumentApprovingCycleResult;

type

  IDocumentApprovingCycleResultRepository = interface

    function AreDocumentApprovingCycleResultsExistsForEmployee(
      const DocumentId: Variant;
      const EmployeeId: Variant
    ): Boolean;
        
    function GetApprovingCycleResultCountForDocument(
      const DocumentId: Variant
    ): Integer;

    function FindAllApprovingCycleResultsForDocument(
      const DocumentId: Variant
    ): TDocumentApprovingCycleResults;

    procedure AddDocumentApprovingCycleResult(
      DocumentApprovingCycleResult: TDocumentApprovingCycleResult
    );

    procedure RemoveDocumentApprovingCycleResult(
      DocumentApprovingCycleResult: TDocumentApprovingCycleResult
      );

    procedure RemoveAllApprovingCycleResultsForDocument(
      const DocumentId: Variant
    );

  end;
  
implementation

end.
