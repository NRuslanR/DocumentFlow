unit DocumentOperationServiceRegistry;

interface

uses

  Document,
  RespondingDocumentCreatingService,
  IncomingDocumentCreatingService,
  DomainException,
  IncomingDocument,
  DocumentCreatingService,
  TypeObjectRegistry,
  SysUtils;

type

  TDocumentOperationServiceRegistry = class

    private

      FDocumentCreatingServiceRegistry: TTypeObjectRegistry;
      FIncomingDocumentCreatingServiceRegistry: TTypeObjectRegistry;
      FRespondingDocumentCreatingServiceRegistry: TTypeObjectRegistry;

    private

      class var FInstance: TDocumentOperationServiceRegistry;

      class function GetInstance: TDocumentOperationServiceRegistry; static;
      
    public

      procedure RegisterRespondingDocumentCreatingService(
        DocumentType: TDocumentClass;
        RespondingDocumentCreatingService: IRespondingDocumentCreatingService
      );

      procedure RegisterStandardRespondingDocumentCreatingService(
        DocumentType: TDocumentClass
      );

    public

      procedure RegisterDocumentCreatingService(
        DocumentType: TDocumentClass;
        DocumentCreatingService: IDocumentCreatingService
      );

      function GetDocumentCreatingService(DocumentType: TDocumentClass): IDocumentCreatingService;

      procedure RegisterStandardDocumentCreatingService(DocumentType: TDocumentClass);

    public

      procedure RegisterIncomingDocumentCreatingService(
        DocumentType: TIncomingDocumentClass;
        IncomingDocumentCreatingService: IIncomingDocumentCreatingService
      );

      function GetIncomingDocumentCreatingService(DocumentType: TIncomingDocumentClass): IIncomingDocumentCreatingService;

      procedure RegisterStandardIncomingDocumentCreatingService(
        DocumentType: TIncomingDocumentClass
      );
      
    public

      procedure RegisterAllStandardDocumentOperationServices(DocumentType: TDocumentClass);

    public

      function GetRespondingDocumentCreatingService(
        DocumentType: TDocumentClass
      ): IRespondingDocumentCreatingService;

    public

      destructor Destroy; override;
      constructor Create;

      class property Instance: TDocumentOperationServiceRegistry read GetInstance;

  end;


implementation

uses

  DocumentUsageEmployeeAccessRightsService,
  StandardRespondingDocumentCreatingService,
  DocumentFormalizationServiceRegistry,
  DocumentStorageServiceRegistry,
  EmployeeSubordinationServiceRegistry,
  DocumentSearchServiceRegistry,
  DocumentNumerationServiceRegistry,
  StandardDocumentCreatingService,
  StandardIncomingDocumentCreatingService,
  EmployeeServiceRegistry,
  DocumentAccessRightsServiceRegistry;
  
{ TDocumentOperationServiceRegistry }

constructor TDocumentOperationServiceRegistry.Create;
begin

  inherited;

  FRespondingDocumentCreatingServiceRegistry :=
    TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;

  FRespondingDocumentCreatingServiceRegistry
    .UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;

  FDocumentCreatingServiceRegistry :=
    TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;

  FDocumentCreatingServiceRegistry
    .UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;

  FIncomingDocumentCreatingServiceRegistry :=
    TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;

  FIncomingDocumentCreatingServiceRegistry
    .UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
    
end;

destructor TDocumentOperationServiceRegistry.Destroy;
begin

  FreeAndNil(FDocumentCreatingServiceRegistry);
  FreeAndNil(FIncomingDocumentCreatingServiceRegistry);
  FreeAndNil(FRespondingDocumentCreatingServiceRegistry);
  
  inherited;

end;

function TDocumentOperationServiceRegistry.
  GetDocumentCreatingService(DocumentType: TDocumentClass): IDocumentCreatingService;
begin

  Result :=
    IDocumentCreatingService(
      FDocumentCreatingServiceRegistry.GetInterface(DocumentType)
    );

end;

function TDocumentOperationServiceRegistry.GetIncomingDocumentCreatingService(
  DocumentType: TIncomingDocumentClass): IIncomingDocumentCreatingService;
begin

  Result :=
    IIncomingDocumentCreatingService(
      FIncomingDocumentCreatingServiceRegistry.GetInterface(DocumentType)
    );
    
end;

class function TDocumentOperationServiceRegistry.GetInstance: TDocumentOperationServiceRegistry;
begin

  if not Assigned(FInstance) then
    FInstance := TDocumentOperationServiceRegistry.Create;

  Result := FInstance;
  
end;

function TDocumentOperationServiceRegistry.GetRespondingDocumentCreatingService(
  DocumentType: TDocumentClass
): IRespondingDocumentCreatingService;
var
    RespondingDocumentCreatingService: IInterface;
begin

  RespondingDocumentCreatingService :=
    FRespondingDocumentCreatingServiceRegistry.GetInterface(DocumentType);

  RespondingDocumentCreatingService.QueryInterface(
    IRespondingDocumentCreatingService, Result
  );
  
end;

procedure TDocumentOperationServiceRegistry.RegisterAllStandardDocumentOperationServices(
  DocumentType: TDocumentClass
);
begin

  RegisterStandardDocumentCreatingService(DocumentType);
  RegisterStandardRespondingDocumentCreatingService(DocumentType);
  
end;

procedure TDocumentOperationServiceRegistry.RegisterDocumentCreatingService(
  DocumentType: TDocumentClass;
  DocumentCreatingService: IDocumentCreatingService);
begin

  FDocumentCreatingServiceRegistry.RegisterInterface(
    DocumentType, DocumentCreatingService
  );
  
end;

procedure TDocumentOperationServiceRegistry.RegisterIncomingDocumentCreatingService(
  DocumentType: TIncomingDocumentClass;
  IncomingDocumentCreatingService: IIncomingDocumentCreatingService);
begin

  FIncomingDocumentCreatingServiceRegistry.RegisterInterface(
    DocumentType,
    IncomingDocumentCreatingService
  );
  
end;

procedure TDocumentOperationServiceRegistry.RegisterRespondingDocumentCreatingService(
  DocumentType: TDocumentClass;
  RespondingDocumentCreatingService: IRespondingDocumentCreatingService
);
begin

  FRespondingDocumentCreatingServiceRegistry.RegisterInterface(
    DocumentType,
    RespondingDocumentCreatingService
  );
  
end;

procedure TDocumentOperationServiceRegistry.RegisterStandardDocumentCreatingService(
  DocumentType: TDocumentClass);
begin

  RegisterDocumentCreatingService(
    DocumentType,
    TStandardDocumentCreatingService.Create(
      DocumentType,
      TDocumentSearchServiceRegistry.Instance.GetDocumentKindFinder,
      TDocumentSearchServiceRegistry.Instance.GetDocumentWorkCycleFinder(DocumentType),
      TDocumentAccessRightsServiceRegistry.Instance.GetEmployeeDocumentKindAccessRightsService,
      TEmployeeSubordinationServiceRegistry.Instance.GetEmployeeSubordinationService
    )
  );
  
end;

procedure TDocumentOperationServiceRegistry.RegisterStandardIncomingDocumentCreatingService(
  DocumentType: TIncomingDocumentClass);
begin

  RegisterIncomingDocumentCreatingService(
    DocumentType,
    TStandardIncomingDocumentCreatingService.Create(
      TDocumentSearchServiceRegistry.Instance.GetDocumentKindFinder,
      DocumentType
    )
  );
  
end;

procedure TDocumentOperationServiceRegistry.RegisterStandardRespondingDocumentCreatingService(
  DocumentType: TDocumentClass
);
var
    OutcomingDocumentType: TDocumentClass;
begin

  if not DocumentType.InheritsFrom(TIncomingDocument) then begin

    raise TDomainException.Create(
      'Попытка зарегистрировать службу создания ' +
      'ответных документов для не входящего вида документов'
    );

  end;

  OutcomingDocumentType := TIncomingDocumentClass(DocumentType).OutcomingDocumentType;
  
  FRespondingDocumentCreatingServiceRegistry.RegisterInterface(
    DocumentType,
    TStandardRespondingDocumentCreatingService.Create(
      TDocumentFormalizationServiceRegistry.Instance.GetDocumentFullNameCompilationService,

      GetDocumentCreatingService(OutcomingDocumentType),

      IIncomingDocumentUsageEmployeeAccessRightsService(
        TDocumentAccessRightsServiceRegistry.Instance.GetDocumentUsageEmployeeAccessRightsService(DocumentType)
      ),

      TDocumentAccessRightsServiceRegistry.Instance.GetDocumentUsageEmployeeAccessRightsService(
        TIncomingDocumentClass(DocumentType).OutcomingDocumentType
      ),

      TDocumentSearchServiceRegistry.Instance.GetFormalDocumentSignerFinder,
      
      TEmployeeSubordinationServiceRegistry.Instance.GetEmployeeSubordinationService
    )
  );
  
end;

end.
