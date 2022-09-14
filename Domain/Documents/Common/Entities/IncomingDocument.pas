unit IncomingDocument;

interface

uses

  AbstractDocumentDecorator,
  Document,
  Employee,
  DocumentCharges,
  DocumentSignings,
  EmployeeDocumentWorkingRules,
  DocumentChargeSheet,
  DocumentApprovings,
  DocumentChargeInterface,
  SysUtils,
  IDocumentUnit,
  DomainObjectListUnit,
  Classes;

type

  TIncomingDocuments = class;
  TIncomingDocumentsClass = class of TIncomingDocuments;

  TIncomingDocumentException = class (TAbstractDocumentDecoratorException)

  end;

  TIncomingDocument = class (TAbstractDocumentDecorator)

    protected

      FIncomingNumber: String;
      FReceiptDate: Variant;
      FReceiverId: Variant;

      procedure RaiseExceptionAboutThatIncomingDocumentCanNotBeMadeChanges;

      function InternalClone: TObject; override;

    public

      function GetIdentity: Variant; override;
      function GetKindIdentity: Variant; override;
      function GetContent: String; override;
      function GetCreationDate: TDateTime; override;
      function GetDocumentDate: Variant; override;
      function GetName: String; override;
      function GetNote: String; override;
      function GetProductCode: String; override;
      function GetNumber: String; override;
      function GetIncomingNumber: String; virtual;
      function GetReceiptDate: Variant; virtual;
      function GetReceiverId: Variant;
      function GetCurrentWorkCycleStageName: String; override;
      function GetCurrentWorkCycleStageNumber: Integer; override;
      function GetEditingEmployee: TEmployee; override;
      function GetAuthor: TEmployee; override;
      function GetDocumentCharges: IDocumentCharges; override;
      function GetDocumentSignings: TDocumentSignings; override;
      function GetIsRejectedFromSigning: Boolean; override;
      function GetIsPerformed: Boolean; override;
      function GetIsPerforming: Boolean; override;
      function GetIsSigned: Boolean; override;
      function GetIsSigning: Boolean; override;
      function GetResponsibleId: Variant; override;
      function GetAreAllApprovingsPerformed: Boolean; override;
      function GetIsSelfRegistered: Boolean; override;
      function GetIsNumberAssigned: Boolean; override;
      function GetIsIncomingNumberAssigned: Boolean; virtual;

      procedure SetIdentity(Identity: Variant); override;
      procedure SetKindIdentity(KindIdentity: Variant); override;
      procedure SetContent(const Value: String); override;
      procedure SetCreationDate(const Value: TDateTime); override;
      procedure SetDocumentDate(const Value: Variant); override;
      procedure SetName(const Value: String); override;
      procedure SetNote(const Value: String); override;
      procedure SetProductCode(const Value: String); override;
      procedure SetNumber(const Value: String); override;

      procedure SetIncomingNumber(const Value: String); virtual;
      procedure AssignIncomingNumber(const Value: String);
      
      procedure SetReceiptDate(const Value: Variant); virtual;
      procedure AssignReceiptDate(const Value: Variant);

      procedure SetReceiverId(const Value: Variant);
      procedure AssignReceiverId(const Value: Variant);
      
      procedure SetCurrentWorkCycleStageNumber(const StageNumber: Integer); override;
      procedure SetCurrentWorkCycleStageName(const StageName: String); override;
      procedure SetResponsibleId(const Value: Variant); override;
      procedure SetAuthor(const Value: TEmployee); override;
      procedure SetEditingEmployee(Employee: TEmployee); override;
      procedure SetIsSelfRegistered(const Value: Boolean); override;
      procedure SetOriginalDocument(const Value: TDocument); override;

      function GetEmployeeDocumentWorkingRules: TEmployeeDocumentWorkingRules; override;
      procedure SetEmployeeDocumentWorkingRules(const Value: TEmployeeDocumentWorkingRules); override;

    public

      procedure AddSigner(Employee: TEmployee); override;
      procedure RemoveSigner(Employee: TEmployee); override;
      procedure SignBy(Employee: TEmployee); override;

      procedure SignByOnBehalfOf(
        CurrentSigningEmployee: TEmployee;
        FormalSigner: TEmployee
      ); override;

      procedure RejectSigningBy(Employee: TEmployee); override;

      procedure RejectSigningByBehalfOf(
        CurrentRejectingSigningEmployee: TEmployee;
        FormalSigner: TEmployee
      ); override;

      procedure MarkAsSignedForAllSigners(
        const MarkingEmployee: TEmployee;
        const SigningDate: TDateTime
      ); override;
      
      procedure MarkAsSigned(
        const MarkingEmployee: TEmployee;
        const Signer: TEmployee;
        const SigningDate: TDateTime
      ); override;

      function FindSigningBySignerOrActuallySignedEmployee(
        Employee: TEmployee
      ): TDocumentSigning; override;

      function IsSignedBy(Employee: TEmployee): Boolean; override;
      
    public

      procedure RemoveChargeFor(Performer: TEmployee); override;

      function FindChargeByPerformerOrActuallyPerformedEmployee(
        Employee: TEmployee
      ): IDocumentCharge; override;

      function IsPerformedBy(Employee: TEmployee): Boolean; override;

      procedure ToSigningBy(Employee: TEmployee); override;
      procedure ToPerformingBy(Employee: TEmployee); override;

      function FetchAllSigners: TEmployees; override;
      function FetchAllPerformers: TEmployees; override;

    public

      constructor Create; overload; override;
      constructor Create(OriginalDocument: TDocument); overload; override;

      constructor Create(
        Identity: Variant;
        OriginalDocument: TDocument
      ); overload;

      constructor Create(
        OriginalDocument: TDocument;
        const ReceiverId: Variant
      ); overload;
      
      constructor Create(
        OriginalDocument: TDocument;
        const IncomingNumber: String;
        const ReceiptDate: TDateTime;
        const ReceiverId: Variant
      ); overload;
      
    public

      function FindApprovingByFormalApprover(
        FormalApprover: TEmployee
      ): TDocumentApproving; override;
      
      function GetDocumentApprovings: TDocumentApprovings; override;

      function GetIsSentToSigning: Boolean; override;
      function GetIsApproving: Boolean; override;
      function GetIsApproved: Boolean; override;
      function GetIsNotApproved: Boolean; override;

    published

      property IncomingNumber: String
      read GetIncomingNumber write SetIncomingNumber;

      property ReceiptDate: Variant
      read GetReceiptDate write SetReceiptDate;

      property ReceiverId: Variant
      read GetReceiverId write SetReceiverId;

      property IsIncomingNumberAssigned: Boolean
      read GetIsIncomingNumberAssigned;

    public

      class function ListType: TDocumentsClass; override;
      class function IncomingListType: TIncomingDocumentsClass; virtual;
      class function OutcomingDocumentType: TDocumentClass; virtual; abstract;

  end;
  
  TIncomingDocumentsEnumerator = class (TDocumentsEnumerator)

    protected

      function GetCurrentIncomingDocument: TIncomingDocument;
      
    public

      constructor Create(IncomingDocuments: TIncomingDocuments);
      
      property Current: TIncomingDocument
      read GetCurrentIncomingDocument;
      
  end;

  TIncomingDocuments = class (TDocuments)

    protected

      function GetDocumentByIndex(Index: Integer): TIncomingDocument;
      procedure SetDocumentByIndex(
        Index: Integer;
        const Value: TIncomingDocument
      );

    public

      destructor Destroy; override;

      function ExtractOriginalDocuments: TDocuments;

      function FindIncomingDocumentById(
        const DocumentId: Variant
      ): TIncomingDocument;

      property Items[Index: Integer]: TIncomingDocument
      read GetDocumentByIndex
      write SetDocumentByIndex; default;

      function GetEnumerator: TIncomingDocumentsEnumerator;
      
  end;

  TIncomingDocumentClass = class of TIncomingDocument;

implementation

uses

  Variants, DomainObjectBaseUnit, DomainObjectUnit, DomainObjectBaseListUnit;
  
{ TIncomingDocument }

procedure TIncomingDocument.AddSigner(Employee: TEmployee);
begin

  RaiseExceptionAboutThatIncomingDocumentCanNotBeMadeChanges

end;

constructor TIncomingDocument.Create(
  Identity: Variant;
  OriginalDocument: TDocument);
begin

  inherited Create(OriginalDocument);

  Self.Identity := Identity;

  AssignReceiverId(Null);

end;

constructor TIncomingDocument.Create;
begin

  inherited;

  FReceiverId := Null;

end;

constructor TIncomingDocument.Create(OriginalDocument: TDocument);
begin

  inherited Create(OriginalDocument);

  AssignReceiverId(Null);
  
end;

constructor TIncomingDocument.Create(
  OriginalDocument: TDocument;
  const IncomingNumber: String;
  const ReceiptDate: TDateTime;
  const ReceiverId: Variant
);
begin

  inherited Create(OriginalDocument);

  AssignIncomingNumber(IncomingNumber);
  AssignReceiptDate(ReceiptDate);
  AssignReceiverId(ReceiverId);

end;

function TIncomingDocument.FetchAllPerformers: TEmployees;
begin

  Result := inherited FetchAllPerformers;

end;

function TIncomingDocument.FetchAllSigners: TEmployees;
begin

  Result := inherited FetchAllSigners;
  
end;

function TIncomingDocument.FindApprovingByFormalApprover(
  FormalApprover: TEmployee): TDocumentApproving;
begin

  Result := FOriginalDocument.FindApprovingByFormalApprover(FormalApprover);
  
end;

function TIncomingDocument.FindChargeByPerformerOrActuallyPerformedEmployee(
  Employee: TEmployee
): IDocumentCharge;
begin

  Result :=
    inherited FindChargeByPerformerOrActuallyPerformedEmployee(
      Employee
    );
    
end;

function TIncomingDocument.FindSigningBySignerOrActuallySignedEmployee(
  Employee: TEmployee): TDocumentSigning;
begin

  Result :=
    inherited FindSigningBySignerOrActuallySignedEmployee(Employee);
    
end;

function TIncomingDocument.GetAreAllApprovingsPerformed: Boolean;
begin

  Result := inherited GetAreAllApprovingsPerformed;

end;

function TIncomingDocument.GetAuthor: TEmployee;
begin

  Result := inherited GetAuthor;
  
end;

function TIncomingDocument.GetContent: String;
begin

  Result := inherited GetContent;
  
end;

function TIncomingDocument.GetCreationDate: TDateTime;
begin

  Result := inherited GetCreationDate;

end;

function TIncomingDocument.GetCurrentWorkCycleStageName: String;
begin

  Result := inherited GetCurrentWorkCycleStageName;
  
end;

function TIncomingDocument.GetCurrentWorkCycleStageNumber: Integer;
begin

  Result := inherited GetCurrentWorkCycleStageNumber;
  
end;

function TIncomingDocument.GetDocumentApprovings: TDocumentApprovings;
begin

  Result := FOriginalDocument.Approvings;
  
end;

function TIncomingDocument.GetDocumentCharges: IDocumentCharges;
begin

  Result := inherited GetDocumentCharges;
  
end;

function TIncomingDocument.GetDocumentDate: Variant;
begin

  Result := FOriginalDocument.DocumentDate;
  
end;

function TIncomingDocument.GetDocumentSignings: TDocumentSignings;
begin

  Result := inherited GetDocumentSignings;

end;

function TIncomingDocument.GetEditingEmployee: TEmployee;
begin

  Result := nil;
  
end;

function TIncomingDocument.GetEmployeeDocumentWorkingRules: TEmployeeDocumentWorkingRules;
begin

  Result := inherited GetEmployeeDocumentWorkingRules;
  
end;

function TIncomingDocument.GetIdentity: Variant;
begin

  Result := FIdentity;

end;

class function TIncomingDocument.IncomingListType: TIncomingDocumentsClass;
begin

  Result := TIncomingDocumentsClass(ListType);
  
end;

function TIncomingDocument.GetIncomingNumber: String;
begin

  Result := FIncomingNumber;

end;

function TIncomingDocument.GetIsApproved: Boolean;
begin

  Result := FOriginalDocument.IsApproved;
  
end;

function TIncomingDocument.GetIsApproving: Boolean;
begin

  Result := FOriginalDocument.IsApproving;
  
end;

function TIncomingDocument.GetIsIncomingNumberAssigned: Boolean;
begin

  Result := Trim(IncomingNumber) <> '';
  
end;

function TIncomingDocument.GetIsNotApproved: Boolean;
begin

  Result := FOriginalDocument.IsNotApproved;
  
end;

function TIncomingDocument.GetIsNumberAssigned: Boolean;
begin

  Result := inherited GetIsNumberAssigned;
  
end;

function TIncomingDocument.GetIsPerformed: Boolean;
begin

  Result := inherited GetIsPerformed;
  
end;

function TIncomingDocument.GetIsPerforming: Boolean;
begin

  Result := inherited GetIsPerforming;
  
end;

function TIncomingDocument.GetIsRejectedFromSigning: Boolean;
begin

  Result := inherited GetIsRejectedFromSigning;
  
end;

function TIncomingDocument.GetIsSelfRegistered: Boolean;
begin

  Result := inherited GetIsSelfRegistered;
  
end;

function TIncomingDocument.GetIsSentToSigning: Boolean;
begin

  Result := FOriginalDocument.IsSentToSigning;
  
end;

function TIncomingDocument.GetIsSigned: Boolean;
begin

  Result := inherited GetIsSigned;
  
end;

function TIncomingDocument.GetIsSigning: Boolean;
begin

  Result := inherited GetIsSigning;
  
end;

function TIncomingDocument.GetKindIdentity: Variant;
begin

  Result := FKindIdentity;
  
end;

class function TIncomingDocument.ListType: TDocumentsClass;
begin

  Result := TIncomingDocuments;

end;

function TIncomingDocument.GetName: String;
begin

  Result := inherited GetName;
  
end;

function TIncomingDocument.GetNote: String;
begin

  Result := inherited GetNote;
  
end;

function TIncomingDocument.GetNumber: String;
begin

  Result := inherited GetNumber;
  
end;

function TIncomingDocument.GetProductCode: String;
begin

  Result := FOriginalDocument.ProductCode;
  
end;

function TIncomingDocument.GetReceiptDate: Variant;
begin

  Result := FReceiptDate;
  
end;

function TIncomingDocument.GetReceiverId: Variant;
begin

  Result := FReceiverId;
  
end;

function TIncomingDocument.GetResponsibleId: Variant;
begin

  Result := inherited GetResponsibleId;
  
end;

function TIncomingDocument.InternalClone: TObject;
var CloneeIncomingDocument: TIncomingDocument;
begin

  CloneeIncomingDocument := inherited InternalClone as TIncomingDocument;

  CloneeIncomingDocument.Identity := GetIdentity;
  CloneeIncomingDocument.IncomingNumber := IncomingNumber;
  CloneeIncomingDocument.ReceiptDate := ReceiptDate;
  CloneeIncomingDocument.ReceiverId := ReceiverId;

  Result := CloneeIncomingDocument;
  
end;

function TIncomingDocument.IsPerformedBy(Employee: TEmployee): Boolean;
begin

  Result := inherited IsPerformedBy(Employee);
  
end;

function TIncomingDocument.IsSignedBy(Employee: TEmployee): Boolean;
begin

  Result := inherited IsSignedBy(Employee);
  
end;

procedure TIncomingDocument.MarkAsSigned(
  const MarkingEmployee: TEmployee;
  const Signer: TEmployee;
  const SigningDate: TDateTime
);
begin

  RaiseExceptionAboutThatIncomingDocumentCanNotBeMadeChanges;

end;

procedure TIncomingDocument.MarkAsSignedForAllSigners(
  const MarkingEmployee: TEmployee;
  const SigningDate: TDateTime
);
begin

  RaiseExceptionAboutThatIncomingDocumentCanNotBeMadeChanges;

end;

procedure TIncomingDocument.RaiseExceptionAboutThatIncomingDocumentCanNotBeMadeChanges;
begin

  raise TIncomingDocumentException.Create(
          'Во входящий документ ' +
          'не могут вноситься изменения'
        );
  
end;

procedure TIncomingDocument.RejectSigningBy(Employee: TEmployee);
begin

  RaiseExceptionAboutThatIncomingDocumentCanNotBeMadeChanges
  
end;

procedure TIncomingDocument.RejectSigningByBehalfOf(
  CurrentRejectingSigningEmployee, FormalSigner: TEmployee);
begin

  RaiseExceptionAboutThatIncomingDocumentCanNotBeMadeChanges;
  
end;

procedure TIncomingDocument.RemoveChargeFor(Performer: TEmployee);
begin

  RaiseExceptionAboutThatIncomingDocumentCanNotBeMadeChanges;
  
end;

procedure TIncomingDocument.RemoveSigner(Employee: TEmployee);
begin

  RaiseExceptionAboutThatIncomingDocumentCanNotBeMadeChanges;
  
end;

procedure TIncomingDocument.SetAuthor(const Value: TEmployee);
begin

  RaiseExceptionAboutThatIncomingDocumentCanNotBeMadeChanges;
  
end;

procedure TIncomingDocument.SetContent(const Value: String);
begin

  RaiseExceptionAboutThatIncomingDocumentCanNotBeMadeChanges;
  
end;

procedure TIncomingDocument.SetCreationDate(const Value: TDateTime);
begin

  RaiseExceptionAboutThatIncomingDocumentCanNotBeMadeChanges;
  
end;

procedure TIncomingDocument.SetCurrentWorkCycleStageName(
  const StageName: String);
begin

  RaiseExceptionAboutThatIncomingDocumentCanNotBeMadeChanges;
  
end;

procedure TIncomingDocument.SetCurrentWorkCycleStageNumber(
  const StageNumber: Integer);
begin

  RaiseExceptionAboutThatIncomingDocumentCanNotBeMadeChanges;
  
end;

procedure TIncomingDocument.SetDocumentDate(const Value: Variant);
begin

  RaiseExceptionAboutThatIncomingDocumentCanNotBeMadeChanges;
  
end;

procedure TIncomingDocument.SetEditingEmployee(Employee: TEmployee);
begin

  RaiseExceptionAboutThatIncomingDocumentCanNotBeMadeChanges;
  
end;

procedure TIncomingDocument.SetEmployeeDocumentWorkingRules(
  const Value: TEmployeeDocumentWorkingRules);
begin

  inherited SetEmployeeDocumentWorkingRules(Value);

end;

procedure TIncomingDocument.SetIdentity(Identity: Variant);
begin

  FIdentity := Identity;
  
end;

procedure TIncomingDocument.SetIncomingNumber(const Value: String);
begin

  if FIncomingNumber = Value then Exit;
                    {
  RaiseExceptionIfInvariantsComplianceRequested(
    TIncomingDocumentException,
    'Программная ошибка. ' +
    'Входящий номер документа не может устанавливаться непосредственно'
  );                 }
  
  AssignIncomingNumber(Value);
  
end;

procedure TIncomingDocument.SetIsSelfRegistered(const Value: Boolean);
begin

  RaiseExceptionAboutThatIncomingDocumentCanNotBeMadeChanges;
  
end;

procedure TIncomingDocument.SetKindIdentity(KindIdentity: Variant);
begin

  FKindIdentity := KindIdentity;

end;

procedure TIncomingDocument.SetName(const Value: String);
begin

  RaiseExceptionAboutThatIncomingDocumentCanNotBeMadeChanges;
  
end;

procedure TIncomingDocument.SetNote(const Value: String);
begin

  RaiseExceptionAboutThatIncomingDocumentCanNotBeMadeChanges;
  
end;

procedure TIncomingDocument.SetNumber(const Value: String);
begin

  RaiseExceptionAboutThatIncomingDocumentCanNotBeMadeChanges;
  
end;

procedure TIncomingDocument.SetOriginalDocument(const Value: TDocument);
begin

  if OriginalDocument = Value then Exit;

    {
  RaiseExceptionIfInvariantsComplianceRequested(
    TIncomingDocument,
    'Программная ошибка. Оригинальный документ не может ' +
    'устанавливаться непосредственно для входящего документа'
  ); }
  
  inherited SetOriginalDocument(Value);

end;

procedure TIncomingDocument.SetProductCode(const Value: String);
begin

  FOriginalDocument.ProductCode := Value;

end;

procedure TIncomingDocument.SetReceiptDate(const Value: Variant);
begin

  if FReceiptDate = Value then Exit;
                  {
  RaiseExceptionIfInvariantsComplianceRequested(
    TIncomingDocumentException,
    'Программная ошибка. ' +
    'Дата получения входящего документа не может устанавливаться непосредственно'
  );
                  }
  AssignReceiptDate(Value);
  
end;

procedure TIncomingDocument.SetReceiverId(const Value: Variant);
begin

  if FReceiverId = Value then Exit;
                 {
  RaiseExceptionIfInvariantsComplianceRequested(
    TIncomingDocumentException,
    'Программная ошибка. Получатель входящего документа ' +
    'не может устанавливаться непосредственно'
  );            }

  AssignReceiverId(Value);
  
end;

procedure TIncomingDocument.SetResponsibleId(const Value: Variant);
begin

  RaiseExceptionAboutThatIncomingDocumentCanNotBeMadeChanges;
  
end;

procedure TIncomingDocument.SignBy(Employee: TEmployee);
begin

  RaiseExceptionAboutThatIncomingDocumentCanNotBeMadeChanges;
  
end;

procedure TIncomingDocument.
  SignByOnBehalfOf(
    CurrentSigningEmployee,
    FormalSigner: TEmployee
  );
begin

  RaiseExceptionAboutThatIncomingDocumentCanNotBeMadeChanges;
  
end;

procedure TIncomingDocument.ToPerformingBy(Employee: TEmployee);
begin

  RaiseExceptionAboutThatIncomingDocumentCanNotBeMadeChanges;
  
end;

procedure TIncomingDocument.ToSigningBy(Employee: TEmployee);
begin

  RaiseExceptionAboutThatIncomingDocumentCanNotBeMadeChanges;
  
end;

procedure TIncomingDocument.AssignIncomingNumber(const Value: String);
begin

  FIncomingNumber := Value;

end;

procedure TIncomingDocument.AssignReceiptDate(const Value: Variant);
begin

  if (Value = Unassigned) or not VarIsType(Value, varDate) then begin

    raise TIncomingDocumentException.Create(
      'Дата получения входящего документа ' +
      'имеет неверный тип'
    );

  end;
  
  FReceiptDate := Value;
  
end;

procedure TIncomingDocument.AssignReceiverId(const Value: Variant);
begin

  FReceiverId := Value;
  
end;

constructor TIncomingDocument.Create(
  OriginalDocument: TDocument;
  const ReceiverId: Variant
);
begin

  inherited Create(OriginalDocument);

  AssignReceiverId(ReceiverId);
  
end;

{ TIncomingDocuments }

destructor TIncomingDocuments.Destroy;
begin

  inherited;

end;

function TIncomingDocuments.ExtractOriginalDocuments: TDocuments;
var
    IncomingDocument: TIncomingDocument;
begin

  if IsEmpty then begin

    Result := nil;
    Exit;
    
  end;

  Result := Self[0].OriginalDocument.ListType.Create;

  try

    for IncomingDocument in Self do
      Result.AddDocument(IncomingDocument.OriginalDocument);

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TIncomingDocuments.FindIncomingDocumentById(
  const DocumentId: Variant): TIncomingDocument;
begin

  Result := FindDocumentById(DocumentId) as TIncomingDocument;

end;

function TIncomingDocuments.GetDocumentByIndex(
  Index: Integer): TIncomingDocument;
begin

  Result := inherited GetDocumentByIndex(Index) as TIncomingDocument;

end;

function TIncomingDocuments.GetEnumerator: TIncomingDocumentsEnumerator;
begin

  Result := TIncomingDocumentsEnumerator.Create(Self);
  
end;

procedure TIncomingDocuments.SetDocumentByIndex(Index: Integer;
  const Value: TIncomingDocument);
begin

  inherited SetDocumentByIndex(Index, Value);
  
end;

{ TIncomingDocumentsEnumerator }

constructor TIncomingDocumentsEnumerator.Create(
  IncomingDocuments: TIncomingDocuments);
begin

  inherited Create(IncomingDocuments);
  
end;

function TIncomingDocumentsEnumerator.GetCurrentIncomingDocument: TIncomingDocument;
begin

  Result := GetCurrentDocument as TIncomingDocument;

end;

end.
