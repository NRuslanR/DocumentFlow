unit DocumentChargeServiceRegistry;

interface

uses

  DocumentChargeCreatingService,
  DocumentChargeKindsControlService,
  DocumentCharges,
  DomainException,
  TypeObjectRegistry,
  SysUtils;

type

  TDocumentChargeServiceRegistry = class

    private

      FChargeCreatingServices: TTypeObjectRegistry;
      FChargeKindsControlServices: TTypeObjectRegistry;

      class var FInstance: TDocumentChargeServiceRegistry;
      class function GetInstance: TDocumentChargeServiceRegistry; static;

    public

      destructor Destroy; override;
      constructor Create;

    public

      procedure RegisterDocumentChargeCreatingService(
        DocumentChargeType: TDocumentChargeClass;
        DocumentChargeCreatingService: IDocumentChargeCreatingService
      );

      procedure RegisterStandardDocumentChargeCreatingService(
        DocumentChargeType: TDocumentChargeClass
      );

      function GetDocumentChargeCreatingService(
        DocumentChargeType: TDocumentChargeClass
      ): IDocumentChargeCreatingService;

    public

      procedure RegisterDocumentChargeKindsControlService(
        ChargeKindsControlService: IDocumentChargeKindsControlService
      );

      function GetDocumentChargeKindsControlService: IDocumentChargeKindsControlService;
      
      class property Instance: TDocumentChargeServiceRegistry
      read GetInstance;
      
  end;

implementation

uses

  StandardDocumentChargeCreatingService;
  
{ TDocumentChargeServiceRegistry }

constructor TDocumentChargeServiceRegistry.Create;
begin

  inherited;

  FChargeCreatingServices := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FChargeKindsControlServices := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  
  FChargeCreatingServices.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  FChargeKindsControlServices.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  
end;

destructor TDocumentChargeServiceRegistry.Destroy;
begin

  FreeAndNil(FChargeCreatingServices);
  FreeAndNil(FChargeKindsControlServices);
  
  inherited;

end;

function TDocumentChargeServiceRegistry.GetDocumentChargeCreatingService(
  DocumentChargeType: TDocumentChargeClass): IDocumentChargeCreatingService;
begin

  Result :=
    IDocumentChargeCreatingService(
      FChargeCreatingServices.GetInterface(DocumentChargeType)
    );
    
end;

function TDocumentChargeServiceRegistry
  .GetDocumentChargeKindsControlService: IDocumentChargeKindsControlService;
begin

  Result :=
    IDocumentChargeKindsControlService(
      FChargeKindsControlServices.GetInterface(TDocumentCharge)
    );
    
end;

class function TDocumentChargeServiceRegistry.GetInstance: TDocumentChargeServiceRegistry;
begin

  if not Assigned(FInstance) then
    FInstance := TDocumentChargeServiceRegistry.Create;

  Result := FInstance;

end;

procedure TDocumentChargeServiceRegistry.RegisterDocumentChargeCreatingService(
  DocumentChargeType: TDocumentChargeClass;
  DocumentChargeCreatingService: IDocumentChargeCreatingService);
begin

  FChargeCreatingServices.RegisterInterface(
    DocumentChargeType,
    DocumentChargeCreatingService
  );

end;

procedure TDocumentChargeServiceRegistry.RegisterDocumentChargeKindsControlService(
  ChargeKindsControlService: IDocumentChargeKindsControlService);
begin

  FChargeKindsControlServices.RegisterInterface(
    TDocumentCharge,
    ChargeKindsControlService
  );
  
end;

procedure TDocumentChargeServiceRegistry.RegisterStandardDocumentChargeCreatingService(
  DocumentChargeType: TDocumentChargeClass
);
begin

  if GetDocumentChargeKindsControlService = nil then begin

    Raise TDomainException.Create(
      'При регистрации службу создания поручения не ' +
      'найдена служба типов поручений'
    );

  end;

  RegisterDocumentChargeCreatingService(
    DocumentChargeType,
    TStandardDocumentChargeCreatingService.Create(GetDocumentChargeKindsControlService)
  );
  
end;

end.
