unit DocumentCardFormViewModelMapperFactory;

interface

uses

  DocumentDataSetHoldersFactory,
  DocumentCardFormViewModelMapper,
  SysUtils,
  Classes;
  
type

  { refactor: remove DocumentDataSetHoldersFactory after refactor it }
  
  TDocumentCardFormViewModelMapperFactory = class

    protected

      FDocumentDataSetHoldersFactory: IDocumentDataSetHoldersFactory;
      
    public

      constructor Create(
        DocumentDataSetHoldersFactory: IDocumentDataSetHoldersFactory
      );

      function CreateDocumentCardFormViewModelMapper:
        TDocumentCardFormViewModelMapper; virtual;
      
  end;

implementation

{ TDocumentCardFormViewModelMapperFactory }

constructor TDocumentCardFormViewModelMapperFactory.Create(
  DocumentDataSetHoldersFactory: IDocumentDataSetHoldersFactory
);
begin

  inherited Create;

  FDocumentDataSetHoldersFactory := DocumentDataSetHoldersFactory;

end;

function TDocumentCardFormViewModelMapperFactory.CreateDocumentCardFormViewModelMapper: TDocumentCardFormViewModelMapper;
begin

  Result := TDocumentCardFormViewModelMapper.Create(FDocumentDataSetHoldersFactory);
  
end;

end.
