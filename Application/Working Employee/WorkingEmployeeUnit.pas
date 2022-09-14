unit WorkingEmployeeUnit;

interface

uses

  IWorkingEmployeeUnit,
  SysUtils,
  Classes;

type

  TWorkingEmployee = class abstract (TInterfacedObject, IWorkingEmployee)

    protected

      FId: Variant;
      FName: String;
      FSurname: String;
      FPatronymic: String;
      FPersonnelNumber: String;
      FShortName: String;
      FLeaderId: Variant;

      function GetId: Variant;
      function GetName: String;
      function GetSurname: String;
      function GetPatronymic: String;
      function GetPersonnelNumber: String;
      function GetLeaderId: Variant;
      function GetShortName: String;
      function GetFullName: String;
      
      class var FInstance: IWorkingEmployee;

      class function GetInstance: IWorkingEmployee; static;
      class procedure SetInstance(WorkingEmployee: IWorkingEmployee); static;

      constructor Create; overload;

    public

      class property Current: IWorkingEmployee
      read GetInstance write SetInstance;

  end;

implementation

uses

  StrUtils;

{ TWorkingEmployee }

constructor TWorkingEmployee.Create;
begin

  inherited;
  
end;

function TWorkingEmployee.GetFullName: String;
begin

  Result :=
    FSurname + ' ' + FName + ' ' + FPatronymic;
  
end;

function TWorkingEmployee.GetId: Variant;
begin

  Result := FId;

end;

class function TWorkingEmployee.GetInstance: IWorkingEmployee;
begin

  Result := FInstance;
  
end;

function TWorkingEmployee.GetLeaderId: Variant;
begin

  Result := FLeaderId;
  
end;

function TWorkingEmployee.GetName: String;
begin

  Result := FName;

end;

function TWorkingEmployee.GetPatronymic: String;
begin

  Result := FPatronymic;
  
end;

function TWorkingEmployee.GetPersonnelNumber: String;
begin

  Result := FPersonnelNumber;

end;

function TWorkingEmployee.GetShortName: String;
var FamilyFirstLetter, FamilyRestLetters: String;
begin

  FamilyFirstLetter := AnsiUpperCase(PChar(String(FSurname[1])));
  FamilyRestLetters := Copy(FSurname, 2, Length(FSurname) - 1);

  Result :=
    FamilyFirstLetter + FamilyRestLetters + ' ' +
    UpperCase(String(FName[1])) + '.' +
    UpperCase(String(FPatronymic[1])) + '.';

end;

function TWorkingEmployee.GetSurname: String;
begin

  Result := FSurname;

end;

class procedure TWorkingEmployee.SetInstance(WorkingEmployee: IWorkingEmployee);
begin

  FInstance := WorkingEmployee;
  
end;

end.
