unit BasedOnVclZeosSynchronizationDataControlService;

interface

uses

  Controls,
  AbstractApplicationService,
  SynchronizationDataControlService,
  ZConnection,
  SysUtils;

type

  TBasedOnVclZeosSynchronizationDataControlService =
    class (TAbstractApplicationService, ISynchronizationDataControlService)

      private

        FZConnection: TZConnection;

      public

        constructor Create(ZConnection: TZConnection);
        
        function GetSynchronizationDataControl(const ClientId: Variant): TControl;
        
    end;


implementation

uses

  UnSinchroPersonData;
  
{ TBasedOnVclZeosSynchronizationDataControlService }

constructor TBasedOnVclZeosSynchronizationDataControlService.Create(
  ZConnection: TZConnection);
begin

  inherited Create;

  FZConnection := ZConnection;
  
end;

function TBasedOnVclZeosSynchronizationDataControlService.
  GetSynchronizationDataControl(const ClientId: Variant): TControl;
begin

  Result := InitSinchroPersonData(FZConnection);

  TfrmSinchroPersonData(Result).ExitToolVisible := False;

end;

end.
