unit EmployeeInfoDTO;

interface

uses

  DepartmentInfoDTO,
  SysUtils,
  Classes;

type

  TEmployeeInfoDTO = class

    Id: Variant;
    LeaderId: Variant;
    Name: String;
    Surname: String;
    Patronymic: String;
    FullName: String;
    Speciality: String;

    DepartmentInfoDTO: TDepartmentInfoDTO;

    constructor Create;
    destructor Destroy; override;
    
  end;

implementation

uses

  Variants;
  
{ TEmployeeInfoDTO }

constructor TEmployeeInfoDTO.Create;
begin

  inherited;

  Id := Null;
  LeaderId := Null;
  
end;

destructor TEmployeeInfoDTO.Destroy;
begin

  FreeAndNil(DepartmentInfoDTO);
  inherited;

end;

end.
