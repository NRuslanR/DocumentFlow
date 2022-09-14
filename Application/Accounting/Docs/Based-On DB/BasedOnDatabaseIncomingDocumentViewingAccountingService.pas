unit BasedOnDatabaseIncomingDocumentViewingAccountingService;

interface

uses

  BasedOnDatabaseDocumentViewingAccountingService,
  QueryExecutor,
  SysUtils,
  Classes;

type

  TIncomingLookedDocumentsDbSchema = record

    LookedDocumentsDbSchema: TLookedDocumentsDbSchema;

    IncomingDocumentTableName: String;
    OutcomingDocumentIdColumnName: String;
    IncomingDocumentIdColumnName: String;
    
  end;
  
  TBasedOnDatabaseIncomingDocumentViewingAccountingService =
    class (TBasedOnDatabaseDocumentViewingAccountingService)

      protected

        FIncomingLookedDocumentsDbSchema: TIncomingLookedDocumentsDbSchema;
          
      protected

        function PrepareDocumentViewDateByEmployeeGettingQueryPattern(
          LookedDocumentsDbSchema: TLookedDocumentsDbSchema
        ): String; override;

        function PrepareDocumentAsViewedByEmployeeMarkingQueryPattern(
          LookedDocumentsDbSchema: TLookedDocumentsDbSchema
        ): String; override;

        function PrepareDocumentViewDateByEmployeeUpdatingQueryPattern(
          LookedDocumentsDbSchema: TLookedDocumentsDbSchema
        ): String; override;

      protected

        function CreateDocumentViewDateByEmployeeGettingQueryParamsFrom(
          const DocumentId, EmployeeId: Variant
        ): TQueryParams; override;

        function CreateDocumentAsViewedByEmployeeMarkingQueryParamsFrom(
          const DocumentId, EmployeeId: Variant;
          const ViewDate: TDateTime
        ): TQueryParams; override;

        function CreateDocumentViewDateByEmployeeUpdatingQueryParamsFrom(
          const DocumentId, EmployeeId: Variant;
          const ViewDate: TDateTime
        ): TQueryParams; override;

      public

        constructor Create(
          IncomingLookedDocumentsDbSchema: TIncomingLookedDocumentsDbSchema;
          QueryExecutor: IQueryExecutor
        );
        
    end;

implementation

{ TBasedOnDatabaseIncomingDocumentViewingAccountingService }

constructor TBasedOnDatabaseIncomingDocumentViewingAccountingService.Create(
  IncomingLookedDocumentsDbSchema: TIncomingLookedDocumentsDbSchema;
  QueryExecutor: IQueryExecutor
);
begin

  FIncomingLookedDocumentsDbSchema := IncomingLookedDocumentsDbSchema;

  inherited Create(
    IncomingLookedDocumentsDbSchema.LookedDocumentsDbSchema,
    QueryExecutor
  );

end;

function TBasedOnDatabaseIncomingDocumentViewingAccountingService.
  CreateDocumentAsViewedByEmployeeMarkingQueryParamsFrom(
    const DocumentId, EmployeeId: Variant;
    const ViewDate: TDateTime
  ): TQueryParams;
begin

  Result :=
    inherited CreateDocumentAsViewedByEmployeeMarkingQueryParamsFrom(
      DocumentId, EmployeeId, ViewDate
    );

  Result.FindQueryParamByName(
    'p' + FLookedDocumentsDbSchema.DocumentIdColumnName
  ).ParamName := 'p' + FIncomingLookedDocumentsDbSchema.IncomingDocumentIdColumnName;

end;

function TBasedOnDatabaseIncomingDocumentViewingAccountingService.
  CreateDocumentViewDateByEmployeeGettingQueryParamsFrom(
    const DocumentId, EmployeeId: Variant
  ): TQueryParams;
begin

  Result :=
    inherited CreateDocumentViewDateByEmployeeGettingQueryParamsFrom(
      DocumentId, EmployeeId
    );

  Result.FindQueryParamByName(
    'p' + FLookedDocumentsDbSchema.DocumentIdColumnName
  ).ParamName := 'p' + FIncomingLookedDocumentsDbSchema.IncomingDocumentIdColumnName;
  
end;

function TBasedOnDatabaseIncomingDocumentViewingAccountingService.
  CreateDocumentViewDateByEmployeeUpdatingQueryParamsFrom(
    const DocumentId, EmployeeId: Variant;
    const ViewDate: TDateTime
  ): TQueryParams;
begin

  Result :=
    inherited CreateDocumentViewDateByEmployeeUpdatingQueryParamsFrom(
      DocumentId, EmployeeId, ViewDate
    );

  Result.FindQueryParamByName(
    'p' + FLookedDocumentsDbSchema.DocumentIdColumnName
  ).ParamName := 'p' + FIncomingLookedDocumentsDbSchema.IncomingDocumentIdColumnName;

end;

function TBasedOnDatabaseIncomingDocumentViewingAccountingService.
  PrepareDocumentAsViewedByEmployeeMarkingQueryPattern(
    LookedDocumentsDbSchema: TLookedDocumentsDbSchema
  ): String;
begin

  Result :=
    Format(
      'INSERT INTO %s (%s,%s,%s) ' +
      'SELECT ' + 
      '(SELECT %s FROM %s WHERE %s=:p%s), ' +
      ':p%s,:p%s',
      [
        LookedDocumentsDbSchema.TableName,

        LookedDocumentsDbSchema.DocumentIdColumnName,
        LookedDocumentsDbSchema.EmployeeIdColumnName,
        LookedDocumentsDbSchema.ViewDateColumnName,

        FIncomingLookedDocumentsDbSchema.OutcomingDocumentIdColumnName,

        FIncomingLookedDocumentsDbSchema.IncomingDocumentTableName,

        FIncomingLookedDocumentsDbSchema.IncomingDocumentIdColumnName,
        FIncomingLookedDocumentsDbSchema.IncomingDocumentIdColumnName,

        LookedDocumentsDbSchema.EmployeeIdColumnName,
        LookedDocumentsDbSchema.ViewDateColumnName
      ]
    );

end;

function TBasedOnDatabaseIncomingDocumentViewingAccountingService.
  PrepareDocumentViewDateByEmployeeGettingQueryPattern(
    LookedDocumentsDbSchema: TLookedDocumentsDbSchema
  ): String;
begin

  Result :=
    Format(
      'SELECT A.%s,A.%s,A.%s FROM %s A ' +
      'JOIN %s B ON B.%s=:p%s ' +
      'WHERE A.%s=B.%s AND A.%s=:p%s',
      [
        LookedDocumentsDbSchema.DocumentIdColumnName,
        LookedDocumentsDbSchema.EmployeeIdColumnName,
        LookedDocumentsDbSchema.ViewDateColumnName,

        LookedDocumentsDbSchema.TableName,

        FIncomingLookedDocumentsDbSchema.IncomingDocumentTableName,

        FIncomingLookedDocumentsDbSchema.IncomingDocumentIdColumnName,
        FIncomingLookedDocumentsDbSchema.IncomingDocumentIdColumnName,

        LookedDocumentsDbSchema.DocumentIdColumnName,
        FIncomingLookedDocumentsDbSchema.OutcomingDocumentIdColumnName,

        LookedDocumentsDbSchema.EmployeeIdColumnName,
        LookedDocumentsDbSchema.EmployeeIdColumnName
      ]
    );

end;

function TBasedOnDatabaseIncomingDocumentViewingAccountingService.
  PrepareDocumentViewDateByEmployeeUpdatingQueryPattern(
    LookedDocumentsDbSchema: TLookedDocumentsDbSchema
  ): String;
begin

  Result :=
    Format(
      'UPDATE %s SET %s=:p%s ' +
      'WHERE %s=:p%s AND %s=(SELECT %s FROM %s WHERE %s=:p%s)',
      [
        LookedDocumentsDbSchema.TableName,

        LookedDocumentsDbSchema.ViewDateColumnName,
        LookedDocumentsDbSchema.ViewDateColumnName,

        LookedDocumentsDbSchema.EmployeeIdColumnName,
        LookedDocumentsDbSchema.EmployeeIdColumnName,

        LookedDocumentsDbSchema.DocumentIdColumnName,
        FIncomingLookedDocumentsDbSchema.OutcomingDocumentIdColumnName,
        FIncomingLookedDocumentsDbSchema.IncomingDocumentTableName,
        FIncomingLookedDocumentsDbSchema.IncomingDocumentIdColumnName,
        FIncomingLookedDocumentsDbSchema.IncomingDocumentIdColumnName
      ]
    );
    
end;

end.
