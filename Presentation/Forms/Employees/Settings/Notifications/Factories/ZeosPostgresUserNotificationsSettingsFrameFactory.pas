unit ZeosPostgresUserNotificationsSettingsFrameFactory;

interface

uses

  UserNotificationsSettingsFrameFactory,
  unUserNotificationsSettingsFrame,
  UserNotificationProfileService,
  BasedOnDatabaseUserNotificationProfileService,
  ZQueryExecutor,
  QueryExecutor,
  ZConnection,
  PostgresTransaction,
  Classes,
  IEmployeeRepositoryUnit,
  EmployeePostgresRepository,
  BasedOnDatabaseEmployeeSetReadService,
  UserNotificationProfileAccessRightsService,
  StandardUserNotificationProfileAccessRightsService,
  UserNotificationsSettingsFormViewModelMapper,
  DataSetQueryExecutor,
  SysUtils;

type

  TZeosPostgresUserNotificationsSettingsFrameFactory =
    class (TInterfacedObject, IUserNotificationsSettingsFrameFactory)

      private

        FZConnection: TZConnection;

      public

        constructor Create(ZConnection: TZConnection);

        function CreateUserNotificationsSettingsFrame(
          Owner: TComponent;
          UserId: Variant
        ): TUserNotificationsSettingsFrame;

    end;

implementation

uses

  EmployeeDbSchema,
  EmployeeTableDef,
  DepartmentTableDef,
  Role,
  RoleTableDef,
  EmployeeWorkGroupTableDef,
  EmployeeWorkGroupAssocTableDef,
  DepartmentDbSchema,
  RoleDbSchema,
  EmployeeWorkGroupAssociationDbSchema;

{ TZeosPostgresUserNotificationsSettingsFrameFactory }

constructor TZeosPostgresUserNotificationsSettingsFrameFactory.Create(
  ZConnection: TZConnection);
begin

  inherited Create;

  FZConnection := ZConnection;
  
end;

function TZeosPostgresUserNotificationsSettingsFrameFactory.
  CreateUserNotificationsSettingsFrame(
    Owner: TComponent;
    UserId: Variant
  ): TUserNotificationsSettingsFrame;
var
    QueryExecutor: IQueryExecutor;
    UserNotificationProfileDbSchema: TUserNotificationProfileDbSchema;
    EmployeeDbSchema: TEmployeeDbSchema;
    DepartmentDbSchema: TDepartmentDbSchema;
    RoleDbSchema: TRoleDbSchema;
    EmployeeWorkGroupAssociationDbSchema: TEmployeeWorkGroupAssociationDbSchema;
    EmployeeRepository: IEmployeeRepository;
    UserNotificationProfileService: IUserNotificationProfileService;
begin

  UserNotificationProfileDbSchema := TUserNotificationProfileDbSchema.Create;

  UserNotificationProfileDbSchema.ProfileTableName := 'doc.employees';
  UserNotificationProfileDbSchema.UsersForWhichPermissibleReceivingNotificationsToOthersTableName :=
    'doc.users_for_which_permissible_receiving_notification_to_others';

  UserNotificationProfileDbSchema.ProfileTableUserIdColumnName := 'id';
  UserNotificationProfileDbSchema.ProfileTableReceivingNotificationsEnabledColumnName :=
    'receiving_notifications_enabled';

  UserNotificationProfileDbSchema.UserIdForWhichReceivingPermissibleColumnName :=
    'user_id_for_which_receiving_permissible';

  UserNotificationProfileDbSchema.ForOtherUserReceivingUserIdColumnName :=
    'for_other_receiving_user_id';

  EmployeeDbSchema := TEmployeeDbSchema.Create;

  EmployeeDbSchema.TableName := EMPLOYEE_TABLE_NAME;
  EmployeeDbSchema.IdColumnName := EMPLOYEE_TABLE_ID_FIELD;
  EmployeeDbSchema.PersonnelNumberColumnName := EMPLOYEE_TABLE_PERSONNEL_NUMBER_FIELD;
  EmployeeDbSchema.NameColumnName := EMPLOYEE_TABLE_NAME_FIELD;
  EmployeeDbSchema.SurnameColumnName := EMPLOYEE_TABLE_SURNAME_FIELD;
  EmployeeDbSchema.PatronymicColumnName := EMPLOYEE_TABLE_PATRONYMIC_FIELD;
  EmployeeDbSchema.SpecialityColumnName := EMPLOYEE_TABLE_SPECIALITY_FIELD;
  EmployeeDbSchema.DepartmentIdColumnName := EMPLOYEE_TABLE_DEPARTMENT_ID_FIELD;
  EmployeeDbSchema.HeadKindredDepartmentIdColumnName := EMPLOYEE_TABLE_HEAD_KINDRED_DEPARTMENT_ID_FIELD;
  EmployeeDbSchema.TelephoneNumberColumnName := EMPLOYEE_TABLE_TELEPHONE_NUMBER_FIELD;
  EmployeeDbSchema.IsForeignColumnName := EMPLOYEE_TABLE_IS_FOREIGN_FIELD;
  EmployeeDbSchema.WasDismissedColumnName := EMPLOYEE_TABLE_IS_DISMISSED_FIELD;
  EmployeeDbSchema.IsSDUserColumnName := EMPLOYEE_TABLE_IS_SD_USER_FIELD;
  EmployeeDbSchema.TopLevelEmployeeIdColumnName := EMPLOYEE_TABLE_LEADER_ID_FIELD;
  
  DepartmentDbSchema := TDepartmentDbSchema.Create;

  DepartmentDbSchema.TableName := DEPARTMENT_TABLE_NAME;
  DepartmentDbSchema.IdColumnName := DEPARTMENT_TABLE_ID_FIELD;
  DepartmentDbSchema.CodeColumnName := DEPARTMENT_TABLE_CODE_FIELD;
  DepartmentDbSchema.ShortNameColumnName := DEPARTMENT_TABLE_SHORT_NAME_FIELD;
  DepartmentDbSchema.FullNameColumnName := DEPARTMENT_TABLE_FULL_NAME_FIELD;

  RoleDbSchema := TRoleDbSchema.Create;

  RoleDbSchema.TableName := ROLE_TABLE_NAME;
  RoleDbSchema.IdColumnName := ROLE_TABLE_ID_FIELD;
  RoleDbSchema.RoleNameColumnName := ROLE_TABLE_DESCRIPTION_FIELD;

  EmployeeWorkGroupAssociationDbSchema := TEmployeeWorkGroupAssociationDbSchema.Create;

  EmployeeWorkGroupAssociationDbSchema.TableName := EMPLOYEE_WORK_GROUPS_ASSOCIATION_TABLE_NAME;
  EmployeeWorkGroupAssociationDbSchema.EmployeeIdColumnName := EMPLOYEE_WORK_GROUPS_ASSOCIATION_TABLE_EMPLOYEE_ID_FIELD;
  EmployeeWorkGroupAssociationDbSchema.WorkGroupIdColumnName := EMPLOYEE_WORK_GROUPS_ASSOCIATION_TABLE_WORK_GROUP_ID_FIELD;

  QueryExecutor := TZQueryExecutor.Create(FZConnection);

  EmployeeRepository := TEmployeePostgresRepository.Create(QueryExecutor);

  UserNotificationProfileService :=
    TBasedOnDatabaseUserNotificationProfileService.Create(
      UserNotificationProfileDbSchema,
      QueryExecutor,
      TPostgresTransaction.Create(QueryExecutor),
      TStandardUserNotificationProfileAccessRightsService.Create(
        TRoleMemento.GetLeadershipRoles,
        EmployeeRepository
      ),
      EmployeeRepository,
      TBasedOnDatabaseEmployeeSetReadService.Create(
        EmployeeDbSchema,
        DepartmentDbSchema,
        RoleDbSchema,
        EmployeeWorkGroupAssociationDbSchema,
        TDataSetQueryExecutor(QueryExecutor.Self)
      )
    );

  Result :=
    TUserNotificationsSettingsFrame.Create(
      Owner,
      UserNotificationProfileService,
      TUserNotificationsSettingsFormViewModelMapper.Create(UserNotificationProfileService),
      UserId
    );

end;

end.
