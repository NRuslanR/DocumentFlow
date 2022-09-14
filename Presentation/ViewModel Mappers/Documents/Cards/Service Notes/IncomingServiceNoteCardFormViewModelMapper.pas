unit IncomingServiceNoteCardFormViewModelMapper;

interface

uses

  IncomingDocumentCardFormViewModelMapper,
  DocumentMainInformationFormViewModelMapper,
  IncomingServiceNoteMainInformationFormViewModelMapper,
  SysUtils,
  Classes;

type

  TIncomingServiceNoteCardFormViewModelMapper =
    class (TIncomingDocumentCardFormViewModelMapper)

      protected

        function CreateMainInformationFormViewModelMapper:
          TDocumentMainInformationFormViewModelMapper; override;
          
    end;

implementation

{ TIncomingServiceNoteCardFormViewModelMapper }

function TIncomingServiceNoteCardFormViewModelMapper.
  CreateMainInformationFormViewModelMapper:
    TDocumentMainInformationFormViewModelMapper;
begin

  Result :=
    TIncomingServiceNoteMainInformationFormViewModelMapper.Create(
      FDocumentCardFormViewModelMapper.MainInformationFormViewModelMapper
    );

end;

end.
