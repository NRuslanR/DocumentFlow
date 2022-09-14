unit AccountingServiceRegistry;

interface                                          

uses

  _ApplicationServiceRegistry,
  DocumentViewingAccountingService,
  DocumentChargeSheetViewingAccountingService,
  DocumentKinds,
  SysUtils,
  Classes;

type

  TAccountingServiceRegistry = class (TApplicationServiceRegistry)

    private

      FDocumentChargeSheetViewingAccountingServiceRegistry: TApplicationServiceRegistry;

    public

      destructor Destroy; override;
      constructor Create;

    public

      procedure RegisterDocumentViewingAccountingService(
        DocumentKind: TDocumentKindClass;
        DocumentViewingAccountingService: IDocumentViewingAccountingService
      );

      function GetDocumentViewingAccountingService(
        DocumentKind: TDocumentKindClass
      ): IDocumentViewingAccountingService;

    public

      procedure RegisterDocumentChargeSheetViewingAccountingService(
        AccountingService: IDocumentChargeSheetViewingAccountingService
      );

      function GetDocumentChargeSheetViewingAccountingService: IDocumentChargeSheetViewingAccountingService;

  end;


implementation

{ TAccountingServiceRegistry }

constructor TAccountingServiceRegistry.Create;
begin

  inherited;

  FDocumentChargeSheetViewingAccountingServiceRegistry :=
    TApplicationServiceRegistry.Create;

  FDocumentChargeSheetViewingAccountingServiceRegistry
    .UseSearchByNearestAncestorTypeIfTargetServiceNotFound := True;

end;

destructor TAccountingServiceRegistry.Destroy;
begin

  FreeAndNil(FDocumentChargeSheetViewingAccountingServiceRegistry);
  
  inherited;

end;

function TAccountingServiceRegistry.GetDocumentViewingAccountingService(
  DocumentKind: TDocumentKindClass): IDocumentViewingAccountingService;
begin

  Result :=
    IDocumentViewingAccountingService(
      GetApplicationService(DocumentKind)
    );
    
end;

procedure TAccountingServiceRegistry.RegisterDocumentViewingAccountingService(
  DocumentKind: TDocumentKindClass;
  DocumentViewingAccountingService: IDocumentViewingAccountingService
);
begin

  RegisterApplicationService(
    DocumentKind,
    DocumentViewingAccountingService
  );
  
end;

procedure TAccountingServiceRegistry.RegisterDocumentChargeSheetViewingAccountingService(
  AccountingService: IDocumentChargeSheetViewingAccountingService
);
begin

  FDocumentChargeSheetViewingAccountingServiceRegistry
    .RegisterApplicationService(
      TDocumentKind,
      AccountingService
    );

end;

function TAccountingServiceRegistry.GetDocumentChargeSheetViewingAccountingService:
  IDocumentChargeSheetViewingAccountingService;
begin

  Result :=
    IDocumentChargeSheetViewingAccountingService(
      FDocumentChargeSheetViewingAccountingServiceRegistry.GetApplicationService(
        TDocumentKind
      )
    );

end;

end.

