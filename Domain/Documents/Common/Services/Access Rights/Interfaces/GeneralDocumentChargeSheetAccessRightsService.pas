unit GeneralDocumentChargeSheetAccessRightsService;

interface

uses

  Document,
  Employee,
  GeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo,
  SysUtils;

type

  IGeneralDocumentChargeSheetAccessRightsService = interface

    function GetDocumentChargeSheetsUsageAccessRights(
      Document: TDocument;
      Employee: TEmployee
    ): TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo;

  end;

implementation

end.
