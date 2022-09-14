unit SynchronizationDataAdminPrivilegeServices;

interface

uses

  SynchronizationDataControlService,
  DocumentFlowAdminPrivilegeServices,
  SysUtils;

type

  TSynchronizationDataAdminPrivilegeServices = class (TDocumentFlowAdminPrivilegeServices)

    public

      SynchronizationDataControlService: ISynchronizationDataControlService;

      public

        constructor Create(
          const PrivilegeId: Variant;
          const WorkingPrivilegeId: Variant;
          SynchronizationDataControlService: ISynchronizationDataControlService
        );

  end;

implementation

{ TSynchronizationDataAdminPrivilegeServices }

constructor TSynchronizationDataAdminPrivilegeServices.Create(
  const PrivilegeId, WorkingPrivilegeId: Variant;
  SynchronizationDataControlService: ISynchronizationDataControlService
);
begin

  inherited Create(PrivilegeId, WorkingPrivilegeId);

  Self.SynchronizationDataControlService := SynchronizationDataControlService;
  
end;

end.
