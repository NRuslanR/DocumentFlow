unit DocumentChargeSheetChangingEnsurer;

interface

uses

  IDocumentChargeSheetUnit,
  IDocumentUnit,
  Employee,
  SysUtils;

type

  IDocumentChargeSheetChangingEnsurer = interface

    procedure EnsureEmployeeMayChangeChargeSheet(
      Employee: TEmployee;
      ChargeSheet: IDocumentChargeSheet
    ); overload;

    procedure EnsureEmployeeMayChangeChargeSheet(
      Employee: TEmployee;
      ChargeSheet: IDocumentChargeSheet;
      FieldNames: array of Variant
    ); overload;

  end;

  TDocumentChargeSheetChangingEnsurer =
    class (TInterfacedObject, IDocumentChargeSheetChangingEnsurer)

      private

        FDocument: IDocument;

      public

        constructor Create(Document: IDocument);
        
        procedure EnsureEmployeeMayChangeChargeSheet(
          Employee: TEmployee;
          ChargeSheet: IDocumentChargeSheet
        ); overload;

        procedure EnsureEmployeeMayChangeChargeSheet(
          Employee: TEmployee;
          ChargeSheet: IDocumentChargeSheet;
          FieldNames: array of Variant
        ); overload;

    end;

implementation

uses

  DocumentChargeSheet;
  
{ TDocumentChargeSheetChangingEnsurer }

constructor TDocumentChargeSheetChangingEnsurer.Create(Document: IDocument);
begin

  inherited Create;

  FDocument := Document;

end;

procedure TDocumentChargeSheetChangingEnsurer.EnsureEmployeeMayChangeChargeSheet(
  Employee: TEmployee;
  ChargeSheet: IDocumentChargeSheet
);
var
    ChargeSheetObj: TDocumentChargeSheet;
begin

  ChargeSheetObj := TDocumentChargeSheet(ChargeSheet.Self);

  ChargeSheetObj
    .WorkingRules
      .DocumentChargeSheetChangingRule
        .EnsureEmployeeMayChangeDocumentChargeSheet(
          Employee, ChargeSheet, FDocument
        );

end;

procedure TDocumentChargeSheetChangingEnsurer.EnsureEmployeeMayChangeChargeSheet(
  Employee: TEmployee;
  ChargeSheet: IDocumentChargeSheet;
  FieldNames: array of Variant
);
var
    ChargeSheetObj: TDocumentChargeSheet;
begin

  ChargeSheetObj := TDocumentChargeSheet(ChargeSheet.Self);

  ChargeSheetObj
    .WorkingRules
      .DocumentChargeSheetChangingRule
        .EnsureEmployeeMayChangeDocumentChargeSheet(
          Employee, ChargeSheet, FDocument, FieldNames
        );
        
end;

end.
