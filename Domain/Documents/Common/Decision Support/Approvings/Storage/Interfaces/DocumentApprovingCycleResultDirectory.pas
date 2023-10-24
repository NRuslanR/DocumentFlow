unit DocumentApprovingCycleResultDirectory;

interface

uses

  IDocumentUnit,
  Employee,
  DocumentApprovingCycleResult,
  DocumentApprovingCycleResultFinder,
  SysUtils;

type

  IDocumentApprovingCycleResultDirectory = interface
    ['{5FC8A822-67C3-4ADF-B673-3E655419B678}']

    function AreDocumentApprovingCycleResultsExistsForEmployee(
      const Document: IDocument;
      const Employee: TEmployee
    ): Boolean;

    function GetApprovingCycleResultCountForDocument(
      const Document: IDocument
    ): Integer;

    function FindAllApprovingCycleResultsForDocument(
      const DocumentId: Variant
    ): TDocumentApprovingCycleResults;

    procedure AddDocumentApprovingCycleResult(
      DocumentApprovingCycleResult: TDocumentApprovingCycleResult
    );

    procedure RemoveDocumentApprovingCycleResult(
      const DocumentApprovingCycleResult: TDocumentApprovingCycleResult
    ); 

    procedure RemoveAllApprovingCycleResultsForDocument(
      const DocumentId: Variant
    );

  end;

implementation

end.
