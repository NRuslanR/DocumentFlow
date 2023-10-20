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

    protected

      function GetIdFieldName: String;
      procedure SetIdFieldName(const Value: String);
    
    public

      KindIdFieldName: String;
      KindNameFieldName: String;
      ServiceKindNameFieldName: String;
      ChargeTextFieldName: String;
      IsForAcquaitanceFieldName: String;
      ResponseFieldName: String;
      TimeFrameStartFieldName: String;
      TimeFrameDeadlineFieldName: String;
      PerformingDateTimeFieldName: String;
      PerformerIdFieldName: String;
      PerformerIsForeignFieldName: String;
      PerformerNameFieldName: String;
      PerformerSpecialityFieldName: String;
      PerformerDepartmentIdFieldName: String;
      PerformerDepartmentCodeFieldName: String;
      PerformerDepartmentNameFieldName: String;

      ActualPerformerIdFieldName: String;
      ActualPerformerIsForeignFieldName: String;
      ActualPerformerNameFieldName: String;
      ActualPerformerSpecialityFieldName: String;
      ActualPerformerDepartmentIdFieldName: String;
      ActualPerformerDepartmentCodeFieldName: String;
      ActualPerformerDepartmentNameFieldName: String;

      property IdFieldName: String read GetIdFieldName write SetIdFieldName;

  end;

  TDocumentChargesInfoHolder = class (TAbstractDataSetHolder)

    private
    
      function GetFieldNames: TDocumentChargesInfoFieldNames;
      procedure SetFieldNames(const Value: TDocumentChargesInfoFieldNames);

    protected

      function GetIsForAcquaitanceFieldValue: Boolean;
      function GetActualPerformerDepartmentCodeFieldValue: String;
      function GetActualPerformerDepartmentIdFieldValue: Variant;
      function GetActualPerformerDepartmentNameFieldValue: String;
      function GetActualPerformerIdFieldValue: Variant;
      function GetActualPerformerNameFieldValue: String;
      function GetActualPerformerSpecialityFieldValue: String;
      function GetIdFieldValue: Variant;
      function GetPerformerDepartmentCodeFieldValue: String;
      function GetPerformerDepartmentIdFieldValue: Variant;
      function GetPerformerDepartmentNameFieldValue: String;
      function GetPerformerIdFieldValue: Variant;
      function GetPerformerNameFieldValue: String;
      function GetPerformerSpecialityFieldValue: String;
      function GetPerformingDateTimeFieldValue: Variant;
      function GetTimeFrameDeadlineFieldValue: Variant;
      function GetTimeFrameStartFieldValue: Variant;
      function GetResponseFieldValue: String;
      function GetChargeTextFieldValue: String;
      function GetActualPerformerIsForeignFieldValue: Boolean;
      function GetPerformerIsForeignFieldValue: Boolean;
      function GetKindIdFieldValue: Variant;
      function GetKindNameFieldValue: String;
      function GetServiceKindNameFieldValue: String;

      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;
      
    public

      property FieldNames: TDocumentChargesInfoFieldNames
      read GetFieldNames write SetFieldNames;

      property IdFieldValue: Variant
      read GetIdFieldValue;

      property KindIdFieldValue: Variant
      read GetKindIdFieldValue;
      
      property KindNameFieldValue: String
      read GetKindNameFieldValue;

      property ServiceKindNameFieldValue: String
      read GetServiceKindNameFieldValue;
      
      property ChargeTextFieldValue: String
      read GetChargeTextFieldValue;

      property IsForAcquaitanceFieldValue: Boolean
      read GetIsForAcquaitanceFieldValue;
      
      property ResponseFieldValue: String
      read GetResponseFieldValue;
      
      property TimeFrameStartFieldValue: Variant
      read GetTimeFrameStartFieldValue;

      property TimeFrameDeadlineFieldValue: Variant
      read GetTimeFrameDeadlineFieldValue;

      property PerformingDateTimeFieldValue: Variant
      read GetPerformingDateTimeFieldValue;
      
      property PerformerIdFieldValue: Variant
      read GetPerformerIdFieldValue;

      property PerformerIsForeignFieldValue: Boolean
      read GetPerformerIsForeignFieldValue;
      
      property PerformerNameFieldValue: String
      read GetPerformerNameFieldValue;
      
      property PerformerSpecialityFieldValue: String
      read GetPerformerSpecialityFieldValue;
      
      property PerformerDepartmentIdFieldValue: Variant
      read GetPerformerDepartmentIdFieldValue;
      
      property PerformerDepartmentCodeFieldValue: String
      read GetPerformerDepartmentCodeFieldValue;
      
      property PerformerDepartmentNameFieldValue: String
      read GetPerformerDepartmentNameFieldValue;
      
      property ActualPerformerIdFieldValue: Variant
      read GetActualPerformerIdFieldValue;
      
      property ActualPerformerIsForeignFieldValue: Boolean
      read GetActualPerformerIsForeignFieldValue;

      property ActualPerformerNameFieldValue: String
      read GetActualPerformerNameFieldValue;
      
      property ActualPerformerSpecialityFieldValue: String
      read GetActualPerformerSpecialityFieldValue;
      
      property ActualPerformerDepartmentIdFieldValue: Variant
      read GetActualPerformerDepartmentIdFieldValue;
      
      property ActualPerformerDepartmentCodeFieldValue: String
      read GetActualPerformerDepartmentCodeFieldValue;
      
      property ActualPerformerDepartmentNameFieldValue: String
      read GetActualPerformerDepartmentNameFieldValue;
      
  end;

implementation

uses

  Variants;
{ TDocumentChargesInfoHolder }


class function TDocumentChargesInfoHolder.GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass;
begin

  Result := TDocumentChargesInfoFieldNames;
  
end;

function TDocumentChargesInfoHolder.GetActualPerformerDepartmentCodeFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.ActualPerformerDepartmentCodeFieldName, '');

end;

function TDocumentChargesInfoHolder.GetActualPerformerDepartmentIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.ActualPerformerDepartmentIdFieldName, Null);

end;

function TDocumentChargesInfoHolder.GetActualPerformerDepartmentNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.ActualPerformerDepartmentNameFieldName, '');

end;

function TDocumentChargesInfoHolder.GetActualPerformerIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.ActualPerformerIdFieldName, '');

end;

function TDocumentChargesInfoHolder.GetActualPerformerIsForeignFieldValue: Boolean;
begin

  Result := GetDataSetFieldValue(
              FieldNames.ActualPerformerIsForeignFieldName,
              False
            );
            
end;

function TDocumentChargesInfoHolder.GetActualPerformerNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.ActualPerformerNameFieldName, '');

end;

function TDocumentChargesInfoHolder.GetActualPerformerSpecialityFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.ActualPerformerSpecialityFieldName, '');

end;

function TDocumentChargesInfoHolder.GetIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.IdFieldName, Null);

end;

function TDocumentChargesInfoHolder.GetIsForAcquaitanceFieldValue: Boolean;
begin

  Result :=
    GetDataSetFieldValue(
      FieldNames.IsForAcquaitanceFieldName, False
    );

end;

function TDocumentChargesInfoHolder.GetKindIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.KindIdFieldName, Null);

end;

function TDocumentChargesInfoHolder.GetKindNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.KindNameFieldName, '');
  
end;

function TDocumentChargesInfoHolder.GetPerformerDepartmentCodeFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.PerformerDepartmentCodeFieldName, '');

end;

function TDocumentChargesInfoHolder.GetPerformerDepartmentIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.PerformerDepartmentIdFieldName, Null);

end;

function TDocumentChargesInfoHolder.GetPerformerDepartmentNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.PerformerDepartmentNameFieldName, '');

end;

function TDocumentChargesInfoHolder.GetPerformerIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.PerformerIdFieldName, Null);

end;

function TDocumentChargesInfoHolder.GetPerformerIsForeignFieldValue: Boolean;
begin

  Result := GetDataSetFieldValue(
              FieldNames.PerformerIsForeignFieldName,
              False
            );
            
end;

function TDocumentChargesInfoHolder.GetPerformerNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.PerformerNameFieldName, '');
  
end;

function TDocumentChargesInfoHolder.GetPerformerSpecialityFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.PerformerSpecialityFieldName, '');
  
end;

function TDocumentChargesInfoHolder.GetPerformingDateTimeFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.PerformingDateTimeFieldName, Null);
  
end;

function TDocumentChargesInfoHolder.GetTimeFrameDeadlineFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.TimeFrameDeadlineFieldName, Null);

end;

function TDocumentChargesInfoHolder.GetTimeFrameStartFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.TimeFrameStartFieldName, Null);

end;

function TDocumentChargesInfoHolder.GetResponseFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.ResponseFieldName, '');

end;

function TDocumentChargesInfoHolder.GetServiceKindNameFieldValue: String;
begin

  Result :=
    GetDataSetFieldValue(FieldNames.ServiceKindNameFieldName, '');
    
end;

function TDocumentChargesInfoHolder.GetChargeTextFieldValue: String;
begin

  Result := GetDataSetFieldValue(FieldNames.ChargeTextFieldName, '');
  
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

{ TDocumentChargesInfoFieldNames }

function TDocumentChargesInfoFieldNames.GetIdFieldName: String;
begin

  Result := RecordIdFieldName;

end;

procedure TDocumentChargesInfoFieldNames.SetIdFieldName(const Value: String);
begin

  RecordIdFieldName := Value;
  
end;

end.
