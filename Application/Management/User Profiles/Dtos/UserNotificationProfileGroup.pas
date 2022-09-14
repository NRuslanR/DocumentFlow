unit UserNotificationProfileGroup;

interface

uses

  UserNotificationProfile,       
  VariantListUnit,
  Disposable,
  SysUtils,
  Classes;

type

  TUserNotificationProfileGroup = class;
  TUserNotificationProfileGroups = class;

  TUserNotificationProfileGroupEnumerator = class

    private

      FUserNotificationProfilesEnumerator: TUserNotificationProfilesEnumerator;
      
      function GetCurrentProfile: TUserNotificationProfile;
      
    public

      destructor Destroy; override;
      constructor Create(ProfileGroup: TUserNotificationProfileGroup);

      function MoveNext: Boolean;
      
      property Current: TUserNotificationProfile read GetCurrentProfile;

  end;

  TUserNotificationProfileGroup = class (TInterfacedObject, IDisposable)

    private

      FId: Variant;
      FUserNotificationProfiles: TUserNotificationProfiles;
      FFreeUserNotificationProfiles: IDisposable;

    public

      constructor Create;

      procedure AddProfile(Profile: TUserNotificationProfile);
      procedure AddProfiles(Profiles: TUserNotificationProfiles);
      procedure AddProfilesFrom(ProfileGroup: TUserNotificationProfileGroup);

      function IsProfileExistsForUser(const UserId: Variant): Boolean;
      
      function FindProfileByUser(const UserId: Variant): TUserNotificationProfile;
      
      function FetchUserIds: TVariantList;
      
      procedure RemoveProfile(Profile: TUserNotificationProfile);

      procedure RemoveProfileForUser(const UserId: Variant);

      function GetEnumerator: TUserNotificationProfileGroupEnumerator;

      function GetProfiles: TUserNotificationProfiles;

      property Id: Variant read FId write FId;

      property Profiles[const UserId: Variant]: TUserNotificationProfile
      read FindProfileByUser; default;

  end;

  TUserNotificationProfileGroupsEnumerator = class (TListEnumerator)

    private

      function GetCurrentUserNotificationProfileGroup: TUserNotificationProfileGroup;
      
    public

      constructor Create(Groups: TUserNotificationProfileGroups);

      property Current: TUserNotificationProfileGroup
      read GetCurrentUserNotificationProfileGroup;
      
  end;

  TUserNotificationProfileGroups = class (TList)

    private

      type

        TProfileGroupHolder = class

          private

            ProfileGroup: TUserNotificationProfileGroup;
            Free: IDisposable;

            constructor Create(ProfileGroup: TUserNotificationProfileGroup);
            
        end;

    private

      function GetUserNotificationProfileGroupByIndex(Index: Integer): TUserNotificationProfileGroup;

      procedure AddProfileGroupHolderFor(ProfileGroup: TUserNotificationProfileGroup);
      
    protected

      procedure Notify(Ptr: Pointer; Action: TListNotification); override;

    public

      procedure Add(UserNotificationProfileGroup: TUserNotificationProfileGroup); overload;
      procedure Add(UserNotificationProfileGroups: TUserNotificationProfileGroups); overload;

      function IsGroupExists(const GroupId: Variant): Boolean;
      function FindGroupById(const GroupId: Variant): TUserNotificationProfileGroup;

      function FetchUserIdsFromAllGroups: TVariantList;

      function FindProfileGroupByHeadUser(const UserId: Variant): TUserNotificationProfileGroup;
      
      function GetEnumerator: TUserNotificationProfileGroupsEnumerator;
      
      property Items[Index: Integer]: TUserNotificationProfileGroup
      read GetUserNotificationProfileGroupByIndex; default;
    
  end;
  

implementation

{ TUserNotificationProfileGroup }

constructor TUserNotificationProfileGroup.Create;
begin

  inherited;

  FUserNotificationProfiles := TUserNotificationProfiles.Create;
  FFreeUserNotificationProfiles := FUserNotificationProfiles;

end;

procedure TUserNotificationProfileGroup.AddProfile(
  Profile: TUserNotificationProfile
);
begin

  if not IsProfileExistsForUser(Profile.UserId) then
    FUserNotificationProfiles.Add(Profile);

end;

procedure TUserNotificationProfileGroup.AddProfiles(
  Profiles: TUserNotificationProfiles);
var
    Profile: TUserNotificationProfile;
begin

  for Profile in Profiles do AddProfile(Profile);
    
end;

procedure TUserNotificationProfileGroup.AddProfilesFrom(
  ProfileGroup: TUserNotificationProfileGroup);
begin

  AddProfiles(ProfileGroup.GetProfiles);
  
end;

function TUserNotificationProfileGroup.FetchUserIds: TVariantList;
begin

  Result := FUserNotificationProfiles.FetchUserIds;
  
end;

function TUserNotificationProfileGroup.FindProfileByUser(
  const UserId: Variant): TUserNotificationProfile;
begin

  Result := FUserNotificationProfiles.FindByUserId(UserId);

end;

function TUserNotificationProfileGroup.GetEnumerator: TUserNotificationProfileGroupEnumerator;
begin

  Result := TUserNotificationProfileGroupEnumerator.Create(Self);

end;

function TUserNotificationProfileGroup.GetProfiles: TUserNotificationProfiles;
begin

  Result := FUserNotificationProfiles;
  
end;

function TUserNotificationProfileGroup.IsProfileExistsForUser(
  const UserId: Variant): Boolean;
begin

  Result := Assigned(FindProfileByUser(UserId));
  
end;

procedure TUserNotificationProfileGroup.RemoveProfile(
  Profile: TUserNotificationProfile);
begin

  FUserNotificationProfiles.Remove(Profile);

end;

procedure TUserNotificationProfileGroup.RemoveProfileForUser(
  const UserId: Variant);
var
    Profile: TUserNotificationProfile;
begin

  Profile := FindProfileByUser(UserId);

  if Assigned(Profile) then
    RemoveProfile(Profile);

end;

{ TUserNotificationProfileGroupEnumerator }

constructor TUserNotificationProfileGroupEnumerator.Create(
  ProfileGroup: TUserNotificationProfileGroup);
begin

  inherited Create;

  FUserNotificationProfilesEnumerator := ProfileGroup.FUserNotificationProfiles.GetEnumerator;
  
end;

destructor TUserNotificationProfileGroupEnumerator.Destroy;
begin

  FreeAndNil(FUserNotificationProfilesEnumerator);

  inherited;

end;

function TUserNotificationProfileGroupEnumerator.GetCurrentProfile: TUserNotificationProfile;
begin

  Result := FUserNotificationProfilesEnumerator.Current;
  
end;

function TUserNotificationProfileGroupEnumerator.MoveNext: Boolean;
begin

  Result := FUserNotificationProfilesEnumerator.MoveNext;

end;

{ TUserNotificationProfileGroups }

procedure TUserNotificationProfileGroups.Add(
  UserNotificationProfileGroup: TUserNotificationProfileGroup);
begin

  AddProfileGroupHolderFor(UserNotificationProfileGroup);

end;

procedure TUserNotificationProfileGroups.Add(
  UserNotificationProfileGroups: TUserNotificationProfileGroups);
var
    ProfileGroup: TUserNotificationProfileGroup;
begin

  if not Assigned(UserNotificationProfileGroups) then Exit;
  
  for ProfileGroup in UserNotificationProfileGroups do
    Add(ProfileGroup);

end;

procedure TUserNotificationProfileGroups.AddProfileGroupHolderFor(
  ProfileGroup: TUserNotificationProfileGroup);
begin

  Add(TProfileGroupHolder.Create(ProfileGroup));
  
end;

function TUserNotificationProfileGroups.FetchUserIdsFromAllGroups: TVariantList;
var
    Group: TUserNotificationProfileGroup;
    UserIds: TVariantList;
begin

  Result := TVariantList.Create;

  try

    for Group in Self do begin

      UserIds := Group.FetchUserIds;

      try

        Result.Add(UserIds);

      finally

        FreeAndNil(UserIds);
        
      end;

    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TUserNotificationProfileGroups.FindGroupById(
  const GroupId: Variant): TUserNotificationProfileGroup;
begin

  for Result in Self do
    if Result.Id = GroupId then
      Exit;

  Result := nil;
    
end;

function TUserNotificationProfileGroups.FindProfileGroupByHeadUser(
  const UserId: Variant
): TUserNotificationProfileGroup;
begin

  for Result in Self do
    if Result.GetProfiles.First.UserId = UserId then
      Exit;

  Result := nil;

end;

function TUserNotificationProfileGroups.GetEnumerator: TUserNotificationProfileGroupsEnumerator;
begin

  Result := TUserNotificationProfileGroupsEnumerator.Create(Self);

end;

function TUserNotificationProfileGroups.GetUserNotificationProfileGroupByIndex(
  Index: Integer): TUserNotificationProfileGroup;
begin

  Result := TProfileGroupHolder(Get(Index)).ProfileGroup;

end;

function TUserNotificationProfileGroups.IsGroupExists(
  const GroupId: Variant): Boolean;
begin

  Result := Assigned(FindGroupById(GroupId));

end;

procedure TUserNotificationProfileGroups.Notify(Ptr: Pointer;
  Action: TListNotification);
begin

  inherited;

  if Action = lnDeleted then
    TObject(Ptr).Free;
    
end;

{ TUserNotificationProfileGroupsEnumerator }

constructor TUserNotificationProfileGroupsEnumerator.Create(
  Groups: TUserNotificationProfileGroups);
begin

  inherited Create(Groups);

end;

function TUserNotificationProfileGroupsEnumerator.GetCurrentUserNotificationProfileGroup: TUserNotificationProfileGroup;
begin

  Result := TUserNotificationProfileGroups.TProfileGroupHolder(GetCurrent).ProfileGroup;

end;

{ TUserNotificationProfileGroups.TProfileGroupHolder }

constructor TUserNotificationProfileGroups.TProfileGroupHolder.Create(
  ProfileGroup: TUserNotificationProfileGroup);
begin

  inherited Create;

  Self.ProfileGroup := ProfileGroup;
  Self.Free := ProfileGroup;
  
end;

end.
