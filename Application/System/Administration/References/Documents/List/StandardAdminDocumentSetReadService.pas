unit StandardAdminDocumentSetReadService;

interface

uses

  DepartmentDocumentSetReadService,
  DocumentFlowAuthorizationService,
  AbstractApplicationService,
  AdminDocumentSetReadService,
  DocumentSetHolder,
  VariantListUnit,
  SysUtils;

type

  TStandardAdminDocumentSetReadService =
    class (TAbstractApplicationService, IAdminDocumentSetReadService)

      private

        FAuthorizationService: IDocumentFlowAuthorizationService;
        FDepartmentDocumentSetReadService: IDepartmentDocumentSetReadService;

        procedure EnsureEmployeeHasAccessRightsForAdminDocumentSet(
          const EmployeeId: Variant
        );

        procedure SetAdminDocumentSetAccessRights(
          AdminDocumentSet: TDocumentSetHolder
        );
        
      public

        constructor Create(
          AuthorizationService: IDocumentFlowAuthorizationService;
          DepartmentDocumentSetReadService: IDepartmentDocumentSetReadService
        );

        function GetAdminDocumentSet(
          const AdminId: Variant;
          const DepartmentIds: TVariantList
        ): TDocumentSetHolder;

        function GetAdminDocumentSetByIds(
          const AdminId: Variant;
          const DocumentIds: TVariantList
        ): TDocumentSetHolder; overload;

        function GetAdminDocumentSetByIds(
          const AdminId: Variant;
          DocumentIds: array of Variant
        ): TDocumentSetHolder; overload;
        
    end;

implementation

uses

  Disposable;
  
{ TStandardAdminDocumentSetReadService }

constructor TStandardAdminDocumentSetReadService.Create(
  AuthorizationService: IDocumentFlowAuthorizationService;
  DepartmentDocumentSetReadService: IDepartmentDocumentSetReadService
);
begin

  inherited Create;

  FAuthorizationService := AuthorizationService;
  FDepartmentDocumentSetReadService := DepartmentDocumentSetReadService;
  
end;

function TStandardAdminDocumentSetReadService.GetAdminDocumentSet(
  const AdminId: Variant;
  const DepartmentIds: TVariantList
): TDocumentSetHolder;
begin

  EnsureEmployeeHasAccessRightsForAdminDocumentSet(AdminId);

  Result := FDepartmentDocumentSetReadService.GetPreparedDocumentSet(DepartmentIds);

  SetAdminDocumentSetAccessRights(Result);
  
end;

function TStandardAdminDocumentSetReadService.GetAdminDocumentSetByIds(
  const AdminId: Variant;
  DocumentIds: array of Variant
): TDocumentSetHolder;
var
    DocumentIdList: TVariantList;
begin

  DocumentIdList := TVariantList.CreateFrom(DocumentIds);

  try

    Result := GetAdminDocumentSetByIds(AdminId, DocumentIdList);
    
  finally

    FreeAndNil(DocumentIdList);

  end;

end;

function TStandardAdminDocumentSetReadService.GetAdminDocumentSetByIds(
  const AdminId: Variant;
  const DocumentIds: TVariantList
): TDocumentSetHolder;
begin

  EnsureEmployeeHasAccessRightsForAdminDocumentSet(AdminId);

  Result := FDepartmentDocumentSetReadService.GetPreparedDocumentSetByIds(DocumentIds);

  Result.DataSet.Open;
  
  SetAdminDocumentSetAccessRights(Result);
  
end;

procedure TStandardAdminDocumentSetReadService.EnsureEmployeeHasAccessRightsForAdminDocumentSet(
  const EmployeeId: Variant);
var
    EmployeeSystemRoleFlags: TDocumentFlowSystemRoleFlags;
    Free: IDisposable;
begin

  EmployeeSystemRoleFlags := TDocumentFlowSystemRoleFlags.Create;

  Free := EmployeeSystemRoleFlags;

  EmployeeSystemRoleFlags.HasAdminViewRole := True;

  FAuthorizationService.EnsureEmployeeHasSystemRoles(EmployeeId, EmployeeSystemRoleFlags);
  
end;

procedure TStandardAdminDocumentSetReadService.SetAdminDocumentSetAccessRights(
  AdminDocumentSet: TDocumentSetHolder);
begin

  with AdminDocumentSet do begin

    ViewAllowed := True;
    AddingAllowed := False;
    EditingAllowed := False;
    RemovingAllowed := True;
    AsSelfRegisteredMarkingAllowed := False;

  end;

end;

end.
