unit OutcomingServiceNoteMainInformationFormViewModelMapper;

interface

uses

  DocumentMainInformationFormViewModelMapper,
  DocumentMainInformationFormViewModelUnit,
  SysUtils,
  Classes;

type

  TOutcomingServiceNoteMainInformationFormViewModelMapper =
    class (TDocumentMainInformationFormViewModelMapper)

      public

        function CreateEmptyDocumentMainInformationFormViewModel:
          TDocumentMainInformationFormViewModel; override;
    end;

implementation

{ TOutcomingServiceNoteMainInformationFormViewModelMapper }

function TOutcomingServiceNoteMainInformationFormViewModelMapper.
  CreateEmptyDocumentMainInformationFormViewModel:
    TDocumentMainInformationFormViewModel;
begin

  Result :=
    inherited CreateEmptyDocumentMainInformationFormViewModel;

  Result.Kind := '��������� �/�';
  Result.CreationDate := Now;
  
end;

end.
