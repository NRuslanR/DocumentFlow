unit DocumentApprovingServiceRegistry;

interface

uses

  DocumentApprovingFinder,
  DocumentApprovingCycleResultFinder,
  DocumentApprovingListCreatingService,
  DocumentApprovingSheetDataCreatingService,
  DocumentApprovingProcessControlService,
  DocumentApprovingsPicker,
  DocumentApprovingsCollector,
  Document,
  TypeObjectRegistry,
  SysUtils;

type

  TDocumentApprovingServiceRegistry = class

    private

      class var FInstance: TDocumentApprovingServiceRegistry;

      class function GetInstance: TDocumentApprovingServiceRegistry; static;

    private

      FApprovingFinderRegistry: TTypeObjectRegistry;
      FApprovingCycleResultFinderRegistry: TTypeObjectRegistry;
      FApprovingListCreatingServiceRegistry: TTypeObjectRegistry;
      FApprovingProcessControlServiceRegistry: TTypeObjectRegistry;
      FApprovingSheetDataCreatingService: TTypeObjectRegistry;

    public

      procedure RegisterDocumentApprovingFinder(
        DocumentKind: TDocumentClass;
        DocumentApprovingFinder: IDocumentApprovingFinder
      );

      function GetDocumentApprovingFinder(
        DocumentKind: TDocumentClass
      ): IDocumentApprovingFinder;

    public

      procedure RegisterDocumentApprovingCycleResultFinder(
        DocumentKind: TDocumentClass;
        DocumentApprovingCycleResultFinder: IDocumentApprovingCycleResultFinder
      );

      function GetDocumentApprovingCycleResultFinder(
        DocumentKind: TDocumentClass
      ): IDocumentApprovingCycleResultFinder;

    public

      procedure RegisterDocumentApprovingListCreatingService(
        DocumentKind: TDocumentClass;
        DocumentApprovingListCreatingService: IDocumentApprovingListCreatingService
      );

      procedure RegisterStandardDocumentApprovingListCreatingService(
        DocumentKind: TDocumentClass;
        DocumentApprovingsCollector: IDocumentApprovingsCollector = nil;
        DocumentApprovingsPicker: IDocumentApprovingsPicker = nil
      );

      function GetDocumentApprovingListCreatingService(
        DocumentKind: TDocumentClass
      ): IDocumentApprovingListCreatingService;

    public

      procedure RegisterDocumentApprovingProcessControlService(
        DocumentKind: TDocumentClass;
        DocumentApprovingProcessControlService: IDocumentApprovingProcessControlService
      );

      procedure RegisterStandardDocumentApprovingProcessControlService(
        DocumentKind: TDocumentClass
      );

      function GetDocumentApprovingProcessControlService(
        DocumentKind: TDocumentClass
      ): IDocumentApprovingProcessControlService;

    public

      procedure RegisterDocumentApprovingSheetDataCreatingService(
        DocumentKind: TDocumentClass;
        DocumentApprovingSheetDataCreatingService: IDocumentApprovingSheetDataCreatingService
      );

      procedure RegisterStandardDocumentApprovingSheetDataCreatingService(
        DocumnetKind: TDocumentClass;
        DocumentApprovingsCollector: IDocumentApprovingsCollector = nil;
        DocumentApprovingsPicker: IDocumentApprovingsPicker = nil
      );

      function GetDocumentApprovingSheetDataCreatingService(
        DocumentKind: TDocumentClass
      ): IDocumentApprovingSheetDataCreatingService;
      
    public

      procedure RegisterAllStandardDocumentApprovingServices(
        DocumentKind: TDocumentClass
      );
      
    public

      destructor Destroy; override;
      constructor Create;

      class property Instance: TDocumentApprovingServiceRegistry
      read GetInstance;
      
  end;

implementation

uses

  DocumentSearchServiceRegistry,
  DocumentApprovingRuleRegistry,
  DocumentFormalizationServiceRegistry,
  StandardDocumentApprovingsCollector,
  StandardDocumentApprovingListCreatingService,
  StandardDocumentApprovingSheetDataCreatingService,
  ToDocumentApprovingSheetApprovingsPicker,
  EmployeeDistributionServiceRegistry,
  StandardDocumentApprovingProcessControlService;
  
{ TDocumentApprovingServiceRegistry }

constructor TDocumentApprovingServiceRegistry.Create;
begin

  inherited;

  FApprovingFinderRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FApprovingCycleResultFinderRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FApprovingListCreatingServiceRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FApprovingProcessControlServiceRegistry := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  FApprovingSheetDataCreatingService := TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
  
  FApprovingFinderRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  FApprovingCycleResultFinderRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  FApprovingListCreatingServiceRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  FApprovingProcessControlServiceRegistry.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  FApprovingSheetDataCreatingService.UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;
  
end;

destructor TDocumentApprovingServiceRegistry.Destroy;
begin

  FreeAndNil(FApprovingCycleResultFinderRegistry);
  FreeAndNil(FApprovingListCreatingServiceRegistry);
  FreeAndNil(FApprovingProcessControlServiceRegistry);
  FreeAndNil(FApprovingFinderRegistry);
  FreeAndNil(FApprovingSheetDataCreatingService);
  
  inherited;

end;

function TDocumentApprovingServiceRegistry.GetDocumentApprovingCycleResultFinder(
  DocumentKind: TDocumentClass): IDocumentApprovingCycleResultFinder;
begin

  Result :=
    IDocumentApprovingCycleResultFinder(
      FApprovingCycleResultFinderRegistry.GetInterface(DocumentKind)
    );

end;

function TDocumentApprovingServiceRegistry.GetDocumentApprovingFinder(
  DocumentKind: TDocumentClass): IDocumentApprovingFinder;
begin

  Result :=
    IDocumentApprovingFinder(
      FApprovingFinderRegistry.GetInterface(DocumentKind)
    );
    
end;

function TDocumentApprovingServiceRegistry.GetDocumentApprovingListCreatingService(
  DocumentKind: TDocumentClass): IDocumentApprovingListCreatingService;
begin

  Result :=
    IDocumentApprovingListCreatingService(
      FApprovingListCreatingServiceRegistry.GetInterface(DocumentKind)
    );
    
end;

function TDocumentApprovingServiceRegistry.GetDocumentApprovingProcessControlService(
  DocumentKind: TDocumentClass): IDocumentApprovingProcessControlService;
begin

  Result :=
    IDocumentApprovingProcessControlService(
      FApprovingProcessControlServiceRegistry.GetInterface(DocumentKind)
    );
    
end;

function TDocumentApprovingServiceRegistry.GetDocumentApprovingSheetDataCreatingService(
  DocumentKind: TDocumentClass): IDocumentApprovingSheetDataCreatingService;
begin

  Result :=
    IDocumentApprovingSheetDataCreatingService(
      FApprovingSheetDataCreatingService.GetInterface(DocumentKind)
    );
    
end;

class function TDocumentApprovingServiceRegistry.GetInstance: TDocumentApprovingServiceRegistry;
begin

  if not Assigned(FInstance) then
    FInstance := TDocumentApprovingServiceRegistry.Create;

  Result := FInstance;

end;

procedure TDocumentApprovingServiceRegistry.RegisterDocumentApprovingCycleResultFinder(
  DocumentKind: TDocumentClass;
  DocumentApprovingCycleResultFinder: IDocumentApprovingCycleResultFinder);
begin

  FApprovingCycleResultFinderRegistry.RegisterInterface(
    DocumentKind,
    DocumentApprovingCycleResultFinder
  );

end;

procedure TDocumentApprovingServiceRegistry.RegisterDocumentApprovingFinder(
  DocumentKind: TDocumentClass;
  DocumentApprovingFinder: IDocumentApprovingFinder);
begin

  FApprovingFinderRegistry.RegisterInterface(
    DocumentKind,
    DocumentApprovingFinder
  );
  
end;

procedure TDocumentApprovingServiceRegistry.RegisterDocumentApprovingListCreatingService(
  DocumentKind: TDocumentClass;
  DocumentApprovingListCreatingService: IDocumentApprovingListCreatingService);
begin

  FApprovingListCreatingServiceRegistry.RegisterInterface(
    DocumentKind,
    DocumentApprovingListCreatingService
  );
  
end;

procedure TDocumentApprovingServiceRegistry.RegisterDocumentApprovingProcessControlService(
  DocumentKind: TDocumentClass;
  DocumentApprovingProcessControlService: IDocumentApprovingProcessControlService);
begin

  FApprovingProcessControlServiceRegistry.RegisterInterface(
    DocumentKind,
    DocumentApprovingProcessControlService
  );

end;

procedure TDocumentApprovingServiceRegistry.RegisterDocumentApprovingSheetDataCreatingService(
  DocumentKind: TDocumentClass;
  DocumentApprovingSheetDataCreatingService: IDocumentApprovingSheetDataCreatingService
);
begin

  FApprovingSheetDataCreatingService.RegisterInterface(
    DocumentKind,
    DocumentApprovingSheetDataCreatingService
  );
  
end;

procedure TDocumentApprovingServiceRegistry.RegisterStandardDocumentApprovingListCreatingService(
  DocumentKind: TDocumentClass;
  DocumentApprovingsCollector: IDocumentApprovingsCollector;
  DocumentApprovingsPicker: IDocumentApprovingsPicker
);
begin

  if not Assigned(DocumentApprovingsPicker) then begin

    DocumentApprovingsPicker := TToDocumentApprovingSheetApprovingsPicker.Create;

  end;

  if not Assigned(DocumentApprovingsCollector) then begin

    DocumentApprovingsCollector :=
      TStandardDocumentApprovingsCollector.Create(
        TDocumentSearchServiceRegistry.Instance.GetDocumentFinder(DocumentKind),
        TDocumentApprovingServiceRegistry.Instance.GetDocumentApprovingCycleResultFinder(DocumentKind)
      );
      
  end;

  RegisterDocumentApprovingListCreatingService(
    DocumentKind,
    TStandardDocumentApprovingListCreatingService.Create(
      DocumentApprovingsCollector,
      DocumentApprovingsPicker,
      TEmployeeDistributionServiceRegistry.Instance.GetDepartmentEmployeeDistributionService
    )
  );
  
end;

procedure TDocumentApprovingServiceRegistry.RegisterStandardDocumentApprovingProcessControlService(
  DocumentKind: TDocumentClass);
begin

  RegisterDocumentApprovingProcessControlService(
    DocumentKind,
    TStandardDocumentApprovingProcessControlService.Create(
      TDocumentApprovingRuleRegistry.Instance.GetDocumentApproverListChangingRule(DocumentKind),
      TDocumentFormalizationServiceRegistry.Instance.GetDocumentFullNameCompilationService,
      TDocumentApprovingRuleRegistry.Instance.GetDocumentApprovingPassingMarkingRule(DocumentKind),
      GetDocumentApprovingCycleResultFinder(DocumentKind)
    )
  );
  
end;

procedure TDocumentApprovingServiceRegistry.RegisterStandardDocumentApprovingSheetDataCreatingService(
  DocumnetKind: TDocumentClass;
  DocumentApprovingsCollector: IDocumentApprovingsCollector;
  DocumentApprovingsPicker: IDocumentApprovingsPicker
);
begin

  if not Assigned(DocumentApprovingsCollector) then begin

    DocumentApprovingsCollector :=
      TStandardDocumentApprovingsCollector.Create(
        TDocumentSearchServiceRegistry.Instance.GetDocumentFinder(DocumnetKind),
        TDocumentApprovingServiceRegistry.Instance.GetDocumentApprovingCycleResultFinder(DocumnetKind)
      );
      
  end;

  if not Assigned(DocumentApprovingsPicker) then
    DocumentApprovingsPicker := TToDocumentApprovingSheetApprovingsPicker.Create;
  
  RegisterDocumentApprovingSheetDataCreatingService(
    DocumnetKind,
    TStandardDocumentApprovingSheetDataCreatingService.Create(
      DocumentApprovingsCollector,
      DocumentApprovingsPicker
    )
  );

end;

procedure TDocumentApprovingServiceRegistry.RegisterAllStandardDocumentApprovingServices(
  DocumentKind: TDocumentClass);
begin

  RegisterStandardDocumentApprovingListCreatingService(DocumentKind);
  RegisterStandardDocumentApprovingProcessControlService(DocumentKind);
  RegisterStandardDocumentApprovingSheetDataCreatingService(DocumentKind);

end;

end.
