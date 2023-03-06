unit DocumentChargeSetHolder;

interface

uses

  DB,
  AbstractDataSetHolder,
  SysUtils,
  Classes;

type

  TDocumentChargeSetFieldDefs = class (TAbstractDataSetFieldDefs)

    private

      FIsPerformedByReceiverFieldName: String;
      FReceiverDocumentIdFieldName: String;
      FReceiverPerformingDateTimeFieldName: String;
      FReceiverDepartmentNameFieldName: String;
      FReceiverSpecialityFieldName: String;
      FReceiverCommentFieldName: String;
      FTopLevelChargeSheetIdFieldName: String;
      FReceiverIdFieldName: String;
      FReceiverFullNameFieldName: String;
      FReceiverLeaderIdFieldName: String;
      FIsReceiverForeignFieldName: String;
      FChargeRecordStatusFieldName: String;
      FChargeTextFieldName: String;
      FChargeKindIdFieldName: String;
      FChargeKindNameFieldName: String;
      FChargeKindServiceNameFieldName: String;
      FViewingDateByPerformerFieldName: String;
      FIsChargeForAcquaitanceFieldName: String;
      FReceiverDepartmentIdFieldName: String;
      FReceiverRoleIdFieldName: String;
      FIsAccessibleChargeFieldName: String;
      FChargeSheetSenderEmployeeNameFieldName: String;
      FChargeSheetSenderEmployeeIdFieldName: String;
      FChargeSheetIssuingDateTimeFieldName: String;
      FPerformedChargeEmployeeNameFieldName: String;

      function GetIdFieldName: String;
      procedure SetIdFieldName(const Value: String);

    public

      property ChargeKindIdFieldName: String
      read FChargeKindIdFieldName write FChargeKindIdFieldName;

      property ChargeKindNameFieldName: String
      read FChargeKindNameFieldName write FChargeKindNameFieldName;

      property ChargeKindServiceNameFieldName: String
      read FChargeKindServiceNameFieldName write FChargeKindServiceNameFieldName;
      
      property IsPerformedByReceiverFieldName: String
      read FIsPerformedByReceiverFieldName
      write FIsPerformedByReceiverFieldName;
      
      property ReceiverDocumentIdFieldName: String
      read FReceiverDocumentIdFieldName
      write FReceiverDocumentIdFieldName;

      property IsChargeForAcquaitanceFieldName: String
      read FIsChargeForAcquaitanceFieldName
      write FIsChargeForAcquaitanceFieldName;
      
      property ReceiverPerformingDateTimeFieldName: String
      read FReceiverPerformingDateTimeFieldName
      write FReceiverPerformingDateTimeFieldName;
      
      property ReceiverDepartmentNameFieldName: String
      read FReceiverDepartmentNameFieldName
      write FReceiverDepartmentNameFieldName;
      
      property ReceiverSpecialityFieldName: String
      read FReceiverSpecialityFieldName
      write FReceiverSpecialityFieldName;
      
      property ReceiverCommentFieldName: String
      read FReceiverCommentFieldName
      write FReceiverCommentFieldName;

      property TopLevelChargeSheetIdFieldName: String
      read FTopLevelChargeSheetIdFieldName
      write FTopLevelChargeSheetIdFieldName;
      
      property ReceiverIdFieldName: String
      read FReceiverIdFieldName
      write FReceiverIdFieldName;

      property ChargeSheetSenderEmployeeNameFieldName: String
      read FChargeSheetSenderEmployeeNameFieldName
      write FChargeSheetSenderEmployeeNameFieldName;

      property ChargeSheetSenderEmployeeIdFieldName: String
      read FChargeSheetSenderEmployeeIdFieldName
      write FChargeSheetSenderEmployeeIdFieldName;

      property ChargeSheetIssuingDateTimeFieldName: String
      read FChargeSheetIssuingDateTimeFieldName
      write FChargeSheetIssuingDateTimeFieldName;
      
      property IdFieldName: String
      read GetIdFieldName write SetIdFieldName;
      
      property ReceiverFullNameFieldName: String
      read FReceiverFullNameFieldName
      write FReceiverFullNameFieldName;
      
      property ReceiverLeaderIdFieldName: String
      read FReceiverLeaderIdFieldName
      write FReceiverLeaderIdFieldName;
      
      property IsReceiverForeignFieldName: String
      read FIsReceiverForeignFieldName
      write FIsReceiverForeignFieldName;

      property ChargeRecordStatusFieldName: String
      read FChargeRecordStatusFieldName
      write FChargeRecordStatusFieldName;

      property ChargeTextFieldName: String
      read FChargeTextFieldName
      write FChargeTextFieldName;

      property ViewingDateByPerformerFieldName: String
      read FViewingDateByPerformerFieldName
      write FViewingDateByPerformerFieldName;

      property ReceiverDepartmentIdFieldName: String
      read FReceiverDepartmentIdFieldName
      write FReceiverDepartmentIdFieldName;

      property ReceiverRoleIdFieldName: String
      read FReceiverRoleIdFieldName
      write FReceiverRoleIdFieldName;

      property IsAccessibleChargeFieldName: String
      read FIsAccessibleChargeFieldName
      write FIsAccessibleChargeFieldName;

      property PerformedChargeEmployeeNameFieldName: String
      read FPerformedChargeEmployeeNameFieldName
      write FPerformedChargeEmployeeNameFieldName;
      
  end;

  TDocumentChargeSetHolder = class (TAbstractDataSetHolder)

    protected

      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;
      
    private

      function GetIsPerformedByReceiverFieldValue: Boolean;
      function GetReceiverDepartmentNameFieldValue: String;
      function GetReceiverFullNameFieldValue: String;
      function GetReceiverIdFieldValue: Variant;
      function GetReceiverPerformingDateTimeFieldValue: Variant;
      function GetReceiverCommentFieldValue: String;
      function GetTopLevelChargeIdFieldValue: Variant;
      function GetReceiverSpecialityFieldValue: String;
      function GetIsAccessibleChargeFieldValue: Boolean;
      function GetChargeSheetSenderEmployeeNameFieldValue: String;
      function GetChargeSheetSenderEmployeeIdFieldValue: Variant;
      function GetPerformedChargeEmployeeNameFieldValue: String;

      procedure SetIsPerformedByReceiverFieldValue(const Value: Boolean);
      procedure SetReceiverDepartmentNameFieldValue(const Value: String);
      procedure SetReceiverDocumentIdFieldValue(const Value: Variant);
      procedure SetReceiverFullNameFieldValue(const Value: String);
      procedure SetReceiverIdFieldValue(const Value: Variant);
      procedure SetReceiverPerformingDateTimeFieldValue(const Value: Variant);
      procedure SetReceiverCommentFieldValue(const Value: String);
      procedure SetTopLevelChargeIdFieldValue(const Value: Variant);
      procedure SetReceiverSpecialityFieldValue(const Value: String);
      procedure SetIsAccessibleChargeFieldValue(const Value: Boolean);
      procedure SetChargeSheetSenderEmployeeNameFieldValue(const Value: String);
      procedure SetChargeSheetSenderEmployeeIdFieldValue(const Value: Variant);
      procedure SetPerformedChargeEmployeeNameFieldValue(const Value: String);

      function GetChargeTextFieldValue: String;
      procedure SetChargeTextFieldValue(const Value: String);
      function GetReceiverDocumentIdFieldValue: Variant;

      function GetReceiverLeaderIdFieldValue: Variant;
      procedure SetReceiverLeaderIdFieldValue(const Value: Variant);

      function GetIsReceiverForeignFieldValue: Boolean;
      procedure SetisReceiverForeignFieldValue(const Value: Boolean);
      function GetChargeRecordStatusFieldValue: Variant;

      function GetReceiverDepartmentIdFieldValue: Variant;
      function GetReceiverRoleIdFieldValue: Variant;

      procedure SetReceiverDepartmentIdFieldValue(const Value: Variant);
      procedure SetReceiverRoleIdFieldValue(const Value: Variant);

      function GetIsPerformedByReceiverFieldName: String;
      function GetIsReceiverForeignFieldName: String;
      function GetChargeTextFieldName: String;
      function GetReceiverCommentFieldName: String;
      function GetReceiverDepartmentNameFieldName: String;
      function GetReceiverDocumentIdFieldName: String;
      function GetReceiverFullNameFieldName: String;
      function GetReceiverIdFieldName: String;
      function GetReceiverLeaderIdFieldName: String;
      function GetReceiverPerformingDateTimeFieldName: String;
      function GetChargeRecordStatusFieldName: String;
      function GetTopLevelChargeSheetIdFieldName: String;
      function GetReceiverSpecialityFieldName: String;
      function GetChargeSheetSenderEmployeeNameFieldName: String;
      function GetChargeSheetSenderEmployeeIdFieldName: String;
      function GetPerformedChargeEmployeeNameFieldName: String;

      function GetViewingDateByPerformerFieldValue: Variant;
      function GetChargeLookedByReceiverFieldName: String;

      function GetReceiverDepartmentIdFieldName: String;
      function GetReceiverRoleIdFieldName: String;
      function GetIsAccessibleChargeFieldName: String;

      procedure SetIsPerformedByReceiverFieldName(const Value: String);
      procedure SetIsReceiverForeignFieldName(const Value: String);
      procedure SetReceiverCommentFieldName(const Value: String);
      procedure SetReceiverDepartmentNameFieldName(const Value: String);
      procedure SetReceiverDocumentIdFieldName(const Value: String);
      procedure SetReceiverFullNameFieldName(const Value: String);
      procedure SetReceiverIdFieldName(const Value: String);
      procedure SetReceiverPerformingDateTimeFieldName(const Value: String);
      procedure SetChargeRecordStatusFieldName(const Value: String);
      procedure SetTopLevelChargeSheetIdFieldName(const Value: String);
      procedure SetReceiverSpecialityFieldName(const Value: String);
      procedure SetChargeTextFieldName(const Value: String);
      procedure SetReceiverLeaderIdFieldName(const Value: String);
      procedure SetChargeSheetSenderEmployeeNameFieldName(const Value: String);
      procedure SetChargeSheetSenderEmployeeIdFieldName(const Value: String);
      procedure SetPerformedChargeEmployeeNameFieldName(const Value: String);
      
      procedure SetViewingDateByPerformer(const Value: Variant);
      procedure SetChargeLookedByReceiverFieldName(const Value: String);

      procedure SetReceiverDepartmentIdFieldName(const Value: String);
      procedure SetReceiverRoleIdFieldName(const Value: String);
      procedure SetIsAccessibleChargeFieldName(const Value: String);
      
      function GetIsChargeForAcquaitanceFieldName: String;
      function GetIsChargeForAcquaitanceFieldValue: Boolean;
      procedure SetIsChargeForAcquaitanceFieldName(const Value: String);
      procedure SetIsChargeForAcquaitanceFieldValue(const Value: Boolean);

      function GetDocumentChargeSetFieldDefs: TDocumentChargeSetFieldDefs;
      procedure SetDocumentChargeSetFieldDefs(
        const Value: TDocumentChargeSetFieldDefs
      );

      function GetChargeRecordAddedStatusValue: Variant;
      function GetChargeRecordChangedStatusValue: Variant;
      function GetChargeRecordNonChangedStatusValue: Variant;
      function GetChargeRecordRemovedStatusValue: Variant;

      procedure SetChargeRecordAddedStatusValue(const Value: Variant);
      procedure SetChargeRecordChangedStatusValue(const Value: Variant);
      procedure SetChargeRecordNonChangedStatusValue(const Value: Variant);
      procedure SetChargeRecordRemovedStatusValue(const Value: Variant);

      function GetIdFieldName: String;
      procedure SetIdFieldName(const Value: String);

      function GetIdFieldValue: Variant;
      procedure SetIdFieldValue(const Value: Variant);
      
      function GetChargeSheetIssuingDateTimeFieldName: String;
      function GetChargeSheetIssuingDateTimeFieldValue: Variant;
      procedure SetChargeSheetIssuingDateTimeFieldName(const Value: String);
      procedure SetChargeSheetIssuingDateTimeFieldValue(const Value: Variant);

      function GetChargeKindIdFieldName: String;
      function GetChargeKindIdFieldValue: Variant;

      procedure SetChargeKindIdFieldName(const Value: String);
      procedure SetChargeKindIdFieldValue(const Value: Variant);

      function GetChargeKindNameFieldName: String;
      function GetChargeKindServiceNameFieldName: String;
      
      procedure SetChargeKindNameFieldName(const Value: String);
      procedure SetChargeKindServiceNameFieldName(const Value: String);

      function GetChargeKindNameFieldValue: String;
      function GetChargeKindServiceNameFieldValue: String;

      procedure SetChargeKindNameFieldValue(const Value: String);
      procedure SetChargeKindServiceNameFieldValue(const Value: String);
      
    public

      destructor Destroy; override;
      constructor Create; virtual;

      procedure FilterChargeRecordsByStatus(
        const Status: Variant
      );

      procedure RevealAllChargeRecords;
      procedure RevealAddedChargeRecords;
      procedure RevealChangedChargeRecords;
      procedure RevealNonRemovedChargeRecords;
      procedure RevealRemovedChargeRecords;

      procedure MarkAllChargeRecordsAsNonChanged;
      procedure MarkAllChargeRecordsAsCommited;
      procedure MarkRemovedChargeRecordsAsNonChanged;
      procedure MarkCurrentChargeRecordAsAdded;
      procedure MarkCurrentChargeRecordAsChanged;
      procedure MarkCurrentChargeAndAllSubordinateChargeRecordsAsRemoved;
      procedure MarkCurrentChargeRecordAsNonChanged;

      function AreChargeRecordChangesExisting: Boolean;

      procedure RefreshChargeRecords;
      procedure RejectLocalChanges;
      
    published

      property IdFieldName: String
      read GetIdFieldName write SetIdFieldName;

      property ChargeKindIdFieldName: String
      read GetChargeKindIdFieldName write SetChargeKindIdFieldName;

      property ChargeKindNameFieldName: String
      read GetChargeKindNameFieldName write SetChargeKindNameFieldName;

      property ChargeKindServiceNameFieldName: String
      read GetChargeKindServiceNameFieldName write SetChargeKindServiceNameFieldName;
      
      property TopLevelChargeSheetIdFieldName: String
      read GetTopLevelChargeSheetIdFieldName write SetTopLevelChargeSheetIdFieldName;

      property ReceiverFullNameFieldName: String
      read GetReceiverFullNameFieldName write SetReceiverFullNameFieldName;

      property ReceiverSpecialityFieldName: String
      read GetReceiverSpecialityFieldName write SetReceiverSpecialityFieldName;

      property ReceiverIdFieldName: String
      read GetReceiverIdFieldName write SetReceiverIdFieldName;

      property ReceiverDepartmentNameFieldName: String
      read GetReceiverDepartmentNameFieldName
      write SetReceiverDepartmentNameFieldName;

      property ReceiverCommentFieldName: String
      read GetReceiverCommentFieldName write SetReceiverCommentFieldName;

      property ReceiverPerformingDateTimeFieldName: String
      read GetReceiverPerformingDateTimeFieldName
      write SetReceiverPerformingDateTimeFieldName;

      property ReceiverDocumentIdFieldName: String
      read GetReceiverDocumentIdFieldName
      write SetReceiverDocumentIdFieldName;

      property IsPerformedByReceiverFieldName: String
      read GetIsPerformedByReceiverFieldName
      write SetIsPerformedByReceiverFieldName;

      property IsReceiverForeignFieldName: String
      read GetIsReceiverForeignFieldName
      write SetIsReceiverForeignFieldName;

      property ChargeRecordStatusFieldName: String
      read GetChargeRecordStatusFieldName write SetChargeRecordStatusFieldName;

      property ChargeTextFieldName: String
      read GetChargeTextFieldName write SetChargeTextFieldName;

      property ReceiverLeaderIdFieldName: String
      read GetReceiverLeaderIdFieldName write SetReceiverLeaderIdFieldName;

      property ViewingDateByPerformerFieldName: String
      read GetChargeLookedByReceiverFieldName
      write SetChargeLookedByReceiverFieldName;

      property ReceiverDepartmentIdFieldName: String
      read GetReceiverDepartmentIdFieldName
      write SetReceiverDepartmentIdFieldName;

      property ReceiverRoleIdFieldName: String
      read GetReceiverRoleIdFieldName
      write SetReceiverRoleIdFieldName;

    public

      property IdFieldValue: Variant read GetIdFieldValue write SetIdFieldValue;

      property ChargeKindIdFieldValue: Variant
      read GetChargeKindIdFieldValue write SetChargeKindIdFieldValue;

      property ChargeKindNameFieldValue: String
      read GetChargeKindNameFieldValue write SetChargeKindNameFieldValue;

      property ChargeKindServiceNameFieldValue: String
      read GetChargeKindServiceNameFieldValue write SetChargeKindServiceNameFieldValue;
      
      property TopLevelChargeIdFieldValue: Variant
      read GetTopLevelChargeIdFieldValue write SetTopLevelChargeIdFieldValue;

      property ReceiverFullNameFieldValue: String
      read GetReceiverFullNameFieldValue write SetReceiverFullNameFieldValue;

      property ReceiverSpecialityFieldValue: String
      read GetReceiverSpecialityFieldValue write SetReceiverSpecialityFieldValue;

      property ReceiverIdFieldValue: Variant
      read GetReceiverIdFieldValue write SetReceiverIdFieldValue;

      property ReceiverDepartmentNameFieldValue: String
      read GetReceiverDepartmentNameFieldValue
      write SetReceiverDepartmentNameFieldValue;

      property ReceiverCommentFieldValue: String
      read GetReceiverCommentFieldValue write SetReceiverCommentFieldValue;

      property ReceiverPerformingDateTimeFieldValue: Variant
      read GetReceiverPerformingDateTimeFieldValue
      write SetReceiverPerformingDateTimeFieldValue;

      property ReceiverDocumentIdFieldValue: Variant
      read GetReceiverDocumentIdFieldValue write SetReceiverDocumentIdFieldValue;

      property IsPerformedByReceiverFieldValue: Boolean
      read GetIsPerformedByReceiverFieldValue
      write SetIsPerformedByReceiverFieldValue;

      property ChargeRecordAddedStatusValue: Variant
      read GetChargeRecordAddedStatusValue
      write SetChargeRecordAddedStatusValue;

      property ChargeRecordChangedStatusValue: Variant
      read GetChargeRecordChangedStatusValue
      write SetChargeRecordChangedStatusValue;

      property ChargeRecordRemovedStatusValue: Variant
      read GetChargeRecordRemovedStatusValue
      write SetChargeRecordRemovedStatusValue;

      property ChargeRecordNonChangedStatusValue: Variant
      read GetChargeRecordNonChangedStatusValue
      write SetChargeRecordNonChangedStatusValue;

      property ChargeRecordStatusFieldValue: Variant
      read GetChargeRecordStatusFieldValue;

      property ChargeTextFieldValue: String
      read GetChargeTextFieldValue write SetChargeTextFieldValue;

      property ReceiverLeaderIdFieldValue: Variant
      read GetReceiverLeaderIdFieldValue write SetReceiverLeaderIdFieldValue;

      property IsReceiverForeignFieldValue: Boolean
      read GetIsReceiverForeignFieldValue
      write SetisReceiverForeignFieldValue;

      property ViewingDateByPerformerFieldValue: Variant
      read GetViewingDateByPerformerFieldValue write SetViewingDateByPerformer;

      property ReceiverDepartmentIdFieldValue: Variant
      read GetReceiverDepartmentIdFieldValue
      write SetReceiverDepartmentIdFieldValue;

      property ReceiverRoleIdFieldValue: Variant
      read GetReceiverRoleIdFieldValue
      write SetReceiverRoleIdFieldValue;

      property IsAccessibleChargeFieldName: String
      read GetIsAccessibleChargeFieldName
      write SetIsAccessibleChargeFieldName;

      property IsAccessibleChargeFieldValue: Boolean
      read GetIsAccessibleChargeFieldValue
      write SetIsAccessibleChargeFieldValue;

      property ChargeSheetSenderEmployeeNameFieldName: String
      read GetChargeSheetSenderEmployeeNameFieldName
      write SetChargeSheetSenderEmployeeNameFieldName;

      property ChargeSheetSenderEmployeeIdFieldName: String
      read GetChargeSheetSenderEmployeeIdFieldName
      write SetChargeSheetSenderEmployeeIdFieldName;

      property ChargeSheetSenderEmployeeNameFieldValue: String
      read GetChargeSheetSenderEmployeeNameFieldValue
      write SetChargeSheetSenderEmployeeNameFieldValue;

      property ChargeSheetSenderEmployeeIdFieldValue: Variant
      read GetChargeSheetSenderEmployeeIdFieldValue
      write SetChargeSheetSenderEmployeeIdFieldValue;

      property ChargeSheetIssuingDateTimeFieldName: String
      read GetChargeSheetIssuingDateTimeFieldName
      write SetChargeSheetIssuingDateTimeFieldName;

      property ChargeSheetIssuingDateTimeFieldValue: Variant
      read GetChargeSheetIssuingDateTimeFieldValue
      write SetChargeSheetIssuingDateTimeFieldValue;

      property PerformedChargeEmployeeNameFieldName: String
      read GetPerformedChargeEmployeeNameFieldName
      write SetPerformedChargeEmployeeNameFieldName;

      property PerformedChargeEmployeeNameFieldValue: String
      read GetPerformedChargeEmployeeNameFieldValue
      write SetPerformedChargeEmployeeNameFieldValue;

      property IsChargeForAcquaitanceFieldName: String
      read GetIsChargeForAcquaitanceFieldName
      write SetIsChargeForAcquaitanceFieldName;

      property IsChargeForAcquaitanceFieldValue: Boolean
      read GetIsChargeForAcquaitanceFieldValue
      write SetIsChargeForAcquaitanceFieldValue;

    public

      property FieldDefs: TDocumentChargeSetFieldDefs
      read GetDocumentChargeSetFieldDefs write SetDocumentChargeSetFieldDefs;

  end;

implementation

uses

  Variants,
  AuxDebugFunctionsUnit,
  VariantListUnit;

{ TDocumentChargeSetHolder }

function TDocumentChargeSetHolder.AreChargeRecordChangesExisting: Boolean;
begin

  Result := AreChangedRecordsExists;
    
end;

constructor TDocumentChargeSetHolder.Create;
begin

  inherited;

  FFieldDefs := TDocumentChargeSetFieldDefs.Create;
  
end;

destructor TDocumentChargeSetHolder.Destroy;
begin

  FreeAndNil(FFieldDefs);
  inherited;

end;

procedure TDocumentChargeSetHolder.FilterChargeRecordsByStatus(
  const Status: Variant);
begin

  FilterByRecordStatus(Status);

end;

function TDocumentChargeSetHolder.GetChargeKindIdFieldName: String;
begin

  Result := FieldDefs.ChargeKindIdFieldName;

end;

function TDocumentChargeSetHolder.GetChargeKindIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(ChargeKindIdFieldName, Null);
  
end;

function TDocumentChargeSetHolder.GetChargeKindNameFieldName: String;
begin

  Result := FieldDefs.ChargeKindNameFieldName;

end;

function TDocumentChargeSetHolder.GetChargeKindNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(ChargeKindNameFieldName, '');
  
end;

function TDocumentChargeSetHolder.GetChargeKindServiceNameFieldName: String;
begin

  Result := FieldDefs.ChargeKindServiceNameFieldName;
  
end;

function TDocumentChargeSetHolder.GetChargeKindServiceNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(ChargeKindServiceNameFieldName, '');
  
end;

function TDocumentChargeSetHolder.GetChargeLookedByReceiverFieldName: String;
begin

  Result := FieldDefs.ViewingDateByPerformerFieldName;
  
end;

function TDocumentChargeSetHolder.GetChargeSheetIssuingDateTimeFieldName: String;
begin

  Result := FieldDefs.ChargeSheetIssuingDateTimeFieldName;

end;

function TDocumentChargeSetHolder.GetChargeSheetIssuingDateTimeFieldValue: Variant;
begin

  Result :=
    GetDataSetFieldValue(ChargeSheetIssuingDateTimeFieldName, Null);

end;

function TDocumentChargeSetHolder.GetChargeSheetSenderEmployeeIdFieldName: String;
begin

  Result := FieldDefs.ChargeSheetSenderEmployeeIdFieldName;
  
end;

function TDocumentChargeSetHolder.GetChargeSheetSenderEmployeeIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(ChargeSheetSenderEmployeeIdFieldName, Null);

end;

function TDocumentChargeSetHolder.
  GetChargeSheetSenderEmployeeNameFieldName: String;
begin

  Result := FieldDefs.ChargeSheetSenderEmployeeNameFieldName;

end;

function TDocumentChargeSetHolder.
  GetChargeSheetSenderEmployeeNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(ChargeSheetSenderEmployeeNameFieldName, '');

end;

class function TDocumentChargeSetHolder.GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass;
begin

  Result := TDocumentChargeSetFieldDefs;

end;

function TDocumentChargeSetHolder.
  GetDocumentChargeSetFieldDefs: TDocumentChargeSetFieldDefs;
begin

  Result := TDocumentChargeSetFieldDefs(inherited FieldDefs);
  
end;

function TDocumentChargeSetHolder.
  GetIsChargeForAcquaitanceFieldName: String;
begin

  Result := FieldDefs.IsChargeForAcquaitanceFieldName;
  
end;

function TDocumentChargeSetHolder.
  GetIsChargeForAcquaitanceFieldValue: Boolean;
begin

  Result := GetDataSetFieldValue(IsChargeForAcquaitanceFieldName, False);

end;

function TDocumentChargeSetHolder.GetViewingDateByPerformerFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(ViewingDateByPerformerFieldName, Null);
  
end;

function TDocumentChargeSetHolder.GetIdFieldName: String;
begin

  Result := RecordIdFieldName;
  
end;

function TDocumentChargeSetHolder.GetIdFieldValue: Variant;
begin

  Result := RecordIdFieldValue;
  
end;

function TDocumentChargeSetHolder.GetIsAccessibleChargeFieldName: String;
begin

  Result := FieldDefs.IsAccessibleChargeFieldName;
  
end;

function TDocumentChargeSetHolder.GetIsAccessibleChargeFieldValue: Boolean;
begin

  Result := GetDataSetFieldValue(IsAccessibleChargeFieldName, False);
  
end;

function TDocumentChargeSetHolder.GetIsPerformedByReceiverFieldName: String;
begin

  Result := FieldDefs.IsPerformedByReceiverFieldName;
  
end;

function TDocumentChargeSetHolder.GetIsPerformedByReceiverFieldValue: Boolean;
begin

  Result := GetDataSetFieldValue(IsPerformedByReceiverFieldName, False);
  
end;

function TDocumentChargeSetHolder.GetIsReceiverForeignFieldName: String;
begin

  Result := FieldDefs.IsReceiverForeignFieldName;
  
end;

function TDocumentChargeSetHolder.GetIsReceiverForeignFieldValue: Boolean;
begin

  Result := GetDataSetFieldValue(IsReceiverForeignFieldName, False);
  
end;

function TDocumentChargeSetHolder.
  GetPerformedChargeEmployeeNameFieldName: String;
begin

  Result := FieldDefs.PerformedChargeEmployeeNameFieldName;
  
end;

function TDocumentChargeSetHolder.
  GetPerformedChargeEmployeeNameFieldValue: String;
var Field: TField;
begin

  Field := DataSet.FieldByName(
    PerformedChargeEmployeeNameFieldName
  );

  if Field.IsNull then
    Result := ''

  else Result := Field.AsString;
  
end;

function TDocumentChargeSetHolder.GetReceiverDepartmentIdFieldName: String;
begin

  Result := FieldDefs.ReceiverDepartmentIdFieldName;
  
end;

function TDocumentChargeSetHolder.GetReceiverDepartmentIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(ReceiverDepartmentIdFieldName, Null);
  
end;

function TDocumentChargeSetHolder.GetReceiverDepartmentNameFieldName: String;
begin

  Result := FieldDefs.ReceiverDepartmentNameFieldName;
  
end;

function TDocumentChargeSetHolder.GetReceiverDepartmentNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(ReceiverDepartmentNameFieldName, '');
  
end;

function TDocumentChargeSetHolder.GetReceiverDocumentIdFieldName: String;
begin

  Result := FieldDefs.ReceiverDocumentIdFieldName;
  
end;

function TDocumentChargeSetHolder.GetReceiverDocumentIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(ReceiverDocumentIdFieldName, '');
  
end;

function TDocumentChargeSetHolder.GetReceiverFullNameFieldName: String;
begin

  Result := FieldDefs.ReceiverFullNameFieldName;
  
end;

function TDocumentChargeSetHolder.GetReceiverFullNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(ReceiverFullNameFieldName, '');
  
end;

function TDocumentChargeSetHolder.GetReceiverIdFieldName: String;
begin

  Result := FieldDefs.ReceiverIdFieldName;
  
end;

function TDocumentChargeSetHolder.GetReceiverIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(ReceiverIdFieldName, Null);

end;

function TDocumentChargeSetHolder.GetReceiverLeaderIdFieldName: String;
begin

  Result := FieldDefs.ReceiverLeaderIdFieldName;
  
end;

function TDocumentChargeSetHolder.GetReceiverLeaderIdFieldValue: Variant;
begin

  Result :=
    GetDataSetFieldValue(ReceiverLeaderIdFieldName, Null);
  
end;

function TDocumentChargeSetHolder.GetReceiverPerformingDateTimeFieldName: String;
begin

  Result := FieldDefs.ReceiverPerformingDateTimeFieldName;
  
end;

function TDocumentChargeSetHolder.GetReceiverPerformingDateTimeFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(ReceiverPerformingDateTimeFieldName, Null);


end;

function TDocumentChargeSetHolder.GetChargeRecordAddedStatusValue: Variant;
begin

  Result := RecordAddedStatusValue;
  
end;

function TDocumentChargeSetHolder.GetChargeRecordChangedStatusValue: Variant;
begin

  Result := RecordChangedStatusValue;
  
end;

function TDocumentChargeSetHolder.GetChargeRecordNonChangedStatusValue: Variant;
begin

  Result := RecordNonChangedStatusValue;
  
end;

function TDocumentChargeSetHolder.GetChargeRecordRemovedStatusValue: Variant;
begin

  Result := RecordRemovedStatusValue;

end;

function TDocumentChargeSetHolder.GetChargeRecordStatusFieldName: String;
begin

  Result := RecordStatusFieldName;
  
end;

function TDocumentChargeSetHolder.GetChargeRecordStatusFieldValue: Variant;
begin

  Result := RecordStatusFieldValue;
  
end;

function TDocumentChargeSetHolder.GetReceiverRoleIdFieldName: String;
begin

  Result := FieldDefs.ReceiverRoleIdFieldName;
  
end;

function TDocumentChargeSetHolder.GetReceiverRoleIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(ReceiverRoleIdFieldName, Null);
  
end;

function TDocumentChargeSetHolder.GetChargeTextFieldName: String;
begin

  Result := FieldDefs.ChargeTextFieldName;
  
end;

function TDocumentChargeSetHolder.GetChargeTextFieldValue: String;
begin

  Result := GetDataSetFieldValue(ChargeTextFieldName, '');
  
end;

function TDocumentChargeSetHolder.GetReceiverCommentFieldName: String;
begin

  Result := FieldDefs.ReceiverCommentFieldName;

end;

function TDocumentChargeSetHolder.GetReceiverCommentFieldValue: String;
begin

  Result := GetDataSetFieldValue(ReceiverCommentFieldName, '');
  
end;

function TDocumentChargeSetHolder.GetTopLevelChargeSheetIdFieldName: String;
begin

  Result := FieldDefs.TopLevelChargeSheetIdFieldName;
  
end;

function TDocumentChargeSetHolder.GetTopLevelChargeIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(TopLevelChargeSheetIdFieldName, Null);

end;

function TDocumentChargeSetHolder.GetReceiverSpecialityFieldName: String;
begin

  Result := FieldDefs.ReceiverSpecialityFieldName;
  
end;

function TDocumentChargeSetHolder.GetReceiverSpecialityFieldValue: String;
begin

  Result := GetDataSetFieldValue(ReceiverSpecialityFieldName, '');
  
end;

procedure TDocumentChargeSetHolder.MarkCurrentChargeRecordAsChanged;
begin

  MarkCurrentRecordAsChanged;

end;

procedure TDocumentChargeSetHolder.MarkCurrentChargeRecordAsAdded;
begin

  MarkCurrentRecordAsAdded;
  
end;

procedure TDocumentChargeSetHolder.MarkCurrentChargeRecordAsNonChanged;

begin

  MarkCurrentRecordAsNonChanged;

end;

procedure TDocumentChargeSetHolder.MarkRemovedChargeRecordsAsNonChanged;
begin

  MarkRemovedRecordsAsNonChanged;

end;

procedure TDocumentChargeSetHolder.MarkAllChargeRecordsAsCommited;
begin

  MarkAllRecordsAsCommited;

end;

procedure TDocumentChargeSetHolder.MarkAllChargeRecordsAsNonChanged;
begin

  MarkAllRecordsAsNonChanged;

end;

procedure TDocumentChargeSetHolder.MarkCurrentChargeAndAllSubordinateChargeRecordsAsRemoved;
var RecordIds: TVariantList;
    RecordId: Variant;
    PreviousFilter: String;
    PreviousFiltered: Boolean;
begin

  RecordIds := TVariantList.Create;

  PreviousFilter := DataSet.Filter;
  PreviousFiltered := DataSet.Filtered;

  try

    RecordIds.Add(IdFieldValue);

    while not RecordIds.IsEmpty do begin

      RecordId := RecordIds.ExtractFirst;

      Locate(IdFieldName, RecordId, []);
      
      MarkCurrentRecordAsRemoved;
      
      DataSet.Filter := TopLevelChargeSheetIdFieldName + '=' + VarToStr(RecordId);

      DataSet.Filtered := True;

      DataSet.First;

      while not DataSet.Eof do begin

        RecordIds.Add(IdFieldValue);

        DataSet.Next;
        
      end;

      DataSet.Filtered := False;

    end;
    
  finally

    DataSet.Filter := PreviousFilter;
    DataSet.Filtered := PreviousFiltered;

    FreeAndNil(RecordIds);

  end;

end;

procedure TDocumentChargeSetHolder.RefreshChargeRecords;
begin

  Refresh;

end;

procedure TDocumentChargeSetHolder.RejectLocalChanges;
begin

  inherited RejectLocalChanges;

end;

procedure TDocumentChargeSetHolder.RevealAddedChargeRecords;
begin

  RevealAddedRecords;
  
end;

procedure TDocumentChargeSetHolder.RevealAllChargeRecords;
begin

  RevealAllRecords;
  
end;

procedure TDocumentChargeSetHolder.RevealChangedChargeRecords;
begin

  RevealChangedRecords;
  
end;

procedure TDocumentChargeSetHolder.RevealNonRemovedChargeRecords;
begin

  RevealNonRemovedRecords;
  
end;

procedure TDocumentChargeSetHolder.RevealRemovedChargeRecords;
begin

  RevealRemovedRecords;
  
end;

procedure TDocumentChargeSetHolder.SetChargeKindIdFieldName(
  const Value: String);
begin

  FieldDefs.ChargeKindIdFieldName := Value;
  
end;

procedure TDocumentChargeSetHolder.SetChargeKindIdFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(ChargeKindIdFieldName, Value);
  
end;

procedure TDocumentChargeSetHolder.SetChargeKindNameFieldName(
  const Value: String);
begin

  FieldDefs.ChargeKindNameFieldName := Value;

end;

procedure TDocumentChargeSetHolder.SetChargeKindNameFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(ChargeKindNameFieldName, Value);
  
end;

procedure TDocumentChargeSetHolder.SetChargeKindServiceNameFieldName(
  const Value: String);
begin

  FieldDefs.ChargeKindServiceNameFieldName := Value;
  
end;

procedure TDocumentChargeSetHolder.SetChargeKindServiceNameFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(ChargeKindServiceNameFieldName, Value);

end;

procedure TDocumentChargeSetHolder.SetChargeLookedByReceiverFieldName(
  const Value: String);
begin

  FieldDefs.ViewingDateByPerformerFieldName := Value;
  
end;

procedure TDocumentChargeSetHolder.SetChargeSheetIssuingDateTimeFieldName(
  const Value: String);
begin

  FieldDefs.ChargeSheetIssuingDateTimeFieldName := Value;
  
end;

procedure TDocumentChargeSetHolder.SetChargeSheetIssuingDateTimeFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(ChargeSheetIssuingDateTimeFieldName, Value);
  
end;

procedure TDocumentChargeSetHolder.
  SetChargeSheetSenderEmployeeIdFieldName(
    const Value: String
);
begin

  FieldDefs.ChargeSheetSenderEmployeeIdFieldName := Value;
  
end;

procedure TDocumentChargeSetHolder.
  SetChargeSheetSenderEmployeeIdFieldValue(
    const Value: Variant
  );
begin

  SetDataSetFieldValue(ChargeSheetSenderEmployeeIdFieldName, Value);

end;

procedure TDocumentChargeSetHolder.
  SetChargeSheetSenderEmployeeNameFieldName(
    const Value: String
  );
begin

  FieldDefs.ChargeSheetSenderEmployeeNameFieldName := Value;

end;

procedure TDocumentChargeSetHolder.
  SetChargeSheetSenderEmployeeNameFieldValue(
    const Value: String
  );
begin

  SetDataSetFieldValue(ChargeSheetSenderEmployeeNameFieldName, Value);
  
end;

procedure TDocumentChargeSetHolder.SetDocumentChargeSetFieldDefs(
  const Value: TDocumentChargeSetFieldDefs);
begin

  SetFieldDefs(Value);

end;

procedure TDocumentChargeSetHolder.SetIdFieldName(
  const Value: String);
begin

  RecordIdFieldName := Value;
  
end;

procedure TDocumentChargeSetHolder.SetIdFieldValue(
  const Value: Variant);
begin

  RecordIdFieldValue := Value;
  
end;

procedure TDocumentChargeSetHolder.SetIsChargeForAcquaitanceFieldName(
  const Value: String);
begin

  FieldDefs.IsChargeForAcquaitanceFieldName := Value;
  
end;

procedure TDocumentChargeSetHolder.SetIsChargeForAcquaitanceFieldValue(
  const Value: Boolean);
begin

 SetDataSetFieldValue(IsChargeForAcquaitanceFieldName, Value);

end;

procedure TDocumentChargeSetHolder.SetViewingDateByPerformer(
  const Value: Variant);
begin

  SetDataSetFieldValue(ViewingDateByPerformerFieldName, Value);
  
end;

procedure TDocumentChargeSetHolder.SetIsAccessibleChargeFieldName(
  const Value: String);
begin

  FieldDefs.IsAccessibleChargeFieldName := Value;
  
end;

procedure TDocumentChargeSetHolder.SetIsAccessibleChargeFieldValue(
  const Value: Boolean);
begin

  SetDataSetFieldValue(IsAccessibleChargeFieldName, Value);

end;

procedure TDocumentChargeSetHolder.SetIsPerformedByReceiverFieldName(
  const Value: String);
begin

  FieldDefs.IsPerformedByReceiverFieldName := Value;
  
end;

procedure TDocumentChargeSetHolder.SetIsPerformedByReceiverFieldValue(
  const Value: Boolean);
begin

  SetDataSetFieldValue(IsPerformedByReceiverFieldName, Value);
  
end;

procedure TDocumentChargeSetHolder.SetIsReceiverForeignFieldName(
  const Value: String);
begin

  FieldDefs.IsReceiverForeignFieldName := Value;
  
end;

procedure TDocumentChargeSetHolder.SetisReceiverForeignFieldValue(
  const Value: Boolean);
begin

  SetDataSetFieldValue(IsReceiverForeignFieldName, Value);
  
end;

procedure TDocumentChargeSetHolder.
SetPerformedChargeEmployeeNameFieldName(
  const Value: String);
begin

  FieldDefs.PerformedChargeEmployeeNameFieldName := Value;
  
end;

procedure TDocumentChargeSetHolder.
  SetPerformedChargeEmployeeNameFieldValue(
    const Value: String);
begin

  SetDataSetFieldValue(PerformedChargeEmployeeNameFieldName, Value);
  
end;

procedure TDocumentChargeSetHolder.SetReceiverDepartmentIdFieldName(
  const Value: String);
begin

  FieldDefs.ReceiverDepartmentIdFieldName := Value;
  
end;

procedure TDocumentChargeSetHolder.SetReceiverDepartmentIdFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(ReceiverDepartmentIdFieldName, Value);
  
end;

procedure TDocumentChargeSetHolder.SetReceiverDepartmentNameFieldName(
  const Value: String);
begin

  FieldDefs.ReceiverDepartmentNameFieldName := Value;
  
end;

procedure TDocumentChargeSetHolder.SetReceiverDepartmentNameFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(ReceiverDepartmentNameFieldName, Value);
  
end;

procedure TDocumentChargeSetHolder.SetReceiverDocumentIdFieldName(
  const Value: String);
begin

  FieldDefs.ReceiverDocumentIdFieldName := Value;
  
end;

procedure TDocumentChargeSetHolder.SetReceiverDocumentIdFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(ReceiverDocumentIdFieldName, Value);

end;

procedure TDocumentChargeSetHolder.SetReceiverFullNameFieldName(
  const Value: String);
begin

  FieldDefs.ReceiverFullNameFieldName := Value;
  
end;

procedure TDocumentChargeSetHolder.SetReceiverFullNameFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(ReceiverFullNameFieldName, Value);

end;

procedure TDocumentChargeSetHolder.SetReceiverIdFieldName(
  const Value: String);
begin

  FieldDefs.ReceiverIdFieldName := Value;
  
end;

procedure TDocumentChargeSetHolder.SetReceiverIdFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(ReceiverIdFieldName, Value);

end;

procedure TDocumentChargeSetHolder.SetReceiverLeaderIdFieldName(
  const Value: String);
begin

  FieldDefs.ReceiverLeaderIdFieldName := Value;
  
end;

procedure TDocumentChargeSetHolder.SetReceiverLeaderIdFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(ReceiverLeaderIdFieldName, Value);

end;

procedure TDocumentChargeSetHolder.SetReceiverPerformingDateTimeFieldName(
  const Value: String);
begin

  FieldDefs.ReceiverPerformingDateTimeFieldName := Value;
  
end;

procedure TDocumentChargeSetHolder.SetReceiverPerformingDateTimeFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(ReceiverPerformingDateTimeFieldName, Value);

end;

procedure TDocumentChargeSetHolder.SetChargeRecordAddedStatusValue(
  const Value: Variant);
begin

  RecordAddedStatusValue := Value;

end;

procedure TDocumentChargeSetHolder.SetChargeRecordChangedStatusValue(
  const Value: Variant);
begin

  RecordChangedStatusValue := Value;
  
end;

procedure TDocumentChargeSetHolder.SetChargeRecordNonChangedStatusValue(
  const Value: Variant);
begin

  RecordNonChangedStatusValue := Value;
  
end;

procedure TDocumentChargeSetHolder.SetChargeRecordRemovedStatusValue(
  const Value: Variant);
begin

  RecordRemovedStatusValue := Value;
  
end;

procedure TDocumentChargeSetHolder.SetChargeRecordStatusFieldName(
  const Value: String);
begin

  RecordStatusFieldName := Value;
  
end;

procedure TDocumentChargeSetHolder.SetReceiverRoleIdFieldName(
  const Value: String);
begin

  FieldDefs.ReceiverRoleIdFieldName := Value;
  
end;

procedure TDocumentChargeSetHolder.SetReceiverRoleIdFieldValue(
  const Value: Variant);
begin

  DataSet.FieldByName(ReceiverRoleIdFieldName).AsVariant := Value;
  
end;

procedure TDocumentChargeSetHolder.SetChargeTextFieldName(
  const Value: String);
begin

  FieldDefs.ChargeTextFieldName := Value;
  
end;

procedure TDocumentChargeSetHolder.SetChargeTextFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(ChargeTextFieldName, Value);
  
end;

procedure TDocumentChargeSetHolder.SetReceiverCommentFieldName(
  const Value: String);
begin

  FieldDefs.ReceiverCommentFieldName := Value;
  
end;

procedure TDocumentChargeSetHolder.SetReceiverCommentFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(ReceiverCommentFieldName, Value);
  
end;

procedure TDocumentChargeSetHolder.SetTopLevelChargeSheetIdFieldName(
  const Value: String);
begin

  FieldDefs.TopLevelChargeSheetIdFieldName := Value;
  
end;

procedure TDocumentChargeSetHolder.SetTopLevelChargeIdFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(TopLevelChargeSheetIdFieldName, Value);
  
end;

procedure TDocumentChargeSetHolder.SetReceiverSpecialityFieldName(
  const Value: String);
begin

  FieldDefs.ReceiverSpecialityFieldName := Value;
  
end;

procedure TDocumentChargeSetHolder.SetReceiverSpecialityFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(ReceiverSpecialityFieldName, Value);

end;

{ TDocumentChargeSetFieldDefs }

function TDocumentChargeSetFieldDefs.GetIdFieldName: String;
begin

  Result := RecordIdFieldName;

end;

procedure TDocumentChargeSetFieldDefs.SetIdFieldName(
  const Value: String);
begin

  RecordIdFieldName := Value;
  
end;

end.
