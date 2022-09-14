unit BasedOnDatabaseNativeDocumentKindsReadService;

interface

uses

  NativeDocumentKindsReadService,
  NativeDocumentKindDto,
  DocumentKindResolver,
  DocumentKindDbSchema,
  AbstractApplicationService,
  QueryExecutor,
  DataReader,
  SysUtils,
  Classes;

type

  TBasedOnDatabaseNativeDocumentKindsReadService =
    class (TAbstractApplicationService, INativeDocumentKindsReadService)

      protected

        FDocumentKindDbSchema: TDocumentKindDbSchema;
        FQueryExecutor: IQueryExecutor;
        FDocumentKindResolver: IDocumentKindResolver;

      protected

        FFetchingDocumentKindSetQueryPattern: String;
        FServicedDocumentKindSetFetchingQueryPattern: String;
        
      protected

        function PrepareFetchingDocumentKindSetQueryPattern(
          DocumentKindDbSchema: TDocumentKindDbSchema
        ): String; virtual;

        function PrepareServicedDocumentKindSetFetchingQueryPattern(
          DocumentKindDbSchema: TDocumentKindDbSchema
        ): String;

      protected

        function ExecuteFetchingDocumentKindSetQuery(
          const QueryPattern: String
        ): IDataReader; virtual;

        function ExecuteServicedDocumentKindSetFetchingQuery(
          const QueryPattern: String
        ): IDataReader;
        
      protected

        function CreateNativeDocumentKindDtosFrom(DataReader: IDataReader): TNativeDocumentKindDtos;
        
      public

        destructor Destroy; override;

        constructor Create(
          DocumentKindDbSchema: TDocumentKindDbSchema;
          QueryExecutor: IQueryExecutor;
          DocumentKindResolver: IDocumentKindResolver
        );

        function GetNativeDocumentKindDtos: TNativeDocumentKindDtos;
        function GetServicedDocumentKindDtos: TNativeDocumentKindDtos;
      
    end;

implementation

{ TBasedOnDatabaseNativeDocumentKindsReadService }

constructor TBasedOnDatabaseNativeDocumentKindsReadService.Create(
  DocumentKindDbSchema: TDocumentKindDbSchema;
  QueryExecutor: IQueryExecutor;
  DocumentKindResolver: IDocumentKindResolver
);
begin

  inherited Create;

  FDocumentKindDbSchema := DocumentKindDbSchema;
  FQueryExecutor := QueryExecutor;
  FDocumentKindResolver := DocumentKindResolver;

  FFetchingDocumentKindSetQueryPattern :=
    PrepareFetchingDocumentKindSetQueryPattern(FDocumentKindDbSchema);

  FServicedDocumentKindSetFetchingQueryPattern :=
    PrepareServicedDocumentKindSetFetchingQueryPattern(FDocumentKindDbSchema);
    
end;

destructor TBasedOnDatabaseNativeDocumentKindsReadService.Destroy;
begin

  FreeAndNil(FDocumentKindDbSchema);
  
  inherited;

end;

function TBasedOnDatabaseNativeDocumentKindsReadService.GetNativeDocumentKindDtos: TNativeDocumentKindDtos;
var DataReader: IDataReader;
begin

  DataReader := ExecuteFetchingDocumentKindSetQuery(FFetchingDocumentKindSetQueryPattern);

  if DataReader.RecordCount = 0 then
    Result := nil

  else Result := CreateNativeDocumentKindDtosFrom(DataReader);

end;

function TBasedOnDatabaseNativeDocumentKindsReadService.ExecuteFetchingDocumentKindSetQuery(
  const QueryPattern: String
): IDataReader;
begin

  Result := FQueryExecutor.ExecuteSelectionQuery(QueryPattern);

end;

function TBasedOnDatabaseNativeDocumentKindsReadService
  .ExecuteServicedDocumentKindSetFetchingQuery(const QueryPattern: String): IDataReader;
begin

  Result := FQueryExecutor.ExecuteSelectionQuery(QueryPattern);
  
end;

function TBasedOnDatabaseNativeDocumentKindsReadService.PrepareFetchingDocumentKindSetQueryPattern(
  DocumentKindDbSchema: TDocumentKindDbSchema): String;
begin

  Result :=
    'SELECT ' +
    DocumentKindDbSchema.IdColumnName + ',' +
    DocumentKindDbSchema.ParentKindIdColumnName + ',' +
    DocumentKindDbSchema.NameColumnName + ',' +
    DocumentKindDbSchema.NameColumnName + ' as original_name ' +
    'FROM ' + DocumentKindDbSchema.TableName + ' ' +
    'WHERE ' + DocumentKindDbSchema.IsPresentedColumnName +
    ' ORDER BY ' + DocumentKindDbSchema.IdColumnName;
    
end;

function TBasedOnDatabaseNativeDocumentKindsReadService.PrepareServicedDocumentKindSetFetchingQueryPattern(
  DocumentKindDbSchema: TDocumentKindDbSchema): String;
begin

  Result :=
    'SELECT ' +
    DocumentKindDbSchema.IdColumnName + ',' +
    DocumentKindDbSchema.ParentKindIdColumnName + ',' +
    DocumentKindDbSchema.NameColumnName + ',' +
    DocumentKindDbSchema.NameColumnName + ' as original_name ' +
    'FROM ' + DocumentKindDbSchema.TableName + ' ' +
    'WHERE ' + DocumentKindDbSchema.IsPresentedColumnName +
    ' AND ' + DocumentKindDbSchema.IsServicedColumnName +
    ' ORDER BY ' + DocumentKindDbSchema.IdColumnName;

end;

function TBasedOnDatabaseNativeDocumentKindsReadService.GetServicedDocumentKindDtos: TNativeDocumentKindDtos;
var
    DataReader: IDataReader;
begin

  DataReader := ExecuteServicedDocumentKindSetFetchingQuery(FServicedDocumentKindSetFetchingQueryPattern);

  if DataReader.RecordCount <> 0 then
    Result := CreateNativeDocumentKindDtosFrom(DataReader)

  else Result := nil;

end;

function TBasedOnDatabaseNativeDocumentKindsReadService.CreateNativeDocumentKindDtosFrom(
  DataReader: IDataReader
): TNativeDocumentKindDtos;

  function CreateNativeDocumentKindDtoFrom(DataReader: IDataReader): TNativeDocumentKindDto;
  begin

    Result := TNativeDocumentKindDto.Create;

    try

      Result.Id := DataReader[FDocumentKindDbSchema.IdColumnName];
      Result.TopLevelDocumentKindId := DataReader[FDocumentKindDbSchema.ParentKindIdColumnName];
      Result.Name := DataReader[FDocumentKindDbSchema.NameColumnName];
      Result.ServiceType := FDocumentKindResolver.ResovleDocumentKindById(Result.Id);
      
    except

      on E: Exception do begin

        FreeAndNil(Result);

        Raise;
        
      end;

    end;

  end;

begin

  Result := TNativeDocumentKindDtos.Create;

  try

    while DataReader.Next do
      Result.Add(CreateNativeDocumentKindDtoFrom(DataReader));

  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;

    end;

  end;

end;

end.
