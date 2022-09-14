unit StandardSendingDocumentToPerformingAppService;

interface

uses

  SendingDocumentToPerformingService,
  SendingDocumentToPerformingAppService,
  EmployeeDocumentOperationService,
  DocumentRegistrationService,
  DocumentChargeSheetControlService,
  DocumentDirectory,
  IEmployeeRepositoryUnit,
  DocumentChargeSheetCasesNotifier,
  IncomingDocument,
  IncomingDocumentDirectory,
  DocumentToPerformingSendingResult,
  DocumentPerformingEventHandlers,
  DocumentCharges,
  IDomainObjectBaseUnit,
  DocumentChargeSheet,
  Session,
  Document,
  Employee,
  SysUtils,
  Classes;

type

  TStandardSendingDocumentToPerformingAppService =
    class (TEmployeeDocumentOperationService, ISendingDocumentToPerformingAppService)

      protected

        FSendingDocumentToPerformingService: ISendingDocumentToPerformingService;
        FDocumentChargeSheetCasesNotifier: IDocumentChargeSheetCasesNotifier;

      protected

        FDocumentToPerformingSendingResult: TDocumentToPerformingSendingResult;
        FFreeDocumentToPerformingSendingResult: IDomainObjectBase;

        FDocumentChargeSheetNotifyingMessagesSender: TEmployee;
        FFreeDocumentChargeSheetNotifyingMessagesSender: IDomainObjectBase;
        
      protected

        procedure MakeEmployeeDocumentDomainOperation(
          DomainObjects: TEmployeeDocumentOperationDomainObjects;
          var EmployeeDocumentOperationResult: TEmployeeDocumentOperationResult
        ); override;

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
          SendingDocumentToPerformingService: ISendingDocumentToPerformingService;
          DocumentChargeSheetCasesNotifier: IDocumentChargeSheetCasesNotifier
        );

        procedure SendDocumentToPerforming(
          const DocumentId: Variant;
          const SendingEmployeeId: Variant
        ); overload;

    end;

implementation

uses

  DocumentOperationService,
  CreatingNecessaryDataForDocumentPerformingService, BusinessProcessService;
  
{ TStandardSendingDocumentToPerformingAppService }

constructor TStandardSendingDocumentToPerformingAppService.Create(
  Session: ISession;
  DocumentDirectory: IDocumentDirectory;
  EmployeeRepository: IEmployeeRepository;
  SendingDocumentToPerformingService: ISendingDocumentToPerformingService;
  DocumentChargeSheetCasesNotifier: IDocumentChargeSheetCasesNotifier
);
begin

  inherited Create(
    Session,
    DocumentDirectory,
    EmployeeRepository
  );

  FSendingDocumentToPerformingService := SendingDocumentToPerformingService;
  FDocumentChargeSheetCasesNotifier := DocumentChargeSheetCasesNotifier;

end;

procedure TStandardSendingDocumentToPerformingAppService.SendDocumentToPerforming(
  const DocumentId, SendingEmployeeId: Variant
);
begin

  MakeEmployeeDocumentOperationAsBusinessTransaction(
    DocumentId, SendingEmployeeId
  );

  try

    try

      SendMessagesToPerformersAboutCreatedNecessaryDataForDocumentPerforming;

    except

      on E: Exception do begin

        RaiseFailedBusinessProcessServiceException(E.Message);
        
      end;

    end;

  finally

    FDocumentToPerformingSendingResult := nil;
    FFreeDocumentToPerformingSendingResult := nil;

    FDocumentChargeSheetNotifyingMessagesSender := nil;
    FFreeDocumentChargeSheetNotifyingMessagesSender := nil;
    
  end;

end;

procedure TStandardSendingDocumentToPerformingAppService.
  SendMessagesToPerformersAboutCreatedNecessaryDataForDocumentPerforming;
begin

  FDocumentChargeSheetCasesNotifier.SendNotificationAboutDocumentChargeSheetsAsync(
    FDocumentToPerformingSendingResult.SentNecessaryDataForDocumentPerforming.DocumentChargeSheets,
    FDocumentChargeSheetNotifyingMessagesSender,
    NewDocumentChargeSheetsCreatedCase,
    OnDocumentChargeSheetNotificationSentEventHandler,
    OnDocumentChargeSheetNotificationSendingFailedEventHandler
  );

end;

procedure TStandardSendingDocumentToPerformingAppService.
  MakeEmployeeDocumentDomainOperation(
    DomainObjects: TEmployeeDocumentOperationDomainObjects;
    var EmployeeDocumentOperationResult: TEmployeeDocumentOperationResult
  );
begin

  FDocumentToPerformingSendingResult :=
    FSendingDocumentToPerformingService.SendDocumentToPerforming(
      TDocument(DomainObjects.Document.Self), DomainObjects.Employee
    );

  FFreeDocumentChargeSheetNotifyingMessagesSender := FDocumentToPerformingSendingResult;

  FDocumentChargeSheetNotifyingMessagesSender := DomainObjects.Employee;

  FFreeDocumentChargeSheetNotifyingMessagesSender := DomainObjects.Employee;
  
end;


procedure TStandardSendingDocumentToPerformingAppService.
  OnDocumentChargeSheetNotificationSendingFailedEventHandler(
    Sender: TObject;
    const Error: Exception;
    DocumentChargeSheetNotificationCase: TDocumentChargeSheetsNotificationCase
  );
begin

  RaiseFailedBusinessProcessServiceException(Error.Message);

end;

procedure TStandardSendingDocumentToPerformingAppService.
  OnDocumentChargeSheetNotificationSentEventHandler(
    Sender: TObject;
    DocumentChargeSheetNotificationCase: TDocumentChargeSheetsNotificationCase
  );
begin

end;

end.
