unit DocumentRemovingRule;

interface

uses

  EmployeeDocumentWorkingRule;

type

  TDocumentRemovingRuleException = class (TEmployeeDocumentWorkingRuleException)

  end;

  IDocumentRemovingRule = interface (IEmployeeDocumentWorkingRule)

    
  end;


implementation

end.
