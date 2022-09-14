unit DocumentChargeSheetWorkingRule;

interface

uses

  DomainException,
  IDocumentChargeSheetUnit,
  IDocumentUnit,
  Employee;

type

  TDocumentChargeSheetWorkingRuleException = class (TDomainException)


  end;
  
  IDocumentChargeSheetWorkingRule = interface

    procedure EnsureThatIsSatisfiedFor(
      Employee: TEmployee;
      DocumentChargeSheet: IDocumentChargeSheet;
      Document: IDocument
    );

    function IsSatisfiedBy(
      Employee: TEmployee;
      DocumentChargeSheet: IDocumentChargeSheet;
      Document: IDocument
    ): Boolean;
    
  end;
  
implementation

end.
