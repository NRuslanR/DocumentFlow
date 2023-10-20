unit DocumentChargeSheetPerformerSetReadService;

interface

uses

  DocumentChargePerformerSetReadService,
  ApplicationService,
  EmployeeSetHolder,
  SysUtils;

type

  TDocumentChargeSheetPerformerSetReadServiceException =
    class (TApplicationServiceException)

    end;
    
  IDocumentChargeSheetPerformerSetReadService = interface (IApplicationService)

    function FindDocumentChargeSheetPerformerSetForEmployee(
      const EmployeeId: Variant
    ): TEmployeeSetHolder;

    function FindChargeSheetPerformerSetForDocumentAndEmployee(
      const DocumentId: Variant;
      const EmployeeId: Variant
    ): TEmployeeSetHolder;

  end;

implementation

end.
