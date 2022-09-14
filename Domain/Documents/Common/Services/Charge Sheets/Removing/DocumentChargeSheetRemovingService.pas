unit DocumentChargeSheetRemovingService;

interface

uses

  DocumentChargeSheet,
  IDocumentUnit,
  Employee,
  DomainException,
  SysUtils;

type

  TDocumentChargeSheetRemovingServiceException = class (TDomainException)
  
  end;

  IDocumentChargeSheetRemovingService = interface

    procedure RemoveChargeSheets(
      Employee: TEmployee;
      ChargeSheets: TDocumentChargeSheets;
      Document: IDocument
    );
    
  end;

implementation

end.
