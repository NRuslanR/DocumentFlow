unit DocumentChargeChangingRule;

interface

uses

  Employee,
  IDocumentUnit,
  Classes,
  DocumentChargeInterface;

type

  IDocumentChargeChangingRule = interface

    function EnsureEmployeeMayChangeDocumentCharge(
      Employee: TEmployee;
      Document: IDocument;
      DocumentCharge: IDocumentCharge
    ): TStrings; overload;
    
    procedure EnsureEmployeeMayChangeDocumentCharge(
      Employee: TEmployee;
      Document: IDocument;
      DocumentCharge: IDocumentCharge;
      FieldNames: array of Variant
    ); overload;

    function MayEmployeeChangeDocumentCharge(
      Employee: TEmployee;
      Document: IDocument;
      DocumentCharge: IDocumentCharge;
      FieldNames: array of Variant
    ): Boolean;

  end;
  
implementation

end.
