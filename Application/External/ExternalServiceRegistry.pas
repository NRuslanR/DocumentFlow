unit ExternalServiceRegistry;

interface

uses

  DocumentKinds,
  DocumentChargeSheetCasesNotifier,
  IDocumentFileServiceClientUnit,
  LoodsmanDocumentsUploadingService,
  _ApplicationServiceRegistry,
  SysUtils,
  Classes;

type

  TExternalServiceRegistry = class (TApplicationServiceRegistry)

    private

      FDocumentChargeSheetCasesNotifierRegistry: TApplicationServiceRegistry;
      FLoodsmanDocumentsUploadingServiceRegistry: TApplicationServiceRegistry;
      
    public

      procedure AddServiceNames(ServiceNames: TStrings); override;

      destructor Destroy; override;
      constructor Create; override;

    public

      procedure RegisterDocumentFileServiceClient(
        DocumentKind: TDocumentKindClass;
        DocumentFileServiceClient: IDocumentFileServiceClient
      );

      function GetDocumentFileServiceClient(
        DocumentKind: TDocumentKindClass
      ): IDocumentFileServiceClient;


    public

      procedure RegisterDocumentChargeSheetCasesNotifier(
        DocumentKind: TDocumentKindClass;
        DocumentChargeSheetCasesNotifier: IDocumentChargeSheetCasesNotifier
      );

      function GetDocumentChargeSheetCasesNotifier(
        DocumentKind: TDocumentKindClass
      ): IDocumentChargeSheetCasesNotifier;

    public

      procedure RegisterLoodsmanDocumentsUploadingService(
        DocumentKind: TDocumentKindClass;
        LoodsmanDocumentsUploadingService: ILoodsmanDocumentsUploadingService
      );

      function GetLoodsmanDocumentsUploadingService(
        DocumentKind: TDocumentKindClass
      ): ILoodsmanDocumentsUploadingService;

  end;

implementation

{ TExternalServiceRegistry }

procedure TExternalServiceRegistry.AddServiceNames(ServiceNames: TStrings);
begin

  inherited;

  FDocumentChargeSheetCasesNotifierRegistry.AddServiceNames(ServiceNames);

end;

constructor TExternalServiceRegistry.Create;
begin

  FDocumentChargeSheetCasesNotifierRegistry :=
    TApplicationServiceRegistry.Create;

  FDocumentChargeSheetCasesNotifierRegistry
    .UseSearchByNearestAncestorTypeIfTargetServiceNotFound := False;


  FLoodsmanDocumentsUploadingServiceRegistry :=
    TApplicationServiceRegistry.Create;


  FLoodsmanDocumentsUploadingServiceRegistry
    .UseSearchByNearestAncestorTypeIfTargetServiceNotFound := False;

  inherited;

end;

destructor TExternalServiceRegistry.Destroy;
begin

  FreeAndNil(FDocumentChargeSheetCasesNotifierRegistry);
  FreeAndNil(FLoodsmanDocumentsUploadingServiceRegistry);
  
  inherited;

end;

function TExternalServiceRegistry.GetDocumentChargeSheetCasesNotifier(
  DocumentKind: TDocumentKindClass): IDocumentChargeSheetCasesNotifier;
begin

  Result :=
    IDocumentChargeSheetCasesNotifier(
      FDocumentChargeSheetCasesNotifierRegistry.GetApplicationService(
        DocumentKind
      )
    );
    
end;

function TExternalServiceRegistry.GetDocumentFileServiceClient(
  DocumentKind: TDocumentKindClass): IDocumentFileServiceClient;
begin

  Result :=
    IDocumentFileServiceClient(
      GetApplicationService(DocumentKind)
    );

end;

procedure TExternalServiceRegistry.RegisterDocumentChargeSheetCasesNotifier(
  DocumentKind: TDocumentKindClass;
  DocumentChargeSheetCasesNotifier: IDocumentChargeSheetCasesNotifier);
begin

  FDocumentChargeSheetCasesNotifierRegistry.RegisterApplicationService(
    DocumentKind,
    DocumentChargeSheetCasesNotifier
  );
  
end;

procedure TExternalServiceRegistry.RegisterDocumentFileServiceClient(
  DocumentKind: TDocumentKindClass;
  DocumentFileServiceClient: IDocumentFileServiceClient);
begin

  RegisterApplicationService(
    DocumentKind,
    DocumentFileServiceClient
  );

end;

procedure TExternalServiceRegistry.RegisterLoodsmanDocumentsUploadingService(
  DocumentKind: TDocumentKindClass;
  LoodsmanDocumentsUploadingService: ILoodsmanDocumentsUploadingService);
begin

  FLoodsmanDocumentsUploadingServiceRegistry.RegisterApplicationService(
    DocumentKind,
    LoodsmanDocumentsUploadingService
  );

end;

function TExternalServiceRegistry.GetLoodsmanDocumentsUploadingService(
  DocumentKind: TDocumentKindClass): ILoodsmanDocumentsUploadingService;
begin

  Result :=
    ILoodsmanDocumentsUploadingService(
      FLoodsmanDocumentsUploadingServiceRegistry.GetApplicationService(
        DocumentKind
      )
    );

end;

end.
