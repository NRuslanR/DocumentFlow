unit PersonnelOrderCardFormViewModelMapperFactory;

interface

uses

  DocumentCardFormViewModelMapperFactory,
  DocumentCardFormViewModelMapper,
  PersonnelOrderCardFormViewModelMapper,
  SysUtils;

type

  TPersonnelOrderCardFormViewModelMapperFactory =
    class (TDocumentCardFormViewModelMapperFactory)

      public

        function CreateDocumentCardFormViewModelMapper:
          TDocumentCardFormViewModelMapper; override;

    end;
  
implementation

{ TPersonnelOrderCardFormViewModelMapperFactory }

function TPersonnelOrderCardFormViewModelMapperFactory.
  CreateDocumentCardFormViewModelMapper: TDocumentCardFormViewModelMapper;
begin

  Result := TPersonnelOrderCardFormViewModelMapper.Create(FDocumentDataSetHoldersFactory);
  
end;

end.
