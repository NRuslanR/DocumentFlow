unit StandardDocumentChargeSheetOrdinaryPerformingService;

interface

uses

  DomainException,
  IDocumentChargeSheetUnit,
  IDocumentUnit,
  DocumentChargeSheetPerformingService,
  DocumentChargeSheetOrdinaryPerformingService,
  Employee;

type

  TStandardDocumentChargeSheetOrdinaryPerformingService =
    class (
      TAbstractDocumentChargeSheetPerformingService,
      IDocumentChargeSheetOrdinaryPerformingService
    )

      public

        function PerformChargeSheet(
          ChargeSheet: IDocumentChargeSheet;
          Document: IDocument;
          Employee: TEmployee;
          const PerformingDateTime: TDateTime = 0
        ): IDocumentChargeSheets; virtual;
    
    end;

implementation

uses

  DocumentChargeSheetPerformingEnsurer,
  IDomainObjectBaseListUnit,
  DocumentChargeSheet;

{ TStandardDocumentChargeSheetOrdinaryPerformingService }

function TStandardDocumentChargeSheetOrdinaryPerformingService.PerformChargeSheet(
  ChargeSheet: IDocumentChargeSheet;
  Document: IDocument;
  Employee: TEmployee;
  const PerformingDateTime: TDateTime
): IDocumentChargeSheets;
var
    ChargeSheetObj: TDocumentChargeSheet;
    ChargeSheets: TDocumentChargeSheets;
    FreeChargeSheets: IDomainObjectBaseList;
begin

  ChargeSheetObj := TDocumentChargeSheet(ChargeSheet.Self);

  ChargeSheetObj.PerformBy(Employee, PerformingDateTime);

  ChargeSheets := TDocumentChargeSheets.Create;

  FreeChargeSheets := ChargeSheets;

  ChargeSheets.AddDocumentChargeSheet(ChargeSheetObj);

  Result := ChargeSheets;

end;

end.
