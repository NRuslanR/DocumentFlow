unit DocumentFlowAdminPrivilegeServicesFactories;

interface

uses

  InterfaceObjectList,
  DocumentFlowAdminPrivilegeServicesFactory,
  DocumentFlowAdminPrivileges,
  SysUtils;

type

  IDocumentFlowAdminPrivilegeServicesFactories = interface
    ['{3EC14E23-D0FB-4133-865A-F93C121D8F12}']

    function CreateDocumentsAdminPrivilegeServicesFactory(
      const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege
    ): IDocumentFlowAdminPrivilegeServicesFactory;

    function CreateDocumentNumeratorsAdminPrivilegeServicesFactory(
      const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege
    ): IDocumentFlowAdminPrivilegeServicesFactory;
    
    function CreateEmployeesAdminPrivilegeServicesFactory(
      const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege
    ): IDocumentFlowAdminPrivilegeServicesFactory;

    function CreateEmployeesReplacementsAdminPrivilegeServicesFactory(
      const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege
    ): IDocumentFlowAdminPrivilegeServicesFactory;

    function CreateEmployeesWorkGroupsAdminPrivilegeServicesFactory(
      const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege
    ): IDocumentFlowAdminPrivilegeServicesFactory;

    function CreateEmpoyeeStaffsAdminPrivilegeServicesFactory(
      const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege
    ): IDocumentFlowAdminPrivilegeServicesFactory;

    function CreateDepartmentsAdminPrivilegeServicesFactory(
      const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege
    ): IDocumentFlowAdminPrivilegeServicesFactory;

    function CreateSynchronizationDataAdminPrivilegeServicesFactory(
      const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege
    ): IDocumentFlowAdminPrivilegeServicesFactory;

    { Создаёт фабрики сервисов для админки по кадровым приказам }
    function CreatePersonnelOrderEmployeesAdminPrivilegeServicesFactory(
      const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege
    ): IDocumentFlowAdminPrivilegeServicesFactory;

    function CreatePersonnelOrderControlGroupsAdminPrivilegeServicesFactory(
      const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege
    ): IDocumentFlowAdminPrivilegeServicesFactory;

    function CreatePersonnelOrderKindApproversAdminPrivilegeServicesFactory(
      const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege
    ): IDocumentFlowAdminPrivilegeServicesFactory;

    function CreatePersonnelOrderSignersAdminPrivilegeServicesFactory(
      const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege
    ): IDocumentFlowAdminPrivilegeServicesFactory;

  end;

  
implementation

end.
