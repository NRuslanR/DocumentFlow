unit OutcomingServiceNoteCardFormViewModelMapperFactory;

interface

uses

  EmployeeDocumentCardFormViewModelMapperFactory,
  DocumentCardFormViewModelMapper,
  OutcomingServiceNoteCardFormViewModelMapper,
  SysUtils,
  Classes;

type

  TOutcomingServiceNoteCardFormViewModelMapperFactory =
    class (TEmployeeDocumentCardFormViewModelMapperFactory)

      public

        function CreateDocumentCardFormViewModelMapper:
          TDocumentCardFormViewModelMapper; override;
      
    end;
    
implementation

{ TOutcomingServiceNoteCardFormViewModelMapperFactory }

function TOutcomingServiceNoteCardFormViewModelMapperFactory.
  CreateDocumentCardFormViewModelMapper: TDocumentCardFormViewModelMapper;
begin

  Result :=
    TOutcomingServiceNoteCardFormViewModelMapper.Create(FDocumentDataSetHoldersFactory);
    
end;

end.
