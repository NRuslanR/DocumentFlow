unit DocumentChargeSheetsInfoHolder;

interface

uses

  DB,
  DocumentChargesInfoHolder,
  AbstractDataSetHolder,
  Disposable,
  SysUtils;

type

  TDocumentChargeSheetsInfoFieldNames = class (TAbstractDataSetFieldDefs)

    private

      function GetActualPerformerDepartmentCodeFieldName: String;
      function GetActualPerformerDepartmentIdFieldName: String;
      function GetActualPerformerDepartmentNameFieldName: String;
      function GetActualPerformerIdFieldName: String;
      function GetActualPerformerNameFieldName: String;
      function GetActualPerformerIsForeignFieldName: String;
      function GetActualPerformerSpecialityFieldName: String;
      function GetChargeTextFieldName: String;
      function GetIsForAcquaitanceFieldName: String;
      function GetKindIdFieldName: String;
      function GetKindNameFieldName: String;
      function GetPerformerDepartmentCodeFieldName: String;
      function GetPerformerDepartmentIdFieldName: String;
      function GetPerformerDepartmentNameFieldName: String;
      function GetPerformerIdFieldName: String;
      function GetPerformerIsForeignFieldName: String;
      function GetPerformerNameFieldName: String;
      function GetPerformerSpecialityFieldName: String;
      function GetPerformingDateTimeFieldName: String;
      function GetResponseFieldName: String;
      function GetServiceKindNameFieldName: String;
      function GetTimeFrameDeadlineFieldName: String;
      function GetTimeFrameStartFieldName: String;
      procedure SetActualPerformerDepartmentCodeFieldName(const Value: String);
      procedure SetActualPerformerDepartmentIdFieldName(const Value: String);
      procedure SetActualPerformerDepartmentNameFieldName(const Value: String);
      procedure SetActualPerformerIdFieldName(const Value: String);
      procedure SetActualPerformerNameFieldName(const Value: String);

      procedure SetActualPerformerIsForeignFieldName(
        const Value: String);
      procedure SetActualPerformerSpecialityFieldName(const Value: String);

      procedure SetChargeInfoFieldDefs(
        const Value: TDocumentChargesInfoFieldNames);

      procedure SetChargeTextFieldName(const Value: String);
      procedure SetIsForAcquaitanceFieldName(const Value: String);
      procedure SetKindIdFieldName(const Value: String);
      procedure SetKindNameFieldName(const Value: String);
      procedure SetPerformerDepartmentCodeFieldName(const Value: String);
      procedure SetPerformerDepartmentIdFieldName(const Value: String);
      procedure SetPerformerDepartmentNameFieldName(const Value: String);
      procedure SetPerformerIdFieldName(const Value: String);
      procedure SetPerformerIsForeignFieldName(const Value: String);
      procedure SetPerformerNameFieldName(const Value: String);
      procedure SetPerformerSpecialityFieldName(const Value: String);
      procedure SetPerformingDateTimeFieldName(const Value: String);
      procedure SetResponseFieldName(const Value: String);
      procedure SetServiceKindNameFieldName(const Value: String);
      procedure SetTimeFrameDeadlineFieldName(const Value: String);
      procedure SetTimeFrameStartFieldName(const Value: String);

      function GetChargeIdFieldName: String;
      procedure SetChargeIdFieldName(const Value: String);
      
      function GetIdFieldName: String;
      procedure SetIdFieldName(const Value: String);

    protected

      FChargeInfoFieldDefs: TDocumentChargesInfoFieldNames;
      FFreeChargeInfoFieldDefs: IDisposable;

    public

      DocumentIdFieldName: String;
      DocumentKindIdFieldName: String;
      TopLevelChargeSheetIdFieldName: String;
      ViewDateByPerformerFieldName: String;
      IssuingDateTimeFieldName: String;
      IssuerIdFieldName: String;
      IssuerIsForeignFieldName: String;
      IssuerNameFieldName: String;
      IssuerSpecialityFieldName: String;
      IssuerDepartmentIdFieldName: String;
      IssuerDepartmentCodeFieldName: String;
      IssuerDepartmentNameFieldName: String;

      ViewingAllowedFieldName: String;
      ChargeSectionAccessibleFieldName: String;
      ResponseSectionAccessibleFieldName: String;
      RemovingAllowedFieldName: String;
      PerformingAllowedFieldName: String;
      IsEmployeePerformerFieldName: String;
      SubordinateChargeSheetsIssuingAllowedFieldName: String;
      
    public

      property IdFieldName: String read GetIdFieldName write SetIdFieldName;
      
      property ChargeInfoFieldDefs: TDocumentChargesInfoFieldNames
      read FChargeInfoFieldDefs write SetChargeInfoFieldDefs;

      property ChargeIdFieldName: String
      read GetChargeIdFieldName write SetChargeIdFieldName;
      
      property KindIdFieldName: String
      read GetKindIdFieldName write SetKindIdFieldName;

      property KindNameFieldName: String
      read GetKindNameFieldName write SetKindNameFieldName;

      property ServiceKindNameFieldName: String
      read GetServiceKindNameFieldName write SetServiceKindNameFieldName;

      property ChargeTextFieldName: String
      read GetChargeTextFieldName write SetChargeTextFieldName;

      property IsForAcquaitanceFieldName: String
      read GetIsForAcquaitanceFieldName write SetIsForAcquaitanceFieldName;

      property ResponseFieldName: String
      read GetResponseFieldName write SetResponseFieldName;

      property TimeFrameStartFieldName: String
      read GetTimeFrameStartFieldName write SetTimeFrameStartFieldName;

      property TimeFrameDeadlineFieldName: String
      read GetTimeFrameDeadlineFieldName write SetTimeFrameDeadlineFieldName;

      property PerformingDateTimeFieldName: String
      read GetPerformingDateTimeFieldName write SetPerformingDateTimeFieldName;

      property PerformerIdFieldName: String
      read GetPerformerIdFieldName write SetPerformerIdFieldName;

      property PerformerIsForeignFieldName: String
      read GetPerformerIsForeignFieldName write SetPerformerIsForeignFieldName;

      property PerformerNameFieldName: String
      read GetPerformerNameFieldName write SetPerformerNameFieldName;

      property PerformerSpecialityFieldName: String
      read GetPerformerSpecialityFieldName write SetPerformerSpecialityFieldName;

      property PerformerDepartmentIdFieldName: String
      read GetPerformerDepartmentIdFieldName write SetPerformerDepartmentIdFieldName;

      property PerformerDepartmentCodeFieldName: String
      read GetPerformerDepartmentCodeFieldName write SetPerformerDepartmentCodeFieldName;

      property PerformerDepartmentNameFieldName: String
      read GetPerformerDepartmentNameFieldName write SetPerformerDepartmentNameFieldName;

      property ActualPerformerIdFieldName: String
      read GetActualPerformerIdFieldName write SetActualPerformerIdFieldName;

      property ActualPerformerIsForeignFieldName: String
      read GetActualPerformerIsForeignFieldName write SetActualPerformerIsForeignFieldName;

      property ActualPerformerNameFieldName: String
      read GetActualPerformerNameFieldName write SetActualPerformerNameFieldName;

      property ActualPerformerSpecialityFieldName: String
      read GetActualPerformerSpecialityFieldName write SetActualPerformerSpecialityFieldName;

      property ActualPerformerDepartmentIdFieldName: String
      read GetActualPerformerDepartmentIdFieldName write SetActualPerformerDepartmentIdFieldName;

      property ActualPerformerDepartmentCodeFieldName: String
      read GetActualPerformerDepartmentCodeFieldName write SetActualPerformerDepartmentCodeFieldName;

      property ActualPerformerDepartmentNameFieldName: String
      read GetActualPerformerDepartmentNameFieldName write SetActualPerformerDepartmentNameFieldName;
      
  end;

  TDocumentChargeSheetsInfoHolder = class (TAbstractDataSetHolder)

    private

      function GetFieldNames: TDocumentChargeSheetsInfoFieldNames;
      procedure SetFieldNames(const Value: TDocumentChargeSheetsInfoFieldNames);
      
      function GetActualPerformerDepartmentCodeFieldValue: String;
      function GetActualPerformerDepartmentIdFieldValue: Variant;
      function GetActualPerformerDepartmentNameFieldValue: String;
      function GetActualPerformerIdFieldValue: Variant;
      function GetActualPerformerIsForeignFieldValue: Boolean;
      function GetActualPerformerNameFieldValue: String;
      function GetActualPerformerSpecialityFieldValue: String;
      function GetChargeTextFieldValue: String;
      function GetIdFieldValue: Variant;
      function GetIsForAcquaitanceFieldValue: Boolean;
      function GetKindIdFieldValue: Variant;
      function GetKindNameFieldValue: String;
      function GetPerformerDepartmentCodeFieldValue: String;
      function GetPerformerDepartmentIdFieldValue: Variant;
      function GetPerformerDepartmentNameFieldValue: String;
      function GetPerformerIdFieldValue: Variant;
      function GetPerformerIsForeignFieldValue: Boolean;
      function GetPerformerNameFieldValue: String;
      function GetPerformerSpecialityFieldValue: String;
      function GetPerformingDateTimeFieldValue: Variant;
      function GetResponseFieldValue: String;
      function GetServiceKindNameFieldValue: String;
      function GetTimeFrameDeadlineFieldValue: Variant;
      function GetTimeFrameStartFieldValue: Variant;
      
      procedure SetChargesInfoHolder(const Value: TDocumentChargesInfoHolder);

      function GetChargeSectionAccessibleFieldValue: Boolean;
      function GetPerformingAllowedFieldValue: Boolean;
      function GetRemovingAllowedFieldValue: Boolean;
      function GetResponseSectionAccessibleFieldValue: Boolean;
      function GetViewingAllowedFieldValue: Boolean;
      function GetDocumentKindIdFieldValue: Variant;
      function GetIsEmployeePerformerFieldValue: Boolean;
      function GetSubordinateChargeSheetsIssuingAllowedFieldValue: Boolean;

    protected

      function GetChargeIdFieldValue: Variant;
      function GetIssuingDateTimeFieldValue: Variant;
      function GetIssuerDepartmentCodeFieldValue: String;
      function GetIssuerDepartmentIdFieldValue: Variant;
      function GetIssuerDepartmentNameFieldValue: String;
      function GetIssuerIdFieldValue: Variant;
      function GetIssuerNameFieldValue: String;
      function GetIssuerSpecialityFieldValue: String;
      function GetTopLevelChargeSheetIdFieldValue: Variant;
      function GetIssuerIsForeignFieldValue: Boolean;
      function GetViewDateByPerformerFieldValue: Variant;
      function GetDocumentIdFieldValue: Variant;

      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;

    protected

      FChargesInfoHolder: TDocumentChargesInfoHolder;
      FFreeChargesInfoHolder: IDisposable;

    public

      property ChargesInfoHolder: TDocumentChargesInfoHolder
      read FChargesInfoHolder write SetChargesInfoHolder;
      
    public

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
      
    public

      property FieldNames: TDocumentChargeSheetsInfoFieldNames
      read GetFieldNames write SetFieldNames;

      property DocumentIdFieldValue: Variant
      read GetDocumentIdFieldValue;

      property DocumentKindIdFieldValue: Variant
      read GetDocumentKindIdFieldValue;

      property ChargeIdFieldValue: Variant
      read GetChargeIdFieldValue;

      property TopLevelChargeSheetIdFieldValue: Variant
      read GetTopLevelChargeSheetIdFieldValue;

      property IssuerIdFieldValue: Variant
      read GetIssuerIdFieldValue;

      property IssuerIsForeignFieldValue: Boolean
      read GetIssuerIsForeignFieldValue;

      property IssuerNameFieldValue: String
      read GetIssuerNameFieldValue;
      
      property IssuerSpecialityFieldValue: String
      read GetIssuerSpecialityFieldValue;
      
      property IssuerDepartmentIdFieldValue: Variant
      read GetIssuerDepartmentIdFieldValue;
      
      property IssuerDepartmentCodeFieldValue: String
      read GetIssuerDepartmentCodeFieldValue;
      
      property IssuerDepartmentNameFieldValue: String
      read GetIssuerDepartmentNameFieldValue;

      property ViewDateByPerformerFieldValue: Variant
      read GetViewDateByPerformerFieldValue;

      property IssuingDateTimeFieldValue: Variant
      read GetIssuingDateTimeFieldValue;

    public

      property ViewingAllowedFieldValue: Boolean
      read GetViewingAllowedFieldValue;

      property ChargeSectionAccessibleFieldValue: Boolean
      read GetChargeSectionAccessibleFieldValue;
      
      property ResponseSectionAccessibleFieldValue: Boolean
      read GetResponseSectionAccessibleFieldValue;
      
      property RemovingAllowedFieldValue: Boolean
      read GetRemovingAllowedFieldValue;
      
      property PerformingAllowedFieldValue: Boolean
      read GetPerformingAllowedFieldValue;

      property IsEmployeePerformerFieldValue: Boolean
      read GetIsEmployeePerformerFieldValue;

      property SubordinateChargeSheetsIssuingAllowedFieldValue: Boolean
      read GetSubordinateChargeSheetsIssuingAllowedFieldValue;

  end;

implementation

uses

  Variants;

{ TDocumentChargeSheetsInfoFieldNames }

function TDocumentChargeSheetsInfoFieldNames.GetActualPerformerDepartmentCodeFieldName: String;
begin

  Result := FChargeInfoFieldDefs.ActualPerformerDepartmentCodeFieldName;

end;

function TDocumentChargeSheetsInfoFieldNames.GetActualPerformerDepartmentIdFieldName: String;
begin

  Result := FChargeInfoFieldDefs.ActualPerformerDepartmentIdFieldName;

end;

function TDocumentChargeSheetsInfoFieldNames.GetActualPerformerDepartmentNameFieldName: String;
begin

  Result := FChargeInfoFieldDefs.ActualPerformerDepartmentNameFieldName;

end;

function TDocumentChargeSheetsInfoFieldNames.GetActualPerformerIdFieldName: String;
begin

  Result := FChargeInfoFieldDefs.ActualPerformerIdFieldName;

end;

function TDocumentChargeSheetsInfoFieldNames.GetActualPerformerNameFieldName: String;
begin

  Result := FChargeInfoFieldDefs.ActualPerformerNameFieldName;
  
end;

function TDocumentChargeSheetsInfoFieldNames.GetActualPerformerIsForeignFieldName: String;
begin

  Result := FChargeInfoFieldDefs.ActualPerformerIsForeignFieldName

end;

function TDocumentChargeSheetsInfoFieldNames.GetActualPerformerSpecialityFieldName: String;
begin

  Result := FChargeInfoFieldDefs.ActualPerformerSpecialityFieldName
end;

function TDocumentChargeSheetsInfoFieldNames.GetChargeIdFieldName: String;
begin

  Result := FChargeInfoFieldDefs.IdFieldName;
  
end;

function TDocumentChargeSheetsInfoFieldNames.GetChargeTextFieldName: String;
begin

  Result := FChargeInfoFieldDefs.ChargeTextFieldName;
  
end;

function TDocumentChargeSheetsInfoFieldNames.GetIdFieldName: String;
begin

  Result := RecordIdFieldName;

end;

function TDocumentChargeSheetsInfoFieldNames.GetIsForAcquaitanceFieldName: String;
begin

  Result := FChargeInfoFieldDefs.IsForAcquaitanceFieldName;

end;

function TDocumentChargeSheetsInfoFieldNames.GetKindIdFieldName: String;
begin

  Result := FChargeInfoFieldDefs.KindIdFieldName;

end;

function TDocumentChargeSheetsInfoFieldNames.GetKindNameFieldName: String;
begin

  Result := FChargeInfoFieldDefs.KindNameFieldName;

end;

function TDocumentChargeSheetsInfoFieldNames.GetPerformerDepartmentCodeFieldName: String;
begin

  Result := FChargeInfoFieldDefs.PerformerDepartmentCodeFieldName;

end;

function TDocumentChargeSheetsInfoFieldNames.GetPerformerDepartmentIdFieldName: String;
begin

  Result := FChargeInfoFieldDefs.PerformerDepartmentIdFieldName;

end;

function TDocumentChargeSheetsInfoFieldNames.GetPerformerDepartmentNameFieldName: String;
begin

  Result := FChargeInfoFieldDefs.PerformerDepartmentNameFieldName;

end;

function TDocumentChargeSheetsInfoFieldNames.GetPerformerIdFieldName: String;
begin

  Result := FChargeInfoFieldDefs.PerformerIdFieldName;

end;

function TDocumentChargeSheetsInfoFieldNames.GetPerformerIsForeignFieldName: String;
begin

  Result := FChargeInfoFieldDefs.PerformerIsForeignFieldName;

end;

function TDocumentChargeSheetsInfoFieldNames.GetPerformerNameFieldName: String;
begin

  Result := FChargeInfoFieldDefs.PerformerNameFieldName;

end;

function TDocumentChargeSheetsInfoFieldNames.GetPerformerSpecialityFieldName: String;
begin

  Result := FChargeInfoFieldDefs.PerformerSpecialityFieldName;

end;

function TDocumentChargeSheetsInfoFieldNames.GetPerformingDateTimeFieldName: String;
begin

  Result := FChargeInfoFieldDefs.PerformingDateTimeFieldName;

end;

function TDocumentChargeSheetsInfoFieldNames.GetResponseFieldName: String;
begin

  Result := FChargeInfoFieldDefs.ResponseFieldName;

end;

function TDocumentChargeSheetsInfoFieldNames.GetServiceKindNameFieldName: String;
begin

  Result := FChargeInfoFieldDefs.ServiceKindNameFieldName;

end;

function TDocumentChargeSheetsInfoFieldNames.GetTimeFrameDeadlineFieldName: String;
begin

  Result := FChargeInfoFieldDefs.TimeFrameDeadlineFieldName;

end;

function TDocumentChargeSheetsInfoFieldNames.GetTimeFrameStartFieldName: String;
begin

  Result := FChargeInfoFieldDefs.TimeFrameStartFieldName;

end;

procedure TDocumentChargeSheetsInfoFieldNames.SetActualPerformerDepartmentCodeFieldName(
  const Value: String);
begin

  FChargeInfoFieldDefs.ActualPerformerDepartmentCodeFieldName := Value;

end;

procedure TDocumentChargeSheetsInfoFieldNames.SetActualPerformerDepartmentIdFieldName(
  const Value: String);
begin

  FChargeInfoFieldDefs.ActualPerformerDepartmentIdFieldName := Value;

end;

procedure TDocumentChargeSheetsInfoFieldNames.SetActualPerformerDepartmentNameFieldName(
  const Value: String);
begin

  FChargeInfoFieldDefs.ActualPerformerDepartmentNameFieldName := Value;

end;

procedure TDocumentChargeSheetsInfoFieldNames.SetActualPerformerIdFieldName(
  const Value: String);
begin

  FChargeInfoFieldDefs.ActualPerformerIdFieldName := Value;

end;

procedure TDocumentChargeSheetsInfoFieldNames.SetActualPerformerNameFieldName(
  const Value: String);
begin

  FChargeInfoFieldDefs.ActualPerformerNameFieldName := Value;

end;

procedure TDocumentChargeSheetsInfoFieldNames.SetActualPerformerIsForeignFieldName(
  const Value: String);
begin

  FChargeInfoFieldDefs.ActualPerformerIsForeignFieldName := Value;

end;

procedure TDocumentChargeSheetsInfoFieldNames.SetActualPerformerSpecialityFieldName(
  const Value: String);
begin

  FChargeInfoFieldDefs.ActualPerformerSpecialityFieldName := Value;

end;

procedure TDocumentChargeSheetsInfoFieldNames.SetChargeIdFieldName(
  const Value: String);
begin

  FChargeInfoFieldDefs.IdFieldName := Value;
  
end;

procedure TDocumentChargeSheetsInfoFieldNames.SetChargeInfoFieldDefs(
  const Value: TDocumentChargesInfoFieldNames);
begin

  FChargeInfoFieldDefs := Value;
  FFreeChargeInfoFieldDefs := FChargeInfoFieldDefs;

end;

procedure TDocumentChargeSheetsInfoFieldNames.SetChargeTextFieldName(
  const Value: String);
begin

  FChargeInfoFieldDefs.ChargeTextFieldName := Value;

end;

procedure TDocumentChargeSheetsInfoFieldNames.SetIdFieldName(
  const Value: String);
begin

  RecordIdFieldName := Value;

end;

procedure TDocumentChargeSheetsInfoFieldNames.SetIsForAcquaitanceFieldName(
  const Value: String);
begin

  FChargeInfoFieldDefs.IsForAcquaitanceFieldName := Value;

end;

procedure TDocumentChargeSheetsInfoFieldNames.SetKindIdFieldName(
  const Value: String);
begin

  FChargeInfoFieldDefs.KindIdFieldName := Value;

end;

procedure TDocumentChargeSheetsInfoFieldNames.SetKindNameFieldName(
  const Value: String);
begin

  FChargeInfoFieldDefs.KindNameFieldName := Value;

end;

procedure TDocumentChargeSheetsInfoFieldNames.SetPerformerDepartmentCodeFieldName(
  const Value: String);
begin

  FChargeInfoFieldDefs.PerformerDepartmentCodeFieldName := Value;

end;

procedure TDocumentChargeSheetsInfoFieldNames.SetPerformerDepartmentIdFieldName(
  const Value: String);
begin

  FChargeInfoFieldDefs.PerformerDepartmentIdFieldName := Value;

end;

procedure TDocumentChargeSheetsInfoFieldNames.SetPerformerDepartmentNameFieldName(
  const Value: String);
begin

  FChargeInfoFieldDefs.PerformerDepartmentNameFieldName := Value;

end;

procedure TDocumentChargeSheetsInfoFieldNames.SetPerformerIdFieldName(
  const Value: String);
begin

  FChargeInfoFieldDefs.PerformerIdFieldName := Value;

end;

procedure TDocumentChargeSheetsInfoFieldNames.SetPerformerIsForeignFieldName(
  const Value: String);
begin

  FChargeInfoFieldDefs.PerformerIsForeignFieldName := Value;
  
end;

procedure TDocumentChargeSheetsInfoFieldNames.SetPerformerNameFieldName(
  const Value: String);
begin

  FChargeInfoFieldDefs.PerformerNameFieldName := Value;

end;

procedure TDocumentChargeSheetsInfoFieldNames.SetPerformerSpecialityFieldName(
  const Value: String);
begin

  FChargeInfoFieldDefs.PerformerSpecialityFieldName := Value;
  
end;

procedure TDocumentChargeSheetsInfoFieldNames.SetPerformingDateTimeFieldName(
  const Value: String);
begin

  FChargeInfoFieldDefs.PerformingDateTimeFieldName := Value;
  
end;

procedure TDocumentChargeSheetsInfoFieldNames.SetResponseFieldName(
  const Value: String);
begin

  FChargeInfoFieldDefs.ResponseFieldName := Value;
  
end;

procedure TDocumentChargeSheetsInfoFieldNames.SetServiceKindNameFieldName(
  const Value: String);
begin

  FChargeInfoFieldDefs.ServiceKindNameFieldName := Value;

end;

procedure TDocumentChargeSheetsInfoFieldNames.SetTimeFrameDeadlineFieldName(
  const Value: String);
begin

  FChargeInfoFieldDefs.TimeFrameDeadlineFieldName := Value;

end;

procedure TDocumentChargeSheetsInfoFieldNames.SetTimeFrameStartFieldName(
  const Value: String);
begin

  FChargeInfoFieldDefs.TimeFrameStartFieldName := Value;
  
end;

{ TDocumentChargeSheetsInfoHolder }

function TDocumentChargeSheetsInfoHolder.GetActualPerformerDepartmentCodeFieldValue: String;
begin

  Result := FChargesInfoHolder.ActualPerformerDepartmentCodeFieldValue;

end;

function TDocumentChargeSheetsInfoHolder.GetActualPerformerDepartmentIdFieldValue: Variant;
begin

  Result := FChargesInfoHolder.ActualPerformerDepartmentIdFieldValue;

end;

function TDocumentChargeSheetsInfoHolder.GetActualPerformerDepartmentNameFieldValue: String;
begin

  Result := FChargesInfoHolder.ActualPerformerDepartmentNameFieldValue;

end;

function TDocumentChargeSheetsInfoHolder.GetActualPerformerIdFieldValue: Variant;
begin

  Result := FChargesInfoHolder.ActualPerformerIdFieldValue;
  
end;

function TDocumentChargeSheetsInfoHolder.GetActualPerformerIsForeignFieldValue: Boolean;
begin

  Result := FChargesInfoHolder.ActualPerformerIsForeignFieldValue;
  
end;

function TDocumentChargeSheetsInfoHolder.GetActualPerformerNameFieldValue: String;
begin

  Result := FChargesInfoHolder.ActualPerformerNameFieldValue;

end;

function TDocumentChargeSheetsInfoHolder.GetActualPerformerSpecialityFieldValue: String;
begin

  Result := FChargesInfoHolder.ActualPerformerSpecialityFieldValue;
  
end;

function TDocumentChargeSheetsInfoHolder.GetChargeIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.ChargeIdFieldName, Null);
  
end;

function TDocumentChargeSheetsInfoHolder.GetChargeSectionAccessibleFieldValue: Boolean;
begin

  Result := GetDataSetFieldValue(FieldNames.ChargeSectionAccessibleFieldName, False);
  
end;

function TDocumentChargeSheetsInfoHolder.GetDocumentIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.DocumentIdFieldName,
              Null
            );
            
end;

function TDocumentChargeSheetsInfoHolder.GetDocumentKindIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(FieldNames.DocumentKindIdFieldName, Null);

end;

function TDocumentChargeSheetsInfoHolder.GetViewDateByPerformerFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.ViewDateByPerformerFieldName,
              Null
            );

end;

function TDocumentChargeSheetsInfoHolder.GetViewingAllowedFieldValue: Boolean;
begin

  Result := GetDataSetFieldValue(FieldNames.ViewingAllowedFieldName, False);
  
end;

function TDocumentChargeSheetsInfoHolder.GetFieldNames: TDocumentChargeSheetsInfoFieldNames;
begin

  Result := TDocumentChargeSheetsInfoFieldNames(inherited FieldDefs);
  
end;

function TDocumentChargeSheetsInfoHolder.
  GetIssuingDateTimeFieldValue: Variant;
begin

  Result :=
    GetDataSetFieldValue(
      FieldNames.IssuingDateTimeFieldName,
      Null
    );
    
end;

function TDocumentChargeSheetsInfoHolder.GetIdFieldValue: Variant;
begin

  Result := RecordIdFieldValue;

end;

function TDocumentChargeSheetsInfoHolder.GetIsForAcquaitanceFieldValue: Boolean;
begin

  Result := FChargesInfoHolder.IsForAcquaitanceFieldValue;

end;

function TDocumentChargeSheetsInfoHolder.GetKindIdFieldValue: Variant;
begin

  Result := FChargesInfoHolder.KindIdFieldValue;
  
end;

function TDocumentChargeSheetsInfoHolder.GetKindNameFieldValue: String;
begin

  Result := FChargesInfoHolder.KindNameFieldValue;

end;

function TDocumentChargeSheetsInfoHolder.GetPerformerDepartmentCodeFieldValue: String;
begin

  Result := FChargesInfoHolder.PerformerDepartmentCodeFieldValue;
  
end;

function TDocumentChargeSheetsInfoHolder.GetPerformerDepartmentIdFieldValue: Variant;
begin

  Result := FChargesInfoHolder.PerformerDepartmentIdFieldValue;
  
end;

function TDocumentChargeSheetsInfoHolder.GetPerformerDepartmentNameFieldValue: String;
begin

  Result := FChargesInfoHolder.PerformerDepartmentNameFieldValue;
  
end;

function TDocumentChargeSheetsInfoHolder.GetPerformerIdFieldValue: Variant;
begin

  Result := FChargesInfoHolder.PerformerIdFieldValue;
  
end;

function TDocumentChargeSheetsInfoHolder.GetPerformerIsForeignFieldValue: Boolean;
begin

  Result := FChargesInfoHolder.PerformerIsForeignFieldValue;

end;

function TDocumentChargeSheetsInfoHolder.GetPerformerNameFieldValue: String;
begin

  Result := FChargesInfoHolder.PerformerNameFieldValue;

end;

function TDocumentChargeSheetsInfoHolder.GetPerformerSpecialityFieldValue: String;
begin

  Result := FChargesInfoHolder.PerformerSpecialityFieldValue;
  
end;

function TDocumentChargeSheetsInfoHolder.GetPerformingAllowedFieldValue: Boolean;
begin

  Result := GetDataSetFieldValue(FieldNames.PerformingAllowedFieldName, False);
  
end;

function TDocumentChargeSheetsInfoHolder.GetPerformingDateTimeFieldValue: Variant;
begin

  Result := FChargesInfoHolder.PerformingDateTimeFieldValue;

end;

function TDocumentChargeSheetsInfoHolder.GetRemovingAllowedFieldValue: Boolean;
begin

  Result := GetDataSetFieldValue(FieldNames.RemovingAllowedFieldName, False);
  
end;

function TDocumentChargeSheetsInfoHolder.GetIsEmployeePerformerFieldValue: Boolean;
begin

  Result := GetDataSetFieldValue(FieldNames.IsEmployeePerformerFieldName, False);

end;

function TDocumentChargeSheetsInfoHolder.GetResponseFieldValue: String;
begin

  Result := FChargesInfoHolder.ResponseFieldValue;

end;

function TDocumentChargeSheetsInfoHolder.GetResponseSectionAccessibleFieldValue: Boolean;
begin

  Result := GetDataSetFieldValue(FieldNames.ResponseSectionAccessibleFieldName, False);
  
end;

function TDocumentChargeSheetsInfoHolder.GetServiceKindNameFieldValue: String;
begin

  Result := FChargesInfoHolder.ServiceKindNameFieldValue;
  
end;

function TDocumentChargeSheetsInfoHolder.GetSubordinateChargeSheetsIssuingAllowedFieldValue: Boolean;
begin

  Result := GetDataSetFieldValue(FieldNames.SubordinateChargeSheetsIssuingAllowedFieldName, False);
  
end;

function TDocumentChargeSheetsInfoHolder.
  GetIssuerDepartmentCodeFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.IssuerDepartmentCodeFieldName,
              ''
            );
            
end;

function TDocumentChargeSheetsInfoHolder.
  GetIssuerDepartmentIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.IssuerDepartmentIdFieldName,
              Null
            );
            
end;

function TDocumentChargeSheetsInfoHolder.
  GetIssuerDepartmentNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.IssuerDepartmentNameFieldName,
              ''
            );

end;

function TDocumentChargeSheetsInfoHolder.
  GetIssuerIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.IssuerIdFieldName,
              Null
            );
            
end;

function TDocumentChargeSheetsInfoHolder.GetIssuerIsForeignFieldValue: Boolean;
begin

  Result := GetDataSetFieldValue(FieldNames.IssuerIsForeignFieldName, False);

end;


function TDocumentChargeSheetsInfoHolder.
  GetIssuerNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.IssuerNameFieldName,
              ''
            );
            
end;

function TDocumentChargeSheetsInfoHolder.
  GetIssuerSpecialityFieldValue: String;
begin

  Result := GetDataSetFieldValue(
              FieldNames.IssuerSpecialityFieldName,
              ''
            );
            
end;

function TDocumentChargeSheetsInfoHolder.GetTimeFrameDeadlineFieldValue: Variant;
begin

  Result := FChargesInfoHolder.TimeFrameDeadlineFieldValue;

end;

function TDocumentChargeSheetsInfoHolder.GetTimeFrameStartFieldValue: Variant;
begin

  Result := FChargesInfoHolder.TimeFrameStartFieldValue;
  
end;

function TDocumentChargeSheetsInfoHolder.GetTopLevelChargeSheetIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(
              FieldNames.TopLevelChargeSheetIdFieldName,
              Null
            );

end;

function TDocumentChargeSheetsInfoHolder.GetChargeTextFieldValue: String;
begin

  Result := FChargesInfoHolder.ChargeTextFieldValue;
  
end;

class function TDocumentChargeSheetsInfoHolder.GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass;
begin

  Result := TDocumentChargeSheetsInfoFieldNames;

end;

procedure TDocumentChargeSheetsInfoHolder.SetChargesInfoHolder(
  const Value: TDocumentChargesInfoHolder);
begin

  FChargesInfoHolder := Value;
  FFreeChargesInfoHolder := FChargesInfoHolder;

  if not Assigned(Value) then Exit;

  if Assigned(Value.DataSet) then
    DataSet := Value.DataSet;
    
end;

procedure TDocumentChargeSheetsInfoHolder.SetFieldNames(
  const Value: TDocumentChargeSheetsInfoFieldNames);
begin

  inherited FieldDefs := Value;

end;

end.
