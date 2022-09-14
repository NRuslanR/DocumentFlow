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

        procedure EnsureThatEmployeeMayChangeChargeList(
          Employee: TEmployee;
          Document: IDocument
        );

        procedure EnsureDocumentChargeAssignedForEmployee(
          Employee: TEmployee;
          Document: IDocument
        );

        function MayEmployeeAssignDocumentCharge(
          Employee: TEmployee;
          Document: IDocument;
          DocumentCharge: IDocumentCharge
        ): Boolean;

        function MayEmployeeChangeChargeList(
          Employee: TEmployee;
          Document: IDocument
        ): Boolean;

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
      'ƒл€ сотрудника "%s" не было назначено ' +
      'поручение по документу "%s"',
      [
        Employee.FullName,
        FDocumentFullNameCompilationService.CompileFullNameForDocument(Document)
      ]
    );
    
  except

    on E: TDocumentChargeListChangingRuleException do ;

  end;
  
end;

procedure TStandardEmployeeDocumentChargeListChangingRule.
  EnsureThatEmployeeMayAssignDocumentCharge(
    Employee: TEmployee;
    Document: IDocument;
    DocumentCharge: IDocumentCharge
  );
begin

  EnsureThatEmployeeMayChangeChargeList(Employee, Document);
  
  RaiseChargeAssigningExceptionIfChargeIsNotValid(Employee, Document, DocumentCharge);

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
  Employee: TEmployee; Document: IDocument): Boolean;
begin

  try

    EnsureThatEmployeeMayChangeChargeList(Employee, Document);
    
    Result := True;

  except

    on E: TDocumentChargeListChangingRuleException do Result := False;

  end;

end;

procedure TStandardEmployeeDocumentChargeListChangingRule.EnsureThatEmployeeMayChangeChargeList(
  Employee: TEmployee; Document: IDocument);
begin

  RaiseChargeAssigningExceptionIfDocumentIsAtNotAllowedWorkCycleStage(Document);
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
      '—ледующие получатели ' +
      'принадлежат одному и тому же ' +
      'подразделению:' + sLineBreak + '%s.' + sLineBreak +
      'ƒопустимо указывать только одного ' +
      'получател€ на подразделение',
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
      'Ќельз€ выдать, изменить или отозвать поручение по ' +
      'документу "%s", поскольку ' +
      'он находитс€ на согласовании',
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
            'Ќельз€ выдать, изменить или отозвать поручение по ' +
            'документу "%s", поскольку ' +
            'он находитс€ на исполнении',
            [
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );

  end;

  if Document.IsPerformed then begin

    raise TDocumentChargeListChangingRuleException.CreateFmt(
            'Ќельз€ выдать, изменить или отозвать' +
            ' поручение по ' +
            'документу "%s", поскольку ' +
            'он уже исполнен',
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
          '—отрудник "%s" не может выдавать, ' +
          'измен€ть или отзывать ' +
          'поручени€ по документу "%s", ' +
          'поскольку по этому документу ' +
          'ему самому было выдано поручение',
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
            '—отрудник "%s" не имеет ' +
            'полномочий дл€ выдачи, ' +
            'изменени€ или отзыва поручений ' +
            'по документу "%s"',
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
      '—отруднику "%s" или тому, за кого он ' +
      'исполн€ет об€занности, уже выдано ' +
      'поручение по документу "%s"',
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
      '—отруднику "%s" не может быть ' +
      'выдано поручение по документу ' +
      '"%s", поскольку он €вл€етс€ ' +
      'автором данного документа',
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
      '—отруднику "%s" не может быть ' +
      'выдано поручение по документу ' +
      '"%s", поскольку дл€ этого ' +
      'документа он назначен подписантом, или ' +
      '€вл€етс€ его исполн€ющим об€занности',
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
  RaiseChargeAssigningExceptionIfPerformerIsDocumentResponsible(
    Performer: TEmployee;
    Document: IDocument
  );
begin

  if Document.ResponsibleId = Performer.LegacyIdentity then begin

    raise TDocumentChargeListChangingRuleException.CreateFmt(
      '—отруднику "%s" не может быть ' +
      'выдано поручение по документу ' +
      '"%s", поскольку он €вл€етс€ ' +
      'ответственным по данному ' +
      'документу',
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
