unit EmployeeDocumentOperationService;

interface

uses

  DocumentOperationService,
  DocumentDirectory,
  Employee,
  IDocumentUnit,
  Document,
  IGetSelfUnit,
  IEmployeeRepositoryUnit,
  Session,
  SysUtils,
  IDomainObjectUnit,
  VariantListUnit,
  Classes;

type

  IEmployeeDocumentOperationServiceCommand = interface

  end;

  IEmployeeDocumentOperationDomainObjects = interface
  
  end;

  IEmployeeDocumentOperationResult = interface

  end;
  
  TEmployeeDocumentOperationServiceCommand =
    class (TInterfacedObject, IEmployeeDocumentOperationServiceCommand)

      protected

        FDocumentId: Variant;
        FEmployeeId: Variant;

      public

        constructor Create(
          const DocumentId: Variant;
          const EmployeeId: Variant
        );

      published
        
        property DocumentId: Variant read FDocumentId write FDocumentId;
        property EmployeeId: Variant read FEmployeeId write FEmployeeId;

    end;
    
  TEmployeeDocumentOperationDomainObjects =
    class (TInterfacedObject, IEmployeeDocumentOperationDomainObjects)

      private

        FFreeEmployee: IDomainObject;
        
      protected

        FDocument: IDocument;
        FEmployee: TEmployee;

        procedure SetDocument(const Value: IDocument);
        procedure SetEmployee(const Value: TEmployee);

      public

        destructor Destroy; override;
        
        constructor Create;
        constructor CreateFrom(
          Document: IDocument;
          Employee: TEmployee
        );

      published

        property Document: IDocument read FDocument write SetDocument;
        property Employee: TEmployee read FEmployee write SetEmployee;

    end;

  TEmployeeDocumentOperationResult =
    class (TInterfacedObject, IEmployeeDocumentOperationResult)

          
    end;

type

  TEmployeeDocumentDomainOperation =
    procedure (
      DomainObjects: TEmployeeDocumentOperationDomainObjects;
      var EmployeeDocumentOperationResult: TEmployeeDocumentOperationResult
    ) of object;

type

  TEmployeeDocumentOperationService = class abstract (TDocumentOperationService)

    protected

      FEmployeeRepository: IEmployeeRepository;

      function GetEmployee(
        const EmployeeId: Variant
      ): TEmployee; virtual;

      function GetEmployeeOrRaise(
        const EmployeeId: Variant;
        const ErrorMessage: String = ''
      ): TEmployee; virtual;
      
      function GetEmployeesOrRaise(
        const EmployeeIds: TVariantList;
        const ErrorMessage: String = ''
      ): TEmployees; virtual;

      procedure MakeEmployeeDocumentOperationAsBusinessTransaction(
        const DocumentId: Variant;
        const EmployeeId: Variant;
        EmployeeDocumentDomainOperation: TEmployeeDocumentDomainOperation = nil
      ); overload;

      procedure DoBeforeDocumentOperationAsBusinessTransaction(
        Command: TEmployeeDocumentOperationServiceCommand
      ); virtual;

      procedure MakeEmployeeDocumentOperationAsBusinessTransaction(
        Command: TEmployeeDocumentOperationServiceCommand;
        EmployeeDocumentDomainOperation: TEmployeeDocumentDomainOperation = nil
      ); overload; virtual;

      procedure DoAfterDocumentOperationAsBusinessTransaction(
        Command: TEmployeeDocumentOperationServiceCommand
      ); virtual;

      procedure MakeEmployeeDocumentApplicationOperation(
        Command: TEmployeeDocumentOperationServiceCommand;
        EmployeeDocumentDomainOperation: TEmployeeDocumentDomainOperation = nil
      ); overload; virtual;

      procedure MakeEmployeeDocumentApplicationOperation(
        DomainObjects: TEmployeeDocumentOperationDomainObjects;
        EmployeeDocumentDomainOperation: TEmployeeDocumentDomainOperation = nil
      ); overload; virtual;

      function GetEmployeeDocumentOperationDomainObjectsInstance: TEmployeeDocumentOperationDomainObjects; virtual;
      
      function GetNecessaryDomainObjectsForCommandPerforming(
        Command: TEmployeeDocumentOperationServiceCommand
      ): TEmployeeDocumentOperationDomainObjects; virtual;

      procedure MakeEmployeeDocumentDomainOperation(
        DomainObjects: TEmployeeDocumentOperationDomainObjects;
        var EmployeeDocumentOperationResult: TEmployeeDocumentOperationResult
      ); virtual; abstract;

      procedure SaveEmployeeDocumentDomainOperationResult(
        DomainOperationResult: TEmployeeDocumentOperationResult
      ); virtual;

      procedure DoAfterMakingEmployeeDocumentApplicationOperation(
        DomainObjects: TEmployeeDocumentOperationDomainObjects
      ); virtual;

    public

      constructor Create(
        Session: ISession;
        DocumentDirectory: IDocumentDirectory;
        EmployeeRepository: IEmployeeRepository
      );

  end;
  
implementation

uses
  BusinessProcessService,
  AbstractApplicationService,
  StrUtils;

{ TEmployeeDocumentOperationService }

constructor TEmployeeDocumentOperationService.Create(
  Session: ISession;
  DocumentDirectory: IDocumentDirectory;
  EmployeeRepository: IEmployeeRepository
);
begin

  inherited Create(
    Session,
    DocumentDirectory
  );

  FEmployeeRepository := EmployeeRepository;

end;

procedure TEmployeeDocumentOperationService.DoAfterDocumentOperationAsBusinessTransaction(
  Command: TEmployeeDocumentOperationServiceCommand);
begin

end;

procedure TEmployeeDocumentOperationService.
  DoAfterMakingEmployeeDocumentApplicationOperation(
    DomainObjects: TEmployeeDocumentOperationDomainObjects
  );
begin

end;

procedure TEmployeeDocumentOperationService.DoBeforeDocumentOperationAsBusinessTransaction(
  Command: TEmployeeDocumentOperationServiceCommand);
begin

end;

function TEmployeeDocumentOperationService.GetEmployeeDocumentOperationDomainObjectsInstance: TEmployeeDocumentOperationDomainObjects;
begin

  Result := TEmployeeDocumentOperationDomainObjects.Create;
  
end;

function TEmployeeDocumentOperationService.GetEmployeeOrRaise(
  const EmployeeId: Variant;
  const ErrorMessage: String
): TEmployee;
begin

  Result := GetEmployee(EmployeeId);

  if not Assigned(Result) then begin

    RaiseFailedBusinessProcessServiceException(
      IfThen(
        ErrorMessage = '',
        'Информация о запрашиваемом сотруднике не найдена',
        ErrorMessage
      )
    );
    
  end;


end;

function TEmployeeDocumentOperationService.GetEmployeesOrRaise(
  const EmployeeIds: TVariantList;
  const ErrorMessage: String
): TEmployees;
begin

  Result := FEmployeeRepository.FindEmployeesByIdentities(EmployeeIds);

  if not Assigned(Result) or Result.IsEmpty then begin

    FreeAndNil(Result);

    RaiseFailedBusinessProcessServiceException(
      IfThen(
        ErrorMessage = '',
        'Информация о запрашиваемых сотрудниках не найдена',
        ErrorMessage
      )
    );
    
  end;

end;

function TEmployeeDocumentOperationService.GetEmployee(
  const EmployeeId: Variant
): TEmployee;
begin

  Result := FEmployeeRepository.FindEmployeeById(EmployeeId);
  
end;

function TEmployeeDocumentOperationService.
  GetNecessaryDomainObjectsForCommandPerforming(
    Command: TEmployeeDocumentOperationServiceCommand
  ): TEmployeeDocumentOperationDomainObjects;
begin

  Result := GetEmployeeDocumentOperationDomainObjectsInstance;

  Result.Document := GetDocument(Command.DocumentId);

  if not Assigned(Result.Document) then
    RaiseFailedBusinessProcessServiceException('Документ не найден');
  
  Result.Employee := GetEmployee(Command.EmployeeId);

  if not Assigned(Result.Employee) then
    RaiseFailedBusinessProcessServiceException(
      'Данные о выполняющем операцию ' +
      'сотруднике не найдены'
    );
  
end;

procedure TEmployeeDocumentOperationService.
  MakeEmployeeDocumentApplicationOperation(
    Command: TEmployeeDocumentOperationServiceCommand;
    EmployeeDocumentDomainOperation: TEmployeeDocumentDomainOperation
  );
  
var
    DomainObjects: TEmployeeDocumentOperationDomainObjects;
    FreeDomainObjects: IEmployeeDocumentOperationDomainObjects;
begin

  DomainObjects := GetNecessaryDomainObjectsForCommandPerforming(Command);

  FreeDomainObjects := DomainObjects;

  MakeEmployeeDocumentApplicationOperation(
    DomainObjects, EmployeeDocumentDomainOperation
  );

end;

procedure TEmployeeDocumentOperationService.
  MakeEmployeeDocumentOperationAsBusinessTransaction(
    const DocumentId, EmployeeId: Variant;
    EmployeeDocumentDomainOperation: TEmployeeDocumentDomainOperation
  );
begin

    MakeEmployeeDocumentOperationAsBusinessTransaction(
      TEmployeeDocumentOperationServiceCommand.Create(
        DocumentId, EmployeeId
      ),
      EmployeeDocumentDomainOperation
    );
  
end;

procedure TEmployeeDocumentOperationService.MakeEmployeeDocumentApplicationOperation(
  DomainObjects: TEmployeeDocumentOperationDomainObjects;
  EmployeeDocumentDomainOperation: TEmployeeDocumentDomainOperation
);
var
    DomainOperationResult: TEmployeeDocumentOperationResult;
    FreeDomainOperationResult: IEmployeeDocumentOperationResult;
begin

  DomainOperationResult := nil;

  if not Assigned(EmployeeDocumentDomainOperation) then begin

    MakeEmployeeDocumentDomainOperation(DomainObjects, DomainOperationResult);

  end

  else begin

    EmployeeDocumentDomainOperation(DomainObjects, DomainOperationResult);

  end;

  FreeDomainOperationResult := DomainOperationResult;

  SaveDocumentChangesToRepository(TDocument(DomainObjects.Document.Self));

  if Assigned(DomainOperationResult) then begin

    SaveEmployeeDocumentDomainOperationResult(DomainOperationResult);

  end;

  DoAfterMakingEmployeeDocumentApplicationOperation(DomainObjects);
  
end;

procedure TEmployeeDocumentOperationService.
  MakeEmployeeDocumentOperationAsBusinessTransaction(
    Command: TEmployeeDocumentOperationServiceCommand;
    EmployeeDocumentDomainOperation: TEmployeeDocumentDomainOperation
  );
var FreeCommand: IEmployeeDocumentOperationServiceCommand;
begin

  FreeCommand := Command;
  
  try

    DoBeforeDocumentOperationAsBusinessTransaction(Command);

    FSession.Start;

    MakeEmployeeDocumentApplicationOperation(
      Command, EmployeeDocumentDomainOperation
    );

    FSession.Commit;

    DoAfterDocumentOperationAsBusinessTransaction(Command);
    
  except

    on e: Exception do begin

      FSession.Rollback;

      RaiseFailedBusinessProcessServiceException(e.Message);
      
    end;

  end;

end;

procedure TEmployeeDocumentOperationService.
  SaveEmployeeDocumentDomainOperationResult(
    DomainOperationResult: TEmployeeDocumentOperationResult
  );
begin

end;

{ TEmployeeDocumentOperationServiceCommand }

constructor TEmployeeDocumentOperationServiceCommand.Create(const DocumentId,
  EmployeeId: Variant);
begin

  inherited Create;

  FDocumentId := DocumentId;
  FEmployeeId := EmployeeId;
  
end;

{ TEmployeeDocumentOperationDomainObjects }

constructor TEmployeeDocumentOperationDomainObjects.Create;
begin

  inherited;

end;

constructor TEmployeeDocumentOperationDomainObjects.CreateFrom(
  Document: IDocument; Employee: TEmployee);
begin

  inherited Create;

  Self.Document := Document;
  Self.Employee := Employee;
  
end;

destructor TEmployeeDocumentOperationDomainObjects.Destroy;
begin

  inherited;

end;

procedure TEmployeeDocumentOperationDomainObjects.SetDocument(
  const Value: IDocument);
begin

  FDocument := Value;
  
end;

procedure TEmployeeDocumentOperationDomainObjects.SetEmployee(
  const Value: TEmployee);
begin

  FEmployee := Value;
  FFreeEmployee := FEmployee;

end;

end.
