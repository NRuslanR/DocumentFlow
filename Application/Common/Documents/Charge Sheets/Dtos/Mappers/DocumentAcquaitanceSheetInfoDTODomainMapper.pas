unit DocumentAcquaitanceSheetInfoDTODomainMapper;

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

  TDocumentAcquaitanceSheetInfoDTODomainMapper =
    class (TDocumentChargeSheetInfoDTODomainMapper)

      protected

        function CreateDocumentChargeSheetInfoDTOInstance: TDocumentChargeSheetInfoDTO; override;
        
    end;
    
implementation

{ TDocumentAcquaitanceSheetInfoDTODomainMapper }

function TDocumentAcquaitanceSheetInfoDTODomainMapper
  .CreateDocumentChargeSheetInfoDTOInstance: TDocumentChargeSheetInfoDTO;
begin

  Result := TDocumentAcquaitanceSheetInfoDTO.Create;

end;

end.
