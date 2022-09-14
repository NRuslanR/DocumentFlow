unit DocumentApprovingProcessControlService;

interface

uses

  SysUtils,
  IDocumentUnit,
  Employee,
  DomainException,
  DocumentApprovingCycle,
  DocumentApprovingCycleResult;

type

  TDocumentApprovingProcessControlServiceException = class (TDomainException)

  end;
  
  IDocumentApprovingProcessControlService = interface

    function GetInfoForNewDocumentApprovingCycle(
      Document: IDocument;
      Employee: TEmployee
    ): TDocumentApprovingCycle;

    { �����������: ���������� ��������, ������������
      ����� �� ���� ���� ������������ ��������,
      � ����� ������ ������ ����� "AndCompleteApprovingCycleIfPossible"
      �� ������������ ������, �������� ��� �����
      ��� ������ }
    function ApproveDocumetOnBehalfOfEmployeeAndCompleteApprovingCycleIfPossible(
      Document: IDocument;
      ApprovingEmployee: TEmployee
    ): TDocumentApprovingCycleResult;

    { �����������: ���������� ��������, ������������
      ����� �� ���� ���� ������������ ��������,
      � ����� ������ ������ ����� "AndCompleteApprovingCycleIfPossible"
      �� ������������ ������, �������� ��� �����
      ��� ������ }
    function NotApproveDocumetOnBehalfOfEmployeeAndCompleteApprovingCycleIfPossible(
      Document: IDocument;
      ApprovingEmployee: TEmployee
    ): TDocumentApprovingCycleResult;
    
    function CompleteDocumentApprovingCycle(
      Document: IDocument;
      CompletingEmployee: TEmployee
    ): TDocumentApprovingCycleResult;

    procedure EnsureThatEmployeeMayCreateNewDocumentApprovingCycle(
      Document: IDocument;
      InitiatingEmployee: TEmployee
    );

    procedure EnsureThatEmployeeMayChangeDocumentApproverList(
      Employee: TEmployee;
      Document: IDocument
    );
    
    procedure EnsureThatEmployeeMayChangeDocumentApproverInfo(
      Employee: TEmployee;
      Document: IDocument;
      Approver: TEmployee
    );

    procedure EnsureThatEmployeeMayAssignDocumentApprover(
      Employee: TEmployee;
      Document: IDocument;
      Approver: TEmployee
    );

    procedure EnsureThatEmployeeMayRemoveDocumentApprover(
      Employee: TEmployee;
      Document: IDocument;
      Approver: TEmployee
    );

    function MayEmployeeChangeDocumentApproverList(
      Employee: TEmployee;
      Document: IDocument
    ): Boolean;

    function MayEmployeeChangeDocumentApproverInfo(
      Employee: TEmployee;
      Document: IDocument;
      Approver: TEmployee
    ): Boolean;

    function MayEmployeeAssignDocumentApprover(
      Employee: TEmployee;
      Document: IDocument;
      Approver: TEmployee
    ): Boolean;

    function MayEmployeeRemoveDocumentApprover(
      Employee: TEmployee;
      Document: IDocument;
      Approver: TEmployee
    ): Boolean;

  end;

  
implementation

end.
