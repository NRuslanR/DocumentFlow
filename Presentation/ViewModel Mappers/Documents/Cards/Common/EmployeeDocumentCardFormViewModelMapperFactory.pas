unit EmployeeDocumentCardFormViewModelMapperFactory;

interface

uses

  DocumentCardFormViewModelMapperFactory,
  DocumentCardFormViewModelMapper,
  EmployeeDocumentCardFormViewModelMapper,
  SysUtils;

type

  TEmployeeDocumentCardFormViewModelMapperFactory =
    class (TDocumentCardFormViewModelMapperFactory)

      public

        function CreateDocumentCardFormViewModelMapper:
          TDocumentCardFormViewModelMapper; override;

    end;

implementation

{ TEmployeeDocumentCardFormViewModelMapperFactory }

function TEmployeeDocumentCardFormViewModelMapperFactory.
  CreateDocumentCardFormViewModelMapper: TDocumentCardFormViewModelMapper;
begin

  Result := TEmployeeDocumentCardFormViewModelMapper.Create(FDocumentDataSetHoldersFactory);
  
end;

end.
