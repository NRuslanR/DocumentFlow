unit BasedOnDBPersonnelOrderSubKindSetReadService;

interface

uses

  AbstractApplicationService,
  PersonnelOrderSubKindSetReadService,
  PersonnelOrderSubKindSetHolder,
  QueryExecutor,
  DataSetDataReader,
  DataSetQueryExecutor,
  PersonnelOrderSubKindTableDef,
  DataReader,
  Disposable,
  VariantListUnit,
  DB,
  SysUtils;

type

  TBasedOnDBPersonnelOrderSubKindSetReadService =
    class (TAbstractApplicationService, IPersonnelOrderSubKindSetReadService)

      private

        FPersonnelOrderSubKindSetFetchingQueryPattern: String;
        FPersonnelOrderSubKindSetByIdsFetchingQueryPattern: String;
        
      private

        FQueryExecutor: IQueryExecutor;

        FPersonnelOrderSubKindTableDef: TPersonnelOrderSubKindTableDef;
        FFreePersonnelOrderSubKindTableDef: IDisposable;

        function PreparePersonnelOrderSubKindSetFetchingQueryPattern(
          PersonnelOrderSubKindTableDef: TPersonnelOrderSubKindTableDef
        ): String;

        function PreparePersonnelOrderSubKindSetByIdsFetchingQueryPattern(
          PersonnelOrderSubKindTableDef: TPersonnelOrderSubKindTableDef
        ): String;

      private

        function ExecutePersonnelOrderSubKindSetFetchingQuery(const QueryPattern: String): TDataSet;
        function ExecutePersonnelOrderSubKindSetByIdsFetchingQuery(const QueryPattern: String; const SubKindIds: array of Variant): TDataSet;
        
        function CreatePersonnelOrderSubKindSetFieldDefs: TPersonnelOrderSubKindSetFieldDefs;
        
      public

        constructor Create(
          QueryExecutor: IQueryExecutor;
          PersonnelOrderSubKindTableDef: TPersonnelOrderSubKindTableDef
        );
        
        function GetPersonnelOrderSubKindSet: TPersonnelOrderSubKindSetHolder;
        function GetPersonnelOrderSubKindSetByIds(const SubKindIds: array of Variant): TPersonnelOrderSubKindSetHolder;

    end;

implementation

uses

  StrUtils,
  SQLCastingFunctions;
  
{ TBasedOnDBPersonnelOrderSubKindSetReadService }

constructor TBasedOnDBPersonnelOrderSubKindSetReadService.Create(
  QueryExecutor: IQueryExecutor;
  PersonnelOrderSubKindTableDef: TPersonnelOrderSubKindTableDef
);
begin

  inherited Create;

  FQueryExecutor := QueryExecutor;
  FPersonnelOrderSubKindTableDef := PersonnelOrderSubKindTableDef;

  FPersonnelOrderSubKindSetFetchingQueryPattern :=
    PreparePersonnelOrderSubKindSetFetchingQueryPattern(PersonnelOrderSubKindTableDef);

  FPersonnelOrderSubKindSetByIdsFetchingQueryPattern :=
    PreparePersonnelOrderSubKindSetByIdsFetchingQueryPattern(PersonnelOrderSubKindTableDef);

end;

function TBasedOnDBPersonnelOrderSubKindSetReadService.
  CreatePersonnelOrderSubKindSetFieldDefs: TPersonnelOrderSubKindSetFieldDefs;
begin

  Result := TPersonnelOrderSubKindSetFieldDefs.Create;

  Result.IdFieldName := FPersonnelOrderSubKindTableDef.IdColumnName;
  Result.NameFieldName := FPersonnelOrderSubKindTableDef.NameColumnName;
  
end;

function TBasedOnDBPersonnelOrderSubKindSetReadService.ExecutePersonnelOrderSubKindSetByIdsFetchingQuery(
  const QueryPattern: String; const SubKindIds: array of Variant): TDataSet;
var
    DataReader: IDataReader;
begin

  DataReader :=
    FQueryExecutor.ExecuteSelectionQuery(
      ReplaceStr(
        QueryPattern,
        'p' + FPersonnelOrderSubKindTableDef.IdColumnName,
        CreateSQLValueListString(SubKindIds)
      )
    );

  Result := TDataSetDataReader(DataReader.Self).ToDataSet;

end;

function TBasedOnDBPersonnelOrderSubKindSetReadService.
  ExecutePersonnelOrderSubKindSetFetchingQuery(const QueryPattern: String): TDataSet;
var
    DataReader: IDataReader;
begin

  DataReader := FQueryExecutor.ExecuteSelectionQuery(QueryPattern);

  Result := TDataSetDataReader(DataReader.Self).ToDataSet;
  
end;

function TBasedOnDBPersonnelOrderSubKindSetReadService.
  GetPersonnelOrderSubKindSet: TPersonnelOrderSubKindSetHolder;
begin

  Result := TPersonnelOrderSubKindSetHolder.Create;

  try

    Result.DataSet :=
      ExecutePersonnelOrderSubKindSetFetchingQuery(
        FPersonnelOrderSubKindSetFetchingQueryPattern
      );
      
    Result.FieldDefs := CreatePersonnelOrderSubKindSetFieldDefs;

  except

    FreeAndNil(Result);

    Raise;
    
  end;

end;

function TBasedOnDBPersonnelOrderSubKindSetReadService.GetPersonnelOrderSubKindSetByIds(
  const SubKindIds: array of Variant): TPersonnelOrderSubKindSetHolder;
begin

  Result := TPersonnelOrderSubKindSetHolder.Create;

  try

    Result.DataSet :=
      ExecutePersonnelOrderSubKindSetByIdsFetchingQuery(
        FPersonnelOrderSubKindSetByIdsFetchingQueryPattern,
        SubKindIds
      );

    Result.FieldDefs := CreatePersonnelOrderSubKindSetFieldDefs;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TBasedOnDBPersonnelOrderSubKindSetReadService
  .PreparePersonnelOrderSubKindSetByIdsFetchingQueryPattern(
    PersonnelOrderSubKindTableDef: TPersonnelOrderSubKindTableDef
  ): String;
begin

  with PersonnelOrderSubKindTableDef do begin
  
    Result :=
      Format(
        '%s WHERE %s=ANY(:p%s)',
        [
          PreparePersonnelOrderSubKindSetFetchingQueryPattern(
            PersonnelOrderSubKindTableDef
          ),

          IdColumnName,
          IdColumnName
        ]
      );

  end;

end;

function TBasedOnDBPersonnelOrderSubKindSetReadService.
  PreparePersonnelOrderSubKindSetFetchingQueryPattern(
    PersonnelOrderSubKindTableDef: TPersonnelOrderSubKindTableDef
  ): String;
begin

  with PersonnelOrderSubKindTableDef do begin

    Result :=
      Format(
        'SELECT %s, %s FROM %s',
        [
          IdColumnName,
          NameColumnName,

          TableName
        ]
      );

  end;

end;

end.
