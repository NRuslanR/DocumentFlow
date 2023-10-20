unit IncomingDocumentCardFormViewModelMapperFactory;

interface

uses

  IncomingDocumentCardFormViewModelMapper,
  DocumentCardFormViewModelMapperFactory,
  DocumentCardFormViewModelMapper,
  DocumentMainInformationFormViewModelMapper,
  DocumentDataSetHoldersFactory,
  IncomingDocumentMainInformationFormViewModelMapper,
  SysUtils,
  Classes;

type

  TIncomingDocumentCardFormViewModelMapperFactory =
    class (TDocumentCardFormViewModelMapperFactory)

      protected

        FOutcomingDocumentCardFormViewModelMapperFactory: TDocumentCardFormViewModelMapperFactory;
        
        function CreateDocumentCardFormViewModelMapperInstance: TDocumentCardFormViewModelMapper; virtual;

      public
      
        function CreateDocumentMainInformationFormViewModelMapper: TDocumentMainInformationFormViewModelMapper; virtual;

      public

        constructor Create(
          OutcomingDocumentCardFormViewModelMapperFactory: TDocumentCardFormViewModelMapperFactory;
          DocumentDataSetHoldersFactory: IDocumentDataSetHoldersFactory
        );

    end;

implementation

{ TIncomingDocumentCardFormViewModelMapperFactory }

constructor TIncomingDocumentCardFormViewModelMapperFactory.Create(
  OutcomingDocumentCardFormViewModelMapperFactory: TDocumentCardFormViewModelMapperFactory;
  DocumentDataSetHoldersFactory: IDocumentDataSetHoldersFactory
);
begin

  inherited Create(DocumentDataSetHoldersFactory);

  FOutcomingDocumentCardFormViewModelMapperFactory :=
    OutcomingDocumentCardFormViewModelMapperFactory;
    
end;

function TIncomingDocumentCardFormViewModelMapperFactory
  .CreateDocumentCardFormViewModelMapperInstance: TDocumentCardFormViewModelMapper;
begin

  Result := TIncomingDocumentCardFormViewModelMapper.Create;
  
end;

function TIncomingDocumentCardFormViewModelMapperFactory
  .CreateDocumentMainInformationFormViewModelMapper: TDocumentMainInformationFormViewModelMapper;
begin

  Result :=
    TIncomingDocumentMainInformationFormViewModelMapper.Create(
      FOutcomingDocumentCardFormViewModelMapperFactory
        .CreateDocumentMainInformationFormViewModelMapper
    );

end;

end.
