unit BasedOnDBDocumentFlowItemStatisticsService;

interface

uses

  AbstractDocumentFlowItemStatisticsService,
  AbstractDocumentFlowItemStatistics,
  QueryExecutor,
  SysUtils,
  Classes;

type

  TBasedOnDBDocumentFlowItemStatisticsService =
    class abstract (TAbstractDocumentFlowItemStatisticsService)

      protected

        FQueryExecutor: IQueryExecutor;
        
      public

        constructor Create(QueryExecutor: IQueryExecutor);

    end;

implementation

{ TBasedOnDBDocumentFlowItemStatisticsService }

constructor TBasedOnDBDocumentFlowItemStatisticsService.Create(
  QueryExecutor: IQueryExecutor);
begin

  inherited Create;

  FQueryExecutor := QueryExecutor;
  
end;

end.
