unit DocumentChargeSheetPerformingService;

interface

uses

  DocumentChargeSheetPerformingResult,
  IDocumentChargeSheetUnit,
  DomainException,
  Employee,
  SysUtils;

type

  TDocumentChargeSheetPerformingServiceException = class (TDomainException)

  end;

  IDocumentChargeSheetPerformingService = interface

    function PerformChargeSheet(
      ChargeSheet: IDocumentChargeSheet;
      Employee: TEmployee;
      const PerformingDateTime: TDateTime = 0
    ): IDocumentChargeSheets;
    
  end;

  TAbstractDocumentChargeSheetPerformingService =
    class (TInterfacedObject, IDocumentChargeSheetPerformingService)

      public
      
        function PerformChargeSheet(
          ChargeSheet: IDocumentChargeSheet;
          Employee: TEmployee;
          const PerformingDateTime: TDateTime = 0
        ): IDocumentChargeSheets; virtual; abstract;

    end;

implementation

end.
