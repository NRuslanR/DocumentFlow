unit DocumentCharges;

interface

uses

  DomainException,
  DomainObjectUnit,
  DomainObjectValueUnit,
  IDomainObjectBaseUnit,
  DomainObjectListUnit,
  DocumentChargeInterface,
  DocumentChargeWorkingRules,
  Employee,
  TimeFrame,
  Disposable,
  VariantListUnit,
  SysUtils,
  Classes,
  DateUtils;
  
type

  TDocumentChargeException = class (TDomainException)

  end;

  TDocumentCharge = class;
  
  TDocumentChargeClass = class of TDocumentCharge;

  TDocumentCharge = class (TDomainObject, IDocumentCharge)

    private

      FreeTimeFrame: IDomainObjectBase;
      FreePerformer: IDomainObjectBase;
      FreeActuallyPerformedEmployee: IDomainObjectBase;
      
      function GetActuallyPerformedEmployeePropName: String;
      function GetChargeTextPropName: String;
      function GetDocumentIdPropName: String;
      function GetPerformerPropName: String;
      function GetPerformingDateTimePropName: String;
      function GetResponsePropName: String;
      function GetTimeFrameDeadlinePropName: String;
      function GetTimeFrameStartPropName: String;
      function GetIsForAcquaitancePropName: String;

    protected

      procedure SetInvariantsComplianceRequested(const Value: Boolean); override;

      procedure RaiseExceptionIfAlreadyPerformed;
      
    protected                                                   

      FDocumentId: Variant;

      FKindId: Variant;
      FKindName: String;
      FServiceKindName: String;

      FIsForAcquaitance: Boolean;
      
      FPerformer: TEmployee;
      FActuallyPerformedEmployee: TEmployee;
      FTimeFrame: TTimeFrame;

      FChargeText: String;
      FResponse: String;

      FPerformingDateTime: Variant;

      FWorkingRules: TDocumentChargeWorkingRules;
      FFreeWorkingRules: IDisposable;

      FEditingEmployee: TEmployee;

      procedure AssignPerformer(Employee: TEmployee);
      procedure AssignTimeFrame(TimeFrame: TTimeFrame);
      
      procedure AssignActuallyPerformedEmployee(
        Employee: TEmployee
      );

    public
    
      function GetActuallyPerformedEmployee: TEmployee;
      function GetIsPerformed: Boolean;
      function GetIsRequired: Boolean;
      function GetPerformer: TEmployee;
      function GetTimeFrameDeadline: Variant;
      function GetTimeFrameStart: Variant;
      function GetPerformingDateTime: Variant;
      function GetChargeText: String;
      function GetResponse: String;
      function GetDocumentId: Variant;
      function GetKindId: Variant;
      function GetKindName: String;
      function GetServiceKindName: String;
      function GetIsForAcquaitance: Boolean;

      procedure SetDocumentId(const Value: Variant);
      procedure SetPerformer(const Value: TEmployee);
      procedure SetPerformingDateTime(const Value: Variant);
      procedure SetChargeText(const Value: String);
      procedure SetResponse(const Value: String);
      procedure SetActuallyPerformedEmployee(const Value: TEmployee);
      procedure SetTimeFrameDeadline(const Value: Variant);
      procedure SetTimeFrameStart(const Value: Variant);
      procedure SetKindId(const Value: Variant);
      procedure SetKindName(const Value: String);
      procedure SetServiceKindName(const Value: String);
      procedure SetIsForAcquaitance(const Value: Boolean);
      procedure SetWorkingRules(const Value: TDocumentChargeWorkingRules);

    public

      constructor Create; overload; override;

      constructor Create(
        Performer: TEmployee;
        WorkingRules: TDocumentChargeWorkingRules
      ); overload;

      class function ChargeSheetType: TClass; virtual;
      
      procedure SetTimeFrameStartAndDeadline(
        const TimeFrameStart, TimeFrameDeadline: TDateTime
      );

      procedure MarkAsPerformedBy(
        ActuallyPerformedEmployee: TEmployee;
        const PerformingDateTime: TDateTime = 0
      ); overload;

      procedure MarkAsPerformedBy(OtherCharge: IDocumentCharge); overload; virtual;

      procedure Assign(OtherCharge: IDocumentCharge);
      
      procedure MarkAsNonRequired;

      function IsTimeFrameExpired: Boolean;

    public

      property WorkingRules: TDocumentChargeWorkingRules
      read FWorkingRules write SetWorkingRules;

    public

      property DocumentIdPropName: String
      read GetDocumentIdPropName;

      property PerformerPropName: String
      read GetPerformerPropName;

      property ActuallyPerformedEmployeePropName: String
      read GetActuallyPerformedEmployeePropName;

      property PerformingDateTimePropName: String
      read GetPerformingDateTimePropName;

      property TimeFrameStartPropName: String
      read GetTimeFrameStartPropName;

      property TimeFrameDeadlinePropName: String
      read GetTimeFrameDeadlinePropName;

      property ChargeTextPropName: String
      read GetChargeTextPropName;

      property ResponsePropName: String
      read GetResponsePropName;

      property IsForAcquaitancePropName: String
      read GetIsForAcquaitancePropName;
      
    published

      property KindId: Variant
      read GetKindId write SetKindId;

      property KindName: String
      read GetKindName write SetKindName;

      property ServiceKindName: String
      read GetServiceKindName write SetServiceKindName;
      
      property DocumentId: Variant
      read GetDocumentId write SetDocumentId;

      property Performer: TEmployee
      read GetPerformer write SetPerformer;

      property ActuallyPerformedEmployee: TEmployee
      read GetActuallyPerformedEmployee
      write SetActuallyPerformedEmployee;

      property PerformingDateTime: Variant
      read GetPerformingDateTime write SetPerformingDateTime;

      property TimeFrameStart: Variant
      read GetTimeFrameStart write SetTimeFrameStart;
      
      property TimeFrameDeadline: Variant
      read GetTimeFrameDeadline write SetTimeFrameDeadline;
      
      property ChargeText: String
      read GetChargeText write SetChargeText;
      
      property Response: String
      read GetResponse write SetResponse;

      property IsPerformed: Boolean read GetIsPerformed;

      property IsRequired: Boolean read GetIsRequired;

      property IsForAcquaitance: Boolean
      read GetIsForAcquaitance write SetIsForAcquaitance;

    public

      function ClassType: TDocumentChargeClass;

  end;

  TDocumentCharges = class (TDomainObjectList, IDocumentCharges)

    private

    protected

    public

      function Contains(Performer: TEmployee): Boolean;

      function First: IDocumentCharge;
      function Last: IDocumentCharge;

      procedure AddCharge(Charge: IDocumentCharge); overload;
      procedure ChangeCharge(Charge: IDocumentCharge);
      procedure MarkChargeAsPerformedBy(OtherCharge: IDocumentCharge);
      
      function GetDocumentChargeByIndex(Index: Integer): IDocumentCharge;
      procedure SetDocumentChargeByIndex(
        Index: Integer;
        DocumentCharge: IDocumentCharge
      );
      
      function FindByIdentity(const Identity: Variant): IDocumentCharge;
      function FindByIdentities(const Identities: TVariantList): IDocumentCharges;

      function FindByIdentitiesOrRaise(
        const Identities: TVariantList;
        const NotFoundMessage: String = ''
      ): IDocumentCharges;

      procedure RemoveChargeFor(Employee: TEmployee);
      procedure RemoveAllCharges;

      function IsEmpty: Boolean;
      
      function AreAllChargesPerformed: Boolean;
      function IsEmployeeAssignedAsPerformer(Employee: TEmployee): Boolean;
      function IsEmployeeActuallyPerformed(Employee: TEmployee): Boolean;
      
      function GetEnumerator: TDocumentChargesEnumerator;

      function FindDocumentChargeByPerformerOrActuallyPerformedEmployee(Employee: TEmployee): IDocumentCharge;

      function Count: Integer;
      
      property Items[Index: Integer]: IDocumentCharge
      read GetDocumentChargeByIndex
      write SetDocumentChargeByIndex; default;

  end;

  TDocumentChargesClass = class of TDocumentCharges;

implementation

uses

  Variants,
  StrUtils,
  VariantFunctions,
  DomainObjectBaseUnit,
  DocumentChargeSheet,
  DocumentAcquaitance;

{ TDocumentCharge }

procedure TDocumentCharge.Assign(OtherCharge: IDocumentCharge);
var
    Charge: TDocumentCharge;
begin

  RaiseConditionalExceptionIfInvariantsComplianceRequested(
    not Assigned(OtherCharge.Performer),
    TDocumentChargeException,
    'Не указан исполнитель во время изменения поручения'
  );
  
  Charge := OtherCharge.Self as TDocumentCharge;

  AssignTimeFrame(Charge.FTimeFrame);
  AssignActuallyPerformedEmployee(Charge.ActuallyPerformedEmployee);

  FPerformingDateTime := Charge.PerformingDateTime;
  FResponse := Charge.Response;
  FChargeText := Charge.ChargeText;
  FIsForAcquaitance := Charge.IsForAcquaitance;
  
end;

procedure TDocumentCharge.AssignActuallyPerformedEmployee(Employee: TEmployee);
begin

  FActuallyPerformedEmployee := Employee;
  FreeActuallyPerformedEmployee := FActuallyPerformedEmployee;

end;

procedure TDocumentCharge.AssignPerformer(Employee: TEmployee);
begin

  FPerformer := Employee;
  FreePerformer := FPerformer;
  
end;

procedure TDocumentCharge.AssignTimeFrame(TimeFrame: TTimeFrame);
begin

  FTimeFrame := TimeFrame;
  FreeTimeFrame := FTimeFrame;
  
end;

constructor TDocumentCharge.Create(
  Performer: TEmployee;
  WorkingRules: TDocumentChargeWorkingRules
);
begin

  if not Assigned(Performer) then
    Raise TDocumentChargeException.Create('Во время создания поручения не указан исполнитель');

  if not Assigned(WorkingRules) then
    Raise TDocumentChargeException.Create('Во время создания поручения не были указаны рабочие правила');

  Create;

  AssignPerformer(Performer);

  Self.WorkingRules := WorkingRules;

end;

constructor TDocumentCharge.Create;
begin

  inherited;

  FPerformingDateTime := Null;
  
end;

function TDocumentCharge.GetActuallyPerformedEmployee: TEmployee;
begin

  Result := FActuallyPerformedEmployee;
  
end;

function TDocumentCharge.GetActuallyPerformedEmployeePropName: String;
begin

  ActuallyPerformedEmployee;

  Result := 'ActuallyPerformedEmployee';
  
end;

function TDocumentCharge.GetChargeText: String;
begin

  Result := FChargeText;
  
end;

function TDocumentCharge.GetChargeTextPropName: String;
begin

  ChargeText;

  Result := 'ChargeText';

end;

function TDocumentCharge.GetDocumentId: Variant;
begin

  Result := FDocumentId;
  
end;

function TDocumentCharge.GetDocumentIdPropName: String;
begin

  DocumentId;

  Result := 'DocumentId';
  
end;

function TDocumentCharge.GetIsForAcquaitance: Boolean;
begin

  Result := FIsForAcquaitance;
  
end;

function TDocumentCharge.GetIsForAcquaitancePropName: String;
begin

  IsForAcquaitance;

  Result := 'IsForAcquaitance';
  
end;

function TDocumentCharge.GetIsPerformed: Boolean;
begin

  Result :=
    Assigned(ActuallyPerformedEmployee)
    and not VarIsNull(PerformingDateTime);

end;

function TDocumentCharge.GetIsRequired: Boolean;
begin

  Result := Assigned(FTimeFrame);
  
end;

function TDocumentCharge.GetKindId: Variant;
begin

  Result := FKindId;

end;

function TDocumentCharge.GetKindName: String;
begin

  Result := FKindName;
  
end;

function TDocumentCharge.GetPerformer: TEmployee;
begin

  Result := FPerformer;
  
end;

function TDocumentCharge.GetPerformerPropName: String;
begin

  Performer;

  Result := 'Performer';
  
end;

function TDocumentCharge.GetPerformingDateTime: Variant;
begin

  Result := FPerformingDateTime;
  
end;

function TDocumentCharge.GetPerformingDateTimePropName: String;
begin

  PerformingDateTime;

  Result := 'PerformingDateTime';

end;

function TDocumentCharge.GetResponse: String;
begin

  Result := FResponse;
  
end;

function TDocumentCharge.GetResponsePropName: String;
begin

  Response;

  Result := 'Response';
  
end;

function TDocumentCharge.GetServiceKindName: String;
begin

  Result := FServiceKindName;

end;

function TDocumentCharge.GetTimeFrameDeadline: Variant;
begin

  if Assigned(FTimeFrame) then
    Result := FTimeFrame.Deadline

  else Result := Null;
  
end;

function TDocumentCharge.GetTimeFrameDeadlinePropName: String;
begin

  TimeFrameDeadline;

  Result := 'TimeFrameDeadline';

end;

function TDocumentCharge.GetTimeFrameStart: Variant;
begin

  if Assigned(FTimeFrame) then
    Result := FTimeFrame.Start

  else Result := Null;
  
end;

function TDocumentCharge.GetTimeFrameStartPropName: String;
begin

  TimeFrameStart;

  Result := 'TimeFrameStart';
  
end;

function TDocumentCharge.IsTimeFrameExpired: Boolean;
begin

  Result := Assigned(FTimeFrame) and FTimeFrame.IsExpired;
  
end;

procedure TDocumentCharge.MarkAsNonRequired;
begin

  FreeAndNil(FTimeFrame);
  
end;

procedure TDocumentCharge.MarkAsPerformedBy(OtherCharge: IDocumentCharge);
begin

  RaiseExceptionIfAlreadyPerformed;

  RaiseConditionalExceptionIfInvariantsComplianceRequested(
    not OtherCharge.IsPerformed,
    TDocumentChargeException,
    'Попытка выполнить поручение на основании невыполненного'
  );

  RaiseConditionalExceptionIfInvariantsComplianceRequested(
    not Performer.IsSameAs(OtherCharge.Performer),
    TDocumentChargeException,
    'Сотрудник "%s" не является исполнителем ' +
    'поручения для сотрудника "%s"',
    [
      OtherCharge.Performer.FullName,
      Performer.FullName
    ]
  );

  RaiseConditionalExceptionIfInvariantsComplianceRequested(
    not Assigned(OtherCharge.ActuallyPerformedEmployee),
    TDocumentChargeException,
    'Не указан фактически выполнивший поручение сотрудник'
  );

  Assign(OtherCharge);

end;

procedure TDocumentCharge.MarkAsPerformedBy(
  ActuallyPerformedEmployee: TEmployee;
  const PerformingDateTime: TDateTime
);
begin

  RaiseExceptionIfAlreadyPerformed;

  AssignActuallyPerformedEmployee(ActuallyPerformedEmployee);

  FPerformingDateTime := VarIfThen(PerformingDateTime = 0, Now, PerformingDateTime);

end;

procedure TDocumentCharge.RaiseExceptionIfAlreadyPerformed;
begin

  if InvariantsComplianceRequested and IsPerformed then begin

    Raise TDocumentChargeException.CreateFmt(
      'Поручение для сотрудника "%s" ' +
      'уже выполнено',
      [
        Performer.FullName
      ]
    );
    
  end;

end;

procedure TDocumentCharge.SetActuallyPerformedEmployee(const Value: TEmployee);
begin

  if ActuallyPerformedEmployee = Value then Exit;
  
  RaiseExceptionIfInvariantsComplianceRequested(
    'Нельзя устанавливать фактически ' +
    'исполнившего поручение сотрудника ' +
    'непосредственно'
  );

  AssignActuallyPerformedEmployee(Value);

end;

procedure TDocumentCharge.SetChargeText(const Value: String);
begin

  RaiseExceptionIfAlreadyPerformed;

  FChargeText := Value;
  
end;

procedure TDocumentCharge.SetDocumentId(const Value: Variant);
begin

  if DocumentId = Value then Exit;

  RaiseConditionalExceptionIfInvariantsComplianceRequested(
    not VarIsNull(DocumentId),
    TDocumentChargeException,
    'Изменять документ поручения недопустимо'
  );

  FDocumentId := Value;

end;

procedure TDocumentCharge.SetInvariantsComplianceRequested(
  const Value: Boolean);
begin

  inherited SetInvariantsComplianceRequested(Value);
  
  if Assigned(FTimeFrame) then
    FTimeFrame.InvariantsComplianceRequested := Value;
    
end;

procedure TDocumentCharge.SetIsForAcquaitance(const Value: Boolean);
begin

  RaiseExceptionIfAlreadyPerformed;

  FIsForAcquaitance := Value;
  
end;

procedure TDocumentCharge.SetKindId(const Value: Variant);
begin

  if KindId = Value then Exit;
  
  RaiseExceptionIfInvariantsComplianceRequested(
    'Тип поручения не может устанавливаться непосредственно'
  );

  FKindId := Value;
  
end;

procedure TDocumentCharge.SetKindName(const Value: String);
begin

  if KindName = Value then Exit;
  
  RaiseExceptionIfInvariantsComplianceRequested(
    'Тип поручения не может устанавливаться непосредственно'
  );

  FKindName := Value;
  
end;

procedure TDocumentCharge.SetPerformer(const Value: TEmployee);
begin

  if Performer = Value then Exit;
  
  RaiseExceptionIfInvariantsComplianceRequested(
    'Исполнитель может устанавливаться только ' +
    'при создании поручения'
  );
  
  RaiseExceptionIfAlreadyPerformed;

  AssignPerformer(Value);
  
end;

procedure TDocumentCharge.SetPerformingDateTime(const Value: Variant);
begin

  if PerformingDateTime = Value then Exit;
  
  RaiseExceptionIfInvariantsComplianceRequested(
    TDocumentChargeException,
    'Дата выполнения поручения не может ' +
    'устанавливаться непосредственно'
  );

  if VarIsNull(Value) or VarIsEmpty(Value) then begin

    FPerformingDateTime := Value;
    Exit;
    
  end;

  if not VarIsType(Value, varDate) then begin

    raise TDocumentChargeException.Create(
      'Дата исполнения поручения должна иметь тип даты'
    );

  end;

  FPerformingDateTime := Value;
  
end;

procedure TDocumentCharge.SetResponse(const Value: String);
begin

  RaiseExceptionIfAlreadyPerformed;
  
  FResponse := Value;
  
end;

procedure TDocumentCharge.SetServiceKindName(const Value: String);
begin

  if ServiceKindName = Value then Exit;
  
  RaiseExceptionIfInvariantsComplianceRequested(
    TDocumentChargeException,
    'Служебное наименование типа поручения ' +
    'не может устанавливаться непосредственно'
  );

  FServiceKindName := Value;

end;

procedure TDocumentCharge.SetTimeFrameDeadline(const Value: Variant);
var
    NewDeadline: TDateTime;
begin

  if TimeFrameDeadline = Value then Exit;

  RaiseExceptionIfInvariantsComplianceRequested(
    TDocumentChargeException,
    'Срок окончания поручения ' +
    'не может устанавливаться ' +
    'непосредственно'
  );
  
  if VarIsNull(Value) then begin

    FreeAndNil(FTimeFrame);
    Exit;
    
  end;

  NewDeadline := Value;
  
  if not Assigned(FTimeFrame) then begin

    FTimeFrame := TTimeFrame.Create;
    FTimeFrame.InvariantsComplianceRequested :=
      InvariantsComplianceRequested;

  end;
  
  FTimeFrame.Deadline := NewDeadline;
  
end;

procedure TDocumentCharge.SetTimeFrameStart(const Value: Variant);
var
    NewStart: TDateTime;
begin

  if TimeFrameStart = Value then Exit;

  RaiseExceptionIfInvariantsComplianceRequested(
    TDocumentChargeException,
    'Срок начала поручения ' +
    'не может устанавливаться ' +
    'непосредственно'
  );

  if VarIsNull(Value) then  begin

    FreeAndNil(FTimeFrame);
    Exit;

  end;

  NewStart := Value;

  if not Assigned(FTimeFrame) then begin

    FTimeFrame := TTimeFrame.Create;
    FTimeFrame.InvariantsComplianceRequested :=
      InvariantsComplianceRequested;

  end;
  
  FTimeFrame.Start := NewStart;
  
end;

procedure TDocumentCharge.SetTimeFrameStartAndDeadline(const TimeFrameStart,
  TimeFrameDeadline: TDateTime);
begin

  RaiseExceptionIfAlreadyPerformed;
  
  if TimeFrameStart > TimeFrameDeadline then begin
  
    raise TDocumentChargeException.Create(
            'Указан некорректный срок исполнения поручения'
          );

  end;

  FreeAndNil(FTimeFrame);
  
  FTimeFrame := TTimeFrame.Create(TimeFrameStart, TimeFrameDeadline);

end;

procedure TDocumentCharge.SetWorkingRules(const Value: TDocumentChargeWorkingRules);
begin

  FWorkingRules := Value;
  FFreeWorkingRules := FWorkingRules;

end;

{ TDocumentCharges }

procedure TDocumentCharges.AddCharge(Charge: IDocumentCharge);
begin

  if Contains(Charge.Performer) then begin

    Raise TDocumentChargeException.CreateFmt(
      'Поручение для сотрудника "%s" уже назначено',
      [
        Charge.Performer.FullName
      ]
    );

  end;
  
  AddDomainObject(Charge.Self as TDocumentCharge);
  
end;

function TDocumentCharges.AreAllChargesPerformed: Boolean;
var DocumentCharge: IDocumentCharge;
begin

  for DocumentCharge in Self do begin

    if DocumentCharge.Self is TDocumentAcquaitance then Continue;
    
    if not DocumentCharge.IsPerformed then begin

      Result := False;
      Exit;
      
    end;

  end;

  Result := True;

end;

procedure TDocumentCharges.ChangeCharge(Charge: IDocumentCharge);
var
    TargetCharge: IDocumentCharge;
begin

  TargetCharge := FindDocumentChargeByPerformerOrActuallyPerformedEmployee(Charge.Performer);

  TargetCharge.Assign(Charge);
  
end;

class function TDocumentCharge.ChargeSheetType: TClass;
begin

  Result := TDocumentChargeSheet;
  
end;

function TDocumentCharge.ClassType: TDocumentChargeClass;
begin

  Result := TDocumentChargeClass(inherited ClassType);
  
end;

function TDocumentCharges.Contains(Performer: TEmployee): Boolean;
begin

  Result := Assigned(FindDocumentChargeByPerformerOrActuallyPerformedEmployee(Performer));

end;

function TDocumentCharges.Count: Integer;
begin

  Result := inherited Count;
  
end;

function TDocumentCharges.FindByIdentities(
  const Identities: TVariantList): IDocumentCharges;
var
    Charge: IDocumentCharge;
begin

  Result := TDocumentCharges.Create;
  
  for Charge in Self do
    if Identities.Contains(Charge.Identity) then
      Result.AddCharge(Charge);

end;

function TDocumentCharges.FindByIdentitiesOrRaise(
  const Identities: TVariantList;
  const NotFoundMessage: String): IDocumentCharges;
begin

  Result := FindByIdentities(Identities);

  try

    if Identities.Count <> Result.Count then begin

      raise TDomainException.Create(
        IfThen(
          NotFoundMessage <> '',
          NotFoundMessage,
          'Некоторые из запрошенных поручений ' +
          'не были найдены'
        )
      );

    end;

  except

    FreeAndNil(Result);

    Raise;

  end;
  
end;

function TDocumentCharges.FindByIdentity(
  const Identity: Variant): IDocumentCharge;
begin

  Result := inherited FindByIdentity(Identity) as TDocumentCharge;
  
end;

function TDocumentCharges.FindDocumentChargeByPerformerOrActuallyPerformedEmployee(
  Employee: TEmployee): IDocumentCharge;
var
    DocumentCharge: IDocumentCharge;
begin

  for DocumentCharge in Self do begin

    Result := DocumentCharge;
    
    if
      Result.Performer.IsSameAs(Employee)
      or
      (
        Assigned(Result.ActuallyPerformedEmployee)
        and Result.ActuallyPerformedEmployee.IsSameAs(Employee)
      )
          
    then Exit;

  end;

  Result := nil;
  
end;

function TDocumentCharges.First: IDocumentCharge;
var
    FirstCharge: TDomainObject;
begin

  FirstCharge := inherited First;

  Supports(FirstCharge, IDocumentCharge, Result);
  
end;

function TDocumentCharges.GetDocumentChargeByIndex(
  Index: Integer): IDocumentCharge;
begin

  Supports(GetDomainObjectByIndex(Index), IDocumentCharge, Result);
  
end;

function TDocumentCharges.GetEnumerator: TDocumentChargesEnumerator;
begin

  Result := TDocumentChargesEnumerator.Create(Self);
  
end;

function TDocumentCharges.IsEmployeeActuallyPerformed(
  Employee: TEmployee): Boolean;
var DocumentCharge: IDocumentCharge;
begin

  DocumentCharge :=
    FindDocumentChargeByPerformerOrActuallyPerformedEmployee(Employee);

  if not Assigned(DocumentCharge) then
    Result := False

  else Result := DocumentCharge.ActuallyPerformedEmployee.IsSameAs(Employee);
  
end;

function TDocumentCharges.IsEmployeeAssignedAsPerformer(
  Employee: TEmployee): Boolean;
var DocumentCharge: IDocumentCharge;
begin

  DocumentCharge :=
    FindDocumentChargeByPerformerOrActuallyPerformedEmployee(
      Employee
    );

  if not Assigned(DocumentCharge) then
    Result := False

  else Result := DocumentCharge.Performer.IsSameAs(Employee);
  
end;

function TDocumentCharges.IsEmpty: Boolean;
begin

  Result := Count = 0;
  
end;

function TDocumentCharges.Last: IDocumentCharge;
var
    LastCharge: TDomainObject;
begin

  LastCharge := inherited Last;

  Supports(LastCharge, IDocumentCharge, Result);
  
end;

procedure TDocumentCharges.MarkChargeAsPerformedBy(OtherCharge: IDocumentCharge);
var
    TargetCharge: IDocumentCharge;
begin

  TargetCharge := FindDocumentChargeByPerformerOrActuallyPerformedEmployee(OtherCharge.Performer);

  TargetCharge.MarkAsPerformedBy(OtherCharge);
  
end;

procedure TDocumentCharges.RemoveAllCharges;
begin

  Clear;
  
end;

procedure TDocumentCharges.RemoveChargeFor(Employee: TEmployee);
var DocumentCharge: IDocumentCharge;
    I: Integer;
begin

  for I := 0 to Self.Count - 1 do begin

    DocumentCharge := Self[I];

    if DocumentCharge.Performer.IsSameAs(Employee) then begin

      DeleteDomainObjectEntryByIndex(I);
      Exit;
      
    end;

  end;
  
end;

procedure TDocumentCharges.SetDocumentChargeByIndex(
  Index: Integer;
  DocumentCharge: IDocumentCharge
);
begin

  SetDomainObjectByIndex(Index, DocumentCharge.Self as TDocumentCharge);
  
end;

end.
