unit ChangedPersonnelOrderDto;

interface

uses

  ChangedDocumentInfoDTO;

type

  TChangedPersonnelOrderDto = class (TChangedDocumentDTO)

    public

      SubKindId: Variant;

      constructor Create; override;
      
  end;
  
implementation

uses

  Variants;

{ TChangedPersonnelOrderDto }

constructor TChangedPersonnelOrderDto.Create;
begin

  inherited;

  SubKindId := Null;
  
end;

end.
