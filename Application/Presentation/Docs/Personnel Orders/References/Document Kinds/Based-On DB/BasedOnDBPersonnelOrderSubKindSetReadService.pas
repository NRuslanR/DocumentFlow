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
  DB,
  SysUtils;

type

  TBasedOnDBPersonnelOrderSubKindSetReadService =
    class (TAbstractApplicationService, IPersonnelOrderSubKindSetReadService)

      private

        FPersonnelOrderSubKindSetFetchingQueryPattern: String;
        
      private

        FQueryExecutor: IQueryExecutor;

        FPersonnelOrderSubKindTableDef: TPersonnelOrderSubKindTableDef;
        FFreePersonnelOrderSubKindTableDef: IDisposable;

        function PreparePersonnelOrderSubKindSetFetchingQueryPattern(
          PersonnelOrderSubKindTableDef: TPersonnelOrderSubKindTableDef
        ): String;

        function ExecutePersonnelOrderSubKindSetFetchingQuery(const QueryPattern: String): TDataSet;

        function CreatePersonnelOrderSubKindSetFieldDefs: TPersonnelOrderSubKindSetFieldDefs;
        
      public

        constructor Create(
          QueryExecutor: IQueryExecutor;
          PersonnelOrderSubKindTableDef: TPersonnelOrderSubKindTableDef
        );
        
        function GetPersonnelOrderSubKindSet: TPersonnelOrderSubKindSetHolder;

    end;

implementation

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

end;

function TBasedOnDBPersonnelOrderSubKindSetReadService.
  CreatePersonnelOrderSubKindSetFieldDefs: TPersonnelOrderSubKindSetFieldDefs;
begin

  Result := TPersonnelOrderSubKindSetFieldDefs.Create;

  Result.IdFieldName := FPersonnelOrderSubKindTableDef.IdColumnName;
  Result.NameFieldName := FPersonnelOrderSubKindTableDef.NameColumnName;
  
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

function TBasedOnDBPersonnelOrderSubKindSetReadService.
  PreparePersonnelOrderSubKindSetFetchingQueryPattern(
    PersonnelOrderSubKindTableDef: TPersonnelOrderSubKindTableDef
  ): String;
begin

  Result :=
    Format(
      'SELECT %s, %s FROM %s',
      [
        PersonnelOrderSubKindTableDef.IdColumnName,
        PersonnelOrderSubKindTableDef.NameColumnName,

        PersonnelOrderSubKindTableDef.TableName
      ]
    );

end;

end.
