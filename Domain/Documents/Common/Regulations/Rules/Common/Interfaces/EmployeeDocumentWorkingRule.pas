unit EmployeeDocumentWorkingRule;

interface

uses

  DomainException,
  IDocumentUnit,
  Employee;

type

  TEmployeeDocumentWorkingRuleException = class (TDomainException)

  end;
  
  IEmployeeDocumentWorkingRule = interface

    procedure EnsureThatIsSatisfiedFor(
      Employee: TEmployee;
      Document: IDocument
    );

    function IsSatisfiedBy(
      Employee: TEmployee;
      Document: IDocument
    ): Boolean;

    procedure EnsureThatIsSatisfiedForEmployeeOnly(
      Employee: TEmployee;
      Document: IDocument
    );

    function IsSatisfiedForEmployeeOnly(
      Employee: TEmployee;
      Document: IDocument
    ): Boolean;

  end;

implementation

end.
