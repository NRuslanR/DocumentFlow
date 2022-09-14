unit PersonnelOrderSubKindEmployeeListTableDef;

interface

uses

  PersonnelOrderEmployeeListTableDef,
  SysUtils;

type

  TPersonnelOrderSubKindEmployeeListTableDef = class (TPersonnelOrderEmployeeListTableDef)

    protected

      function GetPersonnelOrderSubKindIdColumnName: String;
      procedure SetPersonnelOrderSubKindIdColumnName(const Value: String);

    public

      property PersonnelOrderSubKindIdColumnName: String
      read GetPersonnelOrderSubKindIdColumnName write SetPersonnelOrderSubKindIdColumnName;
    
  end;

implementation

uses

  TableDef;

{ TPersonnelOrderSubKindEmployeeListTableDef }

function TPersonnelOrderSubKindEmployeeListTableDef.GetPersonnelOrderSubKindIdColumnName: String;
begin

  Result := IdColumnName;
  
end;

procedure TPersonnelOrderSubKindEmployeeListTableDef.SetPersonnelOrderSubKindIdColumnName(
  const Value: String);
begin

  IdColumnName := Value;
  
end;

end.
