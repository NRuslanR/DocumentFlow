unit DocumentChargeSheetRemovingRule;

interface

uses

  DocumentChargeSheetWorkingRule,
  DomainException,
  SysUtils;

type

  TDocumentChargeSheetRemovingRuleException = class (TDocumentChargeSheetWorkingRuleException)

  end;
  
  IDocumentChargeSheetRemovingRule = interface (IDocumentChargeSheetWorkingRule)

  end;
  
implementation

end.
