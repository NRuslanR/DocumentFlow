unit LoodsmanDocumentsUploadingAccessRightsService;

interface

uses

  LoodsmanDocumentsUploadingAccessRights,
  ApplicationService,
  SysUtils;

type

  TLoodsmanDocumentsUploadingAccessRightsServiceException = class (TApplicationServiceException)

  end;

  ILoodsmanDocumentsUploadingAccessRightsService = interface (IApplicationService)

    function GetEmployeeLoodsmanDocumentsUploadingAccessRights(const EmployeeId: Variant): TLoodsmanDocumentsUploadingAccessRights;
    procedure EnsureEmployeeLoodsmanDocumentsUploadingAccessRights(const EmployeeId: Variant);
    
  end;
  
implementation

end.
