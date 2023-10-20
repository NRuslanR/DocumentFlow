unit DocumentChargeSheetChangingRule;

interface

uses

  IDocumentChargeSheetUnit,
  DocumentChargeSheetWorkingRule,
  Classes,
  Employee,
  DomainException,
  ArrayFunctions;

type

  TDocumentChargeSheetChangingRuleException = class (TDocumentChargeSheetWorkingRuleException)

  end;
  
  IDocumentChargeSheetChangingRule = interface

    function GetAlloweableDocumentChargeSheetFieldNames(
      Employee: TEmployee;
      DocumentChargeSheet: IDocumentChargeSheet
    ): TStrings;
    
    function EnsureEmployeeMayChangeDocumentChargeSheet(
      Employee: TEmployee;
      DocumentChargeSheet: IDocumentChargeSheet
    ): TStrings; overload;
    
    procedure EnsureEmployeeMayChangeDocumentChargeSheet(
      Employee: TEmployee;
      DocumentChargeSheet: IDocumentChargeSheet;
      FieldNames: array of Variant
    ); overload;

    function MayEmployeeChangeDocumentChargeSheet(
      Employee: TEmployee;
      DocumentChargeSheet: IDocumentChargeSheet;
      FieldNames: array of Variant
    ): Boolean;

  end;

implementation

end.
