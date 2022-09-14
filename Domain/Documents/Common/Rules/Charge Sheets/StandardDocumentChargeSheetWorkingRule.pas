unit StandardDocumentChargeSheetWorkingRule;

interface

uses

  IDocumentChargeSheetUnit,
  DocumentChargeSheetWorkingRule,
  EmployeeIsSameAsOrDeputySpecification,
  DocumentChargeSheet,
  IDocumentUnit,
  Employee,
  SysUtils,
  Classes;

type

  TStandardDocumentChargeSheetWorkingRule =
    class (TInterfacedObject, IDocumentChargeSheetWorkingRule)

      protected

        FEmployeeIsSameAsOrDeputySpecification:
          IEmployeeIsSameAsOrDeputySpecification;

        procedure InternalEnsureThatIsSatisfiedFor(
          Employee: TEmployee;
          DocumentChargeSheet: TDocumentChargeSheet;
          Document: IDocument
        ); virtual; abstract;

        function InternalIsSatisfiedBy(
          Employee: TEmployee;
          DocumentChargeSheet: IDocumentChargeSheet;
          Document: IDocument
        ): Boolean; virtual;
        
      public

        constructor Create(
          EmployeeIsSameAsOrDeputySpecification:
            IEmployeeIsSameAsOrDeputySpecification
        );

        procedure EnsureThatIsSatisfiedFor(
          Employee: TEmployee;
          DocumentChargeSheet: IDocumentChargeSheet;
          Document: IDocument
        );

        function IsSatisfiedBy(
          Employee: TEmployee;
          DocumentChargeSheet: IDocumentChargeSheet;
          Document: IDocument
        ): Boolean;

    end;

implementation

{ TStandardDocumentChargeSheetWorkingRule }

constructor TStandardDocumentChargeSheetWorkingRule.Create(
  EmployeeIsSameAsOrDeputySpecification: IEmployeeIsSameAsOrDeputySpecification
);
begin

  inherited Create;

  FEmployeeIsSameAsOrDeputySpecification :=
    EmployeeIsSameAsOrDeputySpecification;
    
end;

procedure TStandardDocumentChargeSheetWorkingRule.
  EnsureThatIsSatisfiedFor(
    Employee: TEmployee;
    DocumentChargeSheet: IDocumentChargeSheet;
    Document: IDocument
  );
begin

  InternalEnsureThatIsSatisfiedFor(
    Employee,
    DocumentChargeSheet.Self as TDocumentChargeSheet,
    Document
  );
  
end;

function TStandardDocumentChargeSheetWorkingRule.InternalIsSatisfiedBy(
  Employee: TEmployee;
  DocumentChargeSheet: IDocumentChargeSheet;
  Document: IDocument
): Boolean;
begin

  try

    EnsureThatIsSatisfiedFor(Employee, DocumentChargeSheet, Document);

    Result := True;

  except

    on e: TDocumentChargeSheetWorkingRuleException do begin

      Result := False;
      
    end;

  end;

end;

function TStandardDocumentChargeSheetWorkingRule.IsSatisfiedBy(
  Employee: TEmployee;
  DocumentChargeSheet: IDocumentChargeSheet;
  Document: IDocument
): Boolean;
begin

  Result := InternalIsSatisfiedBy(Employee, DocumentChargeSheet, Document);
  
end;

end.
