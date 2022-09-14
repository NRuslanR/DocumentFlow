{
  refactor:
    Создать общий класс EmployeeIncomingServiceNoteSetFetchingQueryBuilder,
    где будет определен
    шаблонный метод (паттерн), который будет
    получать строку запроса, имена параметров и их значения
    из функций, переопределяемых в наследниках
    TPostgresEmployeeIncomingServiceNoteSetFetchingQueryBuilder,
    TPostgresEmployeeApproveableServiceNoteSetFetchingQueryBuilder,
    TPostgresEmployeeOutcomingServiceNoteSetFetchingQueryBuilder.
    Сделать это также и для других типов документов - кадровые приказы
}

unit PostgresEmployeeIncomingServiceNoteSetFetchingQueryBuilder;

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

  TPostgresEmployeeIncomingServiceNoteSetFetchingQueryBuilder =
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

  SQLCastingFunctions,
  SelectDocumentRecordsViewQueries,
  AuxiliaryStringFunctions,
  StrUtils;

{ TPostgresEmployeeIncomingServiceNoteSetFetchingQueryBuilder }

procedure TPostgresEmployeeIncomingServiceNoteSetFetchingQueryBuilder
  .GetEmployeeDocumentSetByOptionsFetchingQueryPatternData(
    Options: IEmployeeDocumentSetReadOptions;
    var QueryPattern: String;
    ParamNames: TStringHash
  );
begin

  QueryPattern := SELECT_INCOMING_SERVICE_NOTES_FOR_EMPLOYEE_BY_STAGE_NAMES_QUERY;

  ParamNames['EmployeeId'] := EMPLOYEE_PARAM_NAME;
  ParamNames['StageNames'] := STAGE_NAMES_PARAM_NAME;
  
end;

procedure TPostgresEmployeeIncomingServiceNoteSetFetchingQueryBuilder
  .GetEmployeeDocumentSetFetchingQueryPatternData(
    var QueryPattern: String;
    ParamNames: TStringHash
  );
begin

  QueryPattern := SELECT_ALL_INCOMING_SERVICE_NOTES_FOR_EMPLOYEE_QUERY;

  ParamNames['EmployeeId'] := EMPLOYEE_PARAM_NAME;

end;

procedure TPostgresEmployeeIncomingServiceNoteSetFetchingQueryBuilder
  .GetEmployeeDocumentSubSetByIdsFetchingQueryPatternData(
    var QueryPattern: String;
    ParamNames: TStringHash
  );
begin

  QueryPattern := SELECT_INCOMING_SERVICE_NOTES_FOR_EMPLOYEE_BY_IDS_QUERY;

  ParamNames['EmployeeId'] := EMPLOYEE_PARAM_NAME;
  ParamNames['DocumentIds'] := DOCUMENT_IDS_PARAM_NAME;

end;

end.
