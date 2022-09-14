unit BasedOnRepositoryDocumentFinder;

interface

uses

  AbstractDocumentFinder,
  Document,
  DocumentRepository,
  VariantListUnit,
  IDocumentUnit,
  SysUtils,
  Classes;

type

  TBasedOnRepositoryDocumentFinder = class (TAbstractDocumentFinder)

    protected

      FDocumentRepository: IDocumentRepository;

    protected

      function InternalFindDocumentsByNumbers(const Numbers: TStrings): TDocuments; override;

      function InternalFindDocumentsByNumberAndCreationYear(
        const Number: String;
        const CreationYear: Integer
      ): TDocuments; override;

      function InternalFindDocumentsByNumbersAndCreationYear(
        const Numbers: TStrings;
        const CreationYear: Integer
      ): TDocuments; override;

      function InternalFindDocumentById(const DocumentId: Variant): IDocument; override;
      function InternalFindDocumentsByIds(const DocumentIds: TVariantList): TDocuments; override;
      
    public

      constructor Create(DocumentRepository: IDocumentRepository);

  end;


implementation

{ TBasedOnRepositoryDocumentFinder }

constructor TBasedOnRepositoryDocumentFinder.Create(
  DocumentRepository: IDocumentRepository);
begin

  inherited Create;

  FDocumentRepository := DocumentRepository;
  
end;

function TBasedOnRepositoryDocumentFinder.
  InternalFindDocumentById(const DocumentId: Variant): IDocument;
begin

  Result := FDocumentRepository.FindDocumentById(DocumentId);

end;

function TBasedOnRepositoryDocumentFinder.
  InternalFindDocumentsByIds(const DocumentIds: TVariantList): TDocuments;
begin

  Result := FDocumentRepository.FindDocumentsByIds(DocumentIds);
  
end;

function TBasedOnRepositoryDocumentFinder
  .InternalFindDocumentsByNumberAndCreationYear(
    const Number: String;
    const CreationYear: Integer
  ): TDocuments;
begin

  Result:=
    FDocumentRepository.FindDocumentsByNumberAndCreationYear(
      Number, CreationYear
    );

end;

function TBasedOnRepositoryDocumentFinder
  .InternalFindDocumentsByNumbersAndCreationYear(
    const Numbers: TStrings;
    const CreationYear: Integer
  ): TDocuments;
begin

  Result :=
    FDocumentRepository.FindDocumentsByNumbersAndCreationYear(
      Numbers, CreationYear
    );
    
end;

function TBasedOnRepositoryDocumentFinder
  .InternalFindDocumentsByNumbers(
    const Numbers: TStrings
  ): TDocuments;
begin

  Result := FDocumentRepository.FindDocumentsByNumbers(Numbers);

end;

end.
