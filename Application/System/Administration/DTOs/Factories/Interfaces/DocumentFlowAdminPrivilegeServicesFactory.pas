{ Базовый интерфейс для фабрик dto с
  сервисами для админских привилегий
}

unit DocumentFlowAdminPrivilegeServicesFactory;

interface

uses

  DocumentFlowAdminPrivilegeServices,
  SysUtils;

type

  IDocumentFlowAdminPrivilegeServicesFactory = interface
    ['{8562C20E-A5F3-4F0B-A458-4F2756650777}']

    function CreateDocumentFlowAdminPrivilegeServices:
      TDocumentFlowAdminPrivilegeServices;
      
  end;

implementation

end.
