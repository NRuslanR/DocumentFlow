unit PersonnelOrderFullInfoDTO;

interface

uses

  DocumentFullInfoDTO,
  SysUtils;

type

  TPersonnelOrderDTO = class (TDocumentDTO)

    public

      SubKindId: Variant;
      SubKindName: String;

    public

      constructor Create; override;
      
  end;
  
  TPersonnelOrderFullInfoDTO = class (TDocumentFullInfoDTO)

    private

      function GetDocumentDTO: TPersonnelOrderDTO;
      procedure SetDocumentDTO(const Value: TPersonnelOrderDTO);
      
    public

      property DocumentDTO: TPersonnelOrderDTO
      read GetDocumentDTO write SetDocumentDTO;
    
  end;
    
implementation

uses

  Variants;

{ TPersonnelOrderFullInfoDTO }

function TPersonnelOrderFullInfoDTO.GetDocumentDTO: TPersonnelOrderDTO;
begin

  Result := TPersonnelOrderDTO(DocumentDTO);
  
end;

procedure TPersonnelOrderFullInfoDTO.SetDocumentDTO(
  const Value: TPersonnelOrderDTO);
begin

  DocumentDTO := Value;
  
end;

{ TPersonnelOrderDTO }

constructor TPersonnelOrderDTO.Create;
begin

  inherited;

  SubKindId := Null;

end;

end.
