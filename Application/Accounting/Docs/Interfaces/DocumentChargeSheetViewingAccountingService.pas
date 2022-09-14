unit DocumentChargeSheetViewingAccountingService;

interface

uses

  ApplicationService,
  SysUtils;

type

  TDocumentChargeSheetViewingAccountingServiceException = class (TApplicationServiceException)

  end;
  
  IDocumentChargeSheetViewingAccountingService = interface (IApplicationService)

    function IsDocumentChargeSheetViewedByEmployee(
      const DocumentChargeSheetId, EmployeeId: Variant
    ): Boolean;

    function GetDocumentChargeSheetViewDateByEmployee(
      const DocumentChargeSheetId, EmployeeId: Variant
    ): Variant;
    
    procedure MarkDocumentChargeSheetAsViewedByEmployee(
      const DocumentChargeSheetId: Variant;
      const EmployeeId: Variant;
      const ViewDate: TDateTime
    );

    procedure MarkDocumentChargeSheetAsViewedByEmployeeIfItIsNotViewed(
      const DocumentChargeSheetId: Variant;
      const EmployeeId: Variant;
      const ViewDate: TDateTime
    );

  end;
  
implementation

end.
