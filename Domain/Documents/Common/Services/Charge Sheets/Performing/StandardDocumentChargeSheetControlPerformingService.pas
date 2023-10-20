unit StandardDocumentChargeSheetControlPerformingService;

interface

uses

  DocumentChargeSheetControlPerformingService,
  DocumentChargeSheetPerformingResult,
  DocumentChargeSheet,
  IDocumentChargeSheetUnit,
  DocumentDirectory,
  DocumentPerformingService,
  DocumentChargeSheetPerformingService,
  DocumentKindFinder,
  DocumentKind,
  Document,
  IDocumentUnit,
  DomainException,
  Employee,
  SysUtils;

type

  TStandardDocumentChargeSheetControlPerformingService =
    class (TInterfacedObject, IDocumentChargeSheetControlPerformingService)

      protected

        FDocumentKindFinder: IDocumentKindFinder;
        FDocumentPerformingService: IDocumentPerformingService;

        function PerformDocumentIfNeccessary(
          HeadChargeSheets: TDocumentChargeSheets
        ): IDocument;

        function DoPerformingChargeSheet(
          ChargeSheet: IDocumentChargeSheet;
          Employee: TEmployee;
          const PerformingDateTime: TDateTime
        ): IDocumentChargeSheets;

      public

        constructor Create(
          DocumentKindFinder: IDocumentKindFinder;
          DocumentPerformingService: IDocumentPerformingService
        );

        function PerformChargeSheet(
          ChargeSheet: IDocumentChargeSheet;
          Employee: TEmployee;
          const PerformingDateTime: TDateTime = 0
        ): TDocumentChargeSheetPerformingResult;

        function PerformChargeSheets(
          ChargeSheets: IDocumentChargeSheets;
          Employee: TEmployee;
          const PerformingDateTime: TDateTime = 0
        ): TDocumentChargeSheetPerformingResult;

    end;

implementation

uses

  IDomainObjectBaseUnit,
  IDomainObjectBaseListUnit,
  StandardDocumentChargeSheetOrdinaryPerformingService,
  DocumentChargeSheetsServiceRegistry,
  StandardDocumentChargeSheetOverlappingPerformingService;

{ TStandardDocumentChargeSheetControlPerformingService }

constructor TStandardDocumentChargeSheetControlPerformingService.Create(
  DocumentKindFinder: IDocumentKindFinder;
  DocumentPerformingService: IDocumentPerformingService
);
begin

  inherited Create;

  FDocumentKindFinder := DocumentKindFinder;
  
  FDocumentPerformingService := DocumentPerformingService;

end;

function TStandardDocumentChargeSheetControlPerformingService.PerformChargeSheets(
  ChargeSheets: IDocumentChargeSheets;
  Employee: TEmployee;
  const PerformingDateTime: TDateTime
): TDocumentChargeSheetPerformingResult;
var
    ChargeSheetsObj: TDocumentChargeSheets;
    ChargeSheet: IDocumentChargeSheet;
    PerformingResult: TDocumentChargeSheetPerformingResult;
    FreePerformingResult: IDomainObjectBase;
    HeadChargeSheets: TDocumentChargeSheets;
    FreeHeadChargeSheets: IDomainObjectBaseList;
begin
  
  ChargeSheetsObj := TDocumentChargeSheets(ChargeSheets.Self);

  HeadChargeSheets := TDocumentChargeSheets.Create;

  FreeHeadChargeSheets := HeadChargeSheets;
  
  Result := nil;

  try

    for ChargeSheet in ChargeSheetsObj do begin

      PerformingResult :=
        PerformChargeSheet(ChargeSheet, Employee, PerformingDateTime);

      if not Assigned(Result) then
        Result := PerformingResult

      else begin

        FreePerformingResult := PerformingResult;

        with TDocumentChargeSheets(Result.PerformedChargeSheets.Self) do begin

          AddDocumentChargeSheets(
            TDocumentChargeSheets(PerformingResult.PerformedChargeSheets.Self)
          );

        end;

      end;

      if ChargeSheet.IsHead then
        HeadChargeSheets.AddDocumentChargeSheet(ChargeSheet);

    end;

    if Assigned(Result) then begin

      Result.PerformedDocument :=
        PerformDocumentIfNeccessary(HeadChargeSheets);

    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TStandardDocumentChargeSheetControlPerformingService.PerformChargeSheet(
  ChargeSheet: IDocumentChargeSheet;
  Employee: TEmployee;
  const PerformingDateTime: TDateTime
): TDocumentChargeSheetPerformingResult;
var
    PerformedChargeSheets: IDocumentChargeSheets;
begin

  PerformedChargeSheets :=
    DoPerformingChargeSheet(ChargeSheet, Employee, PerformingDateTime);

  Result := TDocumentChargeSheetPerformingResult.Create(PerformedChargeSheets);
        
end;

function TStandardDocumentChargeSheetControlPerformingService
  .DoPerformingChargeSheet(
    ChargeSheet: IDocumentChargeSheet;
    Employee: TEmployee;
    const PerformingDateTime: TDateTime
  ): IDocumentChargeSheets;
var
    DocumentKind: TDocumentKind;
    FreeDocumentKind: IDomainObjectBase;

    ChargeSheetObj: TDocumentChargeSheet;
    ChargeSheetPerformingService: IDocumentChargeSheetPerformingService;
begin

  ChargeSheetObj := TDocumentChargeSheet(ChargeSheet.Self);

  DocumentKind :=
    FDocumentKindFinder
      .FindDocumentKindByIdentity(ChargeSheet.DocumentKindId);

  if not Assigned(DocumentKind) then begin

    Raise TDocumentChargeSheetControlPerformingServiceException.Create(
      'Не найдена информация о типе документа ' +
      'при выполнении поручения'
    );

  end;

  FreeDocumentKind := DocumentKind;

  { refactor: inject register interface instance }
  
  ChargeSheetPerformingService :=
    TDocumentChargeSheetsServiceRegistry
      .Instance
        .GetDocumentChargeSheetPerformingService(
          DocumentKind.DocumentClass,
          ChargeSheetObj.ClassType
        );

  if not Assigned(ChargeSheetPerformingService) then begin

    Raise TDocumentChargeSheetControlPerformingServiceException.Create(
      'Для выполнения поручения не найдена соответствующая служба'
    );

  end;

  Result :=
    ChargeSheetPerformingService
      .PerformChargeSheet(ChargeSheet, Employee, PerformingDateTime);

end;

function TStandardDocumentChargeSheetControlPerformingService
  .PerformDocumentIfNeccessary(
    HeadChargeSheets: TDocumentChargeSheets
  ): IDocument;
var
    DocumentId: Variant;
begin

  if not HeadChargeSheets.IsEmpty then begin

    DocumentId := HeadChargeSheets.First.DocumentId;

    HeadChargeSheets.EnsureBelongsToDocument(DocumentId);
    
    Result :=
      FDocumentPerformingService.PerformDocument(
        DocumentId, HeadChargeSheets
      );

  end

  else Result := nil;

end;

end.
