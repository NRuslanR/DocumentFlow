unit DocumentDirectory;

interface

uses

  Document,
  Employee,
  IDocumentUnit,
  DocumentRelationsUnit,
  DocumentFileUnit,
  IGetSelfUnit,
  DomainException,
  VariantListUnit,
  SysUtils;

type

  TDocumentDirectoryException = class(TDomainException)

  end;

  TDocumentNotFoundException = class (TDocumentDirectoryException)

    public

      constructor Create;
      
  end;

  IDocumentDirectory = interface (IGetSelf)
    ['{54B24764-9CA6-48F0-BA6C-0CF91EBC4602}']

    function FindDocumentsByNumber(const Number: String): TDocuments;
    
    function FindDocumentById(const DocumentId: Variant): IDocument;
    function FindDocumentsByIds(const DocumentIds: TVariantList): TDocuments;
    
    procedure PutDocument(Document: TDocument);
    procedure PutDocuments(Documents: TDocuments);

    procedure PutDocumentAndRelatedObjects(
      Document: TDocument;
      Relations: TDocumentRelations;
      Files: TDocumentFiles;
      Responsible: TEmployee
    );

    procedure ModifyDocument(Document: TDocument);
    procedure ModifyDocuments(Documents: TDocuments);

    procedure ModifyDocumentAndRelatedObjects(
      Document: TDocument;
      Relations: TDocumentRelations;
      Files: TDocumentFiles;
      Responsible: TEmployee
    );
    
    procedure RemoveDocument(Document: TDocument); overload;
    procedure RemoveDocuments(Documents: TDocuments); overload;

    procedure RemoveDocument(const DocumentId: Variant); overload;
    procedure RemoveDocuments(const DocumentIds: TVariantList); overload;
    
  end;

implementation

{ TDocumentNotFoundException }

constructor TDocumentNotFoundException.Create;
begin

  inherited Create('Документ не найден в каталоге');
  
end;

end.
