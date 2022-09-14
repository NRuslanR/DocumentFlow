unit DocumentResponsibleSetReadService;

interface

uses

  ApplicationService,
  EmployeeSetHolder;


type

  IDocumentResponsibleSetReadService = interface (IApplicationService)

    function GetDocumentResponsibleSetForEmployee(const EmployeeId: Variant): TEmployeeSetHolder;

  end;


implementation

end.
