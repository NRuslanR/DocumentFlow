unit DocumentChargeSheetViewingRule;

interface

uses

  DocumentChargeSheetWorkingRule,
  DomainException,
  IDocumentChargeSheetUnit,
  Employee,
  IDocumentUnit,
  SysUtils;

type

  TDocumentChargeSheetViewingRuleException = class (TDocumentChargeSheetWorkingRuleException)

  end;
  
  TDocumentChargeSheetViewingRuleEnsuringResult = (

    EmployeeMayViewDocumentChargeSheetAsIssuer,
    EmployeeMayViewDocumentChargeSheetAsPerformer,
    EmployeeMayViewDocumentChargeSheetAsAuthorized,
    EmployeeMayNotViewDocumentChargeSheet
    
  );
  
  IDocumentChargeSheetViewingRule = interface (IDocumentChargeSheetWorkingRule)

    function EnsureEmployeeMayViewDocumentChargeSheet(
      Employee: TEmployee;
      DocumentChargeSheet: IDocumentChargeSheet;
      Document: IDocument
    ): TDocumentChargeSheetViewingRuleEnsuringResult;

    function MayEmployeeViewDocumentChargeSheet(
      Employee: TEmployee;
      DocumentChargeSheet: IDocumentChargeSheet;
      Document: IDocument
    ): TDocumentChargeSheetViewingRuleEnsuringResult;

  end;

implementation

end.
