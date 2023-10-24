unit SuccessedDocumentPersistingValidator;

interface

uses

  DocumentPersistingValidator,
  IDocumentUnit,
  Document,
  SysUtils,
  Classes;

type

  TSuccessedDocumentPersistingValidator =
    class (TAbstractDocumentPersistingValidator)

      public

        procedure EnsureDocumentMayBePuttedInDirectory(Document: TDocument); override;
        procedure EnsureDocumentMayBeModifiedInDirectory(Document: TDocument); override;

        procedure EnsureDocumentsMayBePuttedInDirectory(Documents: TDocuments); override;
        procedure EnsureDocumentsMayBeModifiedInDirectory(Documents: TDocuments); override;

    end;

implementation

{ TSuccessedDocumentPersistingValidator }

procedure TSuccessedDocumentPersistingValidator.EnsureDocumentMayBeModifiedInDirectory(
  Document: TDocument);
begin

end;

procedure TSuccessedDocumentPersistingValidator.EnsureDocumentMayBePuttedInDirectory(
  Document: TDocument);
begin

end;

procedure TSuccessedDocumentPersistingValidator.EnsureDocumentsMayBeModifiedInDirectory(
  Documents: TDocuments);
begin

end;

procedure TSuccessedDocumentPersistingValidator.EnsureDocumentsMayBePuttedInDirectory(
  Documents: TDocuments);
begin

end;

end.
