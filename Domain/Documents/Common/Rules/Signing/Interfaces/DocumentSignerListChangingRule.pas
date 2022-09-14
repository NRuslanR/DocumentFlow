unit DocumentSignerListChangingRule;

interface

uses

  DomainException,
  Employee,
  IDocumentUnit,
  SysUtils,
  Classes;

type

  TDocumentSignerListChangingRuleException = class (TDomainException)

  end;

  IDocumentSignerListChangingRule = interface

    procedure EnsureThatEmployeeMayAssignDocumentSigner(
      Employee: TEmployee;
      Document: IDocument;
      Signer: TEmployee
    );

    procedure EnsureThatEmployeeMayRemoveDocumentSigner(
      Employee: TEmployee;
      Document: IDocument;
      Signer: TEmployee
    );

    function MayEmployeeAssignDocumentSigner(
      Employee: TEmployee;
      Document: IDocument;
      Signer: TEmployee
    ): Boolean;

    function MayEmployeeRemoveDocumentSigner(
      Employee: TEmployee;
      Document: IDocument;
      Signer: TEmployee
    ): Boolean;

  end;

implementation

end.
