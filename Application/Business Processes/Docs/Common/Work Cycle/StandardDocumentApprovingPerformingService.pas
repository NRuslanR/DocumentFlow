unit StandardDocumentApprovingPerformingService;

interface

uses

  EmployeeDocumentOperationService,
  Session,
  DocumentDirectory,
  IEmployeeRepositoryUnit,
  Document,
  Employee,
  DocumentApprovingProcessControlService,
  DocumentApprovingCycleResult,
  DocumentApprovingCycleResultRepository,
  DocumentApprovingPerformingService,
  IDocumentUnit,
  SysUtils,
  Classes;

type

  TDocumentApprovingPerformingResult =
    class (TEmployeeDocumentOperationResult)

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

  TDocumentApprovingPerformingCommand = class (TEmployeeDocumentOperationServiceCommand)

    protected

      FDocumentApprovingPerformingKind: TDocumentApprovingPerformingKind;

    public

      constructor Create(
        const DocumentId: Variant;
        const EmployeeId: Variant;
        const DocumentApprovingPerformingKind: TDocumentApprovingPerformingKind
      );

    published

      property DocumentApprovingPerformingKind: TDocumentApprovingPerformingKind
      read FDocumentApprovingPerformingKind
      write FDocumentApprovingPerformingKind;

  end;

  TDocumentApprovingPerformingDomainObjects = class (TEmployeeDocumentOperationDomainObjects)

    protected

      FDocumentApprovingPerformingKind: TDocumentApprovingPerformingKind;

    public

      constructor Create;
      constructor CreateFrom(
        Document: TDocument;
        Employee: TEmployee;
        const DocumentApprovingPerformingKind: TDocumentApprovingPerformingKind
      );

    published

      property DocumentApprovingPerformingKind: TDocumentApprovingPerformingKind
      read FDocumentApprovingPerformingKind
      write FDocumentApprovingPerformingKind;
      
  end;
    
  TStandardDocumentApprovingPerformingService =
    class abstract (
      TEmployeeDocumentOperationService,
      IDocumentApprovingPerformingService
    )

      protected

        FDocumentApprovingProcessControlService:
          IDocumentApprovingProcessControlService;

        FDocumentApprovingCycleResultRepository:
          IDocumentApprovingCycleResultRepository;

        procedure MakeEmployeeDocumentDomainOperation(
          DomainObjects: TEmployeeDocumentOperationDomainObjects;
          var EmployeeDocumentOperationResult: TEmployeeDocumentOperationResult
        ); override;

        procedure SaveEmployeeDocumentDomainOperationResult(
          DomainOperationResult: TEmployeeDocumentOperationResult
        ); override;

        function GetNecessaryDomainObjectsForCommandPerforming(
          Command: TEmployeeDocumentOperationServiceCommand
        ): TEmployeeDocumentOperationDomainObjects; override;

        function GetEmployeeDocumentOperationDomainObjectsInstance: TEmployeeDocumentOperationDomainObjects; override;
  
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

        procedure PerformApprovingDocument(
          const DocumentId: Variant;
          const PerformerId: Variant;
          const DocumentApprovingPerformingKind: TDocumentApprovingPerformingKind
        );
      
    end;


implementation

{ TStandardDocumentApprovingPerformingService }

procedure TStandardDocumentApprovingPerformingService.PerformApprovingDocument(
  const DocumentId, PerformerId: Variant;
  const DocumentApprovingPerformingKind: TDocumentApprovingPerformingKind
);
begin

  MakeEmployeeDocumentOperationAsBusinessTransaction(
    TDocumentApprovingPerformingCommand.Create(
      DocumentId,
      PerformerId,
      DocumentApprovingPerformingKind
    )
  );
  
end;

constructor TStandardDocumentApprovingPerformingService.Create(
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
    EmployeeRepository
  );

  FDocumentApprovingProcessControlService :=
    DocumentApprovingProcessControlService;

  FDocumentApprovingCycleResultRepository :=
    DocumentApprovingCycleResultRepository;
  
end;

function TStandardDocumentApprovingPerformingService.GetEmployeeDocumentOperationDomainObjectsInstance: TEmployeeDocumentOperationDomainObjects;
begin

  Result := TDocumentApprovingPerformingDomainObjects.Create;
  
end;

function TStandardDocumentApprovingPerformingService.
  GetNecessaryDomainObjectsForCommandPerforming(
    Command: TEmployeeDocumentOperationServiceCommand
  ): TEmployeeDocumentOperationDomainObjects;
begin

  Result := inherited GetNecessaryDomainObjectsForCommandPerforming(Command);

  with Result as TDocumentApprovingPerformingDomainObjects do begin

    DocumentApprovingPerformingKind := (Command as TDocumentApprovingPerformingCommand).DocumentApprovingPerformingKind;

  end;
  
end;

procedure TStandardDocumentApprovingPerformingService.
  MakeEmployeeDocumentDomainOperation(
    DomainObjects: TEmployeeDocumentOperationDomainObjects;
    var EmployeeDocumentOperationResult: TEmployeeDocumentOperationResult
  );
var
    Document: IDocument;
    Performer: TEmployee;
    DocumentApprovingCycleResult: TDocumentApprovingCycleResult;
    DocumentApprovingPerformingDomainObjects: TDocumentApprovingPerformingDomainObjects;
    DocumentApprovingPerformingKind: TDocumentApprovingPerformingKind;
begin

  DocumentApprovingPerformingDomainObjects :=
    DomainObjects as TDocumentApprovingPerformingDomainObjects;
    
  Document := DocumentApprovingPerformingDomainObjects.Document;
  Performer := DocumentApprovingPerformingDomainObjects.Employee;
  DocumentApprovingPerformingKind := DocumentApprovingPerformingDomainObjects.DocumentApprovingPerformingKind;

  if DocumentApprovingPerformingKind = pkApporving then begin

    DocumentApprovingCycleResult :=
      FDocumentApprovingProcessControlService.
        ApproveDocumetOnBehalfOfEmployeeAndCompleteApprovingCycleIfPossible(
          Document, Performer
        );
        
  end

  else if DocumentApprovingPerformingKind = pkNotApproving then begin

    DocumentApprovingCycleResult :=
      FDocumentApprovingProcessControlService.
        NotApproveDocumetOnBehalfOfEmployeeAndCompleteApprovingCycleIfPossible(
          Document, Performer
        );
  
  end

  else DocumentApprovingCycleResult := nil;

  if Assigned(DocumentApprovingCycleResult) then begin

    EmployeeDocumentOperationResult :=
      TDocumentApprovingPerformingResult.Create(
        DocumentApprovingCycleResult
      );
      
  end;
    
end;

procedure TStandardDocumentApprovingPerformingService.
  SaveEmployeeDocumentDomainOperationResult(
    DomainOperationResult: TEmployeeDocumentOperationResult
  );
var DocumentApprovingPerformingResult: TDocumentApprovingPerformingResult;
begin

  DocumentApprovingPerformingResult :=
    DomainOperationResult as TDocumentApprovingPerformingResult;

  FDocumentApprovingCycleResultRepository.AddDocumentApprovingCycleResult(
    DocumentApprovingPerformingResult.DocumentApprovingCycleResult
  );
  
end;

{ TDocumentApprovingPerformingResult }

constructor TDocumentApprovingPerformingResult.Create(
  DocumentApprovingCycleResult: TDocumentApprovingCycleResult);
begin

  inherited Create;

  FDocumentApprovingCycleResult := DocumentApprovingCycleResult;
  
end;

destructor TDocumentApprovingPerformingResult.Destroy;
begin

  FreeAndNil(FDocumentApprovingCycleResult);
  inherited;

end;

{ TDocumentApprovingPerformingCommand }

constructor TDocumentApprovingPerformingCommand.Create(
  const DocumentId, EmployeeId: Variant;
  const DocumentApprovingPerformingKind: TDocumentApprovingPerformingKind
);
begin

  inherited Create(DocumentId, EmployeeId);

  FDocumentApprovingPerformingKind := DocumentApprovingPerformingKind;
  
end;

{ TDocumentApprovingPerformingDomainObjects }

constructor TDocumentApprovingPerformingDomainObjects.Create;
begin

  inherited;

end;

constructor TDocumentApprovingPerformingDomainObjects.CreateFrom(
  Document: TDocument; Employee: TEmployee;
  const DocumentApprovingPerformingKind: TDocumentApprovingPerformingKind);
begin

  inherited CreateFrom(Document, Employee);

  FDocumentApprovingPerformingKind := DocumentApprovingPerformingKind;

end;

end.
