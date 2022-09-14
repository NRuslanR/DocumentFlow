unit BasedOnVclZeosDepartmentsAdminReferenceControlService;

interface

uses

  AbstractApplicationService,
  DepartmentsAdminReferenceControlService,
  Controls,
  ZConnection,
  SysUtils;

type

  TBasedOnVclZeosDepartmentsAdminReferenceControlService =
    class (TAbstractApplicationService, IDepartmentsAdminReferenceControlService)

      private

        FZConnection: TZConnection;
        
      public

        constructor Create(ZConnection:  TZConnection);

        function GetDepartmentsAdminReferenceControl(
          const ClientId: Variant
        ): TControl;

    end;
    
implementation

uses

  cxDBTL,
  UnPodrTree;
  
{ TBasedOnVclZeosDepartmentsAdminReferenceControlService }

constructor TBasedOnVclZeosDepartmentsAdminReferenceControlService.Create(
  ZConnection: TZConnection
);
begin

  inherited Create;

  FZConnection := ZConnection;

end;

function TBasedOnVclZeosDepartmentsAdminReferenceControlService.
  GetDepartmentsAdminReferenceControl(
    const ClientId: Variant
  ): TControl;
begin

  Result := InitPodrTree(FZConnection);

  with TfrmPodrTree(Result) do ExitToolVisible := False;
  
end;

end.
