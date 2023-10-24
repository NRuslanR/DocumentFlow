unit StandardDocumentUsageEmployeeAccessRightsService;

interface

uses

  DocumentFullNameCompilationService,
  DocumentUsageEmployeeAccessRightsInfo,
  DocumentUsageEmployeeAccessRightsService,
  GeneralDocumentChargeSheetAccessRightsService,
  EmployeeDocumentKindAccessRightsService,
  DocumentChargeSheetFinder,
  IDocumentUnit,
  Employee,
  Document,
  SysUtils,
  DocumentChargeSheet,
  IDocumentChargeSheetUnit,
  DocumentKind,
  DocumentRelationsUnit,
  EmployeeFinder,
  DocumentRelationsFinder,
  EmployeeDocumentKindAccessRightsInfo,
  Classes;

type

  TStandardDocumentUsageEmployeeAccessRightsService =
    class (TInterfacedObject, IDocumentUsageEmployeeAccessRightsService)

      protected

        FDocumentFullNameCompilationService:
          IDocumentFullNameCompilationService;

        FDocumentRelationsFinder: IDocumentRelationsFinder;

        FGeneralDocumentChargeSheetAccessRightsService:
          IGeneralDocumentChargeSheetAccessRightsService;

        FEmployeeDocumentKindAccessRightsService:
          IEmployeeDocumentKindAccessRightsService;

        function IsDocumentCanBeViewedByEmployee(
          Document: TDocument;
          Employee: TEmployee
        ): Boolean; virtual;

        function IsDocumentCanBeRemovedByEmployee(
          Document: TDocument;
          Employee: TEmployee
        ): Boolean; virtual;
        
        function IsDocumentCanBeSignedByEmployee(
          Document: TDocument;
          Employee: TEmployee
        ): Boolean; virtual;

        function IsDocumentCanBeMarkedAsSigned(
          Document: TDocument;
          Employee: TEmployee
        ): Boolean; virtual;

        function IsDocumentCanBeRejectedFromSigningByEmployee(
          Document: TDocument;
          Employee: TEmployee
        ): Boolean; virtual;

        function IsDocumentCanBePerformedByEmployee(
          Document: TDocument;
          Employee: TEmployee
        ): Boolean; virtual;

        function IsDocumentCanBeSentToSigningByEmployee(
          Document: TDocument;
          Employee: TEmployee
        ): Boolean; virtual;

        function IsDocumentCanBeSentToApprovingByEmployee(
          Document: TDocument;
          Employee: TEmployee
        ): Boolean; virtual;
        
        function IsDocumentCanBeSentToPerformingByEmployee(
          Document: TDocument;
          Employee: TEmployee
        ): Boolean; virtual;

        function IsDocumentCanBeChangedByEmployee(
          Document: TDocument;
          Employee: TEmployee
        ): Boolean; virtual;

        function IsDocumentCanBeMarkedAsSelfRegistered(
          Document: TDocument;
          Employee: TEmployee
        ): Boolean; virtual;

        function IsDocumentApproverListCanBeChangedByEmployee(
          Document: TDocument;
          Employee: TEmployee
        ): Boolean; virtual;

        function IsDocumentApproversInfoCanBeChangedByEmployee(
          Document: TDocument;
          Employee: TEmployee
        ): Boolean; virtual;
        
        function IsDocumentCanBeApprovedByEmployee(
          Document: TDocument;
          Employee: TEmployee
        ): Boolean; virtual;

        function IsDocumentCanBeRejectedFromApprovingByEmployee(
          Document: TDocument;
          Employee: TEmployee
        ): Boolean; virtual;

        function IsDocumentApprovingCanBeCompletedByEmployee(
          Document: TDocument;
          Employee: TEmployee
        ): Boolean; virtual;
        
      protected

        function HasEmployeeRightsForDocumentSigning(
          Employee: TEmployee;
          Document: TDocument
        ): Boolean; virtual;

        function HasEmployeeRightsForDocumentSigningMarking(
          Employee: TEmployee;
          Document: TDocument
        ): Boolean; virtual;

        function HasEmployeeRightsForApproving(
          Employee: TEmployee;
          Document: TDocument
        ): Boolean; virtual;

        function HasEmployeeRightsForSendingToApproving(
          Employee: TEmployee;
          Document: TDocument
        ): Boolean; virtual;
        
        function HasEmployeeRightsForSendingToSigning(
          Employee: TEmployee;
          Document: TDocument
        ): Boolean; virtual;

        function HasEmployeeRightsForSendingToPerforming(
          Employee: TEmployee;
          Document: TDocument
        ): Boolean; virtual;

        function HasEmployeeRightsForRejectingFromSigning(
          Employee: TEmployee;
          Document: TDocument
        ): Boolean; virtual;

        function HasEmployeeRightsForRejectingFromApproving(
          Employee: TEmployee;
          Document: TDocument
        ): Boolean; virtual;


        function GetSourceDocumentRelationsForGettingRelatedDocumentUsageAccessRights(
          const SourceDocument: TDocument
        ): TDocumentRelations; virtual;
        
      public

        constructor Create(

          DocumentFullNameCompilationService:
            IDocumentFullNameCompilationService;

          DocumentRelationsFinder: IDocumentRelationsFinder;

          GeneralDocumentChargeSheetAccessRightsService:
            IGeneralDocumentChargeSheetAccessRightsService;

          EmployeeDocumentKindAccessRightsService:
            IEmployeeDocumentKindAccessRightsService

        );
        
        function GetDocumentUsageAccessRightsInfoForEmployee(
          Document: IDocument;
          Employee: TEmployee
        ): TDocumentUsageEmployeeAccessRightsInfo; virtual;

        function EnsureThatEmployeeHasDocumentUsageAccessRights(
          Document: IDocument;
          Employee: TEmployee
        ): TDocumentUsageEmployeeAccessRightsInfo; virtual;

        function EnsureThatEmployeeHasRelatedDocumentUsageAccessRights(
          SourceDocument: IDocument;
          RelatedDocument: IDocument;
          RelatedDocumentKind: TDocumentKind;
          Employee: TEmployee
        ): TDocumentUsageEmployeeAccessRightsInfo; virtual;
        
    end;

implementation

uses

  ServiceNote,
  AuxDebugFunctionsUnit,
  IDomainObjectBaseUnit,
  IDomainObjectListUnit,
  EmployeeDocumentWorkingRules,
  DocumentApprovingPerformingRule,
  DocumentSigningMarkingRule,
  DocumentChargeSheetsServiceRegistry;

{ TStandardDocumentUsageEmployeeAccessRightsService }

constructor TStandardDocumentUsageEmployeeAccessRightsService.Create(

  DocumentFullNameCompilationService:
    IDocumentFullNameCompilationService;

  DocumentRelationsFinder: IDocumentRelationsFinder;

  GeneralDocumentChargeSheetAccessRightsService:
    IGeneralDocumentChargeSheetAccessRightsService;

  EmployeeDocumentKindAccessRightsService:
    IEmployeeDocumentKindAccessRightsService
  
);
begin

  inherited Create;

  FDocumentFullNameCompilationService :=
    DocumentFullNameCompilationService;

  FDocumentRelationsFinder := DocumentRelationsFinder;

  FGeneralDocumentChargeSheetAccessRightsService :=
    GeneralDocumentChargeSheetAccessRightsService;

  FEmployeeDocumentKindAccessRightsService :=
    EmployeeDocumentKindAccessRightsService;
    
end;

function TStandardDocumentUsageEmployeeAccessRightsService.
  EnsureThatEmployeeHasDocumentUsageAccessRights(
    Document: IDocument;
    Employee: TEmployee
  ): TDocumentUsageEmployeeAccessRightsInfo;
begin

  Result := GetDocumentUsageAccessRightsInfoForEmployee(Document, Employee);

  if
    Result.AllDocumentAccessRightsAbsent
    and
    Result.AllDocumentChargeSheetsAccessRightsAbsent
  then begin

    Result.Destroy;

    raise Exception.CreateFmt(
            '” сотрудника "%s" ' +
            'отсутствуют права на ' +
            'доступ к документу "%s"',
            [
              Employee.FullName,
              FDocumentFullNameCompilationService.CompileFullNameForDocument(
                Document
              )
            ]
          );
          
  end;

end;

function TStandardDocumentUsageEmployeeAccessRightsService.
  EnsureThatEmployeeHasRelatedDocumentUsageAccessRights(
    SourceDocument, RelatedDocument: IDocument;
    RelatedDocumentKind: TDocumentKind;
    Employee: TEmployee
  ): TDocumentUsageEmployeeAccessRightsInfo;
var
    SourceDocumentRelations: TDocumentRelations;
    FreeSourceDocumentRelations: IDomainObjectBase;

    SourceDocumentUsageEmployeeAccessRightsInfo: TDocumentUsageEmployeeAccessRightsInfo;
    FreeSourceDocumentUsageEmployeeAccessRightsInfo: IDomainObjectBase;

    GeneralRelatedDocumentChargeSheetAccessRightsService: IGeneralDocumentChargeSheetAccessRightsService;
begin

  SourceDocumentRelations :=
    GetSourceDocumentRelationsForGettingRelatedDocumentUsageAccessRights(
      TDocument(SourceDocument.Self)
    );

  FreeSourceDocumentRelations := SourceDocumentRelations;

  if  not Assigned(SourceDocumentRelations) or
      not
      SourceDocumentRelations.ContainsRelation(
        RelatedDocument.Identity,
        RelatedDocumentKind.Identity
      )
  then begin

    raise TDocumentUsageEmployeeAccessRightsServiceException.CreateFmt(
      'ƒокумент "%s" не имеет св€зи ' +
      'с документом "%s"',
      [
        FDocumentFullNameCompilationService.CompileFullNameForDocument(
          SourceDocument
        ),
        FDocumentFullNameCompilationService.CompileFullNameForDocument(
          RelatedDocument
        )
      ]
    );

  end;

  { refactor: inject IDocumentChargeSheetAccessRightsServiceRegistry instance to ctor }

  GeneralRelatedDocumentChargeSheetAccessRightsService :=
    TDocumentChargeSheetsServiceRegistry
      .Instance
        .GetGeneralDocumentChargeSheetAccessRightsService(
          RelatedDocumentKind.DocumentClass
        );

  Result := TDocumentUsageEmployeeAccessRightsInfo.Create;

  Result.DocumentCanBeViewed := True;

  Result
    .GeneralChargeSheetsUsageEmployeeAccessRightsInfo
      .AnyChargeSheetsCanBeViewedAsAuthorized :=

    GeneralRelatedDocumentChargeSheetAccessRightsService
      .AnyChargeSheetsCanBeViewedFor(TDocument(RelatedDocument.Self), Employee);

end;

function TStandardDocumentUsageEmployeeAccessRightsService.
  GetDocumentUsageAccessRightsInfoForEmployee(
    Document: IDocument;
    Employee: TEmployee
  ): TDocumentUsageEmployeeAccessRightsInfo;
var
    RealDocument: TDocument;

    LeaderTopLevelEmployees: TEmployees;
    LeaderTopLevelEmployee: TEmployee;

    Leader: TEmployee;
    FreeLeaderTopLevelEmployees: IDomainObjectList;

    DocumentKindAccessRightsInfo: TEmployeeDocumentKindAccessRightsInfo;
    FreeDocumentKindAccessRightsInfo: IDomainObjectBase;
begin

  Result := TDocumentUsageEmployeeAccessRightsInfo.Create;

  try
  
    RealDocument := Document.Self as TDocument;

    Result.DocumentCanBeViewed := 
      IsDocumentCanBeViewedByEmployee(RealDocument, Employee);

    Result.DocumentCanBeChanged :=
      IsDocumentCanBeChangedByEmployee(RealDocument, Employee);

    if Result.DocumentCanBeChanged then
      Document.EditingEmployee := Employee;
      
    Result.DocumentCanBeRemoved :=
      IsDocumentCanBeRemovedByEmployee(RealDocument, Employee);

    Result.DocumentCanBeMarkedAsSelfRegistered :=
      IsDocumentCanBeMarkedAsSelfRegistered(
        RealDocument, Employee
      );
      
    Result.DocumentCanBeSentToSigning :=
      IsDocumentCanBeSentToSigningByEmployee(RealDocument, Employee);

    Result.DocumentCanBeMarkedAsSigned :=
      IsDocumentCanBeMarkedAsSigned(RealDocument, Employee);

    Result.DocumentCanBeSigned :=
      IsDocumentCanBeSignedByEmployee(RealDocument, Employee);

    Result.DocumentCanBeRejectedFromSigning :=
      IsDocumentCanBeRejectedFromSigningByEmployee(
        RealDocument, Employee
      );

    Result.CanBeChangedDocumentApproverList :=
      IsDocumentApproverListCanBeChangedByEmployee(RealDocument, Employee);

    Result.CanBeChangedDocumentApproversInfo :=
      IsDocumentApproversInfoCanBeChangedByEmployee(
        RealDocument, Employee
      );

    Result.DocumentCanBeSentToApproving :=
      IsDocumentCanBeSentToApprovingByEmployee(RealDocument, Employee);
      
    Result.DocumentCanBeApproved :=
      IsDocumentCanBeApprovedByEmployee(RealDocument, Employee);
      
    Result.DocumentCanBeRejectedFromApproving :=
      IsDocumentCanBeRejectedFromApprovingByEmployee(
        RealDocument, Employee
      );

    Result.DocumentApprovingCanBeCompleted :=
      IsDocumentApprovingCanBeCompletedByEmployee(
        RealDocument, Employee
      );
      
    Result.DocumentCanBeSentToPerforming :=
      IsDocumentCanBeSentToPerformingByEmployee(RealDocument, Employee);
      
    Result.DocumentCanBePerformed :=
      IsDocumentCanBePerformedByEmployee(RealDocument, Employee);

    Result.GeneralChargeSheetsUsageEmployeeAccessRightsInfo :=
      FGeneralDocumentChargeSheetAccessRightsService
        .GetDocumentChargeSheetsUsageAccessRights(RealDocument, Employee);

    Result.EmployeeHasRightsForSigning :=
      HasEmployeeRightsForDocumentSigning(
        Employee, RealDocument
      );

    Result.EmployeeHasRightsForSigningMarking :=
      HasEmployeeRightsForDocumentSigningMarking(Employee, RealDocument);
      
    Result.EmployeeHasRightsForRejectingFromSigning :=
      HasEmployeeRightsForRejectingFromSigning(
        Employee, RealDocument
      );

    Result.EmployeeHasRightsForApproving :=
      HasEmployeeRightsForApproving(
        Employee, RealDocument
      );

    Result.EmployeeHasRightsForRejectingFromApproving :=
      HasEmployeeRightsForRejectingFromApproving(
        Employee, RealDocument
      );

    Result.EmployeeHasRightsForSendingToApproving :=
      HasEmployeeRightsForSendingToApproving(
        Employee, RealDocument
      );

    Result.EmployeeHasRightsForSendingToSigning :=
      HasEmployeeRightsForSendingToSigning(
        Employee, RealDocument
      );

    Result.EmployeeHasRightsForSendingToPerforming :=
      HasEmployeeRightsForSendingToPerforming(
        Employee, RealDocument
      );

    Result.NumberCanBeChanged :=
      Result.DocumentCanBeChanged
      or Result.DocumentCanBeSigned
      or Result.DocumentCanBeMarkedAsSigned
      or Result.EmployeeHasRightsForSigning
      or Result.EmployeeHasRightsForSigningMarking;

    DocumentKindAccessRightsInfo :=
      FEmployeeDocumentKindAccessRightsService
        .GetDocumentKindAccessRightsInfoForEmployee(
          RealDocument.ClassType, Employee
        );

    FreeDocumentKindAccessRightsInfo := DocumentKindAccessRightsInfo;

    Result.NumberPrefixPatternType :=
      DocumentKindAccessRightsInfo.DocumentNumberPrefixPatternType;

  except

    FreeAndNil(Result);

    Raise;

  end;
  
end;

function TStandardDocumentUsageEmployeeAccessRightsService.
  GetSourceDocumentRelationsForGettingRelatedDocumentUsageAccessRights(
    const SourceDocument: TDocument
  ): TDocumentRelations;
begin

  Result :=
    FDocumentRelationsFinder.FindRelationsForDocument(SourceDocument);
    
end;

function TStandardDocumentUsageEmployeeAccessRightsService.
  HasEmployeeRightsForApproving(
    Employee: TEmployee;
    Document: TDocument
  ): Boolean;
begin

  Result :=
    Document.
      WorkingRules.
        ApprovingPerformingRule.
          HasEmployeeOnlyRightsForDocumentApproving(
            Employee, Document
          );
          
end;

function TStandardDocumentUsageEmployeeAccessRightsService.
  HasEmployeeRightsForDocumentSigning(
    Employee: TEmployee;
    Document: TDocument
  ): Boolean;
begin

  Result :=
    Document.
      WorkingRules.
        SigningPerformingRule.
          HasEmployeeOnlyRightsForDocumentSigning(
            Employee, Document
          );

end;

function TStandardDocumentUsageEmployeeAccessRightsService.
  HasEmployeeRightsForDocumentSigningMarking(
    Employee: TEmployee;
    Document: TDocument
  ): Boolean;
begin

  Result :=
    Document
      .WorkingRules
        .DocumentSigningMarkingRule
          .HasEmployeeRightsForDocumentSigningMarking(Employee, Document);

end;

function TStandardDocumentUsageEmployeeAccessRightsService.
  HasEmployeeRightsForRejectingFromApproving(
    Employee: TEmployee;
    Document: TDocument
  ): Boolean;
begin

  Result :=
    Document.
      WorkingRules.
        ApprovingRejectingPerformingRule.
          HasEmployeeOnlyRightsForDocumentApprovingRejecting(
            Employee, Document
          );
          
end;

function TStandardDocumentUsageEmployeeAccessRightsService.
  HasEmployeeRightsForRejectingFromSigning(
    Employee: TEmployee;
    Document: TDocument
  ): Boolean;
begin

  Result :=
    Document.
      WorkingRules.
        SigningRejectingPerformingRule.
          HasEmployeeOnlyRightsForDocumentSigningRejecting(
            Employee, Document
          );
          
end;

function TStandardDocumentUsageEmployeeAccessRightsService.
  HasEmployeeRightsForSendingToApproving(
    Employee: TEmployee;
    Document: TDocument
  ): Boolean;
begin

  Result :=
    Document.
      WorkingRules.
        ApprovingDocumentSendingRule.
          IsSatisfiedForEmployeeOnly(
            Employee, Document
          );

end;

function TStandardDocumentUsageEmployeeAccessRightsService.
  HasEmployeeRightsForSendingToPerforming(
    Employee: TEmployee;
    Document: TDocument
  ): Boolean;
begin

  Result :=
    Document.
      WorkingRules.
        PerformingDocumentSendingRule.
          IsSatisfiedForEmployeeOnly(
            Employee, Document
          );

end;

function TStandardDocumentUsageEmployeeAccessRightsService.
  HasEmployeeRightsForSendingToSigning(
    Employee: TEmployee;
    Document: TDocument
  ): Boolean;
begin

  Result :=
    Document.
      WorkingRules.
        SigningDocumentSendingRule.
          IsSatisfiedForEmployeeOnly(
            Employee, Document
          );

end;

function TStandardDocumentUsageEmployeeAccessRightsService.
  IsDocumentApproverListCanBeChangedByEmployee(
    Document: TDocument;
    Employee: TEmployee
  ): Boolean;
begin

  Result :=
    Document.
      WorkingRules.
        ApproverListChangingRule.
          MayEmployeeChangeDocumentApproverList(
            Employee, Document
          );

end;

function TStandardDocumentUsageEmployeeAccessRightsService.
  IsDocumentApproversInfoCanBeChangedByEmployee(
    Document: TDocument;
    Employee: TEmployee
  ): Boolean;
begin

  Result :=
    Document.WorkingRules.
      ApproverListChangingRule.
        MayEmployeeChangeInfoForAnyOfDocumentApprovers(
          Employee, Document
        );

end;

function TStandardDocumentUsageEmployeeAccessRightsService.
  IsDocumentApprovingCanBeCompletedByEmployee(
    Document: TDocument;
    Employee: TEmployee
  ): Boolean;
begin

  Result :=
    Document.WorkingRules.ApprovingPassingMarkingRule.IsSatisfiedBy(
      Employee, Document
    );

end;

function TStandardDocumentUsageEmployeeAccessRightsService.IsDocumentCanBeApprovedByEmployee(
  Document: TDocument; Employee: TEmployee): Boolean;
begin

  Result :=
    Document.WorkingRules.ApprovingPerformingRule.
      CanEmployeeApproveDocument(Document, Employee);
      
end;

function TStandardDocumentUsageEmployeeAccessRightsService.IsDocumentCanBeChangedByEmployee(
  Document: TDocument; Employee: TEmployee): Boolean;
begin

  Result :=
    Document.WorkingRules.EditingRule.IsSatisfiedBy(Employee, Document);
    
end;

function TStandardDocumentUsageEmployeeAccessRightsService.
  IsDocumentCanBeMarkedAsSelfRegistered(
    Document: TDocument;
    Employee: TEmployee
  ): Boolean;
begin

  Result :=
    Document.
      WorkingRules.
        AsSelfRegisteredDocumentMarkingRule.
          IsSatisfiedBy(
            Employee, Document
          );

end;

function TStandardDocumentUsageEmployeeAccessRightsService.
  IsDocumentCanBeMarkedAsSigned(
    Document: TDocument;
    Employee: TEmployee
  ): Boolean;
begin

  Result :=
    Document
      .WorkingRules
        .DocumentSigningMarkingRule
          .CanEmployeeMarkDocumentAsSigned(Employee, Document);

end;

function TStandardDocumentUsageEmployeeAccessRightsService
  .IsDocumentCanBePerformedByEmployee(
    Document: TDocument;
    Employee: TEmployee
  ): Boolean;
begin

  Result :=
    Document.
      WorkingRules.
        PerformingRule.
          MayDocumentBeMarkedAsPerformed(
            Document, Employee, Employee
          );
          
end;

function TStandardDocumentUsageEmployeeAccessRightsService.IsDocumentCanBeRejectedFromApprovingByEmployee(
  Document: TDocument; Employee: TEmployee): Boolean;
begin

  Result :=
    Document.
      WorkingRules.
        ApprovingRejectingPerformingRule.
          CanEmployeeRejectApprovingDocument(Document, Employee);

end;

function TStandardDocumentUsageEmployeeAccessRightsService.IsDocumentCanBeRejectedFromSigningByEmployee(
  Document: TDocument; Employee: TEmployee): Boolean;
begin

  Result :=
    Document.WorkingRules.
        SigningRejectingPerformingRule.
          CanEmployeeRejectSigningDocument(Document, Employee);
          
end;

function TStandardDocumentUsageEmployeeAccessRightsService.
  IsDocumentCanBeRemovedByEmployee(
    Document: TDocument; Employee: TEmployee
  ): Boolean;
begin

  Result :=
    Document.WorkingRules.DocumentRemovingRule.IsSatisfiedBy(
      Employee, Document
    );
    
end;

function TStandardDocumentUsageEmployeeAccessRightsService.
  IsDocumentCanBeSentToApprovingByEmployee(
    Document: TDocument;
    Employee: TEmployee
  ): Boolean;
begin

  Result :=
    Document.WorkingRules.ApprovingDocumentSendingRule.IsSatisfiedBy(
      Employee, Document
    );

end;

function TStandardDocumentUsageEmployeeAccessRightsService.IsDocumentCanBeSentToPerformingByEmployee(
  Document: TDocument; Employee: TEmployee): Boolean;
begin

  Result :=
    Document.WorkingRules.PerformingDocumentSendingRule.IsSatisfiedBy(
        Employee, Document
    );

end;

function TStandardDocumentUsageEmployeeAccessRightsService.IsDocumentCanBeSentToSigningByEmployee(
  Document: TDocument; Employee: TEmployee): Boolean;
begin

  Result :=
    Document.WorkingRules.SigningDocumentSendingRule.IsSatisfiedBy(
      Employee, Document
    );
    
end;

function TStandardDocumentUsageEmployeeAccessRightsService.IsDocumentCanBeSignedByEmployee(
  Document: TDocument; Employee: TEmployee): Boolean;
begin

  Result :=
    Document.WorkingRules.SigningPerformingRule.CanEmployeeSignDocument(
        Document, Employee
    );

end;

function TStandardDocumentUsageEmployeeAccessRightsService.IsDocumentCanBeViewedByEmployee(
  Document: TDocument; Employee: TEmployee): Boolean;
begin

  Result :=
    Document.WorkingRules.DocumentViewingRule.IsSatisfiedBy(
      Employee, Document
    );

end;

end.
