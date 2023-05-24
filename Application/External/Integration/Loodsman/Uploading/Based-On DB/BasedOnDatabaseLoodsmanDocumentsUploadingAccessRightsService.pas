unit BasedOnDatabaseLoodsmanDocumentsUploadingAccessRightsService;

interface

uses

  LoodsmanDocumentsUploadingAccessRightsService,
  LoodsmanDocumentsUploadingAccessRights,
  AbstractApplicationService,
  LoodsmanDocumentsUploadingAccessRightsTableDef,
  QueryExecutor,
  DataReader,
  SysUtils;

type

  TBasedOnDatabaseLoodsmanDocumentsUploadingAccessRightsService =
    class (TAbstractApplicationService, ILoodsmanDocumentsUploadingAccessRightsService)

      private

        FQueryExecutor: IQueryExecutor;
        FAccessRightsTableDef: TLoodsmanDocumentsUploadingAccessRightsTableDef;

        function ExecuteLoodsmanDocumentsUploadingAccessRightsGettingQuery(
          const EmployeeId: Variant
        ): IDataReader;             

        function ExtractUploadingAccessRightsFrom(
          DataReader: IDataReader
        ): TLoodsmanDocumentsUploadingAccessRights;
        
      public

        constructor Create(
          QueryExecutor: IQueryExecutor;
          AccessRightsTableDef: TLoodsmanDocumentsUploadingAccessRightsTableDef
        );
        
        function GetEmployeeLoodsmanDocumentsUploadingAccessRights(const EmployeeId: Variant): TLoodsmanDocumentsUploadingAccessRights;
        procedure EnsureEmployeeLoodsmanDocumentsUploadingAccessRights(const EmployeeId: Variant);
    
    end;
  
implementation

{ TBasedOnDatabaseLoodsmanDocumentsUploadingAccessRightsService }

constructor TBasedOnDatabaseLoodsmanDocumentsUploadingAccessRightsService.Create(
  QueryExecutor: IQueryExecutor;
  AccessRightsTableDef: TLoodsmanDocumentsUploadingAccessRightsTableDef
);
begin

  inherited Create;

  FQueryExecutor := QueryExecutor;
  FAccessRightsTableDef := AccessRightsTableDef;
  
end;

procedure TBasedOnDatabaseLoodsmanDocumentsUploadingAccessRightsService
  .EnsureEmployeeLoodsmanDocumentsUploadingAccessRights(
    const EmployeeId: Variant
  );
var
    AccessRights: TLoodsmanDocumentsUploadingAccessRights;
    Free: ILoodsmanDocumentsUploadingAccessRights;
begin

  AccessRights := GetEmployeeLoodsmanDocumentsUploadingAccessRights(EmployeeId);

  Free := AccessRights;

  if AccessRights.AllAccessRightsAbsent then begin

    Raise TLoodsmanDocumentsUploadingAccessRightsServiceException.Create(
      'Îòñóòñòâóşò ïğàâà íà âûãğóçêó äîêóìåíòîâ â ñèñòåìó "Ëîöìàí"'
    );
    
  end;

end;

function TBasedOnDatabaseLoodsmanDocumentsUploadingAccessRightsService
  .GetEmployeeLoodsmanDocumentsUploadingAccessRights(
    const EmployeeId: Variant
  ): TLoodsmanDocumentsUploadingAccessRights;
var
    DataReader: IDataReader;
begin

  DataReader :=
    ExecuteLoodsmanDocumentsUploadingAccessRightsGettingQuery(
      FAccessRightsTableDef.EmployeeIdColumnName
    );

  Result := ExtractUploadingAccessRightsFrom(DataReader);

end;

function TBasedOnDatabaseLoodsmanDocumentsUploadingAccessRightsService
  .ExecuteLoodsmanDocumentsUploadingAccessRightsGettingQuery(
    const EmployeeId: Variant
  ): IDataReader;
var
    QueryParams: TQueryParams;
begin

  QueryParams.Add(FAccessRightsTableDef.EmployeeIdColumnName, EmployeeId);

  try

    Result :=
      FQueryExecutor.ExecuteSelectionQuery(
        Format(
          'SELECT 1 FROM %s WHERE %s=:p%s',
          [
            FAccessRightsTableDef.TableName,

            FAccessRightsTableDef.EmployeeIdColumnName,
            FAccessRightsTableDef.EmployeeIdColumnName
          ]
        ),
        QueryParams
      );

  finally

    FreeAndNil(QueryParams);
    
  end;

end;

function TBasedOnDatabaseLoodsmanDocumentsUploadingAccessRightsService
  .ExtractUploadingAccessRightsFrom(
    DataReader: IDataReader
  ): TLoodsmanDocumentsUploadingAccessRights;
begin

  Result := TLoodsmanDocumentsUploadingAccessRights.Create;

  Result.UploadingAccessible := DataReader.RecordCount > 0;

end;

end.
