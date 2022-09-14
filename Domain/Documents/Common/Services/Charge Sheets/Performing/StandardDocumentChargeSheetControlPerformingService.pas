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
  IDocumentUnit,
  DomainException,
  Employee,
  SysUtils;

type

  TStandardDocumentChargeSheetControlPerformingService =
    class (TInterfacedObject, IDocumentChargeSheetControlPerformingService)

      protected

        FDocumentPerformingService: IDocumentPerformingService;

        procedure PerformDocumentIfNeccessary(
          Document: IDocument;
          ChargeSheet: IDocumentChargeSheet
        );

        function DoPerformingChargeSheet(
          ChargeSheet: IDocumentChargeSheet;
          Document: IDocument;
          Employee: TEmployee;
          const PerformingDateTime: TDateTime
        ): IDocumentChargeSheets;

      public

        constructor Create(
          DocumentPerformingService: IDocumentPerformingService
        );

        function PerformChargeSheet(
          ChargeSheet: IDocumentChargeSheet;
          Document: IDocument;
          Employee: TEmployee;
          const PerformingDateTime: TDateTime = 0
        ): TDocumentChargeSheetPerformingResult;

        function PerformChargeSheets(
          ChargeSheets: IDocumentChargeSheets;
          Document: IDocument;
          Employee: TEmployee;
          const PerformingDateTime: TDateTime = 0
        ): TDocumentChargeSheetPerformingResult;

    end;

implementation

uses

  Document,
  IDomainObjectBaseUnit,
  StandardDocumentChargeSheetOrdinaryPerformingService,
  DocumentChargeSheetsServiceRegistry,
  StandardDocumentChargeSheetOverlappingPerformingService;

{ TStandardDocumentChargeSheetControlPerformingService }

constructor TStandardDocumentChargeSheetControlPerformingService.Create(
  DocumentPerformingService: IDocumentPerformingService
);
begin

  inherited Create;

  FDocumentPerformingService := DocumentPerformingService;

end;

function TStandardDocumentChargeSheetControlPerformingService.PerformChargeSheets(
  ChargeSheets: IDocumentChargeSheets;
  Document: IDocument;
  Employee: TEmployee;
  const PerformingDateTime: TDateTime
): TDocumentChargeSheetPerformingResult;
var
    ChargeSheetsObj: TDocumentChargeSheets;
    ChargeSheet: IDocumentChargeSheet;
    PerformingResult: TDocumentChargeSheetPerformingResult;
    FreePerformingResult: IDomainObjectBase;
begin
  
  ChargeSheetsObj := TDocumentChargeSheets(ChargeSheets.Self);

  Result := nil;

  try

    for ChargeSheet in ChargeSheetsObj do begin

      PerformingResult :=
        PerformChargeSheet(ChargeSheet, Document, Employee, PerformingDateTime);

      if not Assigned(Result) then
        Result := PerformingResult

      else begin

        FreePerformingResult := PerformingResult;

        Result.PerformedDocument := PerformingResult.PerformedDocument;
        
        with TDocumentChargeSheets(Result.PerformedChargeSheets.Self) do begin

          AddDocumentChargeSheets(
            TDocumentChargeSheets(PerformingResult.PerformedChargeSheets.Self)
          );

        end;

      end;

    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TStandardDocumentChargeSheetControlPerformingService.PerformChargeSheet(
  ChargeSheet: IDocumentChargeSheet;
  Document: IDocument;
  Employee: TEmployee;
  const PerformingDateTime: TDateTime
): TDocumentChargeSheetPerformingResult;
var
    PerformedChargeSheets: IDocumentChargeSheets;
begin

  if not Assigned(Document) then begin

    Raise TDocumentChargeSheetControlPerformingServiceException.Create(
      '¬о врем€ выполнени€ поручени€ не был найден ' +
      'соответствующий документ'
    );

  end;

  PerformedChargeSheets :=
    DoPerformingChargeSheet(ChargeSheet, Document, Employee, PerformingDateTime);

  PerformDocumentIfNeccessary(Document, ChargeSheet);

  Result := TDocumentChargeSheetPerformingResult.Create(Document, PerformedChargeSheets);
        
end;

function TStandardDocumentChargeSheetControlPerformingService
  .DoPerformingChargeSheet(
    ChargeSheet: IDocumentChargeSheet;
    Document: IDocument;
    Employee: TEmployee;
    const PerformingDateTime: TDateTime
  ): IDocumentChargeSheets;
var
    ChargeSheetObj: TDocumentChargeSheet;
    ChargeSheetPerformingService: IDocumentChargeSheetPerformingService;
begin

  ChargeSheetObj := TDocumentChargeSheet(ChargeSheet.Self);

  ChargeSheetPerformingService :=
    TDocumentChargeSheetsServiceRegistry
      .Instance
        .GetDocumentChargeSheetPerformingService(
          TDocument(Document.Self).ClassType,
          ChargeSheetObj.ClassType
        );

  if not Assigned(ChargeSheetPerformingService) then begin

    Raise TDocumentChargeSheetControlPerformingServiceException.Create(
      'ƒл€ выполнени€ поручени€ не найдена соответствующа€ служба'
    );

  end;

  Result :=
    ChargeSheetPerformingService
      .PerformChargeSheet(ChargeSheet, Document, Employee, PerformingDateTime);

end;

procedure TStandardDocumentChargeSheetControlPerformingService
  .PerformDocumentIfNeccessary(
    Document: IDocument;
    ChargeSheet: IDocumentChargeSheet
  );
begin

  if ChargeSheet.IsHead then
    FDocumentPerformingService.PerformDocument(TDocument(Document.Self), ChargeSheet);
  
end;

end.
