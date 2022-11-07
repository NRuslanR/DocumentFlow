unit StandardDocumentSigningAppService;

interface

uses

  Document,
  Employee,
  Department,
  IEmployeeRepositoryUnit,
  DocumentOperationService,
  ApplicationService,
  Session,
  DocumentDirectory,
  EmployeeDocumentOperationService,
  SendingDocumentToPerformingAppService,
  CreatingNecessaryDataForDocumentPerformingService,
  DocumentSigningAppService,
  DocumentChargeSheetNotifyingMessageBuilder,
  MessagingServiceUnit,
  DocumentFilesRepository,
  IDocumentResponsibleRepositoryUnit,
  DocumentSigningService,
  DocumentChargeSheetCasesNotifier,
  DocumentRegistrationService,
  DepartmentRepository,
  IDomainObjectBaseUnit,
  SysUtils;

type

  TDocumentSigningAppService =
    class (TEmployeeDocumentOperationService, IDocumentSigningAppService)

      protected

        FDocumentSigningService: IDocumentSigningService;

      protected

        procedure MakeEmployeeDocumentDomainOperation(
          DomainObjects: TEmployeeDocumentOperationDomainObjects;
          var EmployeeDocumentOperationResult: TEmployeeDocumentOperationResult
        ); override;

      public

        constructor Create(
          Session: ISession;
          DocumentDirectory: IDocumentDirectory;
          EmployeeRepository: IEmployeeRepository;
          DocumentSigningService: IDocumentSigningService
        );

        procedure SignDocument(
          const DocumentId: Variant;
          const SignerId: Variant
        );

    end;

implementation

uses

  IDomainObjectUnit,
  DocumentChargeSheet,
  IDomainObjectListUnit,
  DocumentFileUnit,
  AuxDebugFunctionsUnit,
  BusinessProcessService;

{ TDocumentSigningAppService }

constructor TDocumentSigningAppService.Create(
  Session: ISession;
  DocumentDirectory: IDocumentDirectory;
  EmployeeRepository: IEmployeeRepository;
  DocumentSigningService: IDocumentSigningService
);
begin

  inherited Create(
    Session,
    DocumentDirectory,
    EmployeeRepository
  );

  FDocumentSigningService := DocumentSigningService;
    
end;

procedure TDocumentSigningAppService.MakeEmployeeDocumentDomainOperation(
  DomainObjects: TEmployeeDocumentOperationDomainObjects;
  var EmployeeDocumentOperationResult: TEmployeeDocumentOperationResult
);
var Document: TDocument;
    Signer: TEmployee;
begin

  FDocumentSigningService.SignDocument(
    TDocument(DomainObjects.Document.Self), DomainObjects.Employee
  );

end;

procedure TDocumentSigningAppService.SignDocument(
  const DocumentId, SignerId: Variant
);
begin

  MakeEmployeeDocumentOperationAsBusinessTransaction(DocumentId, SignerId);

end;

end.
