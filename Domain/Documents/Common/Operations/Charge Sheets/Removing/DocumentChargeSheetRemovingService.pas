unit DocumentChargeSheetRemovingService;

interface

uses

  DocumentChargeSheet,
  Employee,
  DomainException,
  SysUtils;

type

  TDocumentChargeSheetRemovingServiceException = class (TDomainException)
  
  end;

  IDocumentChargeSheetRemovingService = interface

    procedure RemoveChargeSheets(
      Employee: TEmployee;
      ChargeSheets: TDocumentChargeSheets
    );
    
  end;

implementation

end.
