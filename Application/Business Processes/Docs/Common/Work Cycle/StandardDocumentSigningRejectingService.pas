unit StandardDocumentSigningRejectingService;

interface

uses

  Document,
  Employee,
  IEmployeeRepositoryUnit,
  Session,
  DocumentDirectory,
  DocumentSigningRejectingService,
  EmployeeDocumentOperationService,
  IDocumentUnit,
  SysUtils;

type

  TDocumentSigningRejectingService =
    class (
      TEmployeeDocumentOperationService,
      IDocumentSigningRejectingService
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

        procedure RejectSigningDocument(
          const DocumentId: Variant;
          const RejectingSigningEmployeeId: Variant
        );

  end;

implementation

uses DocumentOperationService;

{ TDocumentSigningRejectingService }

constructor TDocumentSigningRejectingService.Create(
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

procedure TDocumentSigningRejectingService.MakeEmployeeDocumentDomainOperation(
  DomainObjects: TEmployeeDocumentOperationDomainObjects;
  var EmployeeDocumentOperationResult: TEmployeeDocumentOperationResult
);
var
    Document: IDocument;
    RejectingSigningEmployee: TEmployee;
begin

  Document := DomainObjects.Document;
  RejectingSigningEmployee := DomainObjects.Employee;

  Document.RejectSigningBy(RejectingSigningEmployee);

end;

procedure TDocumentSigningRejectingService.RejectSigningDocument(
  const DocumentId, RejectingSigningEmployeeId: Variant);
begin

  MakeEmployeeDocumentOperationAsBusinessTransaction(
    DocumentId, RejectingSigningEmployeeId
  );
  
end;

end.
