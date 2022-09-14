unit RepositoryRegistryUnit;

interface

uses

  DomainObjectUnit,
  DomainObjectBaseUnit,
  IRepositoryRegistryUnit,
  IEmployeeRepositoryUnit,
  IRoleRepositoryUnit,
  DocumentRepository,
  IncomingDocumentRepository,
  DepartmentRepository,
  DocumentFilesRepository,
  DocumentRelationsRepository,
  IDocumentResponsibleRepositoryUnit,
  DocumentChargeSheet,
  DocumentRelationsUnit,
  DocumentChargeSheetRepository,
  DocumentKindRepository,
  DocumentApprovingCycleResultRepository,
  EmployeesWorkGroupRepository,
  EmployeesWorkGroup,
  InterfaceObjectList,
  Document,
  DocumentRepositoryRegistry,
  PersonnelOrderRepositoryRegistry,
  DocumentKind,
  RepositoryList,
  IncomingDocument,
  Session,
  Classes;

type

  TRepositoryRegistry = class (TInterfacedObject, IRepositoryRegistry)

    private

      FSession: ISession;
      FDocumentRepositoryRegistry: IDocumentRepositoryRegistry;
      FPersonnelOrderRepositoryRegistry: IPersonnelOrderRepositoryRegistry;
      FRepositories: TRepositories;

      class var FCurrent: IRepositoryRegistry;

      class function GetRepositoryRegistry: IRepositoryRegistry; static;

      constructor Create;

    public

      destructor Destroy; override;

      procedure RegisterSessionManager(Session: ISession);
      function GetSessionManager: ISession;

    public

      procedure RegisterEmployeeRepository(EmployeeRepository: IEmployeeRepository);
      function GetEmployeeRepository: IEmployeeRepository;

      procedure RegisterDepartmentRepository(DepartmentRepository: IDepartmentRepository);
      function GetDepartmentRepository: IDepartmentRepository;

      procedure RegisterRoleRepository(RoleRepository: IRoleRepository);
      function GetRoleRepository: IRoleRepository;
      
      procedure RegisterEmployeesWorkGroupRepository(EmployeesWorkGroupRepository: IEmployeesWorkGroupRepository);
      function GetEmployeesWorkGroupRepository: IEmployeesWorkGroupRepository;

    public

      procedure RegisterDocumentRepositoryRegistry(
        DocumentRepositoryRegistry: IDocumentRepositoryRegistry
      );

      function GetDocumentRepositoryRegistry: IDocumentRepositoryRegistry;

    public

      procedure RegisterPersonnelOrderRepositoryRegistry(
        PersonnelOrderRepositoryRegistry: IPersonnelOrderRepositoryRegistry
      );

      function GetPersonnelOrderRepositoryRegistry: IPersonnelOrderRepositoryRegistry;

    public
    
      class property Current: IRepositoryRegistry
      read GetRepositoryRegistry write FCurrent;

  end;
  
implementation

uses

  DepartmentUnit,
  Employee,
  RoleUnit,
  DocumentFileUnit,
  IncomingServiceNote,
  ServiceNote,
  SysUtils;

{ TRepositoryRegistry }

class function TRepositoryRegistry.GetRepositoryRegistry: IRepositoryRegistry;
begin

  if not Assigned(FCurrent) then
    FCurrent := TRepositoryRegistry.Create;

  Result := FCurrent;

end;

constructor TRepositoryRegistry.Create;
begin

  inherited;

  FRepositories := TRepositories.Create;

end;

destructor TRepositoryRegistry.Destroy;
begin

  FreeAndNil(FRepositories);
  
  inherited ;

end;

function TRepositoryRegistry.GetDepartmentRepository: IDepartmentRepository;
begin

  Result := IDepartmentRepository(FRepositories[TDepartment]);

end;

function TRepositoryRegistry.
  GetDocumentRepositoryRegistry: IDocumentRepositoryRegistry;
begin

  Result := FDocumentRepositoryRegistry;
  
end;

function TRepositoryRegistry.GetEmployeeRepository: IEmployeeRepository;
begin

  Result := IEmployeeRepository(FRepositories[TEmployee]);
  
end;

function TRepositoryRegistry.GetEmployeesWorkGroupRepository: IEmployeesWorkGroupRepository;
begin

  Result := IEmployeesWorkGroupRepository(FRepositories[TEmployeesWorkGroup]);

end;

function TRepositoryRegistry.GetPersonnelOrderRepositoryRegistry: IPersonnelOrderRepositoryRegistry;
begin

  Result := FPersonnelOrderRepositoryRegistry;
  
end;

function TRepositoryRegistry.GetRoleRepository: IRoleRepository;
begin

  Result := IRoleRepository(FRepositories[TRole]);

end;

function TRepositoryRegistry.GetSessionManager: ISession;
begin

  Result := FSession;

end;

procedure TRepositoryRegistry.RegisterDepartmentRepository(
  DepartmentRepository: IDepartmentRepository);
begin

  FRepositories.AddOrUpdateRepository(TDepartment, DepartmentRepository);

end;

procedure TRepositoryRegistry.RegisterDocumentRepositoryRegistry(
  DocumentRepositoryRegistry: IDocumentRepositoryRegistry);
begin

  FDocumentRepositoryRegistry := DocumentRepositoryRegistry;

end;

procedure TRepositoryRegistry.RegisterEmployeeRepository(
  EmployeeRepository: IEmployeeRepository);
begin

  FRepositories.AddOrUpdateRepository(TEmployee, EmployeeRepository);
  
end;

procedure TRepositoryRegistry.RegisterEmployeesWorkGroupRepository(
  EmployeesWorkGroupRepository: IEmployeesWorkGroupRepository);
begin

  FRepositories.AddOrUpdateRepository(TEmployeesWorkGroup, EmployeesWorkGroupRepository);

end;

procedure TRepositoryRegistry.RegisterPersonnelOrderRepositoryRegistry(
  PersonnelOrderRepositoryRegistry: IPersonnelOrderRepositoryRegistry);
begin

  FPersonnelOrderRepositoryRegistry := PersonnelOrderRepositoryRegistry;
  
end;

procedure TRepositoryRegistry.RegisterRoleRepository(
  RoleRepository: IRoleRepository);
begin

  FRepositories.AddOrUpdateRepository(TRole, RoleRepository);
  
end;

procedure TRepositoryRegistry.RegisterSessionManager(Session: ISession);
begin

  FSession := Session;
  
end;

end.
