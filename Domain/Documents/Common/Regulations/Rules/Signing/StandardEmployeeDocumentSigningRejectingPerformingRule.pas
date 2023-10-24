unit StandardEmployeeDocumentSigningRejectingPerformingRule;

interface

uses

  StandardEmployeeDocumentWorkingRule,
  EmployeeDocumentWorkingRule,
  EmployeeIsSameAsOrReplacingForOthersSpecification,
  DocumentFullNameCompilationService,
  IDocumentUnit,
  DomainException,
  DocumentSigningRejectingPerformingRule,
  Employee,
  SysUtils,
  Classes;

type

  TStandardEmployeeDocumentSigningRejectingPerformingRule =
    class (
      TInterfacedObject,
      IDocumentSigningRejectingPerformingRule
    )

      protected

        FEmployeeIsSameAsOrReplacingForOthersSpecification:
          IEmployeeIsSameAsOrReplacingForOthersSpecification;

        FDocumentFullNameCompilationService:
          IDocumentFullNameCompilationService;

        function GetSubordinateDocumentSignerCountForEmployee(
          DocumentSigners: TEmployees;
          Employee: TEmployee
        ): Integer;
        
        procedure RaiseExceptionIfDocumentIsAtNotAllowedWorkCycleStage(
          Document: IDocument;
          Employee: TEmployee
        );

        procedure RaiseExceptionIfDocumentWasSignedEarlierByRealFormalSignerOrRejectingEmployee(
          Document: IDocument;
          RealFormalSigner: TEmployee;
          RejectingEmployee: TEmployee
        );
        
        function GetRealFormalSignerForRejectingEmployeeOrRaiseExceptionIfThisEmployeeHasNotRightsForDocumentSigningRejecting(
          Document: IDocument;
          FormalSigner: TEmployee;
          RejectingEmployee: TEmployee
        ): TEmployee; virtual;

        procedure RaiseExceptionIfRejectingEmployeeIsNotReplacingForFormalSigner(
          RejectingEmployee, FormalSigner: TEmployee;
          Document: IDocument
        );
        
      public

        constructor Create(
        
          EmployeeIsSameAsOrReplacingForOthersSpecification:
            IEmployeeIsSameAsOrReplacingForOthersSpecification;

          DocumentFullNameCompilationService:
            IDocumentFullNameCompilationService
        );

        function EnsureThatEmployeeCanRejectSigningDocument(
          Document: IDocument;
          Employee: TEmployee
        ): TEmployee; virtual;

        function EnsureThatEmployeeCanRejectSigningDocumentOnBehalfOfOther(
          Document: IDocument;
          FormalSigner: TEmployee;
          RejectingEmployee: TEmployee
        ): TEmployee; virtual;

        procedure EnsureThatEmployeeHasOnlyRightsForDocumentSigningRejecting(
          Employee: TEmployee;
          Document: IDocument
        ); virtual;
        
        function CanEmployeeRejectSigningDocument(
          Document: IDocument;
          Employee: TEmployee
        ): Boolean; virtual;

        function CanEmployeeRejectSigningDocumentOnBehalfOfOther(
          Document: IDocument;
          FormalSigner: TEmployee;
          SigningEmployee: TEmployee
        ): Boolean; virtual;

        function HasEmployeeOnlyRightsForDocumentSigningRejecting(
          Employee: TEmployee;
          Document: IDocument
        ): Boolean; virtual;

    end;
    
implementation

uses

  Document,
  IDomainObjectUnit;
  
{ TStandardEmployeeDocumentSigningRejectingPerformingRule }

function TStandardEmployeeDocumentSigningRejectingPerformingRule.
  CanEmployeeRejectSigningDocument(
    Document: IDocument;
    Employee: TEmployee
  ): Boolean;
begin

  try

    EnsureThatEmployeeCanRejectSigningDocument(Document, Employee);

    Result := True;

  except

    on e: TDomainException do begin

      Result := False;
      
    end;

  end;

end;

function TStandardEmployeeDocumentSigningRejectingPerformingRule.
  CanEmployeeRejectSigningDocumentOnBehalfOfOther(
    Document: IDocument;
    FormalSigner, SigningEmployee: TEmployee
  ): Boolean;
begin

  try

    EnsureThatEmployeeCanRejectSigningDocumentOnBehalfOfOther(
      Document, FormalSigner, SigningEmployee
    );

    Result := True;
    
  except

    on e: TDomainException do begin

      Result := False;
      
    end;

  end;

end;

constructor TStandardEmployeeDocumentSigningRejectingPerformingRule.Create(
  EmployeeIsSameAsOrReplacingForOthersSpecification:
    IEmployeeIsSameAsOrReplacingForOthersSpecification;

  DocumentFullNameCompilationService:
    IDocumentFullNameCompilationService
  );
begin

  FEmployeeIsSameAsOrReplacingForOthersSpecification :=
    EmployeeIsSameAsOrReplacingForOthersSpecification;

  FDocumentFullNameCompilationService :=
    DocumentFullNameCompilationService;

end;

function TStandardEmployeeDocumentSigningRejectingPerformingRule.
  EnsureThatEmployeeCanRejectSigningDocumentOnBehalfOfOther(
    Document: IDocument;
    FormalSigner, RejectingEmployee: TEmployee
  ): TEmployee;
begin

  RaiseExceptionIfDocumentIsAtNotAllowedWorkCycleStage(Document, RejectingEmployee);

  Result :=

    GetRealFormalSignerForRejectingEmployeeOrRaiseExceptionIfThisEmployeeHasNotRightsForDocumentSigningRejecting(
      Document, FormalSigner, RejectingEmployee
    );

  RaiseExceptionIfDocumentWasSignedEarlierByRealFormalSignerOrRejectingEmployee(
    Document, Result, RejectingEmployee
  );

end;

procedure TStandardEmployeeDocumentSigningRejectingPerformingRule.
  EnsureThatEmployeeHasOnlyRightsForDocumentSigningRejecting(
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

    GetRealFormalSignerForRejectingEmployeeOrRaiseExceptionIfThisEmployeeHasNotRightsForDocumentSigningRejecting(
      Document, Employee, Employee
    );

  FreeEmployee := ActualAssignedSigner;

end;

function TStandardEmployeeDocumentSigningRejectingPerformingRule.
  GetSubordinateDocumentSignerCountForEmployee(
    DocumentSigners: TEmployees;
    Employee: TEmployee
  ): Integer;
var DocumentSigner: TEmployee;
begin

  Result := 0;

  for DocumentSigner in DocumentSigners do
    if DocumentSigner.IsSubLeaderFor(Employee) then
      Inc(Result);
    
end;

function TStandardEmployeeDocumentSigningRejectingPerformingRule.
  HasEmployeeOnlyRightsForDocumentSigningRejecting(
    Employee: TEmployee;
    Document: IDocument
  ): Boolean;
begin

  try

    EnsureThatEmployeeHasOnlyRightsForDocumentSigningRejecting(
      Employee, Document
    );

    Result := True;
    
  except

    Result := False;

  end;

end;

function TStandardEmployeeDocumentSigningRejectingPerformingRule.
  EnsureThatEmployeeCanRejectSigningDocument(
    Document: IDocument;
    Employee: TEmployee
  ): TEmployee;
begin

  Result :=
    EnsureThatEmployeeCanRejectSigningDocumentOnBehalfOfOther(
      Document, Employee, Employee
    );
  
end;

procedure TStandardEmployeeDocumentSigningRejectingPerformingRule.
  RaiseExceptionIfDocumentIsAtNotAllowedWorkCycleStage(
    Document: IDocument;
    Employee: TEmployee
  );
begin

  if Document.IsSigned then begin

    raise TDocumentSigningRejectingPerformingRuleException.CreateFmt(
            'Сотрудник "%s" не может отклонить ' +
            'подписание документа "%s", ' +
            'поскольку этот документ уже прошёл ' +
            'этап подписания',
            [
              Employee.FullName,
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

  end;
  
  if Document.IsRejectedFromSigning then begin

    raise TDocumentSigningRejectingPerformingRuleException.CreateFmt(
            'Сотрудник "%s" не может отклонить ' +
            'подписание документа "%s", ' +
            'поскольку этот документ уже был ' +
            'отклонён ранее',
            [
              Employee.FullName,
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

  end;

  if not Document.IsSentToSigning then begin

    raise TDocumentSigningRejectingPerformingRuleException.CreateFmt(
            'Сотрудник "%s" не может отклонить ' +
            'подписание документа "%s", ' +
            'поскольку данный документ ' +
            'не находится на этапе подписания',
            [
              Employee.FullName,
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

  end;

  if Document.IsApproving then begin

    raise TDocumentSigningRejectingPerformingRuleException.CreateFmt(
      'Сотрудник "%s" не может отклонить ' +
      'подписание документа, поскольку ' +
      'последний находится на согласовании',
      [
        Employee.FullName
      ]
    );

  end;
   
end;

procedure TStandardEmployeeDocumentSigningRejectingPerformingRule.
  RaiseExceptionIfDocumentWasSignedEarlierByRealFormalSignerOrRejectingEmployee(
    Document: IDocument;
    RealFormalSigner, RejectingEmployee: TEmployee
  );
begin

  if Document.IsSignedBy(RealFormalSigner) or
     Document.IsSignedBy(RejectingEmployee)
  then
    raise
      TDocumentSigningRejectingPerformingRuleException.CreateFmt(
        'Нельзя отклонить подписание ' +
        'документа "%s" от имени "%s", ' +
        'поскольку для последнего уже ' +
        'стоит подпись',
        [
          FDocumentFullNameCompilationService.CompileFullNameForDocument(
            Document
          ),
          RealFormalSigner.FullName
        ]
      );
      
end;

procedure TStandardEmployeeDocumentSigningRejectingPerformingRule.
  RaiseExceptionIfRejectingEmployeeIsNotReplacingForFormalSigner(
    RejectingEmployee, FormalSigner: TEmployee;
    Document: IDocument
  );
begin

  if
    not
    FEmployeeIsSameAsOrReplacingForOthersSpecification
      .IsEmployeeSameAsOrReplacingForOtherEmployee(
        RejectingEmployee, FormalSigner
      )
  then begin

    Raise TDocumentSigningRejectingPerformingRuleException.CreateFmt(
      'Сотрудник "%s" не может отклонить ' +
      'подписание документа "%s" от имени ' +
      '"%s", поскольку для последнего ' +
      'первый не является исполняющим ' +
      'обязанности',
      [
        RejectingEmployee.FullName,
        FDocumentFullNameCompilationService.CompileFullNameForDocument(
          Document
        ),
        FormalSigner.FullName
      ]
    );

  end;

end;

function TStandardEmployeeDocumentSigningRejectingPerformingRule.
  GetRealFormalSignerForRejectingEmployeeOrRaiseExceptionIfThisEmployeeHasNotRightsForDocumentSigningRejecting(
    Document: IDocument;
    FormalSigner: TEmployee;
    RejectingEmployee: TEmployee
  ): TEmployee;
var

    DocumentSigners: TEmployees;

    SpecificationResult:
      TEmployeeIsSameAsOrReplacingForOthersSpecificationResult;

    ReplaceableEmployeeFullNamesString: String;

    SubordinateDocumentSignerCount: Integer;

    ExceptionMessage: String;
begin


  SpecificationResult := nil;

  { refactor: логика этого метода дублирует логику
    метода в объекте-правиле подписания документа }
  try

    RaiseExceptionIfRejectingEmployeeIsNotReplacingForFormalSigner(
      RejectingEmployee, FormalSigner, Document
    );

    DocumentSigners := Document.FetchAllSigners;

    if not Assigned(DocumentSigners) then begin

      if not FormalSigner.IsSameAs(RejectingEmployee) then
        ExceptionMessage :=
          Format(
            'Сотрудник "%s" не может отклонить ' +
            'подписание документа "%s" от имени "%s", ' +
            'поскольку для данного документа не было ' +
            'назначено ни одного подписанта',
            [
              RejectingEmployee.FullName,
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              ),
              FormalSigner
            ]
          )

      else
        ExceptionMessage :=
          Format(
            'Сотрудник "%s" не может отклонить ' +
            'подписание документа "%s", поскольку ' +
            'для данного документа не было ' +
            'назначено ни одного подписанта',
            [
              RejectingEmployee.FullName,
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

      raise TDocumentSigningRejectingPerformingRuleException.Create(ExceptionMessage);

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

          if not FormalSigner.IsSameAs(RejectingEmployee) then
            ExceptionMessage :=
              Format(
                'Неоднозначность. Сотрудник "%s" ' +
                'не может отклонить подписание документа "%s", ' +
                'от имени "%s", поскольку последний ' +
                'является руководителем ' +
                'для нескольких подписантов',
                [
                  RejectingEmployee.FullName,
                  FDocumentFullNameCompilationService.CompileFullNameForDocument(
                    Document
                  ),
                  FormalSigner.FullName
                ]
              )

          else
            ExceptionMessage :=
              Format(
                'Неоднозначность. Сотрудник "%s" ' +
                'не может отклонить подписание документа "%s", ' +
                'поскольку является ' +
                'руководителем для нескольких ' +
                'подписантов',
                [
                  RejectingEmployee.FullName,
                  FDocumentFullNameCompilationService.CompileFullNameForDocument(
                    Document
                  )
                ]
              );

          raise TDocumentSigningRejectingPerformingRuleException.Create(ExceptionMessage);

        end;

      end;

      if not FormalSigner.IsSameAs(RejectingEmployee) then
        ExceptionMessage :=
          Format(
            'Сотрудник "%s" не может отклонить ' +
            'подписание документа "%s" от имени "%s", ' +
            'поскольку последний не имеет ' +
            'соответствующих полномочий',
            [
              RejectingEmployee.FullName,
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              ),
              FormalSigner.FullName
            ]
          )

      else
        ExceptionMessage :=
          Format(
            'Сотрудник "%s" не может отклонить ' +
            'подписание документа "%s", ' +
            'поскольку не имеет соответствующих ' +
            'полномочий',
            [
              RejectingEmployee.FullName,
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                  Document
              )
            ]
          );

      raise TDocumentSigningRejectingPerformingRuleException.Create(ExceptionMessage);

    end;

    if SpecificationResult.IsReplaceableEmployeeCountMoreThanOne then begin

      ReplaceableEmployeeFullNamesString :=
        SpecificationResult.FetchReplaceableEmployeeFullNamesString;

      if not FormalSigner.IsSameAs(RejectingEmployee) then
        ExceptionMessage :=
          Format(
            'Неодназначность. Сотрудник "%s" ' +
            'не может отклонить подписание ' +
            'документа "%s" от имени "%s", ' +
            'поскольку последний является ' +
            'исполняющим обязанности для ' +
            'следующих назначенных подписантов:' +
            sLineBreak +
            ReplaceableEmployeeFullNamesString,
            [
              RejectingEmployee.FullName,
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              ),
              FormalSigner.FullName
            ]
          )

      else
        ExceptionMessage :=
          Format(
            'Неодназначность. Сотрудник "%s" ' +
            'является исполняющим обязанности ' +
            'для следующих назначенных ' +
            'подписантов:' + sLineBreak +
            ReplaceableEmployeeFullNamesString,
            [
              RejectingEmployee.FullName
            ]
          );
      
      raise TDocumentSigningRejectingPerformingRuleException.Create(ExceptionMessage);
      
    end

    else if not FormalSigner.IsSameAs(RejectingEmployee) then begin

      if not Assigned(SpecificationResult.ReplaceableEmployees) then
        Result := FormalSigner

      else
        raise
          TDocumentSigningRejectingPerformingRuleException.CreateFmt(
            'Сотрудник "%s" не может отклонить ' +
            'подписание документа "%s" от имени ' +
            '"%s", поскольку последний не был ' +
            'назначен формальным подписантом ' +
            'документа',
            [
              RejectingEmployee.FullName,
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              ),
              FormalSigner.FullName
            ]
          );
      
    end

    else if Assigned(SpecificationResult.ReplaceableEmployees) then
      Result := SpecificationResult.ReplaceableEmployees[0].Clone as TEmployee

    else Result := FormalSigner;

  finally

    FreeAndNil(DocumentSigners);
    FreeAndNil(SpecificationResult);
    
  end;
  
end;

end.
