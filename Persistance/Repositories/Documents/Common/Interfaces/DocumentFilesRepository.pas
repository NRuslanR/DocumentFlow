unit DocumentFilesRepository;

interface

uses

  Document,
  DocumentFileUnit;
  
type

  IDocumentFilesRepository = interface

    procedure AddDocumentFile(DocumentFile: TDocumentFile);
    procedure AddDocumentFiles(DocumentFiles: TDocumentFiles);

    procedure UpdateDocumentFile(DocumentFile: TDocumentFile);

    procedure RemoveDocumentFile(DocumentFile: TDocumentFile);
    procedure RemoveAllFilesForDocument(const DocumentId: Variant);

    function FindDocumentFileById(const DocumentFileId: Variant): TDocumentFile;
    function FindFilesForDocument(const DocumentId: Variant): TDocumentFiles;

  end;

implementation

end.
