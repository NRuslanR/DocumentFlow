unit StandardDocumentPerformingRule;

interface

uses

  Employee,
  IDocumentUnit,
  DocumentPerformingRule,
  EmployeeIsSameAsOrReplacingForOthersSpecification,
  DocumentFullNameCompilationService,
  SysUtils,
  Classes;

type

  TStandardDocumentPerformingRule =
    class (TInterfacedObject, IDocumentPerformingRule)

      protected

        FEmployeeIsSameAsOrReplacingForOthersSpecification:
          IEmployeeIsSameAsOrReplacingForOthersSpecification;

        FDocumentFullNameCompilationService:
          IDocumentFullNameCompilationService;
          
        procedure RaiseExceptionIfDocumentAlreadyPerformed(
          Document: IDocument
        );

        procedure RaiseExceptionIfFormalPerformerHasNotRightsForChargePerforming(
          Document: IDocument;
          FormalPerformer: TEmployee;
          ActuallyPerformedEmployee: TEmployee
        );

      public

        constructor Create(

          EmployeeIsSameAsOrReplacingForOthersSpecification:
            IEmployeeIsSameAsOrReplacingForOthersSpecification;

          DocumentFullNameCompilationService:
            IDocumentFullNameCompilationService

        );

        procedure EnsureThatDocumentMayBeMarkedAsPerformed(
          Document: IDocument;
          FormalPerformer: TEmployee;
          ActuallyPerformedEmployee: TEmployee
        );

        function MayDocumentBeMarkedAsPerformed(
          Document: IDocument;
          FormalPerformer: TEmployee;
          ActuallyPerformedEmployee: TEmployee
        ): Boolean;
        
    end;
    
implementation

{ TStandardDocumentPerformingRule }

constructor TStandardDocumentPerformingRule.Create(

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

procedure TStandardDocumentPerformingRule.
  EnsureThatDocumentMayBeMarkedAsPerformed(
    Document: IDocument;
    FormalPerformer: TEmployee;
    ActuallyPerformedEmployee: TEmployee
  );
begin

  RaiseExceptionIfDocumentAlreadyPerformed(Document);
  RaiseExceptionIfFormalPerformerHasNotRightsForChargePerforming(
    Document, FormalPerformer, ActuallyPerformedEmployee
  );

end;

function TStandardDocumentPerformingRule.
  MayDocumentBeMarkedAsPerformed(
    Document: IDocument;
    FormalPerformer, ActuallyPerformedEmployee: TEmployee
  ): Boolean;
begin

  try

    EnsureThatDocumentMayBeMarkedAsPerformed(
      Document, FormalPerformer, ActuallyPerformedEmployee
    );

    Result := True;
    
  except

    on e: TDocumentPerformingRuleException do begin

      Result := False;
      
    end;

  end;

end;

procedure TStandardDocumentPerformingRule.
  RaiseExceptionIfDocumentAlreadyPerformed(
    Document: IDocument
  );
begin

  if Document.IsPerformed then begin
  
    raise TDocumentPerformingRuleException.CreateFmt(
            'Документ "%s" уже исполнен, поэтому ' +
            'ни один сотрудник уже не может ' +
            'быть отмечен, как исполнивший ' +
            'поручение по данному документу',
            [
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

  end;

end;

procedure TStandardDocumentPerformingRule.
  RaiseExceptionIfFormalPerformerHasNotRightsForChargePerforming(
    Document: IDocument;
    FormalPerformer: TEmployee;
    ActuallyPerformedEmployee: TEmployee
  );
var DocumentPerformers: TEmployees;
    SpecificationResult:
      TEmployeeIsSameAsOrReplacingForOthersSpecificationResult;
begin

  DocumentPerformers := nil;
  SpecificationResult := nil;

  try

    if
        not
        FEmployeeIsSameAsOrReplacingForOthersSpecification.
          IsEmployeeSameAsOrReplacingForOtherEmployee(
            ActuallyPerformedEmployee, FormalPerformer
          )

    then begin

      Raise TDocumentPerformingRuleException.CreateFmt(
              'Сотрудник "%s" не может быть ' +
              'отмечен, как исполнивший ' +
              'поручение по документу "%s" ' +
              'от имени "%s", поскольку ' +
              'для последнего первый не ' +
              'является исполняющим ' +
              'обязанности',
              [
                ActuallyPerformedEmployee.FullName,
                FDocumentFullNameCompilationService.CompileFullNameForDocument(
                  Document
                ),
                FormalPerformer.FullName
              ]
            );

    end;

    DocumentPerformers := Document.FetchAllPerformers;

    SpecificationResult :=
      FEmployeeIsSameAsOrReplacingForOthersSpecification.
        IsEmployeeSameAsOrReplacingForAnyOfEmployees(
          FormalPerformer, DocumentPerformers
        );

    if
      (not SpecificationResult.IsSatisfied) or
      (SpecificationResult.ReplaceableEmployeeCount > 0)
    then begin

      if FormalPerformer.IsSameAs(ActuallyPerformedEmployee) then begin

        raise TDocumentPerformingRuleException.CreateFmt(
                'Сотрудник "%s" не может быть ' +
                'отмечен, как исполнивший ' +
                'поручение по документу "%s", ' +
                'поскольку ни одно из поручений ' +
                'не было ему назначено',
                [
                  ActuallyPerformedEmployee.FullName,
                  FDocumentFullNameCompilationService.
                    CompileFullNameForDocument(
                      Document
                    )
                ]
              )

      end

      else begin

        raise TDocumentPerformingRuleException.CreateFmt(
                'Сотрудник "%s" не может быть ' +
                'отмечен, как исполнивший ' +
                'поручение по документу "%s" ' +
                'от имени "%s", поскольку ' +
                'последнему не было назначено ' +
                'ни одно поручение по данному ' +
                'документу',
                [
                  ActuallyPerformedEmployee.FullName,
                  FDocumentFullNameCompilationService.
                    CompileFullNameForDocument(
                      Document
                    ),
                  FormalPerformer.FullName
                ]
              );

      end;

    end

  finally

    FreeAndNil(SpecificationResult);
    FreeAndNil(DocumentPerformers);

  end;

end;

end.
