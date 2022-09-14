unit Document;

interface

uses

  DomainObjectUnit,
  DomainObjectListUnit,
  DomainObjectValueUnit,
  DocumentWorkCycle,
  EmployeeDocumentWorkingRules,
  DocumentSpecifications,
  IDocumentUnit,
  IDomainObjectBaseUnit,
  IDomainObjectBaseListUnit,
  DocumentChargeInterface,
  DocumentCharges,
  DocumentSignings,
  DocumentApprovings,
  InterfaceFunctions,
  VariantListUnit,
  DocumentChargeSheet,
  Employee,
  RoleUnit,
  TimeFrame,
  Classes,
  SysUtils;

type

  TDocument = class;
  TDocumentClass = class of TDocument;
  TDocumentClasses = array of TDocumentClass;
  
  TDocuments = class;
  TDocumentsClass = class of TDocuments;
  
  TDocument = class (TDomainObject, IDocument)

    private

      FreeAuthor: IDomainObjectBase;
      
      procedure CustomizeInitialState;

    protected

      FKindIdentity: Variant;
      FNumber: String;
      FName: String;
      FCreationDate: TDateTime;
      FDocumentDate: Variant;
      FContent: String;
      FNote: String;
      FIsSentToSigning: Boolean;
      FIsSelfRegistered: Boolean;
      FProductCode: String;

      FAuthor: TEmployee;

      FResponsibleId: Variant;

      FWorkCycle: TDocumentWorkCycle;
      FFreeWorkCycle: IDomainObjectBase;

      FCurrentEditingEmployee: TEmployee;

      FCharges: IDocumentCharges;

      FSignings: TDocumentSignings;
      FFreeSignings: IDomainObjectBaseList;

      FApprovings: TDocumentApprovings;
      FFreeApprovings: IDomainObjectBaseList;

      FWorkingRules: TEmployeeDocumentWorkingRules;
      FFreeWorkingRules: IEmployeeDocumentWorkingRules;

      FSpecifications: IDocumentSpecifications;
      
      function GetKindIdentity: Variant; virtual;
      function GetContent: String; virtual;
      function GetCreationDate: TDateTime; virtual;
      function GetDocumentDate: Variant; virtual;
      function GetName: String; virtual;
      function GetNote: String; virtual;
      function GetProductCode: String; virtual;
      function GetNumber: String; virtual;
      function GetCurrentWorkCycleStageName: String; virtual;
      function GetCurrentWorkCycleStageNumber: Integer; virtual;
      function GetEditingEmployee: TEmployee; virtual;
      function GetAuthor: TEmployee; virtual;

      function GetDocumentCharges: IDocumentCharges; virtual;
      function GetDocumentSignings: TDocumentSignings; virtual;
      function GetDocumentApprovings: TDocumentApprovings; virtual;
      function GetIsRejectedFromSigning: Boolean; virtual;
      function GetIsSelfRegistered: Boolean; virtual;
      function GetIsNumberAssigned: Boolean; virtual;
      function GetWorkCycle: TDocumentWorkCycle; virtual;
      
      function GetAreAllApprovingsPerformed: Boolean; virtual;
      function GetIsPerformed: Boolean; virtual;
      function GetIsPerforming: Boolean; virtual;
      function GetIsSigned: Boolean; virtual;
      function GetIsSigning: Boolean; virtual;
      function GetIsSentToSigning: Boolean; virtual;
      function GetIsApproving: Boolean; virtual;
      function GetIsApproved: Boolean; virtual;
      function GetIsNotApproved: Boolean; virtual;
      function GetResponsibleId: Variant; virtual;

      procedure SetIdentity(Identity: Variant); override;
      procedure SetKindIdentity(KindIdentity: Variant); virtual;
      procedure SetContent(const Value: String); virtual;
      procedure SetCreationDate(const Value: TDateTime); virtual;
      procedure SetDocumentDate(const Value: Variant); virtual;
      procedure SetName(const Value: String); virtual;
      procedure SetNote(const Value: String); virtual;
      procedure SetProductCode(const Value: String); virtual;
      procedure SetNumber(const Value: String); virtual;
      procedure SetIsSentToSigning(const Value: Boolean); virtual;
      procedure SetCurrentWorkCycleStageNumber(const StageNumber: Integer); virtual;
      procedure SetCurrentWorkCycleStageName(const StageName: String); virtual;
      procedure SetResponsibleId(const Value: Variant); virtual;
      procedure SetAuthor(const Value: TEmployee); virtual;
      procedure SetEditingEmployee(Employee: TEmployee); virtual;
      procedure SetIsSelfRegistered(const Value: Boolean); virtual;
      procedure SetWorkCycle(const Value: TDocumentWorkCycle);

      function GetEmployeeDocumentWorkingRules: TEmployeeDocumentWorkingRules; virtual;
      procedure SetEmployeeDocumentWorkingRules(const Value: TEmployeeDocumentWorkingRules); virtual;

      procedure SetDocumentCharges(const Value: IDocumentCharges);
      procedure SetDocumentSignings(const Value: TDocumentSignings);
      procedure SetDocumentApprovings(DocumentApprovings: TDocumentApprovings); virtual;

      procedure RaiseExceptionIfEditingEmployeeNotAssigned;
      procedure RaiseExceptionIfWorkingRulesNotAssigned;
      procedure RaiseExceptionIfEditingEmployeeOrWorkingRulesNotAssigned;

      procedure EnsureThatEmployeeMayMakeChanges(Employee: TEmployee);
      procedure EnsureThatEditingEmployeeMayAddChargeFor(Charge: IDocumentCharge);
      procedure EnsureThatEditingEmployeeMayChangeCharge(Charge: IDocumentCharge);
      procedure EnsureThatEditingEmployeeMayChangeChargeList;
      procedure EnsureThatEditingEmployeeMayRemoveChargeFor(Charge: IDocumentCharge);

      procedure EnsureThatDocumentMayBeMarkedAsPerformed(
        FormalPerformer, ActuallyPerformedEmployee: TEmployee
      );

      procedure EnsureThatEditingEmployeeMayMarkDocumentAsSelfRegistered;
      procedure EnsureThatEditingEmployeeMayAddSigner(Signer: TEmployee);
      procedure EnsureThatEditingEmployeeMayRemoveSigner(Signer: TEmployee);

      procedure EnsureThatEmployeeMayAddApprover(
        AddingEmployee: TEmployee;
        AddableEmployee: TEmployee
      );

      procedure EnsureThatEditingEmployeeMayRemoveApprover(
        RemovingEmployee: TEmployee;
        RemoveableEmployee: TEmployee
      );
      
      function EnsureThatEmployeeMayApproveAndGetRealFormalApprover(
        FormalApprover: TEmployee;
        ApprovingEmployee: TEmployee
      ): TEmployee;
      
      function EnsureThatEmployeeMayRejectApprovingAndGetRealFormalApprover(
        FormalApprover: TEmployee;
        RejectingApprovingEmployee: TEmployee
      ): TEmployee;

      procedure EnsureThatEmployeeMayMarkAsApproved(Employee: TEmployee);
      procedure EnsureThatEmployeeMayMarkAsNotApproved(Employee: TEmployee);
      procedure EnsureThatEmployeeMayChangeDocumentApproverInfo(
        Employee: TEmployee;
        Approver: TEmployee
      );
      
      function EnsureThatEmployeeMaySign(
        FormalSigner: TEmployee;
        SigningEmployee: TEmployee
      ): TEmployee;

      function EnsureThatEmployeeMayRejectSigningAndGetRealFormalSigner(
        FormalSigner: TEmployee;
        RejectingEmployee: TEmployee
      ): TEmployee;

      procedure EnsureThatEmployeeMaySendToPerforming(Employee: TEmployee);
      procedure EnsureThatEmployeeMaySendToSigning(Employee: TEmployee);
      procedure EnsureThatEmployeeMaySendToApproving(Employee: TEmployee);
      procedure EnsureEmployeeCanMarkDocumentAsSigned(Employee: TEmployee);

    protected

      procedure SetInvariantsComplianceRequested(const Value: Boolean); override;

    protected

      procedure ChangeDocumentIdForAllDocumentSignings(
        const DocumentId: Variant
      );
      
      procedure ChangeDocumentIdForAllDocumentCharges(
        const DocumentId: Variant
      );

      procedure ChangeDocumentIdForAllDocumentApprovings(
        const DocumentId: Variant
      );

    protected

      procedure ToStageOfDocumentPerformedIfNecessary;

    public

      constructor Create; override;
      constructor Create(Identity: Variant); override;
      
      destructor Destroy; override;

      property EditingEmployee: TEmployee
      read GetEditingEmployee write SetEditingEmployee;

      procedure AddApprover(
        AddingEmployee: TEmployee;
        AddableEmployee: TEmployee
      );

      procedure RemoveApprover(
        RemovingEmployee: TEmployee;
        RemoveableEmployee: TEmployee
      );
      
      procedure RemoveAllApprovers(
        RemovingEmployee: TEmployee
      );

      function FindApprovingByFormalApprover(
        FormalApprover: TEmployee
      ): TDocumentApproving; virtual;
      
      procedure AddSigner(Employee: TEmployee); virtual;
      procedure RemoveSigner(Employee: TEmployee); virtual;
      procedure RemoveAllSigners; virtual;

      procedure ApproveBy(
        Employee: TEmployee;
        const Note: String = ''
      ); virtual;
      
      procedure ApproveByOnBehalfOf(
        CurrentApprovingEmployee: TEmployee;
        FormalApprover: TEmployee;
        const Note: String = ''
      ); virtual;

      procedure RejectApprovingBy(
        Employee: TEmployee;
        const Reason: String = ''
      ); virtual;

      procedure RejectApprovingByOnBehalfOf(
        CurrentRejectingApprovingEmployee: TEmployee;
        FormalApprover: TEmployee;
        const Reason: String = ''
      ); virtual;

      procedure ChangeNoteForApprover(
        ChangingEmployee: TEmployee;
        Approver: TEmployee;
        const Note: String
      ); virtual;

    public
      
      procedure SignBy(Employee: TEmployee); virtual;
      procedure SignByOnBehalfOf(
        CurrentSigningEmployee: TEmployee;
        FormalSigner: TEmployee
      ); virtual;

      procedure RejectSigningBy(Employee: TEmployee); virtual;
      procedure RejectSigningByBehalfOf(
        CurrentRejectingSigningEmployee: TEmployee;
        FormalSigner: TEmployee
      ); virtual;

      function FindSigningBySignerOrActuallySignedEmployee(
        Employee: TEmployee
      ): TDocumentSigning; virtual;

      function IsSignedBy(Employee: TEmployee): Boolean; virtual;

      procedure MarkAsSignedForAllSigners(
        const MarkingEmployee: TEmployee;
        const SigningDate: TDateTime
      ); virtual;
      
      procedure MarkAsSigned(
        const MarkingEmployee: TEmployee;
        const Signer: TEmployee;
        const SigningDate: TDateTime
      ); virtual;
      
    public

      procedure AddCharge(Charge: IDocumentCharge);
      procedure AddCharges(Charges: IDocumentCharges);
      procedure ChangeCharge(Charge: IDocumentCharge);
      procedure ChangeCharges(Charges: IDocumentCharges);
      procedure PerformCharge(Charge: IDocumentCharge);
      procedure RemoveChargeFor(Performer: TEmployee); virtual;
      procedure RemoveChargesFor(Performers: TEmployees);

      procedure RemoveAllCharges; virtual;

      function FindChargeByPerformerOrActuallyPerformedEmployee(
        Employee: TEmployee
      ): IDocumentCharge; virtual;

      function IsPerformedBy(Employee: TEmployee): Boolean; virtual;

      procedure ToSigningBy(Employee: TEmployee); virtual;
      procedure ToApprovingBy(Employee: TEmployee); virtual;
      procedure MarkAsApprovedBy(Employee: TEmployee); virtual;
      procedure MarkAsNotApprovedBy(Employee: TEmployee); virtual;
      procedure ToPerformingBy(Employee: TEmployee); virtual;

      function FetchAllApprovers: TEmployees; virtual;
      function FetchAllSigners: TEmployees; virtual;
      function FetchAllPerformers: TEmployees; virtual;

    published

      property KindIdentity: Variant read GetKindIdentity write SetKindIdentity;
      property Number: String read GetNumber write SetNumber;
      property Name: String read GetName write SetName;

      property CreationDate: TDateTime
      read GetCreationDate write SetCreationDate;

      property DocumentDate: Variant read GetDocumentDate write SetDocumentDate;
      
      property Content: String read GetContent write SetContent;
      property Note: String read GetNote write SetNote;

      property ProductCode: String read GetProductCode write SetProductCode;

      property ResponsibleId: Variant
      read GetResponsibleId write SetResponsibleId;

      property Author: TEmployee
      read GetAuthor write SetAuthor;

      property Signings: TDocumentSignings
      read GetDocumentSignings write SetDocumentSignings;

      property Charges: IDocumentCharges
      read GetDocumentCharges write SetDocumentCharges;

      property Approvings: TDocumentApprovings
      read GetDocumentApprovings write SetDocumentApprovings;

      property CurrentWorkCycleStageNumber: Integer
      read GetCurrentWorkCycleStageNumber
      write SetCurrentWorkCycleStageNumber;

      property CurrentWorkCycleStageName: String
      read GetCurrentWorkCycleStageName
      write SetCurrentWorkCycleStageName;

      property AreAllApprovingsPerformed: Boolean
      read GetAreAllApprovingsPerformed;
      
      property IsSigning: Boolean read GetIsSigning;
      property IsApproving: Boolean read GetIsApproving;
      property IsApproved: Boolean read GetIsApproved;
      property IsNotApproved: Boolean read GetIsNotApproved;
      property IsSentToSigning: Boolean
      read GetIsSentToSigning write SetIsSentToSigning;
      
      property IsSigned: Boolean read GetIsSigned;
      property IsPerforming: Boolean read GetIsPerforming;
      property IsPerformed: Boolean read GetIsPerformed;
      property IsRejectedFromSigning: Boolean read GetIsRejectedFromSigning;

      property IsNumberAssigned: Boolean
      read GetIsNumberAssigned;

      property IsSelfRegistered: Boolean
      read GetIsSelfRegistered write SetIsSelfRegistered;
      
      property WorkingRules: TEmployeeDocumentWorkingRules
      read GetEmployeeDocumentWorkingRules
      write SetEmployeeDocumentWorkingRules;

      property Specifications: IDocumentSpecifications
      read FSpecifications write FSpecifications;
      
    public

      property WorkCycle: TDocumentWorkCycle
      read GetWorkCycle write SetWorkCycle;

    public

      function ClassType: TDocumentClass;
      class function IncomingDocumentType: TDocumentClass; virtual;
      class function ListType: TDocumentsClass; virtual;
      class function WorkCycleType: TDocumentWorkCycleClass; virtual;

    public

      class function NumberPropertyName: String;

  end;

  TDocumentsEnumerator = class (TDomainObjectListEnumerator)

    protected

      function GetCurrentDocument: TDocument;

    public

      constructor Create(Documents: TDocuments);

      property Current: TDocument read GetCurrentDocument;

  end;
  
  TDocuments = class (TDomainObjectList)

    protected

      function GetDocumentByIndex(Index: Integer): TDocument;
      procedure SetDocumentByIndex(Index: Integer; Document: TDocument);
      
    public

      function FirstDocument: TDocument;
      
      procedure AddDocument(Document: TDocument);
      procedure RemoveDocument(Document: TDocument);

      function ExtractDocumentNumbers: TStrings;

      function FindDocumentsWithAssignedNumbers: TDocuments;
      
      function GetDocumentsByNumber(const Number: String): TDocuments;

      function FindDocumentById(
        const DocumentId: Variant
      ): TDocument;

      property Items[Index: Integer]: TDocument
      read GetDocumentByIndex
      write SetDocumentByIndex; default;

      function GetEnumerator: TDocumentsEnumerator;

  end;

implementation

uses

  DateUtils,
  Variants,
  IncomingDocument,
  DomainObjectBaseUnit,
  AuxDebugFunctionsUnit, DomainObjectBaseListUnit;

{ TDocument }

procedure TDocument.AddApprover(
  AddingEmployee: TEmployee;
  AddableEmployee: TEmployee
);
var DocumentApproving: TDocumentApproving;
begin

  EnsureThatEmployeeMayAddApprover(AddingEmployee, AddableEmployee);

  DocumentApproving := FApprovings.AddApprovingFor(AddableEmployee);

  DocumentApproving.DocumentId := Identity;

end;

procedure TDocument.AddCharges(Charges: IDocumentCharges);
var
    Charge: IDocumentCharge;
begin

  for Charge in Charges  do
    AddCharge(Charge);

end;

procedure TDocument.AddCharge(Charge: IDocumentCharge);
begin

  EnsureThatEditingEmployeeMayAddChargeFor(Charge);

  FCharges.AddCharge(Charge);

  Charge.DocumentId := Identity;

end;

procedure TDocument.AddSigner(Employee: TEmployee);
var DocumentSigning: TDocumentSigning;
begin

  EnsureThatEditingEmployeeMayAddSigner(Employee);

  DocumentSigning := FSignings.AddSigningFor(Employee);

  DocumentSigning.DocumentId := Identity;
  
end;

procedure TDocument.ApproveBy(Employee: TEmployee; const Note: String);
begin

  ApproveByOnBehalfOf(Employee, Employee);
  
end;

procedure TDocument.ApproveByOnBehalfOf(
  CurrentApprovingEmployee, FormalApprover: TEmployee;
  const Note: String
);
var RealFormalApprover: TEmployee;
    FreeRealFormalApprover: IDomainObjectBase;
    DocumentApproving: TDocumentApproving;
begin

  RealFormalApprover :=
    EnsureThatEmployeeMayApproveAndGetRealFormalApprover(
      FormalApprover, CurrentApprovingEmployee
    );

  FreeRealFormalApprover := RealFormalApprover;

  DocumentApproving := FApprovings.FindByApprover(RealFormalApprover);

  DocumentApproving.MarkAsApprovedBy(CurrentApprovingEmployee, Note);
  
end;

procedure TDocument.ChangeCharge(Charge: IDocumentCharge);
begin

  EnsureThatEditingEmployeeMayChangeCharge(Charge);

  FCharges.ChangeCharge(Charge);
  
end;

procedure TDocument.ChangeCharges(Charges: IDocumentCharges);
var
    Charge: IDocumentCharge;
begin

  for Charge in Charges do
    ChangeCharge(Charge);
    
end;

procedure TDocument.ChangeDocumentIdForAllDocumentApprovings(
  const DocumentId: Variant);
var DocumentApproving: TDocumentApproving;
begin

  for DocumentApproving in Approvings do
    DocumentApproving.DocumentId := DocumentId;

end;

procedure TDocument.ChangeDocumentIdForAllDocumentCharges(
  const DocumentId: Variant);
var DocumentCharge: IDocumentCharge;
begin

  for DocumentCharge in Charges do
    DocumentCharge.DocumentId := DocumentId;

end;

procedure TDocument.ChangeDocumentIdForAllDocumentSignings(
  const DocumentId: Variant);
var DocumentSigning: TDocumentSigning;
begin

  for DocumentSigning in Signings do
    DocumentSigning.DocumentId := DocumentId;
    
end;

procedure TDocument.ChangeNoteForApprover(
  ChangingEmployee, Approver: TEmployee;
  const Note: String
);
var DocumentApproving: TDocumentApproving;
begin

  EnsureThatEmployeeMayChangeDocumentApproverInfo(
    ChangingEmployee, Approver
  );

  DocumentApproving := FindApprovingByFormalApprover(Approver);

  DocumentApproving.Note := Note;
  
end;

constructor TDocument.Create;
begin

  inherited Create;

  CustomizeInitialState;

end;

procedure TDocument.CustomizeInitialState;
begin

  FKindIdentity := Null;
  FDocumentDate := Null;
  FResponsibleId := Null;
  
  FCharges := TDocumentCharges.Create;

  FSignings := TDocumentSignings.Create;
  FFreeSignings := FSignings;

  FApprovings := TDocumentApprovings.Create;
  FFreeApprovings := FApprovings;
  
end;


destructor TDocument.Destroy;
begin

  inherited;

end;

procedure TDocument.EnsureEmployeeCanMarkDocumentAsSigned(Employee: TEmployee);
begin

  if not InvariantsComplianceRequested then Exit;

  RaiseExceptionIfWorkingRulesNotAssigned;

  if not Assigned(FWorkingRules.DocumentSigningMarkingRule) then begin

    raise TDocumentException.Create(
      'Для данного документа отсутствует ' +
      'правило помечания в качестве подписанного'
    );
    
  end;

  FWorkingRules
    .DocumentSigningMarkingRule
      .EnsureEmployeeCanMarkDocumentAsSigned(Employee, Self);
  
end;

procedure TDocument.EnsureThatDocumentMayBeMarkedAsPerformed(
  FormalPerformer,
  ActuallyPerformedEmployee: TEmployee
);
begin

  if not InvariantsComplianceRequested then Exit;

  RaiseExceptionIfWorkingRulesNotAssigned;

  FWorkingRules.
    PerformingRule.
      EnsureThatDocumentMayBeMarkedAsPerformed(
        Self, FormalPerformer, ActuallyPerformedEmployee
      );
      
end;

procedure TDocument.EnsureThatEmployeeMayAddApprover(
  AddingEmployee: TEmployee;
  AddableEmployee: TEmployee
);
begin

  if not InvariantsComplianceRequested then Exit;

  RaiseExceptionIfWorkingRulesNotAssigned;

  FWorkingRules.ApproverListChangingRule.
    EnsureThatEmployeeMayAssignDocumentApprover(
      AddingEmployee, Self, AddableEmployee
    );
  
end;

procedure TDocument.EnsureThatEditingEmployeeMayAddChargeFor(
  Charge: IDocumentCharge
);
begin

  if not InvariantsComplianceRequested then Exit;

  RaiseExceptionIfEditingEmployeeOrWorkingRulesNotAssigned;

  FWorkingRules.ChargeListChangingRule.EnsureThatEmployeeMayAssignDocumentCharge(
    EditingEmployee, Self, Charge
  );

end;

procedure TDocument.EnsureThatEditingEmployeeMayAddSigner(Signer: TEmployee);
begin

  if not InvariantsComplianceRequested then Exit;

  RaiseExceptionIfEditingEmployeeOrWorkingRulesNotAssigned;

  FWorkingRules.SignerListChangingRule.EnsureThatEmployeeMayAssignDocumentSigner(
    EditingEmployee, Self, Signer
  );

end;

procedure TDocument.EnsureThatEditingEmployeeMayChangeCharge(Charge: IDocumentCharge);
var
    ChargeForChange: TDocumentCharge;
    ChargeForChangeRef: IDocumentCharge;
    Performer: TEmployee;
    AlloweableEditFieldNames: TStrings;
begin

  if not InvariantsComplianceRequested then Exit;

  EnsureThatEditingEmployeeMayChangeChargeList;

  Performer := Charge.Performer; 
                       
  ChargeForChangeRef :=
    Charges.
      FindDocumentChargeByPerformerOrActuallyPerformedEmployee(Performer);

  if not Assigned(ChargeForChangeRef) then begin

    raise TDocumentException.CreateFmt(
            'Поручение для сотрудника "%s" ' +
            'не найдено',
            [Performer.FullName]
          );

  end;

  ChargeForChange := ChargeForChangeRef.Self as TDocumentCharge;

  AlloweableEditFieldNames :=
    ChargeForChange
      .WorkingRules
        .ChangingRule
          .EnsureEmployeeMayChangeDocumentCharge(
            EditingEmployee, Self, ChargeForChange
          );

  try

    RaiseConditionalExceptionIfInvariantsComplianceRequested(
      not ChargeForChange.PropertiesEqualsExcept(Charge.Self as TDocumentCharge, AlloweableEditFieldNames),
      TDocumentChargeException,
      'Некоторые из полей поручения для сотрудника "%s" ' +
      'недопустимо изменять',
      [
        Performer.FullName
      ]
    );

  finally

    FreeAndNil(AlloweableEditFieldNames);
    
  end;

end;

procedure TDocument.EnsureThatEditingEmployeeMayChangeChargeList;
begin

  if not InvariantsComplianceRequested then Exit;

  RaiseExceptionIfEditingEmployeeOrWorkingRulesNotAssigned;

  FWorkingRules
    .ChargeListChangingRule
      .EnsureThatEmployeeMayChangeChargeList(EditingEmployee, Self);
  
end;

procedure TDocument.EnsureThatEditingEmployeeMayMarkDocumentAsSelfRegistered;
begin

  if not InvariantsComplianceRequested then Exit;

  RaiseExceptionIfEditingEmployeeOrWorkingRulesNotAssigned;

  FWorkingRules.
    AsSelfRegisteredDocumentMarkingRule.EnsureThatIsSatisfiedFor(
      EditingEmployee, Self
    );
  
end;

procedure TDocument.EnsureThatEditingEmployeeMayRemoveApprover(
  RemovingEmployee: TEmployee;
  RemoveableEmployee: TEmployee
);
begin

  if not InvariantsComplianceRequested then Exit;

  RaiseExceptionIfWorkingRulesNotAssigned;

  FWorkingRules.ApproverListChangingRule.
    EnsureThatEmployeeMayRemoveDocumentApprover(
      RemovingEmployee, Self, RemoveableEmployee
    );
    
end;

procedure TDocument.EnsureThatEditingEmployeeMayRemoveChargeFor(
  Charge: IDocumentCharge
);
begin

  RaiseConditionalExceptionIfInvariantsComplianceRequested(
    not Assigned(Charge) or not FCharges.IsEmployeeAssignedAsPerformer(Charge.Performer),
    TDocumentChargeException,
    'Поручение для сотрудника "%s" не найдено для удаления',
    [
      Charge.Performer.FullName
    ]
  );

  EnsureThatEditingEmployeeMayChangeChargeList;
  
end;

procedure TDocument.EnsureThatEditingEmployeeMayRemoveSigner(
  Signer: TEmployee
);
begin

  if not InvariantsComplianceRequested then Exit;

  RaiseExceptionIfEditingEmployeeOrWorkingRulesNotAssigned;

  FWorkingRules.
    SignerListChangingRule.
      EnsureThatEmployeeMayRemoveDocumentSigner(
        EditingEmployee, Self, Signer
      );

end;

function TDocument.EnsureThatEmployeeMayApproveAndGetRealFormalApprover(
  FormalApprover, ApprovingEmployee: TEmployee): TEmployee;
begin

  if not InvariantsComplianceRequested then begin

    Result := FormalApprover;
    Exit;

  end;

  RaiseExceptionIfWorkingRulesNotAssigned;

  Result :=
    FWorkingRules.ApprovingPerformingRule.
      EnsureThatEmployeeCanApproveDocumentOnBehalfOfOther(
        Self, FormalApprover, ApprovingEmployee
      );
  
end;

procedure TDocument.EnsureThatEmployeeMayChangeDocumentApproverInfo(
  Employee: TEmployee;
  Approver: TEmployee
);
begin

  if not InvariantsComplianceRequested then Exit;

  RaiseExceptionIfWorkingRulesNotAssigned;

  FWorkingRules.
    ApproverListChangingRule.
      EnsureThatEmployeeMayChangeDocumentApproverInfo(
        Employee, Self, Approver
      );
  
end;

procedure TDocument.EnsureThatEmployeeMayMakeChanges(Employee: TEmployee);
begin

  if not InvariantsComplianceRequested then Exit;

  RaiseExceptionIfWorkingRulesNotAssigned;
  
  FWorkingRules.EditingRule.EnsureThatIsSatisfiedFor(Employee, Self);
  
end;

procedure TDocument.EnsureThatEmployeeMayMarkAsApproved(Employee: TEmployee);
begin

  if not InvariantsComplianceRequested then Exit;

  RaiseExceptionIfWorkingRulesNotAssigned;

  FWorkingRules.ApprovingPassingMarkingRule.EnsureThatIsSatisfiedFor(
    Employee, Self
  );
  
end;

procedure TDocument.EnsureThatEmployeeMayMarkAsNotApproved(Employee: TEmployee);
begin

  if not InvariantsComplianceRequested then Exit;

  RaiseExceptionIfWorkingRulesNotAssigned;

  FWorkingRules.ApprovingPassingMarkingRule.IsSatisfiedBy(
    Employee, Self
  );
  
end;

function TDocument.
  EnsureThatEmployeeMayRejectApprovingAndGetRealFormalApprover(
    FormalApprover, RejectingApprovingEmployee: TEmployee
  ): TEmployee;
begin

  if not InvariantsComplianceRequested then begin

    Result := FormalApprover;
    Exit;

  end;

  RaiseExceptionIfWorkingRulesNotAssigned;

  Result :=
    FWorkingRules.ApprovingRejectingPerformingRule.
      EnsureThatEmployeeCanRejectApprovingDocumentOnBehalfOfOther(
        Self, FormalApprover, RejectingApprovingEmployee
      );
  
end;

function TDocument.EnsureThatEmployeeMayRejectSigningAndGetRealFormalSigner(
  FormalSigner: TEmployee;
  RejectingEmployee: TEmployee
): TEmployee;
begin

  if not InvariantsComplianceRequested then begin

    Result := FormalSigner;
    Exit;

  end;

  RaiseExceptionIfWorkingRulesNotAssigned;

  Result :=
    FWorkingRules.
      SigningRejectingPerformingRule.
        EnsureThatEmployeeCanRejectSigningDocumentOnBehalfOfOther(
          Self, FormalSigner, RejectingEmployee
        );

end;

procedure TDocument.EnsureThatEmployeeMaySendToApproving(Employee: TEmployee);
begin

  if not InvariantsComplianceRequested then Exit;

  RaiseExceptionIfEditingEmployeeOrWorkingRulesNotAssigned;

  FWorkingRules.ApprovingDocumentSendingRule.EnsureThatIsSatisfiedFor(
    Employee, Self
  );
  
end;

procedure TDocument.EnsureThatEmployeeMaySendToPerforming(Employee: TEmployee);
begin

  if not InvariantsComplianceRequested then Exit;

  RaiseExceptionIfEditingEmployeeOrWorkingRulesNotAssigned;

  FWorkingRules.PerformingDocumentSendingRule.EnsureThatIsSatisfiedFor(
    Employee, Self
  );
  
end;

procedure TDocument.EnsureThatEmployeeMaySendToSigning(Employee: TEmployee);
begin

  if not InvariantsComplianceRequested then Exit;

  RaiseExceptionIfEditingEmployeeOrWorkingRulesNotAssigned;

  FWorkingRules.SigningDocumentSendingRule.EnsureThatIsSatisfiedFor(
    Employee, Self
  );
  
end;

function TDocument.EnsureThatEmployeeMaySign(
  FormalSigner: TEmployee;
  SigningEmployee: TEmployee
): TEmployee;
begin

  if not InvariantsComplianceRequested then begin

    Result := FormalSigner;
    Exit;

  end;

  RaiseExceptionIfWorkingRulesNotAssigned;

  Result :=
    FWorkingRules.
      SigningPerformingRule.EnsureThatEmployeeCanSignDocumentOnBehalfOfOther(
        Self, FormalSigner, SigningEmployee
      );

end;

function TDocument.FetchAllApprovers: TEmployees;
var DocumentApproving: TDocumentApproving;
begin

  Result := TEmployees.Create;

  for DocumentApproving in FApprovings do begin

    Result.AddDomainObject(DocumentApproving.Approver);
    
  end;

end;

function TDocument.FetchAllPerformers: TEmployees;
var DocumentCharge: IDocumentCharge;
begin

  Result := TEmployees.Create;

  for DocumentCharge in FCharges do
    Result.AddDomainObject(DocumentCharge.Performer);

end;

function TDocument.FetchAllSigners: TEmployees;
var DocumentSigning: TDocumentSigning;
begin

  Result := TEmployees.Create;
  
  for DocumentSigning in FSignings do begin

    Result.AddDomainObject(DocumentSigning.Signer);

  end;

end;

function TDocument.FindApprovingByFormalApprover(
  FormalApprover: TEmployee): TDocumentApproving;
begin

  Result := FApprovings.FindByApprover(FormalApprover);

end;

function TDocument.FindChargeByPerformerOrActuallyPerformedEmployee(Employee: TEmployee): IDocumentCharge;
begin

  Result := FCharges.FindDocumentChargeByPerformerOrActuallyPerformedEmployee(Employee);
  
end;

function TDocument.FindSigningBySignerOrActuallySignedEmployee(Employee: TEmployee): TDocumentSigning;
begin

  Result := FSignings.FindDocumentSigningBySignerOrActuallySignedEmployee(Employee);
  
end;

function TDocument.ClassType: TDocumentClass;
begin

  Result := TDocumentClass(inherited ClassType);
  
end;

function TDocument.GetContent: String;
begin

  Result := FContent;

end;

function TDocument.GetAreAllApprovingsPerformed: Boolean;
var DocumentApproving: TDocumentApproving;
begin

  for DocumentApproving in Approvings do
    if not DocumentApproving.IsPerformed then
    begin

      Result := False;
      Exit;

    end;

  Result := True;

end;

function TDocument.GetAuthor: TEmployee;
begin

  Result := FAuthor;
  
end;

function TDocument.GetCreationDate: TDateTime;
begin

  Result := FCreationDate;

end;

function TDocument.GetCurrentWorkCycleStageName: String;
begin

  Result := FWorkCycle.CurrentStage.Name;

end;

function TDocument.GetCurrentWorkCycleStageNumber: Integer;
begin

  Result := FWorkCycle.CurrentStage.Number;
  
end;

function TDocument.GetDocumentApprovings: TDocumentApprovings;
begin

  Result := FApprovings;

end;

function TDocument.GetDocumentCharges: IDocumentCharges;
begin

  Result := FCharges;
  
end;

function TDocument.GetDocumentDate: Variant;
begin

  Result := FDocumentDate;
  
end;

function TDocument.GetDocumentSignings: TDocumentSignings;
begin

  Result := FSignings;
  
end;

function TDocument.GetEditingEmployee: TEmployee;
begin

  Result := FCurrentEditingEmployee;
  
end;

function TDocument.GetEmployeeDocumentWorkingRules: TEmployeeDocumentWorkingRules;
begin

  Result := FWorkingRules;
  
end;

function TDocument.GetIsApproved: Boolean;
begin

  Result := FWorkCycle.IsStageOfDocumentApprovedCurrent;
  
end;

function TDocument.GetIsApproving: Boolean;
begin

  Result := FWorkCycle.IsStageOfDocumentApprovingCurrent;
  
end;

function TDocument.GetIsNotApproved: Boolean;
begin

  Result := FWorkCycle.IsStageOfDocumentNotApprovedCurrent;
  
end;

function TDocument.GetIsNumberAssigned: Boolean;
begin

  Result := Trim(Number) <> '';
  
end;

function TDocument.GetIsPerformed: Boolean;
begin

  Result := FWorkCycle.IsStageOfDocumentPerformedCurrent;

end;

function TDocument.GetIsPerforming: Boolean;
begin

  Result :=
    FWorkCycle.IsStageOfDocumentPerformingCurrent
    or
    Specifications
      .DocumentPerformingSpecification.IsDocumentSentToPerforming(Self)

end;

function TDocument.GetIsRejectedFromSigning: Boolean;
begin

  Result := FWorkCycle.IsStageOfDocumentSigningRejectedCurrent;
  
end;

function TDocument.GetIsSelfRegistered: Boolean;
begin

  Result := FIsSelfRegistered;
  
end;

function TDocument.GetIsSentToSigning: Boolean;
begin

  Result := FIsSentToSigning;
  
end;

function TDocument.GetIsSigned: Boolean;
begin

  Result :=
    FWorkCycle.IsCurrentStageBetween(
      FWorkCycle.StageOfDocumentSigned,
      FWorkCycle.StageOfDocumentPerformed
    );
    
end;

function TDocument.GetIsSigning: Boolean;
begin

  Result := FWorkCycle.IsStageOfDocumentSigningCurrent;
  
end;

function TDocument.GetKindIdentity: Variant;
begin

  Result := FKindIdentity;
  
end;

class function TDocument.ListType: TDocumentsClass;
begin

  Result := TDocuments;
  
end;

function TDocument.GetName: String;
begin

  Result := FName;
  
end;

function TDocument.GetNote: String;
begin

  Result := FNote;

end;

function TDocument.GetNumber: String;
begin

  Result := FNumber;
  
end;

function TDocument.GetProductCode: String;
begin

  Result := FProductCode;
  
end;

function TDocument.GetResponsibleId: Variant;
begin

  Result := FResponsibleId;
  
end;

function TDocument.GetWorkCycle: TDocumentWorkCycle;
begin

  Result := FWorkCycle;
  
end;

constructor TDocument.Create(Identity: Variant);
begin

  inherited;

  CustomizeInitialState;
  
end;

class function TDocument.IncomingDocumentType: TDocumentClass;
begin

  Result := nil;
  
end;

function TDocument.IsPerformedBy(Employee: TEmployee): Boolean;
var EmployeeDocumentCharge: IDocumentCharge;
begin

  EmployeeDocumentCharge :=
    Charges.
      FindDocumentChargeByPerformerOrActuallyPerformedEmployee(Employee);

  Result :=
    Assigned(EmployeeDocumentCharge) and
    EmployeeDocumentCharge.IsPerformed;
    
end;

function TDocument.IsSignedBy(Employee: TEmployee): Boolean;
var DocumentSigning: TDocumentSigning;
begin

  DocumentSigning :=
    Signings.FindDocumentSigningBySignerOrActuallySignedEmployee(Employee);

  Result := Assigned(DocumentSigning) and DocumentSigning.IsPerformed;

end;

procedure TDocument.MarkAsApprovedBy(Employee: TEmployee);
begin

  EnsureThatEmployeeMayMarkAsApproved(Employee);

  FWorkCycle.ToStageOfDocumentApproved;

end;

procedure TDocument.MarkAsNotApprovedBy(Employee: TEmployee);
begin

  EnsureThatEmployeeMayMarkAsNotApproved(Employee);

  FWorkCycle.ToStageOfDocumentNotApproved;

end;

procedure TDocument.MarkAsSignedForAllSigners(
  const MarkingEmployee: TEmployee;
  const SigningDate: TDateTime
);
var
    DocumentSigning: TDocumentSigning;
begin

  EnsureEmployeeCanMarkDocumentAsSigned(MarkingEmployee);

  for DocumentSigning in Signings do
    DocumentSigning.MarkAsPerformedBy(DocumentSigning.Signer, SigningDate);

  FWorkCycle.ToStageOfDocumentSigned;
    
end;

class function TDocument.NumberPropertyName: String;
begin

  Result := 'Number';
  
end;

procedure TDocument.MarkAsSigned(
  const MarkingEmployee: TEmployee;
  const Signer: TEmployee;
  const SigningDate: TDateTime
);
begin

  EnsureEmployeeCanMarkDocumentAsSigned(MarkingEmployee);

  Signings.MarkSigningAsPerformedByOnBehalfOf(Signer, Signer, SigningDate);

  if Signings.AreAllSigningsPerformed then
    FWorkCycle.ToStageOfDocumentSigned;
  
end;

procedure TDocument.PerformCharge(Charge: IDocumentCharge);
begin

  EnsureThatDocumentMayBeMarkedAsPerformed(Charge.Performer, Charge.ActuallyPerformedEmployee);

  FCharges.MarkChargeAsPerformedBy(Charge);

  ToStageOfDocumentPerformedIfNecessary;

end;

procedure TDocument.RaiseExceptionIfEditingEmployeeNotAssigned;
begin

  if not Assigned(FCurrentEditingEmployee) then
    raise TDocumentException.Create(
            'Для текущего документа ' +
            'не найден редактирующий сотрудник'
          );
  
end;

procedure TDocument.RaiseExceptionIfEditingEmployeeOrWorkingRulesNotAssigned;
begin

  RaiseExceptionIfEditingEmployeeNotAssigned;
  RaiseExceptionIfWorkingRulesNotAssigned;

end;

procedure TDocument.RaiseExceptionIfWorkingRulesNotAssigned;
begin

  if not Assigned(FWorkingRules) then
    raise TDocumentException.Create(
            'Для текущего документа ' +
            'не были назначены рабочие правила'
          );
          
end;

procedure TDocument.RejectApprovingBy(
  Employee: TEmployee;
  const Reason: String
);
begin

  RejectApprovingByOnBehalfOf(Employee, Employee, Reason);
  
end;

procedure TDocument.RejectApprovingByOnBehalfOf(
  CurrentRejectingApprovingEmployee, FormalApprover: TEmployee;
  const Reason: String
);
var RealFormalAppover: TEmployee;
    FreeRealFormalApprover: IDomainObjectBase;
    DocumentApproving: TDocumentApproving;
begin

  RealFormalAppover :=
    EnsureThatEmployeeMayRejectApprovingAndGetRealFormalApprover(
      FormalApprover, CurrentRejectingApprovingEmployee
    );

  FreeRealFormalApprover := RealFormalAppover;

  DocumentApproving := FApprovings.FindByApprover(RealFormalAppover);

  DocumentApproving.MarkAsRejectedBy(
    CurrentRejectingApprovingEmployee, Reason
  );
  
end;

procedure TDocument.RejectSigningBy(Employee: TEmployee);
begin

  RejectSigningByBehalfOf(Employee, Employee);
  
end;

procedure TDocument.RejectSigningByBehalfOf(
  CurrentRejectingSigningEmployee,
  FormalSigner: TEmployee
);
var FreeDomainObject: IDomainObjectBase;
begin

  FreeDomainObject :=
    EnsureThatEmployeeMayRejectSigningAndGetRealFormalSigner(
      FormalSigner, CurrentRejectingSigningEmployee
    );

  FWorkCycle.ToStageOfDocumentSigningRejected;

  FIsSentToSigning := False;

end;

procedure TDocument.RemoveAllApprovers(RemovingEmployee: TEmployee);
var DocumentApproving: TDocumentApproving;
begin

  for DocumentApproving in FApprovings
  do begin

    EnsureThatEditingEmployeeMayRemoveApprover(
      RemovingEmployee, DocumentApproving.Approver
    );

  end;
  
  FApprovings.RemoveAll;

end;

procedure TDocument.RemoveAllCharges;
var
  DocumentCharge: IDocumentCharge;
begin

  for DocumentCharge in FCharges
  do EnsureThatEditingEmployeeMayRemoveChargeFor(DocumentCharge);

  FCharges.RemoveAllCharges;
  
end;

procedure TDocument.RemoveAllSigners;
var DocumentSigning: TDocumentSigning;
begin

  for DocumentSigning in FSignings
  do EnsureThatEditingEmployeeMayRemoveSigner(DocumentSigning.Signer);

  FSignings.RemoveAllSignings;
  
end;

procedure TDocument.RemoveApprover(
  RemovingEmployee: TEmployee;
  RemoveableEmployee: TEmployee
);
begin

  EnsureThatEditingEmployeeMayRemoveApprover(
    RemovingEmployee, RemoveableEmployee
  );

  FApprovings.RemoveApprovingFor(RemoveableEmployee);
  
end;

procedure TDocument.RemoveChargeFor(Performer: TEmployee);
var
    Charge: IDocumentCharge;
begin

  Charge := FCharges.FindDocumentChargeByPerformerOrActuallyPerformedEmployee(Performer);

  EnsureThatEditingEmployeeMayRemoveChargeFor(Charge);

  Charges.RemoveChargeFor(Performer);
  
end;

procedure TDocument.RemoveChargesFor(Performers: TEmployees);
var
    Performer: TEmployee;
begin

  for Performer in Performers do
    RemoveChargeFor(Performer);

end;

procedure TDocument.RemoveSigner(Employee: TEmployee);
begin

  EnsureThatEditingEmployeeMayRemoveSigner(Employee);

  Signings.RemoveSigningFor(Employee);
  
end;

procedure TDocument.SetAuthor(const Value: TEmployee);
begin

  if Assigned(FAuthor) then begin
  
    raise TDocumentException.CreateFmt(
            'Нельзя переназначить автора ' +
            'для текущего документа. Автор ' +
            'документа - "%s"',
            [FAuthor.FullName]
          );

  end;

  FAuthor := Value;
  FreeAuthor := FAuthor;
  
end;

procedure TDocument.SetContent(const Value: String);
begin

  if InvariantsComplianceRequested then
    RaiseExceptionIfEditingEmployeeNotAssigned;

  FContent := Value;

end;

procedure TDocument.SetCreationDate(const Value: TDateTime);
begin

  if InvariantsComplianceRequested then
    RaiseExceptionIfEditingEmployeeNotAssigned;

  FCreationDate := Value;
  
end;

procedure TDocument.SetCurrentWorkCycleStageName(const StageName: String);
begin

  if InvariantsComplianceRequested then begin

    raise TDocumentException.Create(
      'Программная ошибка. ' +
      'У документа на данный момент ' +
      'недопустимо изменять стадию ' +
      'рабочего цикла непосредственно'
    );
    //RaiseExceptionIfEditingEmployeeNotAssigned;

  end;

  FWorkCycle.ToSpecifiedStage(StageName);

end;

procedure TDocument.SetCurrentWorkCycleStageNumber(const StageNumber: Integer);
begin

  if InvariantsComplianceRequested then begin

    raise TDocumentException.Create(
      'Программная ошибка. ' +
      'У документа на данный момент ' +
      'недопустимо изменять стадию ' +
      'рабочего цикла непосредственно'
    );

  end;

  FWorkCycle.ToSpecifiedStage(StageNumber);
  
end;

procedure TDocument.SetDocumentApprovings(
  DocumentApprovings: TDocumentApprovings);
begin

  if InvariantsComplianceRequested then
    raise TDocumentException.Create(
            'Согласования для документа ' +
            'не могут назначаться непосредственно'
          );

  if not Assigned(DocumentApprovings) then
    FApprovings.Clear

  else begin

    FApprovings := DocumentApprovings;
    FFreeApprovings := FApprovings;
    
  end;

end;

procedure TDocument.SetDocumentCharges(const Value: IDocumentCharges);
begin

  if InvariantsComplianceRequested then begin
  
    raise TDocumentException.Create(
            'Поручения для документа ' +
            'не могут назначаться непосредственно'
          );

  end;

  if not Assigned(Value) then
    FCharges.Clear

  else begin

    FCharges := Value;
    
  end;

end;

procedure TDocument.SetDocumentDate(const Value: Variant);
begin

  if InvariantsComplianceRequested then
    RaiseExceptionIfEditingEmployeeNotAssigned;

  FDocumentDate := Value;
  
end;

procedure TDocument.SetDocumentSignings(const Value: TDocumentSignings);
begin

  if InvariantsComplianceRequested then
    raise TDocumentException.Create(
            'Подписания для документа ' +
            'не могут назначаться непосредственно'
          );

  if not Assigned(Value) then
    FSignings.Clear

  else begin

    FSignings := Value;
    FFreeSignings := FSignings;
    
  end;

end;

procedure TDocument.SetEditingEmployee(Employee: TEmployee);
begin

  EnsureThatEmployeeMayMakeChanges(Employee);

  FCurrentEditingEmployee := Employee;

end;

procedure TDocument.SetEmployeeDocumentWorkingRules(
  const Value: TEmployeeDocumentWorkingRules);
begin

  if FWorkingRules = Value then Exit;
  
  FreeAndNil(FWorkingRules);

  FWorkingRules := Value;
  FFreeWorkingRules := FWorkingRules;
  
end;

procedure TDocument.SetIdentity(Identity: Variant);
begin

  inherited;

  ChangeDocumentIdForAllDocumentSignings(Identity);
  ChangeDocumentIdForAllDocumentCharges(Identity);
  ChangeDocumentIdForAllDocumentApprovings(Identity);
  
end;

procedure TDocument.SetInvariantsComplianceRequested(const Value: Boolean);
begin

  inherited;

end;

procedure TDocument.SetIsSelfRegistered(const Value: Boolean);
begin
  
  if FIsSelfRegistered and Value then
    Exit;

  if not FIsSelfRegistered and not Value then
    Exit;

  if InvariantsComplianceRequested then
    EnsureThatEditingEmployeeMayMarkDocumentAsSelfRegistered;

  FIsSelfRegistered := Value;
  
end;

procedure TDocument.SetIsSentToSigning(const Value: Boolean);
begin

  if InvariantsComplianceRequested then begin

    raise TDocumentException.Create(
      'Признак отправки документа на ' +
      'подписание не может устанавливаться ' +
      'непосредственно'
    );

  end;
  
  FIsSentToSigning := Value;
  
end;

procedure TDocument.SetKindIdentity(KindIdentity: Variant);
var
    WorkCycleStage: TDocumentWorkCycleStage;
begin

  if InvariantsComplianceRequested then begin

    raise TDocumentException.Create(
      'Программная ошибка. Нельзя ' +
      'изменять идентификатор вида документа ' +
      'непосредственно'
    );
    
  end;

  FKindIdentity := KindIdentity;

  if Assigned(FWorkCycle) then begin

    for WorkCycleStage in FWorkCycle do
      WorkCycleStage.DocumentKindId := KindIdentity;

  end;

end;

procedure TDocument.SetName(const Value: String);
begin

  if InvariantsComplianceRequested then
    RaiseExceptionIfEditingEmployeeNotAssigned;

  FName := Value;
  
end;

procedure TDocument.SetNote(const Value: String);
begin

  if InvariantsComplianceRequested then
    RaiseExceptionIfEditingEmployeeNotAssigned;

  FNote := Value;
  
end;

procedure TDocument.SetNumber(const Value: String);
begin

  if InvariantsComplianceRequested then
    RaiseExceptionIfEditingEmployeeNotAssigned;

  FNumber := Value;

end;

procedure TDocument.SetProductCode(const Value: String);
begin

  FProductCode := Value;

end;

procedure TDocument.SetResponsibleId(const Value: Variant);
begin

  if InvariantsComplianceRequested then
    RaiseExceptionIfEditingEmployeeNotAssigned;

  FResponsibleId := Value;
  
end;

procedure TDocument.SetWorkCycle(const Value: TDocumentWorkCycle);
begin

  if FWorkCycle = Value then Exit;

  if InvariantsComplianceRequested then begin

    raise TDocumentException.Create(
      'Программная ошибка. Недопустимо ' +
      'устанавливать рабочий цикл документа ' +
      'непосредственно'
    );

  end;

  if Value.ClassType <> WorkCycleType then begin

    Raise TDocumentException.Create(
      'Попытка установить для документа ' +
      'недействительный рабочий цикл'
    );

  end;

  FWorkCycle := Value;
  FFreeWorkCycle := FWorkCycle;

end;

procedure TDocument.SignBy(Employee: TEmployee);
begin

  SignByOnBehalfOf(Employee, Employee);
  
end;

procedure TDocument.SignByOnBehalfOf(
  CurrentSigningEmployee, FormalSigner: TEmployee
);
var DocumentSigning: TDocumentSigning;
    RealFormalSigner: TEmployee;
    FreeDomainObject: IDomainObjectBase;
begin

  RealFormalSigner :=
    EnsureThatEmployeeMaySign(FormalSigner, CurrentSigningEmployee);

  FreeDomainObject := RealFormalSigner;

  DocumentSigning :=
    Signings.FindDocumentSigningBySignerOrActuallySignedEmployee(
      RealFormalSigner
    );

  DocumentSigning.MarkAsPerformedBy(CurrentSigningEmployee);

  if Signings.AreAllSigningsPerformed then
    FWorkCycle.ToStageOfDocumentSigned;

end;

procedure TDocument.ToApprovingBy(Employee: TEmployee);
begin

  EnsureThatEmployeeMaySendToApproving(Employee);

  FWorkCycle.ToStageOfDocumentApproving;
  
end;

procedure TDocument.ToPerformingBy(Employee: TEmployee);
begin

  EnsureThatEmployeeMaySendToPerforming(Employee);
  
  FWorkCycle.ToStageOfDocumentPerforming;

end;

procedure TDocument.ToSigningBy(Employee: TEmployee);
begin

  EnsureThatEmployeeMaySendToSigning(Employee);
  
  FWorkCycle.ToStageOfDocumentSigning;

  FIsSentToSigning := True;
  
end;

procedure TDocument.ToStageOfDocumentPerformedIfNecessary;
begin

  if FCharges.AreAllChargesPerformed then
    FWorkCycle.ToStageOfDocumentPerformed;
  
end;

class function TDocument.WorkCycleType: TDocumentWorkCycleClass;
begin

  Result := TDocumentWorkCycle;
  
end;

{ TDocumentsEnumerator }

constructor TDocumentsEnumerator.Create(Documents: TDocuments);
begin

  inherited Create(Documents);

end;

function TDocumentsEnumerator.GetCurrentDocument: TDocument;
begin

  Result := GetCurrentDomainObject as TDocument;
  
end;

{ TDocuments }

procedure TDocuments.AddDocument(Document: TDocument);
begin

  AddDomainObject(Document);
  
end;

function TDocuments.ExtractDocumentNumbers: TStrings;
var
    Document: TDocument;
begin

  Result := TStringList.Create;

  try

    for Document in Self do
      Result.Add(Document.Number);

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TDocuments.FindDocumentById(const DocumentId: Variant): TDocument;
begin

  Result := FindByIdentity(DocumentId) as TDocument;

end;

function TDocuments.FindDocumentsWithAssignedNumbers: TDocuments;
var
    Document: TDocument;
begin

  Result := TDocuments.Create;

  try
  
    for Document in Self do
      if Document.IsNumberAssigned then
        Result.AddDocument(Document);
        
  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TDocuments.FirstDocument: TDocument;
begin

  Result := TDocument(First);
  
end;

function TDocuments.GetDocumentByIndex(Index: Integer): TDocument;
begin

  Result := GetDomainObjectByIndex(Index) as TDocument;
  
end;

function TDocuments.GetDocumentsByNumber(const Number: String): TDocuments;
begin

  Result :=
    TDocuments(
      GetBaseDomainObjectsByPropertyValue(TDocument.NumberPropertyName, Number)
    );
    
end;

function TDocuments.GetEnumerator: TDocumentsEnumerator;
begin

  Result := TDocumentsEnumerator.Create(Self);
  
end;

procedure TDocuments.RemoveDocument(Document: TDocument);
begin

  DeleteDomainObject(Document);
  
end;

procedure TDocuments.SetDocumentByIndex(Index: Integer; Document: TDocument);
begin

  SetDomainObjectByIndex(Index, Document);

end;

end.
