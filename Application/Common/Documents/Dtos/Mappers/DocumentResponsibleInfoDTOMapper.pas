unit DocumentResponsibleInfoDTOMapper;

interface

uses

  Employee,
  DocumentResponsibleInfoDTO,
  SysUtils;

type

  TDocumentResponsibleInfoDTOMapper = class;

  IDocumentResponsibleInfoDTOMapper = interface

    function AsSelf: TDocumentResponsibleInfoDTOMapper;

    function MapDocumentResponsibleInfoDTO(
      DocumentResponsibleInfoDTO: TDocumentResponsibleInfoDTO
    ): TEmployee;

  end;

  TDocumentResponsibleInfoDTOMapper =
    class (TInterfacedObject, IDocumentResponsibleInfoDTOMapper)

      public

        function AsSelf: TDocumentResponsibleInfoDTOMapper;
        
        function MapDocumentResponsibleInfoDTO(
          DocumentResponsibleInfoDTO: TDocumentResponsibleInfoDTO
        ): TEmployee;

    end;
  
implementation

{ TDocumentResponsibleInfoDTOMapper }

function TDocumentResponsibleInfoDTOMapper.AsSelf: TDocumentResponsibleInfoDTOMapper;
begin

  Result := Self;
  
end;

function TDocumentResponsibleInfoDTOMapper.MapDocumentResponsibleInfoDTO(
  DocumentResponsibleInfoDTO: TDocumentResponsibleInfoDTO
): TEmployee;
begin

  Result := TEmployee.Create;

  try

    Result.Identity := DocumentResponsibleInfoDTO.Id;
    Result.Name := DocumentResponsibleInfoDTO.Name;
    Result.TelephoneNumber := DocumentResponsibleInfoDTO.TelephoneNumber;
    Result.DepartmentIdentity := DocumentResponsibleInfoDTO.DepartmentInfoDTO.Id;

  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;

end;

end.
