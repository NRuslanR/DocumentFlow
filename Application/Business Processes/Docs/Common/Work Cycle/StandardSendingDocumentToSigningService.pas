unit StandardSendingDocumentToSigningService;

interface

uses

  Document,
  Employee,
  IEmployeeRepositoryUnit,
  DocumentDirectory,
  EmployeeDocumentOperationService,
  SendingDocumentToSigningService,
  Session,
  IDomainObjectUnit,
  IDocumentUnit,
  SysUtils,
  Classes;

type

  TSendingDocumentToSigningServiceCommand =
    class (TEmployeeDocumentOperationServiceCommand)

      protected

        FSigningEmployeeId: Variant;

        function GetSendingEmployeeId: Variant;
        procedure SetSendingEmployeeId(Value: Variant);
        
      public

        constructor Create(
          const DocumentId: Variant;
          const SendingEmployeeId: Variant;
          const SigningEmployeeId: Variant
        );

      published

        property SigningEmployeeId: Variant
        read FSigningEmployeeId write FSigningEmployeeId;

        property SendingEmployeeId: Variant
        read GetSendingEmployeeId write SetSendingEmployeeId;
        
    end;

  TSendingDocumentToSigningOperationDomainObjects =
    class (TEmployeeDocumentOperationDomainObjects)

      private

        FFreeSigningEmployee: IDomainObject;

      protected

        FSigningEmployee: TEmployee;

        function GetSendingEmployee: TEmployee;
        procedure SetSendingEmployee(Value: TEmployee);
        procedure SetSigningEmployee(Value: TEmployee);
        
      public

        destructor Destroy; override;
        
        constructor Create;
        constructor CreateFrom(
          Document: TDocument;
          const SendingEmployee: TEmployee;
          const SigningEmployee: TEmployee
        );

      published

        property SigningEmployee: TEmployee
        read FSigningEmployee write SetSigningEmployee;

        property SendingEmployee: TEmployee
        read GetSendingEmployee write SetSendingEmployee;

    end;

  TSendingDocumentToSigningService = class (
                                       TEmployeeDocumentOperationService,
                                       ISendingDocumentToSigningService
                                     )

    protected

      function GetEmployeeDocumentOperationDomainObjectsInstance: TEmployeeDocumentOperationDomainObjects; override;
      
      function GetNecessaryDomainObjectsForCommandPerforming(
        Command: TEmployeeDocumentOperationServiceCommand
      ): TEmployeeDocumentOperationDomainObjects; override;
      
      procedure MakeEmployeeDocumentDomainOperation(
        DomainObjects: TEmployeeDocumentOperationDomainObjects;
        var EmployeeDocumentOperationResult: TEmployeeDocumentOperationResult
      ); override;

      procedure SendDocumentToSigningWithoutDocumentSignerAssigning(
        DomainObjects: TEmployeeDocumentOperationDomainObjects;
        var EmployeeDocumentOperationResult: TEmployeeDocumentOperationResult
      );

    public

      constructor Create(
        Session: ISession;
        DocumentDirectory: IDocumentDirectory;
        EmployeeRepository: IEmployeeRepository
      );

      procedure SendDocumentToSigning(
        const DocumentId: Variant;
        const SendingEmployeeId: Variant
      ); overload;

      procedure SendDocumentToSigning(
        const DocumentId: Variant;
        const SendingEmployeeId: Variant;
        const SigningEmployeeId: Variant
      ); overload;

  end;

implementation

{ TSendingDocumentToSigningService }

constructor TSendingDocumentToSigningService.Create(
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

function TSendingDocumentToSigningService.GetEmployeeDocumentOperationDomainObjectsInstance: TEmployeeDocumentOperationDomainObjects;
begin

  Result := TSendingDocumentToSigningOperationDomainObjects.Create;

end;

function TSendingDocumentToSigningService.
  GetNecessaryDomainObjectsForCommandPerforming(
    Command: TEmployeeDocumentOperationServiceCommand
  ): TEmployeeDocumentOperationDomainObjects;
var SendingDocumentToSigningServiceCommand:
      TSendingDocumentToSigningServiceCommand;
begin

  Result := inherited GetNecessaryDomainObjectsForCommandPerforming(Command);

  if not (Command is TSendingDocumentToSigningServiceCommand)
  then Exit;
  
  SendingDocumentToSigningServiceCommand :=
    Command as TSendingDocumentToSigningServiceCommand;
    
  with Result as TSendingDocumentToSigningOperationDomainObjects do begin

    SigningEmployee :=
      GetEmployee(SendingDocumentToSigningServiceCommand.SigningEmployeeId);

  end;
  
end;

procedure TSendingDocumentToSigningService.MakeEmployeeDocumentDomainOperation(
  DomainObjects: TEmployeeDocumentOperationDomainObjects;
  var EmployeeDocumentOperationResult: TEmployeeDocumentOperationResult
);
var
    Document: IDocument;
    SendingEmployee, SigningEmployee: TEmployee;
    OperationDomainObjects: TSendingDocumentToSigningOperationDomainObjects;
begin

  OperationDomainObjects :=
    DomainObjects as TSendingDocumentToSigningOperationDomainObjects;

  Document := OperationDomainObjects.Document;
  SendingEmployee := OperationDomainObjects.SendingEmployee;
  SigningEmployee := OperationDomainObjects.SigningEmployee;

  Document.EditingEmployee := SendingEmployee;
  
  Document.AddSigner(SigningEmployee);
  Document.ToSigningBy(SendingEmployee);

end;

procedure TSendingDocumentToSigningService.SendDocumentToSigning(
  const DocumentId, SendingEmployeeId: Variant);
begin

  MakeEmployeeDocumentOperationAsBusinessTransaction(
    DocumentId,
    SendingEmployeeId,
    SendDocumentToSigningWithoutDocumentSignerAssigning
  );
  
end;

procedure TSendingDocumentToSigningService.SendDocumentToSigning(
  const DocumentId: Variant;
  const SendingEmployeeId: Variant;
  const SigningEmployeeId: Variant
);
begin

  MakeEmployeeDocumentOperationAsBusinessTransaction(
    TSendingDocumentToSigningServiceCommand.Create(
      DocumentId, SendingEmployeeId, SigningEmployeeId
    )
  );
  
end;

procedure TSendingDocumentToSigningService.
  SendDocumentToSigningWithoutDocumentSignerAssigning(
    DomainObjects: TEmployeeDocumentOperationDomainObjects;
    var EmployeeDocumentOperationResult: TEmployeeDocumentOperationResult
  );
var Document: IDocument;
    SendingEmployee: TEmployee;
begin

  Document := DomainObjects.Document;
  SendingEmployee := DomainObjects.Employee;

  Document.EditingEmployee := SendingEmployee;
  
  Document.ToSigningBy(SendingEmployee);

end;

{ TSendingDocumentToSigningOperationDomainObjects }

constructor TSendingDocumentToSigningOperationDomainObjects.Create;
begin

  inherited;
  
end;

constructor TSendingDocumentToSigningOperationDomainObjects.CreateFrom(
  Document: TDocument; const SendingEmployee, SigningEmployee: TEmployee);
begin

  inherited CreateFrom(Document, SendingEmployee);

  FSigningEmployee := SigningEmployee;

end;

destructor TSendingDocumentToSigningOperationDomainObjects.Destroy;
begin

  FreeAndNil(FSigningEmployee);
  inherited;

end;

function TSendingDocumentToSigningOperationDomainObjects.GetSendingEmployee: TEmployee;
begin

  Result := FEmployee;
  
end;

procedure TSendingDocumentToSigningOperationDomainObjects.SetSendingEmployee(
  Value: TEmployee);
begin

  FEmployee := Value;

end;

procedure TSendingDocumentToSigningOperationDomainObjects.SetSigningEmployee(
  Value: TEmployee);
begin

  FSigningEmployee := Value;
  FFreeSigningEmployee := FSigningEmployee;
  
end;

{ TSendingDocumentToSigningServiceCommand }

constructor TSendingDocumentToSigningServiceCommand.Create(
  const DocumentId, SendingEmployeeId, SigningEmployeeId: Variant
);
begin

  inherited Create(DocumentId, SendingEmployeeId);

  FSigningEmployeeId := SigningEmployeeId;
  
end;

function TSendingDocumentToSigningServiceCommand.GetSendingEmployeeId: Variant;
begin

  Result := FEmployeeId;
  
end;

procedure TSendingDocumentToSigningServiceCommand.SetSendingEmployeeId(
  Value: Variant);
begin

  FEmployeeId := Value;
  
end;

end.
