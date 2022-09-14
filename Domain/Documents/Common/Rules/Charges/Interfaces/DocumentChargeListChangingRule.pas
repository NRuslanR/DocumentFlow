unit DocumentChargeListChangingRule;

interface

uses

  DomainException,
  Employee,
  IDocumentUnit,
  DocumentChargeInterface;

type

  TDocumentChargeListChangingRuleException = class (TDomainException)


  end;

  IDocumentChargeListChangingRule = interface

    procedure EnsureThatEmployeeMayAssignDocumentCharge(
      Employee: TEmployee;
      Document: IDocument;
      DocumentCharge: IDocumentCharge
    );

    procedure EnsureThatEmployeeMayChangeChargeList(
      Employee: TEmployee;
      Document: IDocument
    );

    procedure EnsureDocumentChargeAssignedForEmployee(
      Employee: TEmployee;
      Document: IDocument
    );

    function MayEmployeeAssignDocumentCharge(
      Employee: TEmployee;
      Document: IDocument;
      DocumentCharge: IDocumentCharge
    ): Boolean;

    function MayEmployeeChangeChargeList(
      Employee: TEmployee;
      Document: IDocument
    ): Boolean;

    function IsDocumentChargeAssignedForEmployee(
      Employee: TEmployee;
      Document: IDocument
    ): Boolean;

  end;
  
implementation

end.
