unit BasedOnDocumentViewingDocumentChargeSheetViewingAccountingService;

interface

uses

  AbstractApplicationService,
  DocumentChargeSheetViewingAccountingService,
  DocumentViewingAccountingService,
  DocumentChargeSheetDirectory,
  DocumentChargeSheet,
  DocumentKindFinder,
  IDocumentChargeSheetUnit,
  IDocumentUnit,
  DocumentKind,
  VariantFunctions,
  SysUtils;

type

  TBasedOnDocumentViewingDocumentChargeSheetViewingAccountingService =
    class (TAbstractApplicationService, IDocumentChargeSheetViewingAccountingService)

      protected

        FDocumentChargeSheetDirectory: IDocumentChargeSheetDirectory;
        FDocumentKindFinder: IDocumentKindFinder;
        FDocumentViewingAccountingService: IDocumentViewingAccountingService;

        function GetDocumentIdForChargeSheet(const ChargeSheetId: Variant): Variant;
        
      public

        constructor Create(
          DocumentChargeSheetDirectory: IDocumentChargeSheetDirectory;
          DocumentKindFinder: IDocumentKindFinder;
          DocumentViewingAccountingService: IDocumentViewingAccountingService
        );
        
        function IsDocumentChargeSheetViewedByEmployee(
          const DocumentChargeSheetId, EmployeeId: Variant
        ): Boolean;

        function GetDocumentChargeSheetViewDateByEmployee(
          const DocumentChargeSheetId, EmployeeId: Variant
        ): Variant;

        procedure MarkDocumentChargeSheetAsViewedByEmployee(
          const DocumentChargeSheetId: Variant;
          const EmployeeId: Variant;
          const ViewDate: TDateTime
        );

        procedure MarkDocumentChargeSheetAsViewedByEmployeeIfItIsNotViewed(
          const DocumentChargeSheetId: Variant;
          const EmployeeId: Variant;
          const ViewDate: TDateTime
        );
        
    end;
  

implementation

uses

  IDomainObjectBaseUnit;

{ TBasedOnDocumentViewingDocumentChargeSheetViewingAccountingService }

constructor TBasedOnDocumentViewingDocumentChargeSheetViewingAccountingService.Create(
  DocumentChargeSheetDirectory: IDocumentChargeSheetDirectory;
  DocumentKindFinder: IDocumentKindFinder;
  DocumentViewingAccountingService: IDocumentViewingAccountingService
);
begin

  inherited Create;

  FDocumentChargeSheetDirectory := DocumentChargeSheetDirectory;
  FDocumentKindFinder := DocumentKindFinder;
  FDocumentViewingAccountingService := DocumentViewingAccountingService;
  
end;

function TBasedOnDocumentViewingDocumentChargeSheetViewingAccountingService.GetDocumentIdForChargeSheet(
  const ChargeSheetId: Variant): Variant;
var
    ChargeSheet: IDocumentChargeSheet;

    DocumentKind: TDocumentKind;
    FreeDocumentKind: IDomainObjectBase;
begin

  ChargeSheet :=
    FDocumentChargeSheetDirectory.FindDocumentChargeSheetById(ChargeSheetId);

  if not Assigned(ChargeSheet) then begin
  
    TDocumentChargeSheetViewingAccountingServiceException.RaiseException(
      'Не найдено поручение при попытке получить дату его просмотра'
    );

  end;

  DocumentKind :=
    FDocumentKindFinder.FindDocumentKindByIdentity(ChargeSheet.DocumentKindId);

  FreeDocumentKind := DocumentKind;
  Result := ChargeSheet.DocumentId;

  if VarIsNullOrEmpty(ChargeSheet.DocumentId) then begin

    TDocumentChargeSheetViewingAccountingServiceException.RaiseException(
      'Не найден соответствующий поручению документ при попытке ' +
      'получить дату просмотра данного поручения'
    );

  end;

end;

function TBasedOnDocumentViewingDocumentChargeSheetViewingAccountingService.IsDocumentChargeSheetViewedByEmployee(
  const DocumentChargeSheetId, EmployeeId: Variant): Boolean;
begin

  Result :=
    FDocumentViewingAccountingService.IsDocumentViewedByEmployee(
      GetDocumentIdForChargeSheet(DocumentChargeSheetId),
      EmployeeId
    );
  
end;

function TBasedOnDocumentViewingDocumentChargeSheetViewingAccountingService.GetDocumentChargeSheetViewDateByEmployee(
  const DocumentChargeSheetId, EmployeeId: Variant): Variant;
begin

  Result :=
    FDocumentViewingAccountingService.GetDocumentViewDateByEmployee(
      GetDocumentIdForChargeSheet(DocumentChargeSheetId),
      EmployeeId
    );

end;

procedure TBasedOnDocumentViewingDocumentChargeSheetViewingAccountingService
  .MarkDocumentChargeSheetAsViewedByEmployee(
    const DocumentChargeSheetId, EmployeeId: Variant;
    const ViewDate: TDateTime
  );
begin

  FDocumentViewingAccountingService.MarkDocumentAsViewedByEmployee(
    GetDocumentIdForChargeSheet(DocumentChargeSheetId),
    EmployeeId,
    ViewDate
  );
  
end;

procedure TBasedOnDocumentViewingDocumentChargeSheetViewingAccountingService
  .MarkDocumentChargeSheetAsViewedByEmployeeIfItIsNotViewed(
    const DocumentChargeSheetId, EmployeeId: Variant;
    const ViewDate: TDateTime
  );
begin

  FDocumentViewingAccountingService.MarkDocumentAsViewedByEmployeeIfItIsNotViewed(
    GetDocumentIdForChargeSheet(DocumentChargeSheetId),
    EmployeeId,
    ViewDate
  );

end;

end.
