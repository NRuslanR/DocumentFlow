unit StandardDocumentApprovingRejectingService;

interface

uses

  Document,
  Employee,
  EmployeeDocumentOperationService,
  DocumentApprovingRejectingService,
  Session,
  DocumentDirectory,
  IEmployeeRepositoryUnit,
  DocumentApprovingProcessControlService,
  DocumentApprovingCycleResult,
  DocumentApprovingCycleResultRepository,
  DocumentApprovingPerformingService,
  StandardDocumentApprovingPerformingService,
  SysUtils,
  Classes;

type

  TStandardDocumentApprovingRejectingService =
    class (
      TStandardDocumentApprovingPerformingService,
      IDocumentApprovingRejectingService
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

        procedure RejectApprovingDocument(
          const DocumentId: Variant;
          const RejectingApprovingEmployeeId: Variant
        );

    end;
  
implementation

{ TStandardDocumentApprovingRejectingService }

constructor TStandardDocumentApprovingRejectingService.Create(
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

procedure TStandardDocumentApprovingRejectingService.RejectApprovingDocument(
  const DocumentId, RejectingApprovingEmployeeId: Variant);
begin

  PerformApprovingDocument(
    DocumentId,
    RejectingApprovingEmployeeId,
    pkNotApproving
  );
  
end;

end.
