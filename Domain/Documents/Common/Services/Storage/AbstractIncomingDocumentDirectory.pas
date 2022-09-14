unit AbstractIncomingDocumentDirectory;

interface

uses

  DocumentDirectory,
  AbstractDocumentDirectory,
  DocumentRelationsUnit,
  DocumentFileUnit,
  DocumentFinder,
  DocumentRelationDirectory,
  DocumentPersistingValidator,
  DocumentApprovingCycleResultDirectory,
  DocumentResponsibleDirectory,
  DocumentFileStorageService,
  DocumentChargeSheetDirectory,
  Employee,
  IDocumentUnit,
  Document,
  IncomingDocument,
  VariantListUnit,
  SysUtils;

type

  {
    refactor(AbstractIncomingDocumentDirectory, 1):
    поскольку входящий документ не является полноценным документом
    с жизненным циклом, а только лишь обёрткой для учёта на стороне получателя,
    то и соответствующие классы и интерфейсы (в данном случае IncomingDocumentDirectory)
    следует не связывать иерархиями наследования с аналогичным классами и интерфейсами,
    соответствующими оригинальному документу. Это необходимо для упрощения
    самих классов и улучшения их дальнейшего сопровождения. Далее необходимо
    будет сделать такую же процудеру для других классов и интерфейсов, связанных
    иерархиями наследования, затрагивая все слои программы
  }
  
  TAbstractIncomingDocumentDirectory = class (TAbstractDocumentDirectory)

    protected

      FOriginalDocumentDirectory: IDocumentDirectory;

    protected

      function InternalFindDocumentsByNumber(const Number: String): TDocuments; override;
      
      function InternalFindDocumentById(const DocumentId: Variant): IDocument; override;
      function InternalFindDocumentsByIds(const DocumentIds: TVariantList): TDocuments; override;

      procedure AssignOriginalDocumentWorkingRulesAndSpecifications(IncomingDocument: TIncomingDocument);
      procedure AssignOriginalDocumentsWorkingRulesAndSpecifications(IncomingDocuments: TIncomingDocuments);
      
    public

      constructor Create(
        OriginalDocumentDirectory: IDocumentDirectory;
        DocumentPersistingValidator: IDocumentPersistingValidator;
        DocumentFinder: IDocumentFinder;
        DocumentRelationDirectory: IDocumentRelationDirectory;
        DocumentApprovingCycleResultDirectory: IDocumentApprovingCycleResultDirectory;
        DocumentResponsibleDirectory: IDocumentResponsibleDirectory;
        DocumentFileStorageService: IDocumentFileStorageService;
        DocumentChargeSheetDirectory: IDocumentChargeSheetDirectory
      );

    public
    
      procedure RemoveDocument(Document: TDocument); overload; override;
      procedure RemoveDocuments(Documents: TDocuments); overload; override;

  end;
  
implementation

uses

  DocumentSpecificationRegistry,
  DocumentRuleRegistry,
  IDomainObjectBaseUnit,
  IDomainObjectBaseListUnit;
  
{ TAbstractIncomingDocumentDirectory }

procedure TAbstractIncomingDocumentDirectory.AssignOriginalDocumentsWorkingRulesAndSpecifications(
  IncomingDocuments: TIncomingDocuments);
var
    IncomingDocument: TIncomingDocument;
begin

  for IncomingDocument in IncomingDocuments do 
    AssignOriginalDocumentWorkingRulesAndSpecifications(IncomingDocument);

end;

procedure TAbstractIncomingDocumentDirectory.AssignOriginalDocumentWorkingRulesAndSpecifications(
  IncomingDocument: TIncomingDocument);
begin

  IncomingDocument.OriginalDocument.WorkingRules :=
    TDocumentRuleRegistry.GetEmployeeDocumentWorkingRules(
      IncomingDocument.OriginalDocument.ClassType
    );

  IncomingDocument.OriginalDocument.Specifications :=
    TDocumentSpecificationRegistry.Instance.GetDocumentSpecifications(
      IncomingDocument.OriginalDocument.ClassType
    );

end;

constructor TAbstractIncomingDocumentDirectory.Create(
  OriginalDocumentDirectory: IDocumentDirectory;
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

  FOriginalDocumentDirectory := OriginalDocumentDirectory;
  
end;

function TAbstractIncomingDocumentDirectory.InternalFindDocumentById(
  const DocumentId: Variant): IDocument;
begin

  Result := inherited InternalFindDocumentById(DocumentId);

  AssignOriginalDocumentWorkingRulesAndSpecifications(TIncomingDocument(Result.Self));
  
end;

function TAbstractIncomingDocumentDirectory
  .InternalFindDocumentsByIds(const DocumentIds: TVariantList): TDocuments;
begin

  Result := inherited InternalFindDocumentsByIds(DocumentIds);

  AssignOriginalDocumentsWorkingRulesAndSpecifications(TIncomingDocuments(Result));
   
end;

function TAbstractIncomingDocumentDirectory.InternalFindDocumentsByNumber(
  const Number: String): TDocuments;
begin

  Result := FOriginalDocumentDirectory.FindDocumentsByNumber(Number);
  
end;

procedure TAbstractIncomingDocumentDirectory.RemoveDocument(Document: TDocument);
var
    IncomingDocument: TIncomingDocument;
begin

  InternalRemoveDocument(Document);

  IncomingDocument := Document as TIncomingDocument;

  FOriginalDocumentDirectory.RemoveDocument(IncomingDocument);

end;

procedure TAbstractIncomingDocumentDirectory.RemoveDocuments(Documents: TDocuments);
var
    OriginalDocuments: TDocuments;
    Free: IDomainObjectBaseList;
    
    IncomingDocuments: TIncomingDocuments;
    IncomingDocument: TIncomingDocument;
begin

  InternalRemoveDocuments(Documents);

  IncomingDocuments := Documents as TIncomingDocuments;

  OriginalDocuments := nil;
  
  for IncomingDocument in IncomingDocuments do begin

    if not Assigned(OriginalDocuments) then begin

      OriginalDocuments := IncomingDocument.OriginalDocument.ListType.Create;

      Free := OriginalDocuments;
      
    end;

    OriginalDocuments.AddDocument(IncomingDocument.OriginalDocument);

  end;

  FOriginalDocumentDirectory.RemoveDocuments(OriginalDocuments);

end;

end.
