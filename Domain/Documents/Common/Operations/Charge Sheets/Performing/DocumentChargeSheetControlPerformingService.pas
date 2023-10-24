unit DocumentChargeSheetControlPerformingService;

interface

uses

  DocumentChargeSheetPerformingResult,
  IDocumentChargeSheetUnit,
  DomainException,
  Employee,
  SysUtils;

type

  TDocumentChargeSheetControlPerformingServiceException = class (TDomainException)

  end;
  
  IDocumentChargeSheetControlPerformingService = interface

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

end.
