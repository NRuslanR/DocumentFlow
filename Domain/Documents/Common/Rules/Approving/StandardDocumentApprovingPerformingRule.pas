unit StandardDocumentApprovingPerformingRule;

interface

uses

  EmployeeIsSameAsOrReplacingForOthersSpecification,
  DocumentFullNameCompilationService,
  DocumentApprovingPerformingRule,
  DocumentApprovings,
  IDocumentUnit,
  Employee,
  SysUtils,
  Classes;

type

  TStandardDocumentApprovingPerformingRule =
    class (TInterfacedObject, IDocumentApprovingPerformingRule)

      protected

        FEmployeeIsSameAsOrDeputyForOthersSpecification:
          IEmployeeIsSameAsOrReplacingForOthersSpecification;

        FDocumentFullNameCompilationService:
          IDocumentFullNameCompilationService;

        procedure RaiseExceptionIfDocumentIsNotAtAllowableStage(
          Document: IDocument
        );

        function IsDocumentIsAtNotAllowableStage(Document: IDocument): Boolean;
        
        function GetRealFormalApproverForApprovingEmployeeOrRaiseExceptionIfThisEmployeeHasNotRightsForDocumentApproving(
          Document: IDocument;
          FormalApprover: TEmployee;
          ApprovingEmployee: TEmployee
        ): TEmployee; 

        procedure RaiseExceptionIfApprovingAlreadyPerformedFor(
          Document: IDocument;
          RealFormalApprover: TEmployee;
          ApprovingEmployee: TEmployee
        );

      public

        constructor Create(

          EmployeeIsSameAsOrDeputyForOthersSpecification:
            IEmployeeIsSameAsOrReplacingForOthersSpecification;

          DocumentFullNameCompilationService:
            IDocumentFullNameCompilationService

        );

        function EnsureThatEmployeeCanApproveDocument(
          Document: IDocument;
          Employee: TEmployee
        ): TEmployee; virtual;

        function EnsureThatEmployeeCanApproveDocumentOnBehalfOfOther(
          Document: IDocument;
          FormalApprover: TEmployee;
          ApprovingEmployee: TEmployee
        ): TEmployee; virtual;

        procedure EnsureThatEmployeeHasOnlyRightsForDocumentApproving(
          Employee: TEmployee;
          Document: IDocument
        ); virtual;

        function CanEmployeeApproveDocument(
          Document: IDocument;
          Employee: TEmployee
        ): Boolean; virtual;

        function FindReplaceableDocumentApprovingFor(
          Document: IDocument;
          Employee: TEmployee
        ): TDocumentApproving; virtual;
        
        function CanEmployeeApproveDocumentOnBehalfOfOther(
          Document: IDocument;
          FormalApprover: TEmployee;
          ApprovingEmployee: TEmployee
        ): Boolean; virtual;

        function HasEmployeeOnlyRightsForDocumentApproving(
          Employee: TEmployee;
          Document: IDocument
        ): Boolean; virtual;

    end;

implementation

uses

  IDomainObjectUnit,
  Document,
  IDomainObjectBaseUnit,
  IDomainObjectListUnit,
  AuxDebugFunctionsUnit;
  
{ TStandardDocumentApprovingPerformingRule }

function TStandardDocumentApprovingPerformingRule.CanEmployeeApproveDocument(
  Document: IDocument;
  Employee: TEmployee
): Boolean;
begin

  try

    EnsureThatEmployeeCanApproveDocument(Document, Employee);

    Result := True;
    
  except

    on e: TDocumentApprovingPerformingRuleException do begin

      Result := False;
      
    end;

  end;

end;

function TStandardDocumentApprovingPerformingRule.
CanEmployeeApproveDocumentOnBehalfOfOther(
  Document: IDocument;
  FormalApprover, ApprovingEmployee: TEmployee
): Boolean;
begin

  try

    EnsureThatEmployeeCanApproveDocumentOnBehalfOfOther(
      Document, FormalApprover, ApprovingEmployee
    );

    Result := True;

  except

    on e: TDocumentApprovingPerformingRuleException do begin

      Result := False;
      
    end;

  end;

end;

constructor TStandardDocumentApprovingPerformingRule.Create(
  EmployeeIsSameAsOrDeputyForOthersSpecification: IEmployeeIsSameAsOrReplacingForOthersSpecification;
  DocumentFullNameCompilationService: IDocumentFullNameCompilationService
);
begin

  inherited Create;

  FEmployeeIsSameAsOrDeputyForOthersSpecification :=
    EmployeeIsSameAsOrDeputyForOthersSpecification;

  FDocumentFullNameCompilationService :=
    DocumentFullNameCompilationService;
    
end;

function TStandardDocumentApprovingPerformingRule.
EnsureThatEmployeeCanApproveDocument(
  Document: IDocument;
  Employee: TEmployee
): TEmployee;
begin

  Result :=
    EnsureThatEmployeeCanApproveDocumentOnBehalfOfOther(
      Document, Employee, Employee
    );
    
end;

function TStandardDocumentApprovingPerformingRule.
EnsureThatEmployeeCanApproveDocumentOnBehalfOfOther(
  Document: IDocument;
  FormalApprover, ApprovingEmployee: TEmployee
): TEmployee;
begin

  RaiseExceptionIfDocumentIsNotAtAllowableStage(Document);

  Result :=
    GetRealFormalApproverForApprovingEmployeeOrRaiseExceptionIfThisEmployeeHasNotRightsForDocumentApproving(
      Document, FormalApprover, ApprovingEmployee
    );

  try

    RaiseExceptionIfApprovingAlreadyPerformedFor(
      Document, Result, ApprovingEmployee
    );

  except

    on e: Exception do begin

      if not Result.IsSameAs(FormalApprover) then
        Result.Free;

      raise;
      
    end;

  end;

end;

procedure TStandardDocumentApprovingPerformingRule.
  EnsureThatEmployeeHasOnlyRightsForDocumentApproving(
    Employee: TEmployee;
    Document: IDocument
  );
var ActualAssignedApprover: TEmployee;
    FreeEmployee: IDomainObject;
begin

  RaiseExceptionIfDocumentIsNotAtAllowableStage(Document);

  ActualAssignedApprover :=
    GetRealFormalApproverForApprovingEmployeeOrRaiseExceptionIfThisEmployeeHasNotRightsForDocumentApproving(
      Document, Employee, Employee
    );

  FreeEmployee := Employee;
    
end;

function TStandardDocumentApprovingPerformingRule.
  FindReplaceableDocumentApprovingFor(
    Document: IDocument;
    Employee: TEmployee
  ): TDocumentApproving;
var
    ReplaceableApprover: TEmployee;
    FreeReplaceableApprover: IDomainObjectBase;
begin

  if IsDocumentIsAtNotAllowableStage(Document) then
    Result := nil;

  try

    ReplaceableApprover :=
      GetRealFormalApproverForApprovingEmployeeOrRaiseExceptionIfThisEmployeeHasNotRightsForDocumentApproving(
        Document, Employee, Employee
      );

    FreeReplaceableApprover := ReplaceableApprover;

    Result := Document.FindApprovingByFormalApprover(ReplaceableApprover);

  except

    on E: TDocumentApprovingPerformingRuleException do Result := nil;

  end;

end;

procedure TStandardDocumentApprovingPerformingRule.
  RaiseExceptionIfApprovingAlreadyPerformedFor(
    Document: IDocument;
    RealFormalApprover, ApprovingEmployee: TEmployee
  );
var DocumentApproving: TDocumentApproving;
begin

  DocumentApproving :=
    Document.FindApprovingByFormalApprover(RealFormalApprover);

  if not Assigned(DocumentApproving) then
    raise TDocumentApprovingPerformingRuleException.CreateFmt(
            '��������� "%s" �� ������ ' +
            '� �������� ������������ ' +
            '��������� "%s" ��� ' +
            '������������ ��� �����������',
            [
              ApprovingEmployee.FullName,
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

  if DocumentApproving.IsPerformed then
    raise TDocumentApprovingPerformingRuleException.CreateFmt(
            '��������� "%s" �� ����� ' +
            '����������� �������� "%s", ' +
            '��������� ��� ���� ������ ' +
            '�������� ��� �������� ' +
            '������������� ��� ����������',
            [
              ApprovingEmployee.FullName,
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

end;

procedure TStandardDocumentApprovingPerformingRule.
  RaiseExceptionIfDocumentIsNotAtAllowableStage(
    Document: IDocument
  );
begin

  if Document.IsSigned then begin

    raise TDocumentApprovingPerformingRuleException.CreateFmt(
            '�������� "%s" �� ����� ���� ' +
            '����������, ��� ��� �� ��� ' +
            '��������',
            [
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

  end;

  if not Document.IsApproving then begin

    raise TDocumentApprovingPerformingRuleException.CreateFmt(
            '�� ������ ������ �������� "%s" ' +
            '�� ����� ���������������, ' +
            '��������� ��� ���� ���� �� ��� ' +
            '������� ������� ������������',
            [
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

  end;

end;

function TStandardDocumentApprovingPerformingRule.IsDocumentIsAtNotAllowableStage(
  Document: IDocument
): Boolean;
begin

  Result := Document.IsSigned or not Document.IsApproving;
  
end;

function TStandardDocumentApprovingPerformingRule.
  GetRealFormalApproverForApprovingEmployeeOrRaiseExceptionIfThisEmployeeHasNotRightsForDocumentApproving(
    Document: IDocument;
    FormalApprover, ApprovingEmployee: TEmployee
  ): TEmployee;
var
    DocumentApprovers: TEmployees;
    FreeDocumentApprovers: IDomainObjectList;
    SpecificationResult: TEmployeeIsSameAsOrReplacingForOthersSpecificationResult;
    ReplaceableEmployeeFullNameString: String;
    ExceptionMessage: String;
begin

  if
    not
    FEmployeeIsSameAsOrDeputyForOthersSpecification
      .IsEmployeeSameAsOrReplacingForOtherEmployee(
        ApprovingEmployee, FormalApprover
      )
  then begin
  
    raise TDocumentApprovingPerformingRuleException.CreateFmt(
            '��������� "%s" �� ����� ' +
            '����������� �������� "%s" ' +
            '�� ����� ���������� "%s", ' +
            '��������� ��� ���������� ' +
            '������ �� �������� ' +
            '����������� �����������',
            [
              ApprovingEmployee.FullName,
              FormalApprover.FullName
            ]
          );

  end;

  DocumentApprovers := Document.FetchAllApprovers;
  FreeDocumentApprovers := DocumentApprovers;

  if DocumentApprovers.IsEmpty then begin

    raise TDocumentApprovingPerformingRuleException.CreateFmt(
            '��� ��������� "%s" ' +
            '�� �������� �� ���� ' +
            '�����������',
            [
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

  end;

  SpecificationResult :=
    FEmployeeIsSameAsOrDeputyForOthersSpecification.
      IsEmployeeSameAsOrReplacingForAnyOfEmployees(
        FormalApprover, DocumentApprovers
      );

  try

    if not SpecificationResult.IsSatisfied then begin

      if FormalApprover.IsSameAs(ApprovingEmployee) then begin

        ExceptionMessage :=
          Format(
            '� ���������� "%s" ' +
            '����������� ����� ��� ' +
            '������������ ��������� "%s"',
            [
              ApprovingEmployee.FullName,
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

      end

      else begin

        ExceptionMessage :=
          Format(
            '� ���������� "%s" ' +
            '����������� ����� ��� ' +
            '������������ ��������� "%s"',
            [
              FormalApprover.FullName,
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

      end;

      raise TDocumentApprovingPerformingRuleException.Create(ExceptionMessage);

    end

    else if SpecificationResult.IsReplaceableEmployeeCountMoreThanOne then
    begin

      ReplaceableEmployeeFullNameString :=
        SpecificationResult.FetchReplaceableEmployeeFullNamesString;

      if FormalApprover.IsSameAs(ApprovingEmployee) then begin

        ExceptionMessage :=
          Format(
            '���������������. ��������� "%s" ' +
            '�������� ����������� ����������� ' +
            '��� ���������� �������������:' +
            sLineBreak +
            ReplaceableEmployeeFullNameString,
            [
              ApprovingEmployee.FullName
            ]
          );

      end

      else begin

        ExceptionMessage :=
          Format(
            '���������������. ��������� "%s" ' +
            '�������� ����������� ����������� ' +
            '��� ���������� �������������:' +
            sLineBreak +
            ReplaceableEmployeeFullNameString,
            [
              FormalApprover.FullName
            ]
          );
          
      end;

      raise TDocumentApprovingPerformingRuleException.Create(ExceptionMessage);
      
    end

    else if not FormalApprover.IsSameAs(ApprovingEmployee) then begin

      if not Assigned(SpecificationResult.ReplaceableEmployees) then
        Result := FormalApprover

      else begin

        raise TDocumentApprovingPerformingRuleException.CreateFmt(
                '��������� "%s" �� ����� ' +
                '����������� �������� "%s" ' +
                '�� ����� "%s", ��������� ' +
                '��������� �� �������� ' +
                '���������� ������������� ' +
                '��� ������� ���������',
                [
                  ApprovingEmployee.FullName,
                  FDocumentFullNameCompilationService.CompileFullNameForDocument(
                    Document
                  ),
                  FormalApprover.FullName
                ]
              );

      end;

    end

    else if Assigned(SpecificationResult.ReplaceableEmployees) then
      Result := SpecificationResult.ReplaceableEmployees[0].Clone as TEmployee

    else Result := FormalApprover;

  finally

    FreeAndNil(SpecificationResult);
    
  end;

end;

function TStandardDocumentApprovingPerformingRule.
  HasEmployeeOnlyRightsForDocumentApproving(
    Employee: TEmployee;
    Document: IDocument
  ): Boolean;
begin

  try

    EnsureThatEmployeeHasOnlyRightsForDocumentApproving(
      Employee, Document
    );

    Result := True;
    
  except

    Result := False;

  end;

end;

end.
