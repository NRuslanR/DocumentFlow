unit StandardSendingDocumentToApprovingService;

interface

uses

  EmployeeDocumentOperationService,
  SendingDocumentToApprovingService,
  Document,
  Employee,
  Session,
  DocumentDirectory,
  IEmployeeRepositoryUnit,
  IDocumentUnit,
  SysUtils,
  Classes;

type

  TStandardSendingDocumentToApprovingService =
    class (
      TEmployeeDocumentOperationService,
      ISendingDocumentToApprovingService
    )

      protected

        procedure MakeEmployeeDocumentDomainOperation(
          DomainObjects: TEmployeeDocumentOperationDomainObjects;
          var EmployeeDocumentOperationResult: TEmployeeDocumentOperationResult
        ); override;
        
      public

        constructor Create(
          Session: ISession;
          DocumentDirectory: IDocumentDirectory;
          EmployeeRepository: IEmployeeRepository
        );

        procedure SendDocumentToApproving(
          const DocumentId: Variant;
          const SendingEmployeeId: Variant
        );

    end;

implementation

{ TStandardSendingDocumentToApprovingService }

constructor TStandardSendingDocumentToApprovingService.Create(
  Session: ISession;
  DocumentDirectory: IDocumentDirectory;
  EmployeeRepository: IEmployeeRepository
);
begin

  inherited Create(
    Session,
    DocumentDirectory,
    EmployeeRepository
  );
  
end;

procedure TStandardSendingDocumentToApprovingService.
  MakeEmployeeDocumentDomainOperation(
    DomainObjects: TEmployeeDocumentOperationDomainObjects;
    var EmployeeDocumentOperationResult: TEmployeeDocumentOperationResult
  );
var
    Document: IDocument;
    SendingEmployee: TEmployee;
begin

  Document := DomainObjects.Document;
  SendingEmployee := DomainObjects.Employee;

  Document.EditingEmployee := SendingEmployee;
  
  Document.ToApprovingBy(SendingEmployee);
  
end;

procedure TStandardSendingDocumentToApprovingService.SendDocumentToApproving(
  const DocumentId, SendingEmployeeId: Variant);
begin

  MakeEmployeeDocumentOperationAsBusinessTransaction(
    DocumentId, SendingEmployeeId
  );
  
end;

end.
