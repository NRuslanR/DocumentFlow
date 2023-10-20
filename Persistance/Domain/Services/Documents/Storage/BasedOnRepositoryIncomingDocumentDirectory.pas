unit BasedOnRepositoryIncomingDocumentDirectory;

interface

uses

  DocumentFullNameCompilationService,
  DocumentDirectory,
  DocumentFinder,
  DocumentRelationDirectory,
  DocumentPersistingValidator,
  DocumentApprovingCycleResultDirectory,
  DocumentResponsibleDirectory,
  DocumentFileStorageService,
  IncomingDocumentRepository,
  Document,
  IncomingDocument,
  AbstractIncomingDocumentDirectory,
  DocumentChargeSheetDirectory,
  SysUtils;

type

  TBasedOnRepositoryIncomingDocumentDirectory =
    class (TAbstractIncomingDocumentDirectory)

      private

        FIncomingDocumentRepository: IIncomingDocumentRepository;

      protected

        procedure InternalPutDocument(Document: TDocument); override;
        procedure InternalPutDocuments(Documents: TDocuments); override;

        procedure InternalModifyDocument(Document: TDocument); override;
        procedure InternalModifyDocuments(Documents: TDocuments); override;

        procedure InternalRemoveDocument(Document: TDocument); override;
        procedure InternalRemoveDocuments(Documents: TDocuments); override;

      public

        constructor Create(
          IncomingDocumentRepository: IIncomingDocumentRepository;
          OriginalDocumentDirectory: IDocumentDirectory;
          DocumentPersistingValidator: IDocumentPersistingValidator;
          DocumentFinder: IDocumentFinder;
          DocumentRelationDirectory: IDocumentRelationDirectory;
          DocumentApprovingCycleResultDirectory: IDocumentApprovingCycleResultDirectory;
          DocumentResponsibleDirectory: IDocumentResponsibleDirectory;
          DocumentFileStorageService: IDocumentFileStorageService;
          DocumentChargeSheetDirectory: IDocumentChargeSheetDirectory;
          DocumentFullNameCompilationService: IDocumentFullNameCompilationService
        );
        
    end;


implementation

{ TBasedOnRepositoryIncomingDocumentDirectory }

constructor TBasedOnRepositoryIncomingDocumentDirectory.Create(
  IncomingDocumentRepository: IIncomingDocumentRepository;
  OriginalDocumentDirectory: IDocumentDirectory;
  DocumentPersistingValidator: IDocumentPersistingValidator;
  DocumentFinder: IDocumentFinder;
  DocumentRelationDirectory: IDocumentRelationDirectory;
  DocumentApprovingCycleResultDirectory: IDocumentApprovingCycleResultDirectory;
  DocumentResponsibleDirectory: IDocumentResponsibleDirectory;
  DocumentFileStorageService: IDocumentFileStorageService;
  DocumentChargeSheetDirectory: IDocumentChargeSheetDirectory;
  DocumentFullNameCompilationService: IDocumentFullNameCompilationService
);
begin

  inherited Create(
    OriginalDocumentDirectory,
    DocumentPersistingValidator,
    DocumentFinder,
    DocumentRelationDirectory,
    DocumentApprovingCycleResultDirectory,
    DocumentResponsibleDirectory,
    DocumentFileStorageService,
    DocumentChargeSheetDirectory,
    DocumentFullNameCompilationService
  );

  FIncomingDocumentRepository := IncomingDocumentRepository;
  
end;

procedure TBasedOnRepositoryIncomingDocumentDirectory.InternalModifyDocument(
  Document: TDocument);
begin

  FIncomingDocumentRepository.UpdateIncomingDocument(Document as TIncomingDocument);
  
end;

procedure TBasedOnRepositoryIncomingDocumentDirectory.InternalModifyDocuments(
  Documents: TDocuments);
begin

  FIncomingDocumentRepository.UpdateIncomingDocuments(Documents as TIncomingDocuments);

end;

procedure TBasedOnRepositoryIncomingDocumentDirectory.InternalPutDocument(
  Document: TDocument);
begin

  FIncomingDocumentRepository.AddIncomingDocument(Document as TIncomingDocument);
  
end;

procedure TBasedOnRepositoryIncomingDocumentDirectory.InternalPutDocuments(
  Documents: TDocuments);
begin

  FIncomingDocumentRepository.AddIncomingDocuments(Documents as TIncomingDocuments);

end;

procedure TBasedOnRepositoryIncomingDocumentDirectory.InternalRemoveDocument(
  Document: TDocument);
begin

  FIncomingDocumentRepository.RemoveIncomingDocument(Document as TIncomingDocument);

end;

procedure TBasedOnRepositoryIncomingDocumentDirectory.InternalRemoveDocuments(
  Documents: TDocuments);
begin

  FIncomingDocumentRepository.RemoveIncomingDocuments(Documents as TIncomingDocuments);
  
end;

end.
