unit BasedOnRepositoryDocumentFileMetadataDirectory;

interface

uses

  DocumentFileMetadataDirectory,
  DocumentFilesRepository,
  DocumentFileUnit,
  SysUtils,
  Classes;

type

  TBasedOnRepositoryDocumentFileMetadataDirectory =
    class (TInterfacedObject, IDocumentFileMetadataDirectory)

      private

        FDocumentFilesRepository: IDocumentFilesRepository;
        
      public

        constructor Create(DocumentFilesRepository: IDocumentFilesRepository);

        function FindDocumentFileMetadataById(const DocumentFileId: Variant): TDocumentFile;
        function FindDocumentFileMetadatas(const DocumentId: Variant): TDocumentFiles;

        procedure PutDocumentFileMetadata(DocumentFileMetadata: TDocumentFile);
        procedure PutDocumentFileMetadatas(DocumentFileMetadatas: TDocumentFiles);

        procedure UpdateDocumentFileMetadata(DocumentFileMetadata: TDocumentFile);

        procedure RemoveDocumentFileMetadata(DocumentFileMetadata: TDocumentFile);
        procedure RemoveAllDocumentFilesMetadata(const DocumentId: Variant);

    end;

implementation

{ TBasedOnRepositoryDocumentFileMetadataDirectory }

constructor TBasedOnRepositoryDocumentFileMetadataDirectory.Create(
  DocumentFilesRepository: IDocumentFilesRepository);
begin

  inherited Create;

  FDocumentFilesRepository := DocumentFilesRepository;
  
end;

function TBasedOnRepositoryDocumentFileMetadataDirectory.FindDocumentFileMetadataById(
  const DocumentFileId: Variant): TDocumentFile;
begin

  Result := FDocumentFilesRepository.FindDocumentFileById(DocumentFileId);
  
end;

function TBasedOnRepositoryDocumentFileMetadataDirectory.FindDocumentFileMetadatas(
  const DocumentId: Variant): TDocumentFiles;
begin

  Result := FDocumentFilesRepository.FindFilesForDocument(DocumentId);
  
end;

procedure TBasedOnRepositoryDocumentFileMetadataDirectory.PutDocumentFileMetadata(
  DocumentFileMetadata: TDocumentFile);
begin

  FDocumentFilesRepository.AddDocumentFile(DocumentFileMetadata);

end;

procedure TBasedOnRepositoryDocumentFileMetadataDirectory.PutDocumentFileMetadatas(
  DocumentFileMetadatas: TDocumentFiles);
begin

  FDocumentFilesRepository.AddDocumentFiles(DocumentFileMetadatas);
  
end;

procedure TBasedOnRepositoryDocumentFileMetadataDirectory.RemoveAllDocumentFilesMetadata(
  const DocumentId: Variant);
begin

  FDocumentFilesRepository.RemoveAllFilesForDocument(DocumentId);
  
end;

procedure TBasedOnRepositoryDocumentFileMetadataDirectory.RemoveDocumentFileMetadata(
  DocumentFileMetadata: TDocumentFile);
begin

  FDocumentFilesRepository.RemoveDocumentFile(DocumentFileMetadata);

end;

procedure TBasedOnRepositoryDocumentFileMetadataDirectory.UpdateDocumentFileMetadata(
  DocumentFileMetadata: TDocumentFile);
begin

  FDocumentFilesRepository.UpdateDocumentFile(DocumentFileMetadata);

end;

end.
