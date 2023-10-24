unit PersonnelOrderEditingRule;

interface

uses

  StandardEmployeeDocumentEditingRule,
  PersonnelOrderControlService,
  Employee,
  Document,
  IDocumentUnit,
  EmployeeIsSameAsOrReplacingForOthersSpecification,
  AreEmployeesSubLeadersOfSameLeaderSpecification,
  AreEmployeesSecretariesOfSameLeaderSpecification,
  DocumentFullNameCompilationService,
  PersonnelOrder,
  SysUtils;

type

  TPersonnelOrderEditingRule = class (TStandardEmployeeDocumentEditingRule)

    private

      FPersonnelOrderControlService: IPersonnelOrderControlService;

    protected

      function HasEmployeeRightsForDocumentEditing(
        Employee: TEmployee;
        Document: IDocument
      ): Boolean; override;

    public

      constructor Create(
        EmployeeIsSameAsOrReplacingForOthersSpecification:
          IEmployeeIsSameAsOrReplacingForOthersSpecification;

        DocumentFullNameCompilationService:
          IDocumentFullNameCompilationService;

        AreEmployeesSubLeadersOfSameLeaderSpecification:
          IAreEmployeesSubLeadersOfSameLeaderSpecification;

        AreEmployeesSecretariesOfSameLeaderSpecification:
          IAreEmployeesSecretariesOfSameLeaderSpecification;

        PersonnelOrderControlService: IPersonnelOrderControlService
      );

  end;

implementation

{ TPersonnelOrderEditingRule }

constructor TPersonnelOrderEditingRule.Create(
  EmployeeIsSameAsOrReplacingForOthersSpecification: IEmployeeIsSameAsOrReplacingForOthersSpecification;
  DocumentFullNameCompilationService: IDocumentFullNameCompilationService;
  AreEmployeesSubLeadersOfSameLeaderSpecification: IAreEmployeesSubLeadersOfSameLeaderSpecification;
  AreEmployeesSecretariesOfSameLeaderSpecification: IAreEmployeesSecretariesOfSameLeaderSpecification;
  PersonnelOrderControlService: IPersonnelOrderControlService
);
begin

  inherited Create(
    EmployeeIsSameAsOrReplacingForOthersSpecification,
    DocumentFullNameCompilationService,
    AreEmployeesSubLeadersOfSameLeaderSpecification,
    AreEmployeesSecretariesOfSameLeaderSpecification
  );

  FPersonnelOrderControlService := PersonnelOrderControlService;

end;

function TPersonnelOrderEditingRule.HasEmployeeRightsForDocumentEditing(
  Employee: TEmployee;
  Document: IDocument
): Boolean;
var
    PersonnelOrder: TPersonnelOrder;
begin

  PersonnelOrder := Document.Self as TPersonnelOrder;
  
  Result :=
    inherited HasEmployeeRightsForDocumentEditing(Employee, Document)
    or (
      PersonnelOrder.IsSentToSigning and
      FPersonnelOrderControlService.MayEmployeeControlPersonnelOrders(
        PersonnelOrder.SubKindId, Employee
      )
    );

end;

end.
