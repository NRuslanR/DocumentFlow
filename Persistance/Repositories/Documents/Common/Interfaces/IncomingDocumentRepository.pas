unit IncomingDocumentRepository;

interface

uses

  IncomingDocument,
  VariantListUnit,
  DocumentRepository;

type

  IIncomingDocumentRepository = interface (IDocumentRepository)
    ['{F7DFB0C8-2E83-43DB-ABB7-00AAC0173F15}']
    
    function LoadAllIncomingDocuments: TIncomingDocuments;
      
    function FindIncomingDocumentById(
      const IncomingDocumentId: Variant
    ): TIncomingDocument;

    function FindIncomingDocumentsByIds(
      const IncomingDocumentIds: TVariantList
    ): TIncomingDocuments;

    function FindIncomingDocumentsByOriginalDocument(
      const OriginalDocumentId: Variant
    ): TIncomingDocuments;

    function FindIncomingDocumentsByOriginalDocuments(
      const OriginalDocumentIds: TVariantList
    ): TIncomingDocuments;

    procedure AddIncomingDocument(IncomingDocument: TIncomingDocument);
    procedure AddIncomingDocuments(IncomingDocuments: TIncomingDocuments);

    procedure UpdateIncomingDocument(IncomingDocument: TIncomingDocument);
    procedure UpdateIncomingDocuments(IncomingDocuments: TIncomingDocuments);

    procedure RemoveIncomingDocument(IncomingDocument: TIncomingDocument);
    procedure RemoveIncomingDocuments(IncomingDocuments: TIncomingDocuments);

  end;

implementation

end.
