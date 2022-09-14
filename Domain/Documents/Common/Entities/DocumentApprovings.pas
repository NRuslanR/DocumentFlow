unit DocumentApprovings;

interface

uses

  DomainException,
  DomainObjectUnit,
  IDomainObjectUnit,
  DomainObjectListUnit,
  IDomainObjectListUnit,
  Employee,
  SysUtils,
  Classes;

type

  TDocumentApproving = class;
  TDocumentApprovingClass = class of TDocumentApproving;

  THistoricalDocumentApproving = class;
  THistoricalDocumentApprovingClass = class of THistoricalDocumentApproving;
  
  TDocumentApprovings = class;
  TDocumentApprovingsClass = class of TDocumentApprovings;

  THistoricalDocumentApprovings = class;
  THistoricalDocumentApprovingsClass = class of THistoricalDocumentApprovings;
  
  TDocumentApprovingPerformingResult = (

    prApproved = 1,
    prRejected = 2,
    prNotPerformed = 3

  );

  TDocumentApprovingException = class (TDomainException)

  end;
  
  TDocumentApproving = class (TDomainObject)

    private

      FFreeApprover: IDomainObject;
      
    protected

      FApprover: TEmployee;
      FDocumentId: Variant;
      FActuallyPerformedEmployeeId: Variant;
      FPerformingDateTime: Variant;
      FPerformingResult: TDocumentApprovingPerformingResult;
      FNote: String;

      function GetDocumentId: Variant; virtual;
      function GetApprover: TEmployee; virtual;
      function GetActuallyPerformedEmployeeId: Variant; virtual;
      function GetIsPerformed: Boolean; virtual;
      function GetPerformingResult: TDocumentApprovingPerformingResult; virtual;
      function GetNote: String; virtual;
      function GetPerformingResultName: String; virtual;
      
      procedure SetActuallyPerformedEmployeeId(const Value: Variant); virtual;
      function GetPerformingDateTime: Variant; virtual;
      procedure SetApprover(const Value: TEmployee); virtual;
      procedure SetPerformingDateTime(const Value: Variant); virtual;
      procedure SetNote(const Value: String); virtual;
      procedure SetDocumentId(const Value: Variant); virtual;
      procedure SetPerformingResult(
        const Value: TDocumentApprovingPerformingResult
      ); virtual;

      procedure MarkAsPerformedBy(
        PerformedEmployee: TEmployee;
        PerformingResult: TDocumentApprovingPerformingResult;
        const Note: String = ''
      );
      
      procedure RaiseExceptionIfAlreadyPerformed;

    protected

      function InternalClone: TObject; override;
      
    public

      destructor Destroy; override;
      constructor Create; override;

      procedure MarkAsApprovedBy(
        ActuallyApprovedEmployee: TEmployee;
        const Note: String = ''
      );

      procedure MarkAsRejectedBy(
        ActuallyRejectedEmployee: TEmployee;
        const Reason: String
      );

      procedure MarkAsRejectedIfNotPerformed(const Reason: String = '');
      
      property IsPerformed: Boolean read GetIsPerformed;
      
    published

      property DocumentId: Variant
      read GetDocumentId write SetDocumentId;
      
      property Approver: TEmployee
      read GetApprover write SetApprover;

      property ActuallyPerformedEmployeeId: Variant
      read GetActuallyPerformedEmployeeId write SetActuallyPerformedEmployeeId;

      property PerformingDateTime: Variant
      read GetPerformingDateTime write SetPerformingDateTime;

      property PerformingResult: TDocumentApprovingPerformingResult
      read GetPerformingResult write SetPerformingResult;

      property PerformingResultName: String
      read GetPerformingResultName;
      
      property Note: String read GetNote write SetNote;
      
  end;

  THistoricalDocumentApproving = class (TDocumentApproving)

    protected

      FApprovingCycleId: Variant;
      FOriginalApproving: TDocumentApproving;
      FFreeOriginalApproving: IDomainObject;
      
    protected

      function GetIdentity: Variant; override;
      function GetDocumentId: Variant; override;
      function GetApprover: TEmployee; override;
      function GetActuallyPerformedEmployeeId: Variant; override;
      function GetIsPerformed: Boolean; override;
      function GetPerformingResult: TDocumentApprovingPerformingResult; override;
      function GetNote: String; override;

      procedure SetIdentity(Identity: Variant); override;
      procedure SetActuallyPerformedEmployeeId(const Value: Variant); override;
      function GetPerformingDateTime: Variant; override;
      procedure SetApprover(const Value: TEmployee); override;
      procedure SetPerformingDateTime(const Value: Variant); override;
      procedure SetNote(const Value: String); override;
      procedure SetDocumentId(const Value: Variant); override;
      procedure SetPerformingResult(
        const Value: TDocumentApprovingPerformingResult
      ); override;

      procedure SetOriginalApproving(Value: TDocumentApproving);
      
      procedure SetInvariantsComplianceRequested(const Value: Boolean); override;
      
    public

      constructor Create(
        OriginalApproving: TDocumentApproving;
        const ApprovingCycleId: Variant
      );

      property OriginalApproving: TDocumentApproving
      read FOriginalApproving write SetOriginalApproving;
      
    published

      property ApprovingCycleId: Variant
      read FApprovingCycleId write FApprovingCycleId;

  end;

  TDocumentApprovingsEnumerator = class (TDomainObjectListEnumerator)

    protected

      function GetCurrentDocumentApproving: TDocumentApproving;

    public

      constructor Create(DocumentApprovings: TDocumentApprovings);

      property Current: TDocumentApproving
      read GetCurrentDocumentApproving;

  end;

  THistoricalDocumentApprovingsEnumerator = class (TDocumentApprovingsEnumerator)

    protected

      function GetCurrentHistoricalDocumentApproving: THistoricalDocumentApproving;

    public

      constructor Create(
        HistoricalDocumentApprovings: THistoricalDocumentApprovings
      );

      property Current: THistoricalDocumentApproving
      read GetCurrentHistoricalDocumentApproving;

  end;
  
  TDocumentApprovings = class (TDomainObjectList)

    private

      function GetDocumentApprovingByIndex(Index: Integer): TDocumentApproving;

      procedure SetDocumentApprovingByIndex(
        Index: Integer;
        DocumentApproving: TDocumentApproving
      );

    public

      procedure Add(DocumentApproving: TDocumentApproving);
      
      procedure InsertDocumentApproving(
        const Index: Integer;
        DocumentApproving: TDocumentApproving
      );

      function First: TDocumentApproving;
      function Last: TDocumentApproving;

      function AddApprovingFor(Employee: TEmployee): TDocumentApproving;
      procedure RemoveApprovingFor(Employee: TEmployee);
      procedure RemoveByIdentity(const Identity: Variant);
      procedure RemoveAll;

      function FetchApprovers: TEmployees;
      
      function AllApprovingsPerformed: Boolean;
      function IsEmployeeAssignedAsApprover(Employee: TEmployee): Boolean;
      function IsEmployeeActuallyPerformedApproving(Employee: TEmployee): Boolean;
      function FindByIdentity(const Identity: Variant): TDocumentApproving;
      function FindByApprover(Approver: TEmployee): TDocumentApproving;
      function FindByApprovers(Approvers: TEmployees): TDocumentApprovings;
      function FindByActuallyPerformedEmployee(Employee: TEmployee): TDocumentApproving;
      function GetEnumerator: TDocumentApprovingsEnumerator;

      property Items[Index: Integer]: TDocumentApproving
      read GetDocumentApprovingByIndex
      write SetDocumentApprovingByIndex; default;
    
  end;

  THistoricalDocumentApprovings = class (TDocumentApprovings)

    private

      function GetHistoricalDocumentApprovingByIndex(
        Index: Integer
      ): THistoricalDocumentApproving;

      procedure SetHistoricalDocumentApprovingByIndex(
        Index: Integer;
        HistoricalDocumentApproving: THistoricalDocumentApproving
      );

    public

      function FindByApprovingCycleId(
        const ApprovingCycleId: Variant
      ): THistoricalDocumentApprovings;
    
      function GetEnumerator: THistoricalDocumentApprovingsEnumerator;

      property Items[Index: Integer]: THistoricalDocumentApproving
      read GetHistoricalDocumentApprovingByIndex
      write SetHistoricalDocumentApprovingByIndex; default;
    
  end;

implementation

uses

  Variants,
  DomainObjectBaseUnit,
  StrUtils;
  
{ TDocumentApproving }

procedure TDocumentApproving.SetActuallyPerformedEmployeeId(const Value: Variant);
begin

  FActuallyPerformedEmployeeId := Value;
  
end;

constructor TDocumentApproving.Create;
begin

  inherited;

  FActuallyPerformedEmployeeId := Null;
  FPerformingDateTime := Null;
  FPerformingResult := prNotPerformed;
  
end;

destructor TDocumentApproving.Destroy;
begin

  inherited;

end;

function TDocumentApproving.GetActuallyPerformedEmployeeId: Variant;
begin

  Result := FActuallyPerformedEmployeeId;
  
end;

function TDocumentApproving.GetApprover: TEmployee;
begin

  Result := FApprover;

end;

function TDocumentApproving.GetDocumentId: Variant;
begin

  Result := FDocumentId;
  
end;

function TDocumentApproving.GetIsPerformed: Boolean;
begin

  Result := not VarIsNull(FPerformingDateTime) and
            not VarIsEmpty(FPerformingDateTime) and
            (FPerformingResult <> prNotPerformed);
            
end;

function TDocumentApproving.GetNote: String;
begin

  Result := FNote;

end;

function TDocumentApproving.GetPerformingDateTime: Variant;
begin

  Result := FPerformingDateTime;

end;

function TDocumentApproving.GetPerformingResult: TDocumentApprovingPerformingResult;
begin

  Result := FPerformingResult;
  
end;

function TDocumentApproving.GetPerformingResultName: String;
begin

  case PerformingResult of

    prApproved: Result := 'Согласовано';
    prRejected: Result := 'Не согласовано';
    prNotPerformed: Result := 'Не выполнено';

  end;
  
end;

function TDocumentApproving.InternalClone: TObject;
begin

  Result := inherited InternalClone;

  with TDocumentApproving(Result) do begin

    InvariantsComplianceRequested := False;

    PerformingResult := Self.PerformingResult;
    
    InvariantsComplianceRequested :=  True;

  end;

end;

procedure TDocumentApproving.MarkAsApprovedBy(
  ActuallyApprovedEmployee: TEmployee;
  const Note: String
);
begin

  RaiseExceptionIfAlreadyPerformed;

  { Refactor: Note }
  MarkAsPerformedBy(
    ActuallyApprovedEmployee,
    prApproved,
    ifThen(Trim(FNote) <> '', FNote, Note)
  );

end;

procedure TDocumentApproving.MarkAsPerformedBy(
  PerformedEmployee: TEmployee;
  PerformingResult: TDocumentApprovingPerformingResult;
  const Note: String
);
begin

  if Assigned(PerformedEmployee) then
    FActuallyPerformedEmployeeId := PerformedEmployee.Identity

  else FActuallyPerformedEmployeeId := Null;
  
  FPerformingResult := PerformingResult;
  FPerformingDateTime := Now;
  FNote := Note;

end;

procedure TDocumentApproving.MarkAsRejectedIfNotPerformed(
  const Reason: String
);
begin

  if not IsPerformed then
    MarkAsPerformedBy(nil, prRejected, Reason);
  
end;

procedure TDocumentApproving.MarkAsRejectedBy(
  ActuallyRejectedEmployee: TEmployee;
  const Reason: String
);
var RealReson: String;
begin

  RaiseExceptionIfAlreadyPerformed;

  if (Trim(Reason) = '') and (Trim(FNote) = '') then
    raise TDocumentApprovingException.Create(
            'Неуказана причина ' +
            'отклонения согласования'
          );

  MarkAsPerformedBy(
    ActuallyRejectedEmployee,
    prRejected,
    IfThen(Trim(Reason) = '', FNote, Reason)
  );

end;

procedure TDocumentApproving.RaiseExceptionIfAlreadyPerformed;
begin

  if IsPerformed then
    raise TDocumentApprovingException.Create(
            'Нельзя выполнять ' +
            'повторное согласование'
          );
          
end;

procedure TDocumentApproving.SetApprover(const Value: TEmployee);
begin

  FApprover := Value;
  FFreeApprover := FApprover;

end;

procedure TDocumentApproving.SetPerformingDateTime(const Value: Variant);
begin

  if InvariantsComplianceRequested then
    raise TDocumentApprovingException.Create(
            'Дата выполнения согласования ' +
            'не может устанавливаться ' +
            'непосредственно'
          );

  if not (VarIsNull(Value) or VarIsEmpty(Value) or VarIsType(Value, varDate))
  then
    raise TDocumentApprovingException.Create(
            'Дата согласования представлена ' +
            'некорректным типом данных'
          );

  FPerformingDateTime := Value;
  
end;

procedure TDocumentApproving.SetPerformingResult(
  const Value: TDocumentApprovingPerformingResult
);
begin

  if InvariantsComplianceRequested then
    raise TDocumentApprovingException.Create(
            'Результат согласования ' +
            'не может устанавливаться ' +
            'непосредственно'
          );

  FPerformingResult := Value;
  
end;

procedure TDocumentApproving.SetDocumentId(const Value: Variant);
begin

  FDocumentId := Value;
  
end;

procedure TDocumentApproving.SetNote(const Value: String);
begin
  {
  if InvariantsComplianceRequested then
    raise Exception.Create(
            'Замечания для согласования ' +
            'не могут устанавливаться ' +
            'непосредственно'
          ); }

  FNote := Value;
  
end;

{ TDocumentApprovings }

procedure TDocumentApprovings.Add(DocumentApproving: TDocumentApproving);
begin

  AddDomainObject(DocumentApproving);
  
end;

function TDocumentApprovings.AddApprovingFor(Employee: TEmployee): TDocumentApproving;
begin

  if Assigned(FindByApprover(Employee)) then
    raise TDocumentApprovingException.CreateFmt(
            'Сотрудник "%s" уже ' +
            'уже назначен для согласования ' +
            'документа',
            [Employee.FullName]
          );

  Result := TDocumentApproving.Create;

  Result.Approver := Employee;

  AddDomainObject(Result);
  
end;

function TDocumentApprovings.AllApprovingsPerformed: Boolean;
var DocumentApproving: TDocumentApproving;
begin

  for DocumentApproving in Self do
    if not DocumentApproving.IsPerformed then begin

      Result := False;
      Exit;
      
    end;

  Result := True;

end;

function TDocumentApprovings.FetchApprovers: TEmployees;
var
    DocumentApproving: TDocumentApproving;
begin

  Result := TEmployees.Create;

  try

    for DocumentApproving in Self do
      Result.Add(DocumentApproving.Approver);

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TDocumentApprovings.FindByActuallyPerformedEmployee(
  Employee: TEmployee
): TDocumentApproving;
begin

  for Result in Self do
    if Result.ActuallyPerformedEmployeeId = Employee.Identity then
      Exit;

  Result := nil;

end;

function TDocumentApprovings.FindByApprover(
  Approver: TEmployee): TDocumentApproving;
begin

  for Result in Self do
    if Result.Approver.IsSameAs(Approver) then
      Exit;

  Result := nil;

end;

function TDocumentApprovings.FindByApprovers(
  Approvers: TEmployees
): TDocumentApprovings;
var
    Approver: TEmployee;
begin

  Result := TDocumentApprovings.Create;

  try
  
    for Approver in Approvers do
      Result.Add(FindByApprover(Approver));
      
  except

    FreeAndNil(Result);

    Raise;
    
  end;
  
end;

function TDocumentApprovings.FindByIdentity(
  const Identity: Variant): TDocumentApproving;
begin

  Result := inherited FindByIdentity(Identity) as TDocumentApproving;
  
end;

function TDocumentApprovings.First: TDocumentApproving;
begin

  Result := inherited First as TDocumentApproving;
  
end;

function TDocumentApprovings.GetDocumentApprovingByIndex(
  Index: Integer): TDocumentApproving;
begin

  Result := GetDomainObjectByIndex(Index) as TDocumentApproving;
  
end;

function TDocumentApprovings.GetEnumerator: TDocumentApprovingsEnumerator;
begin

  Result := TDocumentApprovingsEnumerator.Create(Self);
  
end;

procedure TDocumentApprovings.InsertDocumentApproving(
  const Index: Integer;
  DocumentApproving: TDocumentApproving
);
begin

  InsertDomainObject(Index, DocumentApproving);
  
end;

function TDocumentApprovings.IsEmployeeActuallyPerformedApproving(
  Employee: TEmployee
): Boolean;
var DocumentApproving: TDocumentApproving;
begin

  DocumentApproving := FindByActuallyPerformedEmployee(Employee);

  Result := Assigned(DocumentApproving) and DocumentApproving.IsPerformed;

end;

function TDocumentApprovings.IsEmployeeAssignedAsApprover(
  Employee: TEmployee): Boolean;
var DocumentApproving: TDocumentApproving;
begin

  DocumentApproving := FindByApprover(Employee);

  Result := Assigned(DocumentApproving);
  
end;

function TDocumentApprovings.Last: TDocumentApproving;
begin

  Result := inherited Last as TDocumentApproving;
  
end;

procedure TDocumentApprovings.RemoveApprovingFor(Employee: TEmployee);
var DocumentApproving: TDocumentApproving;
begin

  DocumentApproving := FindByApprover(Employee);

  if Assigned(DocumentApproving) then
    DeleteDomainObject(DocumentApproving);
  
end;

procedure TDocumentApprovings.RemoveAll;
begin

  Clear;
  
end;

procedure TDocumentApprovings.RemoveByIdentity(const Identity: Variant);
begin

  DeleteDomainObjectByIdentity(Identity);
  
end;

procedure TDocumentApprovings.SetDocumentApprovingByIndex(
  Index: Integer;
  DocumentApproving: TDocumentApproving
);
begin

  SetDomainObjectByIndex(Index, DocumentApproving);
  
end;

{ TDocumentApprovingsEnumerator }

constructor TDocumentApprovingsEnumerator.Create(
  DocumentApprovings: TDocumentApprovings);
begin

  inherited Create(DocumentApprovings);
  
end;

function TDocumentApprovingsEnumerator.GetCurrentDocumentApproving: TDocumentApproving;
begin

  Result := GetCurrentDomainObject as TDocumentApproving;

end;

{ THistoricalDocumentApproving }

constructor THistoricalDocumentApproving.Create(
  OriginalApproving: TDocumentApproving; const ApprovingCycleId: Variant);
begin

  inherited Create;

  FApprovingCycleId := ApprovingCycleId;
  Self.OriginalApproving := OriginalApproving;
  
end;

function THistoricalDocumentApproving.GetActuallyPerformedEmployeeId: Variant;
begin

  Result := FOriginalApproving.GetActuallyPerformedEmployeeId;
  
end;

function THistoricalDocumentApproving.GetApprover: TEmployee;
begin

  Result := FOriginalApproving.GetApprover;

end;

function THistoricalDocumentApproving.GetDocumentId: Variant;
begin

  Result := FOriginalApproving.GetDocumentId;
  
end;

function THistoricalDocumentApproving.GetIdentity: Variant;
begin

  Result := FOriginalApproving.Identity;
  
end;

function THistoricalDocumentApproving.GetIsPerformed: Boolean;
begin

  Result := FOriginalApproving.GetIsPerformed;
  
end;

function THistoricalDocumentApproving.GetNote: String;
begin

  Result := FOriginalApproving.GetNote;
  
end;

function THistoricalDocumentApproving.GetPerformingDateTime: Variant;
begin

  Result := FOriginalApproving.GetPerformingDateTime;
  
end;

function THistoricalDocumentApproving.GetPerformingResult: TDocumentApprovingPerformingResult;
begin

  Result := FOriginalApproving.GetPerformingResult;

end;

procedure THistoricalDocumentApproving.SetActuallyPerformedEmployeeId(
  const Value: Variant);
begin

  FOriginalApproving.SetActuallyPerformedEmployeeId(Value);

end;

procedure THistoricalDocumentApproving.SetApprover(const Value: TEmployee);
begin

  FOriginalApproving.SetApprover(Value);

end;

procedure THistoricalDocumentApproving.SetDocumentId(const Value: Variant);
begin

  FOriginalApproving.SetDocumentId(Value);

end;

procedure THistoricalDocumentApproving.SetIdentity(Identity: Variant);
begin

  FOriginalApproving.SetIdentity(Identity);

end;

procedure THistoricalDocumentApproving.SetInvariantsComplianceRequested(
  const Value: Boolean);
begin

  if Assigned(FOriginalApproving) then
    FOriginalApproving.InvariantsComplianceRequested := Value;

end;

procedure THistoricalDocumentApproving.SetNote(const Value: String);
begin

  FOriginalApproving.SetNote(Value);

end;

procedure THistoricalDocumentApproving.SetOriginalApproving(
  Value: TDocumentApproving);
begin

  if not Assigned(Value) then
    raise TDocumentApprovingException.Create(
            'Попытка создания ' +
            'объекта хранения истории ' +
            'о единичном согласовании документа из ' +
            'отсутствующих данных'
          );
          
  FOriginalApproving := Value;
  FFreeOriginalApproving := FOriginalApproving;
  FOriginalApproving.InvariantsComplianceRequested :=
    InvariantsComplianceRequested;
  
end;

procedure THistoricalDocumentApproving.SetPerformingDateTime(const Value: Variant);
begin

  FOriginalApproving.SetPerformingDateTime(Value);
  
end;

procedure THistoricalDocumentApproving.SetPerformingResult(
  const Value: TDocumentApprovingPerformingResult);
begin

  FOriginalApproving.SetPerformingResult(Value);

end;

{ THistoricalDocumentApprovingsEnumerator }

constructor THistoricalDocumentApprovingsEnumerator.Create(
  HistoricalDocumentApprovings: THistoricalDocumentApprovings);
begin

  inherited Create(HistoricalDocumentApprovings);
  
end;

function THistoricalDocumentApprovingsEnumerator.GetCurrentHistoricalDocumentApproving: THistoricalDocumentApproving;
begin

  Result := GetCurrentDocumentApproving as THistoricalDocumentApproving;

end;

{ THistoricalDocumentApprovings }

function THistoricalDocumentApprovings.
FindByApprovingCycleId(
    const ApprovingCycleId: Variant
    ): THistoricalDocumentApprovings;
begin

end;

function THistoricalDocumentApprovings.GetEnumerator: THistoricalDocumentApprovingsEnumerator;
begin

  Result := THistoricalDocumentApprovingsEnumerator.Create(Self);
  
end;

function THistoricalDocumentApprovings.
  GetHistoricalDocumentApprovingByIndex(
    Index: Integer
  ): THistoricalDocumentApproving;
begin

  Result := GetDocumentApprovingByIndex(Index) as THistoricalDocumentApproving;

end;

procedure THistoricalDocumentApprovings.SetHistoricalDocumentApprovingByIndex(
  Index: Integer;
  HistoricalDocumentApproving: THistoricalDocumentApproving
);
begin

  SetDocumentApprovingByIndex(
    Index, HistoricalDocumentApproving
  );
  
end;

end.
