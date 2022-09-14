unit PostgresEmployeePersonnelOrderSetFetchingQueryBuilder;

interface

uses

  BasedOnDatabaseAbstractEmployeeDocumentSetReadService,
  VariantListUnit,
  SysUtils,
  Hashes,
  EmployeeDocumentSetReadService;

type

  TPostgresEmployeePersonnelOrderSetFetchingQueryBuilder =
    class (TEmployeeDocumentSetFetchingQueryBuilder)

      protected

        procedure GetEmployeeDocumentSetByOptionsFetchingQueryPatternData(
          Options: IEmployeeDocumentSetReadOptions;
          var QueryPattern: String;
          ParamNames: TStringHash
        ); override;

        procedure GetEmployeeDocumentSetFetchingQueryPatternData(
          var QueryPattern: String;
          ParamNames: TStringHash
        ); override;

        procedure GetEmployeeDocumentSubSetByIdsFetchingQueryPatternData(
          var QueryPattern: String;
          ParamNames: TStringHash
        ); override;
        
    end;

implementation

uses

  AuxiliaryStringFunctions,
  StrUtils,
  SelectDocumentRecordsViewQueries;


{ TPostgresEmployeePersonnelOrderSetFetchingQueryBuilder }

procedure TPostgresEmployeePersonnelOrderSetFetchingQueryBuilder
  .GetEmployeeDocumentSetByOptionsFetchingQueryPatternData(
    Options: IEmployeeDocumentSetReadOptions;
    var QueryPattern: String;
    ParamNames: TStringHash
  );
begin

  QueryPattern := SELECT_ALL_PERSONNEL_ORDERS_FOR_EMPLOYEE_QUERY;

  ParamNames['EmployeeId'] := EMPLOYEE_PARAM_NAME;

end;

procedure TPostgresEmployeePersonnelOrderSetFetchingQueryBuilder
  .GetEmployeeDocumentSetFetchingQueryPatternData(
    var QueryPattern: String;
    ParamNames: TStringHash
  );
begin

  QueryPattern := SELECT_ALL_PERSONNEL_ORDERS_FOR_EMPLOYEE_QUERY;

  ParamNames['EmployeeId'] := EMPLOYEE_PARAM_NAME;

end;

procedure TPostgresEmployeePersonnelOrderSetFetchingQueryBuilder
  .GetEmployeeDocumentSubSetByIdsFetchingQueryPatternData(
    var QueryPattern: String;
    ParamNames: TStringHash
  );
begin

  QueryPattern := SELECT_PERSONNEL_ORDERS_FOR_EMPLOYEE_BY_IDS_QUERY;

  ParamNames['EmployeeId'] := EMPLOYEE_PARAM_NAME;
  ParamNames['DocumentIds'] := STAGE_NAMES_PARAM_NAME; 

end;

end.
