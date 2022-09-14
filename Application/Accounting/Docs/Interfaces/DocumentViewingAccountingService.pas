unit DocumentViewingAccountingService;

interface

uses

  ApplicationService;

type

  IDocumentViewingAccountingService = interface (IApplicationService)

    function IsDocumentViewedByEmployee(
      const DocumentId, EmployeeId: Variant
    ): Boolean;

    function GetDocumentViewDateByEmployee(
      const DocumentId, EmployeeId: Variant
    ): Variant;
    
    procedure MarkDocumentAsViewedByEmployee(
      const DocumentId: Variant;
      const EmployeeId: Variant;
      const ViewDate: TDateTime
    );

    procedure MarkDocumentAsViewedByEmployeeIfItIsNotViewed(
      const DocumentId: Variant;
      const EmployeeId: Variant;
      const ViewDate: TDateTime
    );
    
  end;

implementation

end.
