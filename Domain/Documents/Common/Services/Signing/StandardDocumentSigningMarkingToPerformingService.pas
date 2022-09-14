unit StandardDocumentSigningMarkingToPerformingService;

interface

uses

  DocumentSigningMarkingToPerformingService,
  DocumentPerformingEventHandlers,
  DocumentToPerformingSendingResult,
  SendingDocumentToPerformingService,
  Document,
  IDocumentUnit,
  Employee,
  SysUtils;

type

  TStandardDocumentSigningMarkingToPerformingService =
    class (TInterfacedObject, IDocumentSigningMarkingToPerformingService)

      protected

        FSendingDocumentToPerformingService: ISendingDocumentToPerformingService;

      public

        constructor Create(SendingDocumentToPerformingService: ISendingDocumentToPerformingService);
        
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

uses

  IDomainObjectBaseUnit;

{ TStandardDocumentSigningMarkingToPerformingService }

constructor TStandardDocumentSigningMarkingToPerformingService.Create(
  SendingDocumentToPerformingService: ISendingDocumentToPerformingService);
begin

  inherited Create;

  FSendingDocumentToPerformingService := SendingDocumentToPerformingService;
  
end;

function TStandardDocumentSigningMarkingToPerformingService.
  GetOnDocumentSentToPerformingEventHandler: TOnDocumentSentToPerformingEventHandler;
begin

  Result := FSendingDocumentToPerformingService.OnDocumentSentToPerformingEventHandler;

end;

procedure TStandardDocumentSigningMarkingToPerformingService.SetOnDocumentSentToPerformingEventHandler(
  const Value: TOnDocumentSentToPerformingEventHandler);
begin

  FSendingDocumentToPerformingService.OnDocumentSentToPerformingEventHandler := Value;

end;

procedure TStandardDocumentSigningMarkingToPerformingService.MarkDocumentAsSigned(
  Document: IDocument;
  Employee: TEmployee;
  const SigningDateTime: TDateTime
);
var
    DocumentToPerformingSendingResult: TDocumentToPerformingSendingResult;
    Free: IDomainObjectBase;
begin

  Document.EditingEmployee := Employee;

  Document.MarkAsSignedForAllSigners(Employee, SigningDateTime);

  if
    Document.Charges.IsEmpty
    and not TDocument(Document.Self).WorkingRules.DraftingRule.Options.ChargesAssigningRequired

  then Exit;

  DocumentToPerformingSendingResult :=
    FSendingDocumentToPerformingService
      .SendDocumentToPerforming(TDocument(Document.Self), Employee);

  Free := DocumentToPerformingSendingResult;

end;

end.
