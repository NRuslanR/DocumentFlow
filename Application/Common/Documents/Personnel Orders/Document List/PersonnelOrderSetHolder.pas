unit PersonnelOrderSetHolder;

interface

uses

  AbstractDataSetHolder,
  DocumentSetHolder,
  SysUtils,
  Classes;

type

  TPersonnelOrderSetFieldDefs = class (TDocumentSetFieldDefs)

    public

      SubKindIdFieldName: String;
      SubKindNameFieldName: String;
  end;

  TPersonnelOrderSetHolder = class (TDocumentSetHolder)

    private

      function GetPersonnelOrderSetFieldDefs: TPersonnelOrderSetFieldDefs;
      function GetSubKindIdFieldName: String;
      function GetSubKindIdFieldValue: Variant;
      function GetSubKindNameFieldName: String;
      function GetSubKindNameFieldValue: String;

    private
    
      procedure SetPersonnelOrderSetFieldDefs(
        const Value: TPersonnelOrderSetFieldDefs);

      procedure SetSubKindIdFieldName(const Value: String);
      procedure SetSubKindIdFieldValue(const Value: Variant);
      procedure SetSubKindNameFieldName(const Value: String);
      procedure SetSubKindNameFieldValue(const Value: String);

    protected

      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;

    public

      property SubKindIdFieldName: String
      read GetSubKindIdFieldName write SetSubKindIdFieldName;

      property SubKindNameFieldName: String
      read GetSubKindNameFieldName write SetSubKindNameFieldName;

    public

      property SubKindIdFieldValue: Variant
      read GetSubKindIdFieldValue write SetSubKindIdFieldValue;

      property SubKindNameFieldValue: String
      read GetSubKindNameFieldValue write SetSubKindNameFieldValue;

    public

      property FieldDefs: TPersonnelOrderSetFieldDefs
      read GetPersonnelOrderSetFieldDefs write SetPersonnelOrderSetFieldDefs;
      
  end;

implementation

uses

  Variants,
  AuxDebugFunctionsUnit;
  
{ TPersonnelOrderSetHolder }

class function TPersonnelOrderSetHolder.GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass;
begin

  Result := TPersonnelOrderSetFieldDefs;
  
end;

function TPersonnelOrderSetHolder.GetPersonnelOrderSetFieldDefs: TPersonnelOrderSetFieldDefs;
begin

  Result := TPersonnelOrderSetFieldDefs(inherited FieldDefs);
  
end;

function TPersonnelOrderSetHolder.GetSubKindIdFieldName: String;
begin

  Result := FieldDefs.SubKindIdFieldName;
  
end;

function TPersonnelOrderSetHolder.GetSubKindIdFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(SubKindIdFieldName, Null);
  
end;

function TPersonnelOrderSetHolder.GetSubKindNameFieldName: String;
begin

  Result := FieldDefs.SubKindNameFieldName;
  
end;

function TPersonnelOrderSetHolder.GetSubKindNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(SubKindNameFieldName, '');
  
end;

procedure TPersonnelOrderSetHolder.SetPersonnelOrderSetFieldDefs(
  const Value: TPersonnelOrderSetFieldDefs);
begin

  inherited FieldDefs := Value;
  
end;

procedure TPersonnelOrderSetHolder.SetSubKindIdFieldName(const Value: String);
begin

  FieldDefs.SubKindIdFieldName := Value;
  
end;

procedure TPersonnelOrderSetHolder.SetSubKindIdFieldValue(const Value: Variant);
begin

  SetDataSetFieldValue(SubKindIdFieldName, Value);
  
end;

procedure TPersonnelOrderSetHolder.SetSubKindNameFieldName(const Value: String);
begin

  FieldDefs.SubKindNameFieldName := Value;

end;

procedure TPersonnelOrderSetHolder.SetSubKindNameFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(SubKindNameFieldName, Value);

end;

end.
