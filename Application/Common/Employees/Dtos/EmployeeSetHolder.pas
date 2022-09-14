unit EmployeeSetHolder;

interface

uses

  AbstractDataSetHolder,
  SysUtils,
  Classes;

type

  TEmployeeSetFieldDefs = class (TAbstractDataSetFieldDefs)

    public

      PersonnelNumberFieldName: String;
      NameFieldName: String;
      SurnameFieldName: String;
      PatronymicFieldName: String;
      TelephoneNumberFieldName: String;
      IsForeignFieldName: String;
      SpecialityFieldName: String;
      DepartmentCodeFieldName: String;
      DepartmentShortNameFieldName: String;

  end;
  
  TEmployeeSetHolder = class (TAbstractDataSetHolder)

    private

      function GetDepartmentCodeFieldName: String;
      function GetDepartmentCodeFieldValue: String;
      function GetDepartmentShortNameFieldName: String;
      function GetDepartmentShortNameFieldValue: String;
      function GetIsForeignFieldName: String;
      function GetIsForeignFieldValue: Boolean;
      function GetNameFieldName: String;
      function GetNameFieldValue: String;
      function GetPatronymicFieldName: String;
      function GetPatronymicFieldValue: String;
      function GetPersonnelNumberFieldName: String;
      function GetPersonnelNumberFieldValue: String;
      function GetSurnameFieldName: String;
      function GetSurnameFieldValue: String;
      function GetTelephoneNumberFieldName: String;
      function GetTelephoneNumberFieldValue: String;
      function GetSpecialityFieldName: String;
      function GetSpecialityFieldValue: String;

      function GetEmployeeSetFieldDefs: TEmployeeSetFieldDefs;
      
      procedure SetDepartmentCodeFieldName(const Value: String);
      procedure SetDepartmentCodeFieldValue(const Value: String);
      procedure SetDepartmentShortNameFieldName(const Value: String);
      procedure SetDepartmentShortNameFieldValue(const Value: String);
      procedure SetIsForeignFieldName(const Value: String);
      procedure SetIsForeignFieldValue(const Value: Boolean);
      procedure SetNameFieldName(const Value: String);
      procedure SetNameFieldValue(const Value: String);
      procedure SetPatronymicFieldName(const Value: String);
      procedure SetPatronymicFieldValue(const Value: String);
      procedure SetPersonnelNumberFieldName(const Value: String);
      procedure SetPersonnelNumberFieldValue(const Value: String);
      procedure SetSurnameFieldName(const Value: String);
      procedure SetSurnameFieldValue(const Value: String);
      procedure SetTelephoneNumberFieldName(const Value: String);
      procedure SetTelephoneNumberFieldValue(const Value: String);
      procedure SetSpecialityFieldName(const Value: String);
      procedure SetSpecialityFieldValue(const Value: String);
    
      procedure SetEmployeeSetFieldDefs(const Value: TEmployeeSetFieldDefs);
      
    protected

      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;

    public

      property PersonnelNumberFieldName: String
      read GetPersonnelNumberFieldName write SetPersonnelNumberFieldName;

      property NameFieldName: String
      read GetNameFieldName write SetNameFieldName;

      property SurnameFieldName: String
      read GetSurnameFieldName write SetSurnameFieldName;

      property PatronymicFieldName: String
      read GetPatronymicFieldName write SetPatronymicFieldName;
      
      property TelephoneNumberFieldName: String
      read GetTelephoneNumberFieldName write SetTelephoneNumberFieldName;

      property IsForeignFieldName: String
      read GetIsForeignFieldName write SetIsForeignFieldName;

      property SpecialityFieldName: String
      read GetSpecialityFieldName write SetSpecialityFieldName;
      
      property DepartmentCodeFieldName: String
      read GetDepartmentCodeFieldName write SetDepartmentCodeFieldName;

      property DepartmentShortNameFieldName: String
      read GetDepartmentShortNameFieldName write SetDepartmentShortNameFieldName;

    public

      property PersonnelNumberFieldValue: String
      read GetPersonnelNumberFieldValue write SetPersonnelNumberFieldValue;

      property NameFieldValue: String
      read GetNameFieldValue write SetNameFieldValue;

      property SurnameFieldValue: String
      read GetSurnameFieldValue write SetSurnameFieldValue;

      property PatronymicFieldValue: String
      read GetPatronymicFieldValue write SetPatronymicFieldValue;
      
      property TelephoneNumberFieldValue: String
      read GetTelephoneNumberFieldValue write SetTelephoneNumberFieldValue;

      property IsForeignFieldValue: Boolean
      read GetIsForeignFieldValue write SetIsForeignFieldValue;

      property SpecialityFieldValue: String
      read GetSpecialityFieldValue write SetSpecialityFieldValue;
      
      property DepartmentCodeFieldValue: String
      read GetDepartmentCodeFieldValue write SetDepartmentCodeFieldValue;

      property DepartmentShortNameFieldValue: String
      read GetDepartmentShortNameFieldValue write SetDepartmentShortNameFieldValue;

    public

      property FieldDefs: TEmployeeSetFieldDefs
      read GetEmployeeSetFieldDefs write SetEmployeeSetFieldDefs;
  end;
  
implementation

{ TEmployeeSetHolder }

class function TEmployeeSetHolder.GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass;
begin

  Result := TEmployeeSetFieldDefs;
  
end;

function TEmployeeSetHolder.GetDepartmentCodeFieldName: String;
begin

  Result := FieldDefs.DepartmentCodeFieldName;
  
end;

function TEmployeeSetHolder.GetDepartmentCodeFieldValue: String;
begin

  Result := GetDataSetFieldValue(DepartmentCodeFieldName, '');
  
end;

function TEmployeeSetHolder.GetDepartmentShortNameFieldName: String;
begin

  Result := FieldDefs.DepartmentShortNameFieldName;

end;

function TEmployeeSetHolder.GetDepartmentShortNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(DepartmentShortNameFieldName, '');

end;

function TEmployeeSetHolder.GetEmployeeSetFieldDefs: TEmployeeSetFieldDefs;
begin

  Result := TEmployeeSetFieldDefs(inherited FieldDefs);

end;

function TEmployeeSetHolder.GetIsForeignFieldName: String;
begin

  Result := FieldDefs.IsForeignFieldName;
  
end;

function TEmployeeSetHolder.GetIsForeignFieldValue: Boolean;
begin

  Result := GetDataSetFieldValue(IsForeignFieldName, False);
  
end;

function TEmployeeSetHolder.GetNameFieldName: String;
begin

  Result := FieldDefs.NameFieldName;
end;

function TEmployeeSetHolder.GetNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(NameFieldName, '');
  
end;

function TEmployeeSetHolder.GetPatronymicFieldName: String;
begin

  Result := FieldDefs.PatronymicFieldName;

end;

function TEmployeeSetHolder.GetPatronymicFieldValue: String;
begin

  Result := GetDataSetFieldValue(PatronymicFieldName, '');
  
end;

function TEmployeeSetHolder.GetPersonnelNumberFieldName: String;
begin

  Result := FieldDefs.PersonnelNumberFieldName;
  
end;

function TEmployeeSetHolder.GetPersonnelNumberFieldValue: String;
begin

  Result := GetDataSetFieldValue(PersonnelNumberFieldName, '');
  
end;

function TEmployeeSetHolder.GetSpecialityFieldName: String;
begin

  Result := FieldDefs.SpecialityFieldName;
  
end;

function TEmployeeSetHolder.GetSpecialityFieldValue: String;
begin

  Result := GetDataSetFieldValue(SpecialityFieldName, '');

end;

function TEmployeeSetHolder.GetSurnameFieldName: String;
begin

  Result := FieldDefs.SurnameFieldName;
  
end;

function TEmployeeSetHolder.GetSurnameFieldValue: String;
begin

  Result := GetDataSetFieldValue(SurnameFieldName, '');

end;

function TEmployeeSetHolder.GetTelephoneNumberFieldName: String;
begin

  Result := FieldDefs.TelephoneNumberFieldName;
  
end;

function TEmployeeSetHolder.GetTelephoneNumberFieldValue: String;
begin

  Result := GetDataSetFieldValue(TelephoneNumberFieldName, '');
  
end;

procedure TEmployeeSetHolder.SetDepartmentCodeFieldName(const Value: String);
begin

  FieldDefs.DepartmentCodeFieldName := Value;
  
end;

procedure TEmployeeSetHolder.SetDepartmentCodeFieldValue(const Value: String);
begin

  SetDataSetFieldValue(DepartmentCodeFieldName, Value);
  
end;

procedure TEmployeeSetHolder.SetDepartmentShortNameFieldName(
  const Value: String);
begin

  FieldDefs.DepartmentShortNameFieldName := Value;
  
end;

procedure TEmployeeSetHolder.SetDepartmentShortNameFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(DepartmentShortNameFieldName, Value);
  
end;

procedure TEmployeeSetHolder.SetEmployeeSetFieldDefs(
  const Value: TEmployeeSetFieldDefs);
begin

  inherited FieldDefs := Value;
  
end;

procedure TEmployeeSetHolder.SetIsForeignFieldName(const Value: String);
begin

  FieldDefs.IsForeignFieldName := Value;
  
end;

procedure TEmployeeSetHolder.SetIsForeignFieldValue(const Value: Boolean);
begin

  SetDataSetFieldValue(IsForeignFieldName, Value);

end;

procedure TEmployeeSetHolder.SetNameFieldName(const Value: String);
begin

  FieldDefs.NameFieldName := Value;
  
end;

procedure TEmployeeSetHolder.SetNameFieldValue(const Value: String);
begin

  SetDataSetFieldValue(NameFieldName, Value);

end;

procedure TEmployeeSetHolder.SetPatronymicFieldName(const Value: String);
begin

  FieldDefs.PatronymicFieldName := Value;

end;

procedure TEmployeeSetHolder.SetPatronymicFieldValue(const Value: String);
begin

  SetDataSetFieldValue(PatronymicFieldName, Value);
  
end;

procedure TEmployeeSetHolder.SetPersonnelNumberFieldName(const Value: String);
begin

  FieldDefs.PersonnelNumberFieldName := Value;
  
end;

procedure TEmployeeSetHolder.SetPersonnelNumberFieldValue(const Value: String);
begin

  SetDataSetFieldValue(PersonnelNumberFieldName, Value);
  
end;

procedure TEmployeeSetHolder.SetSpecialityFieldName(const Value: String);
begin

  FieldDefs.SpecialityFieldName := Value;
  
end;

procedure TEmployeeSetHolder.SetSpecialityFieldValue(const Value: String);
begin

  SetDataSetFieldValue(SpecialityFieldName, Value);

end;

procedure TEmployeeSetHolder.SetSurnameFieldName(const Value: String);
begin

  FieldDefs.SurnameFieldName := Value;
  
end;

procedure TEmployeeSetHolder.SetSurnameFieldValue(const Value: String);
begin

  SetDataSetFieldValue(SurnameFieldName, Value);
  
end;

procedure TEmployeeSetHolder.SetTelephoneNumberFieldName(const Value: String);
begin

  FieldDefs.TelephoneNumberFieldName := Value;
  
end;

procedure TEmployeeSetHolder.SetTelephoneNumberFieldValue(const Value: String);
begin

  SetDataSetFieldValue(TelephoneNumberFieldName, Value);

end;

end.
