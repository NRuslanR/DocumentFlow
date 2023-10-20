unit StandardDocumentChargeSheetControlService;

interface

uses

  DocumentChargeSheetControlService,
  DocumentChargeSheetAccessRights,
  DocumentChargeSheetAccessRightsService,
  Document,
  IDocumentUnit,                        
  DocumentChargeInterface,
  IDocumentChargeSheetUnit,
  DocumentChargeSheet,
  DocumentDirectory,
  EmployeeIsSameAsOrReplacingForOthersSpecification,
  DocumentFullNameCompilationService,
  EmployeeSubordinationService,
  DocumentChargeSheetOverlappingPerformingService,
  EmployeeChargeIssuingRule,
  DocumentChargeSheetPerformingResult,
  DepartmentEmployeeDistributionSpecification,
  DocumentChargeSheetControlPerformingService,
  DocumentPerformingService,
  DocumentChargeSheetCreatingService,
  DocumentChargeSheetDirectory,
  DocumentChargeSheetRemovingService,
  DocumentChargeKind,
  DocumentKind,
  DocumentKindFinder,
  DocumentChargeKindsControlService,
  DomainObjectValueUnit,
  Employee,
  VariantListUnit,
  SysUtils,
  Classes;

type
  
  TStandardDocumentChargeSheetControlService =
    class (TInterfacedObject, IDocumentChargeSheetControlService)

      protected

        FDocumentKindFinder: IDocumentKindFinder;
        FDocumentChargeKindsControlService: IDocumentChargeKindsControlService;
        FDocumentChargeSheetDirectory: IDocumentChargeSheetDirectory;
        FDocumentChargeSheetRemovingService: IDocumentChargeSheetRemovingService;
        FDocumentPerformingService: IDocumentPerformingService;
        FDocumentChargeSheetControlPerformingService: IDocumentChargeSheetControlPerformingService;

      protected

        procedure EnsureEmployeeMayViewChargeSheet(
          Employee: TEmployee;
          ChargeSheet: IDocumentChargeSheet
        );

        function GetChargeSheetCreatingServiceForOrRaise(
          Document: IDocument;
          const ChargeKindId: Variant;
          const ErrorMsg: String = ''
        ): IDocumentChargeSheetCreatingService; overload;

        function GetChargeSheetCreatingServiceForOrRaise(
          Document: IDocument;
          Performer: TEmployee;
          const ErrorMsg: String = ''
        ): IDocumentChargeSheetCreatingService; overload;

      public

        constructor Create(
          DocumentKindFinder: IDocumentKindFinder;
          DocumentChargeKindsControlService: IDocumentChargeKindsControlService;
          DocumentChargeSheetDirectory: IDocumentChargeSheetDirectory;
          DocumentChargeSheetRemovingService: IDocumentChargeSheetRemovingService;
          DocumentPerformingService: IDocumentPerformingService;
          DocumentChargeSheetControlPerformingService: IDocumentChargeSheetControlPerformingService
        );

        function GetChargeSheets(
          Employee: TEmployee;
          const ChargeSheetIds: TVariantList
        ): TDocumentChargeSheets;

        function GetChargeSheet(
          Employee: TEmployee;
          const ChargeSheetId: Variant
        ): IDocumentChargeSheet; overload;

        procedure GetChargeSheet(
          Employee: TEmployee;
          const ChargeSheetId: Variant;
          var ChargeSheet: IDocumentChargeSheet;
          var AccessRights: TDocumentChargeSheetAccessRights
        ); overload;

        procedure CreateHeadChargeSheet(
          Document: IDocument;
          Performer: TEmployee;
          IssuingEmployee: TEmployee;
          var ChargeSheet: IDocumentChargeSheet;
          var AccessRights: TDocumentChargeSheetAccessRights
        ); overload;

        procedure CreateSubordinateChargeSheet(
          Document: IDocument;
          Performer: TEmployee;
          IssuingEmployee: TEmployee;
          TopLevelChargeSheet: IDocumentChargeSheet;
          var ChargeSheet: IDocumentChargeSheet;
          var AccessRights: TDocumentChargeSheetAccessRights
        ); overload;

        procedure CreateHeadChargeSheet(
          const ChargeKindId: Variant;
          Document: IDocument;
          Performer: TEmployee;
          IssuingEmployee: TEmployee;
          var ChargeSheet: IDocumentChargeSheet;
          var AccessRights: TDocumentChargeSheetAccessRights
        ); overload;

        procedure CreateSubordinateChargeSheet(
          const ChargeKindId: Variant;
          Document: IDocument;
          Performer: TEmployee;
          IssuingEmployee: TEmployee;
          TopLevelChargeSheet: IDocumentChargeSheet;
          var ChargeSheet: IDocumentChargeSheet;
          var AccessRights: TDocumentChargeSheetAccessRights
        ); overload;

        procedure SaveChargeSheets(
          Employee: TEmployee;
          ChargeSheets: TDocumentChargeSheets
        ); virtual;

        function PerformChargeSheet(
          Employee: TEmployee;
          ChargeSheet: IDocumentChargeSheet
        ): TDocumentChargeSheetPerformingResult; virtual;

        function PerformChargeSheets(
          Employee: TEmployee;
          ChargeSheets: TDocumentChargeSheets
        ): TDocumentChargeSheetPerformingResult; virtual;

        procedure RemoveChargeSheets(
          Employee: TEmployee;
          ChargeSheets: TDocumentChargeSheets
        ); virtual;

    end;

implementation

uses

  AuxDebugFunctionsUnit,
  DocumentStorageServiceRegistry,
  DomainRegistries,            
  IDomainObjectBaseListUnit,
  Variants,
  DocumentCharges,
  StrUtils,
  DocumentsDomainRegistries,
  DocumentChargeSheetsServiceRegistry,
  DocumentRuleRegistry,
  IDomainObjectBaseUnit,
  DocumentChargeSheetRuleRegistry;

{ TStandardDocumentChargeSheetControlService }

constructor TStandardDocumentChargeSheetControlService.Create(
  DocumentKindFinder: IDocumentKindFinder;
  DocumentChargeKindsControlService: IDocumentChargeKindsControlService;
  DocumentChargeSheetDirectory: IDocumentChargeSheetDirectory;
  DocumentChargeSheetRemovingService: IDocumentChargeSheetRemovingService;
  DocumentPerformingService: IDocumentPerformingService;
  DocumentChargeSheetControlPerformingService: IDocumentChargeSheetControlPerformingService
    
);
begin

  inherited Create;

  FDocumentKindFinder := DocumentKindFinder;
  FDocumentChargeKindsControlService := DocumentChargeKindsControlService;
  FDocumentChargeSheetDirectory := DocumentChargeSheetDirectory;
  FDocumentChargeSheetRemovingService := DocumentChargeSheetRemovingService;
  FDocumentPerformingService := DocumentPerformingService;
  FDocumentChargeSheetControlPerformingService := DocumentChargeSheetControlPerformingService;

end;

procedure TStandardDocumentChargeSheetControlService.CreateHeadChargeSheet(
  const ChargeKindId: Variant;
  Document: IDocument;
  Performer, IssuingEmployee: TEmployee;
  var ChargeSheet: IDocumentChargeSheet;
  var AccessRights: TDocumentChargeSheetAccessRights
);
begin

  GetChargeSheetCreatingServiceForOrRaise(Document, ChargeKindId)
    .CreateHeadDocumentChargeSheet(
      ChargeKindId, Document, IssuingEmployee,
      Performer, ChargeSheet, AccessRights
    );

end;

procedure TStandardDocumentChargeSheetControlService.CreateHeadChargeSheet(
  Document: IDocument;
  Performer, IssuingEmployee: TEmployee;
  var ChargeSheet: IDocumentChargeSheet;
  var AccessRights: TDocumentChargeSheetAccessRights
);
begin

  GetChargeSheetCreatingServiceForOrRaise(Document, Performer)
    .CreateHeadDocumentChargeSheet(
      Document, IssuingEmployee, Performer, ChargeSheet, AccessRights
    );

end;

procedure TStandardDocumentChargeSheetControlService.CreateSubordinateChargeSheet(
  Document: IDocument;
  Performer, IssuingEmployee: TEmployee;
  TopLevelChargeSheet: IDocumentChargeSheet;
  var ChargeSheet: IDocumentChargeSheet;
  var AccessRights: TDocumentChargeSheetAccessRights
);
begin

  GetChargeSheetCreatingServiceForOrRaise(Document, Performer)
    .CreateSubordinateDocumentChargeSheet(
      TopLevelChargeSheet,
      Document,
      IssuingEmployee,
      Performer,
      ChargeSheet,
      AccessRights
    );

end;

procedure TStandardDocumentChargeSheetControlService.CreateSubordinateChargeSheet(
  const ChargeKindId: Variant;
  Document: IDocument;
  Performer, IssuingEmployee: TEmployee;
  TopLevelChargeSheet: IDocumentChargeSheet;
  var ChargeSheet: IDocumentChargeSheet;
  var AccessRights: TDocumentChargeSheetAccessRights
);
begin

  GetChargeSheetCreatingServiceForOrRaise(Document, ChargeKindId)
    .CreateSubordinateDocumentChargeSheet(
      ChargeKindId,
      TopLevelChargeSheet,
      Document,
      IssuingEmployee,
      Performer,
      ChargeSheet,
      AccessRights
    );

end;

procedure TStandardDocumentChargeSheetControlService.EnsureEmployeeMayViewChargeSheet(
  Employee: TEmployee;
  ChargeSheet: IDocumentChargeSheet
);
var
    ChargeSheetObj: TDocumentChargeSheet;
begin

  {
    refactor (TStandardDocumentChargeSheetControlService, 1):
    extract the assigning WorkingRules to separate object and
    inject it to DocumentChargeSheetCreatingService and this service
  }

  ChargeSheetObj := TDocumentChargeSheet(ChargeSheet.Self);
  
  ChargeSheetObj
    .WorkingRules
      .DocumentChargeSheetViewingRule
        .EnsureThatIsSatisfiedFor(Employee, ChargeSheet);
    
end;

function TStandardDocumentChargeSheetControlService.GetChargeSheet(
  Employee: TEmployee;
  const ChargeSheetId: Variant
): IDocumentChargeSheet;
begin

  Result :=
    FDocumentChargeSheetDirectory.FindDocumentChargeSheetById(ChargeSheetId);

  if not Assigned(Result) then Exit;

  EnsureEmployeeMayViewChargeSheet(Employee, Result);
  
end;

procedure TStandardDocumentChargeSheetControlService.
  GetChargeSheet(
    Employee: TEmployee;
    const ChargeSheetId: Variant;
    var ChargeSheet: IDocumentChargeSheet;
    var AccessRights: TDocumentChargeSheetAccessRights
  );
var
    ChargeSheetAccessRightsService: IDocumentChargeSheetAccessRightsService;
begin

  ChargeSheet :=
    GetChargeSheet(Employee, ChargeSheetId);

  ChargeSheetAccessRightsService :=
    TDocumentChargeSheetsServiceRegistry
      .Instance
        .GetDocumentChargeSheetAccessRightsService(
          TDocumentChargeSheet(ChargeSheet.Self).ClassType
        );
        
  AccessRights :=
    ChargeSheetAccessRightsService
      .EnsureEmployeeHasDocumentChargeSheetAccessRights(
        Employee, ChargeSheet
      );
  
end;

function TStandardDocumentChargeSheetControlService.GetChargeSheetCreatingServiceForOrRaise(
  Document: IDocument;
  const ChargeKindId: Variant;
  const ErrorMsg: String
): IDocumentChargeSheetCreatingService;
var
    ChargeKind: TDocumentChargeKind;
    Free: IDomainObjectBase;
begin

  ChargeKind := FDocumentChargeKindsControlService.FindDocumentChargeKindById(ChargeKindId);

  if Assigned(ChargeKind) then begin

    Free := ChargeKind;

    Result :=
       TDocumentChargeSheetsServiceRegistry
        .Instance
          .GetDocumentChargeSheetCreatingService(
            TDocumentChargeSheetClass(ChargeKind.ChargeClass.ChargeSheetType),
            TDocument(Document.Self).ClassType
          );

  end

  else Result := nil;

  if not Assigned(Result) then begin

    raise TDocumentChargeSheetControlServiceException.Create(
      IfThen(
        ErrorMsg <> '',
        ErrorMsg,
        'Ќе найден служба создани€ листов поручений ' +
        'дл€ требуемого типа'
      )
    );

  end;

end;

function TStandardDocumentChargeSheetControlService.GetChargeSheetCreatingServiceForOrRaise(
  Document: IDocument;
  Performer: TEmployee;
  const ErrorMsg: String
): IDocumentChargeSheetCreatingService;
var
    Charge: IDocumentCharge;
begin

  Charge := Document.FindChargeByPerformerOrActuallyPerformedEmployee(Performer);

  if Assigned(Charge) then begin

    Result :=
      TDocumentChargeSheetsServiceRegistry
        .Instance
          .GetDocumentChargeSheetCreatingService(
            TDocumentChargeSheetClass(TDocumentCharge(Charge.Self).ChargeSheetType),
            TDocument(Document.Self).ClassType
          );

  end

  else Result := nil;

  if not Assigned(Result) then begin

    raise TDocumentChargeSheetControlServiceException.Create(
      IfThen(
        ErrorMsg <> '',
        ErrorMsg,
        'Ќе найдена служба создани€ листов поручений ' +
        'дл€ требуемого исполнител€'
      )
    );
    
  end;


end;

function TStandardDocumentChargeSheetControlService.GetChargeSheets(
  Employee: TEmployee;
  const ChargeSheetIds: TVariantList
): TDocumentChargeSheets;
var
    ChargeSheet: IDocumentChargeSheet;
begin

  Result :=
    FDocumentChargeSheetDirectory
      .FindDocumentChargeSheetsByIds(ChargeSheetIds);

  if not Assigned(Result) then Exit;

  for ChargeSheet in Result do
    EnsureEmployeeMayViewChargeSheet(Employee, ChargeSheet);

end;

function TStandardDocumentChargeSheetControlService.
  PerformChargeSheet(
    Employee: TEmployee;
    ChargeSheet: IDocumentChargeSheet
  ): TDocumentChargeSheetPerformingResult;
begin

  Result :=
    FDocumentChargeSheetControlPerformingService
      .PerformChargeSheet(ChargeSheet, Employee);

end;

function TStandardDocumentChargeSheetControlService.PerformChargeSheets(
  Employee: TEmployee;
  ChargeSheets: TDocumentChargeSheets
): TDocumentChargeSheetPerformingResult;
begin

  Result :=
    FDocumentChargeSheetControlPerformingService
      .PerformChargeSheets(ChargeSheets, Employee);
      
end;

procedure TStandardDocumentChargeSheetControlService.RemoveChargeSheets(
  Employee: TEmployee;
  ChargeSheets: TDocumentChargeSheets
);
begin

  FDocumentChargeSheetRemovingService.RemoveChargeSheets(
    Employee, ChargeSheets
  );
  
end;

procedure TStandardDocumentChargeSheetControlService.SaveChargeSheets(
  Employee: TEmployee;
  ChargeSheets: TDocumentChargeSheets
);

  procedure RaiseExceptionIfChargeSheetsAreNotBelongsToDocument(
    Employee: TEmployee;
    ChargeSheets: TDocumentChargeSheets
  );
  begin

    if ChargeSheets.IsEmpty then Exit;

    if not ChargeSheets.AreBelongsToDocument(ChargeSheets.First.DocumentId)
    then begin
    
      Raise TDocumentChargeSheetControlServiceException.Create(
        'Ќевозможно сохранить изменени€ по поручени€м, не относ€щимс€ ' +
        'к данному документу'
      );

    end;

  end;
  
  procedure ExtractNewAndChangedChargeSheets(
    ChargeSheets: TDocumentChargeSheets;
    var NewDocumentChargeSheets: TDocumentChargeSheets;
    var ChangedDocumentChargeSheets: TDocumentChargeSheets
  );
  var
      ChargeSheet: IDocumentChargeSheet;
      ChargeSheetObj: TDocumentChargeSheet;
  begin

    NewDocumentChargeSheets := TDocumentChargeSheets.Create;
    ChangedDocumentChargeSheets := TDocumentChargeSheets.Create;

    try

      for ChargeSheet in ChargeSheets do begin

        ChargeSheetObj := TDocumentChargeSheet(ChargeSheet.Self);

        if not ChargeSheetObj.IsIdentityAssigned then
          NewDocumentChargeSheets.AddDocumentChargeSheet(ChargeSheet)

        else ChangedDocumentChargeSheets.AddDocumentChargeSheet(ChargeSheet);

      end;

    except

      FreeAndNil(NewDocumentChargeSheets);
      FreeAndNil(ChangedDocumentChargeSheets);

    end;

  end;

  procedure SaveNewDocumentChargesIfNecessary(
    Employee: TEmployee;
    NewChargeSheets: TDocumentChargeSheets
  );
  var
      NewHeadChargeSheets: TDocumentChargeSheets;
      FreeNewHeadChargeSheets: TDocumentChargeSheets;
      ChargeSheet: IDocumentChargeSheet;

      DocumentKind: TDocumentKind;
      FreeDocumentKind: IDomainObjectBase;
      
      DocumentDirectory: IDocumentDirectory;

      Document: IDocument;
      DocumentObj: TDocument;

      NewDocumentChargesAdded: Boolean;
  begin

    NewHeadChargeSheets := TDocumentChargeSheets.Create;

    FreeNewHeadChargeSheets := NewHeadChargeSheets;

    for ChargeSheet in ChargeSheets do begin

      if ChargeSheet.IsHead then
        NewHeadChargeSheets.AddDocumentChargeSheet(ChargeSheet);
        
    end;

    if NewHeadChargeSheets.IsEmpty then Exit;

    DocumentKind :=
      FDocumentKindFinder.FindDocumentKindByIdentity(
        NewHeadChargeSheets.First.DocumentKindId
      );

    if not Assigned(DocumentKind) then begin

      Raise TDocumentChargeSheetControlServiceException.Create(
        'Ќе найден тип документа при сохранении новых поручений'
      );

    end;
    
    FreeDocumentKind := DocumentKind;

    { refactor: inject IDocumentDirectoryRegsitry }

    DocumentDirectory :=
      TDocumentStorageServiceRegistry.Instance.GetOriginalDocumentDirectory(
        DocumentKind.DocumentClass
      );

    if not Assigned(DocumentDirectory) then begin

      Raise TDocumentChargeSheetControlServiceException.Create(
        'Ќе найден каталог документов во врем€ сохранени€ ' +
        'изменений по поручени€м'
      );

    end;

    Document :=
      DocumentDirectory.FindDocumentById(NewHeadChargeSheets.First.DocumentId);

    DocumentObj := TDocument(Document.Self);

    NewDocumentChargesAdded := False;

    DocumentObj.InvariantsComplianceRequested := False;

    DocumentObj.EditingEmployee := Employee;

    DocumentObj.InvariantsComplianceRequested := True;

    for ChargeSheet in NewHeadChargeSheets do begin

      if Document.Charges.IsEmployeeAssignedAsPerformer(Employee)
      then Continue;

      Document.AddCharge(ChargeSheet.Charge);

      NewDocumentChargesAdded := True;

    end;

    if NewDocumentChargesAdded then
      DocumentDirectory.ModifyDocument(TDocument(Document.Self));

  end;
  
var
    NewDocumentChargeSheets: TDocumentChargeSheets;
    ChangedDocumentChargeSheets: TDocumentChargeSheets;
begin

  RaiseExceptionIfChargeSheetsAreNotBelongsToDocument(
    Employee, ChargeSheets
  );

  ExtractNewAndChangedChargeSheets(
    ChargeSheets, NewDocumentChargeSheets, ChangedDocumentChargeSheets
  );

  SaveNewDocumentChargesIfNecessary(Employee, NewDocumentChargeSheets);
  
  FDocumentChargeSheetDirectory.PutDocumentChargeSheets(NewDocumentChargeSheets);
  FDocumentChargeSheetDirectory.ModifyDocumentChargeSheets(ChangedDocumentChargeSheets);

end;

end.
