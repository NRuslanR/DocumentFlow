unit IncomingServiceNoteCardFormViewModelMapperFactory;

interface

uses

  IncomingDocumentCardFormViewModelMapperFactory,
  IncomingServiceNoteCardFormViewModelMapper,
  OutcomingServiceNoteCardFormViewModelMapperFactory,
  OutcomingServiceNoteCardFormViewModelMapper,
  DocumentCardFormViewModelMapper,
  DocumentDataSetHoldersFactory,
  SysUtils,
  Classes;

type

  TIncomingServiceNoteCardFormViewModelMapperFactory =
    class (TIncomingDocumentCardFormViewModelMapperFactory)

      public

        constructor Create(
          DocumentDataSetHoldersFactory: IDocumentDataSetHoldersFactory;
          OutcomingServiceNoteCardFormViewModelMapperFactory:
            TOutcomingServiceNoteCardFormViewModelMapperFactory
        );

        function CreateDocumentCardFormViewModelMapper:
          TDocumentCardFormViewModelMapper; override;
      
    end;


implementation

{ TIncomingServiceNoteCardFormViewModelMapperFactory }

constructor TIncomingServiceNoteCardFormViewModelMapperFactory.Create(
  DocumentDataSetHoldersFactory: IDocumentDataSetHoldersFactory;
  OutcomingServiceNoteCardFormViewModelMapperFactory:
    TOutcomingServiceNoteCardFormViewModelMapperFactory
);
begin

  inherited Create(
    DocumentDataSetHoldersFactory,
    OutcomingServiceNoteCardFormViewModelMapperFactory
  );

end;

function TIncomingServiceNoteCardFormViewModelMapperFactory.
  CreateDocumentCardFormViewModelMapper: TDocumentCardFormViewModelMapper;
begin

  Result :=
    TIncomingServiceNoteCardFormViewModelMapper.Create(
      FDocumentDataSetHoldersFactory,
      FOutcomingDocumentCardFormViewModelMapperFactory.
        CreateDocumentCardFormViewModelMapper as
        TOutcomingServiceNoteCardFormViewModelMapper
    );
    
end;

end.
