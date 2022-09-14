unit UserNotificationProfile;

interface

uses

  SysUtils,
  VariantListUnit,
  Disposable,
  Classes;

type


  TUserNotificationProfileAccessRights = class (TInterfacedObject, IDisposable)

    public

      OwnNotificationsReceivingUsersEditingAllowed: Boolean;
      
  end;

  TUserNotificationProfile = class (TInterfacedObject, IDisposable)

    private

      FUserId: Variant;
      FReceivingNotificationsEnabled: Boolean;
      FPermissibleReceivingOwnNotificationsUserIds: TVariantList;

      FAccessRights: TUserNotificationProfileAccessRights;
      FFreeAccessRights: IDisposable;

      procedure SetAccessRights(const Value: TUserNotificationProfileAccessRights);
      procedure SetPermissibleReceivingOwnNotificationsUserIds(const Value: TVariantList);

    public

      destructor Destroy; override;
      constructor Create;

      procedure AddUserForWhichReceivingOwnNotificationsPermissible(
        const PermissibleUserId: Variant
      );

      procedure AddUsersForWhichReceivingOwnNotificationsPermissible(
        const PermissibleUserIds: TVariantList
      );

      procedure RemoveUserForWhichReceivingOwnNotificationsPermissible(
        const PermissibleUserId: Variant
      );

      procedure RemoveUsersForWhichReceivingOwnNotificationsPermissible(
        const PermissibleUserIds: TVariantList
      );

      procedure RemoveAllUsersForWhichReceivingOwnNotificationsPermissible;

    published

      property UserId: Variant read FUserId write FUserId;

      property ReceivingNotificationsEnabled: Boolean
      read FReceivingNotificationsEnabled write FReceivingNotificationsEnabled;
      
      property PermissibleReceivingOwnNotificationsUserIds: TVariantList
      read FPermissibleReceivingOwnNotificationsUserIds
      write SetPermissibleReceivingOwnNotificationsUserIds;

      property AccessRights: TUserNotificationProfileAccessRights
      read FAccessRights write SetAccessRights;

  end;

  TUserNotificationProfiles = class;

  TUserNotificationProfilesEnumerator = class (TListEnumerator)

    protected

      function GetCurrentUserNotificationProfile: TUserNotificationProfile;

    public

      constructor Create(UserNotificationProfiles: TUserNotificationProfiles);

      property Current: TUserNotificationProfile
      read GetCurrentUserNotificationProfile;
      
  end;

  TSearchByReceivingNotificationsPossibility = (
    ReceivingNotificationsEnabledCriterion,
    ReceivingNotificationsDisabledCriterion
  );

  TUserNotificationProfileHolder = class

    strict private

      FProfile: TUserNotificationProfile;
      FFreeProfile: IDisposable;

      procedure SetProfile(const Value: TUserNotificationProfile);

    public

      constructor Create(Profile: TUserNotificationProfile);

      property Profile: TUserNotificationProfile
      read FProfile write SetProfile;

  end;

  TUserNotificationProfiles = class (TInterfacedObject, IDisposable)

    private

      FProfileHolderList: TList;

    private

      type

        TSearchPredicate =
          function (
            UserNotificationProfile: TUserNotificationProfile
          ): Boolean of object;
        
    private

      function GetUserNotificationProfileByIndex(
        Index: Integer
      ): TUserNotificationProfile;

      procedure SetUserNotificationProfileByIndex(
        Index: Integer;
        const Value: TUserNotificationProfile
      );

      function GetCount: Integer;
      
    protected

      function AnyOfExists(Predicate: TSearchPredicate): Boolean;

    protected

      function ReceivingNotificationsEnabled(
        UserNotificationProfile: TUserNotificationProfile
      ): Boolean;

      function ReceivingNotificationsDisabled(
        UserNotificationProfile: TUserNotificationProfile
      ): Boolean;

    protected

      function FindHolderForUserNotificationProfile(
        UserNotificationProfile: TUserNotificationProfile
      ): TUserNotificationProfileHolder;

    public

      destructor Destroy; override;
      constructor Create;

      function First: TUserNotificationProfile;
      function Last: TUserNotificationProfile;

      procedure Prepend(Profile: TUserNotificationProfile);
      function Add(UserNotificationProfile: TUserNotificationProfile): Integer; overload;
      procedure Add(Profiles: TUserNotificationProfiles); overload;
      
      procedure Remove(UserNotificationProfile: TUserNotificationProfile);

      procedure Clear;

      function FetchUserIds: TVariantList;
      
      function FindByUserId(const UserId: Variant): TUserNotificationProfile;
      function FindByUserIds(const UserIds: TVariantList): TUserNotificationProfiles;
      function FindByUserIdsRecursively(const UserIds: TVariantList): TUserNotificationProfiles;

      function GetProfilesForUserAndHisOwnNotificationsReceivingUsersRecursively(const UserId: Variant): TUserNotificationProfiles;
  
      function IsEmpty: Boolean;
      
      function IsExistsForUser(const UserId: Variant): Boolean;

      function FindByReceivingNotificationsPossibility(
        const Criterion: TSearchByReceivingNotificationsPossibility
      ): TUserNotificationProfiles;

      function AnyOfReceivingNotificationsEnabledExists: Boolean;
      function AnyOfReceivingNotificationsDisabledExists: Boolean;
      
      function GetEnumerator: TUserNotificationProfilesEnumerator;

      property Count: Integer read GetCount;
      
      property Items[Index: Integer]: TUserNotificationProfile
      read GetUserNotificationProfileByIndex
      write SetUserNotificationProfileByIndex; default;

  end;

  
implementation

uses

  AuxCollectionFunctionsUnit;

{ TUserNotificationProfile }

procedure TUserNotificationProfile.
  AddUserForWhichReceivingOwnNotificationsPermissible(
    const PermissibleUserId: Variant
  );
begin

  if
    not
    FPermissibleReceivingOwnNotificationsUserIds.Contains(PermissibleUserId)
  then begin

    FPermissibleReceivingOwnNotificationsUserIds.Add(PermissibleUserId);
    
  end;
  
end;

procedure TUserNotificationProfile.
  AddUsersForWhichReceivingOwnNotificationsPermissible(
    const PermissibleUserIds: TVariantList
  );
var PermissibleUserId: Variant;
begin

  for PermissibleUserId in PermissibleUserIds do
    AddUserForWhichReceivingOwnNotificationsPermissible(PermissibleUserId);

end;

constructor TUserNotificationProfile.Create;
begin

  inherited;

  FPermissibleReceivingOwnNotificationsUserIds := TVariantList.Create;
  AccessRights := TUserNotificationProfileAccessRights.Create;
  
end;

destructor TUserNotificationProfile.Destroy;
begin

  FreeAndNil(FPermissibleReceivingOwnNotificationsUserIds);
  
  inherited;

end;

procedure TUserNotificationProfile.
  RemoveAllUsersForWhichReceivingOwnNotificationsPermissible;
begin

end;

procedure TUserNotificationProfile.
  RemoveUserForWhichReceivingOwnNotificationsPermissible(
    const PermissibleUserId: Variant
  );
begin

  FPermissibleReceivingOwnNotificationsUserIds.Remove(PermissibleUserId);
  
end;

procedure TUserNotificationProfile.
  RemoveUsersForWhichReceivingOwnNotificationsPermissible(
    const PermissibleUserIds: TVariantList
  );
begin

  FPermissibleReceivingOwnNotificationsUserIds.Remove(PermissibleUserIds);
  
end;

procedure TUserNotificationProfile.SetAccessRights(
  const Value: TUserNotificationProfileAccessRights);
begin

  FAccessRights := Value;

  FFreeAccessRights := FAccessRights;
  
end;

procedure TUserNotificationProfile.SetPermissibleReceivingOwnNotificationsUserIds(
  const Value: TVariantList);
begin

  if FPermissibleReceivingOwnNotificationsUserIds = Value then Exit;

  FreeAndNil(FPermissibleReceivingOwnNotificationsUserIds);
  
  FPermissibleReceivingOwnNotificationsUserIds := Value;

end;

{ TUserNotificationProfiles }

function TUserNotificationProfiles.Add(
  UserNotificationProfile: TUserNotificationProfile): Integer;
var ProfileHolder: TUserNotificationProfileHolder;
begin

  ProfileHolder :=
    TUserNotificationProfileHolder.Create(UserNotificationProfile);

  try

    Result := FProfileHolderList.Add(ProfileHolder);

  except

    on E: Exception do begin

      FreeAndNil(ProfileHolder);

      Raise;
      
    end;

  end;

end;

procedure TUserNotificationProfiles.Add(Profiles: TUserNotificationProfiles);
var
    Profile: TUserNotificationProfile;
begin

  if not Assigned(Profiles) then Exit;
  
  for Profile in Profiles do
    Add(Profile);
    
end;

function TUserNotificationProfiles.AnyOfExists(
  Predicate: TSearchPredicate
): Boolean;
var Profile: TUserNotificationProfile;
begin

  for Profile in Self do
    if Predicate(Profile) then begin

      Result := True;

      Exit;

    end;

  Result := False;
    
end;

function TUserNotificationProfiles.AnyOfReceivingNotificationsDisabledExists: Boolean;
begin

  Result := AnyOfExists(ReceivingNotificationsDisabled);
    
end;

function TUserNotificationProfiles.ReceivingNotificationsDisabled(
  UserNotificationProfile: TUserNotificationProfile
): Boolean;
begin

  Result := not UserNotificationProfile.ReceivingNotificationsEnabled;

end;

function TUserNotificationProfiles.AnyOfReceivingNotificationsEnabledExists: Boolean;
begin

  Result := AnyOfExists(ReceivingNotificationsEnabled);

end;

procedure TUserNotificationProfiles.Clear;
begin

  FreeListItems(FProfileHolderList);
  
end;

constructor TUserNotificationProfiles.Create;
begin

  inherited;

  FProfileHolderList := TList.Create;

end;

destructor TUserNotificationProfiles.Destroy;
begin

  FreeListWithItems(FProfileHolderList);
  
  inherited;

end;

function TUserNotificationProfiles.ReceivingNotificationsEnabled(
  UserNotificationProfile: TUserNotificationProfile
): Boolean;
begin

  Result := UserNotificationProfile.ReceivingNotificationsEnabled;

end;

function TUserNotificationProfiles.IsEmpty: Boolean;
begin

  Result := FProfileHolderList.Count = 0;
  
end;

function TUserNotificationProfiles.IsExistsForUser(const UserId: Variant): Boolean;
begin

  Result := Assigned(FindByUserId(UserId));
  
end;

function TUserNotificationProfiles.Last: TUserNotificationProfile;
begin

  Result := GetUserNotificationProfileByIndex(Count - 1);
  
end;

procedure TUserNotificationProfiles.Prepend(Profile: TUserNotificationProfile);
var
    ProfileHolder: TUserNotificationProfileHolder;
begin

  if IsExistsForUser(Profile.UserId) then Exit;

  ProfileHolder := TUserNotificationProfileHolder.Create(Profile);

  FProfileHolderList.Insert(0, ProfileHolder);
  
end;

function TUserNotificationProfiles.FindByReceivingNotificationsPossibility(
  const Criterion: TSearchByReceivingNotificationsPossibility
): TUserNotificationProfiles;
var Profile: TUserNotificationProfile;
    IsCriterionSatisfied: Boolean;
begin

  Result := TUserNotificationProfiles.Create;

  try

    for Profile in Self do begin

      if Criterion = ReceivingNotificationsEnabledCriterion then
        IsCriterionSatisfied := Profile.ReceivingNotificationsEnabled

      else IsCriterionSatisfied := not Profile.ReceivingNotificationsEnabled;

      if IsCriterionSatisfied then
        Result.Add(Profile);
      
    end;

  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;

end;

function TUserNotificationProfiles.FindByUserId(
  const UserId: Variant): TUserNotificationProfile;
begin

  for Result in Self do
    if Result.UserId = UserId then
      Exit;

  Result := nil;

end;

function TUserNotificationProfiles.FindByUserIds(
  const UserIds: TVariantList
): TUserNotificationProfiles;
var
  Profile: TUserNotificationProfile;
begin

  Result := TUserNotificationProfiles.Create;

  try

    for Profile in Self do
      if UserIds.Contains(Profile.UserId) then
        Result.Add(Profile);

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TUserNotificationProfiles.FindByUserIdsRecursively(
  const UserIds: TVariantList
): TUserNotificationProfiles;
var
    Profile: TUserNotificationProfile;
    Profiles: TUserNotificationProfiles;
    RecursiveProfiles: TUserNotificationProfiles;
    FreeRecursiveProfiles: IDisposable;
    FreeProfiles: IDisposable;
begin

  if not Assigned(UserIds) or UserIds.IsEmpty then begin

    Result := nil;
    Exit;
    
  end;

  Profiles := FindByUserIds(UserIds);

  if not Assigned(Profiles) then begin

    Result := nil;
    Exit;

  end;

  Result := TUserNotificationProfiles.Create;

  try

    for Profile in Profiles do begin

      RecursiveProfiles := FindByUserIdsRecursively(Profile.PermissibleReceivingOwnNotificationsUserIds);

      FreeRecursiveProfiles := RecursiveProfiles;

      Result.Add(RecursiveProfiles);

    end;

    Result.Add(Profiles);
      
  except

    FreeAndNil(Result);

    Raise;

  end;
  
end;

function TUserNotificationProfiles.FindHolderForUserNotificationProfile(
  UserNotificationProfile: TUserNotificationProfile
): TUserNotificationProfileHolder;
var HolderPointer: Pointer;
begin

  for HolderPointer in FProfileHolderList do begin

    Result := TUserNotificationProfileHolder(HolderPointer);

    if Result.Profile = UserNotificationProfile then Exit;

  end;

  Result := nil;

end;

function TUserNotificationProfiles.First: TUserNotificationProfile;
begin

  Result := GetUserNotificationProfileByIndex(0);
  
end;

function TUserNotificationProfiles.GetCount: Integer;
begin

  Result := FProfileHolderList.Count;
  
end;

function TUserNotificationProfiles.GetEnumerator: TUserNotificationProfilesEnumerator;
begin

  Result := TUserNotificationProfilesEnumerator.Create(Self);

end;

function TUserNotificationProfiles.GetProfilesForUserAndHisOwnNotificationsReceivingUsersRecursively(
  const UserId: Variant): TUserNotificationProfiles;
var
    UserProfile: TUserNotificationProfile;
    FreeProfile: IDisposable;
begin

  UserProfile := FindByUserId(UserId);

  FreeProfile := UserProfile;

  Result := FindByUserIdsRecursively(UserProfile.PermissibleReceivingOwnNotificationsUserIds);

  if not Assigned(Result) then
    Result := TUserNotificationProfiles.Create;

  Result.Prepend(UserProfile);
  
end;

function TUserNotificationProfiles.FetchUserIds: TVariantList;
var Profile: TUserNotificationProfile;
begin

  Result := TVariantList.Create;

  try

    for Profile in Self do
      Result.Add(Profile.UserId);

  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;

end;

function TUserNotificationProfiles.GetUserNotificationProfileByIndex(
  Index: Integer): TUserNotificationProfile;
begin

  Result :=
    TUserNotificationProfileHolder(FProfileHolderList[Index]).Profile;

end;

procedure TUserNotificationProfiles.Remove(
  UserNotificationProfile: TUserNotificationProfile);
var
    ProfileHolder: TUserNotificationProfileHolder;
begin

  ProfileHolder := FindHolderForUserNotificationProfile(UserNotificationProfile);

  if Assigned(ProfileHolder) then begin

    FProfileHolderList.Remove(ProfileHolder);

    ProfileHolder.Destroy;

  end;

end;

procedure TUserNotificationProfiles.SetUserNotificationProfileByIndex(
  Index: Integer; const Value: TUserNotificationProfile);
begin

  TUserNotificationProfileHolder(FProfileHolderList[Index]).Profile := Value;

end;

{ TUserNotificationProfilesEnumerator }

constructor TUserNotificationProfilesEnumerator.Create(
  UserNotificationProfiles: TUserNotificationProfiles);
begin

  inherited Create(UserNotificationProfiles.FProfileHolderList);

end;

function TUserNotificationProfilesEnumerator.
  GetCurrentUserNotificationProfile: TUserNotificationProfile;
begin

  Result := TUserNotificationProfileHolder(GetCurrent).Profile;
  
end;

{ TUserNotificationProfileHolder }

constructor TUserNotificationProfileHolder.Create(
  Profile: TUserNotificationProfile);
begin

  inherited Create;

  Self.Profile := Profile;

end;

procedure TUserNotificationProfileHolder.SetProfile(
  const Value: TUserNotificationProfile);
begin

  FProfile := Value;

  FFreeProfile := FProfile;

end;

end.
