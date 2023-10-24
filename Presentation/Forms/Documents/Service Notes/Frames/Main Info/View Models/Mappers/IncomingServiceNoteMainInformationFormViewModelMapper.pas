unit IncomingServiceNoteMainInformationFormViewModelMapper;

interface

uses

  DocumentMainInformationFormViewModelMapper,
  DocumentMainInformationFormViewModelUnit,
  IncomingDocumentMainInformationFormViewModelMapper,
  SysUtils,
  Classes;

type

  TIncomingServiceNoteMainInformationFormViewModelMapper =
    class (TIncomingDocumentMainInformationFormViewModelMapper)

      public

        function CreateEmptyDocumentMainInformationFormViewModel:
          TDocumentMainInformationFormViewModel; override;
      
    end;

implementation

{ TIncomingServiceNoteMainInformationFormViewModelMapper }

function TIncomingServiceNoteMainInformationFormViewModelMapper.
  CreateEmptyDocumentMainInformationFormViewModel:
    TDocumentMainInformationFormViewModel;
begin

  Result :=
    inherited CreateEmptyDocumentMainInformationFormViewModel;

  Result.Kind := '¬ход€ща€ с/з';
  
end;

end.
