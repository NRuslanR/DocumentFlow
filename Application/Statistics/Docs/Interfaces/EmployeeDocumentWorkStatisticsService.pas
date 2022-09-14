unit EmployeeDocumentWorkStatisticsService;

interface

uses

  ApplicationService,
  EmployeeDocumentWorkStatistics,
  DocumentKinds,
  SysUtils,
  Classes;

type

  TOnDocumentWorkStatisticsFetchedEventHandler =
    procedure (
      Sender: TObject;
      EmployeeDocumentWorkStatisticsList: TEmployeeDocumentWorkStatisticsList
    ) of object;

  TOnDocumentWorkStatisticsFetchingErrorEventHandler =
    procedure (
      Sender: TObject;
      const Error: Exception
    ) of object;

  { refactor: скрыть различия в разновидностях видов документов,
    принимаемых в качестве параметров, перенести логику
    проверок на тип док-ов в реализацию службы }
    
  IEmployeeDocumentWorkStatisticsService = interface (IApplicationService)

    function GetDocumentWorkStatisticsForEmployee(
      const EmployeeId: Variant
    ): TEmployeeDocumentWorkStatisticsList;

    procedure GetDocumentWorkStatisticsForEmployeeAsync(
      const EmployeeId: Variant;

      OnDocumentWorkStatisticsFetchedEventHandler:
        TOnDocumentWorkStatisticsFetchedEventHandler;

      OnDocumentWorkStatisticsFetchingErrorEventHandler:
        TOnDocumentWorkStatisticsFetchingErrorEventHandler
    );

    function GetDocumentKindsWorkStatisticsForEmployee(

      OutcommingDocumentKinds: array of TOutcomingDocumentKindClass;
      ApproveableDocumentKinds: array of TApproveableDocumentKindClass;
      IncommingDocumentKinds: array of TIncomingDocumentKindClass;
      
      const EmployeeId: Variant
      
    ): TEmployeeDocumentWorkStatisticsList;

    procedure GetDocumentKindsWorkStatisticsForEmployeeAsync(

      OutcommingDocumentKinds: array of TOutcomingDocumentKindClass;
      ApproveableDocumentKinds: array of TApproveableDocumentKindClass;
      IncommingDocumentKinds: array of TIncomingDocumentKindClass;
      
      const EmployeeId: Variant;

      OnDocumentWorkStatisticsFetchedEventHandler:
        TOnDocumentWorkStatisticsFetchedEventHandler;

      OnDocumentWorkStatisticsFetchingErrorEventHandler:
        TOnDocumentWorkStatisticsFetchingErrorEventHandler
    );

  end;
  
implementation


end.
