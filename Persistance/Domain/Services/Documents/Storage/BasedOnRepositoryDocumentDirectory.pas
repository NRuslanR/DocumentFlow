unit BasedOnRepositoryDocumentDirectory;

interface

uses

  Document,
  AbstractDocumentDirectory,
  VariantListUnit,
  DocumentRepository,
  DocumentRelationDirectory,
  DocumentFinder,
  DocumentApprovingCycleResultDirectory,
  DocumentResponsibleDirectory,
  DocumentPersistingValidator,
  DocumentFileStorageService,
  DocumentChargeSheetDirectory,
  SysUtils,
  Classes;

type

  TBasedOnRepositoryDocumentDirectory =
    class (TAbstractDocumentDirectory)

      protected

        FDocumentRepository: IDocumentRepository;
        
      protected

        procedure InternalPutDocument(Document: TDocument); override;
        procedure InternalPutDocuments(Documents: TDocuments); override;

        procedure InternalModifyDocument(Document: TDocument); override;
        procedure InternalModifyDocuments(Documents: TDocuments); override;

        procedure InternalRemoveDocument(Document: TDocument); override;
        procedure InternalRemoveDocuments(Documents: TDocuments); override;

      public

        constructor Create(
          DocumentRepository: IDocumentRepository;
          DocumentPersistingValidator: IDocumentPersistingValidator;
          DocumentFinder: IDocumentFinder;
          DocumentRelationDirectory: IDocumentRelationDirectory;
          DocumentApprovingCycleResultDirectory: IDocumentApprovingCycleResultDirectory;
          DocumentResponsibleDirectory: IDocumentResponsibleDirectory;
          DocumentFileStorageService: IDocumentFileStorageService;
          DocumentChargeSheetDirectory: IDocumentChargeSheetDirectory
        );

    end;

implementation

{ TBasedOnRepositoryDocumentDirectory }

constructor TBasedOnRepositoryDocumentDirectory.Create(
  DocumentRepository: IDocumentRepository;
  DocumentPersistingValidator: IDocumentPersistingValidator;
  DocumentFinder: IDocumentFinder;
  DocumentRelationDirectory: IDocumentRelationDirectory;
  DocumentApprovingCycleResultDirectory: IDocumentApprovingCycleResultDirectory;
  DocumentResponsibleDirectory: IDocumentResponsibleDirectory;
  DocumentFileStorageService: IDocumentFileStorageService;
  DocumentChargeSheetDirectory: IDocumentChargeSheetDirectory
);
begin

  inherited Create(
    DocumentPersistingValidator,
    DocumentFinder,
    DocumentRelationDirectory,
    DocumentApprovingCycleResultDirectory,
    DocumentResponsibleDirectory,
    DocumentFileStorageService,
    DocumentChargeSheetDirectory
  );

  FDocumentRepository := DocumentRepository;
  
end;

procedure TBasedOnRepositoryDocumentDirectory.InternalModifyDocument(
  Document: TDocument);
begin

  FDocumentRepository.UpdateDocument(Document);

end;

procedure TBasedOnRepositoryDocumentDirectory.InternalModifyDocuments(
  Documents: TDocuments);
begin

  FDocumentRepository.UpdateDocuments(Documents);

end;

procedure TBasedOnRepositoryDocumentDirectory.InternalPutDocument(
  Document: TDocument);
begin

  FDocumentRepository.AddDocument(Document);

end;

procedure TBasedOnRepositoryDocumentDirectory.InternalPutDocuments(
  Documents: TDocuments);
begin

  FDocumentRepository.AddDocuments(Documents);

end;

procedure TBasedOnRepositoryDocumentDirectory.InternalRemoveDocument(
  Document: TDocument);
begin

  FDocumentRepository.RemoveDocument(Document);

end;

procedure TBasedOnRepositoryDocumentDirectory.InternalRemoveDocuments(
  Documents: TDocuments);
begin

  FDocumentRepository.RemoveDocuments(Documents);

end;

end.
