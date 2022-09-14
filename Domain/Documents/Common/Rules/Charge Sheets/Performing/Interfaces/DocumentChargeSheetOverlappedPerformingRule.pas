unit DocumentChargeSheetOverlappedPerformingRule;

interface

uses

  DomainException,
  IDocumentChargeSheetUnit;
  
type

  TDocumentChargeSheetOverlappedPerformingRuleException = class (TDomainException)


  end;

  TNotValidChargeSheetTypeForOverlappedPerformingException =
    class (TDocumentChargeSheetOverlappedPerformingRuleException)
    
    end;

  IDocumentChargeSheetOverlappedPerformingRule = interface

    procedure EnsureThatChargeSheetPerformingMayBeOverlappedByOtherChargeSheet(
      TargetChargeSheet, OverlappingChargeSheet: IDocumentChargeSheet
    );

    function MayChargeSheetPerformingOverlappedByOtherChargeSheet(
      TargetChargeSheet, OverlappingChargeSheet: IDocumentChargeSheet
    ): Boolean;

  end;

implementation

end.
