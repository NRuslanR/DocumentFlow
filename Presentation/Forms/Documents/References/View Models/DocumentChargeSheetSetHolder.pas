unit DocumentChargeSheetSetHolder;

interface

uses

  DocumentChargeSetHolder,
  AbstractDataSetHolder,
  VariantListUnit,
  Disposable,
  Variants,
  DB,
  SysUtils,
  Classes;

type

  TDocumentChargeSheetSetFieldDefs = class (TAbstractDataSetFieldDefs)

    private

      FChargeIdFieldName: String;
      
    private

      function GetActualPerformerFullNameFieldName: String;
      function GetChargeIdFieldName: String;
      function GetChargeSetFieldDefs: TDocumentChargeSetFieldDefs;
      function GetChargeTextFieldName: String;
      function GetIdFieldName: String;
      function GetIsForAcquaitanceFieldName: String;
      function GetIsPerformerForeignFieldName: String;
      function GetKindIdFieldName: String;
      function GetKindNameFieldName: String;
      function GetKindServiceNameFieldName: String;
      function GetPerformerCommentFieldName: String;
      function GetPerformerDepartmentIdFieldName: String;
      function GetPerformerDepartmentNameFieldName: String;
      function GetPerformerFullNameFieldName: String;
      function GetPerformerIdFieldName: String;
      function GetPerformerSpecialityFieldName: String;
      function GetPerformingDateTimeFieldName: String;

      procedure SetActualPerformerFullNameFieldName(const Value: String);
      procedure SetChargeIdFieldName(const Value: String);
      procedure SetChargeSetFieldDefs(const Value: TDocumentChargeSetFieldDefs);
      procedure SetChargeTextFieldName(const Value: String);
      procedure SetIdFieldName(const Value: String);
      procedure SetIsForAcquaitanceFieldName(const Value: String);
      procedure SetIsPerformerForeignFieldName(const Value: String);
      procedure SetKindIdFieldName(const Value: String);
      procedure SetKindNameFieldName(const Value: String);
      procedure SetKindServiceNameFieldName(const Value: String);
      procedure SetPerformerCommentFieldName(const Value: String);
      procedure SetPerformerDepartmentIdFieldName(const Value: String);
      procedure SetPerformerDepartmentNameFieldName(const Value: String);
      procedure SetPerformerFullNameFieldName(const Value: String);
      procedure SetPerformerIdFieldName(const Value: String);
      procedure SetPerformerSpecialityFieldName(const Value: String);
      procedure SetPerformingDateTimeFieldName(const Value: String);

    protected

      FChargeSetFieldDefs: TDocumentChargeSetFieldDefs;
      FFreeChargeSetFieldDefs: IDisposable;

    public

      property IdFieldName: String
      read GetIdFieldName write SetIdFieldName;

      property KindIdFieldName: String
      read GetKindIdFieldName write SetKindIdFieldName;

      property KindNameFieldName: String
      read GetKindNameFieldName write SetKindNameFieldName;

      property KindServiceNameFieldName: String
      read GetKindServiceNameFieldName write SetKindServiceNameFieldName;

      property IsForAcquaitanceFieldName: String
      read GetIsForAcquaitanceFieldName
      write SetIsForAcquaitanceFieldName;

      property PerformingDateTimeFieldName: String
      read GetPerformingDateTimeFieldName
      write SetPerformingDateTimeFieldName;

      property PerformerDepartmentNameFieldName: String
      read GetPerformerDepartmentNameFieldName
      write SetPerformerDepartmentNameFieldName;
      
      property PerformerSpecialityFieldName: String
      read GetPerformerSpecialityFieldName
      write SetPerformerSpecialityFieldName;

      property PerformerCommentFieldName: String
      read GetPerformerCommentFieldName
      write SetPerformerCommentFieldName;

      property PerformerIdFieldName: String
      read GetPerformerIdFieldName
      write SetPerformerIdFieldName;

      property PerformerFullNameFieldName: String
      read GetPerformerFullNameFieldName
      write SetPerformerFullNameFieldName;

      property IsPerformerForeignFieldName: String
      read GetIsPerformerForeignFieldName
      write SetIsPerformerForeignFieldName;

      property ChargeTextFieldName: String
      read GetChargeTextFieldName
      write SetChargeTextFieldName;

      property PerformerDepartmentIdFieldName: String
      read GetPerformerDepartmentIdFieldName
      write SetPerformerDepartmentIdFieldName;

      property ActualPerformerFullNameFieldName: String
      read GetActualPerformerFullNameFieldName
      write SetActualPerformerFullNameFieldName;

    public

      property ChargeSetFieldDefs: TDocumentChargeSetFieldDefs
      read GetChargeSetFieldDefs write SetChargeSetFieldDefs;
      
    public

      property ChargeIdFieldName: String
      read GetChargeIdFieldName write SetChargeIdFieldName;
      
    public

      DocumentIdFieldName: String;
      TopLevelChargeSheetIdFieldName: String;
      ViewDateByPerformerFieldName: String;
      IssuerNameFieldName: String;
      IssuerIdFieldName: String;
      IssuingDateTimeFieldName: String;

      ViewingAllowedFieldName: String;
      ChargeSectionAccessibleFieldName: String;
      ResponseSectionAccessibleFieldName: String;
      RemovingAllowedFieldName: String;
      PerformingAllowedFieldName: String;
      SubordinateChargeSheetsIssuingAllowedFieldName: String;
      IsEmployeePerformerFieldName: String;
      
  end;
  
  TDocumentChargeSheetSetHolder = class (TAbstractDataSetHolder)

    private

      function GetChargeSectionAccessibleFieldName: String;
      function GetChargeSectionAccessibleFieldValue: Variant;
      function GetChargeSetFieldDefs: TDocumentChargeSetFieldDefs;
      function GetChargeSetHolder: TDocumentChargeSetHolder;
      function GetChargeTextFieldName: String;
      function GetChargeTextFieldValue: String;
      function GetDocumentIdFieldName: String;
      function GetDocumentIdFieldValue: Variant;
      function GetIssuerIdFieldName: String;
      function GetIssuerIdFieldValue: Variant;
      function GetIssuerNameFieldName: String;
      function GetIssuerNameFieldValue: String;
      function GetIssuingDateTimeFieldName: String;
      function GetIssuingDateTimeFieldValue: Variant;
      function GetPerformingAllowedFieldName: String;
      function GetPerformingAllowedFieldValue: Variant;
      function GetRemovingAllowedFieldName: String;
      function GetRemovingAllowedFieldValue: Variant;
      function GetResponseSectionAccessibleFieldName: String;
      function GetResponseSectionAccessibleFieldValue: Variant;
      function GetTopLevelChargeSheetIdFieldName: String;
      function GetTopLevelChargeSheetIdFieldValue: Variant;
      function GetViewDateByPerformerFieldName: String;
      function GetViewDateByPerformerFieldValue: Variant;
      function GetViewingAllowedFieldName: String;
      function GetViewingAllowedFieldValue: Variant;

      procedure SetChargeSectionAccessibleFieldName(const Value: String);
      procedure SetChargeSectionAccessibleFieldValue(const Value: Variant);
      procedure SetChargeSetFieldDefs(const Value: TDocumentChargeSetFieldDefs);
      procedure SetChargeSetHolder(const Value: TDocumentChargeSetHolder);
      procedure SetChargeTextFieldName(const Value: String);
      procedure SetChargeTextFieldValue(const Value: String);
      procedure SetDocumentIdFieldName(const Value: String);
      procedure SetDocumentIdFieldValue(const Value: Variant);
      procedure SetIssuerIdFieldName(const Value: String);
      procedure SetIssuerIdFieldValue(const Value: Variant);
      procedure SetIssuerNameFieldName(const Value: String);
      procedure SetIssuerNameFieldValue(const Value: String);
      procedure SetIssuingDateTimeFieldName(const Value: String);
      procedure SetIssuingDateTimeFieldValue(const Value: Variant);
      procedure SetPerformingAllowedFieldName(const Value: String);
      procedure SetPerformingAllowedFieldValue(const Value: Variant);
      procedure SetRemovingAllowedFieldName(const Value: String);
      procedure SetRemovingAllowedFieldValue(const Value: Variant);
      procedure SetResponseSectionAccessibleFieldName(const Value: String);
      procedure SetResponseSectionAccessibleFieldValue(const Value: Variant);
      procedure SetTopLevelChargeSheetIdFieldName(const Value: String);
      procedure SetTopLevelChargeSheetIdFieldValue(const Value: Variant);
      procedure SetViewDateByPerformerFieldName(const Value: String);
      procedure SetViewDateByPerformerFieldValue(const Value: Variant);
      procedure SetViewingAllowedFieldName(const Value: String);
      procedure SetViewingAllowedFieldValue(const Value: Variant);

      function GetActualPerformerFullNameFieldValue: String;
      function GetChargeIdFieldName: String;
      function GetChargeIdFieldValue: Variant;
      function GetIdFieldName: String;
      function GetIdFieldValue: Variant;
      function GetIsForAcquaitanceFieldValue: Boolean;
      function GetIsPerformerForeignFieldValue: Boolean;
      function GetKindIdFieldValue: Variant;
      function GetKindNameFieldValue: String;
      function GetKindServiceNameFieldValue: String;
      function GetPerformerCommentFieldValue: String;
      function GetPerformerDepartmentIdFieldValue: Variant;
      function GetPerformerDepartmentNameFieldValue: String;
      function GetPerformerFullNameFieldValue: String;
      function GetPerformerIdFieldValue: Variant;
      function GetPerformerSpecialityFieldValue: String;
      function GetPerformingDateTimeFieldValue: Variant;
      function GetIsEmployeePerformerFieldValue: Variant;
      function GetSubordinateChargeSheetsIssuingAllowedFieldValue: Variant;
      
      procedure SetActualPerformerFullNameFieldValue(const Value: String);
      procedure SetChargeIdFieldName(const Value: String);
      procedure SetChargeIdFieldValue(const Value: Variant);
      procedure SetIdFieldName(const Value: String);
      procedure SetIdFieldValue(const Value: Variant);
      procedure SetIsForAcquaitanceFieldValue(const Value: Boolean);
      procedure SetIsPerformerForeignFieldValue(const Value: Boolean);
      procedure SetKindIdFieldValue(const Value: Variant);
      procedure SetKindNameFieldValue(const Value: String);
      procedure SetKindServiceNameFieldValue(const Value: String);
      procedure SetPerformerCommentFieldValue(const Value: String);
      procedure SetPerformerDepartmentIdFieldValue(const Value: Variant);
      procedure SetPerformerDepartmentNameFieldValue(const Value: String);
      procedure SetPerformerFullNameFieldValue(const Value: String);
      procedure SetPerformerIdFieldValue(const Value: Variant);
      procedure SetPerformerSpecialityFieldValue(const Value: String);
      procedure SetPerformingDateTimeFieldValue(const Value: Variant);
      procedure SetIsEmployeePerformerFieldValue(const Value: Variant);

      procedure SetSubordinateChargeSheetsIssuingAllowedFieldValue(
        const Value: Variant
      );

      function GetChargeSheetSetFieldDefs: TDocumentChargeSheetSetFieldDefs;

      procedure SetChargeSheetSetFieldDefs(
        const Value: TDocumentChargeSheetSetFieldDefs
      );

      function GetActualPerformerFullNameFieldName: String;
      function GetIsForAcquaitanceFieldName: String;
      function GetIsPerformerForeignFieldName: String;
      function GetKindIdFieldName: String;
      function GetKindNameFieldName: String;
      function GetKindServiceNameFieldName: String;
      function GetPerformerCommentFieldName: String;
      function GetPerformerDepartmentIdFieldName: String;
      function GetPerformerDepartmentNameFieldName: String;
      function GetPerformerFullNameFieldName: String;
      function GetPerformerIdFieldName: String;
      function GetPerformerSpecialityFieldName: String;
      function GetPerformingDateTimeFieldName: String;
      function GetIsEmployeePerformerFieldName: String;
      function GetSubordinateChargeSheetsIssuingAllowedFieldName: String;

      procedure SetActualPerformerFullNameFieldName(const Value: String);
      procedure SetIsForAcquaitanceFieldName(const Value: String);
      procedure SetIsPerformerForeignFieldName(const Value: String);
      procedure SetKindIdFieldName(const Value: String);
      procedure SetKindNameFieldName(const Value: String);
      procedure SetKindServiceNameFieldName(const Value: String);
      procedure SetPerformerCommentFieldName(const Value: String);
      procedure SetPerformerDepartmentIdFieldName(const Value: String);
      procedure SetPerformerDepartmentNameFieldName(const Value: String);
      procedure SetPerformerFullNameFieldName(const Value: String);
      procedure SetPerformerIdFieldName(const Value: String);
      procedure SetPerformerSpecialityFieldName(const Value: String);
      procedure SetPerformingDateTimeFieldName(const Value: String);
      procedure SetIsEmployeePerformerFieldName(const Value: String);

      procedure SetSubordinateChargeSheetsIssuingAllowedFieldName(
        const Value: String
      );


    protected

      FHeadChargeSheetsIssuingAllowed: Boolean;

      FChargeSetHolder: TDocumentChargeSetHolder;
      FFreeChargeSetHolder: IDisposable;

      function GetDataSet: TDataSet; override;
      procedure SetDataSet(const Value: TDataSet); override;
      procedure SetFieldDefs(const Value: TAbstractDataSetFieldDefs); override;
      
      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;

    public

      procedure MarkCurrentAndAllSubordinateRecordsAsRemoved;
      
    public

      property ChargeSetFieldDefs: TDocumentChargeSetFieldDefs
      read GetChargeSetFieldDefs write SetChargeSetFieldDefs;

      property ChargeSetHolder: TDocumentChargeSetHolder
      read GetChargeSetHolder write SetChargeSetHolder;

      property FieldDefs: TDocumentChargeSheetSetFieldDefs
      read GetChargeSheetSetFieldDefs write SetChargeSheetSetFieldDefs;

    public

      property KindIdFieldName: String
      read GetKindIdFieldName write SetKindIdFieldName;

      property KindNameFieldName: String
      read GetKindNameFieldName write SetKindNameFieldName;

      property KindServiceNameFieldName: String
      read GetKindServiceNameFieldName write SetKindServiceNameFieldName;

      property IsForAcquaitanceFieldName: String
      read GetIsForAcquaitanceFieldName
      write SetIsForAcquaitanceFieldName;

      property PerformingDateTimeFieldName: String
      read GetPerformingDateTimeFieldName
      write SetPerformingDateTimeFieldName;

      property PerformerDepartmentNameFieldName: String
      read GetPerformerDepartmentNameFieldName
      write SetPerformerDepartmentNameFieldName;
      
      property PerformerSpecialityFieldName: String
      read GetPerformerSpecialityFieldName
      write SetPerformerSpecialityFieldName;

      property PerformerCommentFieldName: String
      read GetPerformerCommentFieldName
      write SetPerformerCommentFieldName;

      property PerformerIdFieldName: String
      read GetPerformerIdFieldName
      write SetPerformerIdFieldName;

      property PerformerFullNameFieldName: String
      read GetPerformerFullNameFieldName
      write SetPerformerFullNameFieldName;

      property IsPerformerForeignFieldName: String
      read GetIsPerformerForeignFieldName
      write SetIsPerformerForeignFieldName;

      property ChargeTextFieldName: String
      read GetChargeTextFieldName
      write SetChargeTextFieldName;

      property PerformerDepartmentIdFieldName: String
      read GetPerformerDepartmentIdFieldName
      write SetPerformerDepartmentIdFieldName;

      property ActualPerformerFullNameFieldName: String
      read GetActualPerformerFullNameFieldName
      write SetActualPerformerFullNameFieldName;

    public

      property IdFieldName: String
      read GetIdFieldName write SetIdFieldName;

      property ChargeIdFieldName: String
      read GetChargeIdFieldName write SetChargeIdFieldName;

      property DocumentIdFieldName: String
      read GetDocumentIdFieldName write SetDocumentIdFieldName;
      
      property TopLevelChargeSheetIdFieldName: String
      read GetTopLevelChargeSheetIdFieldName write SetTopLevelChargeSheetIdFieldName;

      property ViewDateByPerformerFieldName: String
      read GetViewDateByPerformerFieldName write SetViewDateByPerformerFieldName;

      property IssuerNameFieldName: String
      read GetIssuerNameFieldName write SetIssuerNameFieldName;

      property IssuerIdFieldName: String
      read GetIssuerIdFieldName write SetIssuerIdFieldName;

      property IssuingDateTimeFieldName: String
      read GetIssuingDateTimeFieldName write SetIssuingDateTimeFieldName;

      property ViewingAllowedFieldName: String
      read GetViewingAllowedFieldName write SetViewingAllowedFieldName;

      property ChargeSectionAccessibleFieldName: String
      read GetChargeSectionAccessibleFieldName write SetChargeSectionAccessibleFieldName;

      property ResponseSectionAccessibleFieldName: String
      read GetResponseSectionAccessibleFieldName write SetResponseSectionAccessibleFieldName;

      property RemovingAllowedFieldName: String
      read GetRemovingAllowedFieldName write SetRemovingAllowedFieldName;

      property PerformingAllowedFieldName: String
      read GetPerformingAllowedFieldName write SetPerformingAllowedFieldName;

      property SubordinateChargeSheetsIssuingAllowedFieldName: String
      read GetSubordinateChargeSheetsIssuingAllowedFieldName
      write SetSubordinateChargeSheetsIssuingAllowedFieldName;

      property IsEmployeePerformerFieldName: String
      read GetIsEmployeePerformerFieldName write SetIsEmployeePerformerFieldName;

    public

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

      property ActualPerformerFullNameFieldValue: String
      read GetActualPerformerFullNameFieldValue
      write SetActualPerformerFullNameFieldValue;
      
      property IsForAcquaitanceFieldValue: Boolean
      read GetIsForAcquaitanceFieldValue
      write SetIsForAcquaitanceFieldValue;

    public

      property IdFieldValue: Variant
      read GetIdFieldValue write SetIdFieldValue;

      property ChargeIdFieldValue: Variant
      read GetChargeIdFieldValue write SetChargeIdFieldValue;

      property DocumentIdFieldValue: Variant
      read GetDocumentIdFieldValue write SetDocumentIdFieldValue;

      property TopLevelChargeSheetIdFieldValue: Variant
      read GetTopLevelChargeSheetIdFieldValue write SetTopLevelChargeSheetIdFieldValue;

      property ViewDateByPerformerFieldValue: Variant
      read GetViewDateByPerformerFieldValue write SetViewDateByPerformerFieldValue;

      property IssuerNameFieldValue: String
      read GetIssuerNameFieldValue write SetIssuerNameFieldValue;

      property IssuerIdFieldValue: Variant
      read GetIssuerIdFieldValue write SetIssuerIdFieldValue;

      property IssuingDateTimeFieldValue: Variant
      read GetIssuingDateTimeFieldValue write SetIssuingDateTimeFieldValue;

      property ViewingAllowedFieldValue: Variant
      read GetViewingAllowedFieldValue write SetViewingAllowedFieldValue;

      property ChargeSectionAccessibleFieldValue: Variant
      read GetChargeSectionAccessibleFieldValue write SetChargeSectionAccessibleFieldValue;

      property ResponseSectionAccessibleFieldValue: Variant
      read GetResponseSectionAccessibleFieldValue write SetResponseSectionAccessibleFieldValue;

      property RemovingAllowedFieldValue: Variant
      read GetRemovingAllowedFieldValue write SetRemovingAllowedFieldValue;

      property PerformingAllowedFieldValue: Variant
      read GetPerformingAllowedFieldValue write SetPerformingAllowedFieldValue;

      property SubordinateChargeSheetsIssuingAllowedFieldValue: Variant
      read GetSubordinateChargeSheetsIssuingAllowedFieldValue
      write SetSubordinateChargeSheetsIssuingAllowedFieldValue;

      property IsEmployeePerformerFieldValue: Variant
      read GetIsEmployeePerformerFieldValue write SetIsEmployeePerformerFieldValue;

      property HeadChargeSheetsIssuingAllowed: Boolean
      read FHeadChargeSheetsIssuingAllowed write FHeadChargeSheetsIssuingAllowed;
      
  end;

implementation

{ TDocumentChargeSheetSetFieldDefs }

function TDocumentChargeSheetSetFieldDefs.GetActualPerformerFullNameFieldName: String;
begin

  Result := ChargeSetFieldDefs.ActualPerformerFullNameFieldName;

end;

function TDocumentChargeSheetSetFieldDefs.GetChargeIdFieldName: String;
begin

  Result := FChargeIdFieldName; //ChargeSetFieldDefs.IdFieldName;
  
end;

function TDocumentChargeSheetSetFieldDefs.GetChargeSetFieldDefs: TDocumentChargeSetFieldDefs;
begin

  Result := FChargeSetFieldDefs;

end;

function TDocumentChargeSheetSetFieldDefs.GetChargeTextFieldName: String;
begin

  Result := ChargeSetFieldDefs.ChargeTextFieldName;

end;

function TDocumentChargeSheetSetFieldDefs.GetIdFieldName: String;
begin

  Result := RecordIdFieldName;

end;

function TDocumentChargeSheetSetFieldDefs.GetIsForAcquaitanceFieldName: String;
begin

  Result := ChargeSetFieldDefs.IsForAcquaitanceFieldName;

end;

function TDocumentChargeSheetSetFieldDefs.GetIsPerformerForeignFieldName: String;
begin

  Result := ChargeSetFieldDefs.IsPerformerForeignFieldName;

end;

function TDocumentChargeSheetSetFieldDefs.GetKindIdFieldName: String;
begin

  Result := ChargeSetFieldDefs.KindIdFieldName;

end;

function TDocumentChargeSheetSetFieldDefs.GetKindNameFieldName: String;
begin

  Result := ChargeSetFieldDefs.KindNameFieldName;

end;

function TDocumentChargeSheetSetFieldDefs.GetKindServiceNameFieldName: String;
begin

  Result := ChargeSetFieldDefs.KindServiceNameFieldName;
  
end;

function TDocumentChargeSheetSetFieldDefs.GetPerformerCommentFieldName: String;
begin

  Result := ChargeSetFieldDefs.PerformerCommentFieldName;

end;

function TDocumentChargeSheetSetFieldDefs.GetPerformerDepartmentIdFieldName: String;
begin

  Result := ChargeSetFieldDefs.PerformerDepartmentIdFieldName;

end;

function TDocumentChargeSheetSetFieldDefs.GetPerformerDepartmentNameFieldName: String;
begin

  Result := ChargeSetFieldDefs.PerformerDepartmentNameFieldName;

end;

function TDocumentChargeSheetSetFieldDefs.GetPerformerFullNameFieldName: String;
begin

  Result := ChargeSetFieldDefs.PerformerFullNameFieldName;
  
end;

function TDocumentChargeSheetSetFieldDefs.GetPerformerIdFieldName: String;
begin

  Result := ChargeSetFieldDefs.PerformerIdFieldName;

end;

function TDocumentChargeSheetSetFieldDefs.GetPerformerSpecialityFieldName: String;
begin

  Result := ChargeSetFieldDefs.PerformerSpecialityFieldName;
  
end;

function TDocumentChargeSheetSetFieldDefs.GetPerformingDateTimeFieldName: String;
begin

  Result := ChargeSetFieldDefs.PerformingDateTimeFieldName;

end;

procedure TDocumentChargeSheetSetFieldDefs.SetActualPerformerFullNameFieldName(
  const Value: String);
begin

  ChargeSetFieldDefs.ActualPerformerFullNameFieldName := Value;

end;

procedure TDocumentChargeSheetSetFieldDefs.SetChargeIdFieldName(
  const Value: String);
begin

  FChargeIdFieldName := Value;
  //ChargeSetFieldDefs.IdFieldName := Value;

end;

procedure TDocumentChargeSheetSetFieldDefs.SetChargeSetFieldDefs(
  const Value: TDocumentChargeSetFieldDefs);
begin

  FChargeSetFieldDefs := Value;
  FFreeChargeSetFieldDefs := FChargeSetFieldDefs;

end;

procedure TDocumentChargeSheetSetFieldDefs.SetChargeTextFieldName(
  const Value: String);
begin

  ChargeSetFieldDefs.ChargeTextFieldName := Value;
  
end;

procedure TDocumentChargeSheetSetFieldDefs.SetIdFieldName(const Value: String);
begin

  RecordIdFieldName := Value;

end;

procedure TDocumentChargeSheetSetFieldDefs.SetIsForAcquaitanceFieldName(
  const Value: String);
begin

  ChargeSetFieldDefs.IsForAcquaitanceFieldName := Value;
  
end;

procedure TDocumentChargeSheetSetFieldDefs.SetIsPerformerForeignFieldName(
  const Value: String);
begin

  ChargeSetFieldDefs.IsPerformerForeignFieldName := Value;
  
end;

procedure TDocumentChargeSheetSetFieldDefs.SetKindIdFieldName(
  const Value: String);
begin

  ChargeSetFieldDefs.KindIdFieldName := Value;
  
end;

procedure TDocumentChargeSheetSetFieldDefs.SetKindNameFieldName(
  const Value: String);
begin

  ChargeSetFieldDefs.KindNameFieldName := Value;

end;

procedure TDocumentChargeSheetSetFieldDefs.SetKindServiceNameFieldName(
  const Value: String);
begin

  ChargeSetFieldDefs.KindServiceNameFieldName := Value;
  
end;

procedure TDocumentChargeSheetSetFieldDefs.SetPerformerCommentFieldName(
  const Value: String);
begin

  ChargeSetFieldDefs.PerformerCommentFieldName := Value;

end;

procedure TDocumentChargeSheetSetFieldDefs.SetPerformerDepartmentIdFieldName(
  const Value: String);
begin

  ChargeSetFieldDefs.PerformerDepartmentIdFieldName := Value;
  
end;

procedure TDocumentChargeSheetSetFieldDefs.SetPerformerDepartmentNameFieldName(
  const Value: String);
begin

  ChargeSetFieldDefs.PerformerDepartmentNameFieldName := Value;

end;

procedure TDocumentChargeSheetSetFieldDefs.SetPerformerFullNameFieldName(
  const Value: String);
begin

  ChargeSetFieldDefs.PerformerFullNameFieldName := Value;

end;

procedure TDocumentChargeSheetSetFieldDefs.SetPerformerIdFieldName(
  const Value: String);
begin

  ChargeSetFieldDefs.PerformerIdFieldName := Value;

end;

procedure TDocumentChargeSheetSetFieldDefs.SetPerformerSpecialityFieldName(
  const Value: String);
begin

  ChargeSetFieldDefs.PerformerSpecialityFieldName := Value;

end;

procedure TDocumentChargeSheetSetFieldDefs.SetPerformingDateTimeFieldName(
  const Value: String);
begin

  ChargeSetFieldDefs.PerformingDateTimeFieldName := Value;

end;

{ TDocumentChargeSheetSetHolder }

procedure TDocumentChargeSheetSetHolder.SetActualPerformerFullNameFieldName(
  const Value: String);
begin

  FieldDefs.ActualPerformerFullNameFieldName := Value;
  
end;

procedure TDocumentChargeSheetSetHolder.SetActualPerformerFullNameFieldValue(
  const Value: String);
begin

  ChargeSetHolder.ActualPerformerFullNameFieldValue := Value;

end;

procedure TDocumentChargeSheetSetHolder.SetChargeIdFieldName(
  const Value: String);
begin

  FieldDefs.ChargeIdFieldName := Value;
  FChargeSetHolder.IdFieldName := Value;

end;

procedure TDocumentChargeSheetSetHolder.SetChargeIdFieldValue(
  const Value: Variant);
begin

  ChargeSetHolder.IdFieldValue := Value;

end;

procedure TDocumentChargeSheetSetHolder.SetChargeSectionAccessibleFieldName(
  const Value: String);
begin

  FieldDefs.ChargeSectionAccessibleFieldName := Value;

end;

procedure TDocumentChargeSheetSetHolder.SetChargeSectionAccessibleFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(ChargeSectionAccessibleFieldName, Value);
  
end;

procedure TDocumentChargeSheetSetHolder.SetChargeSetFieldDefs(
  const Value: TDocumentChargeSetFieldDefs);
begin

  FieldDefs.ChargeSetFieldDefs := Value;

  if Assigned(ChargeSetHolder) then
    ChargeSetHolder.FieldDefs := Value;
    
end;

procedure TDocumentChargeSheetSetHolder.SetChargeSetHolder(
  const Value: TDocumentChargeSetHolder);
begin

  FChargeSetHolder := Value;
  FFreeChargeSetHolder := Value;

  if not Assigned(FChargeSetHolder) then Exit;

  if Assigned(DataSet) then
    FChargeSetHolder.DataSet := DataSet

  else DataSet := FChargeSetHolder.DataSet;

  FieldDefs.ChargeSetFieldDefs := FChargeSetHolder.FieldDefs;

  //FChargeSetHolder.FieldDefs.IdFieldName := ChargeIdFieldName;
  
end;

procedure TDocumentChargeSheetSetHolder.SetChargeSheetSetFieldDefs(
  const Value: TDocumentChargeSheetSetFieldDefs);
begin

  inherited FieldDefs := Value;

end;

procedure TDocumentChargeSheetSetHolder.SetChargeTextFieldName(
  const Value: String);
begin

  ChargeSetHolder.ChargeTextFieldName := Value;
  
end;

procedure TDocumentChargeSheetSetHolder.SetChargeTextFieldValue(
  const Value: String);
begin

  ChargeSetHolder.ChargeTextFieldValue := Value;

end;

procedure TDocumentChargeSheetSetHolder.SetDataSet(const Value: TDataSet);
begin

  if Assigned(ChargeSetHolder) then
    ChargeSetHolder.DataSet := Value;

  inherited SetDataSet(Value);

end;

procedure TDocumentChargeSheetSetHolder.SetDocumentIdFieldName(
  const Value: String);
begin

  FieldDefs.DocumentIdFieldName := Value;

end;

procedure TDocumentChargeSheetSetHolder.SetDocumentIdFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(DocumentIdFieldName, Value);
  
end;

procedure TDocumentChargeSheetSetHolder.SetFieldDefs(
  const Value: TAbstractDataSetFieldDefs);
begin

  inherited SetFieldDefs(Value);

  if Assigned(ChargeSetHolder) then begin

    TDocumentChargeSheetSetFieldDefs(Value)
      .ChargeSetFieldDefs := ChargeSetHolder.FieldDefs;

  end;

end;

procedure TDocumentChargeSheetSetHolder.SetIdFieldName(const Value: String);
begin

  RecordIdFieldName := Value;

end;

procedure TDocumentChargeSheetSetHolder.SetIdFieldValue(const Value: Variant);
begin

  RecordIdFieldValue := Value;

end;

procedure TDocumentChargeSheetSetHolder.SetIsEmployeePerformerFieldName(
  const Value: String);
begin

  FieldDefs.IsEmployeePerformerFieldName := Value;

end;

procedure TDocumentChargeSheetSetHolder.SetIsEmployeePerformerFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(IsEmployeePerformerFieldName, Value);
  
end;

procedure TDocumentChargeSheetSetHolder.SetIsForAcquaitanceFieldName(
  const Value: String);
begin

  FieldDefs.IsForAcquaitanceFieldName := Value;

end;

procedure TDocumentChargeSheetSetHolder.SetIsForAcquaitanceFieldValue(
  const Value: Boolean);
begin

  ChargeSetHolder.IsForAcquaitanceFieldValue := Value;

end;

procedure TDocumentChargeSheetSetHolder.SetIsPerformerForeignFieldName(
  const Value: String);
begin

  FieldDefs.IsPerformerForeignFieldName := Value;

end;

procedure TDocumentChargeSheetSetHolder.SetIsPerformerForeignFieldValue(
  const Value: Boolean);
begin

  ChargeSetHolder.IsPerformerForeignFieldValue := Value;

end;

procedure TDocumentChargeSheetSetHolder.SetIssuerIdFieldName(
  const Value: String);
begin

  FieldDefs.IssuerIdFieldName := Value;
  
end;

procedure TDocumentChargeSheetSetHolder.SetIssuerIdFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(IssuerIdFieldName, Value);

end;

procedure TDocumentChargeSheetSetHolder.SetIssuerNameFieldName(
  const Value: String);
begin

  FieldDefs.IssuerNameFieldName := Value;

end;

procedure TDocumentChargeSheetSetHolder.SetIssuerNameFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(IssuerNameFieldName, Value);
  
end;

procedure TDocumentChargeSheetSetHolder.SetIssuingDateTimeFieldName(
  const Value: String);
begin

  FieldDefs.IssuingDateTimeFieldName := Value;
  
end;

procedure TDocumentChargeSheetSetHolder.SetIssuingDateTimeFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(IssuingDateTimeFieldName, Value);
  
end;

procedure TDocumentChargeSheetSetHolder.SetKindIdFieldName(const Value: String);
begin

  FieldDefs.KindIdFieldName := Value;
  
end;

procedure TDocumentChargeSheetSetHolder.SetKindIdFieldValue(
  const Value: Variant);
begin

  ChargeSetHolder.KindIdFieldValue := Value;

end;

procedure TDocumentChargeSheetSetHolder.SetKindNameFieldName(
  const Value: String);
begin

  FieldDefs.KindNameFieldName := Value;

end;

procedure TDocumentChargeSheetSetHolder.SetKindNameFieldValue(
  const Value: String);
begin

  ChargeSetHolder.KindNameFieldValue := Value;

end;

procedure TDocumentChargeSheetSetHolder.SetKindServiceNameFieldName(
  const Value: String);
begin

  FieldDefs.KindServiceNameFieldName := Value;

end;

procedure TDocumentChargeSheetSetHolder.SetKindServiceNameFieldValue(
  const Value: String);
begin

  ChargeSetHolder.KindServiceNameFieldValue := Value;
  
end;

procedure TDocumentChargeSheetSetHolder.SetPerformerCommentFieldName(
  const Value: String);
begin

  FieldDefs.PerformerCommentFieldName := Value;

end;

procedure TDocumentChargeSheetSetHolder.SetPerformerCommentFieldValue(
  const Value: String);
begin

  ChargeSetHolder.PerformerCommentFieldValue := Value;
  
end;

procedure TDocumentChargeSheetSetHolder.SetPerformerDepartmentIdFieldName(
  const Value: String);
begin

  FieldDefs.PerformerDepartmentIdFieldName := Value;
  
end;

procedure TDocumentChargeSheetSetHolder.SetPerformerDepartmentIdFieldValue(
  const Value: Variant);
begin

  ChargeSetHolder.PerformerDepartmentIdFieldName := Value;
  
end;

procedure TDocumentChargeSheetSetHolder.SetPerformerDepartmentNameFieldName(
  const Value: String);
begin

  FieldDefs.PerformerDepartmentNameFieldName := Value;
  
end;

procedure TDocumentChargeSheetSetHolder.SetPerformerDepartmentNameFieldValue(
  const Value: String);
begin

  ChargeSetHolder.PerformerDepartmentNameFieldValue := Value;

end;

procedure TDocumentChargeSheetSetHolder.SetPerformerFullNameFieldName(
  const Value: String);
begin

  FieldDefs.PerformerFullNameFieldName := Value;

end;

procedure TDocumentChargeSheetSetHolder.SetPerformerFullNameFieldValue(
  const Value: String);
begin

  ChargeSetHolder.PerformerFullNameFieldValue := Value;
  
end;

procedure TDocumentChargeSheetSetHolder.SetPerformerIdFieldName(
  const Value: String);
begin

  FieldDefs.PerformerIdFieldName := Value;
  
end;

procedure TDocumentChargeSheetSetHolder.SetPerformerIdFieldValue(
  const Value: Variant);
begin

  ChargeSetHolder.PerformerIdFieldValue := Value;
  
end;

procedure TDocumentChargeSheetSetHolder.SetPerformerSpecialityFieldName(
  const Value: String);
begin

  FieldDefs.PerformerSpecialityFieldName := Value;
  
end;

procedure TDocumentChargeSheetSetHolder.SetPerformerSpecialityFieldValue(
  const Value: String);
begin

  ChargeSetHolder.PerformerSpecialityFieldValue := Value;

end;

procedure TDocumentChargeSheetSetHolder.SetPerformingAllowedFieldName(
  const Value: String);
begin

  FieldDefs.PerformingAllowedFieldName := Value;

end;

procedure TDocumentChargeSheetSetHolder.SetPerformingAllowedFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(PerformingAllowedFieldName, Value);
  
end;

procedure TDocumentChargeSheetSetHolder.SetPerformingDateTimeFieldName(
  const Value: String);
begin

  FieldDefs.PerformingDateTimeFieldName := Value;
  
end;

procedure TDocumentChargeSheetSetHolder.SetPerformingDateTimeFieldValue(
  const Value: Variant);
begin

  ChargeSetHolder.PerformingDateTimeFieldValue := Value;

end;

procedure TDocumentChargeSheetSetHolder.SetRemovingAllowedFieldName(
  const Value: String);
begin

  FieldDefs.RemovingAllowedFieldName := Value;
  
end;

procedure TDocumentChargeSheetSetHolder.SetRemovingAllowedFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(RemovingAllowedFieldName, Value);
  
end;

procedure TDocumentChargeSheetSetHolder.SetResponseSectionAccessibleFieldName(
  const Value: String);
begin

  FieldDefs.ResponseSectionAccessibleFieldName := Value;

end;

procedure TDocumentChargeSheetSetHolder.SetResponseSectionAccessibleFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(ResponseSectionAccessibleFieldName, Value);

end;

procedure TDocumentChargeSheetSetHolder.SetSubordinateChargeSheetsIssuingAllowedFieldName(
  const Value: String);
begin

  FieldDefs.SubordinateChargeSheetsIssuingAllowedFieldName := Value;

end;

procedure TDocumentChargeSheetSetHolder.SetSubordinateChargeSheetsIssuingAllowedFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(SubordinateChargeSheetsIssuingAllowedFieldName, Value);
  
end;

procedure TDocumentChargeSheetSetHolder.SetTopLevelChargeSheetIdFieldName(
  const Value: String);
begin

  FieldDefs.TopLevelChargeSheetIdFieldName := Value;

end;

procedure TDocumentChargeSheetSetHolder.SetTopLevelChargeSheetIdFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(TopLevelChargeSheetIdFieldName, Value);

end;

procedure TDocumentChargeSheetSetHolder.SetViewDateByPerformerFieldName(
  const Value: String);
begin

  FieldDefs.ViewDateByPerformerFieldName := Value;
  
end;

procedure TDocumentChargeSheetSetHolder.SetViewDateByPerformerFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(ViewDateByPerformerFieldName, Value);

end;

procedure TDocumentChargeSheetSetHolder.SetViewingAllowedFieldName(
  const Value: String);
begin

  FieldDefs.ViewingAllowedFieldName := Value;

end;

procedure TDocumentChargeSheetSetHolder.SetViewingAllowedFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(ViewingAllowedFieldName, Value);
  
end;

function TDocumentChargeSheetSetHolder.GetActualPerformerFullNameFieldName: String;
begin

  Result := FieldDefs.ActualPerformerFullNameFieldName;

end;

function TDocumentChargeSheetSetHolder.GetActualPerformerFullNameFieldValue: String;
begin

  Result := ChargeSetHolder.ActualPerformerFullNameFieldValue;
  
end;

function TDocumentChargeSheetSetHolder.GetChargeIdFieldName: String;
begin

  Result := FieldDefs.ChargeIdFieldName;

end;

function TDocumentChargeSheetSetHolder.GetChargeIdFieldValue: Variant;
begin

  Result := ChargeSetHolder.IdFieldValue;

end;

function TDocumentChargeSheetSetHolder.GetChargeSectionAccessibleFieldName: String;
begin

  Result := FieldDefs.ChargeSectionAccessibleFieldName;
  
end;

function TDocumentChargeSheetSetHolder.GetChargeSectionAccessibleFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(ChargeSectionAccessibleFieldName, Null);
  
end;

function TDocumentChargeSheetSetHolder.GetChargeSetFieldDefs: TDocumentChargeSetFieldDefs;
begin

  Result := FChargeSetHolder.FieldDefs;
  
end;

function TDocumentChargeSheetSetHolder.GetChargeSetHolder: TDocumentChargeSetHolder;
begin

  Result := FChargeSetHolder;
  
end;

function TDocumentChargeSheetSetHolder.GetChargeSheetSetFieldDefs: TDocumentChargeSheetSetFieldDefs;
begin

  Result := TDocumentChargeSheetSetFieldDefs(inherited FieldDefs);
  
end;

function TDocumentChargeSheetSetHolder.GetChargeTextFieldName: String;
begin

  Result := FieldDefs.ChargeTextFieldName;
  
end;

function TDocumentChargeSheetSetHolder.GetChargeTextFieldValue: String;
begin

  Result := ChargeSetHolder.ChargeTextFieldValue;
  
end;

function TDocumentChargeSheetSetHolder.GetDataSet: TDataSet;
begin

  Result := inherited GetDataSet;
  
end;

class function TDocumentChargeSheetSetHolder.GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass;
begin

  Result := TDocumentChargeSheetSetFieldDefs;
  
end;

function TDocumentChargeSheetSetHolder.GetDocumentIdFieldName: String;
begin

  Result := FieldDefs.DocumentIdFieldName;
  
end;

function TDocumentChargeSheetSetHolder.GetDocumentIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(DocumentIdFieldName, Null);
  
end;

function TDocumentChargeSheetSetHolder.GetIdFieldName: String;
begin

  Result := FieldDefs.IdFieldName;
  
end;

function TDocumentChargeSheetSetHolder.GetIdFieldValue: Variant;
begin

  Result := RecordIdFieldValue;

end;

function TDocumentChargeSheetSetHolder.GetIsEmployeePerformerFieldName: String;
begin

  Result := FieldDefs.IsEmployeePerformerFieldName;

end;

function TDocumentChargeSheetSetHolder.GetIsEmployeePerformerFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(IsEmployeePerformerFieldName, Null);

end;

function TDocumentChargeSheetSetHolder.GetIsForAcquaitanceFieldName: String;
begin

  Result := FieldDefs.IsForAcquaitanceFieldName;
  
end;

function TDocumentChargeSheetSetHolder.GetIsForAcquaitanceFieldValue: Boolean;
begin

  Result := ChargeSetHolder.IsForAcquaitanceFieldValue;

end;

function TDocumentChargeSheetSetHolder.GetIsPerformerForeignFieldName: String;
begin

  Result := FieldDefs.IsPerformerForeignFieldName;
  
end;

function TDocumentChargeSheetSetHolder.GetIsPerformerForeignFieldValue: Boolean;
begin

  Result := ChargeSetHolder.IsPerformerForeignFieldValue;
  
end;

function TDocumentChargeSheetSetHolder.GetIssuerIdFieldName: String;
begin

  Result := FieldDefs.IssuerIdFieldName;

end;

function TDocumentChargeSheetSetHolder.GetIssuerIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(IssuerIdFieldName, Null);
  
end;

function TDocumentChargeSheetSetHolder.GetIssuerNameFieldName: String;
begin

  Result := FieldDefs.IssuerNameFieldName;
  
end;

function TDocumentChargeSheetSetHolder.GetIssuerNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(IssuerNameFieldName, '');
  
end;

function TDocumentChargeSheetSetHolder.GetIssuingDateTimeFieldName: String;
begin

  Result := FieldDefs.IssuingDateTimeFieldName;
  
end;

function TDocumentChargeSheetSetHolder.GetIssuingDateTimeFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(IssuingDateTimeFieldName, Null);

end;

function TDocumentChargeSheetSetHolder.GetKindIdFieldName: String;
begin

  Result := FieldDefs.KindIdFieldName;
  
end;

function TDocumentChargeSheetSetHolder.GetKindIdFieldValue: Variant;
begin

  Result := FChargeSetHolder.KindIdFieldValue;

end;

function TDocumentChargeSheetSetHolder.GetKindNameFieldName: String;
begin

  Result := FieldDefs.KindNameFieldName;
  
end;

function TDocumentChargeSheetSetHolder.GetKindNameFieldValue: String;
begin

  Result := FChargeSetHolder.KindNameFieldValue;
  
end;

function TDocumentChargeSheetSetHolder.GetKindServiceNameFieldName: String;
begin

  Result := FieldDefs.KindServiceNameFieldName;
  
end;

function TDocumentChargeSheetSetHolder.GetKindServiceNameFieldValue: String;
begin

  Result := FChargeSetHolder.KindServiceNameFieldValue;
  
end;

function TDocumentChargeSheetSetHolder.GetPerformerCommentFieldName: String;
begin

  Result := FieldDefs.PerformerCommentFieldName;

end;

function TDocumentChargeSheetSetHolder.GetPerformerCommentFieldValue: String;
begin

  Result := FChargeSetHolder.PerformerCommentFieldValue;
  
end;

function TDocumentChargeSheetSetHolder.GetPerformerDepartmentIdFieldName: String;
begin

  Result := FieldDefs.PerformerDepartmentIdFieldName;
  
end;

function TDocumentChargeSheetSetHolder.GetPerformerDepartmentIdFieldValue: Variant;
begin

  Result := FChargeSetHolder.PerformerDepartmentIdFieldValue;

end;

function TDocumentChargeSheetSetHolder.GetPerformerDepartmentNameFieldName: String;
begin

  Result := FieldDefs.PerformerDepartmentNameFieldName;

end;

function TDocumentChargeSheetSetHolder.GetPerformerDepartmentNameFieldValue: String;
begin

  Result := FChargeSetHolder.PerformerDepartmentNameFieldValue;
  
end;

function TDocumentChargeSheetSetHolder.GetPerformerFullNameFieldName: String;
begin

  Result := FieldDefs.PerformerFullNameFieldName;

end;

function TDocumentChargeSheetSetHolder.GetPerformerFullNameFieldValue: String;
begin

  Result := FChargeSetHolder.PerformerFullNameFieldValue;
  
end;

function TDocumentChargeSheetSetHolder.GetPerformerIdFieldName: String;
begin

  Result := FieldDefs.PerformerIdFieldName;
  
end;

function TDocumentChargeSheetSetHolder.GetPerformerIdFieldValue: Variant;
begin

  Result := FChargeSetHolder.PerformerIdFieldValue;

end;

function TDocumentChargeSheetSetHolder.GetPerformerSpecialityFieldName: String;
begin

  Result := FieldDefs.PerformerSpecialityFieldName;

end;

function TDocumentChargeSheetSetHolder.GetPerformerSpecialityFieldValue: String;
begin

  Result := FChargeSetHolder.PerformerSpecialityFieldValue;
  
end;

function TDocumentChargeSheetSetHolder.GetPerformingAllowedFieldName: String;
begin

  Result := FieldDefs.PerformingAllowedFieldName;

end;

function TDocumentChargeSheetSetHolder.GetPerformingAllowedFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(PerformingAllowedFieldName, Null);

end;

function TDocumentChargeSheetSetHolder.GetPerformingDateTimeFieldName: String;
begin

  Result := FieldDefs.PerformingDateTimeFieldName;

end;

function TDocumentChargeSheetSetHolder.GetPerformingDateTimeFieldValue: Variant;
begin

  Result := FChargeSetHolder.PerformingDateTimeFieldValue;

end;

function TDocumentChargeSheetSetHolder.GetRemovingAllowedFieldName: String;
begin

  Result := FieldDefs.RemovingAllowedFieldName;

end;

function TDocumentChargeSheetSetHolder.GetRemovingAllowedFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(RemovingAllowedFieldName, Null);

end;

function TDocumentChargeSheetSetHolder.GetResponseSectionAccessibleFieldName: String;
begin

  Result := FieldDefs.ResponseSectionAccessibleFieldName;

end;

function TDocumentChargeSheetSetHolder.GetResponseSectionAccessibleFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(ResponseSectionAccessibleFieldName, Null);
  
end;

function TDocumentChargeSheetSetHolder.GetSubordinateChargeSheetsIssuingAllowedFieldName: String;
begin

  Result := FieldDefs.SubordinateChargeSheetsIssuingAllowedFieldName;

end;

function TDocumentChargeSheetSetHolder.GetSubordinateChargeSheetsIssuingAllowedFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(SubordinateChargeSheetsIssuingAllowedFieldName, Null);

end;

function TDocumentChargeSheetSetHolder.GetTopLevelChargeSheetIdFieldName: String;
begin

  Result := FieldDefs.TopLevelChargeSheetIdFieldName;

end;

function TDocumentChargeSheetSetHolder.GetTopLevelChargeSheetIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(TopLevelChargeSheetIdFieldName, Null);
  
end;

function TDocumentChargeSheetSetHolder.GetViewDateByPerformerFieldName: String;
begin

  Result := FieldDefs.ViewDateByPerformerFieldName;

end;

function TDocumentChargeSheetSetHolder.GetViewDateByPerformerFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(ViewDateByPerformerFieldName, Null);
  
end;

function TDocumentChargeSheetSetHolder.GetViewingAllowedFieldName: String;
begin

  Result := FieldDefs.ViewingAllowedFieldName;

end;

function TDocumentChargeSheetSetHolder.GetViewingAllowedFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(ViewingAllowedFieldName, Null);

end;

procedure TDocumentChargeSheetSetHolder.MarkCurrentAndAllSubordinateRecordsAsRemoved;
var
    RecordIds: TVariantList;
    RecordId: Variant;
    PreviousFilter: String;
    PreviousFiltered: Boolean;
begin

  RecordIds := TVariantList.Create;

  PreviousFilter := DataSet.Filter;
  PreviousFiltered := DataSet.Filtered;

  DisableControls;

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

    FreeAndNil(RecordIds);

    DataSet.Filter := PreviousFilter;
    DataSet.Filtered := PreviousFiltered;

    EnableControls;

  end;

end;

end.
