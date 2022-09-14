unit StandardDocumentSigningMarkingToPerformingAppService;

interface

uses

  StandardDocumentSigningMarkingAppService,
  DocumentSigningMarkingToPerformingService,
  DocumentChargeSheetCasesNotifier,
  DocumentPerformingEventHandlers,
  DocumentToPerformingSendingResult,
  Document,
  Employee,
  Session,
  DocumentDirectory,
  IEmployeeRepositoryUnit,
  EmployeeDocumentOperationService,
  IDomainObjectBaseUnit,
  DocumentSigningMarkingAppService,
  SysUtils,
  Classes;

type

  TStandardDocumentSigningMarkingToPerformingAppService =
    class (TStandardDocumentSigningMarkingAppService)

      protected

        FDocumentSigningMarkingToPerformingService: IDocumentSigningMarkingToPerformingService;
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

      public

        constructor Create(
          Session: ISession;
          DocumentDirectory: IDocumentDirectory;
          EmployeeRepository: IEmployeeRepository;
          DocumentSigningMarkingToPerformingService: IDocumentSigningMarkingToPerformingService;
          DocumentChargeSheetCasesNotifier: IDocumentChargeSheetCasesNotifier
        );

    end;

implementation

uses BusinessProcessService;

{ TStandardDocumentSigningMarkingToPerformingAppService }

constructor TStandardDocumentSigningMarkingToPerformingAppService.Create(
  Session: ISession; DocumentDirectory: IDocumentDirectory;
  EmployeeRepository: IEmployeeRepository;
  DocumentSigningMarkingToPerformingService: IDocumentSigningMarkingToPerformingService;
  DocumentChargeSheetCasesNotifier: IDocumentChargeSheetCasesNotifier
);
begin

  inherited Create(
    Session,
    DocumentDirectory,
    EmployeeRepository
  );

  FDocumentSigningMarkingToPerformingService := DocumentSigningMarkingToPerformingService;
  FDocumentChargeSheetCasesNotifier := DocumentChargeSheetCasesNotifier;

  FDocumentSigningMarkingToPerformingService.OnDocumentSentToPerformingEventHandler :=
    OnDocumentSentToPerformingEventHandler;

end;

procedure TStandardDocumentSigningMarkingToPerformingAppService.MakeEmployeeDocumentDomainOperation(
  DomainObjects: TEmployeeDocumentOperationDomainObjects;
  var EmployeeDocumentOperationResult: TEmployeeDocumentOperationResult
);
begin

  with TDocumentSigningMarkingDomainObjects(DomainObjects) do begin

    FDocumentSigningMarkingToPerformingService.MarkDocumentAsSigned(
      Document, Employee, SigningDateTime
    );
    
  end;

end;

procedure TStandardDocumentSigningMarkingToPerformingAppService.OnDocumentSentToPerformingEventHandler(
  Sender: TObject;
  DocumentToPerformingSendingResult: TDocumentToPerformingSendingResult
);
begin

  FDocumentToPerformingSendingResult := DocumentToPerformingSendingResult;
  FFreeDocumentToPerformingSendingResult := FDocumentToPerformingSendingResult;

end;

procedure TStandardDocumentSigningMarkingToPerformingAppService.DoAfterDocumentOperationAsBusinessTransaction(
  Command: TEmployeeDocumentOperationServiceCommand);
begin

  if not Assigned(FDocumentToPerformingSendingResult) then Exit;
  
  try

    FDocumentChargeSheetCasesNotifier.SendNotificationAboutDocumentChargeSheetsAsync(
      FDocumentToPerformingSendingResult.SentNecessaryDataForDocumentPerforming.DocumentChargeSheets,
      FDocumentToPerformingSendingResult.Sender,
      NewDocumentChargeSheetsCreatedCase,
      OnDocumentChargeSheetNotificationSentEventHandler,
      OnDocumentChargeSheetNotificationSendingFailedEventHandler
    );

  finally

    FDocumentToPerformingSendingResult := nil;
    FFreeDocumentToPerformingSendingResult := nil;
    
  end;

end;

procedure TStandardDocumentSigningMarkingToPerformingAppService.
  OnDocumentChargeSheetNotificationSendingFailedEventHandler(
    Sender: TObject;
    const Error: Exception;
    DocumentChargeSheetNotificationCase: TDocumentChargeSheetsNotificationCase
  );
begin

  RaiseFailedBusinessProcessServiceException(Error.Message);

end;

procedure TStandardDocumentSigningMarkingToPerformingAppService.OnDocumentChargeSheetNotificationSentEventHandler(
  Sender: TObject;
  DocumentChargeSheetNotificationCase: TDocumentChargeSheetsNotificationCase
);
begin

end;

end.
