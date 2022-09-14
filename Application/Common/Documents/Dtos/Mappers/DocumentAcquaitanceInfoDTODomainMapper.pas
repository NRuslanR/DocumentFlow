unit DocumentAcquaitanceInfoDTODomainMapper;

interface

uses

  DocumentChargeInfoDTODomainMapper,
  DocumentCharges,
  SysUtils,
  IGetSelfUnit,
  DocumentChargeCreatingService,
  DocumentFullInfoDTO,
  IEmployeeRepositoryUnit,
  DocumentFlowEmployeeInfoDTOMapper,
  VariantListUnit,
  Employee,
  Classes;

type

  TDocumentAcquaitanceInfoDTODomainMapper =
    class (TDocumentChargeInfoDTODomainMapper)

      protected

        function CreateDocumentChargeInfoDTOInstance: TDocumentChargeInfoDTO; override;

    end;

implementation

{ TDocumentAcquaitanceInfoDTODomainMapper }

function TDocumentAcquaitanceInfoDTODomainMapper.CreateDocumentChargeInfoDTOInstance: TDocumentChargeInfoDTO;
begin

  Result := TDocumentAcquaitanceInfoDTO.Create;

end;

end.
