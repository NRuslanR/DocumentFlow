unit DocumentChargeSheetPerformingEnsurer;

interface

uses

  IDocumentUnit,
  IDocumentChargeSheetUnit,
  Employee,
  SysUtils;

type

  IDocumentChargeSheetPerformingEnsurer = interface

    procedure EnsureEmployeeMayPerformChargeSheet(
      Employee: TEmployee;
      ChargeSheet: IDocumentChargeSheet
    );
    
  end;

  TDocumentChargeSheetPerformingEnsurer =
    class (TInterfacedObject, IDocumentChargeSheetPerformingEnsurer)

      private

        FDocument: IDocument;
        
      public

        constructor Create(Document: IDocument);

        procedure EnsureEmployeeMayPerformChargeSheet(
          Employee: TEmployee;
          ChargeSheet: IDocumentChargeSheet
        );
        
    end;
  
implementation

uses

  DocumentChargeSheet;
  
{ TDocumentChargeSheetPerformingEnsurer }

constructor TDocumentChargeSheetPerformingEnsurer.Create(Document: IDocument);
begin

  inherited Create;

  FDocument := Document;
  
end;

procedure TDocumentChargeSheetPerformingEnsurer.
  EnsureEmployeeMayPerformChargeSheet(
    Employee: TEmployee;
    ChargeSheet: IDocumentChargeSheet
  );
var
    ChargeSheetObj: TDocumentChargeSheet;
begin

  ChargeSheetObj := TDocumentChargeSheet(ChargeSheet.Self);

  ChargeSheetObj
    .WorkingRules
      .DocumentChargeSheetPerformingRule
        .EnsureThatIsSatisfiedFor(
          Employee, ChargeSheet, FDocument
        );

end;

end.
