unit DocumentPerformingSheetInfoDTODomainMapper;

interface

uses

  DocumentChargeSheetInfoDTODomainMapper,
  ApplicationService,
  DocumentChargeSheet,
  DocumentChargeSheetsInfoDTO,
  DocumentFlowEmployeeInfoDTOMapper,
  DocumentChargeSheetViewingAccountingService,
  DocumentChargeSheetAccessRights,
  Employee,
  IEmployeeRepositoryUnit,
  Disposable,
  SysUtils;

type

  TDocumentPerformingSheetInfoDTODomainMapper =
    class (TDocumentChargeSheetInfoDTODomainMapper)

      protected

        function CreateDocumentChargeSheetInfoDTOInstance: TDocumentChargeSheetInfoDTO; override;
        
    end;



implementation

{ TDocumentPerformingSheetInfoDTODomainMapper }

function TDocumentPerformingSheetInfoDTODomainMapper
  .CreateDocumentChargeSheetInfoDTOInstance: TDocumentChargeSheetInfoDTO;
begin

  Result := TDocumentPerformingSheetInfoDTO.Create;

end;

end.
