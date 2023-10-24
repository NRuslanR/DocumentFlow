unit DocumentApprovingPerformingRule;

interface

uses

  DomainException,
  DocumentApprovings,
  IDocumentUnit,
  Employee;

type

  TDocumentApprovingPerformingRuleException = class (TDomainException)
  
  end;

  IDocumentApprovingPerformingRule = interface

    function EnsureThatEmployeeCanApproveDocument(
      Document: IDocument;
      Employee: TEmployee
    ): TEmployee;

    function EnsureThatEmployeeCanApproveDocumentOnBehalfOfOther(
      Document: IDocument;
      FormalApprover: TEmployee;
      ApprovingEmployee: TEmployee
    ): TEmployee;

    procedure EnsureThatEmployeeHasOnlyRightsForDocumentApproving(
      Employee: TEmployee;
      Document: IDocument
    );

    function CanEmployeeApproveDocument(
      Document: IDocument;
      Employee: TEmployee
    ): Boolean;

    function CanEmployeeApproveDocumentOnBehalfOfOther(
      Document: IDocument;
      FormalApprover: TEmployee;
      ApprovingEmployee: TEmployee
    ): Boolean;
    
    function FindReplaceableDocumentApprovingFor(
      Document: IDocument;
      Employee: TEmployee
    ): TDocumentApproving;

    function HasEmployeeOnlyRightsForDocumentApproving(
      Employee: TEmployee;
      Document: IDocument
    ): Boolean;
    
  end;
  
implementation

end.
