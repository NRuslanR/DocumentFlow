unit DocumentApprovingCycleDTO;

interface

type

  TDocumentApprovingCycleDTO = class

    public

      Id: Variant;
      Number: Integer;
      BeginDate: Variant;

      constructor Create;
      
  end;
  
implementation

uses

  Variants;
  
{ TDocumentApprovingCycleDTO }

constructor TDocumentApprovingCycleDTO.Create;
begin

  inherited;

  Id := Null;

end;

end.
