unit DepartmentSetReadService;

interface

uses

  ApplicationService,
  DepartmentSetHolder,
  SysUtils;

type

  TDepartmentSetReadServiceException = class (TApplicationServiceException)

  end;

  TDepartmentSetGettingSuccessedEventHandler =
    procedure (
      Sender: TObject;
      DepartmentSetHolder: TDepartmentSetHolder
    ) of object;

  TDepartmentSetGettingFailedEventHandler =
    procedure (
      Sender: TObject;
      const Error: TDepartmentSetReadServiceException
    ) of object;
  
  IDepartmentSetReadService = interface (IApplicationService)
    ['{7F115AC3-749D-416E-B534-40D79A4B89AA}']

    function GetDepartmentSet: TDepartmentSetHolder;

    function GetPreparedDepartmentSet: TDepartmentSetHolder;
    
    procedure GetDepartmentSetAsync(
      SuccessedEventHandler: TDepartmentSetGettingSuccessedEventHandler;
      FailedEventHandler: TDepartmentSetGettingFailedEventHandler
    );

  end;

implementation

end.
