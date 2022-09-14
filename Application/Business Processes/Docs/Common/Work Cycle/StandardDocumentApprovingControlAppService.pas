{ refactor: пересмотреть
  способ реализации механизма
  согласований документов
}

{
  refactor:
  реализовать текущие методы связанные
  с согласованиями документов
  через вызовы метода MakeAs...BusinessTransaction
}
unit StandardDocumentApprovingControlAppService;

interface

uses

  Document,
  Employee,
  DocumentApprovingControlAppService,
  EmployeeDocumentOperationService,
  DocumentApprovingProcessControlService,
  DocumentApprovingCycleResultRepository,
  DocumentApprovingCycle,
  DocumentApprovingCycleDTO,
  DocumentApprovingCycleResult,
  SysUtils,
  Classes,
  IDocumentUnit,
  Session,
  DocumentDirectory,
  VariantListUnit,
  IEmployeeRepositoryUnit;

type

  TDocumentApprovingCompletingResult = class (TEmployeeDocumentOperationResult)

    protected

      FDocumentApprovingCycleResult: TDocumentApprovingCycleResult;

    public

      destructor Destroy; override;

      constructor Create(
        DocumentApprovingCycleResult: TDocumentApprovingCycleResult
      );

    published

      property DocumentApprovingCycleResult: TDocumentApprovingCycleResult
      read FDocumentApprovingCycleResult
      write FDocumentApprovingCycleResult;

  end;

  TStandardDocumentApprovingControlAppService =
    class (
           TEmployeeDocumentOperationService,
           IDocumentApprovingControlAppService
          )

      protected

        FDocumentApprovingProcessControlService:
          IDocumentApprovingProcessControlService;

        FDocumentApprovingCycleResultRepository:
          IDocumentApprovingCycleResultRepository;

      protected

      protected

        procedure MakeEmployeeDocumentDomainOperation(
          DomainObjects: TEmployeeDocumentOperationDomainObjects;
          var EmployeeDocumentOperationResult: TEmployeeDocumentOperationResult
        ); override;

        procedure SaveEmployeeDocumentDomainOperationResult(
          DomainOperationResult: TEmployeeDocumentOperationResult
        ); override;

        procedure MakeOperationOfEnsuringThatEmployeeMayCreateNewDocumentApprovingCycle(
          DomainObjects: TEmployeeDocumentOperationDomainObjects;
          var EmployeeDocumentOperationResult: TEmployeeDocumentOperationResult
        ); virtual;

      protected

        function MapDocumentApprovingCycleDTOFrom(
          DocumentApprovingCycle: TDocumentApprovingCycle
        ): TDocumentApprovingCycleDTO;
        
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

        function GetInfoForNewDocumentApprovingCycle(
          const DocumentId: Variant;
          const EmployeeId: Variant
        ): TDocumentApprovingCycleDTO;
        
        procedure CompleteDocumentApproving(
          const DocumentId: Variant;
          const CompletingApprovingEmployeeId: Variant
        );

        procedure EnsureThatEmployeeMayCreateNewDocumentApprovingCycle(
          const DocumentId: Variant;
          const EmployeeId: Variant
        );

        procedure EnsureThatEmployeeMayChangeDocumentApproverList(
          const EmployeeId: Variant;
          const Documentid: Variant
        );
        
        procedure EnsureThatEmployeeMayChangeDocumentApproverInfo(
          const EmployeeId: Variant;
          const DocumentId: Variant;
          const ApproverId: Variant
        );

        procedure EnsureThatEmployeeMayAssignDocumentApprover(
          const EmployeeId: Variant;
          const DocumentId: Variant;
          const ApproverId: Variant
        );

        procedure EnsureThatEmployeeMayRemoveDocumentApprover(
          const EmployeeId: Variant;
          const DocumentId: Variant;
          const ApproverId: Variant
        );

        function MayEmployeeChangeDocumentApproverList(
          const EmployeeId: Variant;
          const DocumentId: Variant
        ): Boolean;
        
        function MayEmployeeChangeDocumentApproverInfo(
          const EmployeeId: Variant;
          const DocumentId: Variant;
          const ApproverId: Variant
        ): Boolean;

        function MayEmployeeAssignDocumentApprover(
          const EmployeeId: Variant;
          const DocumentId: Variant;
          const ApproverId: Variant
        ): Boolean;

        function MayEmployeeRemoveDocumentApprover(
          const EmployeeId: Variant;
          const DocumentId: Variant;
          const ApproverId: Variant
        ): Boolean;
        
    end;

implementation

uses

  BusinessProcessService,
  IDomainObjectUnit,
  DocumentOperationService, AbstractApplicationService;

{ TDocumentApprovingCompletingResult }

constructor TDocumentApprovingCompletingResult.Create(
  DocumentApprovingCycleResult: TDocumentApprovingCycleResult);
begin

  inherited Create;

  FDocumentApprovingCycleResult := DocumentApprovingCycleResult;
  
end;

destructor TDocumentApprovingCompletingResult.Destroy;
begin

  FreeAndNil(FDocumentApprovingCycleResult);
  inherited;

end;

{ TStandardDocumentApprovingControlAppService }

procedure TStandardDocumentApprovingControlAppService.
  EnsureThatEmployeeMayAssignDocumentApprover(
    const EmployeeId, DocumentId, ApproverId: Variant
  );
var
    Document: IDocument;

    Employee: TEmployee;
    FreeEmployee: IDomainObject;

    Approver: TEmployee;
    FreeApprover: IDomainObject;
    
    DocumentApprovingCycle: TDocumentApprovingCycle;
begin

  FSession.Start;

  try

    Document := GetDocument(DocumentId);

    Employee := GetEmployee(EmployeeId);
    FreeEmployee := Employee;

    Approver := GetEmployee(ApproverId);
    FreeApprover := Approver;
    
    FDocumentApprovingProcessControlService.
      EnsureThatEmployeeMayAssignDocumentApprover(
        Employee, Document, Approver
      );

    FSession.Commit;
    
  except

    on e: Exception do begin

      FSession.Rollback;

      if e is TDocumentApprovingProcessControlServiceException then begin

        Raise TDocumentApprovingControlAppServiceException.Create(
          False,
          e.Message
        );

      end;

      RaiseFailedBusinessProcessServiceException(e.Message);
      
    end;

  end;

end;

{ refactor: реализовать через Make...AsBusinessTransaction }
procedure TStandardDocumentApprovingControlAppService.
  EnsureThatEmployeeMayChangeDocumentApproverInfo(
    const EmployeeId, DocumentId, ApproverId: Variant
  );
var
    Document: IDocument;

    Employee: TEmployee;
    FreeEmployee: IDomainObject;

    Approver: TEmployee;
    FreeApprover: IDomainObject;

    DocumentApprovingCycle: TDocumentApprovingCycle;
begin

  try

    FSession.Start;

    Document := GetDocument(DocumentId);

    Employee := GetEmployee(EmployeeId);
    FreeEmployee := Employee;

    Approver := GetEmployee(ApproverId);
    FreeApprover := Approver;
    
    FDocumentApprovingProcessControlService.
      EnsureThatEmployeeMayChangeDocumentApproverInfo(
        Employee, Document, Approver
      );

    FSession.Commit;
    
  except

    on e: Exception do begin

      FSession.Rollback;

      if e is TDocumentApprovingProcessControlServiceException then
        raise TDocumentApprovingControlAppServiceException.Create(
          False,
          e.Message
        );

      RaiseFailedBusinessProcessServiceException(e.Message);
      
    end;

  end;

end;

procedure TStandardDocumentApprovingControlAppService.
  EnsureThatEmployeeMayChangeDocumentApproverList(
    const EmployeeId, Documentid: Variant
  );
var
    Document: IDocument;

    Employee: TEmployee;
    FreeEmployee: IDomainObject;
begin

  try

    FSession.Start;

    Document := GetDocument(DocumentId);

    Employee := GetEmployee(EmployeeId);
    FreeEmployee := Employee;

    FDocumentApprovingProcessControlService.
      EnsureThatEmployeeMayChangeDocumentApproverList(
        Employee, Document
      );

    FSession.Commit;
    
  except

    on e: Exception do begin

      FSession.Rollback;

      if e is TDocumentApprovingProcessControlServiceException then
        raise TDocumentApprovingControlAppServiceException.Create(
          False,
          e.Message
        );

      RaiseFailedBusinessProcessServiceException(e.Message);

    end;

  end;

end;

procedure TStandardDocumentApprovingControlAppService.
  EnsureThatEmployeeMayCreateNewDocumentApprovingCycle(
    const DocumentId, EmployeeId: Variant
  );
begin

  MakeEmployeeDocumentOperationAsBusinessTransaction(
    DocumentId,
    EmployeeId,
    MakeOperationOfEnsuringThatEmployeeMayCreateNewDocumentApprovingCycle
  );
  
end;

{ refactor: реализовать через Make...AsBusinessTransaction }
procedure TStandardDocumentApprovingControlAppService.
  EnsureThatEmployeeMayRemoveDocumentApprover(
    const EmployeeId, DocumentId, ApproverId: Variant
  );
var
    Document: IDocument;

    Employee: TEmployee;
    FreeEmployee: IDomainObject;

    Approver: TEmployee;
    FreeApprover: IDomainObject;
    
    DocumentApprovingCycle: TDocumentApprovingCycle;
begin

  try

    FSession.Start;

    Document := GetDocument(DocumentId);

    Employee := GetEmployee(EmployeeId);
    FreeEmployee := Employee;

    Approver := GetEmployee(ApproverId);
    FreeApprover := Approver;
    
    FDocumentApprovingProcessControlService.
      EnsureThatEmployeeMayRemoveDocumentApprover(
        Employee, Document, Approver
      );

    FSession.Commit;

  except

    on e: Exception do begin

      FSession.Rollback;

      if e is TDocumentApprovingProcessControlServiceException then
        raise TDocumentApprovingControlAppServiceException.Create(
          False,
          e.Message
        );

      RaiseFailedBusinessProcessServiceException(e.Message);

    end;

  end;

end;

function TStandardDocumentApprovingControlAppService.
  GetInfoForNewDocumentApprovingCycle(
    const DocumentId, EmployeeId: Variant
  ): TDocumentApprovingCycleDTO;
var
    Document: IDocument;

    Employee: TEmployee;
    FreeEmployee: IDomainObject;

    DocumentApprovingCycle: TDocumentApprovingCycle;
    FreeDocumentApprovingCycle: IDomainObject;
begin

  try

    FSession.Start;

    Document := GetDocument(DocumentId);

    Employee := GetEmployee(EmployeeId);
    FreeEmployee := Employee;

    DocumentApprovingCycle :=
      FDocumentApprovingProcessControlService.
        GetInfoForNewDocumentApprovingCycle(
          Document, Employee
        );

    FreeDocumentApprovingCycle := DocumentApprovingCycle;

    Result := MapDocumentApprovingCycleDTOFrom(DocumentApprovingCycle);

    FSession.Commit;
      
  except

    on e: Exception do begin

      FSession.Rollback;
      
      RaiseFailedBusinessProcessServiceException(e.Message);

    end;

  end;

end;

procedure TStandardDocumentApprovingControlAppService.
  CompleteDocumentApproving(
    const DocumentId, CompletingApprovingEmployeeId: Variant
  );
begin

  MakeEmployeeDocumentOperationAsBusinessTransaction(
    DocumentId, CompletingApprovingEmployeeId
  );
  
end;

constructor TStandardDocumentApprovingControlAppService.Create(
  Session: ISession;
  DocumentDirectory: IDocumentDirectory;
  EmployeeRepository: IEmployeeRepository;
  DocumentApprovingProcessControlService: IDocumentApprovingProcessControlService;
  DocumentApprovingCycleResultRepository: IDocumentApprovingCycleResultRepository);
begin

  inherited Create(
    Session,
    DocumentDirectory,
    EmployeeRepository
  );

  FDocumentApprovingProcessControlService :=
    DocumentApprovingProcessControlService;

  FDocumentApprovingCycleResultRepository :=
    DocumentApprovingCycleResultRepository;
    
end;

procedure TStandardDocumentApprovingControlAppService.
  MakeEmployeeDocumentDomainOperation(
    DomainObjects: TEmployeeDocumentOperationDomainObjects;
    var EmployeeDocumentOperationResult: TEmployeeDocumentOperationResult
  );
var Document: IDocument;
    CompletingApprovingEmployee: TEmployee;
    DocumentApprovingCycleResult: TDocumentApprovingCycleResult;
begin

  Document := DomainObjects.Document;
  CompletingApprovingEmployee := DomainObjects.Employee;

  DocumentApprovingCycleResult :=
    FDocumentApprovingProcessControlService.CompleteDocumentApprovingCycle(
      Document, CompletingApprovingEmployee
    );

  EmployeeDocumentOperationResult :=
    TDocumentApprovingCompletingResult.Create(DocumentApprovingCycleResult);

end;

procedure TStandardDocumentApprovingControlAppService.
  MakeOperationOfEnsuringThatEmployeeMayCreateNewDocumentApprovingCycle(
    DomainObjects: TEmployeeDocumentOperationDomainObjects;
    var EmployeeDocumentOperationResult: TEmployeeDocumentOperationResult
  );
var
    Document: IDocument;
    Employee: TEmployee;
begin

  Document := DomainObjects.Document;
  Employee := DomainObjects.Employee;

  FDocumentApprovingProcessControlService.
    EnsureThatEmployeeMayCreateNewDocumentApprovingCycle(
      Document, Employee
    );

end;

function TStandardDocumentApprovingControlAppService.
  MapDocumentApprovingCycleDTOFrom(
    DocumentApprovingCycle: TDocumentApprovingCycle
  ): TDocumentApprovingCycleDTO;
begin

  Result := TDocumentApprovingCycleDTO.Create;

  Result.Id := DocumentApprovingCycle.Identity;
  Result.Number := DocumentApprovingCycle.Number;
  Result.BeginDate := DocumentApprovingCycle.BeginDate;

end;

function TStandardDocumentApprovingControlAppService.
  MayEmployeeAssignDocumentApprover(
    const EmployeeId, DocumentId, ApproverId: Variant
  ): Boolean;
var
    Document: IDocument;

    Employee: TEmployee;
    FreeEmployee: IDomainObject;

    Approver: TEmployee;
    FreeApprover: IDomainObject;
begin

  try

    FSession.Start;

    Document := GetDocument(DocumentId);

    Employee := GetEmployee(EmployeeId);
    FreeEmployee := Employee;

    Approver := GetEmployee(ApproverId);
    FreeApprover := Approver;

    Result :=
      FDocumentApprovingProcessControlService.
        MayEmployeeAssignDocumentApprover(
          Employee, Document, Approver
        );

  except

    on e: Exception do begin

      FSession.Rollback;

      RaiseFailedBusinessProcessServiceException(e.Message);

    end;

  end;

end;

function TStandardDocumentApprovingControlAppService.
  MayEmployeeChangeDocumentApproverInfo(
    const EmployeeId, DocumentId, ApproverId: Variant
  ): Boolean;
var
    Document: IDocument;

    Employee: TEmployee;
    FreeEmployee: IDomainObject;

    Approver: TEmployee;
    FreeApprover: IDomainObject;
begin

  try

    FSession.Start;

    Document := GetDocument(DocumentId);

    Employee := GetEmployee(EmployeeId);
    FreeEmployee := Employee;

    Approver := GetEmployee(ApproverId);
    FreeApprover := Approver;

    Result :=
      FDocumentApprovingProcessControlService.
        MayEmployeeChangeDocumentApproverInfo(
          Employee, Document, Approver
        );

    FSession.Commit;

  except

    on e: Exception do begin

      FSession.Rollback;

      RaiseFailedBusinessProcessServiceException(e.Message);

    end;

  end;
  
end;

function TStandardDocumentApprovingControlAppService.
  MayEmployeeChangeDocumentApproverList(
    const EmployeeId, DocumentId: Variant
  ): Boolean;
var
    Document: IDocument;

    Employee: TEmployee;
    FreeEmployee: IDomainObject;
begin

  try

    FSession.Start;

    Document := GetDocument(DocumentId);

    Employee := GetEmployee(EmployeeId);
    FreeEmployee := Employee;

    Result :=
      FDocumentApprovingProcessControlService.
        MayEmployeeChangeDocumentApproverList(
          Employee, Document
        );

    FSession.Commit;
    
  except

    on e: Exception do begin

      FSession.Rollback;

      RaiseFailedBusinessProcessServiceException(e.Message);

    end;

  end;

end;

function TStandardDocumentApprovingControlAppService.
  MayEmployeeRemoveDocumentApprover(
    const EmployeeId, DocumentId, ApproverId: Variant
  ): Boolean;
var
    Document: IDocument;

    Employee: TEmployee;
    FreeEmployee: IDomainObject;

    Approver: TEmployee;
    FreeApprover: IDomainObject;
begin

  try

    FSession.Start;

    Document := GetDocument(DocumentId);

    Employee := GetEmployee(EmployeeId);
    FreeEmployee := Employee;

    Approver := GetEmployee(ApproverId);
    FreeApprover := Approver;

    Result :=
      FDocumentApprovingProcessControlService.
        MayEmployeeRemoveDocumentApprover(
          Employee, Document, Approver
        );

    FSession.Commit;

  except

    on e: Exception do begin

      FSession.Rollback;

      RaiseFailedBusinessProcessServiceException(e.Message);

    end;

  end;
  
end;

procedure TStandardDocumentApprovingControlAppService.
  SaveEmployeeDocumentDomainOperationResult(
    DomainOperationResult: TEmployeeDocumentOperationResult
  );
begin

  with DomainOperationResult as TDocumentApprovingCompletingResult do begin

    FDocumentApprovingCycleResultRepository.AddDocumentApprovingCycleResult(
      DocumentApprovingCycleResult
    );
    
  end;

end;

end.
