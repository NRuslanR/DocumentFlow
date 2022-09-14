unit DocumentRepository;

interface

uses

  Document,
  VariantListUnit,
  IGetSelfUnit,
  SysUtils,
  Classes;

type

  IDocumentRepository = interface (IGetSelf)
    ['{9EF68206-CA0C-44B5-9C16-C7756E9FAF10}']
    
    function LoadAllDocuments: TDocuments;

    function FindDocumentsByNumber(const Number: String): TDocuments;
    function FindDocumentsByNumbers(const Numbers: TStrings): TDocuments;

    function FindDocumentsByNumberAndCreationYear(
      const Number: String;
      const CreationYear: Integer
    ): TDocuments;

    function FindDocumentsByNumbersAndCreationYear(
      const Numbers: TStrings;
      const CreationYear: Integer
    ): TDocuments;

    function FindDocumentById(const DocumentId: Variant): TDocument;
    function FindDocumentsByIds(const DocumentIds: TVariantList): TDocuments;
    
    procedure AddDocument(Document: TDocument);
    procedure AddDocuments(Documents: TDocuments);

    procedure UpdateDocument(Document: TDocument);
    procedure UpdateDocuments(Documents: TDocuments);
      
    procedure RemoveDocument(Document: TDocument);
    procedure RemoveDocuments(Documents: TDocuments);
      
  end;

implementation

end.
