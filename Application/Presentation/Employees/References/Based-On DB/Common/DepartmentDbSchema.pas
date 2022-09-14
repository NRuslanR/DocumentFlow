unit DepartmentDbSchema;

interface

uses

  SysUtils,
  Classes;

type

  TDepartmentDbSchema = class

    TableName: String;
    
    IdColumnName: String;
    CodeColumnName: String;
    ShortNameColumnName: String;
    FullNameColumnName: String;
    InActiveStatusColumnName: String;
    
  end;

implementation

end.
