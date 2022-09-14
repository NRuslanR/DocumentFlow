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
  DomainObjectValueUnit,
  Employee,
  VariantListUnit,
  SysUtils,
  Classes;

type
  
  TStandardDocumentChargeSheetControlService =
    class (TInterfacedObject, IDocumentChargeSheetControlService)

      protected

        FDocumentChargeSheetDirectory: IDocumentChargeSheetDirectory;

        FDocumentChargeSheetCreatingService: IDocumentChargeSheetCreatingService;
        FDocumentChargeSheetRemovingService: IDocumentChargeSheetRemovingService;

        FDocumentPerformingService: IDocumentPerformingService;
        FDocumentChargeSheetControlPerformingService: IDocumentChargeSheetControlPerformingService;

        FDocumentChargeSheetAccessRightsService: IDocumentChargeSheetAccessRightsService;

      protected

        procedure EnsureEmployeeMayViewChargeSheet(
          Employee: TEmployee;
          ChargeSheet: IDocumentChargeSheet;
          Document: IDocument
        );
        
      public

        constructor Create(
          DocumentChargeSheetDirectory: IDocumentChargeSheetDirectory;

          DocumentChargeSheetCreatingService: IDocumentChargeSheetCreatingService;
          DocumentChargeSheetRemovingService: IDocumentChargeSheetRemovingService;

          DocumentPerformingService: IDocumentPerformingService;
          DocumentChargeSheetControlPerformingService: IDocumentChargeSheetControlPerformingService;

          DocumentChargeSheetAccessRightsService: IDocumentChargeSheetAccessRightsService
        );

        function GetChargeSheets(
          Document: IDocument;
          Employee: TEmployee;
          const ChargeSheetIds: TVariantList
        ): TDocumentChargeSheets;

        function GetChargeSheet(
          Document: IDocument;
          Employee: TEmployee;
          const ChargeSheetId: Variant
        ): IDocumentChargeSheet; overload;

        procedure GetChargeSheet(
          Document: IDocument;
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
          ChargeSheets: TDocumentChargeSheets;
          Document: IDocument
        ); virtual;

        function PerformChargeSheet(
          Employee: TEmployee;
          ChargeSheet: IDocumentChargeSheet;
          Document: IDocument
        ): TDocumentChargeSheetPerformingResult; virtual;

        function PerformChargeSheets(
          Employee: TEmployee;
          ChargeSheets: TDocumentChargeSheets;
          Document: IDocument
        ): TDocumentChargeSheetPerformingResult; virtual;

        procedure RemoveChargeSheets(
          Employee: TEmployee;
          ChargeSheets: TDocumentChargeSheets;
          Document: IDocument
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
  DocumentsDomainRegistries,
  DocumentRuleRegistry,
  IDomainObjectBaseUnit,
  DocumentChargeSheetChangingEnsurer,
  DocumentChargeSheetPerformingEnsurer,
  DocumentChargeSheetRuleRegistry;

{ TStandardDocumentChargeSheetControlService }

constructor TStandardDocumentChargeSheetControlService.Create(

  DocumentChargeSheetDirectory: IDocumentChargeSheetDirectory;

  DocumentChargeSheetCreatingService: IDocumentChargeSheetCreatingService;
  DocumentChargeSheetRemovingService: IDocumentChargeSheetRemovingService;

  DocumentPerformingService: IDocumentPerformingService;
  DocumentChargeSheetControlPerformingService: IDocumentChargeSheetControlPerformingService;

  DocumentChargeSheetAccessRightsService: IDocumentChargeSheetAccessRightsService
    
);
begin

  inherited Create;

  FDocumentChargeSheetDirectory := DocumentChargeSheetDirectory;

  FDocumentChargeSheetCreatingService := DocumentChargeSheetCreatingService;
  FDocumentChargeSheetRemovingService := DocumentChargeSheetRemovingService;
  
  FDocumentPerformingService := DocumentPerformingService;
  FDocumentChargeSheetControlPerformingService := DocumentChargeSheetControlPerformingService;

  FDocumentChargeSheetAccessRightsService := DocumentChargeSheetAccessRightsService;
  
end;

procedure TStandardDocumentChargeSheetControlService.CreateHeadChargeSheet(
  const ChargeKindId: Variant;
  Document: IDocument;
  Performer, IssuingEmployee: TEmployee;
  var ChargeSheet: IDocumentChargeSheet;
  var AccessRights: TDocumentChargeSheetAccessRights
);
begin

  FDocumentChargeSheetCreatingService
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

  FDocumentChargeSheetCreatingService.CreateHeadDocumentChargeSheet(
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

  FDocumentChargeSheetCreatingService.CreateSubordinateDocumentChargeSheet(
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

  FDocumentChargeSheetCreatingService.CreateSubordinateDocumentChargeSheet(
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
  ChargeSheet: IDocumentChargeSheet;
  Document: IDocument
);
var
    ChargeSheetObj: TDocumentChargeSheet;
begin

  {
    refactor (TStandardDocumentChargeSheetControlService, 1):
    extract the assigning WorkingRules and Ensurers to separate object and
    inject it to DocumentChargeSheetCreatingService and this service
  }

  ChargeSheetObj := TDocumentChargeSheet(ChargeSheet.Self);
  
  ChargeSheetObj
    .WorkingRules
      .DocumentChargeSheetViewingRule
        .EnsureThatIsSatisfiedFor(Employee, ChargeSheet, Document);

  ChargeSheetObj.ChangingEnsurer :=
    TDocumentChargeSheetChangingEnsurer.Create(Document);

  ChargeSheetObj.PerformingEnsurer :=
    TDocumentChargeSheetPerformingEnsurer.Create(Document);
    
end;

function TStandardDocumentChargeSheetControlService.GetChargeSheet(
  Document: IDocument;
  Employee: TEmployee;
  const ChargeSheetId: Variant
): IDocumentChargeSheet;
begin

  Result :=
    FDocumentChargeSheetDirectory.FindDocumentChargeSheetById(ChargeSheetId);

  if not Assigned(Result) then Exit;

  EnsureEmployeeMayViewChargeSheet(Employee, Result, Document);
  
end;

procedure TStandardDocumentChargeSheetControlService.
  GetChargeSheet(
    Document: IDocument;
    Employee: TEmployee;
    const ChargeSheetId: Variant;
    var ChargeSheet: IDocumentChargeSheet;
    var AccessRights: TDocumentChargeSheetAccessRights
  );
begin

  ChargeSheet :=
    GetChargeSheet(Document, Employee, ChargeSheetId);
    
  AccessRights :=
    FDocumentChargeSheetAccessRightsService
      .EnsureEmployeeHasDocumentChargeSheetAccessRights(
        Employee, ChargeSheet, Document
      );
  
end;

function TStandardDocumentChargeSheetControlService.GetChargeSheets(
  Document: IDocument;
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
    EnsureEmployeeMayViewChargeSheet(Employee, ChargeSheet, Document);

end;

function TStandardDocumentChargeSheetControlService.
  PerformChargeSheet(
    Employee: TEmployee;
    ChargeSheet: IDocumentChargeSheet;
    Document: IDocument
  ): TDocumentChargeSheetPerformingResult;
begin

  Result :=
    FDocumentChargeSheetControlPerformingService
      .PerformChargeSheet(ChargeSheet, Document, Employee);

end;

function TStandardDocumentChargeSheetControlService.PerformChargeSheets(
  Employee: TEmployee;
  ChargeSheets: TDocumentChargeSheets;
  Document: IDocument
): TDocumentChargeSheetPerformingResult;
begin

  Result :=
    FDocumentChargeSheetControlPerformingService
      .PerformChargeSheets(ChargeSheets, Document, Employee);
      
end;

procedure TStandardDocumentChargeSheetControlService.RemoveChargeSheets(
  Employee: TEmployee;
  ChargeSheets: TDocumentChargeSheets;
  Document: IDocument
);
begin

  FDocumentChargeSheetRemovingService.RemoveChargeSheets(
    Employee, ChargeSheets, Document
  );
  
end;

procedure TStandardDocumentChargeSheetControlService.SaveChargeSheets(
  Employee: TEmployee;
  ChargeSheets: TDocumentChargeSheets;
  Document: IDocument
);

  procedure RaiseExceptionIfChargeSheetsAreNotBelongsToDocument(
    Employee: TEmployee;
    ChargeSheets: TDocumentChargeSheets;
    Document: IDocument
  );
  begin

    if not ChargeSheets.AreBelongsToDocument(Document.Identity) then begin
    
      Raise TDocumentChargeSheetControlServiceException.Create(
        'Невозможно сохранить изменения по поручениям, не относящимся ' +
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
      ChargeSheetObj: TDocumentChargeSheet ;
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
    Document: IDocument;
    NewChargeSheets: TDocumentChargeSheets
  );
  var
      DocumentDirectory: IDocumentDirectory;
      NewHeadChargeSheetsFound: Boolean;
      ChargeSheet: IDocumentChargeSheet;
  begin

    NewHeadChargeSheetsFound := False;

    for ChargeSheet in ChargeSheets do begin

      if not ChargeSheet.IsHead then Continue;

      if
        not
        Document.Charges.IsEmployeeAssignedAsPerformer(ChargeSheet.Performer)
      then begin

        if Document.EditingEmployee <> Employee then
          Document.EditingEmployee := Employee;

        Document.AddCharge(ChargeSheet.Charge);

        NewHeadChargeSheetsFound := True;

      end;
      
    end;
      
    DocumentDirectory :=
      TDocumentStorageServiceRegistry.Instance.GetOriginalDocumentDirectory(
        TDocument(Document.Self).ClassType
      );

    if not Assigned(DocumentDirectory) then begin

      Raise TDocumentChargeSheetControlServiceException.Create(
        'Не найден каталог документов во время сохранения ' +
        'изменений по поручениям'
      );

    end;

    DocumentDirectory.ModifyDocument(TDocument(Document.Self));

  end;
  
var
    NewDocumentChargeSheets: TDocumentChargeSheets;
    ChangedDocumentChargeSheets: TDocumentChargeSheets;
begin

  RaiseExceptionIfChargeSheetsAreNotBelongsToDocument(
    Employee, ChargeSheets, Document
  );

  ExtractNewAndChangedChargeSheets(
    ChargeSheets, NewDocumentChargeSheets, ChangedDocumentChargeSheets
  );

  SaveNewDocumentChargesIfNecessary(Employee, Document, NewDocumentChargeSheets);
  
  FDocumentChargeSheetDirectory.PutDocumentChargeSheets(NewDocumentChargeSheets);
  FDocumentChargeSheetDirectory.ModifyDocumentChargeSheets(ChangedDocumentChargeSheets);

end;

end.
