unit DocumentSigningPerformingRule;

interface

uses

  DomainException,
  IDocumentUnit,
  Employee;

type

  TDocumentSigningPerformingRuleException = class (TDomainException)

  end;
  
  IDocumentSigningPerformingRule = interface

    function EnsureThatEmployeeCanSignDocument(
      Document: IDocument;
      Employee: TEmployee
    ): TEmployee;

    function EnsureThatEmployeeCanSignDocumentOnBehalfOfOther(
      Document: IDocument;
      FormalSigner: TEmployee;
      SigningEmployee: TEmployee
    ): TEmployee;

    procedure EnsureThatEmployeeHasOnlyRightsForDocumentSigning(
      Employee: TEmployee;
      Document: IDocument
    );

    procedure EnsureEmployeeAnyOfDocumentSigners(
      Employee: TEmployee;
      Document: IDocument
    );
    
    function CanEmployeeSignDocument(
      Document: IDocument;
      Employee: TEmployee
    ): Boolean;

    function CanEmployeeSignDocumentOnBehalfOfOther(
      Document: IDocument;
      FormalSigner: TEmployee;
      SigningEmployee: TEmployee
    ): Boolean;

    function HasEmployeeOnlyRightsForDocumentSigning(
      Employee: TEmployee;
      Document: IDocument
    ): Boolean;

    function IsEmployeeAnyOfDocumentSigners(
      Employee: TEmployee;
      Document: IDocument
    ): Boolean;
    
  end;
  
implementation

end.
