unit StandardInternalDocumentDraftingRule;

interface

uses

  StandardDocumentDraftingRule,
  IDocumentUnit,
  DocumentResponsibleFinder,
  DocumentDraftingRuleOptions,
  DocumentDraftingRule,
  Employee,
  DocumentSigningSpecification,
  DepartmentEmployeeDistributionSpecification,
  SysUtils,
  Classes;

type

  TStandardInternalDocumentDraftingRule = class (TStandardDocumentDraftingRule)

    protected

      FDepartmentEmployeeDistributionSpecification: IDepartmentEmployeeDistributionSpecification;
      
    protected

      function IsDocumentResponsibleCorrect(
        Document: IDocument;
        Options: IDocumentDraftingRuleOptions;
        var FailMessage: String
      ): Boolean; override;

    public

      constructor Create(
        DocumentResponsibleFinder: IDocumentResponsibleFinder;
        DocumentSigningSpecification: IDocumentSigningSpecification;
        DepartmentEmployeeDistributionSpecification: IDepartmentEmployeeDistributionSpecification;
        Options: IDocumentDraftingRuleCompoundOptions
      );
      
  end;
  
implementation

uses

  IDomainObjectUnit,
  IDomainObjectListUnit;
  
{ TStandardInternalDocumentDraftingRule }

constructor TStandardInternalDocumentDraftingRule.Create(
  DocumentResponsibleFinder: IDocumentResponsibleFinder;
  DocumentSigningSpecification: IDocumentSigningSpecification;
  DepartmentEmployeeDistributionSpecification: IDepartmentEmployeeDistributionSpecification;
  Options: IDocumentDraftingRuleCompoundOptions
);
begin

  inherited Create(DocumentResponsibleFinder, DocumentSigningSpecification, Options);

  FDepartmentEmployeeDistributionSpecification := DepartmentEmployeeDistributionSpecification;
  
end;

function TStandardInternalDocumentDraftingRule.IsDocumentResponsibleCorrect(
  Document: IDocument;
  Options: IDocumentDraftingRuleOptions;
  var FailMessage: String
): Boolean;
var Responsible: TEmployee;
    FreeResponsible: IDomainObject;
    VerifiableEmployees: TEmployees;
    FreeVerifiableEmployees: IDomainObjectList;
begin

  Result := IsResponsibleAssigned(Document);

  if not Result then begin

    FailMessage := 'Не назначен исполнитель';
    Exit;
    
  end;

  Responsible :=
    FDocumentResponsibleFinder.FindDocumentResponsibleById(
      Document.ResponsibleId
    );

  FreeResponsible := Responsible;

  Result := Assigned(Responsible);
  
  if not Result then begin

    FailMessage :=
      'Не найдена информация об исполнителе';
    Exit;
    
  end;

  VerifiableEmployees := Document.FetchAllSigners;

  FreeVerifiableEmployees := VerifiableEmployees;

  VerifiableEmployees.Add(Responsible);

  Result :=
    FDepartmentEmployeeDistributionSpecification.
      AreEmployeesBelongsToSameHeadKindredDepartment(
        VerifiableEmployees
      );

  if not Result then begin

    FailMessage :=
      'Исполнитель и подписант ' +
      'внутреннего документа ' +
      'не относятся к одному и тому же ' +
      'подразделению';
    
  end;

end;

end.
