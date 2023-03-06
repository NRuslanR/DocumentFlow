unit IWorkingEmployeeUnit;

interface

uses

  SysUtils;
  
type

  IWorkingEmployee = interface

    function GetId: Variant;
    function GetLeaderId: Variant;
    function GetName: String;
    function GetSurname: String;
    function GetPatronymic: String;
    function GetPersonnelNumber: String;
    function GetShortName: String;
    function GetFullName: String;
    function GetGlobalUserId: Variant;

    property Id: Variant read GetId;
    property LeaderId: Variant read GetLeaderId;
    property Name: String read GetName;
    property Surname: String read GetSurname;
    property Patronymic: String read GetPatronymic;
    property PersonnelNumber: String read GetPersonnelNumber;
    property ShortName: String read GetShortName;
    property FullName: String read GetFullName;
    property GlobalId: Variant read GetGlobalUserId;

  end;
  
implementation

end.
