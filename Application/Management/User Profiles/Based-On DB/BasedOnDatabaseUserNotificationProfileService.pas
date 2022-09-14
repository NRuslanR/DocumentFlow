{ refactor: SQL logic move to repository and inject latter to this service }
unit BasedOnDatabaseUserNotificationProfileService;

interface

uses

  UserNotificationProfile,
  UserNotificationProfileService,
  UserNotificationProfileAccessRightsService,
  Session,
  DB,
  IEmployeeRepositoryUnit,
  Employee,
  QueryExecutor,
  Disposable,
  VariantListUnit,
  EmployeeSetHolder,
  AbstractApplicationService,
  EmployeeSetReadService,
  DataReader,
  SysUtils,
  Classes;

type

  TUserNotificationProfileDbSchema = class

    public

      ProfileTableName: String;
      UsersForWhichPermissibleReceivingNotificationsToOthersTableName: String;
      
      ProfileTableUserIdColumnName: String;
      ProfileTableReceivingNotificationsEnabledColumnName: String;

      UserIdForWhichReceivingPermissibleColumnName: String;
      ForOtherUserReceivingUserIdColumnName: String;
      
  end;

  TBasedOnDatabaseUserNotificationProfileService =
    class (TAbstractApplicationService, IUserNotificationProfileService)

      protected

        FUserNotificationProfileFetchingQueryPattern: String;
        FUserNotificationProfileSavingQueryPattern: String;
        FAllPermissibleReceivingOwnNotificationsUsersRemovingQueryPattern: String;
        FNotificationProfilesForUsersAndThoseWhoCanReceiveNotificationsForThemFetchingQueryPattern: String;
        FPermissibleReceivingOwnNotificationsUsersAddingQueryPattern: String;
        
        FUserNotificationProfileDbSchema: TUserNotificationProfileDbSchema;
        FUserNotificationProfileAccessRightsService: IUserNotificationProfileAccessRightsService;
        FEmployeeSetReadService: IEmployeeSetReadService;
        FEmployeeRepository: IEmployeeRepository;
        FQueryExecutor: IQueryExecutor;
        FSession: ISession;

      protected

        function PrepareUserNotificationProfileFetchingQueryPattern(
          UserNotificationProfileDbSchema: TUserNotificationProfileDbSchema
        ): String; virtual;

        function PrepareUserNotificationProfileSavingQueryPattern(
          UserNotificationProfileDbSchema: TUserNotificationProfileDbSchema
        ): String; virtual;

        function PrepareAllPermissibleReceivingOwnNotificationsUsersRemovingQueryPattern(
          UserNotificationProfileDbSchema: TUserNotificationProfileDbSchema
        ): String; virtual;

        function PreparePermissibleReceivingOwnNotificationsUsersAddingQueryPattern(
          UserNotificationProfileDbSchema: TUserNotificationProfileDbSchema
        ): String; virtual;

        function PrepareNotificationProfilesForUsersAndThoseWhoCanReceiveNotificationsForThemFetchingQueryPattern(
          UserNotificationProfileDbSchema: TUserNotificationProfileDbSchema
        ): String; virtual;
        
      protected

        procedure RaiseUserNotificationProfileSavingFailException;
        procedure RaiseUserNotificationProfileFetchingFailException;

      protected

        function ExecuteUserNotificationProfileFetchingQuery(
          const QueryPattern: String;
          const UserId: Variant
        ): IDataReader; virtual;

        procedure ExecuteUserNotificationProfileSavingQuery(
          const QueryPattern: String;
          const UserNotificationProfile: TUserNotificationProfile
        ); virtual;

        procedure ExecuteAllPermissibleReceivingOwnNotificationsUsersRemovingQuery(
          const QueryPattern: String;
          const UserId: Variant
        ); virtual;

        procedure ExecutePermissibleReceivingOwnNotificationsUsersAddingQuery(
          const QueryPattern: String;
          const UserId: Variant;
          const PermissibleReceivingForUserIds: TVariantList
        ); virtual;

        function ExecuteNotificationProfilesForUsersAndThoseWhoCanReceiveNotificationsForThemFetchingQuery(
          QueryPattern: String;
          const UserIds: TVariantList;
          const Options: IUserNotificationProfileGettingOptions
        ): IDataReader; virtual;

      protected

        function ChangeFetchingQueryPatternByOptions(
          QueryPattern: String;
          const Options: IUserNotificationProfileGettingOptions
        ): String;
        
      protected
      
        procedure RaiseExceptionIfUserNotificationProfileIsNotValid(
          UserNotificationProfile: TUserNotificationProfile
        );

        procedure RaiseExceptionIfOwnNotificationsReceivingUsersNotValid(Profile: TUserNotificationProfile);
        
        procedure RaiseUserNotificationProfileIsNotValidException;

        procedure RaiseExceptionIfUserIdIsNotValid(const UserId: Variant);

        procedure RaiseExceptionIfUserIdsAreNotValid(const UserIds: TVariantList);

        procedure RaiseUserIdIsNotValidException;
        procedure RaiseUserIdsAreNotValidException;

      protected

        function CreateUserNotificationProfileFrom(DataReader: IDataReader): TUserNotificationProfile;
        function CreateUserNotificationProfilesFrom(DataReader: IDataReader): TUserNotificationProfiles;

      public

        destructor Destroy; override;
        constructor Create(
          UserNotificationProfileDbSchema: TUserNotificationProfileDbSchema;
          QueryExecutor: IQueryExecutor;
          Session: ISession;
          UserNotificationProfileAccessRightsService: IUserNotificationProfileAccessRightsService;
          EmployeeRepository: IEmployeeRepository;
          EmployeeSetReadService: IEmployeeSetReadService
        );

        function GetNotificationProfilesForUsersAndThoseWhoCanReceiveNotificationsForThem(
          UserIds: TVariantList;
          Options: IUserNotificationProfileGettingOptions = nil
        ): TUserNotificationProfiles;

        function GetNotificationProfileForUser(const UserId: Variant): TUserNotificationProfile;
        procedure SaveUserNotificationProfile(UserNotificationProfile: TUserNotificationProfile);

        function GetAllowedOwnNotificationsReceivingUserSetForUser(const UserId: Variant): TEmployeeSetHolder;
        
    end;

implementation

uses

  Variants,
  StrUtils,
  AuxDataSetFunctionsUnit,
  IDomainObjectBaseUnit,
  IDomainObjectBaseListUnit,
  AuxiliaryStringFunctions;

{ TBasedOnDatabaseUserNotificationProfileService }

function TBasedOnDatabaseUserNotificationProfileService.
  ChangeFetchingQueryPatternByOptions(
    QueryPattern: String;
    const Options: IUserNotificationProfileGettingOptions
  ): String;
var ConditionalClause: String;
begin

  if not ContainsText(QueryPattern, 'select') then begin

    raise TUserNotificationProfileServiceException.Create(
      'Query pattern does not contain select hint'
    );

  end;

  if Options.ReceivingNotificationsEnabledAssigned then begin

    ConditionalClause :=
      Format(
        '%s=%s',
        [
          FUserNotificationProfileDbSchema.ProfileTableReceivingNotificationsEnabledColumnName,
          BoolToStr(Options.ReceivingNotificationsEnabled, True)
        ]
      );

  end;

  if ConditionalClause = '' then Exit;

  if ContainsText(QueryPattern, 'recursive') then begin

    Insert(
      ' WHERE ' + ConditionalClause + ' ',
      QueryPattern,
      Pos('ORDER', QueryPattern)
    );

    Result := QueryPattern;

  end

  else begin

    if not ContainsText(QueryPattern, 'where') then
      Result := QueryPattern + ' WHERE '

    else Result := QueryPattern + ' AND ';

    Result := Result + ConditionalClause;

  end;
  
end;

constructor TBasedOnDatabaseUserNotificationProfileService.Create(
  UserNotificationProfileDbSchema: TUserNotificationProfileDbSchema;
  QueryExecutor: IQueryExecutor;
  Session: ISession;
  UserNotificationProfileAccessRightsService: IUserNotificationProfileAccessRightsService;
  EmployeeRepository: IEmployeeRepository;
  EmployeeSetReadService: IEmployeeSetReadService
);
begin

  inherited Create;

  FUserNotificationProfileDbSchema := UserNotificationProfileDbSchema;
  FQueryExecutor := QueryExecutor;
  FSession := Session;
  FUserNotificationProfileAccessRightsService := UserNotificationProfileAccessRightsService;
  FEmployeeRepository := EmployeeRepository;
  FEmployeeSetReadService := EmployeeSetReadService;
  
  FUserNotificationProfileFetchingQueryPattern :=
    PrepareUserNotificationProfileFetchingQueryPattern(
      UserNotificationProfileDbSchema
    );

  FUserNotificationProfileSavingQueryPattern :=
    PrepareUserNotificationProfileSavingQueryPattern(
      UserNotificationProfileDbSchema
    );

  FAllPermissibleReceivingOwnNotificationsUsersRemovingQueryPattern :=
    PrepareAllPermissibleReceivingOwnNotificationsUsersRemovingQueryPattern(
      UserNotificationProfileDbSchema
    );

  FPermissibleReceivingOwnNotificationsUsersAddingQueryPattern :=
    PreparePermissibleReceivingOwnNotificationsUsersAddingQueryPattern(
      UserNotificationProfileDbSchema
    );

  FNotificationProfilesForUsersAndThoseWhoCanReceiveNotificationsForThemFetchingQueryPattern :=
    PrepareNotificationProfilesForUsersAndThoseWhoCanReceiveNotificationsForThemFetchingQueryPattern(
      UserNotificationProfileDbSchema
    );
    
end;

function TBasedOnDatabaseUserNotificationProfileService.
  PrepareAllPermissibleReceivingOwnNotificationsUsersRemovingQueryPattern(
    UserNotificationProfileDbSchema: TUserNotificationProfileDbSchema
  ): String;
begin

  Result :=
    Format(
      'DELETE FROM %s WHERE %s=:p%s',
      [
        UserNotificationProfileDbSchema
          .UsersForWhichPermissibleReceivingNotificationsToOthersTableName,

        UserNotificationProfileDbSchema.UserIdForWhichReceivingPermissibleColumnName,
        UserNotificationProfileDbSchema.UserIdForWhichReceivingPermissibleColumnName
      ]
    );
    
end;

function TBasedOnDatabaseUserNotificationProfileService.
  PreparePermissibleReceivingOwnNotificationsUsersAddingQueryPattern(
    UserNotificationProfileDbSchema: TUserNotificationProfileDbSchema
  ): String;
begin

  Result :=
    Format(
      'INSERT INTO %s (%s, %s)',
      [
        UserNotificationProfileDbSchema
          .UsersForWhichPermissibleReceivingNotificationsToOthersTableName,

        UserNotificationProfileDbSchema.UserIdForWhichReceivingPermissibleColumnName,
        UserNotificationProfileDbSchema.ForOtherUserReceivingUserIdColumnName
      ]
    );

end;

function TBasedOnDatabaseUserNotificationProfileService.
  PrepareUserNotificationProfileFetchingQueryPattern(
    UserNotificationProfileDbSchema: TUserNotificationProfileDbSchema
  ): String;
begin

  Result :=
    Format(
      'SELECT ' +
      'A.%s, A.%s, B.%s ' +
      'FROM %s A ' +
      'LEFT JOIN %s B ON B.%s = A.%s ' +
      'WHERE %s = :p%s',
      [
        UserNotificationProfileDbSchema.ProfileTableUserIdColumnName,

        UserNotificationProfileDbSchema
          .ProfileTableReceivingNotificationsEnabledColumnName,

        UserNotificationProfileDbSchema
          .ForOtherUserReceivingUserIdColumnName,

        UserNotificationProfileDbSchema.ProfileTableName,

        UserNotificationProfileDbSchema
          .UsersForWhichPermissibleReceivingNotificationsToOthersTableName,

        UserNotificationProfileDbSchema.UserIdForWhichReceivingPermissibleColumnName,
        UserNotificationProfileDbSchema.ProfileTableUserIdColumnName,

        UserNotificationProfileDbSchema.ProfileTableUserIdColumnName,
        UserNotificationProfileDbSchema.ProfileTableUserIdColumnName
      ]
    );

end;

function TBasedOnDatabaseUserNotificationProfileService.
  PrepareNotificationProfilesForUsersAndThoseWhoCanReceiveNotificationsForThemFetchingQueryPattern(
    UserNotificationProfileDbSchema: TUserNotificationProfileDbSchema
  ): String;
begin

  Result :=
    Format(
      'WITH RECURSIVE user_notification_profiles ' +
      '(%s, %s, %s) AS (' +
      'select ' +
      'a.%s,' +
      'a.%s,' +
      'b.%s ' +
      'FROM %s a ' +
      'LEFT JOIN %s b ' +
      'ON b.%s = a.%s ' +
      'WHERE a.%s in (:p%s) ' +
      'UNION ' +
      'SELECT ' +
      'e.%s,' +
      'e.%s,' +
      't.%s ' +
      'FROM user_notification_profiles unp ' +
      'JOIN %s e ON e.%s = unp.%s ' +
      'LEFT JOIN %s t ON t.%s = e.%s' +
      ') ' +
      'SELECT * from user_notification_profiles ORDER BY %s',
      [
        UserNotificationProfileDbSchema.ProfileTableUserIdColumnName,
        UserNotificationProfileDbSchema.ProfileTableReceivingNotificationsEnabledColumnName,
        UserNotificationProfileDbSchema.ForOtherUserReceivingUserIdColumnName,

        UserNotificationProfileDbSchema.ProfileTableUserIdColumnName,
        UserNotificationProfileDbSchema.ProfileTableReceivingNotificationsEnabledColumnName,
        UserNotificationProfileDbSchema.ForOtherUserReceivingUserIdColumnName,

        UserNotificationProfileDbSchema.ProfileTableName,
        UserNotificationProfileDbSchema.UsersForWhichPermissibleReceivingNotificationsToOthersTableName,

        UserNotificationProfileDbSchema.UserIdForWhichReceivingPermissibleColumnName,
        UserNotificationProfileDbSchema.ProfileTableUserIdColumnName,

        UserNotificationProfileDbSchema.ProfileTableUserIdColumnName,
        UserNotificationProfileDbSchema.ProfileTableUserIdColumnName,

        UserNotificationProfileDbSchema.ProfileTableUserIdColumnName,
        UserNotificationProfileDbSchema.ProfileTableReceivingNotificationsEnabledColumnName,
        UserNotificationProfileDbSchema.ForOtherUserReceivingUserIdColumnName,

        UserNotificationProfileDbSchema.ProfileTableName,

        UserNotificationProfileDbSchema.ProfileTableUserIdColumnName,
        UserNotificationProfileDbSchema.ForOtherUserReceivingUserIdColumnName,

        UserNotificationProfileDbSchema.UsersForWhichPermissibleReceivingNotificationsToOthersTableName,
        UserNotificationProfileDbSchema.UserIdForWhichReceivingPermissibleColumnName,
        UserNotificationProfileDbSchema.ProfileTableUserIdColumnName,

        UserNotificationProfileDbSchema.ProfileTableUserIdColumnName
      ]
    );

end;

function TBasedOnDatabaseUserNotificationProfileService.
  PrepareUserNotificationProfileSavingQueryPattern(
    UserNotificationProfileDbSchema: TUserNotificationProfileDbSchema
  ): String;
begin

  Result :=
    Format(
      'UPDATE %s ' +
      'SET %s = :p%s ' +
      'WHERE %s = :p%s',
      [
        UserNotificationProfileDbSchema.ProfileTableName,

        UserNotificationProfileDbSchema
          .ProfileTableReceivingNotificationsEnabledColumnName,

        UserNotificationProfileDbSchema
          .ProfileTableReceivingNotificationsEnabledColumnName,

        UserNotificationProfileDbSchema.ProfileTableUserIdColumnName,
        UserNotificationProfileDbSchema.ProfileTableUserIdColumnName
      ]
    );

end;

function TBasedOnDatabaseUserNotificationProfileService.CreateUserNotificationProfileFrom(
  DataReader: IDataReader): TUserNotificationProfile;
var
    ForOtherUserReceivingUserId: Variant;
    Employee: TEmployee;
    FreeEmployee: IDomainObjectBase;
begin

  Result := TUserNotificationProfile.Create;

  try

    with FUserNotificationProfileDbSchema do begin

      Result.UserId := DataReader[ProfileTableUserIdColumnName];

      Result.ReceivingNotificationsEnabled :=
        DataReader[ProfileTableReceivingNotificationsEnabledColumnName];

      Employee := FEmployeeRepository.FindEmployeeById(Result.UserId);

      if Assigned(Employee) then begin

        FreeEmployee := Employee;

        Result.AccessRights :=
          FUserNotificationProfileAccessRightsService
            .GetUserNotificationProfileAccessRights(Employee);

      end;

      repeat

        if Result.UserId <> DataReader[ProfileTableUserIdColumnName] then begin

          DataReader.Previous;
          Exit;

        end;

        ForOtherUserReceivingUserId :=
          DataReader[ForOtherUserReceivingUserIdColumnName];

        if VarIsNull(ForOtherUserReceivingUserId) then Continue;

        Result.AddUserForWhichReceivingOwnNotificationsPermissible(
          ForOtherUserReceivingUserId
        );

      until not DataReader.Next;

    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TBasedOnDatabaseUserNotificationProfileService.CreateUserNotificationProfilesFrom(
  DataReader: IDataReader
): TUserNotificationProfiles;
var
    UserNotificationProfile:  TUserNotificationProfile;
    FreeUserNotificationProfile: IDisposable;
begin

  Result := TUserNotificationProfiles.Create;

  try

    with FUserNotificationProfileDbSchema do begin

      while DataReader.Next do begin

        UserNotificationProfile := CreateUserNotificationProfileFrom(DataReader);
        FreeUserNotificationProfile := UserNotificationProfile;

        Result.Add(UserNotificationProfile);

      end;

    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

destructor TBasedOnDatabaseUserNotificationProfileService.Destroy;
begin

  FreeAndNil(FUserNotificationProfileDbSchema);
  
  inherited;

end;

function TBasedOnDatabaseUserNotificationProfileService.GetAllowedOwnNotificationsReceivingUserSetForUser(
  const UserId: Variant
): TEmployeeSetHolder;
begin

  Result := FEmployeeSetReadService.GetLeadershipEmployeeSetForLeader(UserId);

end;

function TBasedOnDatabaseUserNotificationProfileService.
  GetNotificationProfileForUser(
    const UserId: Variant
  ): TUserNotificationProfile;

var
    DataReader: IDataReader;
begin

  RaiseExceptionIfUserIdIsNotValid(UserId);

  DataReader :=
    ExecuteUserNotificationProfileFetchingQuery(
      FUserNotificationProfileFetchingQueryPattern, UserId
    );

  if DataReader.RecordCount > 0 then begin

    DataReader.Next;

    Result := CreateUserNotificationProfileFrom(DataReader);

  end

  else Result := nil;
  
end;

{ refactor: merge UserNotificationProfiles into more coarse-grained composites }

function TBasedOnDatabaseUserNotificationProfileService.
  GetNotificationProfilesForUsersAndThoseWhoCanReceiveNotificationsForThem(
    UserIds: TVariantList;
    Options: IUserNotificationProfileGettingOptions
  ): TUserNotificationProfiles;
var
    DataReader: IDataReader;
begin

  RaiseExceptionIfUserIdsAreNotValid(UserIds);

  if not Assigned(Options) then
    Options := TUserNotificationProfileGettingOptions.CreateAsStandard;
    
  DataReader :=
    ExecuteNotificationProfilesForUsersAndThoseWhoCanReceiveNotificationsForThemFetchingQuery(
      FNotificationProfilesForUsersAndThoseWhoCanReceiveNotificationsForThemFetchingQueryPattern,
      UserIds,
      Options
    );

  if DataReader.RecordCount = 0 then begin

    Result := nil;
    Exit;

  end;

  Result := CreateUserNotificationProfilesFrom(DataReader);

end;

procedure TBasedOnDatabaseUserNotificationProfileService.
  SaveUserNotificationProfile(
    UserNotificationProfile: TUserNotificationProfile
  );
begin

  RaiseExceptionIfUserNotificationProfileIsNotValid(UserNotificationProfile);

  FSession.Start;

  try

    ExecuteUserNotificationProfileSavingQuery(
      FUserNotificationProfileSavingQueryPattern,
      UserNotificationProfile
    );

    FSession.Commit;

  except

    FSession.Rollback;

    Raise;

  end;

end;

function TBasedOnDatabaseUserNotificationProfileService.
  ExecuteUserNotificationProfileFetchingQuery(
    const QueryPattern: String;
    const UserId: Variant
  ): IDataReader;
var QueryParams: TQueryParams;
begin

  QueryParams := TQueryParams.Create;

  try

    QueryParams.Add(
      'p' + FUserNotificationProfileDbSchema.ProfileTableUserIdColumnName,
      UserId
    );

    Result := FQueryExecutor.ExecuteSelectionQuery(QueryPattern, QueryParams);

  finally

    FreeAndNil(QueryParams);
    
  end;

end;

procedure TBasedOnDatabaseUserNotificationProfileService.
  ExecuteUserNotificationProfileSavingQuery(
    const QueryPattern: String;
    const UserNotificationProfile: TUserNotificationProfile
  );
var QueryParams: TQueryParams;
begin

  QueryParams := TQueryParams.Create;

  try

    QueryParams
      .AddFluently(
        'p' + FUserNotificationProfileDbSchema.ProfileTableUserIdColumnName,
        UserNotificationProfile.UserId
      )
      .AddFluently(

        'p' +
        FUserNotificationProfileDbSchema
          .ProfileTableReceivingNotificationsEnabledColumnName,

        UserNotificationProfile.ReceivingNotificationsEnabled
      );

    FQueryExecutor.ExecuteModificationQuery(QueryPattern, QueryParams);

    ExecuteAllPermissibleReceivingOwnNotificationsUsersRemovingQuery(
      FAllPermissibleReceivingOwnNotificationsUsersRemovingQueryPattern,
      UserNotificationProfile.UserId
    );

    if
      not
      UserNotificationProfile
        .PermissibleReceivingOwnNotificationsUserIds
          .IsEmpty
    then begin

      ExecutePermissibleReceivingOwnNotificationsUsersAddingQuery(
        FPermissibleReceivingOwnNotificationsUsersAddingQueryPattern,
        UserNotificationProfile.UserId,
        UserNotificationProfile.PermissibleReceivingOwnNotificationsUserIds
      );

    end;


  finally

    FreeAndNil(QueryParams);

  end;

end;

procedure TBasedOnDatabaseUserNotificationProfileService.
  ExecuteAllPermissibleReceivingOwnNotificationsUsersRemovingQuery(
    const QueryPattern: String;
    const UserId: Variant
  );
var QueryParams: TQueryParams;
begin

  QueryParams := TQueryParams.Create;

  try

    QueryParams.Add(
      'p' +
      FUserNotificationProfileDbSchema.UserIdForWhichReceivingPermissibleColumnName,
      UserId
    );

    FQueryExecutor.ExecuteModificationQuery(QueryPattern, QueryParams);
    
  finally

    FreeAndNil(QueryParams);

  end;

end;

function TBasedOnDatabaseUserNotificationProfileService.
  ExecuteNotificationProfilesForUsersAndThoseWhoCanReceiveNotificationsForThemFetchingQuery(
    QueryPattern: String;
    const UserIds: TVariantList;
    const Options: IUserNotificationProfileGettingOptions
  ): IDataReader;
var QueryText: String;
begin

  if Assigned(Options) then
    QueryPattern := ChangeFetchingQueryPatternByOptions(QueryPattern, Options);

  QueryText :=
    ReplaceStr(
      QueryPattern,
      ':p' + FUserNotificationProfileDbSchema.ProfileTableUserIdColumnName,
      CreateStringFromVariantList(UserIds)
    );

  Result := FQueryExecutor.ExecuteSelectionQuery(QueryText);

end;

procedure TBasedOnDatabaseUserNotificationProfileService.
  ExecutePermissibleReceivingOwnNotificationsUsersAddingQuery(
    const QueryPattern: String;
    const UserId: Variant;
    const PermissibleReceivingForUserIds: TVariantList
  );
var PermissibleUserId: Variant;
    QueryText: String;
    ValuesList: String;
    Values: String;
begin

  for PermissibleUserId in PermissibleReceivingForUserIds do begin

    Values :=
      Format(
        '(%s, %s)',
        [
          VarToStr(UserId),
          VarToStr(PermissibleUserId)
        ]
      );

    if ValuesList = '' then
      ValuesList := Values

    else ValuesList := ValuesList + ', ' + Values;

  end;

  QueryText := QueryPattern + ' VALUES ' + ValuesList;

  if FQueryExecutor.ExecuteModificationQuery(QueryText) = 0 then
    RaiseUserNotificationProfileSavingFailException;
  
end;

procedure TBasedOnDatabaseUserNotificationProfileService.
  RaiseExceptionIfOwnNotificationsReceivingUsersNotValid(Profile: TUserNotificationProfile);
var
    AllowedOwnNotificationsReceivingUserSet: TEmployeeSetHolder;
begin

  if not Assigned(Profile.PermissibleReceivingOwnNotificationsUserIds) then Exit;

  AllowedOwnNotificationsReceivingUserSet :=  
    GetAllowedOwnNotificationsReceivingUserSetForUser(Profile.UserId);

  if 
    not 
    AllowedOwnNotificationsReceivingUserSet.ContainsRecords(
      Profile.PermissibleReceivingOwnNotificationsUserIds
    )
  then begin
  
    Raise TUserNotificationProfileServiceException.Create(
      'Ќедопустимый перечень пользователей, которым допустимо ' +
      'получать уведомлени€ данного пользовател€'
    );
    
  end;
  
end;

procedure TBasedOnDatabaseUserNotificationProfileService.RaiseExceptionIfUserIdIsNotValid(
  const UserId: Variant);
begin

  if VarIsNull(UserId) or VarIsEmpty(UserId)
  then RaiseUserIdIsNotValidException;
  
end;

procedure TBasedOnDatabaseUserNotificationProfileService.
  RaiseExceptionIfUserIdsAreNotValid(const UserIds: TVariantList);
begin

  if
    not Assigned(UserIds) or
    UserIds.Contains(Null) or
    UserIds.Contains(Unassigned)
  then
    RaiseUserIdsAreNotValidException;

end;

procedure TBasedOnDatabaseUserNotificationProfileService.
  RaiseExceptionIfUserNotificationProfileIsNotValid(
    UserNotificationProfile: TUserNotificationProfile
  );
begin

  if not Assigned(UserNotificationProfile) then
    RaiseUserNotificationProfileIsNotValidException;
  
  RaiseExceptionIfUserIdIsNotValid(UserNotificationProfile.UserId);
  RaiseExceptionIfOwnNotificationsReceivingUsersNotValid(UserNotificationProfile) ;

end;

procedure TBasedOnDatabaseUserNotificationProfileService.RaiseUserIdIsNotValidException;
begin

  raise TUserNotificationProfileServiceException.Create(
    '»дентификатор пользовател€ недействителен ' +
    'дл€ получени€ данных профил€ уведомлений'
  );

end;

procedure TBasedOnDatabaseUserNotificationProfileService.
  RaiseUserIdsAreNotValidException;
begin

  raise TUserNotificationProfileServiceException.Create(
    'Ќекоторые из идентификаторов пользователей недействителены ' +
    'дл€ получени€ профилей уведомлений'
  );

end;

procedure TBasedOnDatabaseUserNotificationProfileService.RaiseUserNotificationProfileFetchingFailException;
begin

  raise TUserNotificationProfileServiceException.Create(
    'Ќе удалось получить данные ' +
    'профил€ уведомлений пользовател€'
  );
  
end;

procedure TBasedOnDatabaseUserNotificationProfileService.
RaiseUserNotificationProfileIsNotValidException;
begin

  raise TUserNotificationProfileServiceException.Create(
    'ѕрофиль уведомлений пользовател€ ' +
    'недействителен'
  );

end;

procedure TBasedOnDatabaseUserNotificationProfileService.
  RaiseUserNotificationProfileSavingFailException;
begin

  raise TUserNotificationProfileServiceException.Create(
    'Ќе удалось сохранить данные ' +
    'профил€ уведомлений пользовател€'
  );

end;

end.
