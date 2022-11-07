unit EmployeeDocumentKindAccessRightsAppService;

interface

uses

  ApplicationService,
  DocumentKinds,
  EmployeeDocumentKindAccessRightsInfoDto,
  SysUtils,
  Classes;

type

  TEmployeeDocumentKindAccessRightsAppServiceException = class (TApplicationServiceException)
  
  end;

  IEmployeeDocumentKindAccessRightsAppService = interface (IApplicationService)

    function GetDocumentKindAccessRightsInfoForEmployee(
      const DocumentKind: TDocumentKindClass;
      const EmployeeId: Variant
    ): TEmployeeDocumentKindAccessRightsInfoDto;

    function EnsureThatEmployeeCanCreateDocumentsAndGetAllAccessRightsInfo(
      DocumentKind: TClass;
      const EmployeeId: Variant
    ): TEmployeeDocumentKindAccessRightsInfoDto; overload;

    function EnsureThatEmployeeCanCreateDocumentsAndGetAllAccessRightsInfo(
      const DocumentKindId: Variant;
      const EmployeeId: Variant
    ): TEmployeeDocumentKindAccessRightsInfoDto; overload;

    function EnsureThatEmployeeHasAnyDocumentKindAccessRightsAndGetAll(
      const DocumentKindClass: TDocumentKindClass;
      const EmployeeId: Variant
    ): TEmployeeDocumentKindAccessRightsInfoDto; overload;
    
    function EnsureThatEmployeeHasAnyDocumentKindAccessRightsAndGetAll(
      const DocumentKindId: Variant;
      const EmployeeId: Variant
    ): TEmployeeDocumentKindAccessRightsInfoDto; overload;
    
  end;

implementation

end.
