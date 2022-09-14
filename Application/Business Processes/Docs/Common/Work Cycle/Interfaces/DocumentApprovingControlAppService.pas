unit DocumentApprovingControlAppService;

interface

uses

  SysUtils,
  DocumentApprovingCycleDTO,
  ApplicationService,
  BusinessProcessService;
  
type

  TDocumentApprovingControlAppServiceException =
    class (TBusinessProcessServiceException)

    end;

  IDocumentApprovingControlAppService = interface (IApplicationService)

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

end.
