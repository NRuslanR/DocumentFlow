unit GeneralDocumentChargeSheetAccessRightsService;

interface

uses

  Document,
  Employee,
  DomainException,
  GeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo,
  SysUtils;

type

  TGeneralDocumentChargeSheetAccessRightsServiceException =
    class (TDomainException)

    end;
  
  IGeneralDocumentChargeSheetAccessRightsService = interface

    function GetDocumentChargeSheetsUsageAccessRights(
      Document: TDocument;
      Employee: TEmployee
    ): TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo;

    function EnsureEmployeeHasDocumentChargeSheetsAccessRights(
      Document: TDocument;
      Employee: TEmployee
    ): TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo;

    function AnyChargeSheetsCanBeViewedFor(
      Document: TDocument;
      Employee: TEmployee
    ): Boolean;
    
  end;

implementation

end.
