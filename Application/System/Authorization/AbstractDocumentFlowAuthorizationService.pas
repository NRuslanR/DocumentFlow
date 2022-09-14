unit AbstractDocumentFlowAuthorizationService;

interface

uses

  AbstractApplicationService,
  DocumentFlowAuthorizationService,
  SysUtils,
  Classes;

type

  TAbstractDocumentFlowAuthorizationService =
    class abstract (TAbstractApplicationService, IDocumentFlowAuthorizationService)

      public

        function IsRoleAssignedToClient(
          const ClientIdentity: Variant;
          const RoleIdentity: Variant
        ): Boolean; virtual; abstract;

        procedure EnsureThatRoleAssignedToClient(
          const RoleIdentity: Variant;
          const ClientIdentity: Variant
        ); virtual; abstract;

        procedure AssignRoleToClient(
          const RoleIdentity: Variant;
          const ClientIdentity: Variant
        ); virtual; abstract;

      public

        function GetEmployeeSystemRoleFlags(const EmployeeId: Variant): TDocumentFlowSystemRoleFlags; virtual; abstract;
        procedure EnsureEmployeeHasSystemRoles(const EmployeeId: Variant; const Flags: TDocumentFlowSystemRoleFlags); virtual;

        function IsEmployeeAdminView(const EmployeeId: Variant): Boolean; virtual; abstract;
        function IsEmployeeAdminEdit(const EmployeeId: Variant): Boolean; virtual; abstract;
        function IsCurrentEmployeeSDUser: Boolean; virtual; abstract;

        procedure EnsureEmployeeIsAdminView(const EmployeeId: Variant); virtual;
        procedure EnsureEmployeeIsAdminEdit(const EmployeeId: Variant); virtual;

        procedure MakeEmployeeAsAdminView(const EmployeeId: Variant); virtual; abstract;
        procedure MakeEmployeeAsAdminEdit(const EmployeeId: Variant); virtual; abstract;

    end;
    
implementation

{ TAbstractDocumentFlowAuthorizationService }

procedure TAbstractDocumentFlowAuthorizationService.EnsureEmployeeHasSystemRoles(
  const EmployeeId: Variant; const Flags: TDocumentFlowSystemRoleFlags
);
var
    EmployeeSystemRoleFlags: TDocumentFlowSystemRoleFlags;
    Success: Boolean;
begin

  EmployeeSystemRoleFlags := GetEmployeeSystemRoleFlags(EmployeeId);

  if Flags.HasAdminViewRole then
    Success := EmployeeSystemRoleFlags.HasAdminViewRole or EmployeeSystemRoleFlags.HasAdminEditRole;

  if Flags.HasAdminEditRole then
    Success := Success and EmployeeSystemRoleFlags.HasAdminEditRole;

  if not Success then begin

    raise TDocumentFlowAuthorizationServiceException.Create(
      'Отсутствуют требуемые системные роли'
    );

  end;

end;

procedure TAbstractDocumentFlowAuthorizationService.
  EnsureEmployeeIsAdminEdit(const EmployeeId: Variant);
begin

  if not IsEmployeeAdminEdit(EmployeeId) then begin

    raise TDocumentFlowAuthorizationServiceException.Create(
      'У сотрудника отсутствуют права администратора'
    );

  end;

end;

procedure TAbstractDocumentFlowAuthorizationService.
  EnsureEmployeeIsAdminView(const EmployeeId: Variant);
begin

  if not IsEmployeeAdminView(EmployeeId) then begin

    raise TDocumentFlowAuthorizationServiceException.Create(
      'У сотрудника отсутствуют права администратора'
    );
    
  end;

end;

end.
