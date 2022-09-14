unit ApplicationVersionInfoService;

interface

uses
  ApplicationService,
  VersionInfoDTOs;

type

  IApplicationVersionInfoService = interface(IApplicationService)
    function GetLastVersionChanges: TVersionInfoDTOs;
    function GetAllVersionsChanges: TVersionInfoDTOs;
    procedure WriteLastVersionToFile;

  end;

implementation

end.
