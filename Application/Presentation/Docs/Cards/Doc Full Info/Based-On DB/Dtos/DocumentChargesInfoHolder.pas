unit DocumentChargesInfoHolder;

interface

uses

  DB,
  DocumentApprovingsInfoHolder,
  AbstractDataSetHolder,
  SysUtils,
  Classes;

type

  TDocumentChargesInfoFieldNames = class (TAbstractDataSetFieldDefs)

    public

      DocumentChargeIdFieldName: String;
      DocumentChargeKindIdFieldName: String;
      DocumentChargeKindNameFieldName: String;
      DocumentChargeServiceKindNameFieldName: String;
      DocumentChargeTextFieldName: String;
      DocumentChargeIsForAcquaitanceFieldName: String;
      DocumentChargeResponseFieldName: String;
      DocumentChargePeriodStartFieldName: String;
      DocumentChargePeriodEndFieldName: String;
      DocumentChargePerformingDateTimeFieldName: String;
      DocumentChargePerformerIdFieldName: String;
      DocumentChargePerformerLeaderIdFieldName: String;
      DocumentChargePerformerIsForeignFieldName: String;
      DocumentChargePerformerNameFieldName: String;
      DocumentChargePerformerSpecialityFieldName: String;
      DocumentChargePerformerDepartmentIdFieldName: String;
      DocumentChargePerformerDepartmentCodeFieldName: String;
      DocumentChargePerformerDepartmentNameFieldName: String;

      DocumentChargeActualPerformerIdFieldName: String;
      DocumentChargeActualPerformerLeaderIdFieldName: String;
      DocumentChargeActualPerformerIsForeignFieldName: String;
      DocumentChargeActualPerformerNameFieldName: String;
      DocumentChargeActualPerformerSpecialityFieldName: String;
      DocumentChargeActualPerformerDepartmentIdFieldName: String;
      DocumentChargeActualPerformerDepartmentCodeFieldName: String;
      DocumentChargeActualPerformerDepartmentNameFieldName: String;

  end;

  TDocumentChargesInfoHolder = class (TAbstractDataSetHolder)

    private
    
      function GetFieldNames: TDocumentChargesInfoFieldNames;
      procedure SetFieldNames(const Value: TDocumentChargesInfoFieldNames);

    protected

      function GetDocumentChargeIsForAcquaitanceFieldValue: Boolean;
      function GetDocumentChargeActualPerformerDepartmentCodeFieldValue: String;
      function GetDocumentChargeActualPerformerDepartmentIdFieldValue: Variant;
      function GetDocumentChargeActualPerformerDepartmentNameFieldValue: String;
      function GetDocumentChargeActualPerformerIdFieldValue: Variant;
      function GetDocumentChargeActualPerformerNameFieldValue: String;
      function GetDocumentChargeActualPerformerSpecialityFieldValue: String;
      function GetDocumentChargeIdFieldValue: Variant;
      function GetDocumentChargePerformerDepartmentCodeFieldValue: String;
      function GetDocumentChargePerformerDepartmentIdFieldValue: Variant;
      function GetDocumentChargePerformerDepartmentNameFieldValue: String;
      function GetDocumentChargePerformerIdFieldValue: Variant;
      function GetDocumentChargePerformerNameFieldValue: String;
      function GetDocumentChargePerformerSpecialityFieldValue: String;
      function GetDocumentChargePerformingDateTimeFieldValue: Variant;
      function GetDocumentChargePeriodEndFieldValue: Variant;
      function GetDocumentChargePeriodStartFieldValue: Variant;
      function GetDocumentChargeResponseFieldValue: String;
      function GetDocumentChargeTextFieldValue: String;
      function GetDocumentChargeActualPerformerIsForeignFieldValue: Boolean;
      function GetDocumentChargeActualPerformerLeaderIdFieldValue: Variant;
      function GetDocumentChargePerformerIsForeignFieldValue: Boolean;
      function GetDocumentChargePerformerLeaderIdFieldValue: Variant;
      function GetDocumentChargeKindIdFieldValue: Variant;
      function GetDocumentChargeKindNameFieldValue: String;
      function GetDocumentChargeServiceKindNameFieldValue: String;

      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;
      
    public

      property FieldNames: TDocumentChargesInfoFieldNames
      read GetFieldNames write SetFieldNames;

      property DocumentChargeIdFieldValue: Variant
      read GetDocumentChargeIdFieldValue;

      property DocumentChargeKindIdFieldValue: Variant
      read GetDocumentChargeKindIdFieldValue;
      
      property DocumentChargeKindNameFieldValue: String
      read GetDocumentChargeKindNameFieldValue;

      property DocumentChargeServiceKindNameFieldValue: String
      read GetDocumentChargeServiceKindNameFieldValue;
      
      property DocumentChargeTextFieldValue: String
      read GetDocumentChargeTextFieldValue;

      property DocumentChargeIsForAcquaitanceFieldValue: Boolean
      read GetDocumentChargeIsForAcquaitanceFieldValue;
      
      property DocumentChargeResponseFieldValue: String
      read GetDocumentChargeResponseFieldValue;
      
      property DocumentChargePeriodStartFieldValue: Variant
      read GetDocumentChargePeriodStartFieldValue;

      property DocumentChargePeriodEndFieldValue: Variant
      read GetDocumentChargePeriodEndFieldValue;

      property DocumentChargePerformingDateTimeFieldValue: Variant
      read GetDocumentChargePerformingDateTimeFieldValue;
      
      property DocumentChargePerformerIdFieldValue: Variant
      read GetDocumentChargePerformerIdFieldValue;

      property DocumentChargePerformerLeaderIdFieldValue: Variant
      read GetDocumentChargePerformerLeaderIdFieldValue;

      property DocumentChargePerformerIsForeignFieldValue: Boolean
      read GetDocumentChargePerformerIsForeignFieldValue;
      
      property DocumentChargePerformerNameFieldValue: String
      read GetDocumentChargePerformerNameFieldValue;
      
      property DocumentChargePerformerSpecialityFieldValue: String
      read GetDocumentChargePerformerSpecialityFieldValue;
      
      property DocumentChargePerformerDepartmentIdFieldValue: Variant
      read GetDocumentChargePerformerDepartmentIdFieldValue;
      
      property DocumentChargePerformerDepartmentCodeFieldValue: String
      read GetDocumentChargePerformerDepartmentCodeFieldValue;
      
      property DocumentChargePerformerDepartmentNameFieldValue: String
      read GetDocumentChargePerformerDepartmentNameFieldValue;
      
      property DocumentChargeActualPerformerIdFieldValue: Variant
      read GetDocumentChargeActualPerformerIdFieldValue;

      property DocumentChargeActualPerformerLeaderIdFieldValue: Variant
      read GetDocumentChargeActualPerformerLeaderIdFieldValue;

      property DocumentChargeActualPerformerIsForeignFieldValue: Boolean
      read GetDocumentChargeActualPerformerIsForeignFieldValue;

      property DocumentChargeActualPerformerNameFieldValue: String
      read GetDocumentChargeActualPerformerNameFieldValue;
      
      property DocumentChargeActualPerformerSpecialityFieldValue: String
      read GetDocumentChargeActualPerformerSpecialityFieldValue;
      
      property DocumentChargeActualPerformerDepartmentIdFieldValue: Variant
      read GetDocumentChargeActualPerformerDepartmentIdFieldValue;
      
      property DocumentChargeActualPerformerDepartmentCodeFieldValue: String
      read GetDocumentChargeActualPerformerDepartmentCodeFieldValue;
      
      property DocumentChargeActualPerformerDepartmentNameFieldValue: String
      read GetDocumentChargeActualPerformerDepartmentNameFieldValue;
      
  end;

implementation

uses

  Variants;
{ TDocumentChargesInfoHolder }


class function TDocumentChargesInfoHolder.GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass;
begin

  Result := TDocumentChargesInfoFieldNames;
  
end;

function TDocumentChargesInfoHolder.GetDocumentChargeActualPerformerDepartmentCodeFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.DocumentChargeActualPerformerDepartmentCodeFieldName, '');

end;

function TDocumentChargesInfoHolder.GetDocumentChargeActualPerformerDepartmentIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.DocumentChargeActualPerformerDepartmentIdFieldName, Null);

end;

function TDocumentChargesInfoHolder.GetDocumentChargeActualPerformerDepartmentNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.DocumentChargeActualPerformerDepartmentNameFieldName, '');

end;

function TDocumentChargesInfoHolder.GetDocumentChargeActualPerformerIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.DocumentChargeActualPerformerIdFieldName, '');

end;

function TDocumentChargesInfoHolder.GetDocumentChargeActualPerformerIsForeignFieldValue: Boolean;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentChargeActualPerformerIsForeignFieldName,
              False
            );
            
end;

function TDocumentChargesInfoHolder.GetDocumentChargeActualPerformerLeaderIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentChargeActualPerformerLeaderIdFieldName,
              Null
            );
            
end;

function TDocumentChargesInfoHolder.GetDocumentChargeActualPerformerNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.DocumentChargeActualPerformerNameFieldName, '');

end;

function TDocumentChargesInfoHolder.GetDocumentChargeActualPerformerSpecialityFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.DocumentChargeActualPerformerSpecialityFieldName, '');

end;

function TDocumentChargesInfoHolder.GetDocumentChargeIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.DocumentChargeIdFieldName, Null);

end;

function TDocumentChargesInfoHolder.GetDocumentChargeIsForAcquaitanceFieldValue: Boolean;
begin

  Result :=
    GetDataSetFieldValue(
      FieldNames.DocumentChargeIsForAcquaitanceFieldName, False
    );

end;

function TDocumentChargesInfoHolder.GetDocumentChargeKindIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.DocumentChargeKindIdFieldName, Null);

end;

function TDocumentChargesInfoHolder.GetDocumentChargeKindNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.DocumentChargeKindNameFieldName, '');
  
end;

function TDocumentChargesInfoHolder.GetDocumentChargePerformerDepartmentCodeFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.DocumentChargePerformerDepartmentCodeFieldName, '');

end;

function TDocumentChargesInfoHolder.GetDocumentChargePerformerDepartmentIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.DocumentChargePerformerDepartmentIdFieldName, Null);

end;

function TDocumentChargesInfoHolder.GetDocumentChargePerformerDepartmentNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.DocumentChargePerformerDepartmentNameFieldName, '');

end;

function TDocumentChargesInfoHolder.GetDocumentChargePerformerIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.DocumentChargePerformerIdFieldName, Null);

end;

function TDocumentChargesInfoHolder.GetDocumentChargePerformerIsForeignFieldValue: Boolean;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentChargePerformerIsForeignFieldName,
              False
            );
            
end;

function TDocumentChargesInfoHolder.GetDocumentChargePerformerLeaderIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentChargePerformerLeaderIdFieldName,
              Null
            );
            
end;

function TDocumentChargesInfoHolder.GetDocumentChargePerformerNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.DocumentChargePerformerNameFieldName, '');
  
end;

function TDocumentChargesInfoHolder.GetDocumentChargePerformerSpecialityFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.DocumentChargePerformerSpecialityFieldName, '');
  
end;

function TDocumentChargesInfoHolder.GetDocumentChargePerformingDateTimeFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.DocumentChargePerformingDateTimeFieldName, Null);
  
end;

function TDocumentChargesInfoHolder.GetDocumentChargePeriodEndFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.DocumentChargePeriodEndFieldName, Null);

end;

function TDocumentChargesInfoHolder.GetDocumentChargePeriodStartFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.DocumentChargePeriodStartFieldName, Null);

end;

function TDocumentChargesInfoHolder.GetDocumentChargeResponseFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.DocumentChargeResponseFieldName, '');

end;

function TDocumentChargesInfoHolder.GetDocumentChargeServiceKindNameFieldValue: String;
begin

  Result :=
    GetDataSetFieldValue(FieldNames.DocumentChargeServiceKindNameFieldName, '');
    
end;

function TDocumentChargesInfoHolder.GetDocumentChargeTextFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.DocumentChargeTextFieldName, '');
  
end;

function TDocumentChargesInfoHolder.GetFieldNames: TDocumentChargesInfoFieldNames;
begin

  Result := TDocumentChargesInfoFieldNames(inherited FieldDefs);

end;

procedure TDocumentChargesInfoHolder.SetFieldNames(
  const Value: TDocumentChargesInfoFieldNames);
begin

  inherited FieldDefs := Value;
  
end;

end.
