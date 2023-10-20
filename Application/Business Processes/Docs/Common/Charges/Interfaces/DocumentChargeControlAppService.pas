unit DocumentChargeControlAppService;

interface

uses

  DocumentChargeSheetsInfoDTO,
  ApplicationService,
  VariantListUnit,
  SysUtils;

type

  TDocumentChargeControlAppServiceException = class (TApplicationServiceException)

  end;

  TDocumentChargesRemovingEnsuringException = class (TDocumentChargeControlAppServiceException)

    private

      FFailedDocumentChargeInfoDTOs: TDocumentChargesInfoDTO;

    public

      destructor Destroy; override;
      constructor Create(FailedDocumentChargeInfoDTOs: TDocumentChargesInfoDTO; const Msg: String = '');

      property FailedDocumentChargeInfoDTOs: TDocumentChargesInfoDTO
      read FFailedDocumentChargeInfoDTOs;
      
  end;
  
  IDocumentChargeControlAppService = interface (IApplicationService)

    function CreateDocumentCharges(
      const ChargeKindId: Variant;
      const AssigningId: Variant;
      const DocumentId: Variant;
      const PerformerIds: TVariantList
    ): TDocumentChargesInfoDTO;

    function GetDocumentCharge(
      const ChargeId: Variant;
      const DocumentId: Variant;
      const EmployeeId: Variant
    ): TDocumentChargeInfoDTO;

    procedure EnsureEmployeeMayRemoveDocumentCharges(
      const EmployeeId: Variant;
      const ChargeIds: TVariantList;
      const DocumentId: Variant
    );
    
  end;
  

implementation

{ TDocumentChargesRemovingEnsuringException }

constructor TDocumentChargesRemovingEnsuringException.Create(
  FailedDocumentChargeInfoDTOs: TDocumentChargesInfoDTO; const Msg: String);
begin

  inherited Create(Msg);

  FFailedDocumentChargeInfoDTOs := FailedDocumentChargeInfoDTOs;

end;

destructor TDocumentChargesRemovingEnsuringException.Destroy;
begin

  FreeAndNil(FFailedDocumentChargeInfoDTOs);
  
  inherited;

end;

end.
