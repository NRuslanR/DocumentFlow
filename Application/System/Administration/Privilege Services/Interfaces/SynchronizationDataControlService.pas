unit SynchronizationDataControlService;

interface

uses

  Controls,
  ApplicationService,
  SysUtils;

type

  TSynchronizationDataControlServiceException = class (TApplicationServiceException)

  end;
  
  ISynchronizationDataControlService = interface (IApplicationService)
    ['{C39BA378-DC90-49A0-96EA-0D76D8FACAFB}']
    
    function GetSynchronizationDataControl(const ClientId: Variant): TControl;
    
  end;


implementation

end.
