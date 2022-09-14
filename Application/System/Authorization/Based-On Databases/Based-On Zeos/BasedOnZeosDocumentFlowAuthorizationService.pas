unit BasedOnZeosDocumentFlowAuthorizationService;

interface

uses

  BasedOnDatabaseDocumentFlowAuthorizationService,
  QueryExecutor,
  ZConnection,
  SDHelperUnit;

type

  TBasedOnZeosDocumentFlowAuthorizationService =
    class (TBasedOnDatabaseDocumentFlowAuthorizationService)

      private

        FZConnection: TZConnection;
        
      public

        constructor Create(
          QueryExecutor: IQueryExecutor;
          DbSchemaData: TDocumentFlowAuthorizationServiceDbSchema;
          ZConnection: TZConnection
        );
        
        function IsCurrentEmployeeSDUser: Boolean; override;
        
    end;

implementation

{ TBasedOnZeosDocumentFlowAuthorizationService }

constructor TBasedOnZeosDocumentFlowAuthorizationService.Create(
  QueryExecutor: IQueryExecutor;
  DbSchemaData: TDocumentFlowAuthorizationServiceDbSchema;
  ZConnection: TZConnection);
begin

  inherited Create(QueryExecutor, DbSchemaData);

  FZConnection := ZConnection;
  
end;

function TBasedOnZeosDocumentFlowAuthorizationService.IsCurrentEmployeeSDUser: Boolean;
begin

  Result := TSDVisibilityHelper.GetVisibility(FZConnection, FZConnection.User);
  
end;

end.
