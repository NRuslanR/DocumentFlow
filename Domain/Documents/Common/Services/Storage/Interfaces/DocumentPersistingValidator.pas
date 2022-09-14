unit DocumentPersistingValidator;

interface

uses

  DomainException,
  IDocumentUnit,
  IGetSelfUnit,
  Document,
  SysUtils,
  Classes;

type

  TDocumentPersistingValidatonException = class (TDomainException)

  end;
  
  IDocumentPersistingValidator = interface (IGetSelf)

    procedure EnsureDocumentMayBePuttedInDirectory(Document: TDocument);
    procedure EnsureDocumentMayBeModifiedInDirectory(Document: TDocument);

    procedure EnsureDocumentsMayBePuttedInDirectory(Documents: TDocuments);
    procedure EnsureDocumentsMayBeModifiedInDirectory(Documents: TDocuments);

  end;

  TAbstractDocumentPersistingValidator =
    class (TInterfacedObject, IDocumentPersistingValidator)

      public

        function GetSelf: TObject;

        procedure EnsureDocumentMayBePuttedInDirectory(Document: TDocument); virtual; abstract;
        procedure EnsureDocumentMayBeModifiedInDirectory(Document: TDocument); virtual; abstract;

        procedure EnsureDocumentsMayBePuttedInDirectory(Documents: TDocuments); virtual; abstract;
        procedure EnsureDocumentsMayBeModifiedInDirectory(Documents: TDocuments); virtual; abstract;

    end;

implementation

{ TAbstractDocumentPersistingValidator }

function TAbstractDocumentPersistingValidator.GetSelf: TObject;
begin

  Result := Self;
  
end;

end.
