unit DocumentApproverListChangingRule;

interface

uses

  SysUtils,
  IDocumentUnit,
  DomainException,
  EmployeeDocumentWorkingRule,
  Employee;

type

  TDocumentApproverListChangingRuleException = class (TDomainException)

  end;
  
  IDocumentApproverListChangingRule = interface

    procedure EnsureThatEmployeeMayAssignDocumentApprover(
      Employee: TEmployee;
      Document: IDocument;
      Approver: TEmployee
    );

    procedure EnsureThatEmployeeMayRemoveDocumentApprover(
      Employee: TEmployee;
      Document: IDocument;
      Approver: TEmployee
    );

    procedure EnsureThatEmployeeMayChangeDocumentApproverList(
      Employee: TEmployee;
      Document: IDocument
    );

    procedure EnsureThatEmployeeMayChangeDocumentApproverInfo(
      Employee: TEmployee;
      Document: IDocument;
      Approver: TEmployee
    );

    procedure EnsureThatEmployeeMayChangeInfoForAnyOfDocumentApprovers(
      Employee: TEmployee;
      Document: IDocument
    );

    function MayEmployeeAssignDocumentApprover(
      Employee: TEmployee;
      Document: IDocument;
      Approver: TEmployee
    ): Boolean;

    function MayEmployeeRemoveDocumentApprover(
      Employee: TEmployee;
      Document: IDocument;
      Approver: TEmployee
    ): Boolean;

    function MayEmployeeChangeDocumentApproverList(
      Employee: TEmployee;
      Document: IDocument
    ): Boolean;

    function MayEmployeeChangeDocumentApproverInfo(
      Employee: TEmployee;
      Document: IDocument;
      Approver: TEmployee
    ): Boolean;

    function MayEmployeeChangeInfoForAnyOfDocumentApprovers(
      Employee: TEmployee;
      Document: IDocument
    ): Boolean;
    
  end;


implementation

end.
