unit LoodsmanDocumentsUploadingService;

interface

uses

  LoodsmanDocumentUploadingInfo,
  ApplicationService,
  SysUtils,
  Classes;

type

  TLoodsmanDocumentsUploadingServiceException = class (TApplicationServiceException)

  end;
  
  ILoodsmanDocumentsUploadingService = interface (IApplicationService)

    function EnsureAccessRightsAndGetLoodsmanDocumentUploadingInfo(
      const EmployeeId: Variant;
      const DocumentId: Variant
    ): TLoodsmanDocumentUploadingInfo;

    function GetLoodsmanDocumentUploadingInfo(
      const EmployeeId: Variant;
      const DocumentId: Variant
    ): TLoodsmanDocumentUploadingInfo;

    function RunDocumentUploadingToLoodsman(
      const EmployeeId: Variant;
      const DocumentId: Variant
    ): TLoodsmanDocumentUploadingInfo;

    function RunCancellationDocumentUploadingToLoodsman(
      const EmployeeId: Variant;
      const DocumentId: Variant
    ): TLoodsmanDocumentUploadingInfo;
    
  end;

implementation

end.
