unit StandardDocumentSigningToPerformingService;

interface

uses

  StandardDocumentSigningService,
  DocumentSigningService,
  SendingDocumentToPerformingService,
  DocumentSigningToPerformingService,
  DocumentPerformingEventHandlers,
  DocumentToPerformingSendingResult,
  DocumentRegistrationService,
  Document,
  Employee,
  SysUtils;

type
    
  TStandardDocumentSigningToPerformingService =
    class (
      TStandardDocumentSigningService,
      IDocumentSigningToPerformingService,
      IDocumentSigningService
    )

      protected

        FSendingDocumentToPerformingService: ISendingDocumentToPerformingService;

      public

        constructor Create(
          DocumentRegistrationService: IDocumentRegistrationService;
          SendingDocumentToPerformingService: ISendingDocumentToPerformingService
        );

        procedure SignDocument(Document: TDocument; Signer: TEmployee); override;

      public

        function GetOnDocumentSentToPerformingEventHandler: TOnDocumentSentToPerformingEventHandler;
        procedure SetOnDocumentSentToPerformingEventHandler(const Value: TOnDocumentSentToPerformingEventHandler);

        property OnDocumentSentToPerformingEventHandler: TOnDocumentSentToPerformingEventHandler
        read GetOnDocumentSentToPerformingEventHandler
        write SetOnDocumentSentToPerformingEventHandler;
        
    end;

implementation

uses

  IDomainObjectBaseUnit;

{ TStandardDocumentSigningToPerformingService }

constructor TStandardDocumentSigningToPerformingService.Create(
  DocumentRegistrationService: IDocumentRegistrationService;
  SendingDocumentToPerformingService: ISendingDocumentToPerformingService
);
begin

  inherited Create(DocumentRegistrationService);

  FSendingDocumentToPerformingService := SendingDocumentToPerformingService;
  
end;

function TStandardDocumentSigningToPerformingService.
  GetOnDocumentSentToPerformingEventHandler: TOnDocumentSentToPerformingEventHandler;
begin

  Result :=
    FSendingDocumentToPerformingService.OnDocumentSentToPerformingEventHandler;

end;

procedure TStandardDocumentSigningToPerformingService.SetOnDocumentSentToPerformingEventHandler(
  const Value: TOnDocumentSentToPerformingEventHandler);
begin

  FSendingDocumentToPerformingService.OnDocumentSentToPerformingEventHandler := Value;

end;

{
  refactor: реализация по большей части дублирует реализацию
  StandardDocumentSigningMarkingToPerformingService
}
procedure TStandardDocumentSigningToPerformingService.SignDocument(
  Document: TDocument;
  Signer: TEmployee
);
var
    DocumentToPerformingSendingResult : TDocumentToPerformingSendingResult;
    Free: IDomainObjectBase;
begin

  inherited SignDocument(Document, Signer);

  if
    Document.Charges.IsEmpty
    and not Document.WorkingRules.DraftingRule.Options.ChargesAssigningRequired

  then Exit;

  DocumentToPerformingSendingResult :=
    FSendingDocumentToPerformingService.SendDocumentToPerforming(Document, Signer);

  Free := DocumentToPerformingSendingResult;
  
end;

end.
