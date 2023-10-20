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

      FPerformingDateTimeFieldName: String;
      FPerformerDepartmentNameFieldName: String;
      FPerformerSpecialityFieldName: String;
      FPerformerCommentFieldName: String;
      FPerformerIdFieldName: String;
      FPerformerFullNameFieldName: String;
      FIsPerformerForeignFieldName: String;
      FChargeTextFieldName: String;
      FKindIdFieldName: String;
      FKindNameFieldName: String;
      FKindServiceNameFieldName: String;
      FIsForAcquaitanceFieldName: String;
      FPerformerDepartmentIdFieldName: String;
      FActualPerformerFullNameFieldName: String;

      function GetIdFieldName: String;
      procedure SetIdFieldName(const Value: String);

    public

      property KindIdFieldName: String
      read FKindIdFieldName write FKindIdFieldName;

      property KindNameFieldName: String
      read FKindNameFieldName write FKindNameFieldName;

      property KindServiceNameFieldName: String
      read FKindServiceNameFieldName write FKindServiceNameFieldName;

      property IsForAcquaitanceFieldName: String
      read FIsForAcquaitanceFieldName
      write FIsForAcquaitanceFieldName;
      
      property PerformingDateTimeFieldName: String
      read FPerformingDateTimeFieldName
      write FPerformingDateTimeFieldName;
      
      property PerformerDepartmentNameFieldName: String
      read FPerformerDepartmentNameFieldName
      write FPerformerDepartmentNameFieldName;
      
      property PerformerSpecialityFieldName: String
      read FPerformerSpecialityFieldName
      write FPerformerSpecialityFieldName;
      
      property PerformerCommentFieldName: String
      read FPerformerCommentFieldName
      write FPerformerCommentFieldName;

      property PerformerIdFieldName: String
      read FPerformerIdFieldName
      write FPerformerIdFieldName;

      property IdFieldName: String
      read GetIdFieldName write SetIdFieldName;
      
      property PerformerFullNameFieldName: String
      read FPerformerFullNameFieldName
      write FPerformerFullNameFieldName;

      property IsPerformerForeignFieldName: String
      read FIsPerformerForeignFieldName
      write FIsPerformerForeignFieldName;

      property ChargeTextFieldName: String
      read FChargeTextFieldName
      write FChargeTextFieldName;

      property PerformerDepartmentIdFieldName: String
      read FPerformerDepartmentIdFieldName
      write FPerformerDepartmentIdFieldName;

      property ActualPerformerFullNameFieldName: String
      read FActualPerformerFullNameFieldName
      write FActualPerformerFullNameFieldName;
      
  end;

  TDocumentChargeSetHolder = class (TAbstractDataSetHolder)

    protected

      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;
      
    private

      function GetPerformerDepartmentNameFieldValue: String;
      function GetPerformerFullNameFieldValue: String;
      function GetPerformerIdFieldValue: Variant;
      function GetPerformingDateTimeFieldValue: Variant;
      function GetPerformerCommentFieldValue: String;
      function GetPerformerSpecialityFieldValue: String;
      function GetActualPerformerFullNameFieldValue: String;

      procedure SetPerformerDepartmentNameFieldValue(const Value: String);
      procedure SetPerformerFullNameFieldValue(const Value: String);
      procedure SetPerformerIdFieldValue(const Value: Variant);
      procedure SetPerformingDateTimeFieldValue(const Value: Variant);
      procedure SetPerformerCommentFieldValue(const Value: String);
      procedure SetPerformerSpecialityFieldValue(const Value: String);
      procedure SetActualPerformerFullNameFieldValue(const Value: String);

      function GetChargeTextFieldValue: String;
      procedure SetChargeTextFieldValue(const Value: String);

      function GetIsPerformerForeignFieldValue: Boolean;
      procedure SetIsPerformerForeignFieldValue(const Value: Boolean);

      function GetPerformerDepartmentIdFieldValue: Variant;

      procedure SetPerformerDepartmentIdFieldValue(const Value: Variant);

      function GetIsPerformerForeignFieldName: String;
      function GetChargeTextFieldName: String;
      function GetPerformerCommentFieldName: String;
      function GetPerformerDepartmentNameFieldName: String;
      function GetPerformerFullNameFieldName: String;
      function GetPerformerIdFieldName: String;
      function GetPerformingDateTimeFieldName: String;
      function GetPerformerSpecialityFieldName: String;
      function GetActualPerformerFullNameFieldName: String;

      function GetPerformerDepartmentIdFieldName: String;

      procedure SetIsPerformerForeignFieldName(const Value: String);
      procedure SetPerformerCommentFieldName(const Value: String);
      procedure SetPerformerDepartmentNameFieldName(const Value: String);
      procedure SetPerformerFullNameFieldName(const Value: String);
      procedure SetPerformerIdFieldName(const Value: String);
      procedure SetPerformingDateTimeFieldName(const Value: String);
      procedure SetPerformerSpecialityFieldName(const Value: String);
      procedure SetChargeTextFieldName(const Value: String);
      procedure SetActualPerformerFullNameFieldName(const Value: String);

      procedure SetPerformerDepartmentIdFieldName(const Value: String);

      function GetIsForAcquaitanceFieldName: String;
      function GetIsForAcquaitanceFieldValue: Boolean;
      procedure SetIsForAcquaitanceFieldName(const Value: String);
      procedure SetIsForAcquaitanceFieldValue(const Value: Boolean);

      function GetDocumentChargeSetFieldDefs: TDocumentChargeSetFieldDefs;
      procedure SetDocumentChargeSetFieldDefs(
        const Value: TDocumentChargeSetFieldDefs
      );

      function GetIdFieldName: String;
      procedure SetIdFieldName(const Value: String);

      function GetIdFieldValue: Variant;
      procedure SetIdFieldValue(const Value: Variant);

      function GetKindIdFieldName: String;
      function GetKindIdFieldValue: Variant;

      procedure SetKindIdFieldName(const Value: String);
      procedure SetKindIdFieldValue(const Value: Variant);

      function GetKindNameFieldName: String;
      function GetKindServiceNameFieldName: String;
      
      procedure SetKindNameFieldName(const Value: String);
      procedure SetKindServiceNameFieldName(const Value: String);

      function GetKindNameFieldValue: String;
      function GetKindServiceNameFieldValue: String;

      procedure SetKindNameFieldValue(const Value: String);
      procedure SetKindServiceNameFieldValue(const Value: String);
      
    public

      constructor Create; virtual;
      
    published

      property IdFieldName: String
      read GetIdFieldName write SetIdFieldName;

      property KindIdFieldName: String
      read GetKindIdFieldName write SetKindIdFieldName;

      property KindNameFieldName: String
      read GetKindNameFieldName write SetKindNameFieldName;

      property KindServiceNameFieldName: String
      read GetKindServiceNameFieldName write SetKindServiceNameFieldName;

      property PerformerFullNameFieldName: String
      read GetPerformerFullNameFieldName write SetPerformerFullNameFieldName;

      property PerformerSpecialityFieldName: String
      read GetPerformerSpecialityFieldName write SetPerformerSpecialityFieldName;

      property PerformerIdFieldName: String
      read GetPerformerIdFieldName write SetPerformerIdFieldName;

      property PerformerDepartmentNameFieldName: String
      read GetPerformerDepartmentNameFieldName
      write SetPerformerDepartmentNameFieldName;

      property PerformerCommentFieldName: String
      read GetPerformerCommentFieldName write SetPerformerCommentFieldName;

      property PerformingDateTimeFieldName: String
      read GetPerformingDateTimeFieldName
      write SetPerformingDateTimeFieldName;

      property IsPerformerForeignFieldName: String
      read GetIsPerformerForeignFieldName
      write SetIsPerformerForeignFieldName;

      property ChargeTextFieldName: String
      read GetChargeTextFieldName write SetChargeTextFieldName;

      property PerformerDepartmentIdFieldName: String
      read GetPerformerDepartmentIdFieldName
      write SetPerformerDepartmentIdFieldName;

    public

      property IdFieldValue: Variant read GetIdFieldValue write SetIdFieldValue;

      property KindIdFieldValue: Variant
      read GetKindIdFieldValue write SetKindIdFieldValue;

      property KindNameFieldValue: String
      read GetKindNameFieldValue write SetKindNameFieldValue;

      property KindServiceNameFieldValue: String
      read GetKindServiceNameFieldValue write SetKindServiceNameFieldValue;

      property PerformerFullNameFieldValue: String
      read GetPerformerFullNameFieldValue write SetPerformerFullNameFieldValue;

      property PerformerSpecialityFieldValue: String
      read GetPerformerSpecialityFieldValue write SetPerformerSpecialityFieldValue;

      property PerformerIdFieldValue: Variant
      read GetPerformerIdFieldValue write SetPerformerIdFieldValue;

      property PerformerDepartmentNameFieldValue: String
      read GetPerformerDepartmentNameFieldValue
      write SetPerformerDepartmentNameFieldValue;

      property PerformerCommentFieldValue: String
      read GetPerformerCommentFieldValue write SetPerformerCommentFieldValue;

      property PerformingDateTimeFieldValue: Variant
      read GetPerformingDateTimeFieldValue
      write SetPerformingDateTimeFieldValue;

      property ChargeTextFieldValue: String
      read GetChargeTextFieldValue write SetChargeTextFieldValue;

      property IsPerformerForeignFieldValue: Boolean
      read GetIsPerformerForeignFieldValue
      write SetIsPerformerForeignFieldValue;

      property PerformerDepartmentIdFieldValue: Variant
      read GetPerformerDepartmentIdFieldValue
      write SetPerformerDepartmentIdFieldValue;

      property ActualPerformerFullNameFieldName: String
      read GetActualPerformerFullNameFieldName
      write SetActualPerformerFullNameFieldName;

      property ActualPerformerFullNameFieldValue: String
      read GetActualPerformerFullNameFieldValue
      write SetActualPerformerFullNameFieldValue;

      property IsForAcquaitanceFieldName: String
      read GetIsForAcquaitanceFieldName
      write SetIsForAcquaitanceFieldName;

      property IsForAcquaitanceFieldValue: Boolean
      read GetIsForAcquaitanceFieldValue
      write SetIsForAcquaitanceFieldValue;

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

constructor TDocumentChargeSetHolder.Create;
begin

  inherited;

  FFieldDefs := TDocumentChargeSetFieldDefs.Create;
  
end;

function TDocumentChargeSetHolder.GetKindIdFieldName: String;
begin

  Result := FieldDefs.KindIdFieldName;

end;

function TDocumentChargeSetHolder.GetKindIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(KindIdFieldName, Null);
  
end;

function TDocumentChargeSetHolder.GetKindNameFieldName: String;
begin

  Result := FieldDefs.KindNameFieldName;

end;

function TDocumentChargeSetHolder.GetKindNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(KindNameFieldName, '');
  
end;

function TDocumentChargeSetHolder.GetKindServiceNameFieldName: String;
begin

  Result := FieldDefs.KindServiceNameFieldName;
  
end;

function TDocumentChargeSetHolder.GetKindServiceNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(KindServiceNameFieldName, '');
  
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
  GetIsForAcquaitanceFieldName: String;
begin

  Result := FieldDefs.IsForAcquaitanceFieldName;
  
end;

function TDocumentChargeSetHolder.
  GetIsForAcquaitanceFieldValue: Boolean;
begin

  Result := GetDataSetFieldValue(IsForAcquaitanceFieldName, False);

end;

function TDocumentChargeSetHolder.GetIdFieldName: String;
begin

  Result := RecordIdFieldName;
  
end;

function TDocumentChargeSetHolder.GetIdFieldValue: Variant;
begin

  Result := RecordIdFieldValue;
  
end;

function TDocumentChargeSetHolder.GetIsPerformerForeignFieldName: String;
begin

  Result := FieldDefs.IsPerformerForeignFieldName;
  
end;

function TDocumentChargeSetHolder.GetIsPerformerForeignFieldValue: Boolean;
begin

  Result := GetDataSetFieldValue(IsPerformerForeignFieldName, False);
  
end;

function TDocumentChargeSetHolder.
  GetActualPerformerFullNameFieldName: String;
begin

  Result := FieldDefs.ActualPerformerFullNameFieldName;
  
end;

function TDocumentChargeSetHolder.
  GetActualPerformerFullNameFieldValue: String;
var Field: TField;
begin

  Field := DataSet.FieldByName(
    ActualPerformerFullNameFieldName
  );

  if Field.IsNull then
    Result := ''

  else Result := Field.AsString;
  
end;

function TDocumentChargeSetHolder.GetPerformerDepartmentIdFieldName: String;
begin

  Result := FieldDefs.PerformerDepartmentIdFieldName;
  
end;

function TDocumentChargeSetHolder.GetPerformerDepartmentIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(PerformerDepartmentIdFieldName, Null);
  
end;

function TDocumentChargeSetHolder.GetPerformerDepartmentNameFieldName: String;
begin

  Result := FieldDefs.PerformerDepartmentNameFieldName;
  
end;

function TDocumentChargeSetHolder.GetPerformerDepartmentNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(PerformerDepartmentNameFieldName, '');
  
end;

function TDocumentChargeSetHolder.GetPerformerFullNameFieldName: String;
begin

  Result := FieldDefs.PerformerFullNameFieldName;
  
end;

function TDocumentChargeSetHolder.GetPerformerFullNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(PerformerFullNameFieldName, '');
  
end;

function TDocumentChargeSetHolder.GetPerformerIdFieldName: String;
begin

  Result := FieldDefs.PerformerIdFieldName;
  
end;

function TDocumentChargeSetHolder.GetPerformerIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(PerformerIdFieldName, Null);

end;

function TDocumentChargeSetHolder.GetPerformingDateTimeFieldName: String;
begin

  Result := FieldDefs.PerformingDateTimeFieldName;
  
end;

function TDocumentChargeSetHolder.GetPerformingDateTimeFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(PerformingDateTimeFieldName, Null);


end;

function TDocumentChargeSetHolder.GetChargeTextFieldName: String;
begin

  Result := FieldDefs.ChargeTextFieldName;
  
end;

function TDocumentChargeSetHolder.GetChargeTextFieldValue: String;
begin

  Result := GetDataSetFieldValue(ChargeTextFieldName, '');
  
end;

function TDocumentChargeSetHolder.GetPerformerCommentFieldName: String;
begin

  Result := FieldDefs.PerformerCommentFieldName;

end;

function TDocumentChargeSetHolder.GetPerformerCommentFieldValue: String;
begin

  Result := GetDataSetFieldValue(PerformerCommentFieldName, '');

end;

function TDocumentChargeSetHolder.GetPerformerSpecialityFieldName: String;
begin

  Result := FieldDefs.PerformerSpecialityFieldName;

end;

function TDocumentChargeSetHolder.GetPerformerSpecialityFieldValue: String;
begin

  Result := GetDataSetFieldValue(PerformerSpecialityFieldName, '');

end;

procedure TDocumentChargeSetHolder.SetKindIdFieldName(
  const Value: String);
begin

  FieldDefs.KindIdFieldName := Value;
  
end;

procedure TDocumentChargeSetHolder.SetKindIdFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(KindIdFieldName, Value);
  
end;

procedure TDocumentChargeSetHolder.SetKindNameFieldName(
  const Value: String);
begin

  FieldDefs.KindNameFieldName := Value;

end;

procedure TDocumentChargeSetHolder.SetKindNameFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(KindNameFieldName, Value);
  
end;

procedure TDocumentChargeSetHolder.SetKindServiceNameFieldName(
  const Value: String);
begin

  FieldDefs.KindServiceNameFieldName := Value;
  
end;

procedure TDocumentChargeSetHolder.SetKindServiceNameFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(KindServiceNameFieldName, Value);

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

procedure TDocumentChargeSetHolder.SetIsForAcquaitanceFieldName(
  const Value: String);
begin

  FieldDefs.IsForAcquaitanceFieldName := Value;
  
end;

procedure TDocumentChargeSetHolder.SetIsForAcquaitanceFieldValue(
  const Value: Boolean);
begin

 SetDataSetFieldValue(IsForAcquaitanceFieldName, Value);

end;

procedure TDocumentChargeSetHolder.SetIsPerformerForeignFieldName(
  const Value: String);
begin

  FieldDefs.IsPerformerForeignFieldName := Value;
  
end;

procedure TDocumentChargeSetHolder.SetIsPerformerForeignFieldValue(
  const Value: Boolean);
begin

  SetDataSetFieldValue(IsPerformerForeignFieldName, Value);
  
end;

procedure TDocumentChargeSetHolder.
SetActualPerformerFullNameFieldName(
  const Value: String);
begin

  FieldDefs.ActualPerformerFullNameFieldName := Value;
  
end;

procedure TDocumentChargeSetHolder.
  SetActualPerformerFullNameFieldValue(
    const Value: String);
begin

  SetDataSetFieldValue(ActualPerformerFullNameFieldName, Value);
  
end;

procedure TDocumentChargeSetHolder.SetPerformerDepartmentIdFieldName(
  const Value: String);
begin

  FieldDefs.PerformerDepartmentIdFieldName := Value;
  
end;

procedure TDocumentChargeSetHolder.SetPerformerDepartmentIdFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(PerformerDepartmentIdFieldName, Value);
  
end;

procedure TDocumentChargeSetHolder.SetPerformerDepartmentNameFieldName(
  const Value: String);
begin

  FieldDefs.PerformerDepartmentNameFieldName := Value;
  
end;

procedure TDocumentChargeSetHolder.SetPerformerDepartmentNameFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(PerformerDepartmentNameFieldName, Value);
  
end;

procedure TDocumentChargeSetHolder.SetPerformerFullNameFieldName(
  const Value: String);
begin

  FieldDefs.PerformerFullNameFieldName := Value;
  
end;

procedure TDocumentChargeSetHolder.SetPerformerFullNameFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(PerformerFullNameFieldName, Value);

end;

procedure TDocumentChargeSetHolder.SetPerformerIdFieldName(
  const Value: String);
begin

  FieldDefs.PerformerIdFieldName := Value;
  
end;

procedure TDocumentChargeSetHolder.SetPerformerIdFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(PerformerIdFieldName, Value);

end;

procedure TDocumentChargeSetHolder.SetPerformingDateTimeFieldName(
  const Value: String);
begin

  FieldDefs.PerformingDateTimeFieldName := Value;
  
end;

procedure TDocumentChargeSetHolder.SetPerformingDateTimeFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(PerformingDateTimeFieldName, Value);

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

procedure TDocumentChargeSetHolder.SetPerformerCommentFieldName(
  const Value: String);
begin

  FieldDefs.PerformerCommentFieldName := Value;
  
end;

procedure TDocumentChargeSetHolder.SetPerformerCommentFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(PerformerCommentFieldName, Value);
  
end;

procedure TDocumentChargeSetHolder.SetPerformerSpecialityFieldName(
  const Value: String);
begin

  FieldDefs.PerformerSpecialityFieldName := Value;
  
end;

procedure TDocumentChargeSetHolder.SetPerformerSpecialityFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(PerformerSpecialityFieldName, Value);

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
