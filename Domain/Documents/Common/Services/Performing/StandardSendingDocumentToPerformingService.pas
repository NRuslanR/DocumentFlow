unit StandardSendingDocumentToPerformingService;

interface

uses

  SendingDocumentToPerformingService,
  DocumentChargeSheetDirectory,
  DocumentToPerformingSendingResult,
  DocumentPerformingEventHandlers,
  CreatingNecessaryDataForDocumentPerformingService,
  Document,
  Employee,
  SysUtils;

type

   TStandardSendingDocumentToPerformingService =
    class (TInterfacedObject, ISendingDocumentToPerformingService)

      protected

        FCreatingNecessaryDataForDocumentPerformingService:
          ICreatingNecessaryDataForDocumentPerformingService;

        FDocumentChargeSheetDirectory: IDocumentChargeSheetDirectory;

        FOnDocumentSentToPerformingEventHandler: TOnDocumentSentToPerformingEventHandler;
        
        function SendNecessaryDataForDocumentPerforming(
          Document: TDocument;
          SendingEmployee: TEmployee
        ): TNecessaryDataForDocumentPerforming;

        procedure SaveNecessaryDataForDocumentPerforming(
          NecessaryDataForDocumentPerforming: TNecessaryDataForDocumentPerforming
        ); virtual;

        procedure RaiseOnDocumentSentToPerformingEvent(
          Result: TDocumentToPerformingSendingResult
        );

      public

        constructor Create(

          CreatingNecessaryDataForDocumentPerformingService:
            ICreatingNecessaryDataForDocumentPerformingService;

          DocumentChargeSheetDirectory: IDocumentChargeSheetDirectory
        );

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

uses

  IDomainObjectBaseUnit;

{ TStandardSendingDocumentToPerformingService }

constructor TStandardSendingDocumentToPerformingService.Create(

  CreatingNecessaryDataForDocumentPerformingService:
    ICreatingNecessaryDataForDocumentPerformingService;

  DocumentChargeSheetDirectory: IDocumentChargeSheetDirectory
);
begin

  inherited Create;

  FCreatingNecessaryDataForDocumentPerformingService :=
    CreatingNecessaryDataForDocumentPerformingService;

  FDocumentChargeSheetDirectory := DocumentChargeSheetDirectory;
  
end;

function TStandardSendingDocumentToPerformingService.SendDocumentToPerforming(
  Document: TDocument;
  SendingEmployee: TEmployee
): TDocumentToPerformingSendingResult;
var
    SentNecessaryDataForDocumentPerforming: TNecessaryDataForDocumentPerforming;
    Free: IDomainObjectBase;
begin

  if Document.IsPerforming then begin

    raise TSendingDocumentToPerformingServiceException.Create(
      'Документ уже был отправлен ранее на исполнение'
    );
    
  end;
  
  SentNecessaryDataForDocumentPerforming :=
    SendNecessaryDataForDocumentPerforming(Document, SendingEmployee);

  Document.ToPerformingBy(SendingEmployee);
  
  Free := SentNecessaryDataForDocumentPerforming;

  Result :=
    TDocumentToPerformingSendingResult.Create(
      SendingEmployee,
      SentNecessaryDataForDocumentPerforming
    );

  RaiseOnDocumentSentToPerformingEvent(Result);

end;

function TStandardSendingDocumentToPerformingService.SendNecessaryDataForDocumentPerforming(
  Document: TDocument;
  SendingEmployee: TEmployee
): TNecessaryDataForDocumentPerforming;
begin

  Result :=
    FCreatingNecessaryDataForDocumentPerformingService
      .CreateNecessaryDataForDocumentPerforming(Document, SendingEmployee);

  try

    SaveNecessaryDataForDocumentPerforming(Result);

  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;

end;

function TStandardSendingDocumentToPerformingService
  .GetOnDocumentSentToPerformingEventHandler: TOnDocumentSentToPerformingEventHandler;
begin

  Result := FOnDocumentSentToPerformingEventHandler;

end;

procedure TStandardSendingDocumentToPerformingService.RaiseOnDocumentSentToPerformingEvent(
  Result: TDocumentToPerformingSendingResult);
begin

  if Assigned(FOnDocumentSentToPerformingEventHandler) then
    FOnDocumentSentToPerformingEventHandler(Self, Result);
    
end;

procedure TStandardSendingDocumentToPerformingService
  .SetOnDocumentSentToPerformingEventHandler(Value: TOnDocumentSentToPerformingEventHandler);
begin

  FOnDocumentSentToPerformingEventHandler := Value;
  
end;

procedure TStandardSendingDocumentToPerformingService.
  SaveNecessaryDataForDocumentPerforming(
    NecessaryDataForDocumentPerforming: TNecessaryDataForDocumentPerforming
  );
begin

  FDocumentChargeSheetDirectory.PutDocumentChargeSheets(
    NecessaryDataForDocumentPerforming.DocumentChargeSheets
  );

end;

end.
