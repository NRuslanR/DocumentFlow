unit DocumentChargeSheetAccessRightsService;

interface

uses

  DocumentChargeSheetAccessRights,
  DomainException,
  DocumentChargeSheet,
  IDocumentChargeSheetUnit,
  Employee,
  SysUtils;

type

  TDocumentChargeSheetAccessRightsServiceException = class (TDomainException)

  end;
  
  IDocumentChargeSheetAccessRightsService = interface

    function EnsureEmployeeHasDocumentChargeSheetAccessRights(
      Employee: TEmployee;
      ChargeSheet: IDocumentChargeSheet
    ): TDocumentChargeSheetAccessRights;
    
  end;

implementation

end.
