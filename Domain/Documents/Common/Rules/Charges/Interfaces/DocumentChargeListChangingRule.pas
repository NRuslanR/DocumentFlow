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

    procedure EnsureThatEmployeeMayAssignDocumentCharges(
      Employee: TEmployee;
      Document: IDocument;
      DocumentCharges: IDocumentCharges
    );
    
    function MayEmployeeAssignDocumentCharge(
      Employee: TEmployee;
      Document: IDocument;
      DocumentCharge: IDocumentCharge
    ): Boolean;

    procedure EnsureEmployeeMayRemoveDocumentCharge(
      Employee: TEmployee;
      Document: IDocument;
      DocumentCharge: IDocumentCharge
    );

    procedure EnsureEmployeeMayRemoveDocumentCharges(
      Employee: TEmployee;
      Document: IDocument;
      DocumentCharges: IDocumentCharges
    );

    function MayEmployeeRemoveDocumentCharge(
      Employee: TEmployee;
      Document: IDocument;
      DocumentCharge: IDocumentCharge
    ): Boolean;

    procedure EnsureThatEmployeeMayChangeChargeList(
      Employee: TEmployee;
      Document: IDocument;
      Charge: IDocumentCharge = nil
    );

    function MayEmployeeChangeChargeList(
      Employee: TEmployee;
      Document: IDocument;
      Charge: IDocumentCharge = nil
    ): Boolean;

    procedure EnsureDocumentChargeAssignedForEmployee(
      Employee: TEmployee;
      Document: IDocument
    );

    function IsDocumentChargeAssignedForEmployee(
      Employee: TEmployee;
      Document: IDocument
    ): Boolean;

  end;
  
implementation

end.
