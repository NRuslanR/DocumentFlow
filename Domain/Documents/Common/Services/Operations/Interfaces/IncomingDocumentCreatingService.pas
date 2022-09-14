unit IncomingDocumentCreatingService;

interface

uses

  Document,
  IncomingDocument,
  Employee,
  SysUtils;

type

  IIncomingDocumentCreatingService = interface

    function CreateIncomingDocumentInstanceFor(
      Document: TDocument;
      Receiver: TEmployee
    ): TIncomingDocument;

  end;


implementation

end.
