unit DocumentSignings;

interface

uses

  DomainException,
  DomainObjectUnit,
  DomainObjectValueUnit,
  IDomainObjectBaseUnit,
  DomainObjectListUnit,
  Employee,
  SysUtils,
  Classes;

type

  TDocumentSigningException = class (TDomainException)

  end;
  
  TDocumentSigning = class (TDomainObject)

    private

      FreeSigner: IDomainObjectBase;
      FreeActuallySignedEmployee: IDomainObjectBase;

    protected

      procedure SetInvariantsComplianceRequested(const Value: Boolean); override;
    
    protected

      FDocumentId: Variant;
      
      FSigner: TEmployee;
      FActuallySignedEmployee: TEmployee;
      FSigningDate: Variant;

      function GetActuallySignedEmployee: TEmployee;
      function GetIsPerformed: Boolean;
      function GetSigner: TEmployee;
      function GetSigningDate: Variant;

      procedure SetDocumentId(const Value: Variant);
      procedure SetSigner(const Value: TEmployee);
      procedure SetActuallySignedEmployee(const Value: TEmployee);
      procedure SetSigningDate(const Value: Variant);

      procedure AssignActuallySignedEmployee(Employee: TEmployee);
      
      procedure RaiseExceptionAboutThatMustNotChangePerformedSigningIfIsIt;

    public

      constructor Create; override;

      procedure MarkAsPerformedBy(
        ActuallySignedEmployee: TEmployee;
        const PerformingDate: TDateTime = 0
      );

    published

      property DocumentId: Variant
      read FDocumentId write SetDocumentId;
      
      property Signer: TEmployee
      read GetSigner write SetSigner;

      property ActuallySignedEmployee: TEmployee
      read GetActuallySignedEmployee
      write SetActuallySignedEmployee;

      property SigningDate: Variant
      read GetSigningDate write SetSigningDate;

      property IsPerformed: Boolean
      read GetIsPerformed;

  end;

  TDocumentSignings = class;

  TDocumentSigningsEnumerator = class (TDomainObjectListEnumerator)

    protected

      function GetCurrentDocumentSigning: TDocumentSigning;

    public

      constructor Create(DocumentSignings: TDocumentSignings);

      property Current: TDocumentSigning
      read GetCurrentDocumentSigning;

  end;

  TDocumentSignings = class (TDomainObjectList)

    protected

      function GetDocumentSigningByIndex(Index: Integer): TDocumentSigning;
      procedure SetDocumentSigningByIndex(
        Index: Integer;
        DocumentSigning: TDocumentSigning
      );

    public

      function First: TDocumentSigning;
      function Last: TDocumentSigning;
      
      function AddSigningFor(Employee: TEmployee): TDocumentSigning;

      procedure RemoveSigningFor(Employee: TEmployee);
      procedure RemoveAllSignings;
      
      procedure MarkSigningAsPerformedByOnBehalfOf(
        ActuallySignedEmployee: TEmployee;
        FormalAssignedSigner: TEmployee;
        const PerformingDate: TDateTime = 0
      );

      function IsEmpty: Boolean;

      function GetEnumerator: TDocumentSigningsEnumerator;

      function FindDocumentSigningBySignerId(
        const SignerId: Variant
      ): TDocumentSigning;
      
      function FindDocumentSigningBySignerOrActuallySignedEmployee(
        Employee: TEmployee
      ): TDocumentSigning;

      
      function AreAllSigningsPerformed: Boolean;
      function IsEmployeeAssignedAsSigner(Employee: TEmployee): Boolean;
      function IsEmployeeActuallySigned(Employee: TEmployee): Boolean;

      property Items[Index: Integer]: TDocumentSigning
      read GetDocumentSigningByIndex
      write SetDocumentSigningByIndex; default;

  end;

implementation

uses

  Variants,
  DomainObjectBaseUnit,
  Document;

{ TDocumentSigning }

procedure TDocumentSigning.AssignActuallySignedEmployee(Employee: TEmployee);
begin

  FActuallySignedEmployee := Employee;
  FreeActuallySignedEmployee := FActuallySignedEmployee;

end;

constructor TDocumentSigning.Create;
begin

  inherited;

  FSigningDate := Null;
  
end;

function TDocumentSigning.GetActuallySignedEmployee: TEmployee;
begin

  Result := FActuallySignedEmployee;

end;

function TDocumentSigning.GetIsPerformed: Boolean;
begin

  Result :=
    Assigned(ActuallySignedEmployee) and
    (not VarIsNull(SigningDate));

end;

function TDocumentSigning.GetSigner: TEmployee;
begin

  Result := FSigner;
  
end;

function TDocumentSigning.GetSigningDate: Variant;
begin

  Result := FSigningDate;
  
end;

procedure TDocumentSigning.MarkAsPerformedBy(
  ActuallySignedEmployee: TEmployee;
  const PerformingDate: TDateTime
);
begin

  RaiseExceptionAboutThatMustNotChangePerformedSigningIfIsIt;

  AssignActuallySignedEmployee(ActuallySignedEmployee);

  if PerformingDate = 0 then
    FSigningDate := Now

  else FSigningDate := PerformingDate;

end;

procedure TDocumentSigning.RaiseExceptionAboutThatMustNotChangePerformedSigningIfIsIt;
begin

  if not InvariantsComplianceRequested then Exit;

  if IsPerformed then begin
    
    raise TDocumentSigningException.CreateFmt(
            'Документ уже был подписан ранее ' +
            'сотрудником "%s"',
            [ActuallySignedEmployee.FullName]
          );

  end;

end;

procedure TDocumentSigning.SetActuallySignedEmployee(const Value: TEmployee);
begin

  if InvariantsComplianceRequested then
    raise TDocumentSigningException.Create(
            'Нельзя устанавливать ' +
            'фактически подписавшего документ ' +
            'сотрудника непосредственно'
          );

  AssignActuallySignedEmployee(Value);

end;

procedure TDocumentSigning.SetDocumentId(const Value: Variant);
begin

  FDocumentId := Value;

end;

procedure TDocumentSigning.SetInvariantsComplianceRequested(
  const Value: Boolean);
begin

  inherited;
  
end;

procedure TDocumentSigning.SetSigner(const Value: TEmployee);
begin

  RaiseExceptionAboutThatMustNotChangePerformedSigningIfIsIt;

  FSigner := Value;
  FreeSigner := FSigner;

end;

procedure TDocumentSigning.SetSigningDate(const Value: Variant);
begin

  if InvariantsComplianceRequested then
    raise TDocumentSigningException.Create(
            'Нельзя устанавливать ' +
            'дату подписания документа ' +
            'непосредственно'
          );

  FSigningDate := Value;
  
end;

{ TDocumentSigningsEnumerator }

constructor TDocumentSigningsEnumerator.Create(
  DocumentSignings: TDocumentSignings);
begin

  inherited Create(DocumentSignings);

end;

function TDocumentSigningsEnumerator.GetCurrentDocumentSigning: TDocumentSigning;
begin

  Result := GetCurrentDomainObject as TDocumentSigning;
  
end;

{ TDocumentSignings }

function TDocumentSignings.AddSigningFor(
  Employee: TEmployee
): TDocumentSigning;

var DocumentSigning: TDocumentSigning;
begin
                  
  DocumentSigning := TDocumentSigning.Create;

  DocumentSigning.Signer := Employee;

  AddDomainObject(DocumentSigning);

  Result := DocumentSigning;
  
end;

function TDocumentSignings.AreAllSigningsPerformed: Boolean;
var DocumentSigning: TDocumentSigning;
begin

  for DocumentSigning in Self do
    if not DocumentSigning.IsPerformed then begin

      Result := False;
      Exit;
      
    end;

  Result := True;

end;

function TDocumentSignings.IsEmployeeActuallySigned(
  Employee: TEmployee
): Boolean;
var DocumentSigning: TDocumentSigning;
begin

  DocumentSigning :=
    FindDocumentSigningBySignerOrActuallySignedEmployee(Employee);

  if not Assigned(DocumentSigning) then
    Result := False

  else Result := DocumentSigning.ActuallySignedEmployee.IsSameAs(Employee);

end;

function TDocumentSignings.FindDocumentSigningBySignerId(
  const SignerId: Variant
): TDocumentSigning;
begin

  for Result in Self do
    if Result.Signer.Identity = SignerId then
      Exit;

  Result := nil;

end;

function TDocumentSignings.FindDocumentSigningBySignerOrActuallySignedEmployee(
  Employee: TEmployee
): TDocumentSigning;
begin

  for Result in Self do
    if Result.Signer.IsSameAs(Employee) or
       (Assigned(Result.ActuallySignedEmployee) and
        Result.ActuallySignedEmployee.IsSameAs(Employee))
    then Exit;

  Result := nil;

end;

function TDocumentSignings.First: TDocumentSigning;
begin

  Result := TDocumentSigning(inherited First);
  
end;

function TDocumentSignings.GetDocumentSigningByIndex(
  Index: Integer): TDocumentSigning;
begin

  Result := GetDomainObjectByIndex(Index) as TDocumentSigning;
  
end;

function TDocumentSignings.GetEnumerator: TDocumentSigningsEnumerator;
begin

  Result := TDocumentSigningsEnumerator.Create(Self);

end;

function TDocumentSignings.IsEmployeeAssignedAsSigner(
  Employee: TEmployee): Boolean;
var DocumentSigning: TDocumentSigning;
begin

  DocumentSigning :=
    FindDocumentSigningBySignerOrActuallySignedEmployee(Employee);

  if not Assigned(DocumentSigning) then
    Result := False

  else Result := DocumentSigning.Signer.IsSameAs(Employee);

end;

function TDocumentSignings.IsEmpty: Boolean;
begin

  Result := Count = 0;
  
end;

function TDocumentSignings.Last: TDocumentSigning;
begin

  Result := TDocumentSigning(inherited Last);
  
end;

procedure TDocumentSignings.MarkSigningAsPerformedByOnBehalfOf(
  ActuallySignedEmployee, FormalAssignedSigner: TEmployee;
  const PerformingDate: TDateTime
);
var DocumentSigning: TDocumentSigning;
begin

  DocumentSigning :=
    FindDocumentSigningBySignerOrActuallySignedEmployee(
      FormalAssignedSigner
    );

  if not Assigned(DocumentSigning) then begin

    raise TDocumentSigningException.CreateFmt(
            'Сотрудник "%s" не найден в качестве ' +
            'подписанта документа',
            [FormalAssignedSigner.FullName]
          );

  end;

  DocumentSigning.MarkAsPerformedBy(ActuallySignedEmployee, PerformingDate);

end;

procedure TDocumentSignings.RemoveAllSignings;
begin

  Clear;
  
end;

procedure TDocumentSignings.RemoveSigningFor(Employee: TEmployee);
var DocumentSigning: TDocumentSigning;
    I: Integer;
begin

  for I := 0 to Self.Count - 1 do begin

    DocumentSigning := Self[I];

    if DocumentSigning.Signer.IsSameAs(Employee) then begin

      DeleteDomainObjectEntryByIndex(I);
      Exit;

    end;

  end;

end;

procedure TDocumentSignings.SetDocumentSigningByIndex(Index: Integer;
  DocumentSigning: TDocumentSigning);
begin

  SetDomainObjectByIndex(Index, DocumentSigning);

end;

end.
