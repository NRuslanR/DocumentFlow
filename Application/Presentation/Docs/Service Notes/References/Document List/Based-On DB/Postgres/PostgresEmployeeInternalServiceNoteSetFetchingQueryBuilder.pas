unit PostgresEmployeeInternalServiceNoteSetFetchingQueryBuilder;

interface

uses

  BasedOnDatabaseAbstractEmployeeDocumentSetReadService,
  DB,
  DocumentKinds,
  SysUtils,
  Classes,
  Hashes,
  EmployeeDocumentSetReadService;

type

  TPostgresEmployeeInternalServiceNoteSetFetchingQueryBuilder =
    class (TEmployeeDocumentSetFetchingQueryBuilder)

      protected

        procedure GetEmployeeDocumentSetByOptionsFetchingQueryPatternData(
          Options: IEmployeeDocumentSetReadOptions;
          var QueryPattern: String;
          ParamNames: TStringHash
        ); override;

    end;
  
implementation

uses

  SelectDocumentRecordsViewQueries,
  AuxiliaryStringFunctions,
  StrUtils;

{ TBasedOnDatabaseInternalServiceNoteSetReadService }

procedure TPostgresEmployeeInternalServiceNoteSetFetchingQueryBuilder
  .GetEmployeeDocumentSetByOptionsFetchingQueryPatternData(
    Options: IEmployeeDocumentSetReadOptions;
    var QueryPattern: String;
    ParamNames: TStringHash
  );
begin

  QueryPattern := SELECT_ALL_INTERNAL_SERVICE_NOTES_FOR_EMPLOYEE_QUERY;

  ParamNames['EmployeeId'] := EMPLOYEE_PARAM_NAME;

end;

end.
