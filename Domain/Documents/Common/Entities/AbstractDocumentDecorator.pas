unit AbstractDocumentDecorator;

interface

uses

  IDocumentUnit,
  Document,
  Employee,
  DocumentSignings,
  DocumentCharges,
  DocumentApprovings,
  DocumentChargeInterface,
  VariantListUnit,
  DomainObjectBaseUnit,
  DomainObjectBaseListUnit,
  DomainObjectUnit,
  DomainObjectListUnit,
  SysUtils,
  Classes;

type

  TAbstractDocumentDecoratorException = class (TDocumentException)

  end;
  
  TAbstractDocumentDecorator = class abstract (TDocument)

    protected

      FOriginalDocumentReference: IDocument;
      FOriginalDocument: TDocument;

      function GetOriginalDocument: TDocument;
      procedure SetOriginalDocument(const Value: TDocument); virtual;

      procedure RaiseExceptionIfOriginalDocumentNotAssigned;

      function InternalClone: TObject; override;

    public

      constructor Create; overload; override;
      constructor Create(OriginalDocument: TDocument); overload; virtual;

      function GetIdentity: Variant; override;
      function GetKindIdentity: Variant; override;
      function GetContent: String; override;
      function GetCreationDate: TDateTime; override;
      function GetName: String; override;
      function GetNote: String; override;
      function GetNumber: String; override;
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

      procedure SetIdentity(Identity: Variant); override;
      procedure SetKindIdentity(KindIdentity: Variant); override;
      procedure SetContent(const Value: String); override;
      procedure SetCreationDate(const Value: TDateTime); override;
      procedure SetName(const Value: String); override;
      procedure SetNote(const Value: String); override;
      procedure SetNumber(const Value: String); override;
      procedure SetCurrentWorkCycleStageNumber(const StageNumber: Integer); override;
      procedure SetCurrentWorkCycleStageName(const StageName: String); override;
      procedure SetResponsibleId(const Value: Variant); override;
      procedure SetAuthor(const Value: TEmployee); override;
      procedure SetEditingEmployee(Employee: TEmployee); override;
      procedure SetIsSelfRegistered(const Value: Boolean); override;
      
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

      function FindSigningBySignerOrActuallySignedEmployee(
        Employee: TEmployee
      ): TDocumentSigning; override;

      function IsSignedBy(Employee: TEmployee): Boolean; override;

      procedure RemoveChargeFor(Performer: TEmployee); override;

      function FindChargeByPerformerOrActuallyPerformedEmployee(
        Employee: TEmployee
      ): IDocumentCharge; override;

      function IsPerformedBy(Employee: TEmployee): Boolean; override;

      procedure ToSigningBy(Employee: TEmployee); override;
      procedure ToPerformingBy(Employee: TEmployee); override;

      function FetchAllSigners: TEmployees; override;
      function FetchAllPerformers: TEmployees; override;
      
      property OriginalDocument: TDocument
      read GetOriginalDocument write SetOriginalDocument;

    published

      property Number: String read GetNumber write SetNumber;
      property Name: String read GetName write SetName;

      property CreationDate: TDateTime
      read GetCreationDate write SetCreationDate;

      property Content: String read GetContent write SetContent;
      property Note: String read GetNote write SetNote;

      property ResponsibleId: Variant
      read GetResponsibleId write SetResponsibleId;

      property Author: TEmployee
      read GetAuthor write SetAuthor;

      property CurrentWorkCycleStageNumber: Integer
      read GetCurrentWorkCycleStageNumber
      write SetCurrentWorkCycleStageNumber;

      property CurrentWorkCycleStageName: String
      read GetCurrentWorkCycleStageName
      write SetCurrentWorkCycleStageName;

      property IsSigning: Boolean read GetIsSigning;
      property IsSigned: Boolean read GetIsSigned;
      property IsPerforming: Boolean read GetIsPerforming;
      property IsPerformed: Boolean read GetIsPerformed;
      property IsRejectedFromSigning: Boolean read GetIsRejectedFromSigning;

      property IsSelfRegistered: Boolean
      read GetIsSelfRegistered write SetIsSelfRegistered;
      
      property Signings: TDocumentSignings read GetDocumentSignings;
      property Charges: IDocumentCharges read GetDocumentCharges;

      property EditingEmployee: TEmployee
      read GetEditingEmployee write SetEditingEmployee;

  end;

  TAbstractDocumentsDecorator = class abstract (TDocuments)

    protected

      FOriginalDocuments: TDocuments;

    protected

      function GetDomainObjectByIndex(Index: Integer): TDomainObject; override;

      procedure SetDomainObjectByIndex(
        Index: Integer;
        const Value: TDomainObject
      ); override;

      function GetDomainObjectCount: Integer; override;

      function InternalClone: TObject; override;
      
    public

      destructor Destroy; override;

      constructor Create(OriginalDocuments: TDocuments); virtual;
      
      procedure InsertDomainObject(
        const Index: Integer;
        DomainObject: TDomainObject
      ); override;

      function First: TDomainObject; override;
      function Last: TDomainObject; override;

      function CreateDomainObjectIdentityList: TVariantList; override;
      
      procedure AddDomainObject(DomainObject: TDomainObject); override;

      procedure Clear; override;
      
      function IsEmpty: Boolean; override;
      function Contains(DomainObject: TDomainObject): Boolean; override;

      procedure DeleteDomainObject(DomainObject: TDomainObject); override;
      procedure DeleteDomainObjectByIdentity(const Identity: Variant); override;
      
      function FindByIdentity(const Identity: Variant): TDomainObject; override;

      function Equals(Equatable: TObject): Boolean; override;
      
    public

      property OriginalDocuments: TDocuments read FOriginalDocuments;
      
  end;

  TAbstractDocumentsDecoratorClass = class of TAbstractDocumentsDecorator;

implementation

{ TAbstractDocumentDecorator }

procedure TAbstractDocumentDecorator.AddSigner(Employee: TEmployee);
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;

  FOriginalDocument.AddSigner(Employee);

end;

constructor TAbstractDocumentDecorator.Create;
begin

  inherited;

end;

constructor TAbstractDocumentDecorator.Create(OriginalDocument: TDocument);
begin

  inherited Create;

  SetOriginalDocument(OriginalDocument);
  
end;

function TAbstractDocumentDecorator.FetchAllPerformers: TEmployees;
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;
  
  Result := FOriginalDocument.FetchAllPerformers;

end;

function TAbstractDocumentDecorator.FetchAllSigners: TEmployees;
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;
  
  Result := FOriginalDocument.FetchAllSigners;
  
end;

function TAbstractDocumentDecorator.FindChargeByPerformerOrActuallyPerformedEmployee(
  Employee: TEmployee
): IDocumentCharge;
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;
  
  Result :=
    FOriginalDocument.FindChargeByPerformerOrActuallyPerformedEmployee(
      Employee
    );
    
end;

function TAbstractDocumentDecorator.FindSigningBySignerOrActuallySignedEmployee(
  Employee: TEmployee): TDocumentSigning;
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;
  
  Result :=
    FOriginalDocument.FindSigningBySignerOrActuallySignedEmployee(
      Employee
    );
    
end;

function TAbstractDocumentDecorator.GetAreAllApprovingsPerformed: Boolean;
begin

  Result := FOriginalDocument.AreAllApprovingsPerformed;

end;

function TAbstractDocumentDecorator.GetAuthor: TEmployee;
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;
  
  Result := FOriginalDocument.Author;
  
end;

function TAbstractDocumentDecorator.GetContent: String;
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;
  
  Result := FOriginalDocument.Content;
  
end;

function TAbstractDocumentDecorator.GetCreationDate: TDateTime;
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;
  
  Result := FOriginalDocument.CreationDate;

end;

function TAbstractDocumentDecorator.GetCurrentWorkCycleStageName: String;
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;
  
  Result := FOriginalDocument.CurrentWorkCycleStageName;
  
end;

function TAbstractDocumentDecorator.GetCurrentWorkCycleStageNumber: Integer;
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;
  
  Result := FOriginalDocument.CurrentWorkCycleStageNumber;
  
end;

function TAbstractDocumentDecorator.GetDocumentCharges: IDocumentCharges;
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;
  
  Result := FOriginalDocument.Charges;
  
end;

function TAbstractDocumentDecorator.GetDocumentSignings: TDocumentSignings;
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;
  
  Result := FOriginalDocument.Signings;

end;

function TAbstractDocumentDecorator.GetEditingEmployee: TEmployee;
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;

  Result := FOriginalDocument.EditingEmployee;
  
end;

function TAbstractDocumentDecorator.GetIdentity: Variant;
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;

  Result := FOriginalDocument.Identity;

end;

function TAbstractDocumentDecorator.GetIsNumberAssigned: Boolean;
begin

  Result := FOriginalDocument.IsNumberAssigned;
  
end;

function TAbstractDocumentDecorator.GetIsPerformed: Boolean;
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;
  
  Result := FOriginalDocument.IsPerformed;
  
end;

function TAbstractDocumentDecorator.GetIsPerforming: Boolean;
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;
  
  Result := FOriginalDocument.IsPerforming;
  
end;

function TAbstractDocumentDecorator.GetIsRejectedFromSigning: Boolean;
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;
  
  Result := FOriginalDocument.IsRejectedFromSigning;
  
end;

function TAbstractDocumentDecorator.GetIsSelfRegistered: Boolean;
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;

  Result := FOriginalDocument.IsSelfRegistered;
  
end;

function TAbstractDocumentDecorator.GetIsSigned: Boolean;
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;

  Result := FOriginalDocument.IsSigned;
  
end;

function TAbstractDocumentDecorator.GetIsSigning: Boolean;
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;
  
  Result := FOriginalDocument.IsSigning;
  
end;

function TAbstractDocumentDecorator.GetKindIdentity: Variant;
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;

  Result := FOriginalDocument.KindIdentity;
  
end;

function TAbstractDocumentDecorator.GetName: String;
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;
  
  Result := FOriginalDocument.Name;
  
end;

function TAbstractDocumentDecorator.GetNote: String;
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;
  
  Result := FOriginalDocument.Note;
  
end;

function TAbstractDocumentDecorator.GetNumber: String;
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;
  
  Result := FOriginalDocument.Number;
  
end;

function TAbstractDocumentDecorator.GetOriginalDocument: TDocument;
begin

  Result := FOriginalDocument;
  
end;

function TAbstractDocumentDecorator.GetResponsibleId: Variant;
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;
  
  Result := FOriginalDocument.ResponsibleId;
  
end;

function TAbstractDocumentDecorator.InternalClone: TObject;
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;

  Result := TAbstractDocumentDecorator.Create(OriginalDocument.Clone as TDocument);

end;

function TAbstractDocumentDecorator.IsPerformedBy(Employee: TEmployee): Boolean;
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;
  
  Result := FOriginalDocument.IsPerformedBy(Employee);
  
end;

function TAbstractDocumentDecorator.IsSignedBy(Employee: TEmployee): Boolean;
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;

  Result := FOriginalDocument.IsSignedBy(Employee);
  
end;

procedure TAbstractDocumentDecorator.RaiseExceptionIfOriginalDocumentNotAssigned;
begin

  if not Assigned(FOriginalDocument) then begin

    raise TAbstractDocumentDecoratorException.Create(
      'Программная ошибка. Не найден ' +
      'оригинальный документ в абстрактном ' +
      'декораторе документов'
    );
    
  end;

end;

procedure TAbstractDocumentDecorator.RejectSigningBy(Employee: TEmployee);
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;

  FOriginalDocument.RejectSigningBy(Employee);
  
end;

procedure TAbstractDocumentDecorator.RejectSigningByBehalfOf(
  CurrentRejectingSigningEmployee, FormalSigner: TEmployee);
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;

  FOriginalDocument.RejectSigningByBehalfOf(
    CurrentRejectingSigningEmployee, FormalSigner
  );

end;

procedure TAbstractDocumentDecorator.RemoveChargeFor(Performer: TEmployee);
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;

  FOriginalDocument.RemoveChargeFor(Performer);

end;

procedure TAbstractDocumentDecorator.RemoveSigner(Employee: TEmployee);
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;

  FOriginalDocument.RemoveSigner(Employee);
  
end;

procedure TAbstractDocumentDecorator.SetAuthor(const Value: TEmployee);
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;

  FOriginalDocument.Author := Value;
  
end;

procedure TAbstractDocumentDecorator.SetContent(const Value: String);
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;

  FOriginalDocument.Content := Value;
  
end;

procedure TAbstractDocumentDecorator.SetCreationDate(const Value: TDateTime);
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;

  FOriginalDocument.CreationDate := Value;
  
end;

procedure TAbstractDocumentDecorator.SetCurrentWorkCycleStageName(
  const StageName: String);
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;

  FOriginalDocument.CurrentWorkCycleStageName := StageName;
  
end;

procedure TAbstractDocumentDecorator.SetCurrentWorkCycleStageNumber(
  const StageNumber: Integer);
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;

  FOriginalDocument.CurrentWorkCycleStageNumber := StageNumber;
  
end;

procedure TAbstractDocumentDecorator.SetEditingEmployee(Employee: TEmployee);
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;

  FOriginalDocument.EditingEmployee := Employee;
  
end;

procedure TAbstractDocumentDecorator.SetIdentity(Identity: Variant);
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;

  FOriginalDocument.Identity := Identity;
  
end;

procedure TAbstractDocumentDecorator.SetIsSelfRegistered(const Value: Boolean);
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;

  FOriginalDocument.IsSelfRegistered := Value;
  
end;

procedure TAbstractDocumentDecorator.SetKindIdentity(KindIdentity: Variant);
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;

  FOriginalDocument.KindIdentity := KindIdentity;
  
end;

procedure TAbstractDocumentDecorator.SetName(const Value: String);
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;

  FOriginalDocument.Name := Value;
  
end;

procedure TAbstractDocumentDecorator.SetNote(const Value: String);
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;

  FOriginalDocument.Note := Value;
  
end;

procedure TAbstractDocumentDecorator.SetNumber(const Value: String);
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;

  FOriginalDocument.Number := Value;
  
end;

procedure TAbstractDocumentDecorator.SetOriginalDocument(const Value: TDocument);
begin

  FOriginalDocument := Value;
  FOriginalDocumentReference := Value;
  
end;

procedure TAbstractDocumentDecorator.SetResponsibleId(const Value: Variant);
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;

  FOriginalDocument.ResponsibleId := Value;
  
end;

procedure TAbstractDocumentDecorator.SignBy(Employee: TEmployee);
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;

  FOriginalDocument.SignBy(Employee);
  
end;

procedure TAbstractDocumentDecorator.
  SignByOnBehalfOf(
    CurrentSigningEmployee,
    FormalSigner: TEmployee
  );
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;

  FOriginalDocument.SignByOnBehalfOf(CurrentSigningEmployee, FormalSigner);
  
end;

procedure TAbstractDocumentDecorator.ToPerformingBy(Employee: TEmployee);
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;

  FOriginalDocument.ToPerformingBy(Employee);

end;

procedure TAbstractDocumentDecorator.ToSigningBy(Employee: TEmployee);
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;

  FOriginalDocument.ToSigningBy(Employee);
  
end;

{ TAbstractDocumentsDecorator }

procedure TAbstractDocumentsDecorator.AddDomainObject(
  DomainObject: TDomainObject);
begin

  FOriginalDocuments.AddDomainObject(DomainObject);

end;

procedure TAbstractDocumentsDecorator.Clear;
begin

  FOriginalDocuments.Clear;

end;

function TAbstractDocumentsDecorator.Contains(
  DomainObject: TDomainObject): Boolean;
begin

  Result := FOriginalDocuments.Contains(DomainObject);

end;

constructor TAbstractDocumentsDecorator.Create(OriginalDocuments: TDocuments);
begin

  inherited Create;

  FOriginalDocuments := OriginalDocuments;
  
end;

function TAbstractDocumentsDecorator.CreateDomainObjectIdentityList: TVariantList;
begin

  Result := FOriginalDocuments.CreateDomainObjectIdentityList;
  
end;

procedure TAbstractDocumentsDecorator.DeleteDomainObject(
  DomainObject: TDomainObject);
begin

  FOriginalDocuments.DeleteDomainObject(DomainObject);

end;

procedure TAbstractDocumentsDecorator.DeleteDomainObjectByIdentity(
  const Identity: Variant);
begin

  FOriginalDocuments.DeleteDomainObjectByIdentity(Identity);

end;

destructor TAbstractDocumentsDecorator.Destroy;
begin

  FreeAndNil(FOriginalDocuments);
  
  inherited;

end;

function TAbstractDocumentsDecorator.Equals(Equatable: TObject): Boolean;
begin

  if not (Equatable is TAbstractDocumentDecorator) then
    Result := False

  else begin

    Result :=
      FOriginalDocuments.Equals(
        (Equatable as TAbstractDocumentsDecorator).FOriginalDocuments
      );
      
  end;
  
end;

function TAbstractDocumentsDecorator.FindByIdentity(
  const Identity: Variant): TDomainObject;
begin

  Result := FOriginalDocuments.FindByIdentity(Identity);
  
end;

function TAbstractDocumentsDecorator.First: TDomainObject;
begin

  Result := FOriginalDocuments.First;
  
end;

function TAbstractDocumentsDecorator.GetDomainObjectByIndex(
  Index: Integer): TDomainObject;
begin

  Result := FOriginalDocuments[Index];

end;

function TAbstractDocumentsDecorator.GetDomainObjectCount: Integer;
begin

  Result := FOriginalDocuments.Count;
  
end;

procedure TAbstractDocumentsDecorator.InsertDomainObject(const Index: Integer;
  DomainObject: TDomainObject);
begin

  FOriginalDocuments.InsertDomainObject(Index, DomainObject);

end;

function TAbstractDocumentsDecorator.InternalClone: TObject;
begin

  Result :=
    TAbstractDocumentsDecoratorClass.Create(
      FOriginalDocuments.Clone as TDocuments
    );
    
end;

function TAbstractDocumentsDecorator.IsEmpty: Boolean;
begin

  Result := FOriginalDocuments.IsEmpty;

end;

function TAbstractDocumentsDecorator.Last: TDomainObject;
begin

  Result := FOriginalDocuments.Last;
  
end;

procedure TAbstractDocumentsDecorator.SetDomainObjectByIndex(Index: Integer;
  const Value: TDomainObject);
begin

  FOriginalDocuments[Index] := TDocument(Value);

end;

end.
