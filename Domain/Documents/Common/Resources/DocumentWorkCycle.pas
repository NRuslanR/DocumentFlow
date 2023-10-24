unit DocumentWorkCycle;

interface

uses

  Classes,
  DomainException,
  DomainObjectUnit,
  DomainObjectListUnit,
  IDomainObjectBaseUnit,
  DomainObjectValueUnit;

type

  TDocumentWorkCycleStageProperty =

    (
      StageNumberProperty,
      StageNameProperty
    );
    
  TDocumentWorkCycleStageValues = array of Variant;

  TDocumentWorkCycleStage = class;
  TDocumentWorkCycleStageClass = class of TDocumentWorkCycleStage;

  TDocumentWorkCycleStage = class (TDomainObject)

    protected

      FDocumentKindId: Variant;
      FNumber: Integer;
      FName: String;
      FServiceName: String;

      class function GetClassType: TDocumentWorkCycleStageClass; virtual;

      function GetDocumentKindId: Variant;
      procedure SetDocumentKindId(const Value: Variant);

      function GetNumber: Integer;
      procedure SetNumber(const Number: Integer);

      function GetName: string;
      procedure SetName(const Name: String);

      function GetServiceName: String;
      procedure SetServiceName(const Value: String);

      constructor Create; overload; virtual;
      constructor Create(
        const Number: Integer; const Name: String
      ); overload; virtual;

      function GetIsStageOfDocumentCreated: Boolean;
      function GetIsStageOfDocumentApproving: Boolean;
      function GetIsStageOfDocumentApproved: Boolean;
      function GetIsStageOfDocumentNotApproved: Boolean;
      function GetIsStageOfDocumentSigning: Boolean;
      function GetIsStageOfDocumentSigned: Boolean;
      function GetIsStageOfDocumentSigningRejected: Boolean;
      function GetIsStageOfDocumentPerformed: Boolean;
      function GetIsStageOfDocumentPerforming: Boolean;

    published

      property DocumentKindId: Variant
      read GetDocumentKindId write SetDocumentKindId;

      property Number: Integer read GetNumber write SetNumber;
      property Name: String read GetName write SetName;
      property ServiceName: String read GetServiceName write SetServiceName;

      property IsStageOfDocumentCreated: Boolean
      read GetIsStageOfDocumentCreated;

      property IsStageOfDocumentApproving: Boolean
      read GetIsStageOfDocumentApproving;

      property IsStageOfDocumentApproved: Boolean
      read GetIsStageOfDocumentApproved;

      property IsStageOfDocumentNotApproved: Boolean
      read GetIsStageOfDocumentNotApproved;

      property IsStageOfDocumentSigning: Boolean
      read GetIsStageOfDocumentSigning;

      property IsStageOfDocumentSigned: Boolean
      read GetIsStageOfDocumentSigned;

      property IsStageOfDocumentSigningRejected: Boolean
      read GetIsStageOfDocumentSigningRejected;

      property IsStageOfDocumentPerforming: Boolean
      read GetIsStageOfDocumentPerforming;

      property IsStageOfDocumentPerformed: Boolean
      read GetIsStageOfDocumentPerformed;
      
  end;

  TDocumentWorkCycleStages = class;

  TDocumentWorkCycleStageEnumerator = class (TDomainObjectListEnumerator)

    protected

      function GetCurrentDocumentWorkCycleStage: TDocumentWorkCycleStage; virtual;

    public

      constructor Create(DocumentWorkCycleStages: TDocumentWorkCycleStages);

      property Current: TDocumentWorkCycleStage
      read GetCurrentDocumentWorkCycleStage;
      
  end;

  TDocumentWorkCycleStages = class (TDomainObjectList)

    protected

      function GetDocumentWorkCycleStageByIndex(
        Index: Integer
      ): TDocumentWorkCycleStage; virtual;

      procedure SetDocumentWorkCycleStageByIndex(
        Index: Integer;
        DocumentWorkCycleStage: TDocumentWorkCycleStage
      ); virtual;

    public

      function First: TDocumentWorkCycleStage;
      function Last: TDocumentWorkCycleStage;
      
      procedure AddStage(const StageNumber: Integer; const StageName: String); overload;

      function FindStageByNumber(const Number: Integer): TDocumentWorkCycleStage;
      function FindStageByName(const Name: String): TDocumentWorkCycleStage;

      function GetStageIndexBy(
        const StageProperty: TDocumentWorkCycleStageProperty;
        const PropertyValue: Variant
      ): Integer;

      procedure RemoveStageByNumber(const Number: Integer);
      procedure RemoveStageByName(const Name: String);

      procedure RemoveStageBy(
        const StageProperty: TDocumentWorkCycleStageProperty;
        const PropertyValue: Variant
      );

      function Add(Stage: TDocumentWorkCycleStage): Integer;

      property Items[Index: Integer]: TDocumentWorkCycleStage
      read GetDocumentWorkCycleStageByIndex
      write SetDocumentWorkCycleStageByIndex; default;

      function GetEnumerator: TDocumentWorkCycleStageEnumerator;

  end;

  TDocumentWorkCycleException = class (TDomainException)

  end;
  
  TDocumentWorkCycle = class (TDomainObjectValue)

    protected

      FStages: TDocumentWorkCycleStages;
      FCurrentStageIndex: Integer;
      FPreviousStageIndex: Integer;

      function GetDocumentWorkCycleStageByIndex(
        Index: Integer
      ): TDocumentWorkCycleStage;

      procedure RaiseExceptionIfStagesAreAbsent;
      procedure RaiseExceptionIfNextStageIsNotExistsForCurrentStage;
      procedure RaiseExceptionIfPrecedingStageIsNotExistsForCurrentStage;
      procedure RaiseExceptionIfPreviousStageIsNotExistsForCurrentStage;

      function IsCurrentStageIndexValid: Boolean;
      function GetCurrentStage: TDocumentWorkCycleStage;
      function GetStageCount: Integer;

      function GetStageOfDocumentCreated: TDocumentWorkCycleStage;
      function GetStageOfDocumentApproving: TDocumentWorkCycleStage;
      function GetStageOfDocumentApproved: TDocumentWorkCycleStage;
      function GetStageOfDocumentNotApproved: TDocumentWorkCycleStage;
      function GetStageOfDocumentPerformed: TDocumentWorkCycleStage;
      function GetStageOfDocumentPerforming: TDocumentWorkCycleStage;
      function GetStageOfDocumentSigning: TDocumentWorkCycleStage;
      function GetStageOfDocumentSigned: TDocumentWorkCycleStage;
      function GetStageOfDocumentSigningRejected: TDocumentWorkCycleStage;

      function GetDocumentWorkCycleStageClass: TDocumentWorkCycleStageClass; virtual;

      procedure RaiseTransitionToNonExistStageException(
        const ErrorMessage: String;
        const Args: array of const
      );

    protected

      function IsStageOfDocumentCreatedRequired: Boolean; virtual;
      function IsStageOfDocumentApprovingRequired: Boolean; virtual;
      function IsStageOfDocumentApprovedRequired: Boolean; virtual;
      function IsStageOfDocumentNotApprovedRequired: Boolean; virtual;
      function IsStageOfDocumentPerformedRequired: Boolean; virtual;
      function IsStageOfDocumentPerformingRequired: Boolean; virtual;
      function IsStageOfDocumentSigningRequired: Boolean; virtual;
      function IsStageOfDocumentSignedRequired: Boolean; virtual;
      function IsStageOfDocumentSigningRejectedRequired: Boolean; virtual;

    public

      constructor Create(Stages: TDocumentWorkCycleStages);
      
      destructor Destroy; override;

      function FindStageByNumber(const Number: Integer): TDocumentWorkCycleStage;
      function FindStageByName(const Name: String): TDocumentWorkCycleStage;

      function IsStagePrecededForCurrent(Stage: TDocumentWorkCycleStage): Boolean; overload;
      function IsStagePrecededForCurrent(const StageNumber: Integer): Boolean; overload;

      function IsCurrentStage(Stage: TDocumentWorkCycleStage): Boolean; overload;
      function IsCurrentStage(const StageNumber: Integer): Boolean; overload;

      function IsStageOfDocumentCreatedCurrent: Boolean;
      function IsStageOfDocumentApprovingCurrent: Boolean;
      function IsStageOfDocumentApprovedCurrent: Boolean;
      function IsStageOfDocumentNotApprovedCurrent: Boolean;
      function IsStageOfDocumentSigningCurrent: Boolean;
      function IsStageOfDocumentSignedCurrent: Boolean;
      function IsStageOfDocumentSigningRejectedCurrent: Boolean;
      function IsStageOfDocumentPerformingCurrent: Boolean;
      function IsStageOfDocumentPerformedCurrent: Boolean;
      function IsCurrentStageTheStart: Boolean;
      function IsCurrentStageTheLast: Boolean;
      function IsCurrentStageBetween(BeginStage, EndStage: TDocumentWorkCycleStage): Boolean;
      function ToStartStage: TDocumentWorkCycleStage;
      function ToLastStage: TDocumentWorkCycleStage;
      function ToNextStage: TDocumentWorkCycleStage;
      function ToPrecedingStage: TDocumentWorkCycleStage;
      function ToPreviousStage: TDocumentWorkCycleStage;
      
      function ToStageOfDocumentCreated: TDocumentWorkCycleStage;
      function ToStageOfDocumentApproving: TDocumentWorkCycleStage;
      function ToStageOfDocumentApproved: TDocumentWorkCycleStage;
      function ToStageOfDocumentNotApproved: TDocumentWorkCycleStage;
      function ToStageOfDocumentSigning: TDocumentWorkCycleStage;
      function ToStageOfDocumentSigned: TDocumentWorkCycleStage;
      function ToStageOfDocumentSigningRejected: TDocumentWorkCycleStage;
      function ToStageOfDocumentPerforming: TDocumentWorkCycleStage;
      function ToStageOfDocumentPerformed: TDocumentWorkCycleStage;
      
      procedure ToSpecifiedStage(const StageNumber: Integer); overload;
      procedure ToSpecifiedStage(const StageName: String); overload;

      function GetEnumerator: TDocumentWorkCycleStageEnumerator;

      property Stages[Index: Integer]: TDocumentWorkCycleStage
      read GetDocumentWorkCycleStageByIndex; default;

      property StageOfDocumentCreated: TDocumentWorkCycleStage
      read GetStageOfDocumentCreated;

      property StageOfDocumentApproving: TDocumentWorkCycleStage
      read GetStageOfDocumentApproving;

      property StageOfDocumentApproved: TDocumentWorkCycleStage
      read GetStageOfDocumentApproved;

      property StageOfDocumentNotApproved: TDocumentWorkCycleStage
      read GetStageOfDocumentNotApproved;
      
      property StageOfDocumentSigning: TDocumentWorkCycleStage
      read GetStageOfDocumentSigning;

      property StageOfDocumentSigned: TDocumentWorkCycleStage
      read GetStageOfDocumentSigned;
      
      property StageOfDocumentSigningRejected: TDocumentWorkCycleStage
      read GetStageOfDocumentSigningRejected;

      property StageOfDocumentPerforming: TDocumentWorkCycleStage
      read GetStageOfDocumentPerforming;

      property StageOfDocumentPerformed: TDocumentWorkCycleStage
      read GetStageOfDocumentPerformed;

    published

      property CurrentStage: TDocumentWorkCycleStage read GetCurrentStage;

      property StageCount: Integer read GetStageCount;
      
  end;

  TDocumentWorkCycleClass = class of TDocumentWorkCycle;

implementation

uses SysUtils, Math, AuxDebugFunctionsUnit;

{ TDocumentWorkCycleStage }

constructor TDocumentWorkCycleStage.Create;
begin

  inherited;

end;

constructor TDocumentWorkCycleStage.Create(
  const Number: Integer;
  const Name: String
);
begin

  inherited Create;

  SetNumber(Number);
  SetName(Name);

end;

class function TDocumentWorkCycleStage.GetClassType:
  TDocumentWorkCycleStageClass;
begin

  Result := TDocumentWorkCycleStage;

end;

function TDocumentWorkCycleStage.GetDocumentKindId: Variant;
begin

  Result := FDocumentKindId;
  
end;

function TDocumentWorkCycleStage.GetIsStageOfDocumentApproved: Boolean;
var NumberOfStageOfDocumentApproved: Integer;
    NameOfStageOfDocumentApproved: String;
begin

  Result := ServiceName = 'Approved';

end;

function TDocumentWorkCycleStage.GetIsStageOfDocumentApproving: Boolean;
var NumberOfStageOfDocumentApproving: Integer;
    NameOfStageOfDocumentApproving: String;
begin

  Result := ServiceName = 'IsApproving';
    
end;

function TDocumentWorkCycleStage.GetIsStageOfDocumentCreated: Boolean;
var NumberOfStageOfDocumentCreated: Integer;
    NameOfStageOfDocumentCreated: String;
begin

  Result := ServiceName = 'Created';

end;

function TDocumentWorkCycleStage.GetIsStageOfDocumentNotApproved: Boolean;
var NumberOfStageOfDocumentNotApproved: Integer;
    NameOfStageOfDocumentNotApproved: String;
begin

  Result := ServiceName = 'NotApproved';

end;

function TDocumentWorkCycleStage.GetIsStageOfDocumentPerformed: Boolean;
var NumberOfStageOfDocumentPerformed: Integer;
    NameOfStageOfDocumentPerformed: String;
begin

  Result := ServiceName = 'Performed';

end;

function TDocumentWorkCycleStage.GetIsStageOfDocumentPerforming: Boolean;
var NumberOfStageOfDocumentPerforming: Integer;
    NameOfStageOfDocumentPerforming: String;
begin

  Result := ServiceName = 'IsPerforming';

end;

function TDocumentWorkCycleStage.GetIsStageOfDocumentSigned: Boolean;
var NumberOfStageOfDocumentSigning: Integer;
    NameOfStageOfDocumentSigning: String;
begin

  Result := ServiceName = 'Signed';

end;

function TDocumentWorkCycleStage.GetIsStageOfDocumentSigning: Boolean;
var NumberOfStageOfDocumentSigning: Integer;
    NameOfStageOfDocumentSigning: String;
begin

  Result := ServiceName = 'IsSigning';

end;

function TDocumentWorkCycleStage.GetIsStageOfDocumentSigningRejected: Boolean;
var NumberOfStageOfDocumentSigningRejected: Integer;
    NameOfStageOfDocumentSigningRejected: String;
begin

  Result := ServiceName = 'SigningRejected';

end;

function TDocumentWorkCycleStage.GetName: string;
begin

  Result := FName;

end;

function TDocumentWorkCycleStage.GetNumber: Integer;
begin

  Result := FNumber;

end;

function TDocumentWorkCycleStage.GetServiceName: String;
begin

  Result := FServiceName;

end;

procedure TDocumentWorkCycleStage.SetDocumentKindId(const Value: Variant);
begin

  FDocumentKindId := Value;
  
end;

procedure TDocumentWorkCycleStage.SetName(const Name: String);
begin

  FName := Name;
  
end;

procedure TDocumentWorkCycleStage.SetNumber(const Number: Integer);
begin

  FNumber := Number;
  
end;

procedure TDocumentWorkCycleStage.SetServiceName(const Value: String);
begin

  FServiceName := Value;

end;

{ TDocumentWorkCycleStageEnumerator }

constructor TDocumentWorkCycleStageEnumerator.Create(
  DocumentWorkCycleStages: TDocumentWorkCycleStages
);
begin

  inherited Create(DocumentWorkCycleStages);
  
end;

function TDocumentWorkCycleStageEnumerator.GetCurrentDocumentWorkCycleStage: TDocumentWorkCycleStage;
begin

  Result := TDocumentWorkCycleStage(GetCurrentDomainObject);

end;

{ TDocumentWorkCycleStages }

function TDocumentWorkCycleStages.Add(Stage: TDocumentWorkCycleStage): Integer;
begin

  AddDomainObject(Stage);
  
end;

procedure TDocumentWorkCycleStages.AddStage(
  const StageNumber: Integer;
  const StageName: String
);
begin

  AddDomainObject(TDocumentWorkCycleStage.Create(StageNumber, StageName));

end;

function TDocumentWorkCycleStages.GetDocumentWorkCycleStageByIndex(
  Index: Integer
): TDocumentWorkCycleStage;
begin

  Result := TDocumentWorkCycleStage(GetDomainObjectByIndex(index));
  
end;

function TDocumentWorkCycleStages.GetEnumerator: TDocumentWorkCycleStageEnumerator;
begin

  Result := TDocumentWorkCycleStageEnumerator.Create(Self);

end;

procedure TDocumentWorkCycleStages.SetDocumentWorkCycleStageByIndex(
  Index: Integer;
  DocumentWorkCycleStage: TDocumentWorkCycleStage
);
begin

  SetDomainObjectByIndex(index, DocumentWorkCycleStage);
  
end;

procedure TDocumentWorkCycleStages.RemoveStageBy(
  const StageProperty: TDocumentWorkCycleStageProperty;
  const PropertyValue: Variant
);
var
    RemovableStageIndex: Integer;
begin

  RemovableStageIndex := GetStageIndexBy(StageProperty, PropertyValue);

  if RemovableStageIndex = -1 then Exit;

  DeleteDomainObjectEntryByIndex(RemovableStageIndex);

end;

procedure TDocumentWorkCycleStages.RemoveStageByName(const Name: String);
begin

  RemoveStageBy(StageNameProperty, Name);

end;

procedure TDocumentWorkCycleStages.RemoveStageByNumber(const Number: Integer);
begin

  RemoveStageBy(StageNumberProperty, Number);

end;

function TDocumentWorkCycleStages.GetStageIndexBy(
  const StageProperty: TDocumentWorkCycleStageProperty;
  const PropertyValue: Variant
): Integer;
var Stage: TDocumentWorkCycleStage;
    SuccessfulSearch: Boolean;
begin

  for Result := 0 to Count - 1 do begin

    Stage := Self[Result];

    case StageProperty of

      StageNumberProperty:

        SuccessfulSearch := Stage.Number = PropertyValue;

      StageNameProperty:

        SuccessfulSearch := Stage.Name = PropertyValue;

    end;

    if SuccessfulSearch then Exit;

  end;

  Result := -1;

end;

function TDocumentWorkCycleStages.FindStageByName(
  const Name: String): TDocumentWorkCycleStage;
var StageIndex: Integer;
begin

  StageIndex := GetStageIndexBy(StageNameProperty, Name);

  if StageIndex = -1 then
    Result := nil

  else Result := Self[StageIndex];

end;

function TDocumentWorkCycleStages.FindStageByNumber(
  const Number: Integer): TDocumentWorkCycleStage;
var StageIndex: Integer;
begin

  StageIndex := GetStageIndexBy(StageNumberProperty, Number);

  if StageIndex = -1 then
    Result := nil

  else Result := Self[StageIndex];

end;

function TDocumentWorkCycleStages.First: TDocumentWorkCycleStage;
begin

  Result := TDocumentWorkCycleStage(inherited First);
  
end;

function TDocumentWorkCycleStages.Last: TDocumentWorkCycleStage;
begin

  Result := TDocumentWorkCycleStage(inherited Last);

end;

{ TDocumentWorkCycle }

constructor TDocumentWorkCycle.Create(Stages: TDocumentWorkCycleStages);
begin

  if not Assigned(Stages) then begin

    raise TDocumentWorkCycleException.Create(
      'ѕрограммна€ ошибка. ѕопытка создани€ ' +
      'рабочего цикла документа без стадий'
    );
    
  end;

  inherited Create;

  FStages := Stages;

  ToStartStage;
  
end;

destructor TDocumentWorkCycle.Destroy;
begin

  FreeAndNil(FStages);

  inherited;
  
end;

function TDocumentWorkCycle.FindStageByName(
  const Name: String
): TDocumentWorkCycleStage;
begin

  Result := FStages.FindStageByName(Name);

end;

function TDocumentWorkCycle.FindStageByNumber(
  const Number: Integer): TDocumentWorkCycleStage;
begin

  Result := FStages.FindStageByNumber(Number);
  
end;

function TDocumentWorkCycle.GetCurrentStage: TDocumentWorkCycleStage;
begin

  if not IsCurrentStageIndexValid then
    Result := nil

  else Result := FStages[FCurrentStageIndex];
  
end;

function TDocumentWorkCycle.GetDocumentWorkCycleStageByIndex(
  Index: Integer
): TDocumentWorkCycleStage;
begin

  Result := FStages.GetDocumentWorkCycleStageByIndex(Index);

end;

function TDocumentWorkCycle.GetDocumentWorkCycleStageClass: TDocumentWorkCycleStageClass;
begin

  Result := TDocumentWorkCycleStage;
  
end;

function TDocumentWorkCycle.GetEnumerator: TDocumentWorkCycleStageEnumerator;
begin

  Result := FStages.GetEnumerator;
  
end;

function TDocumentWorkCycle.GetStageCount: Integer;
begin

  Result := FStages.Count;
  
end;

function TDocumentWorkCycle.GetStageOfDocumentApproved: TDocumentWorkCycleStage;
begin

  for Result in Self do
    if Result.IsStageOfDocumentApproved then
      Exit;

  Result := nil;

end;

function TDocumentWorkCycle.GetStageOfDocumentApproving: TDocumentWorkCycleStage;
begin

  for Result in Self do
    if Result.IsStageOfDocumentApproving then
      Exit;

  Result := nil;

end;

function TDocumentWorkCycle.GetStageOfDocumentCreated: TDocumentWorkCycleStage;
begin

  for Result in Self do
    if Result.IsStageOfDocumentCreated then
      Exit;
    
  Result := nil;
  
end;

function TDocumentWorkCycle.GetStageOfDocumentNotApproved: TDocumentWorkCycleStage;
begin

  for Result in Self do
    if Result.IsStageOfDocumentNotApproved then
      Exit;

  Result := nil;
    
end;

function TDocumentWorkCycle.GetStageOfDocumentPerformed: TDocumentWorkCycleStage;
begin

  for Result in Self do begin

    if Result.IsStageOfDocumentPerformed then
      Exit;

  end;
  
  Result := nil;
    
end;

function TDocumentWorkCycle.GetStageOfDocumentPerforming: TDocumentWorkCycleStage;
begin
  
  for Result in Self do
    if Result.IsStageOfDocumentPerforming then
      Exit;

  Result := nil;
  
end;

function TDocumentWorkCycle.GetStageOfDocumentSigned: TDocumentWorkCycleStage;
begin

  for Result in Self do
    if Result.IsStageOfDocumentSigned then
      Exit;

  Result := nil;
  
end;

function TDocumentWorkCycle.GetStageOfDocumentSigning: TDocumentWorkCycleStage;
begin

  for Result in Self do
    if Result.IsStageOfDocumentSigning then
      Exit;

  Result := nil;

end;

function TDocumentWorkCycle.GetStageOfDocumentSigningRejected: TDocumentWorkCycleStage;
begin

  for Result in Self do
    if Result.IsStageOfDocumentSigningRejected then
      Exit;

  Result := nil;
    
end;

function TDocumentWorkCycle.IsCurrentStage(const StageNumber: Integer): Boolean;
begin

  Result := CurrentStage.Number = StageNumber;
  
end;

function TDocumentWorkCycle.IsCurrentStageBetween(
  BeginStage, EndStage: TDocumentWorkCycleStage
): Boolean;
begin

  if Assigned(BeginStage) and Assigned(EndStage) then begin

    Result := (CurrentStage.Number >= BeginStage.Number) and
              (CurrentStage.Number <= EndStage.Number);

  end

  else if Assigned(BeginStage) then begin

    Result := CurrentStage.Number >= BeginStage.Number

  end

  else Result := CurrentStage.Number <= EndStage.Number;

end;

function TDocumentWorkCycle.IsCurrentStage(
  Stage: TDocumentWorkCycleStage
): Boolean;
begin

  Result := Assigned(Stage) and IsCurrentStage(Stage.Number);
  
end;

function TDocumentWorkCycle.IsCurrentStageIndexValid: Boolean;
begin

  Result := Assigned(FStages) and
            (FCurrentStageIndex >= 0) and
            (FCurrentStageIndex < FStages.Count);
            
end;

function TDocumentWorkCycle.IsCurrentStageTheLast: Boolean;
begin

  Result := CurrentStage.Equals(StageOfDocumentPerformed);
  
end;

function TDocumentWorkCycle.IsCurrentStageTheStart: Boolean;
begin

  Result := CurrentStage.Equals(StageOfDocumentCreated);
  
end;

function TDocumentWorkCycle.IsStagePrecededForCurrent(
  Stage: TDocumentWorkCycleStage): Boolean;
begin

  Result := IsStagePrecededForCurrent(Stage.Number);
  
end;

function TDocumentWorkCycle.IsStageOfDocumentApprovedCurrent: Boolean;
begin

  Result := IsCurrentStage(StageOfDocumentApproved);
  
end;

function TDocumentWorkCycle.IsStageOfDocumentApprovedRequired: Boolean;
begin

  Result := True;

end;

function TDocumentWorkCycle.IsStageOfDocumentApprovingCurrent: Boolean;
begin

  Result := IsCurrentStage(StageOfDocumentApproving);
  
end;

function TDocumentWorkCycle.IsStageOfDocumentApprovingRequired: Boolean;
begin

  Result := True;

end;

function TDocumentWorkCycle.IsStageOfDocumentCreatedCurrent: Boolean;
begin

  Result := IsCurrentStage(StageOfDocumentCreated);
  
end;

function TDocumentWorkCycle.IsStageOfDocumentCreatedRequired: Boolean;
begin

  Result := True;

end;

function TDocumentWorkCycle.IsStageOfDocumentNotApprovedCurrent: Boolean;
begin

  Result := IsCurrentStage(StageOfDocumentNotApproved);
  
end;

function TDocumentWorkCycle.IsStageOfDocumentNotApprovedRequired: Boolean;
begin

  Result := True;

end;

function TDocumentWorkCycle.IsStageOfDocumentPerformedCurrent: Boolean;
begin

  Result := IsCurrentStage(StageOfDocumentPerformed);

end;

function TDocumentWorkCycle.IsStageOfDocumentPerformedRequired: Boolean;
begin

  Result := True;

end;

function TDocumentWorkCycle.IsStageOfDocumentPerformingCurrent: Boolean;
begin

  Result := IsCurrentStage(StageOfDocumentPerforming);
  
end;

function TDocumentWorkCycle.IsStageOfDocumentPerformingRequired: Boolean;
begin

  Result := True;

end;

function TDocumentWorkCycle.IsStageOfDocumentSignedCurrent: Boolean;
begin

  Result := IsCurrentStage(StageOfDocumentSigned);
  
end;

function TDocumentWorkCycle.IsStageOfDocumentSignedRequired: Boolean;
begin

  Result := True;
  
end;

function TDocumentWorkCycle.IsStageOfDocumentSigningCurrent: Boolean;
begin

  Result := IsCurrentStage(StageOfDocumentSigning);
  
end;

function TDocumentWorkCycle.IsStageOfDocumentSigningRejectedCurrent: Boolean;
begin

  Result := IsCurrentStage(StageOfDocumentSigningRejected);
  
end;

function TDocumentWorkCycle.IsStageOfDocumentSigningRejectedRequired: Boolean;
begin

  Result := True;

end;

function TDocumentWorkCycle.IsStageOfDocumentSigningRequired: Boolean;
begin

  Result := True;
  
end;

function TDocumentWorkCycle.IsStagePrecededForCurrent(
  const StageNumber: Integer): Boolean;
begin

  Result := StageNumber < CurrentStage.Number;
  
end;

procedure TDocumentWorkCycle.
  RaiseExceptionIfNextStageIsNotExistsForCurrentStage;
begin

  RaiseExceptionIfStagesAreAbsent;
  
  if (FCurrentStageIndex + 1) = FStages.Count then
    raise TDocumentWorkCycleException.CreateFmt(
            'For stage with number %d next stage is not exists',
            [FCurrentStageIndex]
          );
  
end;

procedure TDocumentWorkCycle.RaiseExceptionIfPrecedingStageIsNotExistsForCurrentStage;
begin

  RaiseExceptionIfStagesAreAbsent;
  
  if (FCurrentStageIndex - 1) < 0 then
    raise TDocumentWorkCycleException.Create(
            'Attempt to access the stage preceding to first stage'
          );

end;

procedure TDocumentWorkCycle.RaiseExceptionIfPreviousStageIsNotExistsForCurrentStage;
begin

  RaiseExceptionIfStagesAreAbsent;

  if FPreviousStageIndex = -1 then begin

    raise TDocumentWorkCycleException.CreateFmt(
      'ƒл€ стадии "%s" рабочего цикла документа ' +
      'не обнаружена предыдуща€ стади€',
      [CurrentStage.Name]
    );

  end;

end;

procedure TDocumentWorkCycle.RaiseExceptionIfStagesAreAbsent;
begin

  if FStages.Count = 0 then
    raise TDocumentWorkCycleException.Create('Document work cycle stages are absent');

end;

procedure TDocumentWorkCycle.RaiseTransitionToNonExistStageException(
  const ErrorMessage: String; const Args: array of const);
begin

  Raise TDocumentWorkCycleException.CreateFmt(ErrorMessage, Args);

end;

procedure TDocumentWorkCycle.ToSpecifiedStage(const StageNumber: Integer);
var FoundStageIndex: Integer;
begin

  FoundStageIndex :=
    FStages.GetStageIndexBy(
      StageNumberProperty,
      StageNumber
    );
  
  if FoundStageIndex = -1 then begin

    RaiseTransitionToNonExistStageException(
      '—тади€ документа с номером %d не существует',
      [StageNumber]
    );

  end;

  FCurrentStageIndex := FoundStageIndex;
  
end;

procedure TDocumentWorkCycle.ToSpecifiedStage(const StageName: String);
var FoundStageIndex: Integer;
begin

  FoundStageIndex :=
    FStages.GetStageIndexBy(
      StageNameProperty,
      StageName
    );

  if FoundStageIndex = -1 then begin

    RaiseTransitionToNonExistStageException(
      '—тади€ "%s" не существует дл€ данного документа',
      [StageName]
    );

  end;

  FCurrentStageIndex := FoundStageIndex;

end;

function TDocumentWorkCycle.ToStageOfDocumentApproved: TDocumentWorkCycleStage;
var StageOfDocumentApproved: TDocumentWorkCycleStage;
begin

  StageOfDocumentApproved := GetStageOfDocumentApproved;

  if Assigned(StageOfDocumentApproved) then
    ToSpecifiedStage(StageOfDocumentApproved.Number)

  else if IsStageOfDocumentApprovingRequired then begin

    RaiseTransitionToNonExistStageException(
      '¬ рабочем цикле данного вида документов ' +
      'отсутствует этап "согласован"',
      []
    );

  end;

  Result := CurrentStage;

end;

function TDocumentWorkCycle.ToStageOfDocumentApproving: TDocumentWorkCycleStage;
var StageOfDocumentApproving: TDocumentWorkCycleStage;
begin

  StageOfDocumentApproving := GetStageOfDocumentApproving;

  if Assigned(StageOfDocumentApproving) then
    ToSpecifiedStage(StageOfDocumentApproving.Number)

  else if IsStageOfDocumentApprovingRequired then begin

    RaiseTransitionToNonExistStageException(
      '¬ рабочем цикле данного вида документов ' +
      'отсутствует этап "согласование"',
      []
    );

  end;

  Result := CurrentStage;
  
end;

function TDocumentWorkCycle.ToStageOfDocumentCreated: TDocumentWorkCycleStage;
var StageOfDocumentCreated: TDocumentWorkCycleStage;
begin

  StageOfDocumentCreated := GetStageOfDocumentCreated;

  if Assigned(StageOfDocumentCreated) then
    ToSpecifiedStage(StageOfDocumentCreated.Number)

  else if IsStageOfDocumentCreatedRequired then begin

    RaiseTransitionToNonExistStageException(
      '¬ рабочем цикле данного вида документов ' +
      'отсутствует этап "создан"',
      []
    );

  end;

  Result := CurrentStage;

end;

function TDocumentWorkCycle.ToStageOfDocumentNotApproved: TDocumentWorkCycleStage;
var StageOfDocumentNotApproved: TDocumentWorkCycleStage;
begin

  StageOfDocumentNotApproved := GetStageOfDocumentNotApproved;

  if Assigned(StageOfDocumentNotApproved) then
    ToSpecifiedStage(StageOfDocumentNotApproved.Number)

  else if IsStageOfDocumentNotApprovedRequired then begin

    RaiseTransitionToNonExistStageException(
      '¬ рабочем цикле данного вида документов ' +
      'отсутствует этап "не согласован"',
      []
    );

  end;


  Result := CurrentStage;
  
end;

function TDocumentWorkCycle.ToStageOfDocumentPerformed: TDocumentWorkCycleStage;
var StageOfDocumentPerformed: TDocumentWorkCycleStage;
begin

  StageOfDocumentPerformed := GetStageOfDocumentPerformed;

  if Assigned(StageOfDocumentPerformed) then
    ToSpecifiedStage(StageOfDocumentPerformed.Number)

  else if IsStageOfDocumentPerformedRequired then begin

    RaiseTransitionToNonExistStageException(
      '¬ рабочем цикле данного вида документов ' +
      'отсутствует этап "исполнен"',
      []
    );

  end;

  Result := CurrentStage;

end;

function TDocumentWorkCycle.ToStageOfDocumentPerforming: TDocumentWorkCycleStage;
var StageOfDocumentPerforming: TDocumentWorkCycleStage;
begin

  StageOfDocumentPerforming := GetStageOfDocumentPerforming;

  if Assigned(StageOfDocumentPerforming) then
    ToSpecifiedStage(StageOfDocumentPerforming.Number)

  else if IsStageOfDocumentPerformingRequired then begin

    RaiseTransitionToNonExistStageException(
      '¬ рабочем цикле данного вида документов ' +
      'отсутствует этап "на исполнении"',
      []
    );

  end;

  Result := CurrentStage;

end;

function TDocumentWorkCycle.ToStageOfDocumentSigned: TDocumentWorkCycleStage;
var
    StageOfDocumentSigned: TDocumentWorkCycleStage;
begin

  StageOfDocumentSigned := GetStageOfDocumentSigned;

  if Assigned(StageOfDocumentSigned) then
    ToSpecifiedStage(StageOfDocumentSigned.Number)

  else if IsStageOfDocumentSignedRequired then begin

    RaiseTransitionToNonExistStageException(
      '¬ рабочем цикле данного вида документов ' +
      'отсутствует этап "подписан"',
      []
    );

  end;

  Result := CurrentStage;
  
end;

function TDocumentWorkCycle.ToStageOfDocumentSigning: TDocumentWorkCycleStage;
var StageOfDocumentSigning: TDocumentWorkCycleStage;
begin

  StageOfDocumentSigning := GetStageOfDocumentSigning;

  if Assigned(StageOfDocumentSigning) then
    ToSpecifiedStage(StageOfDocumentSigning.Number)

  else if IsStageOfDocumentSigningRequired then begin

    RaiseTransitionToNonExistStageException(
      '¬ рабочем цикле данного вида документов ' +
      'отсутствует этап "на подписании"',
      []
    );

  end;

  Result := CurrentStage;

end;

function TDocumentWorkCycle.ToStageOfDocumentSigningRejected: TDocumentWorkCycleStage;
var StageOfDocumentSigningRejected: TDocumentWorkCycleStage;
begin

  StageOfDocumentSigningRejected := GetStageOfDocumentSigningRejected;

  if Assigned(StageOfDocumentSigningRejected) then
    ToSpecifiedStage(StageOfDocumentSigningRejected.Number)

  else if IsStageOfDocumentSigningRejectedRequired then begin

    RaiseTransitionToNonExistStageException(
      '¬ рабочем цикле данного вида документов ' +
      'отсутствует этап "отклонен от подписани€"',
      []
    );

  end;

  Result := CurrentStage;
  
end;

function TDocumentWorkCycle.ToStartStage: TDocumentWorkCycleStage;
begin

  RaiseExceptionIfStagesAreAbsent;

  FCurrentStageIndex := 0;
  FPreviousStageIndex := -1;

  Result := CurrentStage;

end;

function TDocumentWorkCycle.ToLastStage: TDocumentWorkCycleStage;
begin

  RaiseExceptionIfStagesAreAbsent;
  
  FCurrentStageIndex := FStages.Count - 1;

  Result := CurrentStage;
  
end;

function TDocumentWorkCycle.ToNextStage: TDocumentWorkCycleStage;
begin

  RaiseExceptionIfNextStageIsNotExistsForCurrentStage;

  FCurrentStageIndex := FCurrentStageIndex + 1;

  Result := CurrentStage;

end;

function TDocumentWorkCycle.ToPrecedingStage: TDocumentWorkCycleStage;
begin

  RaiseExceptionIfPrecedingStageIsNotExistsForCurrentStage;

  FCurrentStageIndex := FCurrentStageIndex - 1;

  Result := CurrentStage;

end;

function TDocumentWorkCycle.ToPreviousStage: TDocumentWorkCycleStage;
var OldCurrentStageIndex: Integer;
begin

  RaiseExceptionIfPreviousStageIsNotExistsForCurrentStage;

  OldCurrentStageIndex := FCurrentStageIndex;

  FCurrentStageIndex := FPreviousStageIndex;

  FPreviousStageIndex := OldCurrentStageIndex;

  Result := CurrentStage;

end;

end.
