unit DocumentChargeSheetWorkingRule;

interface

uses

  DomainException,
  IDocumentChargeSheetUnit,
  Employee;

type

  TDocumentChargeSheetWorkingRuleException = class (TDomainException)


  end;
  
  IDocumentChargeSheetWorkingRule = interface

    procedure EnsureThatIsSatisfiedFor(
      Employee: TEmployee;
      DocumentChargeSheet: IDocumentChargeSheet
    );

    function IsSatisfiedBy(
      Employee: TEmployee;
      DocumentChargeSheet: IDocumentChargeSheet
    ): Boolean;
    
  end;
  
implementation

end.
