unit StandardDocumentApproverListChangingRule;

interface

uses

  DocumentApproverListChangingRule,
  EmployeeIsSameAsOrReplacingForOthersSpecification,
  DocumentFullNameCompilationService,
  DocumentApprovings,
  IDocumentUnit,
  AreEmployeesSubLeadersOfSameLeaderSpecification,
  AreEmployeesSecretariesOfSameLeaderSpecification,
  Employee,
  SysUtils,
  Classes;

type

  TStandardDocumentApproverListChangingRule =
    class (TInterfacedObject, IDocumentApproverListChangingRule)

      protected

        FEmployeeIsSameAsOrDeputyForOthersSpecification:
          IEmployeeIsSameAsOrReplacingForOthersSpecification;

        FDocumentFullNameCompilationService:
          IDocumentFullNameCompilationService;

        FAreEmployeesSubLeadersOfSameLeaderSpecification:
          IAreEmployeesSubLeadersOfSameLeaderSpecification;

        FAreEmployeesSecretariesOfSameLeaderSpecification:
          IAreEmployeesSecretariesOfSameLeaderSpecification;

        procedure RaiseExceptionIfDocumentIsNotAtAllowableStage(
          Document: IDocument
        );

        procedure RaiseExceptionIfEmployeeCanNotBeAssignedAsDocumentApprover(
          Employee: TEmployee;
          Document: IDocument;
          Approver: TEmployee
        );
        
        procedure RaiseExceptionIfEmployeeHasNoRightsForDocumentApproverAssigning(
          Employee: TEmployee;
          Document: IDocument;
          Approver: TEmployee
        );

        procedure RaiseExceptionIfEmployeeHasNoRightsForDocumentApproverRemoving(
          Employee: TEmployee;
          Document: IDocument;
          Approver: TEmployee
        );

        procedure RaiseExceptionIfEmployeeHasNoRightsForDocumentApproverListChanging(
          Employee: TEmployee;
          Document: IDocument
        );

        procedure RaiseExceptionIfDocumentIsNotAtAllowableStageForChangingApproverInfo(
          Document: IDocument
        );

        procedure RaiseExceptionIfEmployeeIsNotAssignedAsDocumentApprover(
          Document: IDocument;
          Approver: TEmployee
        );

        procedure RaiseExceptionIfEmployeeIsNotRelatedWithDocumentApprover(
          Employee, Approver: TEmployee
        );

        procedure RaiseExceptionIfEmployeeAlreadyPerformedDocumentApproving(
          FormalApprover: TEmployee;
          Document: IDocument
        );

        procedure RaiseExceptionIfEmployeeHasNotRightsForChangingInfoForAnyOfDocumentApprovers(
          Employee: TEmployee;
          Document: IDocument
        );
        
      public

        constructor Create(

          EmployeeIsSameAsOrDeputyForOthersSpecification:
            IEmployeeIsSameAsOrReplacingForOthersSpecification;

          DocumentFullNameCompilationService:
            IDocumentFullNameCompilationService;

          AreEmployeesSubLeadersOfSameLeaderSpecification:
            IAreEmployeesSubLeadersOfSameLeaderSpecification;

          AreEmployeesSecretariesOfSameLeaderSpecification:
            IAreEmployeesSecretariesOfSameLeaderSpecification

        );

        procedure EnsureThatEmployeeMayAssignDocumentApprover(
          Employee: TEmployee;
          Document: IDocument;
          Approver: TEmployee
        ); virtual;

        procedure EnsureThatEmployeeMayRemoveDocumentApprover(
          Employee: TEmployee;
          Document: IDocument;
          Approver: TEmployee
        ); virtual;

        procedure EnsureThatEmployeeMayChangeDocumentApproverList(
          Employee: TEmployee;
          Document: IDocument
        ); virtual;

        procedure EnsureThatEmployeeMayChangeDocumentApproverInfo(
          Employee: TEmployee;
          Document: IDocument;
          Approver: TEmployee
        ); virtual;

        procedure EnsureThatEmployeeMayChangeInfoForAnyOfDocumentApprovers(
          Employee: TEmployee;
          Document: IDocument
        ); virtual;
        
        function MayEmployeeAssignDocumentApprover(
          Employee: TEmployee;
          Document: IDocument;
          Approver: TEmployee
        ): Boolean; virtual;

        function MayEmployeeRemoveDocumentApprover(
          Employee: TEmployee;
          Document: IDocument;
          Approver: TEmployee
        ): Boolean; virtual;

        function MayEmployeeChangeDocumentApproverList(
          Employee: TEmployee;
          Document: IDocument
        ): Boolean; virtual;

        function MayEmployeeChangeInfoForAnyOfDocumentApprovers(
          Employee: TEmployee;
          Document: IDocument
        ): Boolean; virtual;

        function MayEmployeeChangeDocumentApproverInfo(
          Employee: TEmployee;
          Document: IDocument;
          Approver: TEmployee
        ): Boolean; virtual;

    end;
    
implementation

uses

  Document,
  IDomainObjectListUnit,
  Variants, DocumentSpecifications, DocumentSigningSpecification;

{ TStandardDocumentApproverListChangingRule }

constructor TStandardDocumentApproverListChangingRule.Create(

  EmployeeIsSameAsOrDeputyForOthersSpecification:
    IEmployeeIsSameAsOrReplacingForOthersSpecification;

  DocumentFullNameCompilationService:
    IDocumentFullNameCompilationService;

  AreEmployeesSubLeadersOfSameLeaderSpecification:
    IAreEmployeesSubLeadersOfSameLeaderSpecification;

  AreEmployeesSecretariesOfSameLeaderSpecification:
    IAreEmployeesSecretariesOfSameLeaderSpecification
);
begin

  inherited Create;

  FEmployeeIsSameAsOrDeputyForOthersSpecification :=
    EmployeeIsSameAsOrDeputyForOthersSpecification;

  FDocumentFullNameCompilationService :=
    DocumentFullNameCompilationService;

  FAreEmployeesSecretariesOfSameLeaderSpecification :=
    AreEmployeesSecretariesOfSameLeaderSpecification;

  FAreEmployeesSubLeadersOfSameLeaderSpecification :=
    AreEmployeesSubLeadersOfSameLeaderSpecification;

end;

procedure TStandardDocumentApproverListChangingRule.
  EnsureThatEmployeeMayAssignDocumentApprover(
    Employee: TEmployee;
    Document: IDocument;
    Approver: TEmployee
  );
begin

  RaiseExceptionIfDocumentIsNotAtAllowableStage(Document);

  RaiseExceptionIfEmployeeHasNoRightsForDocumentApproverAssigning(
    Employee, Document, Approver
  );

  RaiseExceptionIfEmployeeCanNotBeAssignedAsDocumentApprover(
    Employee, Document, Approver
  );
  
end;

procedure TStandardDocumentApproverListChangingRule.
  EnsureThatEmployeeMayChangeDocumentApproverInfo(
    Employee: TEmployee;
    Document: IDocument;
    Approver: TEmployee
  );
begin

  RaiseExceptionIfDocumentIsNotAtAllowableStageForChangingApproverInfo(
    Document
  );

  RaiseExceptionIfEmployeeIsNotAssignedAsDocumentApprover(
    Document, Approver
  );
  
  RaiseExceptionIfEmployeeIsNotRelatedWithDocumentApprover(
    Employee, Approver
  );

  RaiseExceptionIfEmployeeAlreadyPerformedDocumentApproving(
    Approver, Document
  );

end;

procedure TStandardDocumentApproverListChangingRule.
  EnsureThatEmployeeMayChangeDocumentApproverList(
    Employee: TEmployee;
    Document: IDocument
  );
begin

  RaiseExceptionIfDocumentIsNotAtAllowableStage(Document);
  RaiseExceptionIfEmployeeHasNoRightsForDocumentApproverListChanging(
    Employee, Document
  );

end;

procedure TStandardDocumentApproverListChangingRule.
  EnsureThatEmployeeMayRemoveDocumentApprover(
  Employee: TEmployee;
  Document: IDocument;
  Approver: TEmployee
);
begin

  RaiseExceptionIfDocumentIsNotAtAllowableStage(Document);
  RaiseExceptionIfEmployeeHasNoRightsForDocumentApproverRemoving(
    Employee, Document, Approver
  );

end;

function TStandardDocumentApproverListChangingRule.
  MayEmployeeAssignDocumentApprover(
    Employee: TEmployee;
    Document: IDocument;
    Approver: TEmployee
  ): Boolean;
begin

  try

    EnsureThatEmployeeMayAssignDocumentApprover(
      Employee, Document, Approver
    );

    Result := True;
    
  except

    Result := False;

  end;

end;

procedure TStandardDocumentApproverListChangingRule.
  EnsureThatEmployeeMayChangeInfoForAnyOfDocumentApprovers(
    Employee: TEmployee;
    Document: IDocument
  );
begin

  RaiseExceptionIfDocumentIsNotAtAllowableStageForChangingApproverInfo(
    Document
  );

  RaiseExceptionIfEmployeeHasNotRightsForChangingInfoForAnyOfDocumentApprovers(
    Employee, Document
  );

end;

function TStandardDocumentApproverListChangingRule.
  MayEmployeeChangeDocumentApproverInfo(
    Employee: TEmployee;
    Document: IDocument;
    Approver: TEmployee
  ): Boolean;
begin

  try

    EnsureThatEmployeeMayChangeDocumentApproverInfo(
      Employee,
      Document,
      Approver
    );

    Result := True;

  except

    on e: TDocumentApproverListChangingRuleException do begin

      Result := False;
      
    end;

  end;
  
end;

function TStandardDocumentApproverListChangingRule.
  MayEmployeeChangeDocumentApproverList(
    Employee: TEmployee; Document: IDocument
  ): Boolean;
begin

  try

    EnsureThatEmployeeMayChangeDocumentApproverList(Employee, Document);

    Result := True;
    
  except

    on e: TDocumentApproverListChangingRuleException do begin

      Result := False;
      
    end;

  end;

end;

function TStandardDocumentApproverListChangingRule.
  MayEmployeeChangeInfoForAnyOfDocumentApprovers(
    Employee: TEmployee;
    Document: IDocument
  ): Boolean;
begin

  try

    EnsureThatEmployeeMayChangeInfoForAnyOfDocumentApprovers(
      Employee, Document
    );

    Result := True;
    
  except

    on e: TDocumentApproverListChangingRuleException do begin

      Result := False;
      
    end;

  end;

end;

function TStandardDocumentApproverListChangingRule.
  MayEmployeeRemoveDocumentApprover(
    Employee: TEmployee;
    Document: IDocument;
    Approver: TEmployee
  ): Boolean;
begin

  try

    EnsureThatEmployeeMayRemoveDocumentApprover(
      Employee, Document, Approver
    );

    Result := True;

  except

    on e: TDocumentApproverListChangingRuleException do begin

      Result := False;
      
    end;

  end;

end;

procedure TStandardDocumentApproverListChangingRule.
  RaiseExceptionIfDocumentIsNotAtAllowableStage(
    Document: IDocument
  );
begin

  if Document.IsSigned then
    raise TDocumentApproverListChangingRuleException.CreateFmt(
            'В документ "%s" ' +
            'не могут вноситься изменения ' +
            'по части согласований, так как ' +
            'он уже подписан',
            [
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

  if Document.IsApproving then
    raise TDocumentApproverListChangingRuleException.CreateFmt(
            'В документ "%s" ' +
            'не могут вноситься изменения ' +
            'по части согласований, так как ' +
            'он находится на согласовании',
            [
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

end;

procedure TStandardDocumentApproverListChangingRule.
  RaiseExceptionIfDocumentIsNotAtAllowableStageForChangingApproverInfo(
    Document: IDocument
  );
begin

  if Document.IsSigned then
    raise TDocumentApproverListChangingRuleException.CreateFmt(
      'Документ "%s" уже подписан',
      [
        FDocumentFullNameCompilationService.CompileFullNameForDocument(
          Document
        )
      ]
    );

  if not Document.IsApproving then
    raise TDocumentApproverListChangingRuleException.CreateFmt(
      'Документ "%s" не находится ' +
      'на этапе согласования',
      [
        FDocumentFullNameCompilationService.CompileFullNameForDocument(
          Document
        )
      ]
    );

end;

procedure TStandardDocumentApproverListChangingRule.
  RaiseExceptionIfEmployeeHasNoRightsForDocumentApproverAssigning(
    Employee: TEmployee;
    Document: IDocument;
    Approver: TEmployee
  );
begin

  RaiseExceptionIfEmployeeHasNoRightsForDocumentApproverListChanging(
    Employee, Document
  );
  
end;

procedure TStandardDocumentApproverListChangingRule.
  RaiseExceptionIfEmployeeHasNoRightsForDocumentApproverListChanging(
    Employee: TEmployee;
    Document: IDocument
  );
var
    IsEmployeeSigner: Boolean;

  procedure RaiseExceptionAboutThatEmployeeHasNotRightsForDocumentApprovingListChanging;
  begin

    raise TDocumentApproverListChangingRuleException.CreateFmt(
      'Сотрудник "%s" не имеет прав ' +
      'для изменения перечня ' +
      'согласовантов для документа "%s"',
      [
        Employee.FullName,
        FDocumentFullNameCompilationService.CompileFullNameForDocument(
          Document
        )
      ]
    );
    
  end;

begin

  { Refactor: смотри StandardApprovingDocumentSendingRule }

  IsEmployeeSigner :=
    TDocument(Document.Self)
      .Specifications
        .DocumentSigningSpecification
          .IsEmployeeAnyOfDocumentSignersOrOnesCanMarkDocumentAsSigned(
            Employee, Document
          );

  if IsEmployeeSigner then begin

    if Document.IsRejectedFromSigning then
      RaiseExceptionAboutThatEmployeeHasNotRightsForDocumentApprovingListChanging;

    Exit;

  end;

  if (
    FEmployeeIsSameAsOrDeputyForOthersSpecification.
      IsEmployeeSameAsOrReplacingForOtherEmployeeOrViceVersa(
        Employee, Document.Author
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

    if (Document.IsSigning or Document.IsSentToSigning)
    then begin

      if
        not Employee.IsLeader
        and not Employee.IsSubLeaderForTopLevelEmployee
      then begin

        raise TDocumentApproverListChangingRuleException.CreateFmt(
          'Сотрудник "%s", являясь ' +
          'автором документа "%s" или ' +
          'исполняющим его обязанности, ' +
          'не может изменять перечень согласовантов ' +
          'для данного документа, поскольку ' +
          'последний находится уже на этапе ' +
          'подписания',
          [
            Employee.FullName,
            FDocumentFullNameCompilationService.CompileFullNameForDocument(
              Document
            )
          ]
        );

      end

      else if not IsEmployeeSigner then
        RaiseExceptionAboutThatEmployeeHasNotRightsForDocumentApprovingListChanging;

    end;
    
  end

  else if not IsEmployeeSigner then
    RaiseExceptionAboutThatEmployeeHasNotRightsForDocumentApprovingListChanging;

end;

procedure TStandardDocumentApproverListChangingRule.
  RaiseExceptionIfEmployeeHasNoRightsForDocumentApproverRemoving(
    Employee: TEmployee;
    Document: IDocument;
    Approver: TEmployee
  );
begin

  RaiseExceptionIfEmployeeHasNoRightsForDocumentApproverListChanging(
    Employee, Document
  );

end;

procedure TStandardDocumentApproverListChangingRule.
  RaiseExceptionIfEmployeeHasNotRightsForChangingInfoForAnyOfDocumentApprovers(
    Employee: TEmployee;
    Document: IDocument
  );
var DocumentApprovers: TEmployees; FreeEmployees: IDomainObjectList;
    SpecificationResult: TEmployeeIsSameAsOrReplacingForOthersSpecificationResult;
    ReplaceableEmployee: TEmployee;
    DocumentApproving: TDocumentApproving;
begin

  DocumentApprovers := Document.FetchAllApprovers;
  
  FreeEmployees := DocumentApprovers;

  if not Assigned(DocumentApprovers) then
    raise TDocumentApproverListChangingRuleException.CreateFmt(
      'Сотрудник "%s" не может ' +
      'вносить изменения в данные ' +
      'о согласовантах, поскольку ' +
      'для документа не задан ни один ' +
      'согласовант',
      [
        Employee.FullName
      ]
    );

  { refactor: в метод спецификации согласования }
  
  SpecificationResult :=
    FEmployeeIsSameAsOrDeputyForOthersSpecification.
      IsEmployeeSameAsOrReplacingForAnyOfEmployees(
        Employee, DocumentApprovers
      );

  try

    if not SpecificationResult.IsSatisfied then
      raise TDocumentApproverListChangingRuleException.CreateFmt(
        'Сотрудник "%s" не может ' +
        'вносить изменения в данные ' +
        'о согласовантах, поскольку не ' +
        'является исполняющим обязанности ' +
        'ни для одного из них',
        [
          Employee.FullName
        ]
      );

    DocumentApproving :=
      Document.FindApprovingByFormalApprover(Employee);

    if Assigned(DocumentApproving) and not DocumentApproving.IsPerformed
    then Exit;

    if Assigned(SpecificationResult.ReplaceableEmployees) then begin

      for ReplaceableEmployee in SpecificationResult.ReplaceableEmployees
      do begin

        DocumentApproving :=
          Document.FindApprovingByFormalApprover(
            ReplaceableEmployee
          );

        if not DocumentApproving.IsPerformed then Exit;

      end;

    end;
    
    raise TDocumentApproverListChangingRuleException.CreateFmt(
      'Сотрудник "%s" не может ' +
      'вносить изменения в данные ' +
      'о согласовантах, поскольку ' +
      'уже принял участие в согласовании ' +
      'документа ранее',
      [
        Employee.FullName
      ]
    );
    
  finally

    FreeAndNil(SpecificationResult);
    
  end;
  
end;

procedure TStandardDocumentApproverListChangingRule.
  RaiseExceptionIfEmployeeIsNotAssignedAsDocumentApprover(
    Document: IDocument;
    Approver: TEmployee
  );
var Approvers: TEmployees; FreeApprovers: IDomainObjectList;
    DocumentApproving: TDocumentApproving;
begin

  DocumentApproving := Document.FindApprovingByFormalApprover(Approver);

  if not Assigned(DocumentApproving) then
    raise TDocumentApproverListChangingRuleException.CreateFmt(
      'Сотрудник "%s" не назначен в качестве ' +
      'согласованта документа "%s"',
      [
        Approver.FullName,
        FDocumentFullNameCompilationService.CompileFullNameForDocument(
          Document
        )
      ]
    );
    
end;

procedure TStandardDocumentApproverListChangingRule.
  RaiseExceptionIfEmployeeIsNotRelatedWithDocumentApprover(
    Employee, Approver: TEmployee
  );
begin

  if not FEmployeeIsSameAsOrDeputyForOthersSpecification.
            IsEmployeeSameAsOrReplacingForOtherEmployee(
              Employee, Approver
            )
  then
    raise TDocumentApproverListChangingRuleException.CreateFmt(
      'Сотрудник "%s" не является ' +
      'исполняющим обязанности для ' +
      'сотрудника "%s"',
      [
        Employee.FullName,
        Approver.FullName
      ]
    );
  
end;

procedure TStandardDocumentApproverListChangingRule.
  RaiseExceptionIfEmployeeAlreadyPerformedDocumentApproving(
    FormalApprover: TEmployee;
    Document: IDocument
  );
var DocumentApproving: TDocumentApproving;
begin

  DocumentApproving := Document.FindApprovingByFormalApprover(FormalApprover);

  if not Assigned(DocumentApproving) then
    raise TDocumentApproverListChangingRuleException.CreateFmt(
      'Сотрудник "%s" не указан ' +
      'в качестве согласованта ' +
      'документа "%s"',
      [
        FormalApprover.FullName,
        FDocumentFullNameCompilationService.CompileFullNameForDocument(
          Document
        )
      ]
    );

  if DocumentApproving.IsPerformed then
    raise TDocumentApproverListChangingRuleException.CreateFmt(
      'Сотрудник "%s" уже ' +
      'выполнил участие в ' +
      'согласовании документа "%s"',
      [
        FormalApprover.FullName,
        FDocumentFullNameCompilationService.CompileFullNameForDocument(
          Document
        )
      ]
    );

end;

procedure TStandardDocumentApproverListChangingRule.
  RaiseExceptionIfEmployeeCanNotBeAssignedAsDocumentApprover(
    Employee: TEmployee;
    Document: IDocument;
    Approver: TEmployee
  );
var DocumentApprovers: TEmployees;
    FreeDocumentApprovers: IDomainObjectList;
    SpecificationResult:
      TEmployeeIsSameAsOrReplacingForOthersSpecificationResult;
begin
  
  DocumentApprovers := Document.FetchAllApprovers;
  FreeDocumentApprovers := DocumentApprovers;

  SpecificationResult :=
    FEmployeeIsSameAsOrDeputyForOthersSpecification.
      IsEmployeeSameAsOrReplacingForAnyOfEmployees(
        Approver, DocumentApprovers
      );

  try

    if SpecificationResult.IsSatisfied then begin

      raise TDocumentApproverListChangingRuleException.CreateFmt(
              'Сотрудник "%s" уже назначен ' +
              'согласовантом для документа "%s", ' +
              'или является исполняющим ' +
              'обязанности для другого ' +
              'назначенного',
              [
                Approver.FullName,
                FDocumentFullNameCompilationService.CompileFullNameForDocument(
                  Document
                )
              ]
            );

    end;

  finally

    FreeAndNil(SpecificationResult);

  end;
  
end;

end.
