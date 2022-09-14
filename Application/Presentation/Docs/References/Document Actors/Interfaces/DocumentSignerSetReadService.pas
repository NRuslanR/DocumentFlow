unit DocumentSignerSetReadService;

interface

uses

  ApplicationService,
  EmployeeSetHolder,
  SysUtils;

type

  IDocumentSignerSetReadService = interface (IApplicationService)

    function FindAllPossibleDocumentSignerSetForEmployee(
      const EmployeeId: Variant
    ): TEmployeeSetHolder;

  end;

implementation

end.
