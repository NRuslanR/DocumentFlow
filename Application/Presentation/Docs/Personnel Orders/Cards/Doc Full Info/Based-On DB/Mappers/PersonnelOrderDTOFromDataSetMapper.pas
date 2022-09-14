unit PersonnelOrderDTOFromDataSetMapper;

interface

uses

  DocumentDTOFromDataSetMapper,
  DocumentInfoHolder,
  PersonnelOrderInfoHolder,
  DocumentFullInfoDTO,
  PersonnelOrderFullInfoDTO,
  SysUtils;

type

  TPersonnelOrderDTOFromDataSetMapper = class (TDocumentDTOFromDataSetMapper)

    protected

      function CreateDocumentDTOInstance: TDocumentDTO; override;

    public

      function MapDocumentDTOFrom(DocumentInfoHolder: TDocumentInfoHolder): TDocumentDTO; override;

  end;
  
implementation

uses

  AuxDebugFunctionsUnit;

{ TPersonnelOrderDTOFromDataSetMapper }

function TPersonnelOrderDTOFromDataSetMapper.CreateDocumentDTOInstance: TDocumentDTO;
begin

  Result := TPersonnelOrderDTO.Create;
  
end;

function TPersonnelOrderDTOFromDataSetMapper.MapDocumentDTOFrom(
  DocumentInfoHolder: TDocumentInfoHolder): TDocumentDTO;
begin

  Result := inherited MapDocumentDTOFrom(DocumentInfoHolder);

  try

    with
      TPersonnelOrderDTO(Result),
      TPersonnelOrderInfoHolder(DocumentInfoHolder)
    do begin

      SubKindId := SubKindIdFieldValue;
      SubKindName := SubKindNameFieldValue;
      SeparatorOfNumberParts := ''; { refactor: look base class }
        
    end;
    
  except

    FreeAndNil(Result);

    Raise;

  end;
  
end;

end.
