unit SendingDocumentToPerformingService;

interface

uses

  DomainException,
  Document,
  IDomainObjectBaseUnit,
  DomainObjectValueUnit,
  DocumentToPerformingSendingResult,
  DocumentPerformingEventHandlers,
  CreatingNecessaryDataForDocumentPerformingService,
  Employee,
  SysUtils,
  Classes;

type

  TSendingDocumentToPerformingServiceException = class (TDomainException)

  end;
    
  ISendingDocumentToPerformingService = interface
    ['{C9C23BEA-E384-4865-BBC8-5CEB61782A16}']

    function GetOnDocumentSentToPerformingEventHandler: TOnDocumentSentToPerformingEventHandler;
    procedure SetOnDocumentSentToPerformingEventHandler(Value: TOnDocumentSentToPerformingEventHandler);
    
    function SendDocumentToPerforming(
      Document: TDocument;
      SendingEmployee: TEmployee
    ): TDocumentToPerformingSendingResult;

    property OnDocumentSentToPerformingEventHandler:
      TOnDocumentSentToPerformingEventHandler
    read GetOnDocumentSentToPerformingEventHandler
    write SetOnDocumentSentToPerformingEventHandler;

  end;

implementation

end.
