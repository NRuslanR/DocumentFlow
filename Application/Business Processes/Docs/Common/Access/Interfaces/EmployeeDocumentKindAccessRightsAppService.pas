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
    ): TEmployeeDocumentKindAccessRightsInfoDto; 
    
  end;

implementation

end.
