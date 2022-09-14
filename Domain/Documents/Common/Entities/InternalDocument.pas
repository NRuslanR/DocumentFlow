unit InternalDocument;

interface

uses

  AbstractDocumentDecorator,
  Document;

type

  TInternalDocument = class;
  TInternalDocumentClass = class of TInternalDocument;

  TInternalDocuments = class;
  TInternalDocumentsClass = class of TInternalDocuments;
  
  TInternalDocument = class (TAbstractDocumentDecorator)

    public

      class function ListType: TDocumentsClass; override;
      class function IncomingDocumentType: TDocumentClass; override;

  end;

  TInternalDocumentsEnumerator = class (TDocumentsEnumerator)

    private

      function GetCurrentInternalDocument: TInternalDocument;

    public

      constructor Create(InternalDocuments: TInternalDocuments);

      property Current: TInternalDocument read GetCurrentInternalDocument;
      
  end;

  TInternalDocuments = class (TDocuments)

    protected

      function GetDocumentByIndex(Index: Integer): TInternalDocument;
      procedure SetDocumentByIndex(Index: Integer; Document: TInternalDocument);
      
    public

      procedure AddDocument(Document: TInternalDocument);
      procedure RemoveDocument(Document: TInternalDocument);

      function FindDocumentById(
        const DocumentId: Variant
      ): TInternalDocument;

      property Items[Index: Integer]: TInternalDocument
      read GetDocumentByIndex
      write SetDocumentByIndex; default;

      function GetEnumerator: TInternalDocumentsEnumerator;
      
  end;
  
implementation

uses

  IncomingInternalDocument;

{ TInternalDocumentsEnumerator }

constructor TInternalDocumentsEnumerator.Create(
  InternalDocuments: TInternalDocuments);
begin

  inherited Create(InternalDocuments);

end;

function TInternalDocumentsEnumerator.GetCurrentInternalDocument: TInternalDocument;
begin

  Result := TInternalDocument(GetCurrentDocument);

end;

{ TInternalDocuments }

procedure TInternalDocuments.AddDocument(Document: TInternalDocument);
begin

  inherited AddDocument(Document);
  
end;

function TInternalDocuments.FindDocumentById(
  const DocumentId: Variant): TInternalDocument;
begin

  Result := TInternalDocument(inherited FindDocumentById(DocumentId));

end;

function TInternalDocuments.GetDocumentByIndex(
  Index: Integer): TInternalDocument;
begin

  Result := TInternalDocument(inherited GetDocumentByIndex(Index));

end;

function TInternalDocuments.GetEnumerator: TInternalDocumentsEnumerator;
begin

  Result := TInternalDocumentsEnumerator.Create(Self);
  
end;

procedure TInternalDocuments.RemoveDocument(Document: TInternalDocument);
begin

  inherited RemoveDocument(Document);

end;

procedure TInternalDocuments.SetDocumentByIndex(Index: Integer;
  Document: TInternalDocument);
begin

  inherited SetDocumentByIndex(Index, Document);

end;

{ TInternalDocument }

class function TInternalDocument.IncomingDocumentType: TDocumentClass;
begin

  Result := TIncomingInternalDocument;
  
end;

class function TInternalDocument.ListType: TDocumentsClass;
begin

  Result := TInternalDocuments;

end;

end.
