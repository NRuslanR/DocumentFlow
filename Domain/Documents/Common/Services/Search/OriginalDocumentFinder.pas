unit OriginalDocumentFinder;

interface

uses

  AbstractDocumentFinder,
  DocumentFinder,
  VariantListUnit,
  IDocumentUnit,
  DocumentChargeInterface,
  IncomingDocument,
  Document,
  SysUtils,
  Classes;

type

  TOriginalDocumentFinder = class (TAbstractDocumentFinder)

    private

      FDocumentFinder: IDocumentFinder;

      function ExtractOriginalDocument(Document: IDocument): IDocument;
      function ExtractOriginalDocuments(Documents: TDocuments): TDocuments;
      
    protected

      function InternalFindDocumentsByNumbers(const Numbers: TStrings): TDocuments; override;

      function InternalFindDocumentById(const DocumentId: Variant): IDocument; override;
      function InternalFindDocumentsByIds(const DocumentIds: TVariantList): TDocuments; override;

    public

      constructor Create(DocumentFinder: IDocumentFinder);

  end;

implementation

uses

  AuxDebugFunctionsUnit,
  IDomainObjectBaseListUnit;
  
{ TOriginalDocumentFinder }

constructor TOriginalDocumentFinder.Create(DocumentFinder: IDocumentFinder);
begin

  inherited Create;

  FDocumentFinder := DocumentFinder;
  
end;

function TOriginalDocumentFinder.InternalFindDocumentById(
  const DocumentId: Variant): IDocument;
begin

  Result := ExtractOriginalDocument(FDocumentFinder.FindDocumentById(DocumentId));

end;

function TOriginalDocumentFinder.ExtractOriginalDocument(
  Document: IDocument): IDocument;
begin

  if not Assigned(Document) then
    Result := nil

  else if Document.Self is TIncomingDocument then
    Result := TIncomingDocument(Document.Self).OriginalDocument

  else Result := Document;
  
end;

function TOriginalDocumentFinder.ExtractOriginalDocuments(
  Documents: TDocuments): TDocuments;
begin

  if not Assigned(Documents) then
    Result := nil

  else if Documents is TIncomingDocuments then
    Result := TIncomingDocuments(Documents).ExtractOriginalDocuments

  else Result := Documents;
  
end;

function TOriginalDocumentFinder.InternalFindDocumentsByIds(
  const DocumentIds: TVariantList): TDocuments;
var
    IncomingDocuments: TDocuments;
    Free: IDomainObjectBaseList;
begin

  IncomingDocuments := FDocumentFinder.FindDocumentsByIds(DocumentIds);

  Free := IncomingDocuments;

  Result := ExtractOriginalDocuments(IncomingDocuments);

end;

function TOriginalDocumentFinder.InternalFindDocumentsByNumbers(
  const Numbers: TStrings): TDocuments;
var
    IncomingDocuments: TDocuments;
    Free: IDomainObjectBaseList;
begin

  DebugOutput(FDocumentFinder.Self.ClassName);
  
  IncomingDocuments := FDocumentFinder.FindDocumentsByNumbers(Numbers);

  Free := IncomingDocuments;

  Result := ExtractOriginalDocuments(IncomingDocuments);
  
end;

end.
