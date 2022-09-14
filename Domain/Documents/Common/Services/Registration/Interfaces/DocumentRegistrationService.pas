unit DocumentRegistrationService;

interface

uses

  DomainException,
  Document,
  DepartmentUnit,
  SysUtils;

type

  TDocumentRegistrationServiceException = class (TDomainException)

  end;

  TDocumentAlreadyRegisteredException = class (TDocumentRegistrationServiceException)

    public

      constructor Create(
        Document: TDocument;
        const DocumentNumber: String;
        const DocumentDate: Variant
      );

  end;

  IDocumentRegistrationService = interface

    procedure RegisterDocument(Document: TDocument);
    procedure RegisterDocumentIfNecessary(Document: TDocument);

    function IsDocumentRegistered(Document: TDocument): Boolean;
    
  end;
  
implementation

uses

  Variants;

{ TDocumentAlreadyRegisteredException }

constructor TDocumentAlreadyRegisteredException.Create(
  Document: TDocument;
  const DocumentNumber: String;
  const DocumentDate: Variant
);
begin

  inherited
    CreateFmt(
      'Документ "%s" уже зарегистрирован.' + sLineBreak +
      'Номер - %s, Дата - %s',
      [
        Document.Name,
        DocumentNumber,
        VarToStr(DocumentDate)
      ]
    );

end;

end.
