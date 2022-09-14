unit DocumentApprovingPerformingService;

interface

uses

  ApplicationService;
  
type

  TDocumentApprovingPerformingKind = (pkApporving, pkNotApproving);

  IDocumentApprovingPerformingService = interface (IApplicationService)

    procedure PerformApprovingDocument(
      const DocumentId: Variant;
      const PerformerId: Variant;
      const DocumentApprovingPerformingKind: TDocumentApprovingPerformingKind
    );
    
  end;

implementation

end.
