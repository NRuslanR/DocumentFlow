unit IncomingInternalDocument;

interface

uses

  IncomingDocument,
  Document,
  SysUtils,
  Classes;

type

  TIncomingInternalDocument = class (TIncomingDocument)

    protected

      function GetOriginalIncomingDocument: TIncomingDocument;
      procedure SetOriginalIncomingDocument(const Value: TIncomingDocument);

    protected

      function GetIdentity: Variant; override;
      function GetIncomingNumber: String; override;
      function GetReceiptDate: Variant; override;
      function GetIsIncomingNumberAssigned: Boolean; override;

      procedure SetIdentity(Identity: Variant); override;
      procedure SetIncomingNumber(const Value: String); override;
      procedure SetReceiptDate(const Value: Variant); override;
      
    protected

      procedure SetOriginalDocument(const Value: TDocument); override;

    public

      class function ListType: TDocumentsClass; override;
      
      property OriginalIncomingDocument: TIncomingDocument
      read GetOriginalIncomingDocument write SetOriginalIncomingDocument;
      
  end;

  TIncomingInternalDocuments = class;

  TIncomingInternalDocumentsEnumerator = class (TIncomingDocumentsEnumerator)

    protected

      function GetCurrentIncomingInternalDocument: TIncomingInternalDocument;

    public

      constructor Create(IncomingInternalDocuments: TIncomingInternalDocuments);

      property Current: TIncomingInternalDocument
      read GetCurrentIncomingInternalDocument;

  end;
  
  TIncomingInternalDocuments = class (TIncomingDocuments)

    public

      function GetEnumerator: TIncomingInternalDocumentsEnumerator;
      
  end;

implementation

uses AbstractDocumentDecorator;

{ TIncomingInternalDocument }

function TIncomingInternalDocument.GetIdentity: Variant;
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;
  
  Result := OriginalIncomingDocument.Identity;
  
end;

function TIncomingInternalDocument.GetIncomingNumber: String;
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;

  Result := OriginalIncomingDocument.IncomingNumber;

end;

function TIncomingInternalDocument.GetIsIncomingNumberAssigned: Boolean;
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;

  Result := OriginalIncomingDocument.IsIncomingNumberAssigned;
  
end;

class function TIncomingInternalDocument.ListType: TDocumentsClass;
begin

  Result := TIncomingInternalDocuments;
  
end;

function TIncomingInternalDocument.GetOriginalIncomingDocument:
  TIncomingDocument;
begin

  Result := TIncomingDocument(OriginalDocument);

end;

function TIncomingInternalDocument.GetReceiptDate: Variant;
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;

  Result := OriginalIncomingDocument.ReceiptDate;

end;

procedure TIncomingInternalDocument.SetIdentity(Identity: Variant);
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;

  OriginalIncomingDocument.Identity := Identity;

end;

procedure TIncomingInternalDocument.SetIncomingNumber(const Value: String);
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;

  OriginalIncomingDocument.IncomingNumber := Value;

end;

procedure TIncomingInternalDocument.SetOriginalDocument(const Value: TDocument);
begin

  if not Value.InheritsFrom(TIncomingDocument) then begin

    raise TIncomingDocumentException.CreateFmt(
      'Программная ошибка. Документ типа "%s" ' +
      'не является входящим документа для ' +
      'ссылки из входящего внутреннего документа',
      [
        Value.ClassName
      ]
    );
    
  end;

  inherited;

end;

procedure TIncomingInternalDocument.SetOriginalIncomingDocument(
  const Value: TIncomingDocument
);
begin

  SetOriginalDocument(Value);
  
end;

procedure TIncomingInternalDocument.SetReceiptDate(const Value: Variant);
begin

  RaiseExceptionIfOriginalDocumentNotAssigned;

  OriginalIncomingDocument.ReceiptDate := Value;

end;

{ TIncomingInternalDocumentsEnumerator }

constructor TIncomingInternalDocumentsEnumerator.Create(
  IncomingInternalDocuments: TIncomingInternalDocuments
);
begin

  inherited Create(IncomingInternalDocuments);

end;

function TIncomingInternalDocumentsEnumerator.
  GetCurrentIncomingInternalDocument: TIncomingInternalDocument;
begin

  Result := TIncomingInternalDocument(GetCurrentIncomingDocument);
  
end;

{ TIncomingInternalDocuments }

function TIncomingInternalDocuments.GetEnumerator: TIncomingInternalDocumentsEnumerator;
begin

  Result := TIncomingInternalDocumentsEnumerator.Create(Self);
  
end;

end.
