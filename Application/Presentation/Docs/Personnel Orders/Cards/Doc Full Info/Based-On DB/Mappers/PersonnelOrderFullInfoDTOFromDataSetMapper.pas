unit PersonnelOrderFullInfoDTOFromDataSetMapper;

interface

uses

  DocumentFullInfoDTOFromDataSetMapper,
  DocumentFullInfoDTO,
  DocumentFullInfoDataSetHolder,
  PersonnelOrderFullInfoDTO,
  SysUtils;

type

  TPersonnelOrderFullInfoDTOFromDataSetMapper =
    class (TDocumentFullInfoDTOFromDataSetMapper)

      protected

        function CreateDocumentFullInfoDTOInstance: TDocumentFullInfoDTO; override;

    end;

implementation

{ TPersonnelOrderFullInfoDTOFromDataSetMapper }

function TPersonnelOrderFullInfoDTOFromDataSetMapper.CreateDocumentFullInfoDTOInstance: TDocumentFullInfoDTO;
begin

  Result := TPersonnelOrderFullInfoDTO.Create;
  
end;

end.
