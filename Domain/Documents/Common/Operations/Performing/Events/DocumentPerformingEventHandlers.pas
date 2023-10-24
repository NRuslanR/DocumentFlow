unit DocumentPerformingEventHandlers;

interface

uses

  DocumentToPerformingSendingResult,
  SysUtils;

type

  TOnDocumentSentToPerformingEventHandler =
    procedure (
      Sender: TObject;
      DocumentToPerformingSendingResult: TDocumentToPerformingSendingResult
    ) of object;
    
implementation

end.
