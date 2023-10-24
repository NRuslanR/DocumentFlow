unit DocumentSigningToPerformingService;

interface

uses

  DocumentSigningService,
  DocumentPerformingEventHandlers,
  SendingDocumentToPerformingService,
  SysUtils;

type
    
  IDocumentSigningToPerformingService = interface (IDocumentSigningService)

    function GetOnDocumentSentToPerformingEventHandler: TOnDocumentSentToPerformingEventHandler;
    procedure SetOnDocumentSentToPerformingEventHandler(const Value: TOnDocumentSentToPerformingEventHandler);

    property OnDocumentSentToPerformingEventHandler: TOnDocumentSentToPerformingEventHandler
    read GetOnDocumentSentToPerformingEventHandler
    write SetOnDocumentSentToPerformingEventHandler;
    
  end;

implementation

end.
