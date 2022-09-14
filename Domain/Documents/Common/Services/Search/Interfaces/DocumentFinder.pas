unit DocumentFinder;

interface

uses

  DomainException,
  VariantListUnit,
  IDocumentUnit,
  IGetSelfUnit,
  Document,
  SysUtils,
  Classes;

type

  TDocumentFinderException = class (TDomainException)

  end;

  IDocumentFinder = interface (IGetSelf)

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

    function FindDocumentById(const DocumentId: Variant): IDocument;
    function FindDocumentsByIds(const DocumentIds: TVariantList): TDocuments;

  end;

implementation

end.
