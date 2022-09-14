unit PersonnelOrderCardFormViewModelMapper;

interface

uses

  DocumentCardFormViewModelMapper,
  DocumentMainInformationFormViewModelMapper,
  PersonnelOrderMainInformationFormViewModelMapper,
  SysUtils;

type

  TPersonnelOrderCardFormViewModelMapper = class (TDocumentCardFormViewModelMapper)

    protected

      function CreateMainInformationFormViewModelMapper:
        TDocumentMainInformationFormViewModelMapper; override;
        
  end;
  
implementation

{ TPersonnelOrderCardFormViewModelMapper }

function TPersonnelOrderCardFormViewModelMapper.
  CreateMainInformationFormViewModelMapper: TDocumentMainInformationFormViewModelMapper;
begin

  Result := TPersonnelOrderMainInformationFormViewModelMapper.Create;
  
end;

end.
