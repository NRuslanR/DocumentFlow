unit DepartmentRecordViewModel;

interface

uses

  SysUtils;

type

  TDepartmentRecordViewModel = class

    public

      Id: Variant;
      IsSelected: Boolean;
      Code: String;
      ShortName: String;
      FullName: String;

      constructor Create;

      function ToString: String;
      
  end;

implementation

uses

  Variants;
  
{ TDepartmentRecordViewModel }

constructor TDepartmentRecordViewModel.Create;
begin

  inherited;

  Id := Null;
  
end;

function TDepartmentRecordViewModel.ToString: String;
begin

  Result :=
    '{' + sLineBreak +
    '  "Id": "' + VarToStr(Id) + '",' + sLineBreak +
    '  "IsSelected": "' + BoolToStr(IsSelected, True) + '",' +
    '  "Code": "' + Code + '",' + sLineBreak +
    '  "ShortName": "' + ShortName + '",' + sLineBreak +
    '  "FullName": "' + FullName + '"' + sLineBreak +
    '}';
    
end;

end.
