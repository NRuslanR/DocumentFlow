unit AbstractDocumentDirectory;

interface

uses

  Document,
  DocumentDirectory,
  DocumentRelationDirectory,
  DocumentResponsibleDirectory,
  DocumentFileStorageService,
  DocumentFinder,
  IDocumentUnit,
  DocumentChargeSheetDirectory,
  DocumentApprovingCycleResultDirectory,
  DocumentRelationsUnit,
  DocumentFileUnit,
  Employee,
  DocumentPersistingValidator,
  DocumentFullNameCompilationService,
  VariantListUnit,
  SysUtils,
  Classes;

type

  TAbstractDocumentDirectory = class (TInterfacedObject, IDocumentDirectory)

    protected

      FDocumentPersistingValidator: IDocumentPersistingValidator;
      FDocumentFinder: IDocumentFinder;
      FDocumentRelationDirectory: IDocumentRelationDirectory;
      FDocumentApprovingCycleResultDirectory: IDocumentApprovingCycleResultDirectory;
      FDocumentResponsibleDirectory: IDocumentResponsibleDirectory;
      FDocumentFileStorageService: IDocumentFileStorageService;
      FDocumentChargeSheetDirectory: IDocumentChargeSheetDirectory;
      FDocumentFullNameCompilationService: IDocumentFullNameCompilationService;
      
      function InternalFindDocumentsByNumber(const Number: String): TDocuments; virtual;

      function InternalFindDocumentById(const DocumentId: Variant): IDocument; virtual;
      function InternalFindDocumentsByIds(const DocumentIds: TVariantList): TDocuments; virtual;

      procedure InternalPutDocument(Document: TDocument); virtual; abstract;
      procedure InternalPutDocuments(Documents: TDocuments); virtual; abstract;

      procedure InternalModifyDocument(Document: TDocument); virtual; abstract;
      procedure InternalModifyDocuments(Documents: TDocuments); virtual; abstract;

      procedure InternalRemoveDocument(Document: TDocument); virtual; abstract;
      procedure InternalRemoveDocuments(Documents: TDocuments); virtual; abstract;

    protected

      procedure RemoveAllRelatedDocumentObjects(Document: TDocument); virtual;
      procedure RemoveAllRelatedObjectsOfDocuments(Documents: TDocuments); virtual;

    protected

      procedure PutDocumentRelations(
        Document: TDocument;
        Relations: TDocumentRelations
      );
      
      procedure PutDocumentFiles(
        Document: TDocument;
        Files: TDocumentFiles
      );
      
      procedure PutDocumentResponsible(
        Document: TDocument;
        Responsible: TEmployee
      );

    protected

      procedure ModifyDocumentRelations(
        Document: TDocument;
        Relations: TDocumentRelations
      );
      
      procedure ModifyDocumentFiles(
        Document: TDocument;
        Files: TDocumentFiles
      );
      
      procedure ModifyDocumentResponsible(
        Document: TDocument;
        Responsible: TEmployee
      );

    private

      procedure PrepareDocumentBeforeSaving(Document: TDocument);
      procedure PrepareDocumentsBeforeSaving(Documents: TDocuments);
      
    public

      destructor Destroy; override;
      
      constructor Create(
        DocumentPersistingValidator: IDocumentPersistingValidator;
        DocumentFinder: IDocumentFinder;
        DocumentRelationDirectory: IDocumentRelationDirectory;
        DocumentApprovingCycleResultDirectory: IDocumentApprovingCycleResultDirectory;
        DocumentResponsibleDirectory: IDocumentResponsibleDirectory;
        DocumentFileStorageService: IDocumentFileStorageService;
        DocumentChargeSheetDirectory: IDocumentChargeSheetDirectory;
        DocumentFullNameCompilationService: IDocumentFullNameCompilationService
      );

      function GetSelf: TObject;

      function FindDocumentsByNumber(const Number: String): TDocuments;
      
      function FindDocumentById(const DocumentId: Variant): IDocument; virtual;
      function FindDocumentsByIds(const DocumentIds: TVariantList): TDocuments; virtual;
      
      procedure PutDocument(Document: TDocument); virtual;
      procedure PutDocuments(Documents: TDocuments); virtual;

      procedure PutDocumentAndRelatedObjects(
        Document: TDocument;
        Relations: TDocumentRelations;
        Files: TDocumentFiles;
        Responsible: TEmployee
      ); virtual;

      procedure ModifyDocument(Document: TDocument); virtual;
      procedure ModifyDocuments(Documents: TDocuments); virtual;

      procedure ModifyDocumentAndRelatedObjects(
        Document: TDocument;
        Relations: TDocumentRelations;
        Files: TDocumentFiles;
        Responsible: TEmployee
      ); virtual;
      
      procedure RemoveDocument(Document: TDocument); overload; virtual;
      procedure RemoveDocuments(Documents: TDocuments); overload; virtual;

      procedure RemoveDocument(const DocumentId: Variant); overload; virtual;
      procedure RemoveDocuments(const DocumentIds: TVariantList); overload; virtual;

  end;
  
implementation

uses

  AuxCollectionFunctionsUnit,
  AuxDebugFunctionsUnit,
  IDomainObjectBaseUnit,
  ObjectsDestroyer,
  IDomainObjectBaseListUnit,
  DocumentRuleRegistry;

{ TAbstractDocumentDirectory }

constructor TAbstractDocumentDirectory.Create(
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

  inherited Create;

  FDocumentPersistingValidator := DocumentPersistingValidator;
  FDocumentFinder := DocumentFinder;
  FDocumentRelationDirectory := DocumentRelationDirectory;
  FDocumentApprovingCycleResultDirectory := DocumentApprovingCycleResultDirectory;
  FDocumentResponsibleDirectory := DocumentResponsibleDirectory;
  FDocumentFileStorageService := DocumentFileStorageService;
  FDocumentChargeSheetDirectory := DocumentChargeSheetDirectory;
  FDocumentFullNameCompilationService := DocumentFullNameCompilationService;
  
end;

destructor TAbstractDocumentDirectory.Destroy;
begin

  inherited;

end;

function TAbstractDocumentDirectory.FindDocumentById(
  const DocumentId: Variant): IDocument;
begin

  Result := InternalFindDocumentById(DocumentId);

  if not Assigned(Result) then
    raise TDocumentNotFoundException.Create;

end;

function TAbstractDocumentDirectory.
  FindDocumentsByIds(const DocumentIds: TVariantList): TDocuments;
var
    Document: TDocument;
begin

  Result := InternalFindDocumentsByIds(DocumentIds);
  
end;

function TAbstractDocumentDirectory.FindDocumentsByNumber(
  const Number: String): TDocuments;
begin

  Result := InternalFindDocumentsByNumber(Number); 

end;

function TAbstractDocumentDirectory.GetSelf: TObject;
begin

  Result := Self;
  
end;

function TAbstractDocumentDirectory.InternalFindDocumentById(
  const DocumentId: Variant
): IDocument;
begin

  Result := FDocumentFinder.FindDocumentById(DocumentId);

end;

function TAbstractDocumentDirectory.InternalFindDocumentsByIds(
  const DocumentIds: TVariantList): TDocuments;
begin

  Result := FDocumentFinder.FindDocumentsByIds(DocumentIds);
  
end;

function TAbstractDocumentDirectory.InternalFindDocumentsByNumber(
  const Number: String): TDocuments;
begin

  Result := FDocumentFinder.FindDocumentsByNumber(Number);

end;

procedure TAbstractDocumentDirectory.PutDocumentAndRelatedObjects(
  Document: TDocument;
  Relations: TDocumentRelations;
  Files: TDocumentFiles;
  Responsible: TEmployee
);
begin

  PutDocument(Document);

  PutDocumentRelations(Document, Relations);
  PutDocumentFiles(Document, Files);
  PutDocumentResponsible(Document, Responsible);

end;

procedure TAbstractDocumentDirectory.PutDocument(Document: TDocument);
begin

  FDocumentPersistingValidator.EnsureDocumentMayBePuttedInDirectory(Document);

  PrepareDocumentBeforeSaving(Document);

  InternalPutDocument(Document);

end;

procedure TAbstractDocumentDirectory.PutDocuments(Documents: TDocuments);
begin

  FDocumentPersistingValidator.EnsureDocumentsMayBePuttedInDirectory(Documents);

  PrepareDocumentsBeforeSaving(Documents);

  InternalPutDocuments(Documents);

end;

procedure TAbstractDocumentDirectory.ModifyDocument(Document: TDocument);
begin

  FDocumentPersistingValidator.EnsureDocumentMayBeModifiedInDirectory(Document);

  PrepareDocumentBeforeSaving(Document);

  InternalModifyDocument(Document);
  
end;

procedure TAbstractDocumentDirectory.ModifyDocumentAndRelatedObjects(
  Document: TDocument;
  Relations: TDocumentRelations;
  Files: TDocumentFiles;
  Responsible: TEmployee
);
begin

  ModifyDocumentRelations(Document, Relations);
  ModifyDocumentFiles(Document, Files);
  ModifyDocumentResponsible(Document, Responsible);

  ModifyDocument(Document);

end;

procedure TAbstractDocumentDirectory.ModifyDocuments(Documents: TDocuments);
begin

  FDocumentPersistingValidator.EnsureDocumentsMayBeModifiedInDirectory(Documents);

  PrepareDocumentsBeforeSaving(Documents);

  InternalModifyDocuments(Documents);

end;

procedure TAbstractDocumentDirectory.PrepareDocumentsBeforeSaving(
  Documents: TDocuments);
var
    Document: TDocument;
begin

  for Document in Documents do
    PrepareDocumentBeforeSaving(Document);

end;

procedure TAbstractDocumentDirectory.PrepareDocumentBeforeSaving(
  Document: TDocument);
begin

  Document.InvariantsComplianceRequested := False;

  Document.FullName :=
    FDocumentFullNameCompilationService.CompileFullNameForDocument(Document);

  Document.InvariantsComplianceRequested := True;
  
end;

procedure TAbstractDocumentDirectory.PutDocumentFiles(
  Document: TDocument;
  Files: TDocumentFiles
);
begin

  if Assigned(Files) and not Files.IsEmpty then begin

    Files.AssignDocument(Document);

    FDocumentFileStorageService.PutDocumentFiles(Files);
    
  end;

end;

procedure TAbstractDocumentDirectory.PutDocumentRelations(
  Document: TDocument;
  Relations: TDocumentRelations
);
begin

  if Assigned(Relations) and (Relations.RelationCount > 0) then begin

    Relations.AssignTargetDocument(Document);

    FDocumentRelationDirectory.AddDocumentRelations(Relations);
    
  end;

end;

procedure TAbstractDocumentDirectory.PutDocumentResponsible(
  Document: TDocument;
  Responsible: TEmployee
);
begin

  ModifyDocumentResponsible(Document, Responsible);

end;

procedure TAbstractDocumentDirectory.RemoveDocument(Document: TDocument);
begin
  
  RemoveAllRelatedDocumentObjects(Document);

  InternalRemoveDocument(Document);
  
end;

procedure TAbstractDocumentDirectory.RemoveDocuments(Documents: TDocuments);
begin

  RemoveAllRelatedObjectsOfDocuments(Documents);
  
  InternalRemoveDocuments(Documents);

end;

procedure TAbstractDocumentDirectory.RemoveAllRelatedDocumentObjects(
  Document: TDocument
);
begin
                                                       
  FDocumentRelationDirectory.RemoveAllRelationsForDocument(Document.Identity);
  FDocumentApprovingCycleResultDirectory.RemoveAllApprovingCycleResultsForDocument(Document.Identity);
  FDocumentChargeSheetDirectory.RemoveAllChargeSheetsForDocument(Document.Identity);
  FDocumentFileStorageService.RemoveAllFilesForDocument(Document.Identity);

end;

procedure TAbstractDocumentDirectory.RemoveAllRelatedObjectsOfDocuments(
  Documents: TDocuments
);
var
    Document: TDocument;
begin

  for Document in Documents do
    RemoveAllRelatedDocumentObjects(Document);

end;

procedure TAbstractDocumentDirectory.RemoveDocument(const DocumentId: Variant);
var
    Document: IDocument;
begin

  Document := FDocumentFinder.FindDocumentById(DocumentId);

  RemoveDocument(TDocument(Document.Self));

end;

procedure TAbstractDocumentDirectory.RemoveDocuments(
  const DocumentIds: TVariantList
);
var
    DocumentId: Variant;

    Documents: TDocuments;
    FreeList: IDomainObjectBaseList;
begin

  Documents := FDocumentFinder.FindDocumentsByIds(DocumentIds);

  FreeList := Documents;
  
  RemoveDocuments(Documents);
  
end;

procedure TAbstractDocumentDirectory.ModifyDocumentFiles(
  Document: TDocument;
  Files: TDocumentFiles
);
begin

  if not Assigned(Files) then Exit;

  Files.AssignDocument(Document);
  
  FDocumentFileStorageService.UpdateDocumentFilesFor(Files, Document.Identity);
    
end;

procedure TAbstractDocumentDirectory.
  ModifyDocumentRelations(
    Document: TDocument;
    Relations: TDocumentRelations
  );
begin

  if not Assigned(Relations) then Exit;

  FDocumentRelationDirectory.RemoveAllRelationsForDocument(Document.Identity);

  PutDocumentRelations(Document, Relations);

end;

procedure TAbstractDocumentDirectory.
  ModifyDocumentResponsible(
    Document: TDocument;
    Responsible: TEmployee
  );
begin

  if Assigned(Responsible) then begin

    FDocumentResponsibleDirectory.UpdateDocumentResponsibleTelephoneNumber(
      Responsible.Identity,
      Responsible.TelephoneNumber
    );

  end;

end;

end.
