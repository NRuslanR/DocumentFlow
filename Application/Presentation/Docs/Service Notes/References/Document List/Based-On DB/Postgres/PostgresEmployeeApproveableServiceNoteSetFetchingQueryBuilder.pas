unit PostgresEmployeeApproveableServiceNoteSetFetchingQueryBuilder;

interface

uses

  BasedOnDatabaseAbstractEmployeeDocumentSetReadService,
  DB,
  DocumentKinds,
  VariantListUnit,
  SysUtils,
  Classes,
  Hashes,
  EmployeeDocumentSetReadService;

type

  TPostgresEmployeeApproveableServiceNoteSetFetchingQueryBuilder =
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

  SelectDocumentRecordsViewQueries,
  AuxiliaryStringFunctions,
  StrUtils;

{ TBasedOnDatabaseApproveableServiceNoteSetReadService }

procedure TPostgresEmployeeApproveableServiceNoteSetFetchingQueryBuilder
  .GetEmployeeDocumentSetByOptionsFetchingQueryPatternData(
    Options: IEmployeeDocumentSetReadOptions;
    var QueryPattern: String;
    ParamNames: TStringHash
  );
begin

  QueryPattern := SELECT_SERVICE_NOTES_FOR_APPROVING_FOR_EMPLOYEE_BY_STAGE_NAMES_QUERY;

  ParamNames['EmployeeId'] := EMPLOYEE_PARAM_NAME;
  ParamNames['StageNames'] := STAGE_NAMES_PARAM_NAME;

end;

procedure TPostgresEmployeeApproveableServiceNoteSetFetchingQueryBuilder
  .GetEmployeeDocumentSetFetchingQueryPatternData(
    var QueryPattern: String;
    ParamNames: TStringHash
  );
begin

  QueryPattern := SELECT_ALL_SERVICE_NOTES_FOR_APPROVING_FOR_EMPLOYEE_QUERY;

  ParamNames['EmployeeId'] := EMPLOYEE_PARAM_NAME;

end;

procedure TPostgresEmployeeApproveableServiceNoteSetFetchingQueryBuilder
  .GetEmployeeDocumentSubSetByIdsFetchingQueryPatternData(
    var QueryPattern: String;
    ParamNames: TStringHash
  );
begin

  QueryPattern := SELECT_APPROVEABLE_SERVICE_NOTES_FOR_EMPLOYEE_BY_IDS_QUERY;

  ParamNames['EmployeeId'] := EMPLOYEE_PARAM_NAME;
  ParamNames['DocumentIds'] := DOCUMENT_IDS_PARAM_NAME;

end;

end.
