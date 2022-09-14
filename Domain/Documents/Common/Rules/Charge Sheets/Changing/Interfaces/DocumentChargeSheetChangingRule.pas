unit DocumentChargeSheetChangingRule;

interface

uses

  IDocumentChargeSheetUnit,
  DocumentChargeSheetWorkingRule,
  IDocumentUnit,
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
      DocumentChargeSheet: IDocumentChargeSheet;
      Document: IDocument
    ): TStrings;
    
    function EnsureEmployeeMayChangeDocumentChargeSheet(
      Employee: TEmployee;
      DocumentChargeSheet: IDocumentChargeSheet;
      Document: IDocument
    ): TStrings; overload;
    
    procedure EnsureEmployeeMayChangeDocumentChargeSheet(
      Employee: TEmployee;
      DocumentChargeSheet: IDocumentChargeSheet;
      Document: IDocument;
      FieldNames: array of Variant
    ); overload;

    function MayEmployeeChangeDocumentChargeSheet(
      Employee: TEmployee;
      DocumentChargeSheet: IDocumentChargeSheet;
      Document: IDocument;
      FieldNames: array of Variant
    ): Boolean;

  end;

implementation

end.
