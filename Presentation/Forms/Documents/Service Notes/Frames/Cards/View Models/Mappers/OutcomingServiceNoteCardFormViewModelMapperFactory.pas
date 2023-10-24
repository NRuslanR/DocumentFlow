unit OutcomingServiceNoteCardFormViewModelMapperFactory;

interface

uses

  EmployeeDocumentCardFormViewModelMapperFactory,
  DocumentCardFormViewModelMapper,
  OutcomingServiceNoteCardFormViewModelMapper,
  DocumentMainInformationFormViewModelMapper,
  OutcomingServiceNoteMainInformationFormViewModelMapper,
  SysUtils,
  Classes;

type

  TOutcomingServiceNoteCardFormViewModelMapperFactory =
    class (TEmployeeDocumentCardFormViewModelMapperFactory)

      protected

        function CreateDocumentCardFormViewModelMapperInstance: TDocumentCardFormViewModelMapper; override;

      public
      
        function CreateDocumentMainInformationFormViewModelMapper: TDocumentMainInformationFormViewModelMapper; override;

    end;
    
implementation

{ TOutcomingServiceNoteCardFormViewModelMapperFactory }

function TOutcomingServiceNoteCardFormViewModelMapperFactory
  .CreateDocumentCardFormViewModelMapperInstance: TDocumentCardFormViewModelMapper;
begin

  Result := TOutcomingServiceNoteCardFormViewModelMapper.Create;

end;

function TOutcomingServiceNoteCardFormViewModelMapperFactory
  .CreateDocumentMainInformationFormViewModelMapper: TDocumentMainInformationFormViewModelMapper;
begin

  Result := TOutcomingServiceNoteMainInformationFormViewModelMapper.Create;
  
end;

end.
