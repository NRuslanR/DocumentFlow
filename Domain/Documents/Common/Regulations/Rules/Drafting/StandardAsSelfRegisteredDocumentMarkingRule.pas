unit StandardAsSelfRegisteredDocumentMarkingRule;

interface

uses

  EmployeeDocumentWorkingRule,
  EmployeeIsSameAsOrReplacingForOthersSpecification,
  DocumentFullNameCompilationService,
  AreEmployeesSecretariesOfSameLeaderSpecification,
  StandardEmployeeDocumentWorkingRule,
  IDocumentUnit,
  Employee,
  DomainException;

type

  TStandardAsSelfRegisteredDocumentMarkingRule =
    class (TStandardEmployeeDocumentWorkingRule)

      protected

        FAreEmployeesSecretariesOfSameLeaderSpecification:
          IAreEmployeesSecretariesOfSameLeaderSpecification;

        procedure InternalEnsureThatIsSatisfiedFor(
          Employee: TEmployee;
          Document: IDocument
        ); override;

        procedure InternalEnsureThatIsSatisfiedForEmployeeOnly(
          Employee: TEmployee;
          Document: IDocument
        ); override;

      public

        constructor Create(

          EmployeeIsSameAsOrReplacingForOthersSpecification:
            IEmployeeIsSameAsOrReplacingForOthersSpecification;

          DocumentFullNameCompilationService:
            IDocumentFullNameCompilationService;

          AreEmployeesSecretariesOfSameLeaderSpecification:
            IAreEmployeesSecretariesOfSameLeaderSpecification

        );

    end;
  

implementation

{ TStandardAsSelfRegisteredDocumentMarkingRule }

constructor TStandardAsSelfRegisteredDocumentMarkingRule.Create(

  EmployeeIsSameAsOrReplacingForOthersSpecification:
    IEmployeeIsSameAsOrReplacingForOthersSpecification;

  DocumentFullNameCompilationService:
    IDocumentFullNameCompilationService;

  AreEmployeesSecretariesOfSameLeaderSpecification:
    IAreEmployeesSecretariesOfSameLeaderSpecification

);
begin

  inherited Create(
    EmployeeIsSameAsOrReplacingForOthersSpecification,
    DocumentFullNameCompilationService
  );

  FAreEmployeesSecretariesOfSameLeaderSpecification :=
    AreEmployeesSecretariesOfSameLeaderSpecification;

end;

procedure TStandardAsSelfRegisteredDocumentMarkingRule.
  InternalEnsureThatIsSatisfiedFor(
    Employee: TEmployee;
    Document: IDocument
  );
begin

  EnsureThatIsSatisfiedForEmployeeOnly(Employee, Document);
  
  if
      FEmployeeIsSameAsOrReplacingForOthersSpecification.
        IsEmployeeSameAsOrReplacingForOtherEmployee(
          Employee,
          Document.Author
        )

  then Exit;

  if
      not
      FAreEmployeesSecretariesOfSameLeaderSpecification.
        AreEmployeesSecretariesOfSameLeader(
          Employee, Document.Author
        )
  then begin

    raise TEmployeeDocumentWorkingRuleException.CreateFmt(
      '��������� "%s" �� ����� �������� ' +
      '��������, ��� ������������������ ' +
      '��������������, ��������� �� �������� ' +
      '������� ������� ��������� ��� ����������� ' +
      '��� �����������, ��� �� �������� ' +
      '��������� ��� ���� �� ������ ' +
      '������������, ��� � �����',
      [
        Employee.FullName
      ]
    );

  end;

end;

procedure TStandardAsSelfRegisteredDocumentMarkingRule.
  InternalEnsureThatIsSatisfiedForEmployeeOnly(
    Employee: TEmployee;
    Document: IDocument
  );
begin

  if not Employee.IsSecretarySignerForTopLevelEmployee then begin

    raise TEmployeeDocumentWorkingRuleException.CreateFmt(
      '��������� "%s" �� ����� �������� ���������, ' +
      '��� ������������������ ��������������, ' +
      '��������� �� �������� ' +
      '���������-�����������',
      [
        Employee.FullName
      ]
    );

  end;

end;

end.
