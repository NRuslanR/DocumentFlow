unit StatisticsServiceRegistry;

interface

uses

  _ApplicationServiceRegistry,
  DocumentKinds,
  EmployeeDocumentWorkStatisticsService,
  EmployeeDocumentChargesWorkStatisticsService,
  SysUtils,
  Classes;

type

  TStatisticsServiceRegistry = class (TApplicationServiceRegistry)

    public

      procedure RegisterEmployeeDocumentWorkStatisticsService(

        EmployeeDocumentWorkStatisticsService:
          IEmployeeDocumentWorkStatisticsService

      );

      procedure RegisterEmployeeDocumentChargesWorkStatisticsService(

        DocumentKind: TDocumentKindClass;

        EmployeeDocumentChargesWorkStatisticsService:
          IEmployeeDocumentChargesWorkStatisticsService
          
      );

    public
    
      function GetEmployeeDocumentWorkStatisticsService:
        IEmployeeDocumentWorkStatisticsService;

      function GetEmployeeDocumentChargesWorkStatisticsService(
        DocumentKind: TDocumentKindClass
      ): IEmployeeDocumentChargesWorkStatisticsService;
      
  end;

implementation

type

  TStatisticsServiceType = class

  end;
  
  TEmployeeDocumentWorkStatisticsServiceType = class (TStatisticsServiceType)

  end;
  
{ TStatisticsServiceRegistry }

function TStatisticsServiceRegistry.
  GetEmployeeDocumentChargesWorkStatisticsService(
    DocumentKind: TDocumentKindClass
  ): IEmployeeDocumentChargesWorkStatisticsService;
begin

  Result :=
    IEmployeeDocumentChargesWorkStatisticsService(GetApplicationService(DocumentKind));
    
end;

function TStatisticsServiceRegistry.
  GetEmployeeDocumentWorkStatisticsService: IEmployeeDocumentWorkStatisticsService;
begin

  Result :=
    IEmployeeDocumentWorkStatisticsService(
      GetApplicationService(TEmployeeDocumentWorkStatisticsServiceType)
    );
    
end;

procedure TStatisticsServiceRegistry.
  RegisterEmployeeDocumentChargesWorkStatisticsService(
    DocumentKind: TDocumentKindClass;
    EmployeeDocumentChargesWorkStatisticsService: IEmployeeDocumentChargesWorkStatisticsService
  );
begin

  RegisterApplicationService(
    DocumentKind,
    EmployeeDocumentChargesWorkStatisticsService
  );

end;

procedure TStatisticsServiceRegistry.
  RegisterEmployeeDocumentWorkStatisticsService(
    EmployeeDocumentWorkStatisticsService:
      IEmployeeDocumentWorkStatisticsService
  );
begin

  RegisterApplicationService(
    TEmployeeDocumentWorkStatisticsServiceType,
    EmployeeDocumentWorkStatisticsService
  );

end;

end.
