unit DocumentChargePerformerSetReadService;

interface

uses

  DocumentKinds,
  EmployeeSetHolder,
  DomainException,
  ApplicationService;

type

  TDocumentChargePerformerSetReadServiceException = class (TApplicationServiceException)

  end;

  IDocumentChargePerformerSetReadService = interface (IApplicationService)

    function FindAllPossibleDocumentChargePerformerSetForEmployee(
      const EmployeeId: Variant
    ): TEmployeeSetHolder;
      
  end;

implementation

end.
