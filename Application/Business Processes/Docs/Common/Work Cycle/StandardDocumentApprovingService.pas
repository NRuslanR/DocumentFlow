unit StandardDocumentApprovingService;

interface

uses

  DocumentApprovingService,
  EmployeeDocumentOperationService,
  Session,
  DocumentDirectory,
  IEmployeeRepositoryUnit,
  Document,
  Employee,
  DocumentApprovingPerformingService,
  DocumentApprovingProcessControlService,
  DocumentApprovingCycleResult,
  DocumentApprovingCycleResultRepository,
  StandardDocumentApprovingPerformingService,
  SysUtils,
  Classes;

type

    
  TStandardDocumentApprovingService =
    class (
      TStandardDocumentApprovingPerformingService,
      IDocumentApprovingService
    )

      public

        constructor Create(
          Session: ISession;
          DocumentDirectory: IDocumentDirectory;
          EmployeeRepository: IEmployeeRepository;

          DocumentApprovingProcessControlService:
            IDocumentApprovingProcessControlService;

          DocumentApprovingCycleResultRepository:
            IDocumentApprovingCycleResultRepository
        );

        procedure ApproveDocument(
          const DocumentId: Variant;
          const ApproverId: Variant
        );

    end;


implementation

{ TStandardDocumentApprovingService }

procedure TStandardDocumentApprovingService.ApproveDocument(const DocumentId,
  ApproverId: Variant);
begin

  PerformApprovingDocument(
    DocumentId,
    ApproverId,
    pkApporving
  );
  
end;

constructor TStandardDocumentApprovingService.Create(
  Session: ISession;
  DocumentDirectory: IDocumentDirectory;
  EmployeeRepository: IEmployeeRepository;

  DocumentApprovingProcessControlService:
    IDocumentApprovingProcessControlService;

  DocumentApprovingCycleResultRepository:
    IDocumentApprovingCycleResultRepository
);
begin

  inherited Create(
    Session,
    DocumentDirectory,
    EmployeeRepository,
    DocumentApprovingProcessControlService,
    DocumentApprovingCycleResultRepository
  );
  
end;

end.
