unit DocumentChargeSheet;

interface

uses

  DomainException,
  IDocumentChargeSheetUnit,
  DomainObjectUnit,
  DomainObjectListUnit,
  Employee,
  DocumentCharges,
  IDomainObjectBaseUnit,
  DocumentChargeSheetOverlappingPerformingService,
  DocumentChargeSheetWorkingRules,
  DocumentChargeSheetPerformingService,
  DocumentChargeSheetPerformingEnsurer,
  DocumentChargeSheetChangingEnsurer,
  ArrayFunctions,
  ArrayTypes,
  TimeFrame,
  SysUtils,
  Classes;

type

  TDocumentChargeSheet = class;
  TDocumentChargeSheetClass = class of TDocumentChargeSheet;

  TDocumentChargeSheets = class;
  TDocumentChargeSheetsClass = class of TDocumentChargeSheets;

  TDocumentChargeSheetException = class (TDomainException)

  end;

  TDocumentChargeSheetFieldNamesNotAccessibleException =
    class (TDocumentChargeSheetException)

      public

        RequestedFieldNames: TVariantArray;
        NotAccessbleFieldNames: TVariantArray;
        AccessibleFieldNames: TVariantArray;
        
        constructor Create(
          RequestedFieldNames: TVariantArray;
          NotAccessibleFieldNames: TVariantArray;
          const Msg: String;
          const Args: array of const
        );
        
    end;
  
  TDocumentChargeSheet = class (TDomainObject, IDocumentChargeSheet)

    private

      FreeIssuer: IDomainObjectBase;

      procedure Init; virtual;

    protected

      procedure SetInvariantsComplianceRequested(const Value: Boolean); override;

    protected

      procedure AssignIssuer(Issuer: TEmployee);
      
    protected

      FCharge: TDocumentCharge;
      FFreeCharge: IDomainObjectBase;

      FDocumentKindId: Variant; { refactor: возможно перенести в TDocumentCharge }

      FEditingEmployee: TEmployee;
      FIssuer: TEmployee;

      FIssuingDateTime: Variant;

      FTopLevelChargeSheetId: Variant;

      FChangingEnsurer: IDocumentChargeSheetChangingEnsurer;
      FPerformingEnsurer: IDocumentChargeSheetPerformingEnsurer;
      
      FWorkingRules: TDocumentChargeSheetWorkingRules;
      FFreeWorkingRules: IDocumentChargeSheetWorkingRules;

      procedure RaiseExceptionIfEditingEmployeeNotAssigned;
      procedure RaiseExceptionIfWorkingRulesNotAssigned;
      procedure RaiseExceptionIfEditingEmployeeAndWorkingRulesNotAssigned;
      procedure RaiseExceptionIfChangingEnsurerNotAssigned;
      procedure RaiseExceptionIfPerformingEnsurerNotAssigned;

      procedure EnsureThatEmployeeMayMakeChangesForThisChargeSheet(
        Employee: TEmployee;
        FieldNames: array of Variant
      );

      procedure EnsureThatThisChargeSheetMayBePerformedByOverlappingChargeSheet(
        OverlappingChargeSheet: IDocumentChargeSheet
      );

      procedure EnsureEmployeeMayDoPerforming(
        Employee: TEmployee
      );

    public

      function GetCharge: TDocumentCharge;

      function GetIssuer: TEmployee;
      procedure SetIssuer(
        Issuer: TEmployee
      );

      function GetKindId: Variant;
      procedure SetKindId(const Value: Variant);

      function GetKindName: String;
      procedure SetKindName(const Value: String);

      function GetServiceKindName: String;
      procedure SetServiceKindName(const Value: String);

      function GetChargeText: String;
      procedure SetChargeText(const ChargeText: String);

      function GetTimeFrameStart: Variant;
      procedure SetTimeFrameStart(const Value: Variant);

      function GetTimeFrameDeadline: Variant;
      procedure SetTimeFrameDeadline(const Value: Variant);
      
      function GetPerformer: TEmployee;
      procedure SetPerformer(Performer: TEmployee);

      function GetPerformerResponse: String;
      procedure SetPerformerResponse(const Value: String);

      function GetActuallyPerformedEmployee: TEmployee;
      procedure SetActuallyPerformedEmployee(const Value: TEmployee);

      function GetDocumentId: Variant;
      procedure SetDocumentId(const DocumentId: Variant);

      function GetDocumentKindId: Variant;
      procedure SetDocumentKindId(const Value: Variant);

      function GetTopLevelChargeSheetId: Variant;
      procedure SetTopLevelChargeSheetId(const TopLevelChargeSheetId: Variant);

      function GetIsForAcquaitance: Boolean;
      procedure SetIsForAcquaitance(const Value: Boolean);

      function GetPerformingDateTime: Variant;
      procedure SetPerformingDateTime(const Value: Variant);

      function GetIssuingDateTime: Variant;
      procedure SetIssuingDateTime(const Value: Variant);

      function GetIsHead: Boolean;
      function GetIsPerformed: Boolean;
      function GetIsTimeFrameExpired: Boolean;

      function GetEditingEmployee: TEmployee;
      procedure SetEditingEmployee(EditingEmployee: TEmployee);

      function GetIsRequired: Boolean;
      
      procedure SetWorkingRules(Value: TDocumentChargeSheetWorkingRules);

      procedure SetChangingEnsurer(const Value: IDocumentChargeSheetChangingEnsurer);
      procedure SetPerformingEnsurer(const Value: IDocumentChargeSheetPerformingEnsurer);

    public

      constructor Create; overload; override;
      constructor Create(Charge: TDocumentCharge); overload;

      constructor Create(
        Charge: TDocumentCharge;
        Issuer: TEmployee;
        IssuingDateTime: TDateTime;
        WorkingRules: TDocumentChargeSheetWorkingRules
      ); overload;

      destructor Destroy; override;

      procedure SyncIdentityByChargeIdentity;
      
      procedure SetResponseBy(
        const Response: String;
        Performer: TEmployee
      );

      procedure EnsureBelongsToDocument(const DocumentId: Variant);
      
      procedure PerformBy(
        Performer: TEmployee;
        const PerformingDateTime: TDateTime = 0
      );

      procedure PerformAsOverlappedBy(
        OverlappingChargeSheet: IDocumentChargeSheet;
        ActualPerformer: TEmployee;
        const PerformingDateTime: TDateTime = 0
      );

      function PerformAsOverlappedIfPossible(
        OverlappingChargeSheet: IDocumentChargeSheet;
        ActualPerformer: TEmployee;
        const PerformingDateTime: TDateTime = 0
      ): Boolean;

      procedure MarkAsNonRequired;

      procedure SetTimeFrameStartAndDeadline(
        const TimeFrameStart, TimeFrameDeadline: TDateTime
      );
      
      property EditingEmployee: TEmployee
      read GetEditingEmployee write SetEditingEmployee;

      property ChangingEnsurer: IDocumentChargeSheetChangingEnsurer
      read FChangingEnsurer write SetChangingEnsurer;

      property PerformingEnsurer: IDocumentChargeSheetPerformingEnsurer
      read FPerformingEnsurer write SetPerformingEnsurer;
      
      property WorkingRules: TDocumentChargeSheetWorkingRules
      read FWorkingRules write SetWorkingRules;

      property Charge: TDocumentCharge read GetCharge;
      
    public

      function IssuerPropName: String;
      function ChargeTextPropName: String;
      function TimeFrameStartPropName: String;
      function TimeFrameDeadlinePropName: String;
      function PerformerPropName: String;
      function PerformerResponsePropName: String;
      function ActuallyPerformedEmployeePropName: String;
      function DocumentIdPropName: String;
      function TopLevelChargeSheetIdPropName: String;
      function IssuingDateTimePropName: String;
      function PerformingDateTimePropName: String;

    public

      function ClassType: TDocumentChargeSheetClass;
      class function ChargeType: TDocumentChargeClass; virtual;
      class function ListType: TDocumentChargeSheetsClass; virtual;
      
    published

      property KindId: Variant
      read GetKindId write SetKindId;

      property KindName: String
      read GetKindName write SetKindName;

      property ServiceKindName: String
      read GetServiceKindName write SetServiceKindName;
      
      property Issuer: TEmployee
      read GetIssuer write SetIssuer;

      property ChargeText: String
      read GetChargeText write SetChargeText;

      property TimeFrameStart: Variant
      read GetTimeFrameStart write SetTimeFrameStart;

      property TimeFrameDeadline: Variant
      read GetTimeFrameDeadline write SetTimeFrameDeadline;

      property Performer: TEmployee
      read GetPerformer write SetPerformer;

      property PerformerResponse: String
      read GetPerformerResponse write SetPerformerResponse;

      property ActuallyPerformedEmployee: TEmployee
      read GetActuallyPerformedEmployee
      write SetActuallyPerformedEmployee;

      property DocumentId: Variant
      read GetDocumentId write SetDocumentId;

      property DocumentKindId: Variant
      read GetDocumentKindId write SetDocumentKindId;

      property TopLevelChargeSheetId: Variant
      read GetTopLevelChargeSheetId write SetTopLevelChargeSheetId;

      property IsPerformed: Boolean
      read GetIsPerformed;

      property IssuingDateTime: Variant
      read GetIssuingDateTime write SetIssuingDateTime;
      
      property PerformingDateTime: Variant
      read GetPerformingDateTime write SetPerformingDateTime;

      property IsTimeFrameExpired: Boolean
      read GetIsTimeFrameExpired;

      property IsForAcquaitance: Boolean
      read GetIsForAcquaitance write SetIsForAcquaitance;
      
      property IsHead: Boolean read GetIsHead;

      property IsRequired: Boolean read GetIsRequired;

  end;

  TDocumentChargeSheetsEnumerator = class (TDomainObjectListEnumerator)

    private

      function GetCurrentDocumentChargeSheet: IDocumentChargeSheet;

    public

      constructor Create(DocumentChargeSheets: TDocumentChargeSheets);

      property Current: IDocumentChargeSheet
      read GetCurrentDocumentChargeSheet;
      
  end;

  TDocumentChargeSheets =
    class (TDomainObjectList, IDocumentChargeSheets)
        
      protected

        function GetDocumentChargeSheetByIndex(
          Index: Integer
        ): IDocumentChargeSheet;

        procedure SetDocumentChargeSheetByIndex(
          Index: Integer;
          const Value: IDocumentChargeSheet
        );

        function GetChargeSheetCount: Integer;

      public

        destructor Destroy; override;
        
        procedure AssignDocument(const DocumentId: Variant);
        
        procedure InsertDocumentChargeSheet(
          const Index: Integer;
          ChargeSheet: IDocumentChargeSheet
        );

        procedure AddDocumentChargeSheet(ChargeSheet: IDocumentChargeSheet);
        procedure AddDocumentChargeSheets(ChargeSheets: TDocumentChargeSheets);

        procedure RemoveDocumentChargeSheet(
          ChargeSheet: IDocumentChargeSheet
        );

        procedure SyncIdentitiesByChargeIdentities;

        function AreBelongsToDocument(const DocumentId: Variant): Boolean;
        
        function FindChargeSheetByIdentity(
          const Identity: Variant
        ): IDocumentChargeSheet;

        function FindChargeSheetsByIssuer(
          Issuer: TEmployee
        ): TDocumentChargeSheets; overload;

        function FindChargeSheetsByIssuer(
          const IssuerId: Variant
        ): TDocumentChargeSheets; overload;

        function FindAllSubordinateChargeSheetsByIssuer(
          Issuer: TEmployee
        ): TDocumentChargeSheets; overload;

        function FindAllSubordinateChargeSheetsByIssuer(
          const IssuerId: Variant
        ): TDocumentChargeSheets; overload;

        function FindChargeSheetByCharge(Charge: TDocumentCharge): IDocumentChargeSheet;

        function FindChargeSheetsByTopLevelChargeSheet(
          const TopLevelChargeSheetId: Variant
        ): TDocumentChargeSheets;

        function FetchPerformers: TEmployees;
        function FetchCharges: TDocumentCharges;
        function GetEnumerator: TDocumentChargeSheetsEnumerator;
        
        property Items[Index: Integer]: IDocumentChargeSheet
        read GetDocumentChargeSheetByIndex
        write SetDocumentChargeSheetByIndex; default;

    end;

implementation

uses

  Variants,
  DomainObjectBaseUnit,
  DocumentChargeSheetOverlappedPerformingRule,
  VariantFunctions;

{ IDocumentChargeSheet }

constructor TDocumentChargeSheet.Create;
begin

  inherited;

  Init;

end;

function TDocumentChargeSheet.ActuallyPerformedEmployeePropName: String;
begin

  ActuallyPerformedEmployee;

  Result := 'ActuallyPerformedEmployee';
  
end;

procedure TDocumentChargeSheet.AssignIssuer(Issuer: TEmployee);
begin

  FIssuer := Issuer;
  FreeIssuer := FIssuer;
  
end;

function TDocumentChargeSheet.ChargeTextPropName: String;
begin

  ChargeText;

  Result := 'ChargeText';
  
end;

class function TDocumentChargeSheet.ChargeType: TDocumentChargeClass;
begin

  Result := TDocumentCharge;
  
end;

constructor TDocumentChargeSheet.Create(
  Charge: TDocumentCharge;
  Issuer: TEmployee;
  IssuingDateTime: TDateTime;
  WorkingRules: TDocumentChargeSheetWorkingRules
);
begin

  if not Assigned(Issuer) then
    Raise TDocumentChargeSheetException.Create('Во время создания листа поручения не был назначен выдавший');

  if not Assigned(WorkingRules) then
    Raise TDocumentChargeSheetException.Create('Во время создания листа поручения не были назначены рабочие правила');
    
  Create(Charge);

  AssignIssuer(Issuer);

  Self.WorkingRules := WorkingRules;

  FIssuingDateTime := IssuingDateTime;
  
end;

constructor TDocumentChargeSheet.Create(Charge: TDocumentCharge);
begin

  if not Assigned(Charge) then begin

    Raise TDocumentChargeSheetException.Create(
      'Во время создания листа поручение не был указан объект поручения'
    );

  end;

  inherited Create;

  Init;

  FCharge := Charge;
  FFreeCharge := FCharge;
  
end;

destructor TDocumentChargeSheet.Destroy;
begin

  inherited;

end;

function TDocumentChargeSheet.DocumentIdPropName: String;
begin

  DocumentId;

  Result := 'DocumentId';
  
end;

procedure TDocumentChargeSheet.EnsureBelongsToDocument(
  const DocumentId: Variant);
begin

  if Self.DocumentId <> DocumentId then begin

    Raise TDocumentChargeSheetException.Create('Поручение не относится к данному документу');

  end;

end;

procedure TDocumentChargeSheet.EnsureEmployeeMayDoPerforming(
  Employee: TEmployee
);
begin

  if not InvariantsComplianceRequested then Exit;

  RaiseExceptionIfWorkingRulesNotAssigned;
  RaiseExceptionIfPerformingEnsurerNotAssigned;
  
  FPerformingEnsurer.EnsureEmployeeMayPerformChargeSheet(Employee, Self);
  
end;

procedure TDocumentChargeSheet.EnsureThatEmployeeMayMakeChangesForThisChargeSheet(
  Employee: TEmployee;
  FieldNames: array of Variant
);
begin

  if not InvariantsComplianceRequested then Exit;

  RaiseExceptionIfEditingEmployeeAndWorkingRulesNotAssigned;
  RaiseExceptionIfChangingEnsurerNotAssigned;
  
  FChangingEnsurer.EnsureEmployeeMayChangeChargeSheet(
    Employee, Self, FieldNames
  );

end;

procedure TDocumentChargeSheet.
  EnsureThatThisChargeSheetMayBePerformedByOverlappingChargeSheet(
    OverlappingChargeSheet: IDocumentChargeSheet
  );
begin

  if not InvariantsComplianceRequested then Exit;

  RaiseExceptionIfWorkingRulesNotAssigned;

  FWorkingRules.
    DocumentChargeSheetOverlappedPerformingRule.
      EnsureThatChargeSheetPerformingMayBeOverlappedByOtherChargeSheet(
        Self, OverlappingChargeSheet
      );

end;

function TDocumentChargeSheet.GetActuallyPerformedEmployee: TEmployee;
begin

  Result := FCharge.ActuallyPerformedEmployee;
  
end;

function TDocumentChargeSheet.GetCharge: TDocumentCharge;
begin

  Result := FCharge;
  
end;

function TDocumentChargeSheet.GetChargeText: String;
begin

  Result := FCharge.ChargeText;
  
end;

function TDocumentChargeSheet.ClassType: TDocumentChargeSheetClass;
begin

  Result := TDocumentChargeSheetClass(inherited ClassType);
  
end;

function TDocumentChargeSheet.GetDocumentId: Variant;
begin

  Result := FCharge.DocumentId;
  
end;

function TDocumentChargeSheet.GetDocumentKindId: Variant;
begin

  Result := FDocumentKindId;
  
end;

function TDocumentChargeSheet.GetEditingEmployee: TEmployee;
begin

  Result := FEditingEmployee;
  
end;

function TDocumentChargeSheet.GetIsForAcquaitance: Boolean;
begin

  Result := FCharge.IsForAcquaitance;
  
end;

function TDocumentChargeSheet.GetIsHead: Boolean;
begin

  Result := VarIsNullOrEmpty(TopLevelChargeSheetId);
  
end;

function TDocumentChargeSheet.GetIsPerformed: Boolean;
begin

  Result := not VarIsNullOrEmpty(PerformingDateTime);

end;

function TDocumentChargeSheet.GetIsRequired: Boolean;
begin

  Result := FCharge.IsRequired;
  
end;

function TDocumentChargeSheet.GetIssuer: TEmployee;
begin

  Result := FIssuer;
  
end;

function TDocumentChargeSheet.GetIssuingDateTime: Variant;
begin

  Result := FIssuingDateTime;
  
end;

function TDocumentChargeSheet.GetIsTimeFrameExpired: Boolean;
begin

  Result := FCharge.IsTimeFrameExpired;
  
end;

function TDocumentChargeSheet.GetKindId: Variant;
begin

  Result := FCharge.KindId;
  
end;

function TDocumentChargeSheet.GetKindName: String;
begin

  Result := FCharge.KindName;
  
end;

function TDocumentChargeSheet.GetPerformer: TEmployee;
begin

  Result := FCharge.Performer;
  
end;

function TDocumentChargeSheet.GetPerformerResponse: String;
begin

  Result := FCharge.Response;
  
end;

function TDocumentChargeSheet.GetPerformingDateTime: Variant;
begin

  Result := FCharge.PerformingDateTime;
  
end;

function TDocumentChargeSheet.GetServiceKindName: String;
begin

  Result := FCharge.ServiceKindName;
  
end;

function TDocumentChargeSheet.GetTimeFrameDeadline: Variant;
begin

  Result := FCharge.TimeFrameDeadline;

end;

function TDocumentChargeSheet.GetTimeFrameStart: Variant;
begin

  Result := FCharge.TimeFrameStart;
  
end;

function TDocumentChargeSheet.GetTopLevelChargeSheetId: Variant;
begin

  Result := FTopLevelChargeSheetId;
  
end;

procedure TDocumentChargeSheet.Init;
begin

  FDocumentKindId := Null;
  FIssuingDateTime := Null;
  FTopLevelChargeSheetId := Null;

end;

function TDocumentChargeSheet.IssuerPropName: String;
begin

  Issuer;

  Result := 'Issuer';

end;

function TDocumentChargeSheet.IssuingDateTimePropName: String;
begin

  IssuingDateTime;

  Result := 'IssuingDateTime';

end;

class function TDocumentChargeSheet.ListType: TDocumentChargeSheetsClass;
begin

  Result := TDocumentChargeSheets;
  
end;

procedure TDocumentChargeSheet.MarkAsNonRequired;
begin

  FCharge.MarkAsNonRequired;
  
end;

procedure TDocumentChargeSheet.PerformAsOverlappedBy(
  OverlappingChargeSheet: IDocumentChargeSheet;
  ActualPerformer: TEmployee;
  const PerformingDateTime: TDateTime
);
begin

  EnsureThatThisChargeSheetMayBePerformedByOverlappingChargeSheet(OverlappingChargeSheet);

  FCharge.MarkAsPerformedBy(ActualPerformer, PerformingDateTime);

end;

function TDocumentChargeSheet.PerformAsOverlappedIfPossible(
  OverlappingChargeSheet: IDocumentChargeSheet;
  ActualPerformer: TEmployee;
  const PerformingDateTime: TDateTime
): Boolean;
begin

  try

    PerformAsOverlappedBy(
      OverlappingChargeSheet, ActualPerformer, PerformingDateTime
    );

    Result := True;

  except

    on E: TNotValidChargeSheetTypeForOverlappedPerformingException
    do Result := False;
    

  end;

end;

procedure TDocumentChargeSheet.PerformBy(
  Performer: TEmployee;
  const PerformingDateTime: TDateTime
);
begin

  RaiseConditionalExceptionIfInvariantsComplianceRequested(
    (PerformingDateTime <> 0) and (IssuingDateTime > PerformingDateTime),
    TDocumentChargeSheetException,
    'Нельзя выполнить поручение сотрудника "%s" ' +
    'с датой его выдачи, поздней, чем дата выполнения',
    [
      Self.Performer.FullName
    ]
  );
  
  EnsureEmployeeMayDoPerforming(Performer);

  FCharge.InvariantsComplianceRequested := False;

  FCharge.MarkAsPerformedBy(Performer, PerformingDateTime);

  FCharge.InvariantsComplianceRequested := True;

end;

function TDocumentChargeSheet.PerformerPropName: String;
begin

  Performer;

  Result := 'Performer';
  
end;

function TDocumentChargeSheet.PerformerResponsePropName: String;
begin

  PerformerResponse;

  Result := 'PerformerResponse';
  
end;

function TDocumentChargeSheet.PerformingDateTimePropName: String;
begin

  PerformingDateTime;

  Result := 'PerformingDateTime';

end;

procedure TDocumentChargeSheet.
  RaiseExceptionIfEditingEmployeeAndWorkingRulesNotAssigned;
begin

  RaiseExceptionIfEditingEmployeeNotAssigned;
  RaiseExceptionIfWorkingRulesNotAssigned;

end;

procedure TDocumentChargeSheet.RaiseExceptionIfEditingEmployeeNotAssigned;
begin

  if not Assigned(EditingEmployee) then begin

    raise TDocumentChargeSheetException.Create(
            'Редактирующий поручение ' +
            'сотрудник не определён'
          );

  end;

end;

procedure TDocumentChargeSheet.RaiseExceptionIfChangingEnsurerNotAssigned;
begin

  if not Assigned(FChangingEnsurer) then begin

    Raise TDocumentChargeSheetException.Create('DocumentChargeSheet ChangingEnsurer not assigned');

  end;

end;

procedure TDocumentChargeSheet.RaiseExceptionIfPerformingEnsurerNotAssigned;
begin

  if not Assigned(FPerformingEnsurer) then begin

    Raise TDocumentChargeSheetException.Create(
      'DocumentChargeSheet PerformingEnsurer not assigned'
    );
    
  end;

end;

procedure TDocumentChargeSheet.RaiseExceptionIfWorkingRulesNotAssigned;
begin

  if not Assigned(FWorkingRules) then begin

    raise TDocumentChargeSheetException.Create(
            'Не найдены правила работы ' +
            'с поручением на документ'
          );

  end;

end;

procedure TDocumentChargeSheet.SetEditingEmployee(EditingEmployee: TEmployee);
begin

  RaiseExceptionIfWorkingRulesNotAssigned;
  RaiseExceptionIfChangingEnsurerNotAssigned;

  FEditingEmployee := EditingEmployee;
  
end;

procedure TDocumentChargeSheet.SetIsForAcquaitance(const Value: Boolean);
begin

  FCharge.IsForAcquaitance := Value;

end;

procedure TDocumentChargeSheet.SetIssuer(Issuer: TEmployee);
begin

  if Self.Issuer = Issuer then Exit;

  RaiseExceptionIfInvariantsComplianceRequested(
    'Выдавший поручение не может устанавливаться непосредственно'
  );

  FIssuer := Issuer;
  FreeIssuer := FIssuer;
  
end;

procedure TDocumentChargeSheet.SetIssuingDateTime(const Value: Variant);
begin

  if IssuingDateTime = Value then Exit;

  if VarIsNull(Value) or not VarIsType(Value, varDate) then begin

    raise TDocumentChargeSheetException.Create(
      'Дата выдачи поручения некорректна'
    );

  end;

  RaiseExceptionIfInvariantsComplianceRequested(
    TDocumentChargeSheetException,
    'Дата выдачи поручения не может устанавливаться непосредственно'
  );

  FIssuingDateTime := Value;
  
end;

procedure TDocumentChargeSheet.SetKindId(const Value: Variant);
begin

  FCharge.KindId := Value;
  
end;

procedure TDocumentChargeSheet.SetKindName(const Value: String);
begin

  FCharge.KindName := Value;
  
end;

procedure TDocumentChargeSheet.SetActuallyPerformedEmployee(
  const Value: TEmployee
);
begin

  FCharge.ActuallyPerformedEmployee := Value;
  
end;

procedure TDocumentChargeSheet.SetChangingEnsurer(
  const Value: IDocumentChargeSheetChangingEnsurer);
begin

  FChangingEnsurer := Value;

end;

procedure TDocumentChargeSheet.SetChargeText(const ChargeText: String);
begin

  if Self.ChargeText = ChargeText then Exit;
  
  EnsureThatEmployeeMayMakeChangesForThisChargeSheet(
    EditingEmployee, [ChargeTextPropName]
  );
  
  FCharge.ChargeText := ChargeText;
  
end;

procedure TDocumentChargeSheet.SetDocumentId(const DocumentId: Variant);
begin

  FCharge.DocumentId := DocumentId;

end;

procedure TDocumentChargeSheet.SetDocumentKindId(const Value: Variant);
begin

  if FDocumentKindId = Value then Exit;

  RaiseExceptionIfInvariantsComplianceRequested(
    TDocumentChargeSheetException,
    'Программная ошибка. ' +
    'Идентификатор вида документа не может ' +
    'устанавливаться непосредственно для поручения'
  );                                            

  FDocumentKindId := Value;
  
end;

procedure TDocumentChargeSheet.SetPerformer(Performer: TEmployee);
begin

  FCharge.Performer := Performer;

end;

procedure TDocumentChargeSheet.SetPerformerResponse(const Value: String);
begin

  if PerformerResponse = Value then Exit;
  
  EnsureThatEmployeeMayMakeChangesForThisChargeSheet(
    EditingEmployee, [PerformerResponsePropName]
  );

  FCharge.Response := Value;
  
end;

procedure TDocumentChargeSheet.SetPerformingDateTime(const Value: Variant);
begin

  FCharge.PerformingDateTime := Value;
  
end;

procedure TDocumentChargeSheet.SetPerformingEnsurer(const Value: IDocumentChargeSheetPerformingEnsurer);
begin

  FPerformingEnsurer := Value;
  
end;

procedure TDocumentChargeSheet.SetResponseBy(
  const Response: String;
  Performer: TEmployee
);
begin

  FCharge.Response := Response;

end;

procedure TDocumentChargeSheet.SetServiceKindName(const Value: String);
begin

  FCharge.ServiceKindName := Value;

end;

procedure TDocumentChargeSheet.SetTimeFrameDeadline(const Value: Variant);
begin

  FCharge.TimeFrameDeadline := Value;
  
end;

procedure TDocumentChargeSheet.SetTimeFrameStart(const Value: Variant);
begin

  FCharge.TimeFrameStart := Value;

end;

procedure TDocumentChargeSheet.SetTimeFrameStartAndDeadline(
  const TimeFrameStart, TimeFrameDeadline: TDateTime);
begin

  FCharge.SetTimeFrameStartAndDeadline(TimeFrameStart, TimeFrameDeadline);
  
end;

procedure TDocumentChargeSheet.SetTopLevelChargeSheetId(
  const TopLevelChargeSheetId: Variant);
begin

  if Self.TopLevelChargeSheetId = TopLevelChargeSheetId then Exit;
  
  EnsureThatEmployeeMayMakeChangesForThisChargeSheet(
    EditingEmployee, [TopLevelChargeSheetIdPropName]
  );
    
  FTopLevelChargeSheetId := TopLevelChargeSheetId;

end;

procedure TDocumentChargeSheet.SetWorkingRules(
  Value: TDocumentChargeSheetWorkingRules);
begin

  if FWorkingRules = Value then Exit;

  FWorkingRules := Value;
  FFreeWorkingRules := FWorkingRules;
  
end;

procedure TDocumentChargeSheet.SyncIdentityByChargeIdentity;
begin

  Identity := Charge.Identity;
  
end;

procedure TDocumentChargeSheet.SetInvariantsComplianceRequested(
  const Value: Boolean);
begin

  inherited SetInvariantsComplianceRequested(Value);

  if Assigned(FCharge) then
    FCharge.InvariantsComplianceRequested := Value;

end;

function TDocumentChargeSheet.TimeFrameDeadlinePropName: String;
begin

  TimeFrameDeadline;

  Result := 'TimeFrameDeadline';
  
end;

function TDocumentChargeSheet.TimeFrameStartPropName: String;
begin

  TimeFrameStart;

  Result := 'TimeFrameStart';

end;

function TDocumentChargeSheet.TopLevelChargeSheetIdPropName: String;
begin

  TopLevelChargeSheetId;

  Result := 'TopLevelChargeSheetId';

end;

{ TDocumentChargeSheets }

procedure TDocumentChargeSheets.AddDocumentChargeSheet(
  ChargeSheet: IDocumentChargeSheet);
begin

  AddDomainObject(TDocumentChargeSheet(ChargeSheet.Self));
  
end;

procedure TDocumentChargeSheets.AddDocumentChargeSheets(
  ChargeSheets: TDocumentChargeSheets);
var
    ChargeSheet: IDocumentChargeSheet;
begin

  for ChargeSheet in ChargeSheets do
    AddDocumentChargeSheet(ChargeSheet);

end;

function TDocumentChargeSheets.AreBelongsToDocument(
  const DocumentId: Variant): Boolean;
var
    ChargeSheet: IDocumentChargeSheet;
begin

  for ChargeSheet in Self do begin

    if ChargeSheet.DocumentId <> DocumentId then begin

      Result := False;
      Exit;

    end;

  end;

  Result := True;

end;

procedure TDocumentChargeSheets.AssignDocument(const DocumentId: Variant);
var
    ChargeSheet: IDocumentChargeSheet;
begin

  for ChargeSheet in Self do
    ChargeSheet.DocumentId := DocumentId;

end;

destructor TDocumentChargeSheets.Destroy;
begin

  inherited;

end;

function TDocumentChargeSheets.FetchCharges: TDocumentCharges;
var
    ChargeSheet: IDocumentChargeSheet;
begin

  Result := TDocumentCharges.Create;
  
  for ChargeSheet in Self do 
    Result.AddCharge(ChargeSheet.Charge);  
    
end;

function TDocumentChargeSheets.FetchPerformers: TEmployees;
var
    ChargeSheet: IDocumentChargeSheet;
begin

  Result := TEmployees.Create;

  try

    for ChargeSheet in Self do
      Result.Add(ChargeSheet.Performer);

  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;

    end;

  end;

end;

function TDocumentChargeSheets.
  FindAllSubordinateChargeSheetsByIssuer(
    Issuer: TEmployee
  ): TDocumentChargeSheets;
begin

  Result := FindAllSubordinateChargeSheetsByIssuer(Issuer.Identity);

end;

function TDocumentChargeSheets.FindAllSubordinateChargeSheetsByIssuer(
  const IssuerId: Variant
): TDocumentChargeSheets;
var
    SubordinateChargeSheets: TDocumentChargeSheets;
    FreeSubordinateChargeSheets: IDocumentChargeSheets;

    QueuedSubordinateChargeSheet: IDocumentChargeSheet;

    QueuedSubordinateChargeSheets: TDocumentChargeSheets;
    FreeQueuedSubordinateChargeSheet: IDocumentChargeSheet;
begin

  Result := TDocumentChargeSheets.Create;
  QueuedSubordinateChargeSheets := TDocumentChargeSheets.Create;

  try

    try

      SubordinateChargeSheets :=
        FindChargeSheetsByIssuer(IssuerId);

      FreeSubordinateChargeSheets := SubordinateChargeSheets;

      Result.AddDocumentChargeSheets(SubordinateChargeSheets);

      QueuedSubordinateChargeSheets.AddDocumentChargeSheets(SubordinateChargeSheets);

      while not QueuedSubordinateChargeSheets.IsEmpty do begin

        QueuedSubordinateChargeSheet := QueuedSubordinateChargeSheets[0];

        FreeQueuedSubordinateChargeSheet := QueuedSubordinateChargeSheet;

        QueuedSubordinateChargeSheets.DeleteDomainObjectEntryByIndex(0);

        SubordinateChargeSheets :=
          FindChargeSheetsByIssuer(
            QueuedSubordinateChargeSheet.Performer
          );

        FreeSubordinateChargeSheets := SubordinateChargeSheets;

        Result.AddDocumentChargeSheets(SubordinateChargeSheets);

        QueuedSubordinateChargeSheets.AddDocumentChargeSheets(
          SubordinateChargeSheets
        );
    
      end;

    except

      FreeAndNil(Result);

      Raise;

    end;

  finally

    FreeAndNil(QueuedSubordinateChargeSheets);

  end;

end;

function TDocumentChargeSheets
  .FindChargeSheetByCharge(Charge: TDocumentCharge): IDocumentChargeSheet;
var
    ChargeSheet: IDocumentChargeSheet;
begin

  for ChargeSheet in Self do begin

    if ChargeSheet.Charge.IsSameAs(Charge) then begin

      Result := ChargeSheet;
      Exit;

    end;

  end;

  Result := nil;

end;

function TDocumentChargeSheets.FindChargeSheetByIdentity(
  const Identity: Variant
): IDocumentChargeSheet;
begin

  Result := TDocumentChargeSheet(FindByIdentity(Identity));

end;

function TDocumentChargeSheets.FindChargeSheetsByIssuer(
  Issuer: TEmployee
): TDocumentChargeSheets;
begin

  Result := FindChargeSheetsByIssuer(Issuer.Identity);

end;

function TDocumentChargeSheets.FindChargeSheetsByIssuer(
  const IssuerId: Variant
): TDocumentChargeSheets;
var
    ChargeSheet: IDocumentChargeSheet;
begin

  Result := TDocumentChargeSheets.Create;

  try

    for ChargeSheet in Self do begin

      if ChargeSheet.Issuer.Identity = IssuerId
      then begin

        Result.AddDocumentChargeSheet(ChargeSheet);

      end;

    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TDocumentChargeSheets.FindChargeSheetsByTopLevelChargeSheet(
  const TopLevelChargeSheetId: Variant
): TDocumentChargeSheets;
var
    ChargeSheet: IDocumentChargeSheet;
begin

  Result := TDocumentChargeSheets.Create;

  try

    for ChargeSheet in Self do begin

      if ChargeSheet.TopLevelChargeSheetId = TopLevelChargeSheetId
      then begin

        Result.AddDocumentChargeSheet(ChargeSheet);
        
      end;
      
    end;

  except

    FreeAndNil(Result);

    Raise;

  end;
    
end;

function TDocumentChargeSheets.GetChargeSheetCount: Integer;
begin

  Result := Count;

end;

function TDocumentChargeSheets.GetDocumentChargeSheetByIndex(
  Index: Integer): IDocumentChargeSheet;
begin

  Result := TDocumentChargeSheet(GetDomainObjectByIndex(Index));
  
end;

function TDocumentChargeSheets.GetEnumerator: TDocumentChargeSheetsEnumerator;
begin

  Result := TDocumentChargeSheetsEnumerator.Create(Self);

end;

procedure TDocumentChargeSheets.InsertDocumentChargeSheet(
  const Index: Integer;
  ChargeSheet: IDocumentChargeSheet
);
begin

  InsertDomainObject(Index, TDocumentChargeSheet(ChargeSheet.Self));

end;

procedure TDocumentChargeSheets.RemoveDocumentChargeSheet(
  ChargeSheet: IDocumentChargeSheet
);
begin

  DeleteDomainObject(TDomainObject(ChargeSheet.Self));
                                     
end;

procedure TDocumentChargeSheets.SetDocumentChargeSheetByIndex(
  Index: Integer;
  const Value: IDocumentChargeSheet
);
begin

  SetDomainObjectByIndex(Index, TDocumentChargeSheet(Value.Self));
  
end;

procedure TDocumentChargeSheets.SyncIdentitiesByChargeIdentities;
var
    ChargeSheet: IDocumentChargeSheet;
begin

  for ChargeSheet in Self do
    ChargeSheet.SyncIdentityByChargeIdentity;

end;

{ TDocumentChargeSheetsEnumerator }

constructor TDocumentChargeSheetsEnumerator.Create(
  DocumentChargeSheets: TDocumentChargeSheets
);
begin

  inherited Create(DocumentChargeSheets);
  
end;

function TDocumentChargeSheetsEnumerator.GetCurrentDocumentChargeSheet: IDocumentChargeSheet;
begin

  Result := TDocumentChargeSheet(GetCurrentDomainObject);
  
end;

{ TDocumentChargeSheetFieldNamesNotAccessibleException }

constructor TDocumentChargeSheetFieldNamesNotAccessibleException.Create(
  RequestedFieldNames, NotAccessibleFieldNames: TVariantArray;
  const Msg: String;
  const Args: array of const
);
begin
                                                         
  inherited CreateFmt(Msg, Args);

  Self.RequestedFieldNames := RequestedFieldNames;
  Self.NotAccessbleFieldNames := NotAccessibleFieldNames;

  AccessibleFieldNames := ArrayDiff(RequestedFieldNames, AccessibleFieldNames);

end;

end.
