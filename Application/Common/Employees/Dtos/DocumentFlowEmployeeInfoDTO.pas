unit DocumentFlowEmployeeInfoDTO;

interface

uses

  EmployeeInfoDTO;

type

  TDocumentFlowEmployeeInfoDTO = class (TEmployeeInfoDTO)

    public

      RoleId: Variant;
      IsForeign: Boolean;

      constructor Create;

  end;

implementation

uses

  Variants;
  
{ TDocumentFlowEmployeeInfoDTO }

constructor TDocumentFlowEmployeeInfoDTO.Create;
begin

  inherited;

  IsForeign := False;
  RoleId := Null;
  
end;

end.
