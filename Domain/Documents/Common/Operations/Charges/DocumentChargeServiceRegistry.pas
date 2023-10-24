unit DocumentChargeServiceRegistry;

interface

uses

  DocumentChargeCreatingService,
  DocumentChargeAccessRightsService,
  DocumentChargeKindsControlService,
  DocumentCharges,
  DocumentChargeControlService,
  DomainException,
  TypeObjectRegistry,
  SysUtils;

type

  TDocumentChargeServiceRegistry = class

    private

      FChargeAccessRightsServices: TTypeObjectRegistry;
      FChargeCreatingServices: TTypeObjectRegistry;
      FChargeKindsControlServices: TTypeObjectRegistry;
      FChargeControlServices: TTypeObjectRegistry;

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

      procedure RegisterDocumentChargeAccessRightsService(
        DocumentChargeType: TDocumentChargeClass;
        DocumentChargeAccessRightsService: IDocumentChargeAccessRightsService
      );

      function GetDocumentChargeAccessRightsService(
        DocumentChargeType: TDocumentChargeClass
      ): IDocumentChargeAccessRightsService;

      procedure RegisterStandardDocumentChargeAccessRightsService(
        DocumentChargeType: TDocumentChargeClass
      );

    public

      procedure RegisterDocumentChargeControlService(
        DocumentChargeControlService: IDocumentChargeControlService
      );

      function GetDocumentChargeControlService: IDocumentChargeControlService;

      procedure RegisterStandardDocumentChargeControlService;
      
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

  StandardDocumentChargeControlService,
  StandardDocumentChargeAccessRightsService,
  StandardDocumentChargeCreatingService;
  
{ TDocumentChargeServiceRegistry }

constructor TDocumentChargeServiceRegistry.Create;
begin

  inherited;

  FChargeAccessRightsServices := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FChargeCreatingServices := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FChargeKindsControlServices := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FChargeControlServices := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  
  FChargeAccessRightsServices.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  FChargeCreatingServices.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  FChargeKindsControlServices.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  FChargeControlServices.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  
end;

destructor TDocumentChargeServiceRegistry.Destroy;
begin

  FreeAndNil(FChargeAccessRightsServices);
  FreeAndNil(FChargeCreatingServices);
  FreeAndNil(FChargeKindsControlServices);
  FreeAndNil(FChargeControlServices);
  
  inherited;

end;

function TDocumentChargeServiceRegistry.GetDocumentChargeAccessRightsService(
  DocumentChargeType: TDocumentChargeClass): IDocumentChargeAccessRightsService;
begin

  Result :=
    IDocumentChargeAccessRightsService(
      FChargeAccessRightsServices.GetInterface(DocumentChargeType)
    );

end;

function TDocumentChargeServiceRegistry.GetDocumentChargeControlService: IDocumentChargeControlService;
begin

  Result :=
    IDocumentChargeControlService(
      FChargeControlServices.GetInterface(TDocumentCharge)
    );
    
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

procedure TDocumentChargeServiceRegistry.RegisterDocumentChargeAccessRightsService(
  DocumentChargeType: TDocumentChargeClass;
  DocumentChargeAccessRightsService: IDocumentChargeAccessRightsService
);
begin

  FChargeAccessRightsServices.RegisterInterface(
    DocumentChargeType,
    DocumentChargeAccessRightsService
  );
  
end;

procedure TDocumentChargeServiceRegistry.RegisterDocumentChargeControlService(
  DocumentChargeControlService: IDocumentChargeControlService);
begin

  FChargeControlServices.RegisterInterface(
    TDocumentCharge,
    DocumentChargeControlService
  );
  
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

procedure TDocumentChargeServiceRegistry.RegisterStandardDocumentChargeAccessRightsService(
  DocumentChargeType: TDocumentChargeClass);
begin

  RegisterDocumentChargeAccessRightsService(
    DocumentChargeType,
    TStandardDocumentChargeAccessRightsService.Create
  );
  
end;

procedure TDocumentChargeServiceRegistry.RegisterStandardDocumentChargeControlService;
begin

  if GetDocumentChargeKindsControlService = nil then begin

    raise TDomainException.Create(
      'Программная ошибка. Во время регистрации службы ' +
      'управления поручениями не найдена служба управления ' +
      'типами поручений'
    );
    
  end;

  RegisterDocumentChargeControlService(
    TStandardDocumentChargeControlService.Create(
      GetDocumentChargeKindsControlService
    )
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
