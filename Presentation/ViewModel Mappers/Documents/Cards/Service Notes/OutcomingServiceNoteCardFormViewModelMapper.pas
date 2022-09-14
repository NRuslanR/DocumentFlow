unit OutcomingServiceNoteCardFormViewModelMapper;

interface

uses

  EmployeeDocumentCardFormViewModelMapper,
  DocumentMainInformationFormViewModelMapper,
  OutcomingServiceNoteMainInformationFormViewModelMapper,
  SysUtils,
  Classes;

type

  TOutcomingServiceNoteCardFormViewModelMapper =
    class (TEmployeeDocumentCardFormViewModelMapper)

      protected

        function CreateMainInformationFormViewModelMapper:
          TDocumentMainInformationFormViewModelMapper; override;

    end;
  
implementation

{ TOutcomingServiceNoteCardFormViewModelMapper }

function TOutcomingServiceNoteCardFormViewModelMapper.
  CreateMainInformationFormViewModelMapper:
    TDocumentMainInformationFormViewModelMapper;
begin

  Result :=
    TOutcomingServiceNoteMainInformationFormViewModelMapper.Create;

end;

end.
