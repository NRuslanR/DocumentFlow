unit EmployeeDbSchema;

interface

uses

  SysUtils,
  Classes;

type

  TEmployeeDbSchema = class

    TableName: String;
    
    IdColumnName: String;
    TopLevelEmployeeIdColumnName: String;
    PersonnelNumberColumnName: String;
    NameColumnName: String;
    SurnameColumnName: String;
    PatronymicColumnName: String;
    SpecialityColumnName: String;
    DepartmentIdColumnName: String;
    HeadKindredDepartmentIdColumnName: String;
    TelephoneNumberColumnName: String;
    IsForeignColumnName: String;
    WasDismissedColumnName: String;
    IsSDUserColumnName: String;
    
  end;
  
implementation

end.
