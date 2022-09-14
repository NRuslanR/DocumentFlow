unit EmployeeDocumentChargesWorkStatisticsService;

interface

uses

  ApplicationService,
  EmployeeDocumentChargesWorkStatistics;
  
type

  
  IEmployeeDocumentChargesWorkStatisticsService = interface (IApplicationService)

    function GetDocumentChargesWorkStatisticsFor(
      const EmployeeId: Variant;
      const DocumentId: Variant
    ): TEmployeeDocumentChargesWorkStatistics;
    
  end;
  
implementation

end.
