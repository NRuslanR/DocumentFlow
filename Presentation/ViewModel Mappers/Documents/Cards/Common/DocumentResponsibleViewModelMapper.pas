unit DocumentResponsibleViewModelMapper;

interface

uses

  DocumentResponsibleInfoDTO,
  DocumentSignerViewModelUnit,
  DocumentResponsibleViewModelUnit,
  SysUtils,
  Classes;

type

  TDocumentResponsibleViewModelMapper = class

    protected

      function CreateDocumentResponsibleViewModelInstance:
        TDocumentResponsibleViewModel; virtual;
        
    public

      function MapDocumentResponsibleViewModelFrom(
        DocumentResponsibleInfoDTO: TDocumentResponsibleInfoDTO
      ): TDocumentResponsibleViewModel; virtual;

  end;
  
implementation

{ TDocumentResponsibleViewModelMapper }

function TDocumentResponsibleViewModelMapper.CreateDocumentResponsibleViewModelInstance: TDocumentResponsibleViewModel;
begin

  Result := TDocumentResponsibleViewModel.Create;
  
end;

function TDocumentResponsibleViewModelMapper.
  MapDocumentResponsibleViewModelFrom(
    DocumentResponsibleInfoDTO: TDocumentResponsibleInfoDTO
  ): TDocumentResponsibleViewModel;
begin

  Result := CreateDocumentResponsibleViewModelInstance;

  if Assigned(DocumentResponsibleInfoDTO) then begin

    Result.Id := DocumentResponsibleInfoDTO.Id;
    Result.Name := DocumentResponsibleInfoDTO.Name;
    Result.TelephoneNumber := DocumentResponsibleInfoDTO.TelephoneNumber;
    Result.DepartmentCode := DocumentResponsibleInfoDTO.DepartmentInfoDTO.Code;
    Result.DepartmentShortName := DocumentResponsibleInfoDTO.DepartmentInfoDTO.Name;

  end;

end;

end.
