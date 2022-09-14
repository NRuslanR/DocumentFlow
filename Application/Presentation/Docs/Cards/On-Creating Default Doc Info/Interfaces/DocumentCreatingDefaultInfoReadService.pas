unit DocumentCreatingDefaultInfoReadService;

interface

uses

  DocumentCreatingDefaultInfoDTO,
  ApplicationService;

type

  IDocumentCreatingDefaultInfoReadService = interface (IApplicationService)

    function GetDocumentCreatingDefaultInfoForEmployee(
      const EmployeeId: Variant
    ): TDocumentCreatingDefaultInfoDTO;
    
  end;
  
implementation

end.
