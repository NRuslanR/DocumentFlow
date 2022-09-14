unit EmployeeDocumentChargesWorkStatisticsZeosService;

interface

uses

  EmployeeDocumentChargesWorkStatistics,
  EmployeeDocumentChargesWorkStatisticsService,
  ZDataset,
  ZConnection,
  SysUtils;

type

  TEmployeeDocumentChargesStatisticsFetchingQueryData = class

    QueryText: String;
    TotalChargeCountFieldName: String;
    PerformedChargeCountFieldName: String;
    
  end;
  
  TEmployeeDocumentChargesWorkStatisticsZeosService =
    class (TInterfacedObject, IEmployeeDocumentChargesWorkStatisticsService)

      protected

        FConnection: TZConnection;

        function CreateDocumentChargesStatisticsFetchingQueryDataFrom(
          const EmployeeId: Variant;
          const DocumentId: Variant
        ): TEmployeeDocumentChargesStatisticsFetchingQueryData;
        virtual; abstract;

        function MapEmployeeDocumentChargesWorkStatisticsFrom(
          DataSet: TZQuery;
          const PerformedChargeCountFieldName: String;
          const TotalChargeCountFieldName: String
        ): TEmployeeDocumentChargesWorkStatistics; virtual;
        
      public

        constructor Create(Connection: TZConnection);
        
        function GetDocumentChargesWorkStatisticsFor(
          const EmployeeId: Variant;
          const DocumentId: Variant
        ): TEmployeeDocumentChargesWorkStatistics;

        function GetSelf: TObject;
        
    end;

implementation

uses

  AuxZeosFunctions;
  
{ TEmployeeDocumentChargesWorkStatisticsZeosService }

constructor TEmployeeDocumentChargesWorkStatisticsZeosService.Create(
  Connection: TZConnection);
begin

  inherited Create;

  FConnection := Connection;
  
end;

function TEmployeeDocumentChargesWorkStatisticsZeosService.GetDocumentChargesWorkStatisticsFor(
  const EmployeeId,
  DocumentId: Variant
): TEmployeeDocumentChargesWorkStatistics;
var ZQuery: TZQuery;
    EmployeeDocumentChargesStatisticsFetchingQueryData:
      TEmployeeDocumentChargesStatisticsFetchingQueryData;
begin

  ZQuery := nil;
  EmployeeDocumentChargesStatisticsFetchingQueryData := nil;
  
  try

    EmployeeDocumentChargesStatisticsFetchingQueryData :=
    
      CreateDocumentChargesStatisticsFetchingQueryDataFrom(
        EmployeeId, DocumentId
      );
      
    ZQuery :=

      CreateAndExecuteQuery(
        FConnection,
        EmployeeDocumentChargesStatisticsFetchingQueryData.QueryText,
        [],
        []
      );

    Result :=
    
      MapEmployeeDocumentChargesWorkStatisticsFrom(

        ZQuery,
        
        EmployeeDocumentChargesStatisticsFetchingQueryData.
          PerformedChargeCountFieldName,

        EmployeeDocumentChargesStatisticsFetchingQueryData.
          TotalChargeCountFieldName
      );

  finally

    FreeAndNil(ZQuery);
    FreeAndNil(EmployeeDocumentChargesStatisticsFetchingQueryData);

  end;
  
end;

function TEmployeeDocumentChargesWorkStatisticsZeosService.GetSelf: TObject;
begin

  Result := Self;
  
end;

function TEmployeeDocumentChargesWorkStatisticsZeosService.
  MapEmployeeDocumentChargesWorkStatisticsFrom(
    DataSet: TZQuery;
    const PerformedChargeCountFieldName: String;
    const TotalChargeCountFieldName: String
  ): TEmployeeDocumentChargesWorkStatistics;
begin

  DataSet.First;

  Result :=
    TEmployeeDocumentChargesWorkStatistics.Create(

      DataSet.FieldByName(
        PerformedChargeCountFieldName
      ).AsInteger,

      DataSet.FieldByName(
        TotalChargeCountFieldName
      ).AsInteger

    );
    
end;

end.
