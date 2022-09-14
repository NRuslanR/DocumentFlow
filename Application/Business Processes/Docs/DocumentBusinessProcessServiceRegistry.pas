{ refactor: добавить исследование ключа
  на наследуемость, comparator }
unit DocumentBusinessProcessServiceRegistry;

interface

uses

  DocumentKinds,
  _ApplicationServiceRegistry,
  SendingDocumentToSigningService,
  SendingDocumentToPerformingAppService,
  DocumentSigningAppService,
  DocumentSigningRejectingService,
  DocumentApprovingService,
  DocumentApprovingRejectingService,
  DocumentChargeSheetControlAppService,
  DocumentStorageService,
  DocumentApprovingControlAppService,
  RespondingDocumentCreatingAppService,
  EmployeeDocumentKindAccessRightsAppService,
  SendingDocumentToApprovingService,
  RelatedDocumentStorageService,
  DocumentChargeKindsControlAppService,
  ApplicationService,
  DocumentSigningMarkingAppService,
  SysUtils,
  Classes;

type

  TDocumentBusinessProcessServiceRegistry = class (TApplicationServiceRegistry)

    private

      FDocumentApprovingServiceRegistry: TApplicationServiceRegistry;
      FDocumentApprovingRejectingServiceRegistry: TApplicationServiceRegistry;
      FDocumentApprovingControlAppServiceRegistry: TApplicationServiceRegistry;
      FDocumentSigningAppServiceRegistry: TApplicationServiceRegistry;
      FDocumentSigningMarkingAppServiceRegistry: TApplicationServiceRegistry;
      FDocumentSigningRejectingServiceRegistry: TApplicationServiceRegistry;
      FSendingDocumentToApprovingServiceRegistry: TApplicationServiceRegistry;
      FSendingDocumentToPerformingAppServiceRegistry: TApplicationServiceRegistry;
      FDocumentChargeSheetControlAppServiceRegistry: TApplicationServiceRegistry;
      FDocumentStorageServiceRegistry: TApplicationServiceRegistry;
      FRelatedDocumentStorageServiceRegistry: TApplicationServiceRegistry;
      FRespondingDocumentCreatingAppServiceRegistry: TApplicationServiceRegistry;
      
    public

      destructor Destroy; override;
      constructor Create; override;

      procedure AddServiceNames(ServiceNames: TStrings); override;
      
      procedure RegisterSendingDocumentToApprovingService(
        DocumentKind: TDocumentKindClass;
        SendingDocumentToApprovingService: ISendingDocumentToApprovingService
      );
      
      procedure RegisterSendingDocumentToSigningService(
        DocumentKind: TDocumentKindClass;
        SendingDocumentToSigningService: ISendingDocumentToSigningService
      );

      procedure RegisterDocumentApprovingService(
        DocumentKind: TDocumentKindClass;
        DocumentApprovingService: IDocumentApprovingService
      );

      procedure RegisterDocumentApprovingRejectingService(
        DocumentKind: TDocumentKindClass;
        DocumentApprovingRejectingService: IDocumentApprovingRejectingService
      );

      procedure RegisterDocumentApprovingControlAppService(
        DocumentKind: TDocumentKindClass;
        DocumentApprovingControlAppService: IDocumentApprovingControlAppService
      );

      procedure RegisterDocumentSigningAppService(
        DocumentKind: TDocumentKindClass;
        DocumentSigningAppService: IDocumentSigningAppService
      );

      procedure RegisterDocumentSigningMarkingAppService(
        DocumentKind: TDocumentKindClass;
        DocumentSigningMarkingAppService: IDocumentSigningMarkingAppService
      );

      procedure RegisterDocumentSigningRejectingService(
        DocumentKind: TDocumentKindClass;
        DocumentSigningRejectingService: IDocumentSigningRejectingService
      );

      procedure RegisterSendingDocumentToPerformingAppService(
        DocumentKind: TDocumentKindClass;
        SendingDocumentToPerformingAppService: ISendingDocumentToPerformingAppService
      );

      procedure RegisterDocumentChargeSheetControlAppService(
        DocumentKind: TDocumentKindClass;
        DocumentChargeSheetControlService: IDocumentChargeSheetControlAppService
      );

      procedure RegisterDocumentStorageService(
        DocumentKind: TDocumentKindClass;
        DocumentStorageService: IDocumentStorageService
      );

      procedure RegisterRelatedDocumentStorageService(
        DocumentKind: TDocumentKindClass;
        DocumentStorageService: IRelatedDocumentStorageService
      );
      
      procedure RegisterEmployeeDocumentKindAccessRightsAppService(
        EmployeeDocumentKindAccessRightsAppService:
          IEmployeeDocumentKindAccessRightsAppService
      );

      procedure RegisterRespondingDocumentCreatingAppService(
        DocumentKind: TDocumentKindClass;
        RespondingDocumentCreatingAppService: IRespondingDocumentCreatingAppService
      );

      procedure RegisterDocumentChargeKindsControlAppService(
        DocumentChargeKindsControlAppService: IDocumentChargeKindsControlAppService
      );
      
    public

      function GetSendingDocumentToApprovingService(
        DocumentKind: TDocumentKindClass
      ): ISendingDocumentToApprovingService;
      
      function GetSendingDocumentToSigningService(
        DocumentKind: TDocumentKindClass
      ): ISendingDocumentToSigningService;

      function GetDocumentApprovingService(
        DocumentKind: TDocumentKindClass
      ): IDocumentApprovingService;

      function GetDocumentApprovingRejectingService(
        DocumentKind: TDocumentKindClass
      ): IDocumentApprovingRejectingService;

      function GetDocumentApprovingControlAppService(
        DocumentKind: TDocumentKindClass
      ): IDocumentApprovingControlAppService;

      function GetDocumentSigningAppService(
        DocumentKind: TDocumentKindClass
      ): IDocumentSigningAppService;

      function GetDocumentSigningMarkingAppService(
        DocumentKind: TDocumentKindClass
      ): IDocumentSigningMarkingAppService;

      function GetDocumentSigningRejectingService(
        DocumentKind: TDocumentKindClass
      ): IDocumentSigningRejectingService;

      function GetSendingDocumentToPerformingAppService(
        DocumentKind: TDocumentKindClass
      ): ISendingDocumentToPerformingAppService;

      function GetDocumentChargeSheetControlAppService(
        DocumentKind: TDocumentKindClass
      ): IDocumentChargeSheetControlAppService;

      function GetDocumentStorageService(
        DocumentKind: TDocumentKindClass
      ): IDocumentStorageService;

      function GetRelatedDocumentStorageService(
        DocumentKind: TDocumentKindClass
      ): IRelatedDocumentStorageService;

      function GetEmployeeDocumentKindAccessRightsAppService:
        IEmployeeDocumentKindAccessRightsAppService;

      function GetRespondingDocumentCreatingAppService(
        DocumentKind: TDocumentKindClass
      ): IRespondingDocumentCreatingAppService;

      function GetDocumentChargeKindsControlAppService: IDocumentChargeKindsControlAppService;
      
  end;

implementation

type

  TEmployeeDocumentKindAccessRightsAppServiceType = class

  end;

  TDocumentChargeKindsControlAppServiceType = class

  end;

{ TDocumentBusinessProcessServiceRegistry }

procedure TDocumentBusinessProcessServiceRegistry.AddServiceNames(
  ServiceNames: TStrings);
begin

  inherited;

  FSendingDocumentToApprovingServiceRegistry.AddServiceNames(ServiceNames);
  FDocumentApprovingServiceRegistry.AddServiceNames(ServiceNames);
  FDocumentApprovingRejectingServiceRegistry.AddServiceNames(ServiceNames);
  FDocumentApprovingControlAppServiceRegistry.AddServiceNames(ServiceNames);
  FDocumentSigningAppServiceRegistry.AddServiceNames(ServiceNames);
  FDocumentSigningMarkingAppServiceRegistry.AddServiceNames(ServiceNames);
  FDocumentSigningRejectingServiceRegistry.AddServiceNames(ServiceNames);
  FSendingDocumentToPerformingAppServiceRegistry.AddServiceNames(ServiceNames);
  FDocumentChargeSheetControlAppServiceRegistry.AddServiceNames(ServiceNames);
  FDocumentStorageServiceRegistry.AddServiceNames(ServiceNames);
  FRelatedDocumentStorageServiceRegistry.AddServiceNames(ServiceNames);
  FRespondingDocumentCreatingAppServiceRegistry.AddServiceNames(ServiceNames);
  
end;

constructor TDocumentBusinessProcessServiceRegistry.Create;
begin

  inherited;

  FSendingDocumentToApprovingServiceRegistry := TApplicationServiceRegistry.Create;
  FDocumentApprovingServiceRegistry := TApplicationServiceRegistry.Create;
  FDocumentApprovingRejectingServiceRegistry := TApplicationServiceRegistry.Create;
  FDocumentApprovingControlAppServiceRegistry := TApplicationServiceRegistry.Create;
  FDocumentSigningAppServiceRegistry := TApplicationServiceRegistry.Create;
  FDocumentSigningMarkingAppServiceRegistry := TApplicationServiceRegistry.Create;
  FDocumentSigningRejectingServiceRegistry := TApplicationServiceRegistry.Create;
  FSendingDocumentToPerformingAppServiceRegistry := TApplicationServiceRegistry.Create;
  FDocumentChargeSheetControlAppServiceRegistry := TApplicationServiceRegistry.Create;
  FDocumentStorageServiceRegistry := TApplicationServiceRegistry.Create;
  FRelatedDocumentStorageServiceRegistry := TApplicationServiceRegistry.Create;
  FRespondingDocumentCreatingAppServiceRegistry := TApplicationServiceRegistry.Create;

end;

destructor TDocumentBusinessProcessServiceRegistry.Destroy;
begin

  FreeAndNil(FSendingDocumentToApprovingServiceRegistry);
  FreeAndNil(FDocumentApprovingServiceRegistry);
  FreeAndNil(FDocumentApprovingRejectingServiceRegistry);
  FreeAndNil(FDocumentApprovingControlAppServiceRegistry);
  FreeAndNil(FDocumentSigningAppServiceRegistry);
  FreeAndNil(FDocumentSigningMarkingAppServiceRegistry);
  FreeAndNil(FDocumentSigningRejectingServiceRegistry);
  FreeAndNil(FDocumentChargeSheetControlAppServiceRegistry);
  FreeAndNil(FDocumentStorageServiceRegistry);
  FreeAndNil(FRelatedDocumentStorageServiceRegistry);
  FreeAndNil(FRespondingDocumentCreatingAppServiceRegistry);
  
  inherited;

end;

function TDocumentBusinessProcessServiceRegistry.
  GetDocumentApprovingControlAppService(
    DocumentKind: TDocumentKindClass
  ): IDocumentApprovingControlAppService;
begin

  Result :=
    IDocumentApprovingControlAppService(
      FDocumentApprovingControlAppServiceRegistry.GetApplicationService(
        DocumentKind
      )
    );
  
end;

function TDocumentBusinessProcessServiceRegistry.
  GetDocumentApprovingRejectingService(
    DocumentKind: TDocumentKindClass
  ): IDocumentApprovingRejectingService;
begin

  Result :=
    IDocumentApprovingRejectingService(
      FDocumentApprovingRejectingServiceRegistry.GetApplicationService(
        DocumentKind
      )
    );
    
end;

function TDocumentBusinessProcessServiceRegistry.
  GetDocumentApprovingService(
    DocumentKind: TDocumentKindClass
  ): IDocumentApprovingService;
begin

  Result :=
    IDocumentApprovingService(
      FDocumentApprovingServiceRegistry.GetApplicationService(DocumentKind)
    );
    
end;

function TDocumentBusinessProcessServiceRegistry.GetDocumentChargeKindsControlAppService: IDocumentChargeKindsControlAppService;
begin

  Result :=
    IDocumentChargeKindsControlAppService(
      GetApplicationService(TDocumentChargeKindsControlAppServiceType)
    );
    
end;

function TDocumentBusinessProcessServiceRegistry.GetDocumentChargeSheetControlAppService(
  DocumentKind: TDocumentKindClass): IDocumentChargeSheetControlAppService;
begin

  Result :=
    IDocumentChargeSheetControlAppService(
      FDocumentChargeSheetControlAppServiceRegistry.GetApplicationService(
        DocumentKind
      )
    );

end;

function TDocumentBusinessProcessServiceRegistry.GetDocumentSigningRejectingService(
  DocumentKind: TDocumentKindClass): IDocumentSigningRejectingService;
begin

  Result :=
    IDocumentSigningRejectingService(
      FDocumentSigningRejectingServiceRegistry.GetApplicationService(
        DocumentKind
      )
    );
    
end;

function TDocumentBusinessProcessServiceRegistry.GetDocumentSigningAppService(
  DocumentKind: TDocumentKindClass): IDocumentSigningAppService;
begin

  Result :=
    IDocumentSigningAppService(
      FDocumentSigningAppServiceRegistry.GetApplicationService(
        DocumentKind
      )
    );
    
end;

function TDocumentBusinessProcessServiceRegistry.GetDocumentSigningMarkingAppService(
  DocumentKind: TDocumentKindClass): IDocumentSigningMarkingAppService;
begin

  Result :=
    IDocumentSigningMarkingAppService(
      FDocumentSigningMarkingAppServiceRegistry.GetApplicationService(
        DocumentKind
      )
    );
    
end;

function TDocumentBusinessProcessServiceRegistry.GetDocumentStorageService(
  DocumentKind: TDocumentKindClass): IDocumentStorageService;
begin

  Result :=
    IDocumentStorageService(
      FDocumentStorageServiceRegistry.GetApplicationService(
        DocumentKind
      )
  );
  
end;

function TDocumentBusinessProcessServiceRegistry.
  GetEmployeeDocumentKindAccessRightsAppService: IEmployeeDocumentKindAccessRightsAppService;
begin

  Result :=
    IEmployeeDocumentKindAccessRightsAppService(
      GetApplicationService(TEmployeeDocumentKindAccessRightsAppServiceType)
    );
    
end;

function TDocumentBusinessProcessServiceRegistry.GetRespondingDocumentCreatingAppService(
  DocumentKind: TDocumentKindClass
): IRespondingDocumentCreatingAppService;
begin

  Result :=
    IRespondingDocumentCreatingAppService(
      FRespondingDocumentCreatingAppServiceRegistry.GetApplicationService(
        DocumentKind
      )
    );

end;

function TDocumentBusinessProcessServiceRegistry.GetRelatedDocumentStorageService(
  DocumentKind: TDocumentKindClass): IRelatedDocumentStorageService;
begin

  Result :=
    IRelatedDocumentStorageService(
      FRelatedDocumentStorageServiceRegistry.GetApplicationService(
        DocumentKind
      )
    );
    
end;

function TDocumentBusinessProcessServiceRegistry.GetSendingDocumentToApprovingService(
  DocumentKind: TDocumentKindClass): ISendingDocumentToApprovingService;
begin

  Result :=
    ISendingDocumentToApprovingService(
      FSendingDocumentToApprovingServiceRegistry.GetApplicationService(
        DocumentKind
      )
    );

end;

function TDocumentBusinessProcessServiceRegistry.GetSendingDocumentToPerformingAppService(
  DocumentKind: TDocumentKindClass): ISendingDocumentToPerformingAppService;
begin

  Result :=
    ISendingDocumentToPerformingAppService(
      FSendingDocumentToPerformingAppServiceRegistry.GetApplicationService(
        DocumentKind
      )
    );
    
end;

function TDocumentBusinessProcessServiceRegistry.GetSendingDocumentToSigningService(
  DocumentKind: TDocumentKindClass): ISendingDocumentToSigningService;
begin

  Result :=
    ISendingDocumentToSigningService(
      GetApplicationService(DocumentKind)
    );
    
end;

procedure TDocumentBusinessProcessServiceRegistry.RegisterDocumentApprovingControlAppService(
  DocumentKind: TDocumentKindClass;
  DocumentApprovingControlAppService: IDocumentApprovingControlAppService);
begin

  FDocumentApprovingControlAppServiceRegistry.RegisterApplicationService(
    DocumentKind,
    DocumentApprovingControlAppService
  );
  
end;

procedure TDocumentBusinessProcessServiceRegistry.RegisterDocumentApprovingRejectingService(
  DocumentKind: TDocumentKindClass;
  DocumentApprovingRejectingService: IDocumentApprovingRejectingService);
begin

  FDocumentApprovingRejectingServiceRegistry.RegisterApplicationService(
    DocumentKind,
    DocumentApprovingRejectingService
  );
  
end;

procedure TDocumentBusinessProcessServiceRegistry.RegisterDocumentApprovingService(
  DocumentKind: TDocumentKindClass;
  DocumentApprovingService: IDocumentApprovingService);
begin

  FDocumentApprovingServiceRegistry.RegisterApplicationService(
    DocumentKind,
    DocumentApprovingService
  );
  
end;

procedure TDocumentBusinessProcessServiceRegistry.RegisterDocumentChargeKindsControlAppService(
  DocumentChargeKindsControlAppService: IDocumentChargeKindsControlAppService);
begin

  RegisterApplicationService(
    TDocumentChargeKindsControlAppServiceType,
    DocumentChargeKindsControlAppService
  );
  
end;

procedure TDocumentBusinessProcessServiceRegistry.RegisterDocumentChargeSheetControlAppService(
  DocumentKind: TDocumentKindClass;
  DocumentChargeSheetControlService: IDocumentChargeSheetControlAppService);
begin

  FDocumentChargeSheetControlAppServiceRegistry.RegisterApplicationService(
    DocumentKind,
    DocumentChargeSheetControlService
  );
  
end;

procedure TDocumentBusinessProcessServiceRegistry.RegisterDocumentSigningRejectingService(
  DocumentKind: TDocumentKindClass;
  DocumentSigningRejectingService: IDocumentSigningRejectingService);
begin

  FDocumentSigningRejectingServiceRegistry.RegisterApplicationService(
    DocumentKind,
    DocumentSigningRejectingService
  );
  
end;

procedure TDocumentBusinessProcessServiceRegistry.RegisterDocumentSigningAppService(
  DocumentKind: TDocumentKindClass;
  DocumentSigningAppService: IDocumentSigningAppService
);
begin

  FDocumentSigningAppServiceRegistry.RegisterApplicationService(
    DocumentKind,
    DocumentSigningAppService
  );

end;

procedure TDocumentBusinessProcessServiceRegistry.RegisterDocumentSigningMarkingAppService(
  DocumentKind: TDocumentKindClass;
  DocumentSigningMarkingAppService: IDocumentSigningMarkingAppService);
begin

  FDocumentSigningMarkingAppServiceRegistry.RegisterApplicationService(
    DocumentKind,
    DocumentSigningMarkingAppService
  );
  
end;

procedure TDocumentBusinessProcessServiceRegistry.RegisterDocumentStorageService(
  DocumentKind: TDocumentKindClass; DocumentStorageService: IDocumentStorageService);
begin

  FDocumentStorageServiceRegistry.RegisterApplicationService(
    DocumentKind,
    DocumentStorageService
  );
  
end;

procedure TDocumentBusinessProcessServiceRegistry.
  RegisterEmployeeDocumentKindAccessRightsAppService(
    EmployeeDocumentKindAccessRightsAppService:
      IEmployeeDocumentKindAccessRightsAppService
  );
begin

  RegisterApplicationService(
    TEmployeeDocumentKindAccessRightsAppServiceType,
    EmployeeDocumentKindAccessRightsAppService
  );
  
end;

procedure TDocumentBusinessProcessServiceRegistry.RegisterRelatedDocumentStorageService(
  DocumentKind: TDocumentKindClass;
  DocumentStorageService: IRelatedDocumentStorageService
);
begin

  FRelatedDocumentStorageServiceRegistry.RegisterApplicationService(
    DocumentKind,
    DocumentStorageService
  );
  
end;

procedure TDocumentBusinessProcessServiceRegistry.RegisterRespondingDocumentCreatingAppService(
  DocumentKind: TDocumentKindClass;
  RespondingDocumentCreatingAppService: IRespondingDocumentCreatingAppService
);
begin

  FRespondingDocumentCreatingAppServiceRegistry.RegisterApplicationService(
    DocumentKind,
    RespondingDocumentCreatingAppService
  );

end;

procedure TDocumentBusinessProcessServiceRegistry.
  RegisterSendingDocumentToApprovingService(
    DocumentKind: TDocumentKindClass;
    SendingDocumentToApprovingService: ISendingDocumentToApprovingService
  );
begin

  FSendingDocumentToApprovingServiceRegistry.RegisterApplicationService(
    DocumentKind,
    SendingDocumentToApprovingService
  );

end;

procedure TDocumentBusinessProcessServiceRegistry.RegisterSendingDocumentToPerformingAppService(
  DocumentKind: TDocumentKindClass;
  SendingDocumentToPerformingAppService: ISendingDocumentToPerformingAppService);
begin

  FSendingDocumentToPerformingAppServiceRegistry.RegisterApplicationService(
    DocumentKind,
    SendingDocumentToPerformingAppService
  );
  
end;

procedure TDocumentBusinessProcessServiceRegistry.RegisterSendingDocumentToSigningService(
  DocumentKind: TDocumentKindClass;
  SendingDocumentToSigningService: ISendingDocumentToSigningService);
begin

  RegisterApplicationService(
    DocumentKind,
    SendingDocumentToSigningService
  );
  
end;

end.
