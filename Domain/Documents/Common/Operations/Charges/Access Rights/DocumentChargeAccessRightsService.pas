unit DocumentChargeAccessRightsService;

interface

uses

  DocumentChargeAccessRights,
  Employee,
  DocumentChargeInterface,
  IDocumentUnit,
  DomainException,
  SysUtils;

type

  TDocumentChargeAccessRightsServiceException = class (TDomainException)

  end;
  
  IDocumentChargeAccessRightsService = interface

    function EnsureEmployeeHasDocumentChargeAccessRights(
      Employee: TEmployee;
      DocumentCharge: IDocumentCharge;
      Document: IDocument
    ): TDocumentChargeAccessRights;
    
  end;

implementation

end.
