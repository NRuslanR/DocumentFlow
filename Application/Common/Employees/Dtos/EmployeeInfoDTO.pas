unit EmployeeInfoDTO;

interface

uses

  DepartmentInfoDTO,
  IGetSelfUnit,
  SysUtils,
  Classes;

type

  TEmployeeInfoDTO = class (TInterfacedObject, IGetSelf)

    private

      FDepartmentInfoDTO: TDepartmentInfoDTO;
      FFreeDepartmentInfoDTO: IGetSelf;
      
      procedure SetDepartmentInfoDTO(const Value: TDepartmentInfoDTO);
      
    public

      Id: Variant;
      LeaderId: Variant;
      PersonnelNumber: String;
      Name: String;
      Surname: String;
      Patronymic: String;
      FullName: String;
      Speciality: String;

      constructor Create;

      function GetSelf: TObject;

      property DepartmentInfoDTO: TDepartmentInfoDTO
      read FDepartmentInfoDTO write SetDepartmentInfoDTO;
    
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

function TEmployeeInfoDTO.GetSelf: TObject;
begin

  Result := Self;
  
end;

procedure TEmployeeInfoDTO.SetDepartmentInfoDTO(
  const Value: TDepartmentInfoDTO);
begin

  FDepartmentInfoDTO := Value;
  FFreeDepartmentInfoDTO := Value;

end;

end.

