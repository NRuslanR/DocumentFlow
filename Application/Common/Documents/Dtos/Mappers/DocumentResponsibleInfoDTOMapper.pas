unit DocumentResponsibleInfoDTOMapper;

interface

uses

  Employee,
  DocumentResponsibleInfoDTO,
  SysUtils;

type

  IDocumentResponsibleInfoDTOMapper = interface

    function MapDocumentResponsibleInfoDTO(
      DocumentResponsibleInfoDTO: TDocumentResponsibleInfoDTO
    ): TEmployee;

  end;

  TDocumentResponsibleInfoDTOMapper =
    class (TInterfacedObject, IDocumentResponsibleInfoDTOMapper)

      public

        function MapDocumentResponsibleInfoDTO(
          DocumentResponsibleInfoDTO: TDocumentResponsibleInfoDTO
        ): TEmployee;

    end;
  
implementation

{ TDocumentResponsibleInfoDTOMapper }

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
