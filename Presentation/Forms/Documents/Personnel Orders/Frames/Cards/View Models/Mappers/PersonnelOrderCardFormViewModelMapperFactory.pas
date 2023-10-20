unit PersonnelOrderCardFormViewModelMapperFactory;

interface

uses

  DocumentCardFormViewModelMapperFactory,
  DocumentCardFormViewModelMapper,
  PersonnelOrderCardFormViewModelMapper,
  PersonnelOrderMainInformationFormViewModelMapper,
  DocumentMainInformationFormViewModelMapper,
  SysUtils;

type

  TPersonnelOrderCardFormViewModelMapperFactory =
    class (TDocumentCardFormViewModelMapperFactory)

      protected

        function CreateDocumentCardFormViewModelMapperInstance: TDocumentCardFormViewModelMapper; override;

      public

        function CreateDocumentMainInformationFormViewModelMapper: TDocumentMainInformationFormViewModelMapper; override;

    end;
  
implementation

{ TPersonnelOrderCardFormViewModelMapperFactory }

function TPersonnelOrderCardFormViewModelMapperFactory
  .CreateDocumentCardFormViewModelMapperInstance: TDocumentCardFormViewModelMapper;
begin

  Result := TPersonnelOrderCardFormViewModelMapper.Create;

end;

function TPersonnelOrderCardFormViewModelMapperFactory
  .CreateDocumentMainInformationFormViewModelMapper: TDocumentMainInformationFormViewModelMapper;
begin

  Result := TPersonnelOrderMainInformationFormViewModelMapper.Create;
  
end;

end.
