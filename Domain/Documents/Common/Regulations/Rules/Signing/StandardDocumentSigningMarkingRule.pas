{
  refactor: некоторая часть реализации дублирует реализацию правила подписания
  StandardDocumentSigningPerformingRule
}
unit StandardDocumentSigningMarkingRule;

interface

uses

  StandardEmployeeDocumentWorkingRule,
  DocumentDraftingRule,
  DocumentSigningMarkingRule,
  Employee,
  IDocumentUnit,
  EmployeeIsSameAsOrReplacingForOthersSpecification,
  DocumentFullNameCompilationService,
  DocumentApprovings,
  SysUtils;

type

  TStandardDocumentSigningMarkingRule =
    class abstract (
      TStandardEmployeeDocumentWorkingRule,
      IDocumentSigningMarkingRule
    )

      protected

        FDocumentDraftingRule: IDocumentDraftingRule;
        
        procedure InternalEnsureThatIsSatisfiedFor(
          Employee: TEmployee;
          Document: IDocument
        ); override;

        procedure InternalEnsureThatIsSatisfiedForEmployeeOnly(
          Employee: TEmployee;
          Document: IDocument
        ); override;

      protected

        procedure RaiseExceptionIfDocumentIsAtNotAllowedWorkCycleStage(
          Document: IDocument
        );

        procedure RaiseExceptionIfDocumentNotCorrectlyWritingForSigningMarking(
          Document: IDocument
        );

        procedure RaiseExceptionIfDocumentHasTheNotPerformedApprovings(
          Document: IDocument;
          SigningEmployee: TEmployee
        );

        procedure RaiseExceptionIfEmployeeHasNotRightsForDocumentMarkingAsSigned(
          Employee: TEmployee;
          Document: IDocument
        );
        
      protected

        function IsDocumentAtAllowedWorkCycleStage(Document: IDocument): Boolean;
        
        function HasEmployeeRightsForDocumentMarkingAsSigned(
          Employee: TEmployee;
          Document: IDocument;
          var FailMessage: String
        ): Boolean; virtual; 
        
      public

        constructor Create(
        
          EmployeeIsSameAsOrReplacingForOthersSpecification:
            IEmployeeIsSameAsOrReplacingForOthersSpecification;

          DocumentFullNameCompilationService:
            IDocumentFullNameCompilationService;

          DocumentDraftingRule: IDocumentDraftingRule
        );

        function CanEmployeeMarkDocumentAsSigned(
          Employee: TEmployee;
          Document: IDocument
        ): Boolean;

        function CouldEmployeeMarkDocumentAsSigned(
          Employee: TEmployee;
          Document: IDocument
        ): Boolean;

        procedure EnsureEmployeeCanMarkDocumentAsSigned(
          Employee: TEmployee;
          Document: IDocument
        );

        function HasEmployeeRightsForDocumentSigningMarking(
          Employee: TEmployee;
          Document: IDocument
        ): Boolean;

        procedure EnsureEmployeeHasRightsForDocumentSigningMarking(
          Employee: TEmployee;
          Document: IDocument
        );
    
    end;

  
implementation

uses

  Document;
  
{ TStandardDocumentSigningMarkingRule }

function TStandardDocumentSigningMarkingRule.CanEmployeeMarkDocumentAsSigned(
  Employee: TEmployee;
  Document: IDocument
): Boolean;
begin

  Result := InternalIsSatisfiedBy(Employee, Document);

end;

function TStandardDocumentSigningMarkingRule.CouldEmployeeMarkDocumentAsSigned(
  Employee: TEmployee; Document: IDocument): Boolean;
begin

  try

    RaiseExceptionIfEmployeeHasNotRightsForDocumentMarkingAsSigned(Employee, Document);

    Result := True;
    
  except

    on E: TDocumentSigningMarkingRuleException do Result := False;

  end;

end;

constructor TStandardDocumentSigningMarkingRule.Create(
  EmployeeIsSameAsOrReplacingForOthersSpecification: IEmployeeIsSameAsOrReplacingForOthersSpecification;
  DocumentFullNameCompilationService: IDocumentFullNameCompilationService;
  DocumentDraftingRule: IDocumentDraftingRule
);
begin

  inherited Create(
    EmployeeIsSameAsOrReplacingForOthersSpecification,
    DocumentFullNameCompilationService
  );

  FDocumentDraftingRule := DocumentDraftingRule;
  
end;

procedure TStandardDocumentSigningMarkingRule.EnsureEmployeeCanMarkDocumentAsSigned(
  Employee: TEmployee;
  Document: IDocument);
begin

  InternalEnsureThatIsSatisfiedFor(Employee, Document);

end;

procedure TStandardDocumentSigningMarkingRule.
  EnsureEmployeeHasRightsForDocumentSigningMarking(
    Employee: TEmployee;
    Document: IDocument
  );
begin

  InternalEnsureThatIsSatisfiedForEmployeeOnly(Employee, Document);

end;

function TStandardDocumentSigningMarkingRule
  .HasEmployeeRightsForDocumentMarkingAsSigned(
    Employee: TEmployee;
    Document: IDocument;
    var FailMessage: String
  ): Boolean;
begin

  Result :=
    TDocument(Document.Self)
      .Specifications
        .DocumentSigningSpecification
          .IsEmployeeAnyOfOnesCanMarkDocumentAsSigned(Employee, Document);

  if not Result then begin

    FailMessage :=
      Format(
        'У сотрудника "%s" отсутствуют права для ' +
        'того, чтобы отметить документ подписанным',
        [
          Employee.FullName
        ]
      );

  end;

end;

function TStandardDocumentSigningMarkingRule.
  HasEmployeeRightsForDocumentSigningMarking(
    Employee: TEmployee;
    Document: IDocument
  ): Boolean;
begin

  Result := InternalIsSatisfiedForEmployeeOnly(Employee, Document);
  
end;

procedure TStandardDocumentSigningMarkingRule.InternalEnsureThatIsSatisfiedFor(
  Employee: TEmployee;
  Document: IDocument
);
begin

  RaiseExceptionIfDocumentIsAtNotAllowedWorkCycleStage(Document);
  RaiseExceptionIfDocumentNotCorrectlyWritingForSigningMarking(Document);
  RaiseExceptionIfDocumentHasTheNotPerformedApprovings(Document, Employee);
  RaiseExceptionIfEmployeeHasNotRightsForDocumentMarkingAsSigned(Employee, Document);

end;

procedure TStandardDocumentSigningMarkingRule.
  InternalEnsureThatIsSatisfiedForEmployeeOnly(
    Employee: TEmployee;
    Document: IDocument
    );
begin

  RaiseExceptionIfDocumentIsAtNotAllowedWorkCycleStage(Document);
  RaiseExceptionIfEmployeeHasNotRightsForDocumentMarkingAsSigned(Employee, Document);
  
end;

procedure TStandardDocumentSigningMarkingRule.RaiseExceptionIfDocumentIsAtNotAllowedWorkCycleStage(
  Document: IDocument);
begin

  if not IsDocumentAtAllowedWorkCycleStage(Document) then begin

    raise TDocumentSigningMarkingRuleException.Create(
      'Документ не может быть отмечен подписанным, ' +
      'поскольку находится на недопустимой стадии рабочего цикла'
    );

  end;

end;

procedure TStandardDocumentSigningMarkingRule.
  RaiseExceptionIfDocumentNotCorrectlyWritingForSigningMarking(
    Document: IDocument
  );
begin

  FDocumentDraftingRule.EnsureThatDocumentDraftedCorrectlyForSigning(Document);

end;

procedure TStandardDocumentSigningMarkingRule.
RaiseExceptionIfDocumentHasTheNotPerformedApprovings(
  Document: IDocument;
  SigningEmployee: TEmployee
);
var
    DocumentApproving: TDocumentApproving;
begin

  for DocumentApproving in Document.Approvings do begin
  
    if not DocumentApproving.IsPerformed then begin

      raise TDocumentSigningMarkingRuleException.CreateFmt(
        'Сотрудник "%s" не может отметить документ, ' +
        'подписанным, поскольку не все согласованты ' +
        'приняли участие в его согласовании',
        [
          SigningEmployee.FullName
        ]
      );

    end;

  end;

end;

procedure TStandardDocumentSigningMarkingRule.
  RaiseExceptionIfEmployeeHasNotRightsForDocumentMarkingAsSigned(
    Employee: TEmployee;
    Document: IDocument
  );
var
    FailMessage: String;
begin

  if
    not
    HasEmployeeRightsForDocumentMarkingAsSigned(Employee, Document, FailMessage)
  then begin

    if Trim(FailMessage) <> '' then begin

      Raise TDocumentSigningMarkingRuleException.Create(FailMessage);

    end

    else begin

      Raise TDocumentSigningMarkingRuleException.CreateFmt(
        'У сотрудника "%s" отсутствуют права для ' +
        'того, чтобы отметить документ подписанным' ,
        [
          Employee.FullName
        ]
      );

    end;

  end;

end;

function TStandardDocumentSigningMarkingRule.IsDocumentAtAllowedWorkCycleStage(
  Document: IDocument
): Boolean;
begin

  Result := not (Document.IsSigned or Document.IsApproving or Document.IsRejectedFromSigning);
  
end;

end.
