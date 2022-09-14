unit EmployeeDocumentSetHolder;

interface

uses

  DocumentSetHolder,
  AbstractDataSetHolder,
  AbstractDocumentSetHolderDecorator,
  SysUtils,
  Classes;

type

  TEmployeeDocumentSetFieldDefs = class (TAbstractDocumentSetFieldDefsDecorator)

    public

      IsViewedFieldName: String;
      OwnChargeSheetFieldName: String;
      AllChargeSheetsPerformedFieldName: String;
      AllSubordinateChargeSheetsPerformedFieldName: String;
      
  end;

  TEmployeeDocumentSetHolder = class (TAbstractDocumentSetHolderDecorator)

    private

      function GetIsViewedFieldName: String;
      function GetIsViewedFieldValue: Variant;
      function GetEmployeeDocumentSetFieldDefs: TEmployeeDocumentSetFieldDefs;
      function GetOwnChargeSheetFieldName: String;
      function GetOwnChargeSheetFieldValue: Variant;
      function GetAllChargeSheetsPerformedFieldName: String;
      function GetAllChargeSheetsPerformedFieldValue: Variant;
      function GetAllSubordinateChargeSheetsPerformedFieldName: String;
      function GetAllSubordinateChargeSheetsPerformedFieldValue: Variant;

      procedure SetIsViewedFieldName(const Value: String);
      procedure SetIsViewedFieldValue(const Value: Variant);
      procedure SetOwnChargeSheetFieldName(const Value: String);
      procedure SetOwnChargeSheetFieldValue(const Value: Variant);
      procedure SetAllChargeSheetsPerformedFieldName(const Value: String);
      procedure SetAllChargeSheetsPerformedFieldValue(const Value: Variant);

      procedure SetAllSubordinateChargeSheetsPerformedFieldName(const Value: String);

      procedure SetAllSubordinateChargeSheetsPerformedFieldValue(const Value: Variant);

      procedure SetEmployeeDocumentSetFieldDefs(const Value: TEmployeeDocumentSetFieldDefs);

    protected

      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;
      
    public

      constructor Create; override;

    public

      property IsViewedFieldName: String
      read GetIsViewedFieldName write SetIsViewedFieldName;

      property OwnChargeSheetFieldName: String
      read GetOwnChargeSheetFieldName write SetOwnChargeSheetFieldName;

      property AllChargeSheetsPerformedFieldName: String
      read GetAllChargeSheetsPerformedFieldName
      write SetAllChargeSheetsPerformedFieldName;

      property AllSubordinateChargeSheetsPerformedFieldName: String
      read GetAllSubordinateChargeSheetsPerformedFieldName
      write SetAllSubordinateChargeSheetsPerformedFieldName;

    public
    
      property IsViewedFieldValue: Variant
      read GetIsViewedFieldValue write SetIsViewedFieldValue;

      property OwnChargeSheetFieldValue: Variant
      read GetOwnChargeSheetFieldValue write SetOwnChargeSheetFieldValue;
        
      property AllChargeSheetsPerformedFieldValue: Variant
      read GetAllChargeSheetsPerformedFieldValue
      write SetAllChargeSheetsPerformedFieldValue;

      property AllSubordinateChargeSheetsPerformedFieldValue: Variant
      read GetAllSubordinateChargeSheetsPerformedFieldValue
      write SetAllSubordinateChargeSheetsPerformedFieldValue;

    public

      property FieldDefs: TEmployeeDocumentSetFieldDefs
      read GetEmployeeDocumentSetFieldDefs
      write SetEmployeeDocumentSetFieldDefs;
      
  end;
  
implementation

uses

  Variants;
  
{ TEmployeeDocumentSetHolder }

constructor TEmployeeDocumentSetHolder.Create;
begin

  inherited;

end;

class function TEmployeeDocumentSetHolder.GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass;
begin

  Result := TEmployeeDocumentSetFieldDefs;
  
end;

function TEmployeeDocumentSetHolder.
  GetEmployeeDocumentSetFieldDefs: TEmployeeDocumentSetFieldDefs;
begin

  Result := TEmployeeDocumentSetFieldDefs(inherited FieldDefs);
  
end;

function TEmployeeDocumentSetHolder.GetIsViewedFieldName: String;
begin

  Result := FieldDefs.IsViewedFieldName;
  
end;

function TEmployeeDocumentSetHolder.GetIsViewedFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(IsViewedFieldName, Null);
  
end;

procedure TEmployeeDocumentSetHolder.SetEmployeeDocumentSetFieldDefs(
  const Value: TEmployeeDocumentSetFieldDefs);
begin

  inherited FieldDefs := Value;
  
end;

procedure TEmployeeDocumentSetHolder.SetIsViewedFieldName(
  const Value: String);
begin

  FieldDefs.IsViewedFieldName := Value;

end;

function TEmployeeDocumentSetHolder.GetAllChargeSheetsPerformedFieldName: String;
begin

  Result := FieldDefs.AllChargeSheetsPerformedFieldName;
  
end;

function TEmployeeDocumentSetHolder.GetAllChargeSheetsPerformedFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(AllChargeSheetsPerformedFieldName, Null);

end;

function TEmployeeDocumentSetHolder.GetAllSubordinateChargeSheetsPerformedFieldName: String;
begin

  Result := FieldDefs.AllSubordinateChargeSheetsPerformedFieldName;

end;

function TEmployeeDocumentSetHolder.GetAllSubordinateChargeSheetsPerformedFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(AllSubordinateChargeSheetsPerformedFieldName, Null);
  
end;

function TEmployeeDocumentSetHolder.GetOwnChargeSheetFieldName: String;
begin

  Result := FieldDefs.OwnChargeSheetFieldName;
  
end;

function TEmployeeDocumentSetHolder.GetOwnChargeSheetFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(OwnChargeSheetFieldName, Null);
  
end;

procedure TEmployeeDocumentSetHolder.SetAllChargeSheetsPerformedFieldName(
  const Value: String);
begin

  FieldDefs.AllChargeSheetsPerformedFieldName := Value;
  
end;

procedure TEmployeeDocumentSetHolder.SetAllChargeSheetsPerformedFieldValue(
  const Value: Variant);
begin

  if IsDataSetFieldExists(AllChargeSheetsPerformedFieldName) then
    SetDataSetFieldValue(AllChargeSheetsPerformedFieldName, Value);

end;

procedure TEmployeeDocumentSetHolder.SetAllSubordinateChargeSheetsPerformedFieldName(
  const Value: String);
begin

  FieldDefs.AllSubordinateChargeSheetsPerformedFieldName := Value;
  
end;

procedure TEmployeeDocumentSetHolder.SetAllSubordinateChargeSheetsPerformedFieldValue(
  const Value: Variant);
begin

  if IsDataSetFieldExists(AllSubordinateChargeSheetsPerformedFieldName) then
    SetDataSetFieldValue(AllSubordinateChargeSheetsPerformedFieldName, Value);

end;

procedure TEmployeeDocumentSetHolder.SetOwnChargeSheetFieldName(
  const Value: String);
begin

  FieldDefs.OwnChargeSheetFieldName := Value;
  
end;

procedure TEmployeeDocumentSetHolder.SetOwnChargeSheetFieldValue(
  const Value: Variant);
begin

  if IsDataSetFieldExists(OwnChargeSheetFieldName) then
    SetDataSetFieldValue(OwnChargeSheetFieldName, Value);

end;

procedure TEmployeeDocumentSetHolder.SetIsViewedFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(IsViewedFieldName, Value);

end;

end.
