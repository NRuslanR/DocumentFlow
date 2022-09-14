unit IRepositoryRegistryUnit;

interface

uses

  IEmployeeRepositoryUnit,
  DepartmentRepository,
  IRoleRepositoryUnit,
  DocumentRepository,
  IncomingDocumentRepository,
  DocumentFilesRepository,
  IDocumentResponsibleRepositoryUnit,
  DocumentChargeSheet,
  EmployeesWorkGroupRepository,
  DocumentChargeSheetRepository,
  Session,
  Document,
  IncomingDocument,
  DocumentKindRepository,
  DocumentRepositoryRegistry,
  DocumentApprovingCycleResultRepository,
  PersonnelOrderRepositoryRegistry,
  DocumentRelationsRepository;

type

  IRepositoryRegistry = interface

      procedure RegisterSessionManager(Session: ISession);
      function GetSessionManager: ISession;

      procedure RegisterEmployeeRepository(EmployeeRepository: IEmployeeRepository);
      procedure RegisterDepartmentRepository(DepartmentRepository: IDepartmentRepository);
      procedure RegisterRoleRepository(RoleRepository: IRoleRepository);
      procedure RegisterEmployeesWorkGroupRepository(EmployeesWorkGroupRepository: IEmployeesWorkGroupRepository);
  
      function GetEmployeeRepository: IEmployeeRepository;
      function GetDepartmentRepository: IDepartmentRepository;
      function GetRoleRepository: IRoleRepository;
      function GetEmployeesWorkGroupRepository: IEmployeesWorkGroupRepository;

      procedure RegisterDocumentRepositoryRegistry(
        DocumentRepositoryRegistry: IDocumentRepositoryRegistry
      );
      
      function GetDocumentRepositoryRegistry: IDocumentRepositoryRegistry;


      procedure RegisterPersonnelOrderRepositoryRegistry(
        PersonnelOrderRepositoryRegistry: IPersonnelOrderRepositoryRegistry
      );

      function GetPersonnelOrderRepositoryRegistry: IPersonnelOrderRepositoryRegistry;
      
  end;
  
implementation

end.

