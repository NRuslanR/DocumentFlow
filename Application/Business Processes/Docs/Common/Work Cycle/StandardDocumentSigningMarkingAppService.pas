unit StandardDocumentSigningMarkingAppService;

interface

uses

  Document,
  Employee,
  EmployeeDocumentOperationService,
  DocumentSigningMarkingAppService;

type

  TDocumentSigningMarkingDomainObjects = class (TEmployeeDocumentOperationDomainObjects)

    protected

      FSigningDateTime: TDateTime;
        
    public

      constructor CreateFrom(
        Document: TDocument;
        Employee: TEmployee;
        const SigningDateTime: TDateTime
      );

      property SigningDateTime: TDateTime read FSigningDateTime write FSigningDateTime;

  end;

  TStandardDocumentSigningMarkingAppService =
    class (TEmployeeDocumentOperationService, IDocumentSigningMarkingAppService)

      protected

        procedure MakeEmployeeDocumentDomainOperation(
          DomainObjects: TEmployeeDocumentOperationDomainObjects;
          var EmployeeDocumentOperationResult: TEmployeeDocumentOperationResult
        ); override;

      protected

        function GetEmployeeDocumentOperationDomainObjectsInstance: TEmployeeDocumentOperationDomainObjects; override;
      
        function GetNecessaryDomainObjectsForCommandPerforming(
          Command: TEmployeeDocumentOperationServiceCommand
        ): TEmployeeDocumentOperationDomainObjects; override;
        
      public

        procedure MarkDocumentAsSigned(
          const DocumentId: Variant;
          const MarkingEmployeeId: Variant;
          const SigningDateTime: TDateTime
        );
      
    end;
  
implementation

uses

  AuxDebugFunctionsUnit;
  
type

  TDocumentSigningMarkingServiceCommand =
    class (TEmployeeDocumentOperationServiceCommand)

      protected

        FSigningDateTime: TDateTime;
        
      public

        constructor Create(
          const DocumentId: Variant;
          const EmployeeId: Variant;
          const SigningDateTime: TDateTime
        );

        property SigningDateTime: TDateTime read FSigningDateTime write FSigningDateTime;
        
    end;

{ TStandardDocumentSigningMarkingAppService }

procedure TStandardDocumentSigningMarkingAppService.
  MarkDocumentAsSigned(
    const DocumentId, MarkingEmployeeId: Variant;
    const SigningDateTime: TDateTime
  );
begin

  MakeEmployeeDocumentOperationAsBusinessTransaction(
    TDocumentSigningMarkingServiceCommand.Create(
      DocumentId,
      MarkingEmployeeId,
      SigningDateTime
    )
  );
  
end;

function TStandardDocumentSigningMarkingAppService.
  GetEmployeeDocumentOperationDomainObjectsInstance: TEmployeeDocumentOperationDomainObjects;
begin

  Result := TDocumentSigningMarkingDomainObjects.Create;
  
end;

function TStandardDocumentSigningMarkingAppService.GetNecessaryDomainObjectsForCommandPerforming(
  Command: TEmployeeDocumentOperationServiceCommand
): TEmployeeDocumentOperationDomainObjects;
begin

  Result := inherited GetNecessaryDomainObjectsForCommandPerforming(Command);

  DebugOutput(Result.ClassName);

  with TDocumentSigningMarkingDomainObjects(Result) do begin

    SigningDateTime :=
      TDocumentSigningMarkingServiceCommand(Command).SigningDateTime;
      
  end;

end;

procedure TStandardDocumentSigningMarkingAppService.MakeEmployeeDocumentDomainOperation(
  DomainObjects: TEmployeeDocumentOperationDomainObjects;
  var EmployeeDocumentOperationResult: TEmployeeDocumentOperationResult
);
begin

  with TDocumentSigningMarkingDomainObjects(DomainObjects) do begin

    Document.MarkAsSignedForAllSigners(Employee, SigningDateTime);

  end;

end;

{ TDocumentSigningMarkingServiceCommand }

constructor TDocumentSigningMarkingServiceCommand.Create(const DocumentId,
  EmployeeId: Variant; const SigningDateTime: TDateTime);
begin

  inherited Create(DocumentId, EmployeeId);

  FSigningDateTime := SigningDateTime;
  
end;

{ TDocumentSigningMarkingDomainObjects }

constructor TDocumentSigningMarkingDomainObjects.CreateFrom(Document: TDocument;
  Employee: TEmployee; const SigningDateTime: TDateTime);
begin

  inherited CreateFrom(Document, Employee);


  FSigningDateTime := SigningDateTime;

end;

end.
