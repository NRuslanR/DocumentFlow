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

      protected

        function CreateDocumentCardFormViewModelMapperInstance: TDocumentCardFormViewModelMapper; override;

    end;

implementation

{ TEmployeeDocumentCardFormViewModelMapperFactory }

function TEmployeeDocumentCardFormViewModelMapperFactory
  .CreateDocumentCardFormViewModelMapperInstance: TDocumentCardFormViewModelMapper;
begin

  Result := TEmployeeDocumentCardFormViewModelMapper.Create;
  
end;

end.
