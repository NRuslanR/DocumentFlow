unit DocumentPerformingServiceRegistry;

interface

uses

  CreatingNecessaryDataForDocumentPerformingService,
  SendingDocumentToPerformingService,
  DocumentPerformingService,
  Document,
  TypeObjectRegistry,
  SysUtils;

type

  TDocumentPerformingServiceRegistry = class

    private

      class var FInstance: TDocumentPerformingServiceRegistry;

      class function GetInstance: TDocumentPerformingServiceRegistry; static;

    private

      FCreatingNecessaryDataForDocumentPerformingServiceRegistry: TTypeObjectRegistry;
      FSendingDocumentToPerformingServiceRegistry: TTypeObjectRegistry;
      FDocumentPerformingServiceRegistry: TTypeObjectRegistry;
      
    public

      procedure RegisterCreatingNecessaryDataForDocumentPerformingService(
        DocumentKind: TDocumentClass;
        CreatingNecessaryDataForDocumentPerformingService: ICreatingNecessaryDataForDocumentPerformingService
      );

      procedure RegisterStandardCreatingNecessaryDataForDocumentPerformingService(
        DocumentKind: TDocumentClass
      );

      function GetCreatingNecessaryDataForDocumentPerformingService(
        DocumentKind: TDocumentClass
      ): ICreatingNecessaryDataForDocumentPerformingService;

    public

      procedure RegisterSendingDocumentToPerformingService(
        DocumentKind: TDocumentClass;
        SendingDocumentToPerformingService: ISendingDocumentToPerformingService
      );

      procedure RegisterStandardSendingDocumentToPerformingService(
        DocumentKind: TDocumentClass
      );

      function GetSendingDocumentToPerformingService(
        DocumentKind: TDocumentClass
      ): ISendingDocumentToPerformingService;

    public
    
      procedure RegisterDocumentPerformingService(
        DocumentKind: TDocumentClass;
        DocumentPerformingService: IDocumentPerformingService
      );

      procedure RegisterStandardDocumentPerformingService(
        DocumentKind: TDocumentClass
      );

      function GetDocumentPerformingService(
        DocumentKind: TDocumentClass
      ): IDocumentPerformingService;
      
    public

      procedure RegisterAllStandardDocumentPerformingServices(
        DocumentKind: TDocumentClass
      );

    public

      destructor Destroy; override;
      constructor Create;

      class property Instance: TDocumentPerformingServiceRegistry
      read GetInstance;
      
  end;

implementation

uses

  IncomingDocument,
  PersonnelOrder,
  ServiceNote,
  StandardDocumentPerformingService,
  StandardCreatingNecessaryDataForDocumentPerformingService,
  StandardCreatingNecessaryDataForCrossDepartmentDocumentPerformingService,
  EmployeeSearchServiceRegistry,
  DocumentFormalizationServiceRegistry,
  DocumentChargeSheetsServiceRegistry,
  DocumentRegistrationServiceRegistry,
  DocumentRegistrationService,
  StandardSendingDocumentToPerformingService,
  CreatingNecessaryDataForCrossDepartmentDocumentPerformingService,
  StandardSendingCrossDepartmentDocumentToPerformingService,
  DocumentOperationServiceRegistry,
  DocumentStorageServiceRegistry,
  IncomingDocumentDirectory;


{ TDocumentPerformingServiceRegistry }

constructor TDocumentPerformingServiceRegistry.Create;
begin

  inherited;

  FCreatingNecessaryDataForDocumentPerformingServiceRegistry :=
    TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;

  FCreatingNecessaryDataForDocumentPerformingServiceRegistry
    .UseSearchByNearestAncestorTypeIfTargetObjectNotFound := True;

  FSendingDocumentToPerformingServiceRegistry :=
    TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;

  FDocumentPerformingServiceRegistry :=
    TTypeObjectRegistry.CreateInMemoryTypeObjectRegistry;
    
end;

destructor TDocumentPerformingServiceRegistry.Destroy;
begin

  FreeAndNil(FCreatingNecessaryDataForDocumentPerformingServiceRegistry);
  FreeAndNil(FSendingDocumentToPerformingServiceRegistry);
  FreeAndNil(FDocumentPerformingServiceRegistry);
  
  inherited;

end;

function TDocumentPerformingServiceRegistry.GetCreatingNecessaryDataForDocumentPerformingService(
  DocumentKind: TDocumentClass): ICreatingNecessaryDataForDocumentPerformingService;
begin

  Result :=
    ICreatingNecessaryDataForDocumentPerformingService(
      FCreatingNecessaryDataForDocumentPerformingServiceRegistry.GetInterface(
        DocumentKind
      )
    );
    
end;

function TDocumentPerformingServiceRegistry.GetDocumentPerformingService(
  DocumentKind: TDocumentClass
): IDocumentPerformingService;
begin

  Result :=
    IDocumentPerformingService(
      FDocumentPerformingServiceRegistry.GetInterface(DocumentKind)
    );
    
end;

class function TDocumentPerformingServiceRegistry.GetInstance: TDocumentPerformingServiceRegistry;
begin

  if not Assigned(FInstance) then
    FInstance := TDocumentPerformingServiceRegistry.Create;

  Result := FInstance;

end;

function TDocumentPerformingServiceRegistry.GetSendingDocumentToPerformingService(
  DocumentKind: TDocumentClass): ISendingDocumentToPerformingService;
begin

  Result :=
    ISendingDocumentToPerformingService(
      FSendingDocumentToPerformingServiceRegistry.GetInterface(
        DocumentKind
      )
    );
    
end;

procedure TDocumentPerformingServiceRegistry.RegisterCreatingNecessaryDataForDocumentPerformingService(
  DocumentKind: TDocumentClass;
  CreatingNecessaryDataForDocumentPerformingService: ICreatingNecessaryDataForDocumentPerformingService);
begin

  FCreatingNecessaryDataForDocumentPerformingServiceRegistry.RegisterInterface(
    DocumentKind,
    CreatingNecessaryDataForDocumentPerformingService
  );

end;

procedure TDocumentPerformingServiceRegistry.RegisterDocumentPerformingService(
  DocumentKind: TDocumentClass;
  DocumentPerformingService: IDocumentPerformingService
  );
begin

  FDocumentPerformingServiceRegistry.RegisterInterface(
    DocumentKind,
    DocumentPerformingService
  );
  
end;

procedure TDocumentPerformingServiceRegistry.RegisterSendingDocumentToPerformingService(
  DocumentKind: TDocumentClass;
  SendingDocumentToPerformingService: ISendingDocumentToPerformingService);
begin

  FSendingDocumentToPerformingServiceRegistry.RegisterInterface(
    DocumentKind, SendingDocumentToPerformingService
  );

end;

procedure TDocumentPerformingServiceRegistry.RegisterStandardCreatingNecessaryDataForDocumentPerformingService(
  DocumentKind: TDocumentClass
);
var
    IncomingDocumentType: TIncomingDocumentClass;
    IncomingDocumentRegistrationService: IDocumentRegistrationService;
    CreatingNecessaryDataForDocumentPerformingService: ICreatingNecessaryDataForDocumentPerformingService;
begin

  if DocumentKind.InheritsFrom(TIncomingDocument) then Exit;

  IncomingDocumentType := TIncomingDocumentClass(DocumentKind.IncomingDocumentType);

  if Assigned(IncomingDocumentType) then begin

    IncomingDocumentRegistrationService :=
      TDocumentRegistrationServiceRegistry.Instance.GetDocumentRegistrationService(
        IncomingDocumentType
      );

    if not Assigned(IncomingDocumentRegistrationService) then begin

      TDocumentRegistrationServiceRegistry.Instance.RegisterStandardDocumentRegistrationService(
        IncomingDocumentType
      );
      
    end;

    CreatingNecessaryDataForDocumentPerformingService :=
      TStandardCreatingNecessaryDataForCrossDepartmentDocumentPerformingService.Create(

        TDocumentChargeSheetsServiceRegistry.Instance.GetDocumentChargeSheetControlService(
          DocumentKind
        ),

        TDocumentRegistrationServiceRegistry.Instance.GetDocumentRegistrationService(
          DocumentKind.IncomingDocumentType
        ) ,

        TDocumentOperationServiceRegistry.Instance.GetIncomingDocumentCreatingService(
          TIncomingDocumentClass(DocumentKind.IncomingDocumentType)
        )

      );

  end

  else begin

    CreatingNecessaryDataForDocumentPerformingService :=
      TStandardCreatingNecessaryDataForDocumentPerformingService.Create(
        TDocumentChargeSheetsServiceRegistry.Instance.GetDocumentChargeSheetControlService(
          DocumentKind
        )
      );

  end;

  RegisterCreatingNecessaryDataForDocumentPerformingService(
    DocumentKind,
    CreatingNecessaryDataForDocumentPerformingService
  );

end;

procedure TDocumentPerformingServiceRegistry.RegisterStandardDocumentPerformingService(
  DocumentKind: TDocumentClass);
begin
                        
  RegisterDocumentPerformingService(
    DocumentKind,
    TStandardDocumentPerformingService.Create
  );
  
end;

procedure TDocumentPerformingServiceRegistry.
  RegisterStandardSendingDocumentToPerformingService(
    DocumentKind: TDocumentClass
  );
var
    CreatingNecessaryDataForDocumentPerformingService:  
      ICreatingNecessaryDataForDocumentPerformingService;

    IncomingDocumentType: TIncomingDocumentClass;
begin

  if DocumentKind.InheritsFrom(TIncomingDocument) then Exit;
    
  CreatingNecessaryDataForDocumentPerformingService :=
    GetCreatingNecessaryDataForDocumentPerformingService(DocumentKind);

  if not Assigned(CreatingNecessaryDataForDocumentPerformingService) then begin
  
    RegisterStandardCreatingNecessaryDataForDocumentPerformingService(DocumentKind);
    
  end;

  IncomingDocumentType := TIncomingDocumentClass(DocumentKind.IncomingDocumentType);

  if not Assigned(IncomingDocumentType) then begin

    RegisterSendingDocumentToPerformingService(
      DocumentKind,
      TStandardSendingDocumentToPerformingService.Create(
        GetCreatingNecessaryDataForDocumentPerformingService(DocumentKind),
        TDocumentChargeSheetsServiceRegistry.Instance.GetDocumentChargeSheetDirectory(DocumentKind)
      )
    );

  end

  else begin

    RegisterSendingDocumentToPerformingService(
      DocumentKind,
      TStandardSendingCrossDepartmentDocumentToPerformingService.Create(
        ICreatingNecessaryDataForCrossDepartmentDocumentPerformingService(
          GetCreatingNecessaryDataForDocumentPerformingService(DocumentKind)
        ),
        TDocumentChargeSheetsServiceRegistry.Instance.GetDocumentChargeSheetDirectory(DocumentKind),
        IIncomingDocumentDirectory(
          TDocumentStorageServiceRegistry.Instance.GetDocumentDirectory(
            DocumentKind.IncomingDocumentType
          )
        )
      )
    );
    
  end;

end;

procedure TDocumentPerformingServiceRegistry.RegisterAllStandardDocumentPerformingServices(
  DocumentKind: TDocumentClass);
begin

  RegisterStandardCreatingNecessaryDataForDocumentPerformingService(DocumentKind);
  RegisterStandardSendingDocumentToPerformingService(DocumentKind);
  RegisterStandardDocumentPerformingService(DocumentKind);
  
end;

end.
