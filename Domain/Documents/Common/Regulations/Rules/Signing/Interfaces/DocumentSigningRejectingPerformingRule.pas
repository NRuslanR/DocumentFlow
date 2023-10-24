unit DocumentSigningRejectingPerformingRule;

interface

uses

  DomainException,
  IDocumentUnit,
  Employee;

type

  TDocumentSigningRejectingPerformingRuleException = class (TDomainException)

  end;

  IDocumentSigningRejectingPerformingRule = interface

    function EnsureThatEmployeeCanRejectSigningDocument(
      Document: IDocument;
      Employee: TEmployee
    ): TEmployee;
    
    function EnsureThatEmployeeCanRejectSigningDocumentOnBehalfOfOther(
      Document: IDocument;
      FormalSigner: TEmployee;
      SigningEmployee: TEmployee
    ): TEmployee;

    procedure EnsureThatEmployeeHasOnlyRightsForDocumentSigningRejecting(
      Employee: TEmployee;
      Document: IDocument
    );
    
    function CanEmployeeRejectSigningDocument(
      Document: IDocument;
      Employee: TEmployee
    ): Boolean;

    function CanEmployeeRejectSigningDocumentOnBehalfOfOther(
      Document: IDocument;
      FormalSigner: TEmployee;
      SigningEmployee: TEmployee
    ): Boolean;

    function HasEmployeeOnlyRightsForDocumentSigningRejecting(
      Employee: TEmployee;
      Document: IDocument
    ): Boolean;
    
  end;

implementation

end.
