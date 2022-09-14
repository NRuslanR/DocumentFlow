unit ApplicationServiceRegistries;

interface

uses

  SysUtils,
  Classes,
  DocumentBusinessProcessServiceRegistry,
  ReportingServiceRegistry,
  StatisticsServiceRegistry,
  PresentationServiceRegistry,
  _ApplicationServiceRegistry,
  AccountingServiceRegistry,
  ManagementServiceRegistry,
  SystemServiceRegistry,
  ExternalServiceRegistry,
  NotificationRegistry;

type

  TApplicationServiceRegistries = class

    private

      class var FInstance: TApplicationServiceRegistries;

      class var FManagementServiceRegistry: TManagementServiceRegistry;
      class var FAccountingServiceRegistry: TAccountingServiceRegistry;
      class var FDocumentBusinessProcessServiceRegistry: TDocumentBusinessProcessServiceRegistry;
      class var FReportingServiceRegistry: TReportingServiceRegistry;
      class var FStatisticsServiceRegistry: TStatisticsServiceRegistry;
      class var FExternalServiceRegistry: TExternalServiceRegistry;
      class var FPresentationServiceRegistry: TPresentationServiceRegistry;
      class var FSystemServiceRegistry: TSystemServiceRegistry;
      class var FNotificationsRegistry: TNotificationServiceRegistry;
      
      class function GetInstance: TApplicationServiceRegistries; static;

    public

      function GetManagementServiceRegistry: TManagementServiceRegistry;
      function GetAccountingServiceRegistry: TAccountingServiceRegistry;
      function GetDocumentBusinessProcessServiceRegistry:
        TDocumentBusinessProcessServiceRegistry;

      function GetReportingServiceRegistry: TReportingServiceRegistry;
      function GetStatisticsServiceRegistry: TStatisticsServiceRegistry;
      function GetExternalServiceRegistry: TExternalServiceRegistry;
      function GetPresentationServiceRegistry: TPresentationServiceRegistry;
      function GetSystemServiceRegistry: TSystemServiceRegistry;
      function GetNotificationRegistry: TNotificationServiceRegistry;
      
    public

      destructor Destroy; override;
      
      class property Current: TApplicationServiceRegistries
      read GetInstance;

  end;
  
implementation

uses

  Document,
  DocumentDirectory,
  ServiceNote,
  AuxDebugFunctionsUnit,
  DocumentsDomainRegistries;


{ TApplicationServiceRegistries }

destructor TApplicationServiceRegistries.Destroy;
begin

  FreeAndNil(FManagementServiceRegistry);
  FreeAndNil(FAccountingServiceRegistry);
  FreeAndNil(FDocumentBusinessProcessServiceRegistry);
  FreeAndNil(FReportingServiceRegistry);
  FreeAndNil(FStatisticsServiceRegistry);
  FreeAndNil(FExternalServiceRegistry);
  FreeAndNil(FPresentationServiceRegistry);

  inherited;

end;

function TApplicationServiceRegistries.GetAccountingServiceRegistry: TAccountingServiceRegistry;
begin

  if not Assigned(FAccountingServiceRegistry) then
    FAccountingServiceRegistry := TAccountingServiceRegistry.Create;

  Result := FAccountingServiceRegistry;
  
end;

function TApplicationServiceRegistries.GetDocumentBusinessProcessServiceRegistry: TDocumentBusinessProcessServiceRegistry;
begin

  if not Assigned(FDocumentBusinessProcessServiceRegistry) then
    FDocumentBusinessProcessServiceRegistry := TDocumentBusinessProcessServiceRegistry.Create;

  Result := FDocumentBusinessProcessServiceRegistry;
  
end;

function TApplicationServiceRegistries.GetExternalServiceRegistry: TExternalServiceRegistry;
begin

  if not Assigned(FExternalServiceRegistry) then
    FExternalServiceRegistry := TExternalServiceRegistry.Create;

  Result := FExternalServiceRegistry;
  
end;

function TApplicationServiceRegistries.GetReportingServiceRegistry: TReportingServiceRegistry;
begin

  if not Assigned(FReportingServiceRegistry) then
    FReportingServiceRegistry := TReportingServiceRegistry.Create;

  Result := FReportingServiceRegistry;
  
end;

function TApplicationServiceRegistries.GetStatisticsServiceRegistry: TStatisticsServiceRegistry;
begin

  if not Assigned(FStatisticsServiceRegistry) then
    FStatisticsServiceRegistry := TStatisticsServiceRegistry.Create;

  Result := FStatisticsServiceRegistry;
  
end;

function TApplicationServiceRegistries.GetSystemServiceRegistry:
  TSystemServiceRegistry;
begin

  if not Assigned(FSystemServiceRegistry) then
    FSystemServiceRegistry := TSystemServiceRegistry.Create;

  Result := FSystemServiceRegistry;
  
end;

class function TApplicationServiceRegistries.GetInstance: TApplicationServiceRegistries;
begin

  if not Assigned(FInstance) then
    FInstance := TApplicationServiceRegistries.Create;

  Result := FInstance;
  
end;

function TApplicationServiceRegistries.GetManagementServiceRegistry: TManagementServiceRegistry;
begin

  if not Assigned(FManagementServiceRegistry) then
    FManagementServiceRegistry := TManagementServiceRegistry.Create;

  Result := FManagementServiceRegistry;
  
end;

function TApplicationServiceRegistries.GetNotificationRegistry: TNotificationServiceRegistry;
begin

  if not Assigned(FNotificationsRegistry) then
    FNotificationsRegistry := TNotificationServiceRegistry.Create;

  Result := FNotificationsRegistry;
  
end;

function TApplicationServiceRegistries.GetPresentationServiceRegistry:
  TPresentationServiceRegistry;
begin

  if not Assigned(FPresentationServiceRegistry) then
    FPresentationServiceRegistry := TPresentationServiceRegistry.Create;

  Result := FPresentationServiceRegistry;

end;

end.
