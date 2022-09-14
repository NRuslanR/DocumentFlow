unit StandardDocumentApprovingRejectingPerformingRule;

interface

uses

  DocumentApprovings,
  EmployeeIsSameAsOrReplacingForOthersSpecification,
  DocumentFullNameCompilationService,
  DocumentApprovingRejectingPerformingRule,
  IDocumentUnit,
  IDomainObjectListUnit,
  Employee,
  SysUtils,
  Classes;

type

  TStandardDocumentApprovingRejectingPerformingRule =
    class (TInterfacedObject, IDocumentApprovingRejectingPerformingRule)

      protected

        FEmployeeIsSameAsOrDeputyForOthersSpecification:
          IEmployeeIsSameAsOrReplacingForOthersSpecification;

        FDocumentFullNameCompilationService:
          IDocumentFullNameCompilationService;

        procedure RaiseExceptionIfDocumentIsNotAtAllowableStage(
          Document: IDocument
        );

        function GetRealFormalApproverForRejectingApprovingEmployeeOrRaiseExceptionIfThisEmployeeHasNotRightsForDocumentRejectingApproving(
          Document: IDocument;
          FormalApprover: TEmployee;
          RejectingApprovingEmployee: TEmployee
        ): TEmployee;

        procedure RaiseExceptionIfDocumentApprovingAlreadyPerformed(
          Document: IDocument;
          RealFormalApprover: TEmployee;
          RejectingApprovingEmployee: TEmployee
        );

      public

        constructor Create(

          EmployeeIsSameAsOrDeputyForOthersSpecification:
            IEmployeeIsSameAsOrReplacingForOthersSpecification;

          DocumentFullNameCompilationService:
            IDocumentFullNameCompilationService

        );
        
        function EnsureThatEmployeeCanRejectApprovingDocument(
          Document: IDocument;
          Employee: TEmployee
        ): TEmployee; virtual;

        function EnsureThatEmployeeCanRejectApprovingDocumentOnBehalfOfOther(
          Document: IDocument;
          FormalApprover: TEmployee;
          RejectingApprovingEmployee: TEmployee
        ): TEmployee; virtual;

        procedure EnsureThatEmployeeHasOnlyRightsForDocumentApprovingRejecting(
          Employee: TEmployee;
          Document: IDocument
        ); virtual;

        function CanEmployeeRejectApprovingDocument(
          Document: IDocument;
          Employee: TEmployee
        ): Boolean; virtual;

        function CanEmployeeRejectApprovingDocumentOnBehalfOfOther(
          Document: IDocument;
          FormalApprover: TEmployee;
          RejectingApprovingEmployee: TEmployee
        ): Boolean; virtual;

        function HasEmployeeOnlyRightsForDocumentApprovingRejecting(
          Employee: TEmployee;
          Document: IDocument
        ): Boolean; virtual;

    end;

implementation

uses

  IDomainObjectUnit;
  
{ TStandardDocumentApprovingRejectingPerformingRule }

function TStandardDocumentApprovingRejectingPerformingRule.
  CanEmployeeRejectApprovingDocument(
    Document: IDocument;
    Employee: TEmployee
  ): Boolean;
begin

  try

    EnsureThatEmployeeCanRejectApprovingDocument(
      Document, Employee
    );

    Result := True;

  except

    on e: TDocumentApprovingRejectingPerformingRuleException do begin

      Result := False;
      
    end;

  end;

end;

function TStandardDocumentApprovingRejectingPerformingRule.
  CanEmployeeRejectApprovingDocumentOnBehalfOfOther(
    Document: IDocument;
    FormalApprover, RejectingApprovingEmployee: TEmployee
  ): Boolean;
begin

  try

    EnsureThatEmployeeCanRejectApprovingDocumentOnBehalfOfOther(
      Document, FormalApprover, RejectingApprovingEmployee
    );

    Result := True;
    
  except

    on e: TDocumentApprovingRejectingPerformingRuleException do begin

      Result := False;
      
    end;

  end;

end;

constructor TStandardDocumentApprovingRejectingPerformingRule.Create(
  EmployeeIsSameAsOrDeputyForOthersSpecification: IEmployeeIsSameAsOrReplacingForOthersSpecification;
  DocumentFullNameCompilationService: IDocumentFullNameCompilationService
);
begin

  inherited Create;

  FEmployeeIsSameAsOrDeputyForOthersSpecification :=
    EmployeeIsSameAsOrDeputyForOthersSpecification;

  FDocumentFullNameCompilationService := DocumentFullNameCompilationService;
  
end;

function TStandardDocumentApprovingRejectingPerformingRule.
  EnsureThatEmployeeCanRejectApprovingDocument(
    Document: IDocument;
    Employee: TEmployee
  ): TEmployee;
begin

  Result :=
    EnsureThatEmployeeCanRejectApprovingDocumentOnBehalfOfOther(
      Document, Employee, Employee
    );
  
end;

function TStandardDocumentApprovingRejectingPerformingRule.
  EnsureThatEmployeeCanRejectApprovingDocumentOnBehalfOfOther(
    Document: IDocument;
    FormalApprover, RejectingApprovingEmployee: TEmployee
  ): TEmployee;
var RealFormalApprover: TEmployee;
begin

  RaiseExceptionIfDocumentIsNotAtAllowableStage(Document);

  Result :=
    GetRealFormalApproverForRejectingApprovingEmployeeOrRaiseExceptionIfThisEmployeeHasNotRightsForDocumentRejectingApproving(
      Document, FormalApprover, RejectingApprovingEmployee
    );

  try

    RaiseExceptionIfDocumentApprovingAlreadyPerformed(
      Document, Result, RejectingApprovingEmployee
    );
    
  except

    on e: Exception do begin

      if not Result.IsSameAs(FormalApprover) then
        Result.Free;

      raise;
      
    end;

  end;
  

end;

procedure TStandardDocumentApprovingRejectingPerformingRule.
  EnsureThatEmployeeHasOnlyRightsForDocumentApprovingRejecting(
    Employee: TEmployee;
    Document: IDocument
  );
var ActualAssignedApprover: TEmployee;
    FreeEmployee: IDomainObject;
begin

  RaiseExceptionIfDocumentIsNotAtAllowableStage(Document);
  
  ActualAssignedApprover :=
    GetRealFormalApproverForRejectingApprovingEmployeeOrRaiseExceptionIfThisEmployeeHasNotRightsForDocumentRejectingApproving(
      Document, Employee, Employee
    );

  FreeEmployee := ActualAssignedApprover;
  
end;

function TStandardDocumentApprovingRejectingPerformingRule.
  GetRealFormalApproverForRejectingApprovingEmployeeOrRaiseExceptionIfThisEmployeeHasNotRightsForDocumentRejectingApproving(
  Document: IDocument;
  FormalApprover, RejectingApprovingEmployee: TEmployee
): TEmployee;
var DocumentApprovers: TEmployees;
    FreeDocumentApprovers: IDomainObjectList;
    SpecificationResult:
      TEmployeeIsSameAsOrReplacingForOthersSpecificationResult;
    ReplaceableEmployeeFullNameString: String;
    ExceptionMessage: String;
begin

  if not FEmployeeIsSameAsOrDeputyForOthersSpecification.
        IsEmployeeSameAsOrReplacingForOtherEmployee(
          RejectingApprovingEmployee, FormalApprover
        )
  then
    raise TDocumentApprovingRejectingPerformingRuleException.CreateFmt(
            'Сотрудник "%s" не может ' +
            'отклонить согласование документа "%s" ' +
            'от имени сотрудника "%s", ' +
            'поскольку для последнего ' +
            'первый не является ' +
            'исполняющим обязанности',
            [
              RejectingApprovingEmployee.FullName,
              FormalApprover.FullName
            ]
          );

  DocumentApprovers := Document.FetchAllApprovers;
  FreeDocumentApprovers := DocumentApprovers;

  if DocumentApprovers.IsEmpty then
    raise TDocumentApprovingRejectingPerformingRuleException.CreateFmt(
            'Для документа "%s" ' +
            'не назначен ни один ' +
            'согласовант',
            [
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

  SpecificationResult :=
    FEmployeeIsSameAsOrDeputyForOthersSpecification.
      IsEmployeeSameAsOrReplacingForAnyOfEmployees(
        FormalApprover, DocumentApprovers
      );

  try

    if not SpecificationResult.IsSatisfied then begin

      if FormalApprover.IsSameAs(RejectingApprovingEmployee) then begin

        ExceptionMessage :=
          Format(
            'У сотрудника "%s" ' +
            'отсутствуют права для ' +
            'отклонения согласования документа "%s"',
            [
              RejectingApprovingEmployee.FullName,
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

      end

      else begin

        ExceptionMessage :=
          Format(
            'У сотрудника "%s" ' +
            'отсутствуют права для ' +
            'согласования документа "%s"',
            [
              FormalApprover.FullName,
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

      end;

      raise TDocumentApprovingRejectingPerformingRuleException.Create(ExceptionMessage);

    end

    else if SpecificationResult.IsReplaceableEmployeeCountMoreThanOne then
    begin

      ReplaceableEmployeeFullNameString :=
        SpecificationResult.FetchReplaceableEmployeeFullNamesString;

      if FormalApprover.IsSameAs(RejectingApprovingEmployee) then begin

        ExceptionMessage :=
          Format(
            'Неодназначность. Сотрудник "%s" ' +
            'является исполняющим обязанности ' +
            'для нескольких согласовантов:' +
            sLineBreak +
            ReplaceableEmployeeFullNameString,
            [
              RejectingApprovingEmployee.FullName
            ]
          );

      end

      else begin

        ExceptionMessage :=
          Format(
            'Неодназначность. Сотрудник "%s" ' +
            'является исполняющим обязанности ' +
            'для нескольких согласовантов:' +
            sLineBreak +
            ReplaceableEmployeeFullNameString,
            [
              FormalApprover.FullName
            ]
          );
          
      end;

      raise TDocumentApprovingRejectingPerformingRuleException.Create(ExceptionMessage);
      
    end

    else if not FormalApprover.IsSameAs(RejectingApprovingEmployee) then begin

      if not Assigned(SpecificationResult.ReplaceableEmployees) then
        Result := FormalApprover

      else
        raise TDocumentApprovingRejectingPerformingRuleException.CreateFmt(
                'Сотрудник "%s" не может ' +
                'отклонить согласование документ "%s" ' +
                'от имени "%s", поскольку ' +
                'последний не назначен ' +
                'формальным согласовантом ' +
                'для данного документа',
                [
                  RejectingApprovingEmployee.FullName,
                  FDocumentFullNameCompilationService.CompileFullNameForDocument(
                    Document
                  ),
                  FormalApprover.FullName
                ]
              );

    end

    else if Assigned(SpecificationResult.ReplaceableEmployees) then
      Result := SpecificationResult.ReplaceableEmployees[0].Clone as TEmployee

    else Result := FormalApprover;

  finally

    FreeAndNil(SpecificationResult);
    
  end;

end;

function TStandardDocumentApprovingRejectingPerformingRule.
  HasEmployeeOnlyRightsForDocumentApprovingRejecting(
    Employee: TEmployee;
    Document: IDocument
  ): Boolean;
begin

  try

    EnsureThatEmployeeHasOnlyRightsForDocumentApprovingRejecting(
      Employee, Document
    );

    Result := True;
    
  except

    on E: TDocumentApprovingRejectingPerformingRuleException do Result := False;

  end;

end;

procedure TStandardDocumentApprovingRejectingPerformingRule.
  RaiseExceptionIfDocumentApprovingAlreadyPerformed(
    Document: IDocument;
    RealFormalApprover, RejectingApprovingEmployee: TEmployee
  );
var DocumentApproving: TDocumentApproving;
begin

  DocumentApproving :=
    Document.FindApprovingByFormalApprover(RealFormalApprover);

  if not Assigned(DocumentApproving) then begin

    raise TDocumentApprovingRejectingPerformingRuleException.CreateFmt(
            'Для сотрудника "%s" не ' +
            'назначено согласование ' +
            'документа "%s"',
            [
              RealFormalApprover.FullName,
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

  end;

  if DocumentApproving.IsPerformed then begin

    raise TDocumentApprovingRejectingPerformingRuleException.CreateFmt(
            'Для сотрудника "%s" ' +
            'документ "%s" уже является ' +
            'согласованным или отклонённым',
            [
              RealFormalApprover.FullName,
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

  end;

end;

procedure TStandardDocumentApprovingRejectingPerformingRule.
  RaiseExceptionIfDocumentIsNotAtAllowableStage(
    Document: IDocument
  );
begin

  if Document.IsSigned then begin

    raise TDocumentApprovingRejectingPerformingRuleException.CreateFmt(
            'Нельзя отклонить ' +
            'согласование документа "%s", ' +
            'так как он уже подписан',
            [
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

  end;

  if not Document.IsApproving then begin

    raise TDocumentApprovingRejectingPerformingRuleException.CreateFmt(
            'Нельзя отклонить согласование ' +
            'документа "%s", поскольку на ' +
            'данный момент он не находится ' +
            'этапе согласования',
            [
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

  end;

end;

end.
