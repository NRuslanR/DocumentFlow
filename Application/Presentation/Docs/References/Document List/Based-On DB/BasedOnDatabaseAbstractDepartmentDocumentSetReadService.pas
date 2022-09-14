unit BasedOnDatabaseAbstractDepartmentDocumentSetReadService;

interface

uses

  AbstractApplicationService,
  DepartmentDocumentSetReadService,
  DocumentSetHolder,
  VariantListUnit,
  BasedOnDatabaseAbstractDocumentSetReadService,
  QueryExecutor,
  DataSetQueryExecutor,
  AbstractDataReader,
  DB,
  SysUtils;

type

  IDepartmentDocumentSetFetchingQueryBuilder = interface

    function BuildDepartmentDocumentSetFetchingQuery(
      const DepartmentIds: TVariantList
    ): String;

    function BuildDepartmentDocumentSetByIdsFetchingQuery(
      const DocumentIds: TVariantList
    ): String;
    
  end;

  TDepartmentDocumentSetFetchingQueryBuilder =
    class (TInterfacedObject, IDepartmentDocumentSetFetchingQueryBuilder)

      public

        function BuildDepartmentDocumentSetFetchingQuery(
          const DepartmentIds: TVariantList
        ): String; virtual; abstract;

        function BuildDepartmentDocumentSetByIdsFetchingQuery(
          const DocumentIds: TVariantList
        ): String; virtual; abstract;
        
    end;
  
  TBasedOnDatabaseAbstractDepartmentDocumentSetReadService =
    class abstract (
      TBasedOnDatabaseAbstractDocumentSetReadService,
      IDepartmentDocumentSetReadService
    )

      protected

        FQueryBuilder: IDepartmentDocumentSetFetchingQueryBuilder;

        function ExecuteDepartmentDocumentSetFetchingQuery(
          const DepartmentIds: TVariantList
        ): TDataSet; virtual;

        function ExecuteDepartmentDocumentSetByIdsFetchingQuery(
          const DocumentIds: TVariantList
        ): TDataSet; virtual;
        
      public

        constructor Create(
          QueryExecutor: TDataSetQueryExecutor;
          QueryBuilder: IDepartmentDocumentSetFetchingQueryBuilder
        );

        function GetPreparedDocumentSet(const DepartmentIds: TVariantList): TDocumentSetHolder;
        function GetPreparedDocumentSetByIds(const DocumentIds: TVariantList): TDocumentSetHolder; overload;
        function GetPreparedDocumentSetByIds(const DocumentIds: array of Variant): TDocumentSetHolder; overload;
        
    end;
    
implementation

uses

  StrUtils,
  AuxiliaryStringFunctions,
  SelectDocumentRecordsViewQueries;

constructor TBasedOnDatabaseAbstractDepartmentDocumentSetReadService.Create(
  QueryExecutor: TDataSetQueryExecutor;
  QueryBuilder: IDepartmentDocumentSetFetchingQueryBuilder
);
begin

  inherited Create(QueryExecutor);

  FQueryBuilder := QueryBuilder;
  
end;

function TBasedOnDatabaseAbstractDepartmentDocumentSetReadService.GetPreparedDocumentSetByIds(
  const DocumentIds: array of Variant): TDocumentSetHolder;
var
    DocumentIdList: TVariantList;
begin

  DocumentIdList := TVariantList.CreateFrom(DocumentIds);

  try

    Result := GetPreparedDocumentSetByIds(DocumentIdList);
    
  finally

    FreeAndNil(DocumentIdList);

  end;

end;

function TBasedOnDatabaseAbstractDepartmentDocumentSetReadService.
  GetPreparedDocumentSet(const DepartmentIds: TVariantList): TDocumentSetHolder;
begin

  Result := CreateDocumentSetHolder;

  Result.DataSet := ExecuteDepartmentDocumentSetFetchingQuery(DepartmentIds);

end;

function TBasedOnDatabaseAbstractDepartmentDocumentSetReadService.GetPreparedDocumentSetByIds(
  const DocumentIds: TVariantList
): TDocumentSetHolder;
begin

  Result := CreateDocumentSetHolder;

  Result.DataSet := ExecuteDepartmentDocumentSetByIdsFetchingQuery(DocumentIds);

end;

function TBasedOnDatabaseAbstractDepartmentDocumentSetReadService.
  ExecuteDepartmentDocumentSetFetchingQuery(
    const DepartmentIds: TVariantList
  ): TDataSet;
begin

  Result :=
      TDataSetQueryExecutor(FQueryExecutor.Self)
        .PrepareDataSet(
          FQueryBuilder.BuildDepartmentDocumentSetFetchingQuery(
            DepartmentIds
          )
        );

end;

function TBasedOnDatabaseAbstractDepartmentDocumentSetReadService.
ExecuteDepartmentDocumentSetByIdsFetchingQuery(
  const DocumentIds: TVariantList
): TDataSet;
begin

  Result :=
    TDataSetQueryExecutor(FQueryExecutor.Self)
      .PrepareDataSet(
        FQueryBuilder.BuildDepartmentDocumentSetByIdsFetchingQuery(
          DocumentIds
        )
      );

end;

end.
