unit DocumentChargeSheetPerformerSetReadService;

interface

uses

  DocumentChargePerformerSetReadService,
  ApplicationService,
  EmployeeSetHolder,
  SysUtils;

type

  IDocumentChargeSheetPerformerSetReadService = interface (IApplicationService)

    function FindDocumentChargeSheetPerformerSetForEmployee(
      const EmployeeId: Variant
    ): TEmployeeSetHolder;

  end;

implementation

end.
