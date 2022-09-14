unit SelectionDepartmentSetHolder;

interface

uses

  AbstractDataSetHolder,
  DepartmentSetHolder,
  SysUtils,
  Classes;

type

  TSelectionDepartmentSetFieldDefs = class (TDepartmentSetFieldDefs)

    public

      IsSelectedFieldName: String;

  end;

  TSelectionDepartmentSetHolder = class (TDepartmentSetHolder)

  private

    function GetIsSelectedFieldName: String;
    function GetIsSelectedFieldValue: Variant;
    function GetSelectionDepartmentSetFieldDefs: TSelectionDepartmentSetFieldDefs;
    
    procedure SetIsSelectedFieldName(const Value: String);
    procedure SetIsSelectedFieldValue(const Value: Variant);

    procedure SetSelectionDepartmentSetFieldDefs(
      const Value: TSelectionDepartmentSetFieldDefs
    );

    protected

      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;

    public

      property IsSelectedFieldName: String
      read GetIsSelectedFieldName write SetIsSelectedFieldName;

      property IsSelectedFieldValue: Variant
      read GetIsSelectedFieldValue write SetIsSelectedFieldValue;

    public

      property FieldDefs: TSelectionDepartmentSetFieldDefs
      read GetSelectionDepartmentSetFieldDefs
      write SetSelectionDepartmentSetFieldDefs;
      
  end;

  
implementation

uses

  Variants;

{ TSelectionDepartmentSetHolder }

class function TSelectionDepartmentSetHolder.GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass;
begin

  Result := TSelectionDepartmentSetFieldDefs;
  
end;

function TSelectionDepartmentSetHolder.GetIsSelectedFieldName: String;
begin

  Result := FieldDefs.IsSelectedFieldName;
  
end;

function TSelectionDepartmentSetHolder.GetIsSelectedFieldValue: Variant;
begin

  Result := GetDataSetFieldValue(IsSelectedFieldName, Null);
  
end;

function TSelectionDepartmentSetHolder.
  GetSelectionDepartmentSetFieldDefs: TSelectionDepartmentSetFieldDefs;
begin

  Result := TSelectionDepartmentSetFieldDefs(inherited FieldDefs);
  
end;

procedure TSelectionDepartmentSetHolder.SetIsSelectedFieldName(
  const Value: String);
begin

  FieldDefs.IsSelectedFieldName := Value;
  
end;

procedure TSelectionDepartmentSetHolder.SetIsSelectedFieldValue(
  const Value: Variant);
begin

  SetDataSetFieldValue(IsSelectedFieldName, Value);

end;

procedure TSelectionDepartmentSetHolder.SetSelectionDepartmentSetFieldDefs(
  const Value: TSelectionDepartmentSetFieldDefs);
begin

  inherited FieldDefs := Value;
  
end;

end.
