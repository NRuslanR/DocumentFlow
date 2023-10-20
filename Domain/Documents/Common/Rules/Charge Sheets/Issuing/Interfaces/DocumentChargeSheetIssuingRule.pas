unit DocumentChargeSheetIssuingRule;

interface

uses

  DocumentChargeSheetWorkingRule,
  DomainException,
  IDocumentChargeSheetUnit,
  Employee,
  SysUtils;

type

  TDocumentChargeSheetIssuingRuleException =
    class (TDocumentChargeSheetWorkingRuleException)

    end;
  
  IDocumentChargeSheetIssuingRule = interface 

    procedure EnsureEmployeeCanIssueSubordinateChargeSheet(
      Employee: TEmployee;
      DocumentChargeSheet: IDocumentChargeSheet
    );

    function CanEmployeeCanIssueSubordinateChargeSheet(
      Employee: TEmployee;
      DocumentChargeSheet: IDocumentChargeSheet
    ): Boolean;
  
  end;

implementation

end.
