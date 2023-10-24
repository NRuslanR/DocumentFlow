unit StandardInternalDocumentChargeListChangingRule;

interface

uses

  StandardDocumentChargeListChangingRule,
  DepartmentEmployeeDistributionService,
  DocumentChargeListChangingRule,
  DocumentFullNameCompilationService,
  EmployeeIsSameAsOrReplacingForOthersSpecification,
  AreEmployeesSubLeadersOfSameLeaderSpecification,
  AreEmployeesSecretariesOfSameLeaderSpecification,
  DepartmentEmployeeDistributionSpecification,
  DocumentChargeInterface,
  Employee,
  IDocumentUnit,
  SysUtils,
  Classes;

type

  TStandardInternalDocumentChargeListChangingRule =
    class (TStandardEmployeeDocumentChargeListChangingRule)

      protected

        FDepartmentEmployeeDistributionSpecification:
          IDepartmentEmployeeDistributionSpecification;

      protected

        procedure RaiseChargeAssigningExceptionIfChargeIsNotValid(
          Employee: TEmployee;
          Document: IDocument;
          Charge: IDocumentCharge
        ); override;

        procedure RaiseChargeAssigningExceptionIfPerformerIsNotLeader(
          Performer: TEmployee;
          Document: IDocument;
          AssigningEmployee: TEmployee
        );

        procedure RaiseChargeAssigningExceptionIfPerformerAndAssigningEmployeeNotBelongsToSameHeadKindredDepartment(
          Performer: TEmployee;
          Document: IDocument;
          AssigningEmployee: TEmployee
        );

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
            IAreEmployeesSecretariesOfSameLeaderSpecification;

          DepartmentEmployeeDistributionSpecification:
            IDepartmentEmployeeDistributionSpecification

        );
      
    end;

implementation

uses

  IDomainObjectBaseListUnit;

{ TStandardInternalDocumentChargeListChangingRule }

constructor TStandardInternalDocumentChargeListChangingRule.Create(
  DepartmentEmployeeDistributionService: IDepartmentEmployeeDistributionService;
  DocumentFullNameCompilationService: IDocumentFullNameCompilationService;
  EmployeeIsSameAsOrReplacingForOthersSpecification: IEmployeeIsSameAsOrReplacingForOthersSpecification;
  AreEmployeesSubLeadersOfSameLeaderSpecification: IAreEmployeesSubLeadersOfSameLeaderSpecification;
  AreEmployeesSecretariesOfSameLeaderSpecification: IAreEmployeesSecretariesOfSameLeaderSpecification;
  DepartmentEmployeeDistributionSpecification: IDepartmentEmployeeDistributionSpecification
);
begin

  inherited Create(
    DepartmentEmployeeDistributionService,
    DocumentFullNameCompilationService,
    EmployeeIsSameAsOrReplacingForOthersSpecification,
    AreEmployeesSubLeadersOfSameLeaderSpecification,
    AreEmployeesSecretariesOfSameLeaderSpecification
  );

  FDepartmentEmployeeDistributionSpecification :=
    DepartmentEmployeeDistributionSpecification;

end;

procedure TStandardInternalDocumentChargeListChangingRule.
  RaiseChargeAssigningExceptionIfChargeIsNotValid(
    Employee: TEmployee;
    Document: IDocument;
    Charge: IDocumentCharge
  );
begin

  inherited RaiseChargeAssigningExceptionIfChargeIsNotValid(
    Employee, Document, Charge
  );

  RaiseChargeAssigningExceptionIfPerformerIsNotLeader(
    Employee, Document, Charge.Performer
  );
  
  RaiseChargeAssigningExceptionIfPerformerAndAssigningEmployeeNotBelongsToSameHeadKindredDepartment(
    Employee, Document, Charge.Performer
  );
  
end;

procedure TStandardInternalDocumentChargeListChangingRule.
  RaiseChargeAssigningExceptionIfPerformerIsNotLeader(
    Performer: TEmployee;
    Document: IDocument;
    AssigningEmployee: TEmployee
  );
begin

  if not Performer.IsLeader then begin

    Raise TDocumentChargeListChangingRuleException.CreateFmt(
      'Сотрудник "%s" не может быть указан получателем ' +
      'внутреннего документа, так как не имеет должности ' +
      'руководителя',
      [
        Performer.FullName
      ]
    );
    
  end;

end;

procedure TStandardInternalDocumentChargeListChangingRule.
  RaiseChargeAssigningExceptionIfPerformerAndAssigningEmployeeNotBelongsToSameHeadKindredDepartment(
    Performer: TEmployee;
    Document: IDocument;
    AssigningEmployee: TEmployee
  );
var VerifiableEmployees: TEmployees;
    FreeVerifiableEmployees: IDomainObjectBaseList;
begin

  VerifiableEmployees := TEmployees.Create;

  FreeVerifiableEmployees := VerifiableEmployees;
  
  VerifiableEmployees.Add(Performer);
  VerifiableEmployees.Add(AssigningEmployee);

  if
    not FDepartmentEmployeeDistributionSpecification.
          AreEmployeesBelongsToSameHeadKindredDepartment(
            VerifiableEmployees
          )
  then begin

    raise TDocumentChargeListChangingRuleException.CreateFmt(
      'Сотрудник "%s" не может указать сотрудника "%s" ' +
      'получателем внутреннего документа, поскольку ' +
      'они не относятся к одному и тому же подразделению',
      [
        AssigningEmployee.FullName,
        Performer.FullName
      ]
    );

  end;
  
end;

end.
