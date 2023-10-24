unit StandardDocumentChargeSheetWorkingRule;

interface

uses

  IDocumentChargeSheetUnit,
  DocumentChargeSheetWorkingRule,
  EmployeeIsSameAsOrDeputySpecification,
  DocumentChargeSheet,
  Employee,
  SysUtils,
  Classes;

type

  TStandardDocumentChargeSheetWorkingRule =
    class (
      TInterfacedObject,
      IDocumentChargeSheetWorkingRule
    )

      protected

        FEmployeeIsSameAsOrDeputySpecification:
          IEmployeeIsSameAsOrDeputySpecification;

        procedure InternalEnsureThatIsSatisfiedFor(
          Employee: TEmployee;
          DocumentChargeSheet: TDocumentChargeSheet
        ); virtual; abstract;

        function InternalIsSatisfiedBy(
          Employee: TEmployee;
          DocumentChargeSheet: IDocumentChargeSheet
        ): Boolean; virtual;
        
      public

        constructor Create(
          EmployeeIsSameAsOrDeputySpecification:
            IEmployeeIsSameAsOrDeputySpecification
        );

        procedure EnsureThatIsSatisfiedFor(
          Employee: TEmployee;
          DocumentChargeSheet: IDocumentChargeSheet
        );

        function IsSatisfiedBy(
          Employee: TEmployee;
          DocumentChargeSheet: IDocumentChargeSheet
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
    DocumentChargeSheet: IDocumentChargeSheet
  );
begin

  InternalEnsureThatIsSatisfiedFor(
    Employee,
    DocumentChargeSheet.Self as TDocumentChargeSheet
  );
  
end;

function TStandardDocumentChargeSheetWorkingRule.InternalIsSatisfiedBy(
  Employee: TEmployee;
  DocumentChargeSheet: IDocumentChargeSheet
): Boolean;
begin

  try

    EnsureThatIsSatisfiedFor(Employee, DocumentChargeSheet);

    Result := True;

  except

    on e: TDocumentChargeSheetWorkingRuleException do begin

      Result := False;
      
    end;

  end;

end;

function TStandardDocumentChargeSheetWorkingRule.IsSatisfiedBy(
  Employee: TEmployee;
  DocumentChargeSheet: IDocumentChargeSheet
): Boolean;
begin

  Result := InternalIsSatisfiedBy(Employee, DocumentChargeSheet);
  
end;

end.
