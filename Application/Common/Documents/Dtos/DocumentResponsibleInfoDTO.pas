unit DocumentResponsibleInfoDTO;

interface

uses

  DepartmentInfoDTO,
  IGetSelfUnit,
  SysUtils,
  Classes;
  
type

  TDocumentResponsibleInfoDTO = class (TInterfacedObject, IGetSelf)

    private

      FDepartmentInfoDTO: TDepartmentInfoDTO;
      FFreeDepartmentInfoDTO: IGetSelf;
      
      procedure SetDepartmentInfoDTO(const Value: TDepartmentInfoDTO);
      
    public

      Id: Variant;
      Name: String;
      TelephoneNumber: String;

      constructor Create;

      function GetSelf: TObject;

      property DepartmentInfoDTO: TDepartmentInfoDTO
      read FDepartmentInfoDTO write SetDepartmentInfoDTO;

  end;
  
implementation

uses

  Variants;
  
{ TDocumentResponsibleInfoDTO }

constructor TDocumentResponsibleInfoDTO.Create;
begin

  inherited;

  Id := Null;
  
end;

function TDocumentResponsibleInfoDTO.GetSelf: TObject;
begin

  Result := Self;
  
end;

procedure TDocumentResponsibleInfoDTO.SetDepartmentInfoDTO(
  const Value: TDepartmentInfoDTO);
begin

  FDepartmentInfoDTO := Value;
  FFreeDepartmentInfoDTO := Value;
  
end;

end.

