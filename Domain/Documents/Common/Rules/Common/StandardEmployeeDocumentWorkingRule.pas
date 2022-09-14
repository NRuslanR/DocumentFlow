unit StandardEmployeeDocumentWorkingRule;

interface

uses

  DomainException,
  EmployeeDocumentWorkingRule,
  EmployeeIsSameAsOrReplacingForOthersSpecification,
  DocumentFullNameCompilationService,
  IDocumentUnit,
  Employee,
  SysUtils,
  Classes;

type

  TStandardEmployeeDocumentWorkingRule =
    class abstract (TInterfacedObject, IEmployeeDocumentWorkingRule)

      protected

        FEmployeeIsSameAsOrReplacingForOthersSpecification:
          IEmployeeIsSameAsOrReplacingForOthersSpecification;

        FDocumentFullNameCompilationService:
          IDocumentFullNameCompilationService;
          
        procedure InternalEnsureThatIsSatisfiedFor(
          Employee: TEmployee;
          Document: IDocument
        ); virtual; abstract;

        function InternalIsSatisfiedBy(
          Employee: TEmployee;
          Document: IDocument
        ): Boolean; virtual;

        procedure InternalEnsureThatIsSatisfiedForEmployeeOnly(
          Employee: TEmployee;
          Document: IDocument
        ); virtual; abstract;

        function InternalIsSatisfiedForEmployeeOnly(
          Employee: TEmployee;
          Document: IDocument
        ): Boolean; virtual; 

      public

        constructor Create(
        
          EmployeeIsSameAsOrReplacingForOthersSpecification:
            IEmployeeIsSameAsOrReplacingForOthersSpecification;

          DocumentFullNameCompilationService:
            IDocumentFullNameCompilationService
        );

        procedure EnsureThatIsSatisfiedFor(
          Employee: TEmployee;
          Document: IDocument
        );

        function IsSatisfiedBy(
          Employee: TEmployee;
          Document: IDocument
        ): Boolean;

        procedure EnsureThatIsSatisfiedForEmployeeOnly(
          Employee: TEmployee;
          Document: IDocument
        );

        function IsSatisfiedForEmployeeOnly(
          Employee: TEmployee;
          Document: IDocument
        ): Boolean;

    end;

implementation

{ TStandardEmployeeDocumentWorkingRule }

constructor TStandardEmployeeDocumentWorkingRule.Create(
  EmployeeIsSameAsOrReplacingForOthersSpecification:
    IEmployeeIsSameAsOrReplacingForOthersSpecification;

  DocumentFullNameCompilationService:
    IDocumentFullNameCompilationService
  );
begin

  inherited Create;

  FEmployeeIsSameAsOrReplacingForOthersSpecification :=
    EmployeeIsSameAsOrReplacingForOthersSpecification;

  FDocumentFullNameCompilationService :=
    DocumentFullNameCompilationService;
  
end;

procedure TStandardEmployeeDocumentWorkingRule.EnsureThatIsSatisfiedFor(
  Employee: TEmployee; Document: IDocument);
begin

  InternalEnsureThatIsSatisfiedFor(Employee, Document);
  
end;

procedure TStandardEmployeeDocumentWorkingRule.
  EnsureThatIsSatisfiedForEmployeeOnly(
    Employee: TEmployee;
    Document: IDocument
  );
begin

  InternalEnsureThatIsSatisfiedForEmployeeOnly(
    Employee, Document
  );
  
end;

function TStandardEmployeeDocumentWorkingRule.InternalIsSatisfiedBy(
  Employee: TEmployee;
  Document: IDocument
): Boolean;
begin

  try

    InternalEnsureThatIsSatisfiedFor(Employee, Document);

    Result := True;

  except

    on E: TDomainException do begin

      Result := False;

    end;

  end;

end;

function TStandardEmployeeDocumentWorkingRule.InternalIsSatisfiedForEmployeeOnly(
  Employee: TEmployee; Document: IDocument): Boolean;
begin

  try

    InternalEnsureThatIsSatisfiedForEmployeeOnly(
      Employee, Document
    );

    Result := True;

  except

    on E: TDomainException do begin

      Result := False;

    end;

  end;

end;

function TStandardEmployeeDocumentWorkingRule.IsSatisfiedBy(Employee: TEmployee;
  Document: IDocument): Boolean;
begin

  Result := InternalIsSatisfiedBy(Employee, Document);
  
end;

function TStandardEmployeeDocumentWorkingRule.
  IsSatisfiedForEmployeeOnly(
    Employee: TEmployee;
    Document: IDocument
  ): Boolean;
begin

  Result :=
    InternalIsSatisfiedForEmployeeOnly(
      Employee, Document
    );

end;

end.
