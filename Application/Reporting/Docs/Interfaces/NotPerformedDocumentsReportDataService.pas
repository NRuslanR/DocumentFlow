unit NotPerformedDocumentsReportDataService;

interface

uses

  ApplicationService,
  NotPerformedDocumentsReportData,
  SysUtils,
  Classes,
  DB;

type

  TNotPerformedDocumentsReportDataServiceException = class (TApplicationServiceException)

  end;

  INotPerformedDocumentsReportDataService = interface (IApplicationService)

    function GetNotPerformedServiceNotesReportDataForEmployee(
      const EmployeeId: Variant;
      const DepartmentId: Variant;
      const PeriodStart: TDateTime = 0;
      const PeriodEnd: TDateTime = 0
    ): TNotPerformedDocumentsReportData;

  end;
  
implementation

end.
