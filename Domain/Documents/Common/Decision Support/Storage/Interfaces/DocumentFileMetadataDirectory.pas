unit DocumentFileMetadataDirectory;

interface

uses

  DocumentFileUnit,
  DomainException;

type

  IDocumentFileMetadataDirectory = interface

    function FindDocumentFileMetadataById(const DocumentFileId: Variant): TDocumentFile;
    function FindDocumentFileMetadatas(const DocumentId: Variant): TDocumentFiles;

    procedure PutDocumentFileMetadata(DocumentFileMetadata: TDocumentFile);
    procedure PutDocumentFileMetadatas(DocumentFileMetadatas: TDocumentFiles);

    procedure UpdateDocumentFileMetadata(DocumentFileMetadata: TDocumentFile);
    
    procedure RemoveDocumentFileMetadata(DocumentFileMetadata: TDocumentFile);
    procedure RemoveAllDocumentFilesMetadata(const DocumentId: Variant);
    
  end;

implementation

end.
