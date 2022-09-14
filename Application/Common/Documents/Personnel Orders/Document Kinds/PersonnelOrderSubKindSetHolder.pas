unit PersonnelOrderSubKindSetHolder;

interface

uses

  AbstractDataSetHolder,
  SysUtils;

type

  TPersonnelOrderSubKindSetFieldDefs = class (TAbstractDataSetFieldDefs)

    private
    
      function GetIdFieldName: String;
      procedure SetIdFieldName(const Value: String);

    public

      property IdFieldName: String read GetIdFieldName write SetIdFieldName;

    public

      NameFieldName: String;
      
  end;

  TPersonnelOrderSubKindSetHolder = class (TAbstractDataSetHolder)

    private

      function GetIdFieldName: String;
      function GetIdFieldValue: Variant;
      function GetNameFieldName: String;
      function GetNameFieldValue: String;
      function GetPersonnelOrderSubKindSetFieldDefs: TPersonnelOrderSubKindSetFieldDefs;

      procedure SetIdFieldName(const Value: String);
      procedure SetIdFieldValue(const Value: Variant);
      procedure SetNameFieldName(const Value: String);
      procedure SetNameFieldValue(const Value: String);

      procedure SetPersonnelOrderSubKindSetFieldDefs(
        const Value: TPersonnelOrderSubKindSetFieldDefs
      );

    protected

      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;
      
    public

      property IdFieldName: String read GetIdFieldName write SetIdFieldName;
      property NameFieldName: String read GetNameFieldName write SetNameFieldName;

    public

      property IdFieldValue: Variant read GetIdFieldValue write SetIdFieldValue;
      property NameFieldValue: String read GetNameFieldValue write SetNameFieldValue;

    public

      property FieldDefs: TPersonnelOrderSubKindSetFieldDefs
      read GetPersonnelOrderSubKindSetFieldDefs
      write SetPersonnelOrderSubKindSetFieldDefs;
      
  end;
  
implementation

{ TPersonnelOrderSubKindSetFieldDefs }

function TPersonnelOrderSubKindSetFieldDefs.GetIdFieldName: String;
begin

  Result := RecordIdFieldName;

end;

procedure TPersonnelOrderSubKindSetFieldDefs.SetIdFieldName(
  const Value: String);
begin

  RecordIdFieldName := Value;
  
end;

{ TPersonnelOrderSubKindSetHolder }

class function TPersonnelOrderSubKindSetHolder.GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass;
begin

  Result := TPersonnelOrderSubKindSetFieldDefs;
  
end;

function TPersonnelOrderSubKindSetHolder.GetIdFieldName: String;
begin

  Result := FieldDefs.IdFieldName;

end;

function TPersonnelOrderSubKindSetHolder.GetIdFieldValue: Variant;
begin

  Result := RecordIdFieldValue;
  
end;

function TPersonnelOrderSubKindSetHolder.GetNameFieldName: String;
begin

  Result := FieldDefs.NameFieldName;
  
end;

function TPersonnelOrderSubKindSetHolder.GetNameFieldValue: String;
begin

  Result := GetDataSetFieldValue(NameFieldName, '');

end;

function TPersonnelOrderSubKindSetHolder.GetPersonnelOrderSubKindSetFieldDefs: TPersonnelOrderSubKindSetFieldDefs;
begin

  Result := TPersonnelOrderSubKindSetFieldDefs(inherited FieldDefs);
  
end;

procedure TPersonnelOrderSubKindSetHolder.SetIdFieldName(const Value: String);
begin

  FieldDefs.IdFieldName := Value;
  
end;

procedure TPersonnelOrderSubKindSetHolder.SetIdFieldValue(const Value: Variant);
begin

  RecordIdFieldValue := Value;

end;

procedure TPersonnelOrderSubKindSetHolder.SetNameFieldName(const Value: String);
begin

  FieldDefs.NameFieldName := Value;

end;

procedure TPersonnelOrderSubKindSetHolder.SetNameFieldValue(
  const Value: String);
begin

  SetDataSetFieldValue(NameFieldName, Value);
  
end;

procedure TPersonnelOrderSubKindSetHolder.SetPersonnelOrderSubKindSetFieldDefs(
  const Value: TPersonnelOrderSubKindSetFieldDefs);
begin

  inherited FieldDefs := Value;
  
end;

end.
