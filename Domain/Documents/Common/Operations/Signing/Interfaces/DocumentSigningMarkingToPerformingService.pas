unit DocumentSigningMarkingToPerformingService;

interface

uses

  DocumentPerformingEventHandlers,
  IDocumentUnit,
  Employee,
  SysUtils;

type

  IDocumentSigningMarkingToPerformingService = interface
    ['{201F1596-3DF6-462A-8CAA-593F6545478C}']

    function GetOnDocumentSentToPerformingEventHandler: TOnDocumentSentToPerformingEventHandler;
    procedure SetOnDocumentSentToPerformingEventHandler(const Value: TOnDocumentSentToPerformingEventHandler);

    procedure MarkDocumentAsSigned(
      Document: IDocument;
      Employee: TEmployee;
      const SigningDateTime: TDateTime
    );

    property OnDocumentSentToPerformingEventHandler: TOnDocumentSentToPerformingEventHandler
    read GetOnDocumentSentToPerformingEventHandler
    write SetOnDocumentSentToPerformingEventHandler;

  end;

implementation

end.
