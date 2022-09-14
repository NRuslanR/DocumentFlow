unit DepartmentSetHolder;

interface

uses

  AbstractDataSetHolder,
  SysUtils;

type

  TDepartmentSetFieldDefs = class (TAbstractDataSetFieldDefs)

    private

      function GetDepartmentIdFieldName: String;
      procedure SetDepartmentIdFieldName(const Value: String);

    public

      property DepartmentIdFieldName: String
      read GetDepartmentIdFieldName write SetDepartmentIdFieldName;

    public

      IsSelectedFieldName: String;
      CodeFieldName: String;
      ShortNameFieldName: String;
      FullNameFieldName: String;

  end;

  TDepartmentSetHolder = class (TAbstractDataSetHolder)

    protected

      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;
      
    private

      function GetCodeFieldName: String;
      function GetCodeFieldValue: String;
      function GetDepartmentIdFieldName: String;
      function GetDepartmentIdFieldValue: Variant;
      function GetDepartmentSetFieldDefs: TDepartmentSetFieldDefs;
      function GetFullNameFieldName: String;
      function GetFullNameFieldValue: String;
      function GetShortNameFieldName: String;
      function GetShortNameFieldValue: String;
      function GetIsSelectedFieldName: String;
      function GetIsSelectedFieldValue: Boolean;

      procedure SetCodeFieldName(const Value: String);
      procedure SetCodeFieldValue(const Value: String);
      procedure SetDepartmentIdFieldName(const Value: String);
      procedure SetDepartmentIdFieldValue(const Value: Variant);
      procedure SetDepartmentSetFieldDefs(const Value: TDepartmentSetFieldDefs);
      procedure SetFullNameFieldName(const Value: String);
      procedure SetFullNameFieldValue(const Value: String);
      procedure SetShortNameFieldName(const Value: String);
      procedure SetShortNameFieldValue(const Value: String);
      procedure SetIsSelectedFieldName(const Value: String);
      procedure SetIsSelectedFieldValue(const Value: Boolean);

    public

      property IsSelectedFieldName: String
      read GetIsSelectedFieldName write SetIsSelectedFieldName;
      
      property DepartmentIdFieldName: String
      read GetDepartmentIdFieldName write SetDepartmentIdFieldName;
      
      property CodeFieldName: String
      read GetCodeFieldName write SetCodeFieldName;

      property ShortNameFieldName: String
      read GetShortNameFieldName write SetShortNameFieldName;

      property FullNameFieldName: String
      read GetFullNameFieldName write SetFullNameFieldName;

    public

      property IsSelectedFieldValue: Boolean
      read GetIsSelectedFieldValue write SetIsSelectedFieldValue;
      
      property DepartmentIdFieldValue: Variant
      read GetDepartmentIdFieldValue write SetDepartmentIdFieldValue;
      
      property CodeFieldValue: String
      read GetCodeFieldValue write SetCodeFieldValue;

      property ShortNameFieldValue: String
      read GetShortNameFieldValue write SetShortNameFieldValue;

      property FullNameFieldValue: String
      read GetFullNameFieldValue write SetFullNameFieldValue;

    public

      property FieldDefs: TDepartmentSetFieldDefs
      read GetDepartmentSetFieldDefs write SetDepartmentSetFieldDefs;

  end;

implementation

{ TDepartmentSetFieldDefs }

function TDepartmentSetFieldDefs.GetDepartmentIdFieldName: String;
begin

  Result := RecordIdFieldName;

end;

procedure TDepartmentSetFieldDefs.SetDepartmentIdFieldName(
  const Value: String);
begin

  RecordIdFieldName := Value;
  
end;

{ TDepartmentSetHolder }

function TDepartmentSetHolder.GetCodeFieldName: String;
begin

  Result := FieldDefs.CodeFieldName;

end;

function TDepartmentSetHolder.GetCodeFieldValue: String;
begin

  Result := GetDataSetFieldValue(CodeFieldname, '');

end;

class function TDepartmentSetHolder.GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass;
begin

  Result := TDepartmentSetFieldDefs;
  
end;

function TDepartmentSetHolder.GetDepartmentIdFieldName: String;
begin

  Result := RecordIdFieldName

end;

function TDepartmentSetHolder.GetDepartmentIdFieldValue: Variant;
begin

  Result := RecordIdFieldValue;

end;

function TDepartmentSetHolder.GetDepartmentSetFieldDefs: TDepartmentSetFieldDefs;
begin

  Result := TDepartmentSetFieldDefs(inherited FieldDefs);
  
end;

function TDepartmentSetHolder.GetFullNameFieldName: String;
begin

  Result := FieldDefs.FullNameFieldName;

end;

function TDepartmentSetHolder.GetFullNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(FullNameFieldName, '');

end;

function TDepartmentSetHolder.GetIsSelectedFieldName: String;
begin

  Result := FieldDefs.IsSelectedFieldName;

end;

function TDepartmentSetHolder.GetIsSelectedFieldValue: Boolean;
begin

  Result := GetDataSetFieldValue(IsSelectedFieldName, False);
  
end;

function TDepartmentSetHolder.GetShortNameFieldName: String;
begin

  Result := FieldDefs.ShortNameFieldName;
  
end;

function TDepartmentSetHolder.GetShortNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(ShortNameFieldName, '');
  
end;

procedure TDepartmentSetHolder.SetCodeFieldName(const Value: String);
begin

  FieldDefs.CodeFieldName := Value;

end;

procedure TDepartmentSetHolder.SetCodeFieldValue(const Value: String);
begin

  SetDataSetFieldValue(CodeFieldName, Value);
  
end;

procedure TDepartmentSetHolder.SetDepartmentIdFieldName(const Value: String);
begin

  FieldDefs.DepartmentIdFieldName := Value;
  
end;

procedure TDepartmentSetHolder.SetDepartmentIdFieldValue(const Value: Variant);
begin

  RecordIdFieldValue := Value;

end;

procedure TDepartmentSetHolder.SetDepartmentSetFieldDefs(
  const Value: TDepartmentSetFieldDefs);
begin

  inherited FieldDefs := Value;
  
end;

procedure TDepartmentSetHolder.SetFullNameFieldName(const Value: String);
begin

  FieldDefs.FullNameFieldName := Value;

end;

procedure TDepartmentSetHolder.SetFullNameFieldValue(const Value: String);
begin

  SetDataSetFieldValue(FullNameFieldName, Value);
  
end;

procedure TDepartmentSetHolder.SetIsSelectedFieldName(const Value: String);
begin

  FieldDefs.IsSelectedFieldName := Value;
  
end;

procedure TDepartmentSetHolder.SetIsSelectedFieldValue(const Value: Boolean);
begin

  SetDataSetFieldValue(IsSelectedFieldName, Value);
  
end;

procedure TDepartmentSetHolder.SetShortNameFieldName(const Value: String);
begin

  FieldDefs.ShortNameFieldName := Value;

end;

procedure TDepartmentSetHolder.SetShortNameFieldValue(const Value: String);
begin

  SetDataSetFieldValue(ShortNameFieldName, Value);
  
end;

end.
