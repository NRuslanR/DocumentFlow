unit DocumentChargeSheetPerformingService;

interface

uses

  DocumentChargeSheetPerformingResult,
  IDocumentChargeSheetUnit,
  DomainException,
  IDocumentUnit,
  Employee,
  SysUtils;

type

  TDocumentChargeSheetPerformingServiceException = class (TDomainException)

  end;

  IDocumentChargeSheetPerformingService = interface

    function PerformChargeSheet(
      ChargeSheet: IDocumentChargeSheet;
      Document: IDocument;
      Employee: TEmployee;
      const PerformingDateTime: TDateTime = 0
    ): IDocumentChargeSheets;
    
  end;

  TAbstractDocumentChargeSheetPerformingService =
    class (TInterfacedObject, IDocumentChargeSheetPerformingService)

      public
      
        function PerformChargeSheet(
          ChargeSheet: IDocumentChargeSheet;
          Document: IDocument;
          Employee: TEmployee;
          const PerformingDateTime: TDateTime = 0
        ): IDocumentChargeSheets; virtual; abstract;

    end;

implementation

end.
