unit DocumentChargeSheetOverlappingPerformingService;

interface

uses

  DomainException,
  IDocumentChargeSheetUnit,
  DocumentChargeSheetPerformingService,
  Employee;

type


  TDocumentChargeSheetOverlappingPerformingServiceException = class (TDomainException)

  end;

  IDocumentChargeSheetOverlappingPerformingService =
    interface (IDocumentChargeSheetPerformingService)

      function PerformChargeSheetAsOverlapping(
        ChargeSheet: IDocumentChargeSheet;
        Employee: TEmployee;
        const PerformingDateTime: TDateTime = 0
      ): IDocumentChargeSheets;
      
    end;

implementation

end.
