unit DocumentResponsibleInfoDTO;

interface

uses

  DepartmentInfoDTO,
  SysUtils,
  Classes;
  
type

  TDocumentResponsibleInfoDTO = class

    public

      Id: Variant;
      Name: String;
      TelephoneNumber: String;

      DepartmentInfoDTO: TDepartmentInfoDTO;

      constructor Create;
      destructor Destroy; override;

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

destructor TDocumentResponsibleInfoDTO.Destroy;
begin

  FreeAndNil(DepartmentInfoDTO);

  inherited;

end;

end.
