unit DocumentPerformingInfoDTODomainMapper;

interface

uses

  DocumentChargeInfoDTODomainMapper,
  DocumentCharges,
  SysUtils,
  IGetSelfUnit,
  DocumentChargeCreatingService,
  DocumentChargeSheetsInfoDTO,
  IEmployeeRepositoryUnit,
  DocumentFlowEmployeeInfoDTOMapper,
  VariantListUnit,
  Employee,
  Classes;

type


  TDocumentPerformingInfoDTODomainMapper =
    class (TDocumentChargeInfoDTODomainMapper)

      protected

        function CreateDocumentChargeInfoDTOInstance: TDocumentChargeInfoDTO; override;

    end;
  

implementation

{ TDocumentPerformingInfoDTODomainMapper }

function TDocumentPerformingInfoDTODomainMapper.CreateDocumentChargeInfoDTOInstance: TDocumentChargeInfoDTO;
begin

  Result := TDocumentPerformingInfoDTO.Create;
  
end;

end.
