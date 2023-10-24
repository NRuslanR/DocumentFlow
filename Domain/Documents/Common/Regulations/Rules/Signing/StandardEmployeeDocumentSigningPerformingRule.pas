unit StandardEmployeeDocumentSigningPerformingRule;

interface

uses

  EmployeeIsSameAsOrReplacingForOthersSpecification,
  DocumentFullNameCompilationService,
  StandardEmployeeDocumentWorkingRule,
  DocumentDraftingRule,
  DomainException,
  DocumentSigningPerformingRule,
  Employee,
  IDocumentUnit,
  SysUtils,
  Classes;

type

  TStandardEmployeeDocumentSigningPerformingRule =
    class (
      TInterfacedObject,
      IDocumentSigningPerformingRule
    )

      protected

        FEmployeeIsSameAsOrReplacingSignerForOthersSpecification:
          IEmployeeIsSameAsOrReplacingForOthersSpecification;

        FDocumentFullNameCompilationService:
          IDocumentFullNameCompilationService;

        FDocumentDraftingRule:
          IDocumentDraftingRule;

        procedure RaiseExceptionIfDocumentIsAtNotAllowedWorkCycleStage(
          Document: IDocument;
          Employee: TEmployee
        );

        procedure RaiseExceptionIfDocumentNotCorrectlyWritingForSigning(
          Document: IDocument;
          Employee: TEmployee
        );

        procedure RaiseExceptionIfDocumentHasTheNotPerformedApprovings(
          Document: IDocument;
          SigningEmployee: TEmployee
        );

        procedure RaiseExceptionIfSigningEmployeeTheSecretarySignerAndDocumentIsNotSelfRegistered(
          SigningEmployee: TEmployee;
          Document: IDocument
        );

        function GetRealFormalSignerForSigningEmployeeOrRaiseExceptionIfThisEmployeeHasNotRightsForDocumentSigning(
          Document: IDocument;
          FormalSigner: TEmployee;
          SigningEmployee: TEmployee
        ): TEmployee;

        function GetSubordinateDocumentSignerCountForEmployee(
          DocumentSigners: TEmployees;
          Employee: TEmployee
        ): Integer;

      public

        constructor Create(

          EmployeeIsSameAsOrDeputyOfEmployeesSpecification:
            IEmployeeIsSameAsOrReplacingForOthersSpecification;

          DocumentFullNameCompilationService:
            IDocumentFullNameCompilationService;

          DocumentDraftingRule:
            IDocumentDraftingRule
        );

        function EnsureThatEmployeeCanSignDocument(
          Document: IDocument;
          Employee: TEmployee
        ): TEmployee; virtual;

        function EnsureThatEmployeeCanSignDocumentOnBehalfOfOther(
          Document: IDocument;
          FormalSigner: TEmployee;
          SigningEmployee: TEmployee
        ): TEmployee; virtual;

        procedure EnsureThatEmployeeHasOnlyRightsForDocumentSigning(
          Employee: TEmployee;
          Document: IDocument
        ); virtual;

        procedure EnsureEmployeeAnyOfDocumentSigners(
          Employee: TEmployee;
          Document: IDocument
        );

        function CanEmployeeSignDocument(
          Document: IDocument;
          Employee: TEmployee
        ): Boolean; virtual;

        function IsEmployeeAnyOfDocumentSigners(
          Employee: TEmployee;
          Document: IDocument
        ): Boolean; virtual;

        function CanEmployeeSignDocumentOnBehalfOfOther(
          Document: IDocument;
          FormalSigner: TEmployee;
          SigningEmployee: TEmployee
        ): Boolean; virtual;

        function HasEmployeeOnlyRightsForDocumentSigning(
          Employee: TEmployee;
          Document: IDocument
        ): Boolean; virtual;

    end;

implementation

uses

  Document,
  DocumentApprovings,
  IDomainObjectUnit,
  IDomainObjectBaseUnit,
  IDomainObjectListUnit,
  DocumentSignings,
  AuxDebugFunctionsUnit;
  
{ TStandardEmployeeDocumentSigningPerformingRule }

function TStandardEmployeeDocumentSigningPerformingRule.
  CanEmployeeSignDocument(
    Document: IDocument;
    Employee: TEmployee
  ): Boolean;
begin

  try

    EnsureThatEmployeeCanSignDocument(Document, Employee);

    Result := True;

  except

    on e: TDomainException do begin

      Result := False;
      
    end;

  end;

end;

function TStandardEmployeeDocumentSigningPerformingRule.
  CanEmployeeSignDocumentOnBehalfOfOther(
    Document: IDocument;
    FormalSigner, SigningEmployee: TEmployee
  ): Boolean;
begin

  try

    EnsureThatEmployeeCanSignDocumentOnBehalfOfOther(
      Document, FormalSigner, SigningEmployee
    );

    Result := True;

  except

    on e: TDomainException do begin

      Result := False;
      
    end;
    
  end;

end;

function TStandardEmployeeDocumentSigningPerformingRule.IsEmployeeAnyOfDocumentSigners(
  Employee: TEmployee;
  Document: IDocument
): Boolean;
var
    ActualAssignedSigner: TEmployee;
    FreeEmployee: IDomainObjectBase;
begin

  try

    EnsureEmployeeAnyOfDocumentSigners(Employee, Document);

    Result := True;

  except

    on E: TDocumentSigningPerformingRuleException do Result := False;

  end;

end;

procedure TStandardEmployeeDocumentSigningPerformingRule.EnsureEmployeeAnyOfDocumentSigners(
  Employee: TEmployee;
  Document: IDocument
);
var
    ActualAssignedSigner: TEmployee;
    FreeEmployee: IDomainObjectBase;
begin

  ActualAssignedSigner :=

    GetRealFormalSignerForSigningEmployeeOrRaiseExceptionIfThisEmployeeHasNotRightsForDocumentSigning(
      Document, Employee, Employee
    );

  FreeEmployee := ActualAssignedSigner;

end;

constructor TStandardEmployeeDocumentSigningPerformingRule.Create(
  EmployeeIsSameAsOrDeputyOfEmployeesSpecification: IEmployeeIsSameAsOrReplacingForOthersSpecification;
  DocumentFullNameCompilationService: IDocumentFullNameCompilationService;
  DocumentDraftingRule: IDocumentDraftingRule
);
begin

  FEmployeeIsSameAsOrReplacingSignerForOthersSpecification :=
    EmployeeIsSameAsOrDeputyOfEmployeesSpecification;

  FDocumentFullNameCompilationService :=
    DocumentFullNameCompilationService;

  FDocumentDraftingRule :=
    DocumentDraftingRule;

end;

function TStandardEmployeeDocumentSigningPerformingRule.
  EnsureThatEmployeeCanSignDocument(
    Document: IDocument;
    Employee: TEmployee
  ): TEmployee;
begin

  Result :=
    EnsureThatEmployeeCanSignDocumentOnBehalfOfOther(
      Document, Employee, Employee
    );
  
end;

procedure TStandardEmployeeDocumentSigningPerformingRule.
  RaiseExceptionIfDocumentIsAtNotAllowedWorkCycleStage(
    Document: IDocument;
    Employee: TEmployee
  );
begin

  if Document.IsSigned then begin

    raise TDocumentSigningPerformingRuleException.CreateFmt(
            'Документ "%s" не может быть подписан ' +
            'сотрудником "%s", поскольку этот документ уже ' +
            'прошёл этап подписания',
            [
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              ),
              Employee.FullName
            ]
          );

  end;

  if Document.IsRejectedFromSigning then begin

    raise TDocumentSigningPerformingRuleException.CreateFmt(
      'Документ не может быть подписан ' +
      'сотрудником "%s", поскольку этот документ ' +
      'ранее был отклонен от подписания',
      [
        FDocumentFullNameCompilationService.CompileFullNameForDocument(
          Document
        ),
        Employee.FullName
      ]
    );

  end;


  if Document.IsApproving then begin

    raise TDocumentSigningPerformingRuleException.CreateFmt(
            'Документ "%s" не может быть подписан ' +
            'сотрудником "%s", поскольку этот документ ' +
            'находится на этапе согласования',
            [
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              ),
              Employee.FullName
            ]
          );

  end;
  
end;

procedure TStandardEmployeeDocumentSigningPerformingRule.
  RaiseExceptionIfDocumentNotCorrectlyWritingForSigning(
    Document: IDocument;
    Employee: TEmployee
  );
begin

  FDocumentDraftingRule.EnsureThatDocumentDraftedCorrectlyForSigning(Document);

end;

procedure TStandardEmployeeDocumentSigningPerformingRule.
  RaiseExceptionIfSigningEmployeeTheSecretarySignerAndDocumentIsNotSelfRegistered(
    SigningEmployee: TEmployee;
    Document: IDocument
  );
begin

  if SigningEmployee.IsSecretarySignerForTopLevelEmployee
     and not Document.IsSelfRegistered
  then begin

    raise TDocumentSigningPerformingRuleException.CreateFmt(
      'Секретарь-подписант "%s" не может подписать ' +
      'документ, поскольку он не отмечен, как ' +
      'зарегистрированный самостоятельно',
      [
        SigningEmployee.FullName
      ]
    );
  
  end;

end;

procedure TStandardEmployeeDocumentSigningPerformingRule.
RaiseExceptionIfDocumentHasTheNotPerformedApprovings(
  Document: IDocument;
  SigningEmployee: TEmployee
);
var DocumentApproving: TDocumentApproving;
begin

  for DocumentApproving in Document.Approvings do begin
  
    if not DocumentApproving.IsPerformed then begin

      raise TDocumentSigningPerformingRuleException.CreateFmt(
        'Сотрудник "%s" не может подписать документ, ' +
        'поскольку не все согласованты приняли участие в ' +
        'согласовании данного документа',
        [
          SigningEmployee.FullName
        ]
      );

    end;

  end;

end;

function TStandardEmployeeDocumentSigningPerformingRule.
  GetRealFormalSignerForSigningEmployeeOrRaiseExceptionIfThisEmployeeHasNotRightsForDocumentSigning(
    Document: IDocument;
    FormalSigner: TEmployee;
    SigningEmployee: TEmployee
  ): TEmployee;
var
    SpecificationResult: TEmployeeIsSameAsOrReplacingForOthersSpecificationResult;

    DocumentSigners: TEmployees;

    ReplaceableEmployeeFullNamesString: String;

    SubordinateDocumentSignerCount: Integer;

    ExceptionMessage: String;
begin

  SpecificationResult := nil;
  DocumentSigners := nil;

  try

    if
        not
        FEmployeeIsSameAsOrReplacingSignerForOthersSpecification.
          IsEmployeeSameAsOrReplacingForOtherEmployee(
            SigningEmployee, FormalSigner
          )

    then begin

      raise
        TDocumentSigningPerformingRuleException.CreateFmt(
          'Сотрудник "%s" не может подписать ' +
          'документ "%s" от имени "%s", поскольку ' +
          'для последнего первый не является ' +
          'исполняющим обязанности',
          [
            SigningEmployee.FullName,
            FDocumentFullNameCompilationService.CompileFullNameForDocument(
              Document
            ),
            FormalSigner.FullName
          ]
        );

    end;
    
    DocumentSigners := Document.FetchAllSigners;

    if not Assigned(DocumentSigners) then begin

      if not FormalSigner.IsSameAs(SigningEmployee) then begin

        ExceptionMessage :=
          Format(
            'Сотрудник "%s" не может подписать ' +
            'документ "%s" от имени "%s", поскольку ' +
            'для данного документа не было назначено ни ' +
            'одного подписанта',
            [
              SigningEmployee.FullName,
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              ),
              FormalSigner.FullName
            ]
          )

      end

      else begin

        ExceptionMessage :=
          Format(
            'Сотрудник "%s" не может подписать ' +
            'документ "%s", поскольку для данного ' +
            'документа не было назначено ни ' +
            'одного подписанта',
            [
              SigningEmployee.FullName,
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

      end;

      raise TDocumentSigningPerformingRuleException.Create(ExceptionMessage);

    end;

    TDocument(Document.Self)
      .Specifications
        .DocumentSigningSpecification
          .IsEmployeeAnyOfDocumentSigners(FormalSigner, Document, SpecificationResult);

    if not SpecificationResult.IsSatisfied then begin

      if FormalSigner.IsLeader then begin

        SubordinateDocumentSignerCount :=
          GetSubordinateDocumentSignerCountForEmployee(
            DocumentSigners, FormalSigner
          );

        if SubordinateDocumentSignerCount = 1 then begin

          Result := DocumentSigners[0];
          Exit;

        end;

        if SubordinateDocumentSignerCount > 1 then begin

          if not FormalSigner.IsSameAs(SigningEmployee) then begin

            ExceptionMessage :=
              Format(
                'Неодназначность. Сотрудник ' +
                '"%s" не может подписать документ "%s" ' +
                'от имени "%s", поскольку последний ' +
                ' является руководителем ' +
                'для нескольких подписантов',
                [
                  SigningEmployee.FullName,
                  FDocumentFullNameCompilationService.
                    CompileFullNameForDocument(Document),
                  FormalSigner.FullName
                ]
              )

          end

          else begin

            ExceptionMessage :=
              Format(
                'Неодназначность. Сотрудник ' +
                '"%s" является руководителем ' +
                'для нескольких подписантов',
                [SigningEmployee.FullName]
              );

          end;

          raise TDocumentSigningPerformingRuleException.Create(ExceptionMessage);

        end;

      end;

      if not FormalSigner.IsSameAs(SigningEmployee) then begin

        ExceptionMessage :=
          Format(
            'Сотрудник "%s" не может подписать ' +
            'документ "%s" от имени "%s", ' +
            'поскольку последний не ' +
            'имеет соответствующих полномочий',
            [
              SigningEmployee.FullName,
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              ),
              FormalSigner.FullName
            ]
          )

      end

      else begin

        ExceptionMessage :=
          Format(
            'Сотрудник "%s" не может подписать ' +
            'документ "%s", поскольку он не ' +
            'имеет соответствующих полномочий',
            [
              FormalSigner.FullName,
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

      end;
      
      raise TDocumentSigningPerformingRuleException.Create(ExceptionMessage);

    end;

    if SpecificationResult.IsReplaceableEmployeeCountMoreThanOne then begin

      ReplaceableEmployeeFullNamesString :=
        SpecificationResult.FetchReplaceableEmployeeFullNamesString;

      if not FormalSigner.IsSameAs(SigningEmployee) then begin

        ExceptionMessage :=
          Format(
            'Неодназначность. Сотрудник "%s" ' +
            'не может подписать документ "%s" ' +
            'от имени "%s", поскольку последний ' +
            'является исполняющим обязанности ' +
            'для следующих назначенных ' +
            'подписантов:' + sLineBreak +
            ReplaceableEmployeeFullNamesString,
            [
              SigningEmployee.FullName,
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              ),
              FormalSigner.FullName
            ]
          )

      end

      else begin

        ExceptionMessage :=
          Format(
            'Неодназначность. Сотрудник "%s" ' +
            'является исполняющим обязанности ' +
            'для следующих назначенных ' +
            'подписантов:' + sLineBreak +
            ReplaceableEmployeeFullNamesString,
            [
              SigningEmployee.FullName
            ]
          );

      end;

      raise TDocumentSigningPerformingRuleException.Create(ExceptionMessage);
            
    end

    else if not FormalSigner.IsSameAs(SigningEmployee) then begin

      if not Assigned(SpecificationResult.ReplaceableEmployees) then
        Result := FormalSigner

      else begin

        raise
          TDocumentSigningPerformingRuleException.CreateFmt(
            'Сотрудник "%s" не может подписать ' +
            'документ "%s" от имени "%s", поскольку ' +
            'последний не был назначен ' +
            'подписантом для этого документа',
            [
              SigningEmployee.FullName,
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              ),
              FormalSigner.FullName
            ]
          );

      end;

    end

    else if Assigned(SpecificationResult.ReplaceableEmployees) then
      Result := SpecificationResult.ReplaceableEmployees[0].Clone as TEmployee

    else Result := FormalSigner;

  finally

    FreeAndNil(SpecificationResult);
    FreeAndNil(DocumentSigners);

  end;

end;

function TStandardEmployeeDocumentSigningPerformingRule.
  EnsureThatEmployeeCanSignDocumentOnBehalfOfOther(
    Document: IDocument;
    FormalSigner, SigningEmployee: TEmployee
  ): TEmployee;
begin

  RaiseExceptionIfDocumentNotCorrectlyWritingForSigning(
    Document, SigningEmployee
  );

  RaiseExceptionIfDocumentHasTheNotPerformedApprovings(
    Document, SigningEmployee
  );
  
  RaiseExceptionIfDocumentIsAtNotAllowedWorkCycleStage(
    Document, SigningEmployee
  );

  Result :=

    GetRealFormalSignerForSigningEmployeeOrRaiseExceptionIfThisEmployeeHasNotRightsForDocumentSigning(
      Document, FormalSigner, SigningEmployee
    );

end;

procedure TStandardEmployeeDocumentSigningPerformingRule.
  EnsureThatEmployeeHasOnlyRightsForDocumentSigning(
    Employee: TEmployee;
    Document: IDocument
  );
var ActualAssignedSigner: TEmployee;
    FreeEmployee: IDomainObject;
begin

  RaiseExceptionIfDocumentIsAtNotAllowedWorkCycleStage(
    Document, Employee
  );
  
  ActualAssignedSigner :=

    GetRealFormalSignerForSigningEmployeeOrRaiseExceptionIfThisEmployeeHasNotRightsForDocumentSigning(
      Document, Employee, Employee
    );

  FreeEmployee := ActualAssignedSigner;

end;

function TStandardEmployeeDocumentSigningPerformingRule.
GetSubordinateDocumentSignerCountForEmployee(
  DocumentSigners: TEmployees;
  Employee: TEmployee
): Integer;

var DocumentSigner: TEmployee;
begin

  Result := 0;

  for DocumentSigner in DocumentSigners do
    if DocumentSigner.IsSubLeaderFor(Employee)
    then Inc(Result);

end;

function TStandardEmployeeDocumentSigningPerformingRule.
  HasEmployeeOnlyRightsForDocumentSigning(
    Employee: TEmployee;
    Document: IDocument
  ): Boolean;
begin

  try

    EnsureThatEmployeeHasOnlyRightsForDocumentSigning(
      Employee, Document
    );

    Result := True;
    
  except

    Result := False;
    
  end;

end;

end.
