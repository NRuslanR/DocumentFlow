unit AdminDocumentSetReadService;

interface

uses

  ApplicationService,
  DocumentSetHolder,
  VariantListUnit,
  SysUtils;

type

  TAdminDocumentSetReadServiceException = class (TApplicationServiceException)

  end;
  
  IAdminDocumentSetReadService = interface (IApplicationService)
    ['{02D75269-F17C-4056-A63F-583759DD7F1C}']

    function GetAdminDocumentSet(
      const AdminId: Variant;
      const DepartmentIds: TVariantList
    ): TDocumentSetHolder;

    function GetAdminDocumentSetByIds(
      const AdminId: Variant;
      const DocumentIds: TVariantList
    ): TDocumentSetHolder; overload;

    function GetAdminDocumentSetByIds(
      const AdminId: Variant;
      DocumentIds: array of Variant
    ): TDocumentSetHolder; overload;

  end;

implementation

end.
