unit DocumentFlowAdminPrivileges;

interface

uses

  SystemAdministrationPrivileges;

type

  TDocumentFlowAdminPrivilege = class (TSystemAdministrationPrivilege)

    public

      WorkingPrivilegeId: Variant;

      constructor Create; overload;
      constructor Create(
        const Identity: Variant;
        const WorkingIdentity: Variant;
        const TopLevelPrivilegeIdentity: Variant;
        const Name: String;
        const HasServices: Boolean
      ); overload;

  end;

  TDocumentFlowAdminPrivileges = class;

  TDocumentAdminPrivilegesEnumerator = class (TSystemAdministrationPrivilegesEnumerator)

    protected

      function GetCurrentDocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege;

    public

      constructor Create(SystemAdministrationPrivileges: TDocumentFlowAdminPrivileges);

      property Current: TDocumentFlowAdminPrivilege
      read GetCurrentDocumentFlowAdminPrivilege;
      
  end;
  
  TDocumentFlowAdminPrivileges = class (TSystemAdministrationPrivileges)

    private

      function GetDocumentFlowAdminPrivilegeByIndex(
        Index: Integer
      ): TDocumentFlowAdminPrivilege;

      procedure SetDocumentFlowAdminPrivilegeByIndex(Index: Integer;
        const Value: TDocumentFlowAdminPrivilege
      );
      
    public

      function Add(Privilege: TDocumentFlowAdminPrivilege): Integer;

      function FindPrivilegeById(const PrivilegeId: Variant): TDocumentFlowAdminPrivilege;
      
      function GetEnumerator: TDocumentAdminPrivilegesEnumerator;

      property Items[Index: Integer]: TDocumentFlowAdminPrivilege
      read GetDocumentFlowAdminPrivilegeByIndex
      write SetDocumentFlowAdminPrivilegeByIndex;
      
  end;

implementation

uses

  Variants;
  
{ TDocumentAdminPrivilegesEnumerator }

constructor TDocumentAdminPrivilegesEnumerator.Create(
  SystemAdministrationPrivileges: TDocumentFlowAdminPrivileges);
begin

  inherited Create(SystemAdministrationPrivileges);
  
end;

function TDocumentAdminPrivilegesEnumerator.
  GetCurrentDocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege;
begin

  Result := TDocumentFlowAdminPrivilege(GetCurrentSystemAdministrationPrivilege);
  
end;

{ TDocumentFlowAdminPrivileges }

function TDocumentFlowAdminPrivileges.Add(
  Privilege: TDocumentFlowAdminPrivilege): Integer;
begin

  inherited Add(Privilege);
  
end;

function TDocumentFlowAdminPrivileges.FindPrivilegeById(
  const PrivilegeId: Variant): TDocumentFlowAdminPrivilege;
begin

  Result :=
    TDocumentFlowAdminPrivilege(inherited FindPrivilegeById(PrivilegeId));
    
end;

function TDocumentFlowAdminPrivileges.GetDocumentFlowAdminPrivilegeByIndex(
  Index: Integer): TDocumentFlowAdminPrivilege;
begin

  Result := TDocumentFlowAdminPrivilege(GetSystemAdministrationPrivilegeByIndex(Index));

end;

function TDocumentFlowAdminPrivileges.GetEnumerator: TDocumentAdminPrivilegesEnumerator;
begin

  Result := TDocumentAdminPrivilegesEnumerator.Create(Self);
  
end;

procedure TDocumentFlowAdminPrivileges.SetDocumentFlowAdminPrivilegeByIndex(
  Index: Integer; const Value: TDocumentFlowAdminPrivilege);
begin

  SetSystemAdministrationPrivilegeByIndex(Index, Value);
  
end;

{ TDocumentFlowAdminPrivilege }

constructor TDocumentFlowAdminPrivilege.Create;
begin

  inherited;

  WorkingPrivilegeId := Null;
  
end;

constructor TDocumentFlowAdminPrivilege.Create(
  const Identity, WorkingIdentity,
  TopLevelPrivilegeIdentity: Variant;
  const Name: String;
  const HasServices: Boolean
);
begin

  inherited Create(
    Identity,
    TopLevelPrivilegeIdentity,
    Name,
    HasServices
  );

  WorkingPrivilegeId := WorkingIdentity;

end;

end.
