unit DocumentChargeSheetAccessRightsService;

interface

uses

  DocumentChargeSheetAccessRights,
  DomainException,
  DocumentChargeSheet,
  IDocumentUnit,
  IDocumentChargeSheetUnit,
  Employee,
  SysUtils;

type

  TDocumentChargeSheetAccessRightsServiceException = class (TDomainException)

  end;
  
  IDocumentChargeSheetAccessRightsService = interface

    function EnsureEmployeeHasDocumentChargeSheetAccessRights(
      Employee: TEmployee;
      ChargeSheet: IDocumentChargeSheet;
      Document: IDocument
    ): TDocumentChargeSheetAccessRights;
    
  end;

implementation

end.
