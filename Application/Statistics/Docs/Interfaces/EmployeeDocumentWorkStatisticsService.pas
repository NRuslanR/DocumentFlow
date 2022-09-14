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

  { refactor: ������ �������� � �������������� ����� ����������,
    ����������� � �������� ����������, ��������� ������
    �������� �� ��� ���-�� � ���������� ������ }
    
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
