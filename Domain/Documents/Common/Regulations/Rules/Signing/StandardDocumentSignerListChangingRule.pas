unit StandardDocumentSignerListChangingRule;

interface

uses

  EmployeeIsSameAsOrReplacingForOthersSpecification,
  DocumentSignerListChangingRule,
  DocumentFullNameCompilationService,
  AreEmployeesSubLeadersOfSameLeaderSpecification,
  AreEmployeesSecretariesOfSameLeaderSpecification,
  EmployeeIsLeaderForOtherSpecification,
  EmployeesWorkGroupMembershipSpecification,
  Disposable,
  IDocumentUnit,
  Employee,
  SysUtils,
  Classes;

type

  TStandardEmployeeDocumentSignerListChangingRule =
    class (TInterfacedObject, IDocumentSignerListChangingRule)

      protected

        FDocumentFullNameCompilationService:
          IDocumentFullNameCompilationService;

        FEmployeeIsSameAsOrReplacingForOthersSpecification:
          IEmployeeIsSameAsOrReplacingForOthersSpecification;

        FAreEmployeesSubLeadersOfSameLeaderSpecification:
          IAreEmployeesSubLeadersOfSameLeaderSpecification;

        FAreEmployeesSecretariesOfSameLeaderSpecification:
          IAreEmployeesSecretariesOfSameLeaderSpecification;

        FEmployeeIsLeaderForOtherSpecification:
          IEmployeeIsLeaderForOtherSpecification;

        FEmployeesWorkGroupMembershipSpecification:
          IEmployeesWorkGroupMembershipSpecification;

      protected

        procedure RaiseSignerAssigningExceptionIfDocumentIsAtNotAllowedWorkCycleStage(
          Document: IDocument
        ); virtual;

        procedure RaiseSignerAssigningExceptionIfEmployeeHasNotRightsForAssigningAsSigner(
          Signer: TEmployee;
          Document: IDocument;
          AssigningEmployee: TEmployee
        ); virtual;

        procedure RaiseSignerAssigningExceptionIfSignerAlreadyAssignedAsPerformer(
          Signer: TEmployee;
          Document: IDocument;
          AssigningEmployee: TEmployee
        ); virtual;

        procedure RaiseSignerAssigningExceptionIfSignerIsNotLeaderForAssigningEmployee(
          Signer: TEmployee;
          Document: IDocument;
          AssigningEmployee: TEmployee
        ); virtual;

        procedure RaiseExceptionIfEmployeeHasNotRightsForSignerListChanging(
          Employee: TEmployee;
          Document: IDocument
        ); virtual;

      protected

        function IsEmployeeWorkGroupLeaderForOtherEmployee(
          Suggestedleader: TEmployee;
          OtherEmployee: TEmployee
        ): Boolean;
        
      protected

        procedure RaiseExceptionIfDocumentAlreadySignedByEmployee(
          Document: IDocument;
          Employee: TEmployee
        );

        procedure RaiseSignerAssigningExceptionIfEmployeeAlreadyAssignedAsSigner(
          Signer: TEmployee;
          Document: IDocument;
          AssigningEmployee: TEmployee
        );

      public

        constructor Create(

          DocumentFullNameCompilationService:
            IDocumentFullNameCompilationService;

          EmployeeIsSameAsOrReplacingForOthersSpecification:
            IEmployeeIsSameAsOrReplacingForOthersSpecification;

          AreEmployeesSubLeadersOfSameLeaderSpecification:
            IAreEmployeesSubLeadersOfSameLeaderSpecification;

          AreEmployeesSecretariesOfSameLeaderSpecification:
            IAreEmployeesSecretariesOfSameLeaderSpecification;

          EmployeeIsLeaderForOtherSpecification:
            IEmployeeIsLeaderForOtherSpecification;

          EmployeesWorkGroupMembershipSpecification:
            IEmployeesWorkGroupMembershipSpecification

        );

        procedure EnsureThatEmployeeMayAssignDocumentSigner(
          Employee: TEmployee;
          Document: IDocument;
          Signer: TEmployee
        );

        procedure EnsureThatEmployeeMayRemoveDocumentSigner(
          Employee: TEmployee;
          Document: IDocument;
          Signer: TEmployee
        );

        function MayEmployeeAssignDocumentSigner(
          Employee: TEmployee;
          Document: IDocument;
          Signer: TEmployee
        ): Boolean;

        function MayEmployeeRemoveDocumentSigner(
          Employee: TEmployee;
          Document: IDocument;
          Signer: TEmployee
        ): Boolean;

    end;

implementation

uses

  IDomainObjectBaseListUnit,
  Document,
  DocumentSignings;

{ TStandardEmployeeDocumentSignerListChangingRule }

constructor TStandardEmployeeDocumentSignerListChangingRule.Create(

  DocumentFullNameCompilationService:
    IDocumentFullNameCompilationService;

  EmployeeIsSameAsOrReplacingForOthersSpecification:
    IEmployeeIsSameAsOrReplacingForOthersSpecification;

  AreEmployeesSubLeadersOfSameLeaderSpecification:
    IAreEmployeesSubLeadersOfSameLeaderSpecification;

  AreEmployeesSecretariesOfSameLeaderSpecification:
    IAreEmployeesSecretariesOfSameLeaderSpecification;

  EmployeeIsLeaderForOtherSpecification:
    IEmployeeIsLeaderForOtherSpecification;

  EmployeesWorkGroupMembershipSpecification:
    IEmployeesWorkGroupMembershipSpecification

);
begin

  inherited Create;

  FDocumentFullNameCompilationService :=
    DocumentFullNameCompilationService;

  FEmployeeIsSameAsOrReplacingForOthersSpecification :=
    EmployeeIsSameAsOrReplacingForOthersSpecification;

  FAreEmployeesSubLeadersOfSameLeaderSpecification :=
    AreEmployeesSubLeadersOfSameLeaderSpecification;

  FAreEmployeesSecretariesOfSameLeaderSpecification :=
    AreEmployeesSecretariesOfSameLeaderSpecification;

  FEmployeeIsLeaderForOtherSpecification :=
    EmployeeIsLeaderForOtherSpecification;

  FEmployeesWorkGroupMembershipSpecification :=
    EmployeesWorkGroupMembershipSpecification;
    
end;

procedure TStandardEmployeeDocumentSignerListChangingRule.
  EnsureThatEmployeeMayAssignDocumentSigner(
    Employee: TEmployee;
    Document: IDocument;
    Signer: TEmployee
  );
begin

  RaiseSignerAssigningExceptionIfDocumentIsAtNotAllowedWorkCycleStage(Document);
  RaiseSignerAssigningExceptionIfEmployeeHasNotRightsForAssigningAsSigner(
    Signer, Document, Employee
  );
  RaiseExceptionIfEmployeeHasNotRightsForSignerListChanging(Employee, Document);

end;

procedure TStandardEmployeeDocumentSignerListChangingRule.
  EnsureThatEmployeeMayRemoveDocumentSigner(
    Employee: TEmployee;
    Document: IDocument;
    Signer: TEmployee
  );
begin

  RaiseSignerAssigningExceptionIfDocumentIsAtNotAllowedWorkCycleStage(Document);
  RaiseExceptionIfDocumentAlreadySignedByEmployee(Document, Signer);
  RaiseExceptionIfEmployeeHasNotRightsForSignerListChanging(Employee, Document);

end;

function TStandardEmployeeDocumentSignerListChangingRule.IsEmployeeWorkGroupLeaderForOtherEmployee(
  Suggestedleader, OtherEmployee: TEmployee): Boolean;
begin

  Result :=
    Suggestedleader.IsLeader and
    FEmployeesWorkGroupMembershipSpecification.
      IsEmployeeAnyWorkGroupLeaderForOtherEmployee(
        Suggestedleader, OtherEmployee
      );
       
end;

function TStandardEmployeeDocumentSignerListChangingRule.
  MayEmployeeAssignDocumentSigner(
    Employee: TEmployee;
    Document: IDocument;
    Signer: TEmployee
  ): Boolean;
begin

  try

    EnsureThatEmployeeMayAssignDocumentSigner(Employee, Document, Signer);

    Result := True;
    
  except

    on e: TDocumentSignerListChangingRuleException do begin

      Result := False;
      
    end;

  end;

end;

function TStandardEmployeeDocumentSignerListChangingRule.
  MayEmployeeRemoveDocumentSigner(
    Employee: TEmployee;
    Document: IDocument;
    Signer: TEmployee
  ): Boolean;
begin

  try

    EnsureThatEmployeeMayRemoveDocumentSigner(Employee, Document, Signer);

    Result := True;
    
  except

    on e: TDocumentSignerListChangingRuleException do begin

      Result := False;
      
    end;

  end;

end;

procedure TStandardEmployeeDocumentSignerListChangingRule.
  RaiseSignerAssigningExceptionIfDocumentIsAtNotAllowedWorkCycleStage(
    Document: IDocument
  );
begin

  if Document.IsSigned then begin

    raise TDocumentSignerListChangingRuleException.CreateFmt(
            'На данный момент уже нельзя ' +
            'назначать или отзывать ' +
            'подписантов для документа ' +
            '"%s", поскольку ' +
            'он уже был подписан ранее',
            [
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

  end;

end;

procedure TStandardEmployeeDocumentSignerListChangingRule.
  RaiseExceptionIfDocumentAlreadySignedByEmployee(
    Document: IDocument;
    Employee: TEmployee
  );
var DocumentSigning: TDocumentSigning;
begin

  DocumentSigning :=
    Document.FindSigningBySignerOrActuallySignedEmployee(Employee);

  if DocumentSigning.IsPerformed then begin

    raise TDocumentSignerListChangingRuleException.CreateFmt(
            'Нельзя отозвать подписанта ' +
            '"%s" для документа "%s", ' +
            'поскольку данный документ ' +
            'уже подписан этим сотрудником',
            [
              Employee.FullName,
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

  end;

end;

procedure TStandardEmployeeDocumentSignerListChangingRule.
  RaiseSignerAssigningExceptionIfEmployeeAlreadyAssignedAsSigner(
    Signer: TEmployee;
    Document: IDocument;
    AssigningEmployee: TEmployee
  );
begin

  if
    TDocument(Document.Self)
      .Specifications
        .DocumentSigningSpecification
          .IsEmployeeAnyOfDocumentSigners(Signer, Document)
  then begin

    raise TDocumentSignerListChangingRuleException.CreateFmt(
      'Сотрудник "%s" уже назначен ' +
      'на документ "%s" ' +
      'в качестве подписанта',
      [
        Signer.FullName,
        FDocumentFullNameCompilationService.CompileFullNameForDocument(
          Document
        )
      ]
    );

  end;
  
end;

procedure TStandardEmployeeDocumentSignerListChangingRule.
  RaiseSignerAssigningExceptionIfEmployeeHasNotRightsForAssigningAsSigner(
    Signer: TEmployee;
    Document: IDocument;
    AssigningEmployee: TEmployee
  );
begin

  RaiseSignerAssigningExceptionIfEmployeeAlreadyAssignedAsSigner(
    Signer, Document, AssigningEmployee
  );

  RaiseSignerAssigningExceptionIfSignerIsNotLeaderForAssigningEmployee(
    Signer, Document, AssigningEmployee
  );

  RaiseSignerAssigningExceptionIfSignerAlreadyAssignedAsPerformer(
    Signer, Document, AssigningEmployee
  );

end;

procedure TStandardEmployeeDocumentSignerListChangingRule.
  RaiseSignerAssigningExceptionIfSignerAlreadyAssignedAsPerformer(
    Signer: TEmployee;
    Document: IDocument;
    AssigningEmployee: TEmployee
  );
begin

  if
    Document.Charges.IsEmployeeAssignedAsPerformer(Signer)
    and not AssigningEmployee.IsSecretarySignerFor(Signer)
  then begin

    raise TDocumentSignerListChangingRuleException.CreateFmt(
            'Сотрудник "%s" не может быть ' +
            'назначен в качестве подписанта ' +
            'документа "%s", поскольку ' +
            'по данному документу ему выдано ' +
            'поручение',
            [
              Signer.FullName,
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

  end;
  
end;

procedure TStandardEmployeeDocumentSignerListChangingRule.
  RaiseSignerAssigningExceptionIfSignerIsNotLeaderForAssigningEmployee(
    Signer: TEmployee;
    Document: IDocument;
    AssigningEmployee: TEmployee
  );
begin

  if
    not (
      FEmployeeIsLeaderForOtherSpecification.
        IsEmployeeLeaderForOtherEmployee(
          Signer, AssigningEmployee
        )
      or
      IsEmployeeWorkGroupLeaderForOtherEmployee(
        Signer, AssigningEmployee
      )
    )
  then begin

    raise TDocumentSignerListChangingRuleException.CreateFmt(
            'Сотрудник "%s" не может быть ' +
            'назначен в качестве подписанта ' +
            'документа "%s", поскольку он не ' +
            'является руководителем для сотрудника "%s"',
            [
              Signer.FullName,
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              ),
              AssigningEmployee.FullName
            ]
          );

  end;

end;

procedure TStandardEmployeeDocumentSignerListChangingRule.
  RaiseExceptionIfEmployeeHasNotRightsForSignerListChanging(
    Employee: TEmployee;
    Document: IDocument
  );
var
    SpecificationResult: TEmployeeIsSameAsOrReplacingForOthersSpecificationResult;
    FreeSpecificationResult: IDisposable;
begin

  if
      not (
        FEmployeeIsSameAsOrReplacingForOthersSpecification.
          IsEmployeeSameAsOrReplacingForOtherEmployee(
            Employee, Document.Author
          )

        or

        FEmployeeIsSameAsOrReplacingForOthersSpecification.
          IsEmployeeSameAsOrReplacingForOtherEmployee(
            Document.Author, Employee
          )

        or

        FAreEmployeesSubLeadersOfSameLeaderSpecification.
          AreEmployeesSubLeadersOfSameLeader(
            Employee, Document.Author
          )

        or

        FAreEmployeesSecretariesOfSameLeaderSpecification.
          AreEmployeesSecretariesOfSameLeader(
            Employee, Document.Author
          )
      )
  then begin
    
    TDocument(Document.Self)
      .Specifications
        .DocumentSigningSpecification
          .IsEmployeeAnyOfDocumentSigners(Employee, Document, SpecificationResult);

    FreeSpecificationResult := SpecificationResult;

    if not SpecificationResult.IsSatisfied then begin

      raise TDocumentSignerListChangingRuleException.CreateFmt(
              'Сотрудник "%s" не может ' +
              'назначать или отзывать подписантов для ' +
              'документа "%s", поскольку ' +
              'не имеет достаточных прав',
              [
                Employee.FullName,
                FDocumentFullNameCompilationService.CompileFullNameForDocument(
                  Document
                )
              ]
            );

    end;

  end;

end;

end.
