unit DocumentChargeSheetIssuingAccessRightsService;

interface

uses

  Document,
  DocumentChargeKind,
  Employee,
  DomainObjectValueUnit,
  DomainException,
  IDomainObjectBaseListUnit,
  DocumentChargeSheetIssuingAccessRights,
  GeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo,
  IDomainObjectBaseUnit,
  SysUtils;

type

  TDocumentChargeSheetIssuingAccessRightsServiceException = class (TDomainException)

  end;

  IDocumentChargeSheetIssuingAccessRightsService = interface

    function GetDocumentChargeSheetIssuingAccessRights(
      Document: TDocument;
      Employee: TEmployee;
      GeneralChargeSheetsAccessRights: TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo
    ): TDocumentChargeSheetIssuingAccessRights;

    function EnsureEmployeeHasDocumentChargeSheetIssuingAccessRights(
      Document: TDocument;
      Employee: TEmployee;
      GeneralChargeSheetsAccessRights: TGeneralDocumentChargeSheetsUsageEmployeeAccessRightsInfo
    ): TDocumentChargeSheetIssuingAccessRights;

  end;
  
implementation


end.
