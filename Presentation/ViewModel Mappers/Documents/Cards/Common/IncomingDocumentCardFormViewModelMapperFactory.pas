unit IncomingDocumentCardFormViewModelMapperFactory;

interface

uses

  IncomingDocumentCardFormViewModelMapper,
  DocumentCardFormViewModelMapperFactory,
  DocumentCardFormViewModelMapper,
  DocumentDataSetHoldersFactory,
  SysUtils,
  Classes;

type

  { refactor: remove DocumentDataSetHoldersFactory after refactor it }
  
  TIncomingDocumentCardFormViewModelMapperFactory =
    class (TDocumentCardFormViewModelMapperFactory)

      protected

        FOutcomingDocumentCardFormViewModelMapperFactory:
          TDocumentCardFormViewModelMapperFactory;
          
      public

        destructor Destroy; override;
        
        constructor Create(
          DocumentDataSetHoldersFactory: IDocumentDataSetHoldersFactory;  
          OutcomingDocumentCardFormViewModelMapperFactory:
            TDocumentCardFormViewModelMapperFactory
        );

        function CreateDocumentCardFormViewModelMapper:
          TDocumentCardFormViewModelMapper; override;
          
    end;

implementation

{ TIncomingDocumentCardFormViewModelMapperFactory }

constructor TIncomingDocumentCardFormViewModelMapperFactory.Create(
  DocumentDataSetHoldersFactory: IDocumentDataSetHoldersFactory;
  OutcomingDocumentCardFormViewModelMapperFactory: TDocumentCardFormViewModelMapperFactory
);
begin

  inherited Create(DocumentDataSetHoldersFactory);

  DocumentDataSetHoldersFactory := DocumentDataSetHoldersFactory;
  
  FOutcomingDocumentCardFormViewModelMapperFactory :=
    OutcomingDocumentCardFormViewModelMapperFactory;
    
end;

function TIncomingDocumentCardFormViewModelMapperFactory.
  CreateDocumentCardFormViewModelMapper: TDocumentCardFormViewModelMapper;
begin

  Result :=
    TIncomingDocumentCardFormViewModelMapper.Create(
      FDocumentDataSetHoldersFactory,
      FOutcomingDocumentCardFormViewModelMapperFactory.
        CreateDocumentCardFormViewModelMapper
    );
  
end;

destructor TIncomingDocumentCardFormViewModelMapperFactory.Destroy;
begin

  FreeAndNil(FOutcomingDocumentCardFormViewModelMapperFactory);

  inherited;

end;

end.
