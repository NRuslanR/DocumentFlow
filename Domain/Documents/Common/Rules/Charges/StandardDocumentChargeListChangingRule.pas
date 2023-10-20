unit StandardDocumentChargeListChangingRule;

interface

uses

  DocumentChargeListChangingRule,
  IDocumentUnit,
  DocumentCharges,
  DocumentChargeInterface,
  DocumentFullNameCompilationService,
  EmployeeIsSameAsOrReplacingForOthersSpecification,
  AreEmployeesSubLeadersOfSameLeaderSpecification,
  DepartmentEmployeeDistributionService,
  AreEmployeesSecretariesOfSameLeaderSpecification,
  Employee,
  SysUtils,
  Classes;

type

  TStandardEmployeeDocumentChargeListChangingRule =
    class (TInterfacedObject, IDocumentChargeListChangingRule)

      private
      
      protected

        FDocumentFullNameCompilationService:
          IDocumentFullNameCompilationService;

        FEmployeeIsSameAsOrReplacingForOthersSpecification:
          IEmployeeIsSameAsOrReplacingForOthersSpecification;

        FAreEmployeesSubLeadersOfSameLeaderSpecification:
          IAreEmployeesSubLeadersOfSameLeaderSpecification;
          
        FAreEmployeesSecretariesOfSameLeaderSpecification:
          IAreEmployeesSecretariesOfSameLeaderSpecification;

        FDepartmentEmployeeDistributionService:
          IDepartmentEmployeeDistributionService;
          
        procedure RaiseChargeAssigningExceptionIfDocumentIsAtNotAllowedWorkCycleStage(
          Document: IDocument;
          DocumentCharge: IDocumentCharge = nil
        ); virtual;

      protected

        procedure RaiseChargeAssigningExceptionIfChargeIsNotValid(
          Employee: TEmployee;
          Document: IDocument;
          DocumentCharge: IDocumentCharge
        ); virtual;

      protected

        procedure RaiseChargeAssigningExceptionIfPerformerIsOneOfDocumentSigners(
          Performer: TEmployee;
          Document: IDocument
        );

        procedure RaiseChargeAssigningExceptionIfPerformerIsDocumentAuthor(
          Performer: TEmployee;
          Document: IDocument
        );

        procedure RaiseChargeAssigningExceptionIfPerformerIsDocumentResponsible(
          Performer: TEmployee;
          Document: IDocument
        );

        procedure RaiseChargeAssigningExceptionIfEmployeeAlreadyAssignedAsPerformer(
          Employee: TEmployee;
          Document: IDocument
        );

      protected

        procedure RaiseChargeRemovingExceptionIfChargeIsNotValid(
          Employee: TEmployee;
          Document: IDocument;
          DocumentCharge: IDocumentCharge
        ); virtual;

      protected

        procedure RaiseExceptionIfAssignablePerformerAndAnyOfAssignedPerformersBelongsToSameHeadKindredDepartment(
          AssignablePerformer: TEmployee;
          AssignedPerformers: TEmployees
        );

        procedure RaiseExceptionIfEmployeeHasNotRightsForChargeListChanging(
          Employee: TEmployee;
          Document: IDocument
        ); virtual;

      public

        constructor Create(

          DepartmentEmployeeDistributionService:
            IDepartmentEmployeeDistributionService;
            
          DocumentFullNameCompilationService:
            IDocumentFullNameCompilationService;

          EmployeeIsSameAsOrReplacingForOthersSpecification:
            IEmployeeIsSameAsOrReplacingForOthersSpecification;

          AreEmployeesSubLeadersOfSameLeaderSpecification:
            IAreEmployeesSubLeadersOfSameLeaderSpecification;

          AreEmployeesSecretariesOfSameLeaderSpecification:
            IAreEmployeesSecretariesOfSameLeaderSpecification

        );

        procedure EnsureThatEmployeeMayAssignDocumentCharge(
          Employee: TEmployee;
          Document: IDocument;
          DocumentCharge: IDocumentCharge
        );

        procedure EnsureThatEmployeeMayAssignDocumentCharges(
          Employee: TEmployee;
          Document: IDocument;
          DocumentCharges: IDocumentCharges
        );

        function MayEmployeeAssignDocumentCharge(
          Employee: TEmployee;
          Document: IDocument;
          DocumentCharge: IDocumentCharge
        ): Boolean;

        procedure EnsureEmployeeMayRemoveDocumentCharge(
          Employee: TEmployee;
          Document: IDocument;
          DocumentCharge: IDocumentCharge
        );

        procedure EnsureEmployeeMayRemoveDocumentCharges(
          Employee: TEmployee;
          Document: IDocument;
          DocumentCharges: IDocumentCharges
        );

        function MayEmployeeRemoveDocumentCharge(
          Employee: TEmployee;
          Document: IDocument;
          DocumentCharge: IDocumentCharge
        ): Boolean;

        procedure EnsureThatEmployeeMayChangeChargeList(
          Employee: TEmployee;
          Document: IDocument;
          Charge: IDocumentCharge = nil
        );

        function MayEmployeeChangeChargeList(
          Employee: TEmployee;
          Document: IDocument;
          Charge: IDocumentCharge = nil
        ): Boolean;

        procedure EnsureDocumentChargeAssignedForEmployee(
          Employee: TEmployee;
          Document: IDocument
        );

        function IsDocumentChargeAssignedForEmployee(
          Employee: TEmployee;
          Document: IDocument
        ): Boolean;

    end;
    
implementation

uses

  Document,
  DocumentAcquaitance,
  IDomainObjectListUnit, DocumentSpecifications, DocumentSigningSpecification;

{ TStandardEmployeeDocumentChargeListChangingRule }

constructor TStandardEmployeeDocumentChargeListChangingRule.Create(

  DepartmentEmployeeDistributionService:
    IDepartmentEmployeeDistributionService;

  DocumentFullNameCompilationService:
    IDocumentFullNameCompilationService;

  EmployeeIsSameAsOrReplacingForOthersSpecification:
    IEmployeeIsSameAsOrReplacingForOthersSpecification;

  AreEmployeesSubLeadersOfSameLeaderSpecification:
    IAreEmployeesSubLeadersOfSameLeaderSpecification;

  AreEmployeesSecretariesOfSameLeaderSpecification:
    IAreEmployeesSecretariesOfSameLeaderSpecification

);
begin

  inherited Create;

  FDepartmentEmployeeDistributionService :=
    DepartmentEmployeeDistributionService;
    
  FDocumentFullNameCompilationService :=
    DocumentFullNameCompilationService;

  FEmployeeIsSameAsOrReplacingForOthersSpecification :=
    EmployeeIsSameAsOrReplacingForOthersSpecification;

  FAreEmployeesSubLeadersOfSameLeaderSpecification :=
    AreEmployeesSubLeadersOfSameLeaderSpecification;

  FAreEmployeesSecretariesOfSameLeaderSpecification :=
    AreEmployeesSecretariesOfSameLeaderSpecification;
    
end;

procedure TStandardEmployeeDocumentChargeListChangingRule.EnsureDocumentChargeAssignedForEmployee(
  Employee: TEmployee; Document: IDocument);
begin

  try

    RaiseChargeAssigningExceptionIfEmployeeAlreadyAssignedAsPerformer(Employee, Document);

    raise TDocumentChargeListChangingRuleException.CreateFmt(
      '��� ���������� "%s" �� ���� ��������� ' +
      '��������� �� ��������� "%s"',
      [
        Employee.FullName,
        FDocumentFullNameCompilationService.CompileFullNameForDocument(Document)
      ]
    );
    
  except

    on E: TDocumentChargeListChangingRuleException do ;

  end;
  
end;

procedure TStandardEmployeeDocumentChargeListChangingRule
  .EnsureEmployeeMayRemoveDocumentCharge(
    Employee: TEmployee;
    Document: IDocument;
    DocumentCharge: IDocumentCharge
  );
begin

  EnsureThatEmployeeMayChangeChargeList(Employee, Document);

  RaiseChargeRemovingExceptionIfChargeIsNotValid(Employee, Document, DocumentCharge);

end;

procedure TStandardEmployeeDocumentChargeListChangingRule.EnsureEmployeeMayRemoveDocumentCharges(
  Employee: TEmployee;
  Document: IDocument;
  DocumentCharges: IDocumentCharges
);
var
    Charge: IDocumentCharge;
begin

  for Charge in DocumentCharges do
    EnsureEmployeeMayRemoveDocumentCharge(Employee, Document, Charge);
    
end;

procedure TStandardEmployeeDocumentChargeListChangingRule.
  EnsureThatEmployeeMayAssignDocumentCharge(
    Employee: TEmployee;
    Document: IDocument;
    DocumentCharge: IDocumentCharge
  );
begin

  EnsureThatEmployeeMayChangeChargeList(Employee, Document, DocumentCharge);
  
  RaiseChargeAssigningExceptionIfChargeIsNotValid(Employee, Document, DocumentCharge);

end;

procedure TStandardEmployeeDocumentChargeListChangingRule.EnsureThatEmployeeMayAssignDocumentCharges(
  Employee: TEmployee;
  Document: IDocument;
  DocumentCharges: IDocumentCharges
);
var
    Charge: IDocumentCharge;
begin

  for Charge in DocumentCharges do
    EnsureThatEmployeeMayAssignDocumentCharge(Employee, Document, Charge);
    
end;

function TStandardEmployeeDocumentChargeListChangingRule.
  MayEmployeeAssignDocumentCharge(
    Employee: TEmployee;
    Document: IDocument;
    DocumentCharge: IDocumentCharge
  ): Boolean;
begin

  try

    EnsureThatEmployeeMayAssignDocumentCharge(
      Employee, Document, DocumentCharge
    );

    Result := True;
    
  except

    on e: TDocumentChargeListChangingRuleException do begin

      Result := False;
      
    end;

  end;

end;

function TStandardEmployeeDocumentChargeListChangingRule.MayEmployeeChangeChargeList(
  Employee: TEmployee;
  Document: IDocument;
  Charge: IDocumentCharge
): Boolean;
begin

  try

    EnsureThatEmployeeMayChangeChargeList(Employee, Document, Charge);
    
    Result := True;

  except

    on E: TDocumentChargeListChangingRuleException do Result := False;

  end;

end;

function TStandardEmployeeDocumentChargeListChangingRule.MayEmployeeRemoveDocumentCharge(
  Employee: TEmployee;
  Document: IDocument;
  DocumentCharge: IDocumentCharge
): Boolean;
begin

  try

    EnsureEmployeeMayRemoveDocumentCharge(Employee, Document, DocumentCharge);

    Result := True;

  except

    on E: TDocumentChargeListChangingRuleException do Result := False;

  end;

end;

procedure TStandardEmployeeDocumentChargeListChangingRule.EnsureThatEmployeeMayChangeChargeList(
  Employee: TEmployee;
  Document: IDocument;
  Charge: IDocumentCharge
);
begin

  RaiseChargeAssigningExceptionIfDocumentIsAtNotAllowedWorkCycleStage(Document, Charge);
  RaiseExceptionIfEmployeeHasNotRightsForChargeListChanging(Employee, Document);
  
end;

function TStandardEmployeeDocumentChargeListChangingRule.IsDocumentChargeAssignedForEmployee(
  Employee: TEmployee; Document: IDocument): Boolean;
begin

  try

    EnsureDocumentChargeAssignedForEmployee(Employee, Document);

    Result := True;

  except

    on E: TDocumentChargeListChangingRuleException do Result := False;

  end;

end;

procedure TStandardEmployeeDocumentChargeListChangingRule.
  RaiseExceptionIfAssignablePerformerAndAnyOfAssignedPerformersBelongsToSameHeadKindredDepartment(
    AssignablePerformer: TEmployee;
    AssignedPerformers: TEmployees
  );
var SameHeadKindredDepartmentAssignedPerformers: TEmployees;
    FreeSameHeadKindredDepartmentAssignedPerformers: IDomainObjectList;

  function CreatePerformerListStringFrom(Employees: TEmployees): String;
  var Employee: TEmployee;
  begin

    for Employee in Employees do begin

      if Result = '' then
        Result := '"' + Employee.FullName + '"'

      else
        Result := Result + ', "' + Employee.FullName + '"';

    end;

  end;

begin

  SameHeadKindredDepartmentAssignedPerformers :=
    FDepartmentEmployeeDistributionService.
      GetEmployeesThatBelongsToSameHeadKindredDepartmentAsTargetEmployee(
        AssignedPerformers,
        AssignablePerformer
      );

  FreeSameHeadKindredDepartmentAssignedPerformers :=
    SameHeadKindredDepartmentAssignedPerformers;

  if Assigned(SameHeadKindredDepartmentAssignedPerformers) then begin

    SameHeadKindredDepartmentAssignedPerformers.AddDomainObject(
      AssignablePerformer
    );
    
    raise TDocumentChargeListChangingRuleException.CreateFmt(
      '��������� ���������� ' +
      '����������� ������ � ���� �� ' +
      '�������������:' + sLineBreak + '%s.' + sLineBreak +
      '��������� ��������� ������ ������ ' +
      '���������� �� �������������',
      [
        CreatePerformerListStringFrom(
          SameHeadKindredDepartmentAssignedPerformers
        )
      ]
    );

  end;

  
end;

procedure TStandardEmployeeDocumentChargeListChangingRule.
  RaiseChargeAssigningExceptionIfDocumentIsAtNotAllowedWorkCycleStage(
    Document: IDocument;
    DocumentCharge: IDocumentCharge
  );
begin

  if Document.IsApproving then begin

    Raise TDocumentChargeListChangingRuleException.CreateFmt(
      '������ ������, �������� ��� �������� ��������� �� ' +
      '��������� "%s", ��������� ' +
      '�� ��������� �� ������������',
      [
        FDocumentFullNameCompilationService.CompileFullNameForDocument(
          Document
        )
      ]
    );

  end;

  if
      Assigned(DocumentCharge)
      and (DocumentCharge.Self is TDocumentAcquaitance)

  then Exit;

  if Document.IsPerforming then begin

    raise TDocumentChargeListChangingRuleException.CreateFmt(
            '������ ������, �������� ��� �������� ��������� �� ' +
            '��������� "%s", ��������� ' +
            '�� ��������� �� ����������',
            [
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

  end;

  if Document.IsPerformed then begin

    raise TDocumentChargeListChangingRuleException.CreateFmt(
            '������ ������, �������� ��� ��������' +
            ' ��������� �� ' +
            '��������� "%s", ��������� ' +
            '�� ��� ��������',
            [
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

  end;
  
end;

procedure TStandardEmployeeDocumentChargeListChangingRule.
  RaiseExceptionIfEmployeeHasNotRightsForChargeListChanging(
    Employee: TEmployee;
    Document: IDocument
  );
var
    EmployeeIsAuthorOrHisDeputy: Boolean;
    EmployeeIsLeaderOfAuthor: Boolean;
    EmployeeIsOneOfDocumentSigners: Boolean;
    EmployeeIsOneOfDocumentPerformers: Boolean;
begin

  EmployeeIsAuthorOrHisDeputy :=
    FEmployeeIsSameAsOrReplacingForOthersSpecification.
      IsEmployeeSameAsOrReplacingForOtherEmployee(
        Employee, Document.Author
      );

  EmployeeIsLeaderOfAuthor :=
    Document.Author.IsEmployeeLeaderForThis(Employee);


  EmployeeIsOneOfDocumentSigners :=
    TDocument(Document.Self)
      .Specifications
        .DocumentSigningSpecification
          .IsEmployeeAnyOfDocumentSigners(Employee, Document);

  if
    TDocument(Document.Self)
      .Specifications
        .DocumentChargesSpecification
          .IsDocumentChargeAssignedForEmployee(Employee, Document)
  then begin

    raise TDocumentChargeListChangingRuleException.CreateFmt(
          '��������� "%s" �� ����� ��������, ' +
          '�������� ��� �������� ' +
          '��������� �� ��������� "%s", ' +
          '��������� �� ����� ��������� ' +
          '��� ������ ���� ������ ���������',
          [
            Employee.FullName,
            FDocumentFullNameCompilationService.CompileFullNameForDocument(
              Document
            )
          ]
        );

  end;

  if

      not(
        EmployeeIsAuthorOrHisDeputy or

        FAreEmployeesSubLeadersOfSameLeaderSpecification.
          AreEmployeesSubLeadersOfSameLeader(
            Employee, Document.Author
          )

        or

        FAreEmployeesSecretariesOfSameLeaderSpecification.
          AreEmployeesSecretariesOfSameLeader(
            Employee, Document.Author
          )

        or
        EmployeeIsLeaderOfAuthor or
        EmployeeIsOneOfDocumentSigners
      )

  then begin

    raise TDocumentChargeListChangingRuleException.CreateFmt(
            '��������� "%s" �� ����� ' +
            '���������� ��� ������, ' +
            '��������� ��� ������ ��������� ' +
            '�� ��������� "%s"',
            [
              Employee.FullName,
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

  end;

end;


procedure TStandardEmployeeDocumentChargeListChangingRule.
  RaiseChargeAssigningExceptionIfChargeIsNotValid(
    Employee: TEmployee;
    Document: IDocument;
    DocumentCharge: IDocumentCharge
  );
var
    Performer: TEmployee;
    AssignedPerformers: TEmployees;
    FreeAssignedPerformers: IDomainObjectList;
begin

  Performer := DocumentCharge.Performer;
  AssignedPerformers := Document.FetchAllPerformers;
  FreeAssignedPerformers := AssignedPerformers;

  if not Employee.IsSecretarySignerFor(Performer) then begin

    RaiseChargeAssigningExceptionIfPerformerIsOneOfDocumentSigners(
      Performer, Document
    );

    RaiseChargeAssigningExceptionIfPerformerIsDocumentAuthor(
      Performer, Document
    );

    RaiseChargeAssigningExceptionIfPerformerIsDocumentResponsible(
      Performer, Document
    );

  end;

  RaiseChargeAssigningExceptionIfEmployeeAlreadyAssignedAsPerformer(
    Performer, Document
  );

end;

procedure TStandardEmployeeDocumentChargeListChangingRule.
  RaiseChargeAssigningExceptionIfEmployeeAlreadyAssignedAsPerformer(
    Employee: TEmployee;
    Document: IDocument
  );
begin

  if
    TDocument(Document.Self)
      .Specifications
        .DocumentChargesSpecification
          .IsDocumentChargeAssignedForEmployee(Employee, Document)
  then begin
    
    raise TDocumentChargeListChangingRuleException.CreateFmt(
      '���������� "%s" ��� ����, �� ���� �� ' +
      '��������� �����������, ��� ������ ' +
      '��������� �� ��������� "%s"',
      [
        Employee.FullName,
        FDocumentFullNameCompilationService.CompileFullNameForDocument(
          Document
        )
      ]
    );
            
  end;

end;

procedure TStandardEmployeeDocumentChargeListChangingRule.
  RaiseChargeAssigningExceptionIfPerformerIsDocumentAuthor(
    Performer: TEmployee;
    Document: IDocument
  );
begin

  if Document.Author.IsSameAs(Performer) then begin

    raise TDocumentChargeListChangingRuleException.CreateFmt(
      '���������� "%s" �� ����� ���� ' +
      '������ ��������� �� ��������� ' +
      '"%s", ��������� �� �������� ' +
      '������� ������� ���������',
      [
        Performer.FullName,
        FDocumentFullNameCompilationService.CompileFullNameForDocument(
          Document
        )
      ]
    );

  end;

end;

procedure TStandardEmployeeDocumentChargeListChangingRule.
  RaiseChargeAssigningExceptionIfPerformerIsOneOfDocumentSigners(
  Performer: TEmployee;
  Document: IDocument
);
begin

  if
    TDocument(Document.Self)
      .Specifications
        .DocumentSigningSpecification
          .IsEmployeeAnyOfDocumentSigners(Performer, Document)
  then begin

    raise TDocumentChargeListChangingRuleException.CreateFmt(
      '���������� "%s" �� ����� ���� ' +
      '������ ��������� �� ��������� ' +
      '"%s", ��������� ��� ����� ' +
      '��������� �� �������� �����������, ��� ' +
      '�������� ��� ����������� �����������',
      [
        Performer.FullName,
        FDocumentFullNameCompilationService.CompileFullNameForDocument(
          Document
        )
      ]
    );

  end;

end;

procedure TStandardEmployeeDocumentChargeListChangingRule
  .RaiseChargeRemovingExceptionIfChargeIsNotValid(
    Employee: TEmployee;
    Document: IDocument;
    DocumentCharge: IDocumentCharge
  );
var
    DocumentObj: TDocument;
begin

  DocumentObj := TDocument(Document.Self);

  if
    not
    FEmployeeIsSameAsOrReplacingForOthersSpecification.IsEmployeeSameAsOrReplacingForOtherEmployee(
      Employee, Document.Author
    )
    and not
    DocumentObj.Specifications.DocumentSigningSpecification.IsEmployeeAnyOfDocumentSigners(
      Employee, Document
    )
  then begin

    raise TDocumentChargeListChangingRuleException.CreateFmt(
      '����������� ����� ��� �������� ��������� ' +
      '���������� "%s"',
      [
        DocumentCharge.Performer.FullName
      ]
    );

  end;

end;

procedure TStandardEmployeeDocumentChargeListChangingRule.
  RaiseChargeAssigningExceptionIfPerformerIsDocumentResponsible(
    Performer: TEmployee;
    Document: IDocument
  );
begin

  if Document.ResponsibleId = Performer.LegacyIdentity then begin

    raise TDocumentChargeListChangingRuleException.CreateFmt(
      '���������� "%s" �� ����� ���� ' +
      '������ ��������� �� ��������� ' +
      '"%s", ��������� �� �������� ' +
      '������������� �� ������� ' +
      '���������',
      [
        Performer.FullName,
        FDocumentFullNameCompilationService.CompileFullNameForDocument(
          Document
        )
      ]
    );

  end;
      
end;

end.
