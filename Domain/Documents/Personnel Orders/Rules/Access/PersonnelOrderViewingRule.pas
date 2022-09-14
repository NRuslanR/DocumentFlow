unit PersonnelOrderViewingRule;

interface

uses

  StandardEmployeeDocumentViewingRule,
  Employee,
  IDocumentUnit,
  PersonnelOrder,
  DocumentApprovingCycleResultFinder,
  PersonnelOrderControlService,
  DocumentFullNameCompilationService,
  EmployeeIsSecretaryForAnyOfEmployeesSpecification,
  EmployeeIsSameAsOrReplacingForOthersSpecification,
  AreEmployeesSubLeadersOfSameLeaderSpecification,
  AreEmployeesSecretariesOfSameLeaderSpecification,
  WorkspaceEmployeeDistributionSpecification,
  SysUtils;

type

  TPersonnelOrderViewingRule = class (TStandardEmployeeDocumentViewingRule)

    private

      FPersonnelOrderControlService: IPersonnelOrderControlService;
      
    protected

      function HasEmployeeAccessRightsForDocumentViewing(
        Employee: TEmployee;
        Document: IDocument
      ): Boolean; override;

    public

      constructor Create(
        DocumentApprovingCycleResultFinder:
          IDocumentApprovingCycleResultFinder;

        DocumentFullNameCompilationService:
          IDocumentFullNameCompilationService;

        EmployeeIsSecretaryForAnyOfEmployeesSpecification:
          IEmployeeIsSecretaryForAnyOfEmployeesSpecification;

        EmployeeIsSameAsOrReplacingForOthersSpecification:
          IEmployeeIsSameAsOrReplacingForOthersSpecification;

        AreEmployeesSubLeadersOfSameLeaderSpecification:
          IAreEmployeesSubLeadersOfSameLeaderSpecification;

        AreEmployeesSecretariesOfSameLeaderSpecification:
          IAreEmployeesSecretariesOfSameLeaderSpecification;

        WorkspaceEmployeeDistributionSpecification:
          IWorkspaceEmployeeDistributionSpecification;

        PersonnelOrderControlService: IPersonnelOrderControlService
      );

  end;
  
implementation

{ TPersonnelOrderViewingRule }

constructor TPersonnelOrderViewingRule.Create(
  DocumentApprovingCycleResultFinder: IDocumentApprovingCycleResultFinder;
  DocumentFullNameCompilationService: IDocumentFullNameCompilationService;
  EmployeeIsSecretaryForAnyOfEmployeesSpecification: IEmployeeIsSecretaryForAnyOfEmployeesSpecification;
  EmployeeIsSameAsOrReplacingForOthersSpecification: IEmployeeIsSameAsOrReplacingForOthersSpecification;
  AreEmployeesSubLeadersOfSameLeaderSpecification: IAreEmployeesSubLeadersOfSameLeaderSpecification;
  AreEmployeesSecretariesOfSameLeaderSpecification: IAreEmployeesSecretariesOfSameLeaderSpecification;
  WorkspaceEmployeeDistributionSpecification: IWorkspaceEmployeeDistributionSpecification;
  PersonnelOrderControlService: IPersonnelOrderControlService
);
begin

  inherited Create(
    DocumentApprovingCycleResultFinder,
    DocumentFullNameCompilationService,
    EmployeeIsSecretaryForAnyOfEmployeesSpecification,
    EmployeeIsSameAsOrReplacingForOthersSpecification,
    AreEmployeesSubLeadersOfSameLeaderSpecification,
    AreEmployeesSecretariesOfSameLeaderSpecification,
    WorkspaceEmployeeDistributionSpecification
  );

  FPersonnelOrderControlService := PersonnelOrderControlService;
  
end;

function TPersonnelOrderViewingRule.HasEmployeeAccessRightsForDocumentViewing(
  Employee: TEmployee;
  Document: IDocument
): Boolean;
var
    PersonnelOrder: TPersonnelOrder;
begin

  Result := inherited HasEmployeeAccessRightsForDocumentViewing(Employee, Document);

  if Result then Exit;
  
  PersonnelOrder := Document.Self as TPersonnelOrder;

  Result :=
    FPersonnelOrderControlService
      .MayEmployeeControlPersonnelOrders(PersonnelOrder.SubKindId, Employee);

end;

end.
