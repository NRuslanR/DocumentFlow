unit DocumentChargeSheetsInfoHolder;

interface

uses

  DB,
  AbstractDataSetHolder,
  SysUtils;

type

  TDocumentChargeSheetsInfoFieldNames = class (TAbstractDataSetFieldDefs)

    public

      DocumentChargeSheetIdFieldName: String;
      DocumentChargeSheetKindIdFieldName: String;
      DocumentChargeSheetKindNameFieldName: String;
      DocumentChargeSheetServiceKindNameFieldName: String;
      ChargeSheetDocumentIdFieldName: String;
      TopLevelDocumentChargeSheetIdFieldName: String;
      DocumentChargeSheetTextFieldName: String;
      DocumentChargeSheetIsForAcquaitanceFieldName: String;
      DocumentChargeSheetResponseFieldName: String;
      DocumentChargeSheetPeriodStartFieldName: String;
      DocumentChargeSheetPeriodEndFieldName: String;
      DocumentChargeSheetPerformingDateTimeFieldName: String;
      DocumentChargeSheetViewingDateByPerformerFieldName: String;

      DocumentChargeSheetIssuingDateTimeFieldName: String;
      DocumentChargeSheetPerformerIdFieldName: String;
      DocumentChargeSheetPerformerRoleIdFieldName: String; { refactor }
      DocumentChargeSheetPerformerLeaderIdFieldName: String;
      DocumentChargeSheetPerformerIsForeignFieldName: String;
      DocumentChargeSheetPerformerNameFieldName: String;
      DocumentChargeSheetPerformerSpecialityFieldName: String;
      DocumentChargeSheetPerformerDepartmentIdFieldName: String;
      DocumentChargeSheetPerformerDepartmentCodeFieldName: String;
      DocumentChargeSheetPerformerDepartmentNameFieldName: String;

      DocumentChargeSheetActualPerformerIdFieldName: String;
      DocumentChargeSheetActualPerformerLeaderIdFieldName: String;
      DocumentChargeSheetActualPerformerIsForeignFieldName: String;
      DocumentChargeSheetActualPerformerNameFieldName: String;
      DocumentChargeSheetActualPerformerSpecialityFieldName: String;
      DocumentChargeSheetActualPerformerDepartmentIdFieldName: String;
      DocumentChargeSheetActualPerformerDepartmentCodeFieldName: String;
      DocumentChargeSheetActualPerformerDepartmentNameFieldName: String;

      DocumentChargeSheetSenderIdFieldName: String;
      DocumentChargeSheetSenderLeaderIdFieldName: String;
      DocumentChargeSheetSenderIsForeignFieldName: String;
      DocumentChargeSheetSenderNameFieldName: String;
      DocumentChargeSheetSenderSpecialityFieldName: String;
      DocumentChargeSheetSenderDepartmentIdFieldName: String;
      DocumentChargeSheetSenderDepartmentCodeFieldName: String;
      DocumentChargeSheetSenderDepartmentNameFieldName: String;
      
  end;

  TDocumentChargeSheetsInfoHolder = class (TAbstractDataSetHolder)

    private

      function GetFieldNames: TDocumentChargeSheetsInfoFieldNames;
      procedure SetFieldNames(const Value: TDocumentChargeSheetsInfoFieldNames);

    protected

      function GetDocumentChargeSheetActualPerformerDepartmentCodeFieldValue: String;
      function GetDocumentChargeSheetActualPerformerDepartmentIdFieldValue: Variant;
      function GetDocumentChargeSheetActualPerformerDepartmentNameFieldValue: String;
      function GetDocumentChargeSheetActualPerformerIdFieldValue: Variant;
      function GetDocumentChargeSheetActualPerformerNameFieldValue: String;
      function GetDocumentChargeSheetActualPerformerSpecialityFieldValue: String;
      function GetDocumentChargeSheetIdFieldValue: Variant;
      function GetDocumentChargeSheetPerformerDepartmentCodeFieldValue: String;
      function GetDocumentChargeSheetPerformerDepartmentIdFieldValue: Variant;
      function GetDocumentChargeSheetPerformerDepartmentNameFieldValue: String;
      function GetDocumentChargeSheetPerformerIdFieldValue: Variant;
      function GetDocumentChargeSheetPerformerNameFieldValue: String;
      function GetDocumentChargeSheetPerformerSpecialityFieldValue: String;
      function GetDocumentChargeSheetIssuingDateTimeFieldValue: Variant;
      function GetDocumentChargeSheetPerformingDateTimeFieldValue: Variant;
      function GetDocumentChargeSheetPeriodEndFieldValue: Variant;
      function GetDocumentChargeSheetPeriodStartFieldValue: Variant;
      function GetDocumentChargeSheetResponseFieldValue: String;
      function GetDocumentChargeSheetSenderDepartmentCodeFieldValue: String;
      function GetDocumentChargeSheetSenderDepartmentIdFieldValue: Variant;
      function GetDocumentChargeSheetSenderDepartmentNameFieldValue: String;
      function GetDocumentChargeSheetSenderIdFieldValue: Variant;
      function GetDocumentChargeSheetSenderNameFieldValue: String;
      function GetDocumentChargeSheetSenderSpecialityFieldValue: String;
      function GetDocumentChargeSheetTextFieldValue: String;
      function GetTopLevelChargeSheetIdFieldValue: Variant;
      function GetDocumentChargeSheetActualPerformerIsForeignFieldValue: Boolean;
      function GetDocumentChargeSheetActualPerformerLeaderIdFieldValue: Variant;
      function GetDocumentChargeSheetPerformerIsForeignFieldValue: Boolean;
      function GetDocumentChargeSheetIsForAcquaitanceFieldValue: Variant;
      function GetDocumentChargeSheetPerformerLeaderIdFieldValue: Variant;
      function GetDocumentChargeSheetSenderIsForeignFieldValue: Boolean;
      function GetDocumentChargeSheetSenderLeaderIdFieldValue: Variant;
      function GetDocumentChargeSheetViewingDateByPerformerFieldValue: Variant;
      function GetDocumentChargeSheetPerformerRoleIdFieldValue: Variant; { временно, из-за неадаптированной предыдущей версии программы }
      function GetChargeSheetDocumentIdFieldValue: Variant;
      function GetDocumentChargeSheetKindIdFieldValue: Variant;
      function GetDocumentChargeSheetKindNameFieldValue: String;
      function GetDocumentChargeSheetServiceKindNameFieldValue: String;

      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;
      
    public

      property FieldNames: TDocumentChargeSheetsInfoFieldNames
      read GetFieldNames write SetFieldNames;

      property ChargeSheetDocumentIdFieldValue: Variant
      read GetChargeSheetDocumentIdFieldValue;
      
      property DocumentChargeSheetIdFieldValue: Variant
      read GetDocumentChargeSheetIdFieldValue;

      property DocumentChargeSheetKindIdFieldValue: Variant
      read GetDocumentChargeSheetKindIdFieldValue;

      property DocumentChargeSheetKindNameFieldValue: String
      read GetDocumentChargeSheetKindNameFieldValue;

      property DocumentChargeSheetServiceKindNameFieldName: String
      read GetDocumentChargeSheetServiceKindNameFieldValue;
      
      property TopLevelChargeSheetIdFieldValue: Variant
      read GetTopLevelChargeSheetIdFieldValue;

      property DocumentChargeSheetTextFieldValue: String
      read GetDocumentChargeSheetTextFieldValue;

      property DocumentChargeSheetResponseFieldValue: String
      read GetDocumentChargeSheetResponseFieldValue;

      property DocumentChargeSheetPeriodStartFieldValue: Variant
      read GetDocumentChargeSheetPeriodStartFieldValue;

      property DocumentChargeSheetPeriodEndFieldValue: Variant
      read GetDocumentChargeSheetPeriodEndFieldValue;

      property DocumentChargeSheetPerformingDateTimeFieldValue: Variant
      read GetDocumentChargeSheetPerformingDateTimeFieldValue;
      
      property DocumentChargeSheetPerformerIdFieldValue: Variant
      read GetDocumentChargeSheetPerformerIdFieldValue;

      { временно, из-за неадаптированной предыдущей версии программы }
      property DocumentChargeSheetPerformerRoleIdFieldValue: Variant
      read GetDocumentChargeSheetPerformerRoleIdFieldValue;

      property DocumentChargeSheetPerformerLeaderIdFieldValue: Variant
      read GetDocumentChargeSheetPerformerLeaderIdFieldValue;

      property DocumentChargeSheetPerformerIsForeignFieldValue: Boolean
      read GetDocumentChargeSheetPerformerIsForeignFieldValue;

      property DocumentChargeSheetPerformerNameFieldValue: String
      read GetDocumentChargeSheetPerformerNameFieldValue;
      
      property DocumentChargeSheetPerformerSpecialityFieldValue: String
      read GetDocumentChargeSheetPerformerSpecialityFieldValue;
      
      property DocumentChargeSheetPerformerDepartmentIdFieldValue: Variant
      read GetDocumentChargeSheetPerformerDepartmentIdFieldValue;
      
      property DocumentChargeSheetPerformerDepartmentCodeFieldValue: String
      read GetDocumentChargeSheetPerformerDepartmentCodeFieldValue;
      
      property DocumentChargeSheetPerformerDepartmentNameFieldValue: String
      read GetDocumentChargeSheetPerformerDepartmentNameFieldValue;
      
      property DocumentChargeSheetActualPerformerIdFieldValue: Variant
      read GetDocumentChargeSheetActualPerformerIdFieldValue;

      property DocumentChargeSheetActualPerformerLeaderIdFieldValue: Variant
      read GetDocumentChargeSheetActualPerformerLeaderIdFieldValue;

      property DocumentChargeSheetActualPerformerIsForeignFieldValue: Boolean
      read GetDocumentChargeSheetActualPerformerIsForeignFieldValue;
      
      property DocumentChargeSheetActualPerformerNameFieldValue: String
      read GetDocumentChargeSheetActualPerformerNameFieldValue;
      
      property DocumentChargeSheetActualPerformerSpecialityFieldValue: String
      read GetDocumentChargeSheetActualPerformerSpecialityFieldValue;
      
      property DocumentChargeSheetActualPerformerDepartmentIdFieldValue: Variant
      read GetDocumentChargeSheetActualPerformerDepartmentIdFieldValue;
      
      property DocumentChargeSheetActualPerformerDepartmentCodeFieldValue: String
      read GetDocumentChargeSheetActualPerformerDepartmentCodeFieldValue;
      
      property DocumentChargeSheetActualPerformerDepartmentNameFieldValue: String
      read GetDocumentChargeSheetActualPerformerDepartmentNameFieldValue;

      property DocumentChargeSheetSenderIdFieldValue: Variant
      read GetDocumentChargeSheetSenderIdFieldValue;

      property DocumentChargeSheetSenderLeaderIdFieldValue: Variant
      read GetDocumentChargeSheetSenderLeaderIdFieldValue;

      property DocumentChargeSheetSenderIsForeignFieldValue: Boolean
      read GetDocumentChargeSheetSenderIsForeignFieldValue;

      property DocumentChargeSheetSenderNameFieldValue: String
      read GetDocumentChargeSheetSenderNameFieldValue;
      
      property DocumentChargeSheetSenderSpecialityFieldValue: String
      read GetDocumentChargeSheetSenderSpecialityFieldValue;
      
      property DocumentChargeSheetSenderDepartmentIdFieldValue: Variant
      read GetDocumentChargeSheetSenderDepartmentIdFieldValue;
      
      property DocumentChargeSheetSenderDepartmentCodeFieldValue: String
      read GetDocumentChargeSheetSenderDepartmentCodeFieldValue;
      
      property DocumentChargeSheetSenderDepartmentNameFieldValue: String
      read GetDocumentChargeSheetSenderDepartmentNameFieldValue;

      property DocumentChargeSheetViewingDateByPerformerFieldValue: Variant
      read GetDocumentChargeSheetViewingDateByPerformerFieldValue;

      property DocumentChargeSheetIssuingDateTimeFieldValue: Variant
      read GetDocumentChargeSheetIssuingDateTimeFieldValue;

      property DocumentChargeSheetIsForAcquaitanceFieldValue: Variant
      read GetDocumentChargeSheetIsForAcquaitanceFieldValue;

  end;

implementation

uses

  Variants;

{ TDocumentChargeSheetsInfoHolder }

function TDocumentChargeSheetsInfoHolder.GetChargeSheetDocumentIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.ChargeSheetDocumentIdFieldName,
              Null
            );
            
end;


class function TDocumentChargeSheetsInfoHolder.GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass;
begin

  Result := TDocumentChargeSheetsInfoFieldNames;
  
end;

function TDocumentChargeSheetsInfoHolder.
  GetDocumentChargeSheetActualPerformerDepartmentCodeFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentChargeSheetActualPerformerDepartmentCodeFieldName,
              ''
            );
  
end;

function TDocumentChargeSheetsInfoHolder.
  GetDocumentChargeSheetActualPerformerDepartmentIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.DocumentChargeSheetActualPerformerDepartmentIdFieldName, Null);
  
end;

function TDocumentChargeSheetsInfoHolder.
  GetDocumentChargeSheetActualPerformerDepartmentNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.
                DocumentChargeSheetActualPerformerDepartmentNameFieldName,
              ''
            );
            
end;

function TDocumentChargeSheetsInfoHolder.
  GetDocumentChargeSheetActualPerformerIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.DocumentChargeSheetActualPerformerIdFieldName, Null);

end;

function TDocumentChargeSheetsInfoHolder.GetDocumentChargeSheetActualPerformerIsForeignFieldValue: Boolean;
begin

  Result := GetDataSetFieldValue(FieldNames.DocumentChargeSheetActualPerformerIsForeignFieldName, False);

end;

function TDocumentChargeSheetsInfoHolder.GetDocumentChargeSheetActualPerformerLeaderIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.DocumentChargeSheetActualPerformerLeaderIdFieldName, False);
  
end;

function TDocumentChargeSheetsInfoHolder.
  GetDocumentChargeSheetActualPerformerNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentChargeSheetActualPerformerNameFieldName,
              ''
            );
            
end;

function TDocumentChargeSheetsInfoHolder.
  GetDocumentChargeSheetActualPerformerSpecialityFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentChargeSheetActualPerformerSpecialityFieldName,
              ''
            );
            
end;

function TDocumentChargeSheetsInfoHolder.GetDocumentChargeSheetIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.DocumentChargeSheetIdFieldName, Null);
  
end;

function TDocumentChargeSheetsInfoHolder.GetDocumentChargeSheetIsForAcquaitanceFieldValue: Variant;
begin

  Result :=
    GetDataSetFieldValue(
      FieldNames.DocumentChargeSheetIsForAcquaitanceFieldName,
      False
    );

end;

function TDocumentChargeSheetsInfoHolder.GetDocumentChargeSheetViewingDateByPerformerFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentChargeSheetViewingDateByPerformerFieldName,
              Null
            );

end;

function TDocumentChargeSheetsInfoHolder.GetFieldNames: TDocumentChargeSheetsInfoFieldNames;
begin

  Result := TDocumentChargeSheetsInfoFieldNames(inherited FieldDefs);
  
end;

function TDocumentChargeSheetsInfoHolder.
  GetDocumentChargeSheetIssuingDateTimeFieldValue: Variant;
begin

  Result :=
    GetDataSetFieldValue(
      FieldNames.DocumentChargeSheetIssuingDateTimeFieldName,
      Null
    );
    
end;

function TDocumentChargeSheetsInfoHolder.GetDocumentChargeSheetKindIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.DocumentChargeSheetKindIdFieldName, Null);

end;

function TDocumentChargeSheetsInfoHolder.GetDocumentChargeSheetKindNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.DocumentChargeSheetKindNameFieldName, '');

end;

function TDocumentChargeSheetsInfoHolder.
  GetDocumentChargeSheetPerformerDepartmentCodeFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentChargeSheetPerformerDepartmentCodeFieldName,
              ''
            );
            
end;

function TDocumentChargeSheetsInfoHolder.
  GetDocumentChargeSheetPerformerDepartmentIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentChargeSheetPerformerDepartmentIdFieldName,
              Null
            );

end;

function TDocumentChargeSheetsInfoHolder.
  GetDocumentChargeSheetPerformerDepartmentNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentChargeSheetPerformerDepartmentNameFieldName,
              ''
            );
            
end;

function TDocumentChargeSheetsInfoHolder.
  GetDocumentChargeSheetPerformerIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentChargeSheetPerformerIdFieldName,
              Null
            );
            
end;

function TDocumentChargeSheetsInfoHolder.GetDocumentChargeSheetPerformerIsForeignFieldValue: Boolean;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentChargeSheetPerformerIsForeignFieldName,
              False
            );
            
end;

function TDocumentChargeSheetsInfoHolder.GetDocumentChargeSheetPerformerLeaderIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentChargeSheetPerformerLeaderIdFieldName,
              Null
            );
            
end;

function TDocumentChargeSheetsInfoHolder.
  GetDocumentChargeSheetPerformerNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentChargeSheetPerformerNameFieldName,
              ''
            );

end;

function TDocumentChargeSheetsInfoHolder.GetDocumentChargeSheetPerformerRoleIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentChargeSheetPerformerRoleIdFieldName,
              Null
            );
            
end;

function TDocumentChargeSheetsInfoHolder.
  GetDocumentChargeSheetPerformerSpecialityFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentChargeSheetPerformerSpecialityFieldName,
              ''
            );
            
end;

function TDocumentChargeSheetsInfoHolder.
  GetDocumentChargeSheetPerformingDateTimeFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentChargeSheetPerformingDateTimeFieldName,
              Null
            );
            
end;

function TDocumentChargeSheetsInfoHolder.
  GetDocumentChargeSheetPeriodEndFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentChargeSheetPeriodEndFieldName,
              Null
            );
            
end;

function TDocumentChargeSheetsInfoHolder.
  GetDocumentChargeSheetPeriodStartFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentChargeSheetPeriodStartFieldName,
              Null
            );
            
end;

function TDocumentChargeSheetsInfoHolder.
  GetDocumentChargeSheetResponseFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentChargeSheetResponseFieldName,
              ''
            );
            
end;

function TDocumentChargeSheetsInfoHolder.
  GetDocumentChargeSheetSenderDepartmentCodeFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentChargeSheetSenderDepartmentCodeFieldName,
              ''
            );
            
end;

function TDocumentChargeSheetsInfoHolder.
  GetDocumentChargeSheetSenderDepartmentIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentChargeSheetSenderDepartmentIdFieldName,
              Null
            );
            
end;

function TDocumentChargeSheetsInfoHolder.
  GetDocumentChargeSheetSenderDepartmentNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentChargeSheetSenderDepartmentNameFieldName,
              ''
            );

end;

function TDocumentChargeSheetsInfoHolder.
  GetDocumentChargeSheetSenderIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentChargeSheetSenderIdFieldName,
              Null
            );
            
end;

function TDocumentChargeSheetsInfoHolder.GetDocumentChargeSheetSenderIsForeignFieldValue: Boolean;
begin

  Result := GetDataSetFieldValue(FieldNames.DocumentChargeSheetSenderIsForeignFieldName, False);

end;

function TDocumentChargeSheetsInfoHolder.GetDocumentChargeSheetSenderLeaderIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.DocumentChargeSheetSenderLeaderIdFieldName, Null);
  
end;

function TDocumentChargeSheetsInfoHolder.
  GetDocumentChargeSheetSenderNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentChargeSheetSenderNameFieldName,
              ''
            );
            
end;

function TDocumentChargeSheetsInfoHolder.
  GetDocumentChargeSheetSenderSpecialityFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentChargeSheetSenderSpecialityFieldName,
              ''
            );
            
end;

function TDocumentChargeSheetsInfoHolder.GetDocumentChargeSheetServiceKindNameFieldValue: String;
begin

  Result :=
    GetDataSetFieldValue(FieldNames.DocumentChargeSheetServiceKindNameFieldName, '');
    
end;

function TDocumentChargeSheetsInfoHolder.
  GetDocumentChargeSheetTextFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentChargeSheetTextFieldName,
              ''
            );
            
end;

function TDocumentChargeSheetsInfoHolder.GetTopLevelChargeSheetIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.TopLevelDocumentChargeSheetIdFieldName,
              Null
            );

end;

procedure TDocumentChargeSheetsInfoHolder.SetFieldNames(
  const Value: TDocumentChargeSheetsInfoFieldNames);
begin

  inherited FieldDefs := Value;

end;

end.
