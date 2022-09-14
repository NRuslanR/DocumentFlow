unit DocumentFlowAuthorizationService;

interface

uses

  SystemAuthorizationService,
  Disposable;

type

  TDocumentFlowAuthorizationServiceException =
    class (TSystemAuthorizationServiceException)

    end;

  TDocumentFlowSystemRoleFlags = class (TInterfacedObject, IDisposable)

    public

      HasAdminViewRole: Boolean;
      HasAdminEditRole: Boolean;
      
  end;

  IDocumentFlowAuthorizationService = interface (ISystemAuthorizationService)
    ['{7376EC1D-0F05-476C-BFC5-E879B657CE7B}']

    function GetEmployeeSystemRoleFlags(const EmployeeId: Variant): TDocumentFlowSystemRoleFlags;
    procedure EnsureEmployeeHasSystemRoles(const EmployeeId: Variant; const Flags: TDocumentFlowSystemRoleFlags);
    
    function IsEmployeeAdminView(const EmployeeId: Variant): Boolean;
    function IsEmployeeAdminEdit(const EmployeeId: Variant): Boolean;
    function IsCurrentEmployeeSDUser: Boolean;

    procedure EnsureEmployeeIsAdminView(const EmployeeId: Variant);
    procedure EnsureEmployeeIsAdminEdit(const EmployeeId: Variant);

    procedure MakeEmployeeAsAdminView(const EmployeeId: Variant);
    procedure MakeEmployeeAsAdminEdit(const EmployeeId: Variant);

  end;

implementation

end.
