unit StandardDocumentSigningService;

interface

uses

  DocumentSigningService,
  DocumentRegistrationService,
  Document,
  Employee,
  SysUtils;

type

  TStandardDocumentSigningService =
    class (TInterfacedObject, IDocumentSigningService)

      protected

        FDocumentRegistrationService: IDocumentRegistrationService;

      public

        constructor Create(DocumentRegistrationService: IDocumentRegistrationService);

        procedure SignDocument(Document: TDocument; Signer: TEmployee); virtual;

    end;
  
implementation

uses

  PersonnelOrder;

{ TStandardDocumentSigningService }

constructor TStandardDocumentSigningService.Create(
  DocumentRegistrationService: IDocumentRegistrationService);
begin

  inherited Create;

  FDocumentRegistrationService := DocumentRegistrationService;

end;

procedure TStandardDocumentSigningService.SignDocument(Document: TDocument;
  Signer: TEmployee);
begin

  Document.EditingEmployee := Signer;
  
  FDocumentRegistrationService.RegisterDocumentIfNecessary(Document);

  Document.SignBy(Signer);

end;

end.
