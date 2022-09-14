unit DocumentApproverSetReadService;

interface

uses

  ApplicationService,
  EmployeeSetHolder;

type

  IDocumentApproverSetReadService = interface (IApplicationService)

    function GetDocumentApproverSetForEmployee(
      const EmployeeId: Variant
    ): TEmployeeSetHolder;
    
  end;
  
implementation

end.
