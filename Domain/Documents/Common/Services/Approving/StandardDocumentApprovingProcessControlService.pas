unit StandardDocumentApprovingProcessControlService;

interface

uses

  IDocumentUnit,
  DocumentApprovings,
  Employee,
  EmployeeDocumentWorkingRule,
  DocumentApprovingCycleResultFinder,
  DocumentFullNameCompilationService,
  DocumentApproverListChangingRule,
  DocumentApprovingProcessControlService,
  DocumentApprovingCycleResult,
  DocumentApprovingCycle,
  SysUtils,
  Classes;

type

  TStandardDocumentApprovingProcessControlService =
    class (TInterfacedObject, IDocumentApprovingProcessControlService)

      protected

        FDocumentApproverListChangingRule: IDocumentApproverListChangingRule;
        FDocumentFullNameCompilationService: IDocumentFullNameCompilationService;
        FDocumentApprovingPassingMarkingRule: IEmployeeDocumentWorkingRule;
        FDocumentApprovingCycleResultFinder: IDocumentApprovingCycleResultFinder;
    
      protected

        procedure RaiseExceptionIfDocumentIsNotAtAllowableStageForNewApprovingCycle(
          Document: IDocument
        );

        procedure RaiseExceptionIfEmployeeHasNoRightsForCreatingNewDocumentApprovingCycle(
          InitiatingEmployee: TEmployee;
          Document: IDocument
        );

      protected

        function CreateCurrentDocumentApprovingCycleResultForDocument(
          Document: IDocument
        ): TDocumentApprovingCycleResult;

        procedure ChangeDocumentWorkCycleStageByApprovingCycleResult(
          Document: IDocument;
          Employee: TEmployee;
          ApprovingCycleResult: TDocumentApprovingCycleResult
        );
        
        procedure ProcessDocumentApprovingsAsResultOfDocumentApprovingCycle(
          DocumentApprovings: TDocumentApprovings
        );
        
      protected

        function PerformDocumetApprovingOnBehalfOfEmployeeAndCompleteApprovingCycleIfPossible(
          Document: IDocument;
          PerformingEmployee: TEmployee;
          PerformingResult: TDocumentApprovingPerformingResult
        ): TDocumentApprovingCycleResult;

        function InternalCompleteDocumentApprovingCycle(
          Document: IDocument;
          CompletingEmployee: TEmployee
        ): TDocumentApprovingCycleResult; virtual;

        procedure InternalEnsureThatEmployeeMayCreateNewDocumentApprovingCycle(
          Document: IDocument;
          InitiatingEmployee: TEmployee
        ); virtual;

      public

        constructor Create(
          DocumentApproverListChangingRule: IDocumentApproverListChangingRule;
          DocumentFullNameCompilationService: IDocumentFullNameCompilationService;
          DocumentApprovingPassingMarkingRule: IEmployeeDocumentWorkingRule;
          DocumentApprovingCycleResultFinder: IDocumentApprovingCycleResultFinder
        );

        function GetInfoForNewDocumentApprovingCycle(
          Document: IDocument;
          Employee: TEmployee
        ): TDocumentApprovingCycle;

        function ApproveDocumetOnBehalfOfEmployeeAndCompleteApprovingCycleIfPossible(
          Document: IDocument;
          ApprovingEmployee: TEmployee
        ): TDocumentApprovingCycleResult;

        function NotApproveDocumetOnBehalfOfEmployeeAndCompleteApprovingCycleIfPossible(
          Document: IDocument;
          ApprovingEmployee: TEmployee
        ): TDocumentApprovingCycleResult;

        function CompleteDocumentApprovingCycle(
          Document: IDocument;
          CompletingEmployee: TEmployee
        ): TDocumentApprovingCycleResult;

        procedure EnsureThatEmployeeMayCreateNewDocumentApprovingCycle(
          Document: IDocument;
          InitiatingEmployee: TEmployee
        );

        procedure EnsureThatEmployeeMayChangeDocumentApproverList(
          Employee: TEmployee;
          Document: IDocument
        );

        procedure EnsureThatEmployeeMayChangeDocumentApproverInfo(
          Employee: TEmployee;
          Document: IDocument;
          Approver: TEmployee
        );

        procedure EnsureThatEmployeeMayAssignDocumentApprover(
          Employee: TEmployee;
          Document: IDocument;
          Approver: TEmployee
        );

        procedure EnsureThatEmployeeMayRemoveDocumentApprover(
          Employee: TEmployee;
          Document: IDocument;
          Approver: TEmployee
        );

        function MayEmployeeChangeDocumentApproverList(
          Employee: TEmployee;
          Document: IDocument
        ): Boolean;

        function MayEmployeeChangeDocumentApproverInfo(
          Employee: TEmployee;
          Document: IDocument;
          Approver: TEmployee
        ): Boolean;

        function MayEmployeeAssignDocumentApprover(
          Employee: TEmployee;
          Document: IDocument;
          Approver: TEmployee
        ): Boolean;

        function MayEmployeeRemoveDocumentApprover(
          Employee: TEmployee;
          Document: IDocument;
          Approver: TEmployee
        ): Boolean;

    end;


implementation

uses

  AuxDebugFunctionsUnit,
  Variants,
  Document;
  
{ TStandardDocumentApprovingProcessControlService }

procedure TStandardDocumentApprovingProcessControlService.
  EnsureThatEmployeeMayAssignDocumentApprover(
    Employee: TEmployee;
    Document: IDocument;
    Approver: TEmployee
  );
var TargetDocument: TDocument;
begin

  TargetDocument := Document.Self as TDocument;

  try

    TargetDocument.WorkingRules.
      ApproverListChangingRule.
        EnsureThatEmployeeMayAssignDocumentApprover(
          Employee, Document, Approver
        );

  except

    on e: Exception do begin

      if e is TDocumentApproverListChangingRuleException then
        raise TDocumentApprovingProcessControlServiceException.Create(
          e.Message
        );

      raise;
      
    end;

  end;

end;

procedure TStandardDocumentApprovingProcessControlService.
  EnsureThatEmployeeMayChangeDocumentApproverInfo(
    Employee: TEmployee;
    Document: IDocument;
    Approver: TEmployee
  );
var TargetDocument: TDocument;
begin

  TargetDocument := Document.Self as TDocument;

  try

    TargetDocument.
      WorkingRules.
        ApproverListChangingRule.
          EnsureThatEmployeeMayChangeDocumentApproverInfo(
            Employee, Document, Approver
          );

  except

    on e: Exception do begin

      if e is TDocumentApproverListChangingRuleException then
        raise TDocumentApprovingProcessControlServiceException.Create(
          e.Message
        );

      raise;
      
    end;

  end;

end;

procedure TStandardDocumentApprovingProcessControlService.
  EnsureThatEmployeeMayChangeDocumentApproverList(
    Employee: TEmployee;
    Document: IDocument
  );
var TargetDocument: TDocument;
begin

  TargetDocument := Document.Self as TDocument;

  try

    TargetDocument.
      WorkingRules.
        ApproverListChangingRule.
          EnsureThatEmployeeMayChangeDocumentApproverList(
            Employee, Document
          );

  except

    on e: TDocumentApproverListChangingRuleException do begin

      raise TDocumentApprovingProcessControlServiceException.Create(
        e.Message
      );
      
    end;

  end;

end;

procedure TStandardDocumentApprovingProcessControlService.
  EnsureThatEmployeeMayCreateNewDocumentApprovingCycle(
    Document: IDocument; InitiatingEmployee: TEmployee
  );
begin

  InternalEnsureThatEmployeeMayCreateNewDocumentApprovingCycle(
    Document, InitiatingEmployee
  );
            
end;

procedure TStandardDocumentApprovingProcessControlService.
  EnsureThatEmployeeMayRemoveDocumentApprover(
    Employee: TEmployee;
    Document: IDocument;
    Approver: TEmployee
  );
var TargetDocument: TDocument;
begin

  TargetDocument := Document.Self as TDocument;

  try

    TargetDocument.
      WorkingRules.
        ApproverListChangingRule.
          EnsureThatEmployeeMayRemoveDocumentApprover(
            Employee, Document, Approver
          );

  except

    on e: Exception do begin

      if e is TDocumentApproverListChangingRuleException then
        raise TDocumentApprovingProcessControlServiceException.Create(
          e.Message
        );

      raise;
      
    end;

  end;

end;

procedure TStandardDocumentApprovingProcessControlService.
  ChangeDocumentWorkCycleStageByApprovingCycleResult(
    Document: IDocument;
    Employee: TEmployee;
    ApprovingCycleResult: TDocumentApprovingCycleResult
  );
var DocumentApproving: TDocumentApproving;
begin

  for DocumentApproving in ApprovingCycleResult.DocumentApprovings do begin

    if DocumentApproving.PerformingResult = prRejected then begin

      Document.MarkAsNotApprovedBy(Employee);
      Exit;
      
    end;

  end;

  Document.MarkAsApprovedBy(Employee);

end;

function TStandardDocumentApprovingProcessControlService.
  CompleteDocumentApprovingCycle(
    Document: IDocument;
    CompletingEmployee: TEmployee
  ): TDocumentApprovingCycleResult;
begin

  Result := InternalCompleteDocumentApprovingCycle(
              Document,
              CompletingEmployee
            );
            
end;

constructor TStandardDocumentApprovingProcessControlService.Create(
  DocumentApproverListChangingRule: IDocumentApproverListChangingRule;
  DocumentFullNameCompilationService: IDocumentFullNameCompilationService;
  DocumentApprovingPassingMarkingRule: IEmployeeDocumentWorkingRule;
  DocumentApprovingCycleResultFinder: IDocumentApprovingCycleResultFinder
);
begin

  inherited Create;

  FDocumentApproverListChangingRule := DocumentApproverListChangingRule;
  FDocumentFullNameCompilationService := DocumentFullNameCompilationService;
  FDocumentApprovingPassingMarkingRule := DocumentApprovingPassingMarkingRule;
  FDocumentApprovingCycleResultFinder := DocumentApprovingCycleResultFinder;

end;

function TStandardDocumentApprovingProcessControlService.
  CreateCurrentDocumentApprovingCycleResultForDocument(
    Document: IDocument
  ): TDocumentApprovingCycleResult;
var PassedApprovingCycleCount: Integer;
    CurrentDocumentApprovingCycleNumber: Integer;
    CurrentDocumentApprovings: TDocumentApprovings;
begin

  PassedApprovingCycleCount :=
    FDocumentApprovingCycleResultFinder.
      GetPassedApprovingCycleCountForDocument(Document);

  DebugOutput(Document.Approvings.First.PerformingResultName);

  CurrentDocumentApprovings := Document.Approvings.Clone as TDocumentApprovings;

  ProcessDocumentApprovingsAsResultOfDocumentApprovingCycle(
    CurrentDocumentApprovings
  );

  CurrentDocumentApprovingCycleNumber := PassedApprovingCycleCount + 1;
  
  Result := TDocumentApprovingCycleResult.Create(
              CurrentDocumentApprovingCycleNumber,
              CurrentDocumentApprovings
            );
  
end;

function TStandardDocumentApprovingProcessControlService.
  GetInfoForNewDocumentApprovingCycle(
    Document: IDocument;
    Employee: TEmployee
  ): TDocumentApprovingCycle;
var PassedDocumentApprovingCycleCount: Integer;
begin

  EnsureThatEmployeeMayCreateNewDocumentApprovingCycle(
    Document, Employee
  );

  PassedDocumentApprovingCycleCount :=
    FDocumentApprovingCycleResultFinder.
      GetPassedApprovingCycleCountForDocument(
        Document
      );

  Result :=
    TDocumentApprovingCycle.Create(
      Null,
      PassedDocumentApprovingCycleCount + 1,
      Now
    );
    
end;

procedure TStandardDocumentApprovingProcessControlService.
  InternalEnsureThatEmployeeMayCreateNewDocumentApprovingCycle(
    Document: IDocument;
    InitiatingEmployee: TEmployee
  );
begin

  RaiseExceptionIfDocumentIsNotAtAllowableStageForNewApprovingCycle(Document);
  RaiseExceptionIfEmployeeHasNoRightsForCreatingNewDocumentApprovingCycle(
    InitiatingEmployee, Document
  );
  
end;

function TStandardDocumentApprovingProcessControlService.
  MayEmployeeAssignDocumentApprover(
    Employee: TEmployee;
    Document: IDocument;
    Approver: TEmployee
  ): Boolean;
var TargetDocument: TDocument;
begin

  TargetDocument := Document.Self as TDocument;

  Result :=
    TargetDocument.
      WorkingRules.
        ApproverListChangingRule.MayEmployeeAssignDocumentApprover(
          Employee, Document, Approver
        );

end;

function TStandardDocumentApprovingProcessControlService.
  MayEmployeeChangeDocumentApproverInfo(
    Employee: TEmployee;
    Document: IDocument;
    Approver: TEmployee
  ): Boolean;
var TargetDocument: TDocument;
begin

  TargetDocument := Document.Self as TDocument;

  Result :=
    TargetDocument.
    WorkingRules.
    ApproverListChangingRule.
    MayEmployeeChangeDocumentApproverInfo(
      Employee, Document, Approver
    );

end;

function TStandardDocumentApprovingProcessControlService.
  MayEmployeeChangeDocumentApproverList(
    Employee: TEmployee;
    Document: IDocument
  ): Boolean;
var TargetDocument: TDocument;
begin

  TargetDocument := Document.Self as TDocument;

  Result :=
    TargetDocument.
      WorkingRules.
        ApproverListChangingRule.
          MayEmployeeChangeDocumentApproverList(
            Employee, Document
          );

end;

function TStandardDocumentApprovingProcessControlService.
  MayEmployeeRemoveDocumentApprover(
    Employee: TEmployee;
    Document: IDocument;
    Approver: TEmployee
  ): Boolean;
var TargetDocument: TDocument;
begin

  TargetDocument := Document.Self as TDocument;

  Result :=
    TargetDocument.
    WorkingRules.
    ApproverListChangingRule.
    MayEmployeeRemoveDocumentApprover(
      Employee, Document, Approver
    );

end;

function TStandardDocumentApprovingProcessControlService.
  ApproveDocumetOnBehalfOfEmployeeAndCompleteApprovingCycleIfPossible(
    Document: IDocument;
    ApprovingEmployee: TEmployee
  ): TDocumentApprovingCycleResult;
begin

  Result :=
    PerformDocumetApprovingOnBehalfOfEmployeeAndCompleteApprovingCycleIfPossible(
      Document, ApprovingEmployee, prApproved
    );
    
end;

function TStandardDocumentApprovingProcessControlService.
  NotApproveDocumetOnBehalfOfEmployeeAndCompleteApprovingCycleIfPossible(
    Document: IDocument;
    ApprovingEmployee: TEmployee
  ): TDocumentApprovingCycleResult;
begin

  Result :=
    PerformDocumetApprovingOnBehalfOfEmployeeAndCompleteApprovingCycleIfPossible(
      Document, ApprovingEmployee, prRejected
    );

end;

function TStandardDocumentApprovingProcessControlService.
  InternalCompleteDocumentApprovingCycle(
    Document: IDocument;
    CompletingEmployee: TEmployee
  ): TDocumentApprovingCycleResult;
var TargetDocument: TDocument;
begin

  FDocumentApprovingPassingMarkingRule.EnsureThatIsSatisfiedFor(
    CompletingEmployee, Document
  );

  Result := CreateCurrentDocumentApprovingCycleResultForDocument(Document);

  ChangeDocumentWorkCycleStageByApprovingCycleResult(
    Document, CompletingEmployee, Result
  );
  
  TargetDocument := Document.Self as TDocument;

  TargetDocument.InvariantsComplianceRequested := False;

  try

    Document.RemoveAllApprovers(CompletingEmployee);

  finally

    TargetDocument.InvariantsComplianceRequested := True;
    
  end;
  
end;

function TStandardDocumentApprovingProcessControlService.
  PerformDocumetApprovingOnBehalfOfEmployeeAndCompleteApprovingCycleIfPossible(
    Document: IDocument;
    PerformingEmployee: TEmployee;
    PerformingResult: TDocumentApprovingPerformingResult
  ): TDocumentApprovingCycleResult;
var DocumentSigner: TEmployee;
begin

  if PerformingResult = prApproved then
    Document.ApproveBy(PerformingEmployee)

  else if PerformingResult = prRejected then
    Document.RejectApprovingBy(PerformingEmployee)

  else begin

    raise TDocumentApprovingProcessControlServiceException.CreateFmt(
      'Обнаружен недопустимый статус ' +
      'во время выполнения согласования ' +
      'документа "%s"',
      [
        FDocumentFullNameCompilationService.CompileFullNameForDocument(
          Document
        )
      ]
    );

  end;

  if not Document.AreAllApprovingsPerformed then begin

    Result := nil;
    Exit;

  end;

  if Document.Signings.IsEmpty then begin

    raise TDocumentApprovingProcessControlServiceException.CreateFmt(
      'Не найден сотрудник из перечня подписантов ' +
      'документа "%s", от имени которого ' +
      'цикл согласования может быть завершен',
      [
        FDocumentFullNameCompilationService.CompileFullNameForDocument(
          Document
        )
      ]
    );

  end;

  DocumentSigner := Document.Signings[0].Signer;

  Result := CompleteDocumentApprovingCycle(Document, DocumentSigner);

end;

procedure TStandardDocumentApprovingProcessControlService.
  ProcessDocumentApprovingsAsResultOfDocumentApprovingCycle(
    DocumentApprovings: TDocumentApprovings
  );
var DocumentApproving: TDocumentApproving;
begin

  for DocumentApproving in DocumentApprovings do
    DocumentApproving.MarkAsRejectedIfNotPerformed;

end;

procedure TStandardDocumentApprovingProcessControlService.
  RaiseExceptionIfDocumentIsNotAtAllowableStageForNewApprovingCycle(
    Document: IDocument
  );
begin

  if Document.IsApproving then
    raise TDocumentApprovingProcessControlServiceException.CreateFmt(
            'Нельзя создать новый цикл ' +
            'согласования для документа "%s", ' +
            'так как он уже находится на ' +
            'согласовании',
            [
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

  if Document.IsSigned then
    raise TDocumentApprovingProcessControlServiceException.CreateFmt(
            'Нельзя создать новый цикла ' +
            'согласования для документа "%s", ' +
            'так как он уже подписан',
            [
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );
  
end;

procedure TStandardDocumentApprovingProcessControlService.
  RaiseExceptionIfEmployeeHasNoRightsForCreatingNewDocumentApprovingCycle(
    InitiatingEmployee: TEmployee;
    Document: IDocument
  );
begin

  if not
     FDocumentApproverListChangingRule.MayEmployeeChangeDocumentApproverList(
        InitiatingEmployee, Document
     )

  then
    raise TDocumentApprovingProcessControlServiceException.CreateFmt(
            'У сотрудника "%s" ' +
            'отсутствуют права для ' +
            'создания нового цикла ' +
            'согласования для документа ' +
            '"%s"',
            [
              InitiatingEmployee.FullName,
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

end;

end.
