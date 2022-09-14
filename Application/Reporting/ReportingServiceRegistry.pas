unit ReportingServiceRegistry;

interface

uses

  _ApplicationServiceRegistry,
  ApplicationService,
  NotPerformedDocumentsReportDataService,
  DocumentApprovingListCreatingAppService,
  DocumentApprovingSheetDataCreatingAppService,
  DocumentKinds,
  SysUtils,
  Classes;

type

  TReportingServiceRegistry = class (TApplicationServiceRegistry)

    private

      FDocumentApprovingListCreatingAppServiceRegistry: TApplicationServiceRegistry;
      FDocumentApprovingSheetDataCreatingAppService: TApplicationServiceRegistry;

    public

      procedure AddServiceNames(ServiceNames: TStrings); override;

    public

      destructor Destroy; override;
      constructor Create; override;

      procedure RegisterNotPerformedDocumentsReportDataService(
        NotPerformedDocumentsReportDataService:
          INotPerformedDocumentsReportDataService
      );

      function GetNotPerformedDocumentsReportDataService:
        INotPerformedDocumentsReportDataService;

    public

      procedure RegisterDocumentApprovingListCreatingAppService(

        DocumentKind: TDocumentKindClass;

        DocumentApprovingListCreatingAppService:
          IDocumentApprovingListCreatingAppService
      );

      function GetDocumentApprovingListCreatingAppService(
        DocumentKind: TDocumentKindClass
      ): IDocumentApprovingListCreatingAppService;

    public

      procedure RegisterDocumentApprovingSheetDataCreatingAppService(
        DocumentKind: TDocumentKindClass;
        DocumentApprovingSheetDataCreatingAppService: IDocumentApprovingSheetDataCreatingAppService
      );

      function GetDocumentApprovingSheetDataCreatingAppService(
        DocumentKind: TDocumentKindClass
      ): IDocumentApprovingSheetDataCreatingAppService;

  end;
  
implementation

uses

  Variants;
  
type

  TReportingServiceType = class

  end;

  TNotPerformedDocumentsReportingServiceType = class (TReportingServiceType)

  end;


  TDocumentApprovingListCreatingAppServiceType = class (TReportingServiceType)

    
  end;
  
{ TReportingServiceRegistry }

procedure TReportingServiceRegistry.AddServiceNames(ServiceNames: TStrings);
begin

  inherited;

  FDocumentApprovingListCreatingAppServiceRegistry.AddServiceNames(ServiceNames);
  FDocumentApprovingSheetDataCreatingAppService.AddServiceNames(ServiceNames);
  
end;

constructor TReportingServiceRegistry.Create;
begin

  inherited;

  FDocumentApprovingListCreatingAppServiceRegistry := TApplicationServiceRegistry.Create;
  FDocumentApprovingSheetDataCreatingAppService := TApplicationServiceRegistry.Create;

end;

destructor TReportingServiceRegistry.Destroy;
begin

  FreeAndNil(FDocumentApprovingListCreatingAppServiceRegistry);
  FreeAndNil(FDocumentApprovingSheetDataCreatingAppService);
  
  inherited;

end;

function TReportingServiceRegistry.
  GetDocumentApprovingListCreatingAppService(
    DocumentKind: TDocumentKindClass
  ): IDocumentApprovingListCreatingAppService;
begin

  Result :=
    IDocumentApprovingListCreatingAppService(
      FDocumentApprovingListCreatingAppServiceRegistry.GetApplicationService(
        DocumentKind
      )
    );

end;

function TReportingServiceRegistry.GetDocumentApprovingSheetDataCreatingAppService(
  DocumentKind: TDocumentKindClass): IDocumentApprovingSheetDataCreatingAppService;
begin

  Result :=
    IDocumentApprovingSheetDataCreatingAppService(
      FDocumentApprovingSheetDataCreatingAppService.GetApplicationService(
        DocumentKind
      )
    );

end;

function TReportingServiceRegistry.GetNotPerformedDocumentsReportDataService: INotPerformedDocumentsReportDataService;
begin

  Result :=
    INotPerformedDocumentsReportDataService(
      GetApplicationService(TNotPerformedDocumentsReportingServiceType)
    );
            
end;

procedure TReportingServiceRegistry.
RegisterDocumentApprovingListCreatingAppService(
  DocumentKind: TDocumentKindClass;
  DocumentApprovingListCreatingAppService:
    IDocumentApprovingListCreatingAppService
);
begin

  FDocumentApprovingListCreatingAppServiceRegistry.RegisterApplicationService(
    DocumentKind,
    DocumentApprovingListCreatingAppService
  );

end;

procedure TReportingServiceRegistry.RegisterDocumentApprovingSheetDataCreatingAppService(
  DocumentKind: TDocumentKindClass;
  DocumentApprovingSheetDataCreatingAppService: IDocumentApprovingSheetDataCreatingAppService);
begin

  FDocumentApprovingSheetDataCreatingAppService.RegisterApplicationService(
    DocumentKind,
    DocumentApprovingSheetDataCreatingAppService
  );
  
end;

procedure TReportingServiceRegistry.
  RegisterNotPerformedDocumentsReportDataService(
    NotPerformedDocumentsReportDataService:
      INotPerformedDocumentsReportDataService
  );
begin

  RegisterApplicationService(
    TNotPerformedDocumentsReportingServiceType,
    NotPerformedDocumentsReportDataService
  );
  
end;

end.
