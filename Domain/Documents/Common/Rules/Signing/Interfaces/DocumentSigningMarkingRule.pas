unit DocumentSigningMarkingRule;

interface

uses

  DomainException,
  EmployeeDocumentWorkingRule,
  Employee,
  IDocumentUnit,
  SysUtils;

type

  TDocumentSigningMarkingRuleException = class (TEmployeeDocumentWorkingRuleException)

  end;
  
  IDocumentSigningMarkingRule = interface

    function CanEmployeeMarkDocumentAsSigned(
      Employee: TEmployee;
      Document: IDocument
    ): Boolean;

    function CouldEmployeeMarkDocumentAsSigned(
      Employee: TEmployee;
      Document: IDocument
    ): Boolean;
    
    procedure EnsureEmployeeCanMarkDocumentAsSigned(
      Employee: TEmployee;
      Document: IDocument
    );

    function HasEmployeeRightsForDocumentSigningMarking(
      Employee: TEmployee;
      Document: IDocument
    ): Boolean;

    procedure EnsureEmployeeHasRightsForDocumentSigningMarking(
      Employee: TEmployee;
      Document: IDocument
    );
    
  end;
  
implementation

end.
