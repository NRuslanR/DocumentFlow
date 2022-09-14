unit AbstractDocumentApprovingCycleResultDirectory;

interface

uses

  DocumentApprovingCycleResultFinder,
  DocumentApprovingCycleResult,
  DocumentApprovingCycleResultDirectory,
  IDocumentUnit,
  Employee,
  SysUtils;

type

  TAbstractDocumentApprovingCycleResultDirectory =
    class (TInterfacedObject, IDocumentApprovingCycleResultDirectory)

      protected

        FDocumentApprovingCycleResultFinder: IDocumentApprovingCycleResultFinder;
        
      public

        constructor Create(
          DocumentApprovingCycleResultFinder: IDocumentApprovingCycleResultFinder
        );

      public
        
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

      public

        procedure AddDocumentApprovingCycleResult(
          DocumentApprovingCycleResult: TDocumentApprovingCycleResult
        ); virtual; abstract;

        procedure RemoveDocumentApprovingCycleResult(
          const DocumentApprovingCycleResult: TDocumentApprovingCycleResult
        ); virtual; abstract;

        procedure RemoveAllApprovingCycleResultsForDocument(
          const DocumentId: Variant
        ); virtual; abstract;
        
    end;

implementation

{ TAbstractDocumentApprovingCycleResultDirectory }

constructor TAbstractDocumentApprovingCycleResultDirectory.Create(
  DocumentApprovingCycleResultFinder: IDocumentApprovingCycleResultFinder);
begin

  inherited Create;

  FDocumentApprovingCycleResultFinder := DocumentApprovingCycleResultFinder;
  
end;

function TAbstractDocumentApprovingCycleResultDirectory.
  AreDocumentApprovingCycleResultsExistsForEmployee(
    const Document: IDocument;
    const Employee: TEmployee
  ): Boolean;
begin

  Result :=
    FDocumentApprovingCycleResultFinder
      .AreDocumentApprovingCycleResultsExistsForEmployee(
        Document, Employee
      );
      
end;

function TAbstractDocumentApprovingCycleResultDirectory.
  FindAllApprovingCycleResultsForDocument(
    const DocumentId: Variant
  ): TDocumentApprovingCycleResults;
begin

  Result := FDocumentApprovingCycleResultFinder.FindAllApprovingCycleResultsForDocument(DocumentId);
  
end;

function TAbstractDocumentApprovingCycleResultDirectory.
  GetApprovingCycleResultCountForDocument(
    const Document: IDocument
  ): Integer;
begin

  Result :=
    FDocumentApprovingCycleResultFinder
      .GetPassedApprovingCycleCountForDocument(Document);
      
end;

end.
