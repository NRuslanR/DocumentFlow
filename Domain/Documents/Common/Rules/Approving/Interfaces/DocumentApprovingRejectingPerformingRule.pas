unit DocumentApprovingRejectingPerformingRule;

interface

uses

  DomainException,
  IDocumentUnit,
  Employee;

type

  TDocumentApprovingRejectingPerformingRuleException = class (TDomainException)

  end;
  
  IDocumentApprovingRejectingPerformingRule = interface

    function EnsureThatEmployeeCanRejectApprovingDocument(
      Document: IDocument;
      Employee: TEmployee
    ): TEmployee;
    
    function EnsureThatEmployeeCanRejectApprovingDocumentOnBehalfOfOther(
      Document: IDocument;
      FormalApprover: TEmployee;
      RejectingApprovingEmployee: TEmployee
    ): TEmployee;

    procedure EnsureThatEmployeeHasOnlyRightsForDocumentApprovingRejecting(
      Employee: TEmployee;
      Document: IDocument
    );
    
    function CanEmployeeRejectApprovingDocument(
      Document: IDocument;
      Employee: TEmployee
    ): Boolean;

    function CanEmployeeRejectApprovingDocumentOnBehalfOfOther(
      Document: IDocument;
      FormalApprover: TEmployee;
      RejectingApprovingEmployee: TEmployee
    ): Boolean;

    function HasEmployeeOnlyRightsForDocumentApprovingRejecting(
      Employee: TEmployee;
      Document: IDocument
    ): Boolean;

  end;

implementation

end.
