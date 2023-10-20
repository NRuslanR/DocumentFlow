unit EmployeeInfoReadService;

interface

uses

  ApplicationService,
  DocumentFlowEmployeeInfoDTO,
  SysUtils;

type

  TEmployeeInfoReadServiceException = class (TApplicationServiceException)

  end;
  
  IEmployeeInfoReadService = interface (IApplicationService)

    function GetEmployeeInfo(const EmployeeId: Variant): TDocumentFlowEmployeeInfoDTO;
    
  end;

implementation

end.
