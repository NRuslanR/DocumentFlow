unit EmployeeDocumentKindAccessRightsService;

interface

uses

  EmployeeDocumentKindAccessRightsInfo,
  DomainObjectValueUnit,
  DomainException,
  Employee,
  SysUtils,
  Classes;
  
type

  TEmployeeDocumentKindAccessRightsServiceException = class (TDomainException)
    
  end;

  IEmployeeDocumentKindAccessRightsService = interface

    function GetDocumentKindAccessRightsInfoForEmployee(
      DocumentKind: TClass;
      Employee: TEmployee
    ): TEmployeeDocumentKindAccessRightsInfo;

    procedure EnsureThatEmployeeCanCreateDocuments(
      DocumentKind: TClass;
      Employee: TEmployee
    );

    function EnsureThatEmployeeCanCreateDocumentsAndGetAllAccessRightsInfo(
      DocumentKind: TClass;
      Employee: TEmployee
    ): TEmployeeDocumentKindAccessRightsInfo;

    function EnsureThatEmployeeHasAnyDocumentKindAccessRightsAndGetAll(
      DocumentKind: TClass;
      Employee:  TEmployee
    ): TEmployeeDocumentKindAccessRightsInfo;
    
  end;
  
implementation

end.
