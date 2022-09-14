unit PersonnelOrderSignerListTableDef;

interface

uses

  PersonnelOrderEmployeeListTableDef,
  SysUtils;

type

  TPersonnelOrderSignerListTableDef = class (TPersonnelOrderEmployeeListTableDef)

    public

      IsDefaultColumnName: String;
      
  end;
  
implementation

end.
