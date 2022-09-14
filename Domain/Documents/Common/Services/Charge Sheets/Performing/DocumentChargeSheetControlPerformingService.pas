unit DocumentChargeSheetControlPerformingService;

interface

uses

  DocumentChargeSheetPerformingResult,
  IDocumentChargeSheetUnit,
  IDocumentUnit,
  DomainException,
  Employee,
  SysUtils;

type

  TDocumentChargeSheetControlPerformingServiceException = class (TDomainException)

  end;
  
  IDocumentChargeSheetControlPerformingService = interface

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

end.
