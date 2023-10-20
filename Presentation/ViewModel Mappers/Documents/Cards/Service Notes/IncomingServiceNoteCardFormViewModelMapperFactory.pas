unit IncomingServiceNoteCardFormViewModelMapperFactory;

interface

uses

  IncomingDocumentCardFormViewModelMapperFactory,
  IncomingServiceNoteCardFormViewModelMapper,
  DocumentMainInformationFormViewModelMapper,
  IncomingServiceNoteMainInformationFormViewModelMapper,
  OutcomingServiceNoteCardFormViewModelMapperFactory,
  OutcomingServiceNoteCardFormViewModelMapper,
  DocumentCardFormViewModelMapper,
  DocumentDataSetHoldersFactory,
  SysUtils,
  Classes;

type

  TIncomingServiceNoteCardFormViewModelMapperFactory =
    class (TIncomingDocumentCardFormViewModelMapperFactory)

      protected

        function CreateDocumentCardFormViewModelMapperInstance: TDocumentCardFormViewModelMapper; override;

      public

        constructor Create(
          OutcomingDocumentCardFormViewModelMapperFactory: TOutcomingServiceNoteCardFormViewModelMapperFactory;
          DocumentDataSetHoldersFactory: IDocumentDataSetHoldersFactory
        );

        function CreateDocumentMainInformationFormViewModelMapper: TDocumentMainInformationFormViewModelMapper; override;

    end;


implementation

{ TIncomingServiceNoteCardFormViewModelMapperFactory }

constructor TIncomingServiceNoteCardFormViewModelMapperFactory.Create(
  OutcomingDocumentCardFormViewModelMapperFactory: TOutcomingServiceNoteCardFormViewModelMapperFactory;
  DocumentDataSetHoldersFactory: IDocumentDataSetHoldersFactory);
begin

  inherited Create(
    OutcomingDocumentCardFormViewModelMapperFactory,
    DocumentDataSetHoldersFactory
  );
                                
end;

function TIncomingServiceNoteCardFormViewModelMapperFactory
  .CreateDocumentCardFormViewModelMapperInstance: TDocumentCardFormViewModelMapper;
begin

  Result := TIncomingServiceNoteCardFormViewModelMapper.Create;

end;

function TIncomingServiceNoteCardFormViewModelMapperFactory
  .CreateDocumentMainInformationFormViewModelMapper: TDocumentMainInformationFormViewModelMapper;
begin

  Result :=
    TIncomingServiceNoteMainInformationFormViewModelMapper.Create(
      FOutcomingDocumentCardFormViewModelMapperFactory
        .CreateDocumentMainInformationFormViewModelMapper
    );
    
end;

end.
