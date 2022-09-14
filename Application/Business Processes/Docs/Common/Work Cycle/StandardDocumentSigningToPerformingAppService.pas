unit StandardDocumentSigningToPerformingAppService;

interface

uses

  DocumentSigningToPerformingAppService,
  EmployeeDocumentOperationService,
  DocumentChargeSheetCasesNotifier,
  DocumentSigningToPerformingService,
  SendingDocumentToPerformingService,
  DocumentSigningAppService,
  Session,
  DocumentToPerformingSendingResult,
  DocumentPerformingEventHandlers,
  DocumentDirectory,
  IDomainObjectBaseUnit,
  IEmployeeRepositoryUnit,
  Document,
  Employee,
  SysUtils;

type

  TStandardDocumentSigningToPerformingAppService =
    class (
      TEmployeeDocumentOperationService,
      IDocumentSigningToPerformingAppService,
      IDocumentSigningAppService
    )

      protected

        FDocumentSigningToPerformingService: IDocumentSigningToPerformingService;
        FDocumentChargeSheetCasesNotifier: IDocumentChargeSheetCasesNotifier;

      protected

        FDocumentToPerformingSendingResult: TDocumentToPerformingSendingResult;
        FFreeDocumentToPerformingSendingResult: IDomainObjectBase;

      protected

        procedure MakeEmployeeDocumentDomainOperation(
          DomainObjects: TEmployeeDocumentOperationDomainObjects;
          var EmployeeDocumentOperationResult: TEmployeeDocumentOperationResult
        ); override;

        procedure DoAfterDocumentOperationAsBusinessTransaction(
          Command: TEmployeeDocumentOperationServiceCommand
        ); override;

      protected

        procedure OnDocumentSentToPerformingEventHandler(
          Sender: TObject;
          DocumentToPerformingSendingResult: TDocumentToPerformingSendingResult
        );

        procedure OnDocumentChargeSheetNotificationSentEventHandler(
          Sender: TObject;
          DocumentChargeSheetNotificationCase: TDocumentChargeSheetsNotificationCase
        );

        procedure OnDocumentChargeSheetNotificationSendingFailedEventHandler(
          Sender: TObject;
          const Error: Exception;
          DocumentChargeSheetNotificationCase: TDocumentChargeSheetsNotificationCase
        );

      protected

        procedure SendMessagesToPerformersAboutCreatedNecessaryDataForDocumentPerforming;
        
      public

        constructor Create(
          Session: ISession;
          DocumentDirectory: IDocumentDirectory;
          EmployeeRepository: IEmployeeRepository;
          DocumentSigningToPerformingService: IDocumentSigningToPerformingService;
          DocumentChargeSheetCasesNotifier: IDocumentChargeSheetCasesNotifier
        );

        procedure SignDocument(const DocumentId: Variant; const SignerId: Variant);
        
    end;
  
implementation

uses BusinessProcessService;

{ TStandardDocumentSigningToPerformingAppService }

constructor TStandardDocumentSigningToPerformingAppService.Create(
  Session: ISession;
  DocumentDirectory: IDocumentDirectory;
  EmployeeRepository: IEmployeeRepository;
  DocumentSigningToPerformingService: IDocumentSigningToPerformingService;
  DocumentChargeSheetCasesNotifier: IDocumentChargeSheetCasesNotifier
);
begin

  inherited Create(
    Session,
    DocumentDirectory,
    EmployeeRepository
  );

  FDocumentSigningToPerformingService := DocumentSigningToPerformingService;
  FDocumentChargeSheetCasesNotifier := DocumentChargeSheetCasesNotifier;

  FDocumentSigningToPerformingService
    .OnDocumentSentToPerformingEventHandler := OnDocumentSentToPerformingEventHandler;
    
end;

procedure TStandardDocumentSigningToPerformingAppService.DoAfterDocumentOperationAsBusinessTransaction(
  Command: TEmployeeDocumentOperationServiceCommand);
begin

  { refactor: см. StandardDocumentSigningMarkingToPerformingAppService }
  
  if not Assigned(FDocumentToPerformingSendingResult) then Exit;
  
  try
  
    SendMessagesToPerformersAboutCreatedNecessaryDataForDocumentPerforming;

  finally

    FDocumentToPerformingSendingResult := nil;
    FFreeDocumentToPerformingSendingResult := nil;

  end;

end;

procedure TStandardDocumentSigningToPerformingAppService.
  MakeEmployeeDocumentDomainOperation(
    DomainObjects: TEmployeeDocumentOperationDomainObjects;
    var EmployeeDocumentOperationResult: TEmployeeDocumentOperationResult
  );
begin

  FDocumentSigningToPerformingService.SignDocument(
    TDocument(DomainObjects.Document.Self), DomainObjects.Employee
  );
  
end;

procedure TStandardDocumentSigningToPerformingAppService.OnDocumentChargeSheetNotificationSendingFailedEventHandler(
  Sender: TObject; const Error: Exception;
  DocumentChargeSheetNotificationCase: TDocumentChargeSheetsNotificationCase);
begin

  RaiseFailedBusinessProcessServiceException(Error.Message);
  
end;

procedure TStandardDocumentSigningToPerformingAppService.OnDocumentChargeSheetNotificationSentEventHandler(
  Sender: TObject;
  DocumentChargeSheetNotificationCase: TDocumentChargeSheetsNotificationCase);
begin

end;

procedure TStandardDocumentSigningToPerformingAppService.OnDocumentSentToPerformingEventHandler(
  Sender: TObject;
  DocumentToPerformingSendingResult: TDocumentToPerformingSendingResult
);
begin

  FDocumentToPerformingSendingResult := DocumentToPerformingSendingResult;
  FFreeDocumentToPerformingSendingResult := FDocumentToPerformingSendingResult;

end;

procedure TStandardDocumentSigningToPerformingAppService.
  SendMessagesToPerformersAboutCreatedNecessaryDataForDocumentPerforming;
begin

  FDocumentChargeSheetCasesNotifier.SendNotificationAboutDocumentChargeSheetsAsync(
    FDocumentToPerformingSendingResult.SentNecessaryDataForDocumentPerforming.DocumentChargeSheets,
    FDocumentToPerformingSendingResult.Sender,
    NewDocumentChargeSheetsCreatedCase,
    OnDocumentChargeSheetNotificationSentEventHandler,
    OnDocumentChargeSheetNotificationSendingFailedEventHandler
  );
  
end;

procedure TStandardDocumentSigningToPerformingAppService.SignDocument(
  const DocumentId, SignerId: Variant);
begin

  MakeEmployeeDocumentOperationAsBusinessTransaction(DocumentId, SignerId);

end;

end.
