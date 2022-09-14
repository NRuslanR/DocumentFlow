unit SDItemsService;

interface

uses

  SDItem,
  Controls,
  SDBaseTableFormUnit,
  ApplicationService,
  SysUtils;

type

  TSDItemsServiceException = class (TApplicationServiceException)

  end;

  TSDItemsAccessDeniedException = class (TSDItemsServiceException)

  end;

  ISDItemsService = interface (IApplicationService)

    function GetAllSDItems: TSDItems;
	  function GetSDItemControl(const SDItemId: Variant): TWinControl;

  end;

implementation

end.
