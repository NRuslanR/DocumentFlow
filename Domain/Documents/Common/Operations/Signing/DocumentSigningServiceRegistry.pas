unit DocumentSigningServiceRegistry;

interface

uses

  TypeObjectRegistry,
  DocumentSigningService,
  Document,
  DocumentSigningToPerformingService,
  DocumentSigningMarkingToPerformingService,
  SysUtils;

type

  TDocumentSigningServiceRegistry = class

    private

      FSigningServices: TTypeObjectRegistry;
      FSigningMarkingServices: TTypeObjectRegistry;
      
    private

      class var FInstance: TDocumentSigningServiceRegistry;
      
      class function GetInstance: TDocumentSigningServiceRegistry; static;

    public

      destructor Destroy; override;
      constructor Create;
      
      procedure RegisterDocumentSigningService(
        DocumentClass: TDocumentClass;
        DocumentSigningService: IDocumentSigningService
      );

      function GetDocumentSigningService(
        DocumentClass: TDocumentClass
      ): IDocumentSigningService;

      procedure RegisterStandardDocumentSigningService(DocumentClass: TDocumentClass);
      procedure RegisterStandardDocumentSigningToPerformingService(DocumentClass: TDocumentClass);

    public

      function GetDocumentSigningMarkingToPerformingService(
        DocumentClass: TDocumentClass
      ): IDocumentSigningMarkingToPerformingService;

      procedure RegisterDocumentSigningMarkingToPerformingService(
        DocumentClass: TDocumentClass;
        DocumentSigningMarkingToPerformingService: IDocumentSigningMarkingToPerformingService
      );

      procedure RegisterStandardDocumentSigningMarkingToPerformingService(
        DocumentClass: TDocumentClass
      );
      
    public

      procedure RegisterAllStandardDocumentSigningServices(DocumentClass: TDocumentClass);
      
    public

      class property Instance: TDocumentSigningServiceRegistry read GetInstance;
      
  end;

implementation

uses

  PersonnelOrder,
  StandardDocumentSigningMarkingToPerformingService,
  DocumentPerformingServiceRegistry,
  DocumentRegistrationServiceRegistry,
  StandardDocumentSigningService,
  StandardDocumentSigningToPerformingService;
  
{ TDocumentSigningServiceRegistry }

constructor TDocumentSigningServiceRegistry.Create;
begin

  inherited;

  FSigningServices := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FSigningMarkingServices := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;

  FSigningServices
    .UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;

  FSigningServices
    .UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
    
end;

destructor TDocumentSigningServiceRegistry.Destroy;
begin

  FreeAndNil(FSigningServices);
  FreeAndNil(FSigningMarkingServices);
  
  inherited;

end;

function TDocumentSigningServiceRegistry
  .GetDocumentSigningMarkingToPerformingService(
    DocumentClass: TDocumentClass
  ): IDocumentSigningMarkingToPerformingService;
begin

  Result :=
    IDocumentSigningMarkingToPerformingService(
      FSigningMarkingServices.GetInterface(DocumentClass)
    );

end;

function TDocumentSigningServiceRegistry.GetDocumentSigningService(
  DocumentClass: TDocumentClass
): IDocumentSigningService;
begin

  Result :=
    IDocumentSigningService(
      FSigningServices.GetInterface(DocumentClass)
    );

end;

class function TDocumentSigningServiceRegistry.GetInstance: TDocumentSigningServiceRegistry;
begin

  if not Assigned(FInstance) then
    FInstance := TDocumentSigningServiceRegistry.Create;

  Result := FInstance;
  
end;

procedure TDocumentSigningServiceRegistry.RegisterAllStandardDocumentSigningServices(
  DocumentClass: TDocumentClass);
begin

  RegisterStandardDocumentSigningMarkingToPerformingService(DocumentClass);
  RegisterStandardDocumentSigningToPerformingService(DocumentClass);

end;

procedure TDocumentSigningServiceRegistry.RegisterDocumentSigningMarkingToPerformingService(
  DocumentClass: TDocumentClass;
  DocumentSigningMarkingToPerformingService: IDocumentSigningMarkingToPerformingService);
begin

  FSigningMarkingServices.RegisterInterface(
    DocumentClass,
    DocumentSigningMarkingToPerformingService
  );
  
end;

procedure TDocumentSigningServiceRegistry.RegisterDocumentSigningService(
  DocumentClass: TDocumentClass;
  DocumentSigningService: IDocumentSigningService);
begin

  FSigningServices.RegisterInterface(
    DocumentClass,
    DocumentSigningService
  );
  
end;

procedure TDocumentSigningServiceRegistry.RegisterStandardDocumentSigningMarkingToPerformingService(
  DocumentClass: TDocumentClass);
begin

  RegisterDocumentSigningMarkingToPerformingService(
    DocumentClass,
    TStandardDocumentSigningMarkingToPerformingService.Create(
      TDocumentPerformingServiceRegistry.Instance.GetSendingDocumentToPerformingService(
        DocumentClass
      )
    )
  );
  
end;

procedure TDocumentSigningServiceRegistry.RegisterStandardDocumentSigningService(
  DocumentClass: TDocumentClass);
begin

  RegisterDocumentSigningService(
    DocumentClass,
    TStandardDocumentSigningService.Create(
      TDocumentRegistrationServiceRegistry.Instance.GetDocumentRegistrationService(
        DocumentClass
      )
    )
  );

end;

procedure TDocumentSigningServiceRegistry.RegisterStandardDocumentSigningToPerformingService(
  DocumentClass: TDocumentClass);
begin

  RegisterDocumentSigningService(
    DocumentClass,
    TStandardDocumentSigningToPerformingService.Create(
      TDocumentRegistrationServiceRegistry.Instance.GetDocumentRegistrationService(DocumentClass),
      TDocumentPerformingServiceRegistry.Instance.GetSendingDocumentToPerformingService(DocumentClass)
    )
  );
  
end;

end.
