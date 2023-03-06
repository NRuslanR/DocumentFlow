{ refactor: внедрять справочник информации о видах документов (номера стадий) }
unit EmployeeDocumentWorkStatisticsPostgresService;

interface

uses

  EmployeeDocumentWorkStatistics,
  EmployeeDocumentWorkStatisticsService,
  AbstractEmployeeDocumentWorkStatisticsZeosService,
  IEmployeeRepositoryUnit,
  DocumentKinds,
  Employee,
  Role,
  ZDataset,
  ZConnection,
  VariantListUnit,
  DocumentKindResolver,
  SysUtils,
  Classes,
  DB;

type

  TEmployeeDocumentKindWorkStatisticsFetching = class

    private

      OwnActionDocumentStageNumbers: TVariantList;
      InWorkingDocumentStageNumbers: TVariantList;

      constructor Create;

      procedure AddOwnActionDocumentStageNumber(
        const StageNumber: Integer
      );

      procedure AddInWorkingDocumentStageNumber(
        const StageNumber: Integer
      );
      
    public

      destructor Destroy; override;

  end;

  TEmployeeDocumentKindWorkStatisticsFetchingQueryData = class

    public

      OwnActionDocumentStageNumbersStringList: String;
      InWorkingDocumentStageNumbersStringList: String;

  end;

  TEmployeeDocumentKindsWorkStatisticsQueryParts = record

    FetchingDocumentKindsInfoLocalViewDefs: String;
    FetchingDocumentKindUnionStatisticsQueries: String;
    
  end;

  TEmployeeDocumentWorkStatisticsPostgresService =
    class (TAbstractEmployeeDocumentWorkStatisticsZeosService)

      protected

        function MapEmployeeDocumentKindWorkStatisticsFetchingFrom(
          EmployeeRole: TRole;
          const DocumentKind: TDocumentKindClass
        ): TEmployeeDocumentKindWorkStatisticsFetching;

        function CreateEmployeeOutcommingServiceNotesInfoFetchingQuery(
          const EmployeeId: Variant
        ): String;

        function CreateEmployeeApproveableServiceNotesInfoFetchingQuery(
          const EmployeeId: Variant
        ): String;

        function CreateEmployeeApproveableDocumentsInfoFetchingQuery(
          const EmployeeId: Variant
        ): String;
        
        function CreateEmployeeIncommingServiceNotesInfoFetchingQuery(
          const EmployeeId: Variant
        ): String;

        function CreeateEmployeeOutcommingDocumentInfoFetchingQuery(
          const EmployeeId: Variant
        ): String;

        function CreeateEmployeeIncommingDocumentInfoFetchingQuery(
          const EmployeeId: Variant
        ): String;

        function MapEmployeeDocumentKindWorkStatisticsFetchingToSQLStringList(
          EmployeeDocumentKindWorkStatisticsFetching:
            TEmployeeDocumentKindWorkStatisticsFetching
        ): TEmployeeDocumentKindWorkStatisticsFetchingQueryData;

        function GetDocumentKindsWorkStatisticsForEmployeeQueryText(

          OutcommingDocumentKinds: array of TOutcomingDocumentKindClass;
          ApproveableDocumentKinds: array of TApproveableDocumentKindClass;
          IncommingDocumentKinds: array of TIncomingDocumentKindClass;

          const EmployeeId: Variant
        ): String;
         
        procedure ExecuteEmployeeDocumentWorkStatisticsFetchingQuery(
          const StatisticsFetchingQuery: String
        );

        function
        MapEmployeeDocumentWorkStatisticsListFromStatisticsFetchingQueryResult(
          ResultSet: TDataSet;

          OutcommingDocumentKinds: array of TOutcomingDocumentKindClass;
          ApproveableDocumentKinds: array of TApproveableDocumentKindClass;
          IncommingDocumentKinds: array of TIncomingDocumentKindClass

        ): TEmployeeDocumentWorkStatisticsList;

        function GetEmployeeOutcommingDocumentKindsWorkStatisticsQueryParts(
          Employee: TEmployee;
          OutcommingDocumentKinds: array of TOutcomingDocumentKindClass
        ): TEmployeeDocumentKindsWorkStatisticsQueryParts;

        function GetEmployeeApproveableDocumentKindsWorkStatisticsQueryParts(
          Employee: TEmployee;
          ApproveableDocumentKinds: array of TApproveableDocumentKindClass
        ): TEmployeeDocumentKindsWorkStatisticsQueryParts;
        
        function GetEmployeeIncommingDocumentKindsWorkStatisticsQueryParts(
          Employee: TEmployee;
          IncommingDocumentKinds: array of TIncomingDocumentKindClass
        ): TEmployeeDocumentKindsWorkStatisticsQueryParts;
         
        function InternalGetDocumentWorkStatisticsForEmployee(
          const EmployeeId: Variant
        ): TEmployeeDocumentWorkStatisticsList; override;

        function InternalGetDocumentKindsWorkStatisticsForEmployee(

          OutcommingDocumentKinds: array of TOutcomingDocumentKindClass;
          ApproveableDocumentKinds: array of TApproveableDocumentKindClass;
          IncommingDocumentKinds: array of TIncomingDocumentKindClass;

          const EmployeeId: Variant

        ): TEmployeeDocumentWorkStatisticsList; override;

        procedure InternalGetDocumentKindsWorkStatisticsForEmployeeAsync(

          OutcommingDocumentKinds: array of TOutcomingDocumentKindClass;
          ApproveableDocumentKinds: array of TApproveableDocumentKindClass;
          IncommingDocumentKinds: array of TIncomingDocumentKindClass;
          
          const EmployeeId: Variant;

          OnDocumentWorkStatisticsFetchedEventHandler:
            TOnDocumentWorkStatisticsFetchedEventHandler;

          OnDocumentWorkStatisticsFetchingErrorEventHandler:
            TOnDocumentWorkStatisticsFetchingErrorEventHandler

        ); override;

      protected

        procedure OnDocumentWorkStatisticsFetchingQuerySuccessEventHandler(
          Sender: TObject;
          DataSet: TDataSet;
          RelatedState: TObject
        );
        
        procedure OnDocumentWorkStatisticsFetchingQueryFailedEventHandler(
          Sender: Tobject;
          DataSet: TDataSet;
          const Error: Exception;
          RelatedState: TObject
        );

      public

        constructor Create(
          Connection: TZConnection;
          EmployeeRepository: IEmployeeRepository;
          DocumentKindResolver: IDocumentKindResolver
        ); overload;

    end;


implementation

uses

  StrUtils,
  AuxZeosFunctions,
  AuxAsyncZeosFunctions;

type

  TDocumentWorkStatisticsAsyncFetchingEventHandlers = class

    OutcommingDocumentKinds: array of TOutcomingDocumentKindClass;
    IncommingDocumentKinds: array of TIncomingDocumentKindClass;
    ApproveableDocumentKinds: array of TApproveableDocumentKindClass;
    
    OnDocumentWorkStatisticsFetchedEventHandler:
      TOnDocumentWorkStatisticsFetchedEventHandler;

    OnDocumentWorkStatisticsFetchingErrorEventHandler:
      TOnDocumentWorkStatisticsFetchingErrorEventHandler;

    constructor Create(

      OutcommingDocumentKinds: array of TOutcomingDocumentKindClass;
      ApproveableDocumentKinds: array of TApproveableDocumentKindClass;
      IncommingDocumentKinds: array of TIncomingDocumentKindClass;
      
      OnDocumentWorkStatisticsFetchedEventHandler:
        TOnDocumentWorkStatisticsFetchedEventHandler;

      OnDocumentWorkStatisticsFetchingErrorEventHandler:
        TOnDocumentWorkStatisticsFetchingErrorEventHandler
    );

  end;

{ TEmployeeDocumentWorkStatisticsPostgresService }

constructor TEmployeeDocumentWorkStatisticsPostgresService.Create(
  Connection: TZConnection;
  EmployeeRepository: IEmployeeRepository;
  DocumentKindResolver: IDocumentKindResolver
);
begin

  inherited Create(Connection, EmployeeRepository, DocumentKindResolver);

end;

function TEmployeeDocumentWorkStatisticsPostgresService.CreateEmployeeApproveableDocumentsInfoFetchingQuery(
  const EmployeeId: Variant): String;
begin

  Result := '';
  
end;

function TEmployeeDocumentWorkStatisticsPostgresService.
  CreateEmployeeOutcommingServiceNotesInfoFetchingQuery(
    const EmployeeId: Variant
  ): String;
begin

  Result :=
    'select' + #13#10 +
      'a.id as id,' + #13#10 + 
      'a.type_id,' + #13#10 + 
      'c.service_stage_name,' + #13#10 +
      'c.stage_number,' + #13#10 +
      'employee_author.ok as is_employee_author,' + #13#10 + 
      'employee_signer.ok as is_employee_signer' + #13#10 + 
      '' + #13#10 + 
      'from doc.service_notes a' + #13#10 + 
      'join doc.employees e on e.id = a.author_id' + #13#10 + 
      'join doc.document_types b on a.type_id = b.id' + #13#10 + 
      'join doc.document_type_work_cycle_stages c on c.id = a.current_work_cycle_stage_id' + #13#10 + 
      'join doc.employees_roles er on er.employee_id = :employee_id' + #13#10 + 
      'join doc.employees e1 on e1.id = :employee_id' + #13#10 + 
      'left join doc.service_note_signings s on s.document_id = a.id' + #13#10 + 
      'left join doc.employees signer on signer.id = s.signer_id' + #13#10 + 
      'join lateral (' + #13#10 + 
        'select' + #13#10 + 
          'a.author_id = :employee_id' + #13#10 + 
          'or doc.is_employee_subleader_or_replacing_for_other(:employee_id, a.author_id)' + #13#10 + 
      ') employee_author(ok) on true' + #13#10 + 
      'join lateral (' + #13#10 + 
        'select' + #13#10 + 
          's.signer_id = :employee_id' + #13#10 + 
          'or doc.is_employee_acting_for_other_or_vice_versa(:employee_id, s.signer_id)' + #13#10 + 
      ') employee_signer(ok) on true' + #13#10 + 
      'where' + #13#10 + 
      '(a.author_id is not null) and' + #13#10 + 
      '(' + #13#10 + 
        '(e.head_kindred_department_id = e1.head_kindred_department_id and employee_author.ok)' + #13#10 + 
        'or' + #13#10 + 
        '(' + #13#10 + 
        'a.is_sent_to_signing' + #13#10 + 
        'and' + #13#10 + 
        'e1.head_kindred_department_id = signer.head_kindred_department_id' + #13#10 + 
        'and employee_signer.ok' + #13#10 + 
        ')' + #13#10 + 
      ')';

  Result := ReplaceStr(Result, ':employee_id', EmployeeId);

end;

function TEmployeeDocumentWorkStatisticsPostgresService.
  CreateEmployeeIncommingServiceNotesInfoFetchingQuery(
    const EmployeeId: Variant
  ): String;
begin

  Result :=
    'with incoming_service_notes_charges as (' + #13#10 +
      'select' + #13#10 + 
      '' + #13#10 + 
      'b.head_charge_sheet_id as id,' + #13#10 + 
      'b.incoming_document_type_id as type_id,' + #13#10 + 
      '' + #13#10 + 
      'row_number() over (' + #13#10 + 
        'partition by b.head_charge_sheet_id' + #13#10 + 
        '' + #13#10 + 
        'order by dtwcs.stage_number,' + #13#10 + 
        '' + #13#10 + 
        'case' + #13#10 + 
            'when b.performer_id = :employee_id' + #13#10 + 
            'then 0' + #13#10 + 
            'else' + #13#10 + 
                'case' + #13#10 + 
                    'when replacing.ok' + #13#10 + 
                    'then 1' + #13#10 + 
                    'else 2' + #13#10 + 
                'end' + #13#10 + 
        'end' + #13#10 + 
      ') as charge_number,' + #13#10 + 
      '' + #13#10 + 
      'replacing.ok as is_performer_replacing_ok,' + #13#10 + 
      '' + #13#10 + 
      'total_charge_count,' + #13#10 + 
      'performed_charge_count,' + #13#10 + 
      'coalesce(subordinate_charge_count, 0) as subordinate_charge_count,' + #13#10 + 
      'performing_date' + #13#10 + 
      '' + #13#10 + 
      'from doc.service_note_receivers b' + #13#10 + 
      'join doc.document_types c on c.id = b.incoming_document_type_id' + #13#10 + 
      'join doc.employees cur_emp on cur_emp.id = :employee_id' + #13#10 + 
      'join doc.document_type_work_cycle_stages dtwcs on dtwcs.document_type_id = c.id and dtwcs.service_stage_name = case when b.performing_date is not null then ''Performed'' else ''IsPerforming'' end' + #13#10 +
      'join doc.employees_roles cur_emp_role on cur_emp_role.employee_id = :employee_id' + #13#10 + 
      'join lateral (select :employee_id = b.performer_id or doc.is_employee_acting_for_other_or_vice_versa(:employee_id, b.performer_id)) replacing(ok) on true' + #13#10 + 
      'where b.issuer_id is not null' + #13#10 + 
      'and replacing.ok' + #13#10 + 
    ')' + #13#10 + 
    'select' + #13#10 + 
    '' + #13#10 + 
      'isnc.id,' + #13#10 + 
      'isnc.type_id,' + #13#10 +
      'd.stage_number,' + #13#10 +
      'd.service_stage_name,' + #13#10 + 
      'is_performer_replacing_ok,' + #13#10 + 
      'isnc.subordinate_charge_count > 0 as subordinate_charges_exists' + #13#10 + 
      '' + #13#10 + 
      'from incoming_service_notes_charges isnc' + #13#10 + 
      'join doc.service_note_receivers in_doc on in_doc.id = isnc.id' + #13#10 + 
      '' + #13#10 + 
      'join doc.document_type_work_cycle_stages d on d.document_type_id = isnc.type_id' + #13#10 + 
      'and' + #13#10 + 
      'd.service_stage_name =' + #13#10 + 
      'case when isnc.total_charge_count > 0' + #13#10 + 
           'then' + #13#10 + 
        'case when isnc.total_charge_count = isnc.performed_charge_count' + #13#10 + 
        'then ''Performed'' else ''IsPerforming'' end' + #13#10 + 
           'else' + #13#10 + 
           'case' + #13#10 + 
             'when isnc.performing_date is not null' + #13#10 + 
             'then ''Performed'' else ''IsPerforming''' + #13#10 + 
         'end' + #13#10 + 
      'end' + #13#10 + 
     '' + #13#10 + 
      'where charge_number = 1 and in_doc.input_number_date is not null and in_doc.input_number is not null';

  Result := ReplaceStr(Result, ':employee_id', EmployeeId);

end;

function TEmployeeDocumentWorkStatisticsPostgresService.
  CreateEmployeeApproveableServiceNotesInfoFetchingQuery(
    const EmployeeId: Variant
  ): String;
begin

  Result :=
    'select ' + #13#10 +
      'distinct' + #13#10 + 
      'a.id as id,' + #13#10 + 
      '(select id from doc.document_types where service_name = ''approveable_service_note'') as type_id,' + #13#10 + 
      'c.service_stage_name,' + #13#10 +
      'c.stage_number,' + #13#10 +
      'employee_approver.ok as is_employee_approver' + #13#10 + 
      '' + #13#10 + 
      'from doc.service_notes a' + #13#10 + 
      'join doc.employees e on e.id = a.author_id' + #13#10 + 
      'left join doc.employees resp on resp.spr_person_id = a.performer_id' + #13#10 + 
      'left join doc.departments author_head_dep on author_head_dep.id = resp.head_kindred_department_id' + #13#10 + 
      'join doc.document_types b on a.type_id = b.id' + #13#10 + 
      'join doc.document_type_work_cycle_stages c on c.id = a.current_work_cycle_stage_id' + #13#10 + 
      'join doc.employees cur_user on cur_user.id = :employee_id' + #13#10 + 
      'join doc.employees_roles cur_user_role on cur_user_role.employee_id = :employee_id' + #13#10 + 
      'join doc.service_note_approvings sna on sna.document_id = a.id' + #13#10 + 
      'join doc.document_approving_results dar on dar.id = sna.performing_result_id' + #13#10 + 
      'join lateral (' + #13#10 + 
        'select' + #13#10 + 
          'sna.approver_id = :employee_id' + #13#10 + 
          'or doc.is_employee_subleader_or_replacing_for_other(:employee_id , sna.approver_id)' + #13#10 + 
      ') employee_approver(ok) on true' + #13#10 + 
      'where' + #13#10 + 
      'employee_approver.ok' + #13#10 + 
      'and c.stage_number = 2 and dar.id = 3';

  Result := ReplaceStr(Result, ':employee_id', EmployeeId);

end;

function TEmployeeDocumentWorkStatisticsPostgresService.
  CreeateEmployeeIncommingDocumentInfoFetchingQuery(
    const EmployeeId: Variant
  ): String;
begin

  Result := '';
  
end;

function TEmployeeDocumentWorkStatisticsPostgresService.
  CreeateEmployeeOutcommingDocumentInfoFetchingQuery(
    const EmployeeId: Variant
  ): String;
begin

  Result := '';

end;

procedure TEmployeeDocumentWorkStatisticsPostgresService.ExecuteEmployeeDocumentWorkStatisticsFetchingQuery(
  const StatisticsFetchingQuery: String);
begin

  FZQuery.SQL.Text := StatisticsFetchingQuery;
  FZQuery.Open;

end;

function TEmployeeDocumentWorkStatisticsPostgresService.
  GetDocumentKindsWorkStatisticsForEmployeeQueryText(
    OutcommingDocumentKinds: array of TOutcomingDocumentKindClass;
    ApproveableDocumentKinds: array of TApproveableDocumentKindClass;
    IncommingDocumentKinds: array of TIncomingDocumentKindClass;
    const EmployeeId: Variant
  ): String;
var Employee: TEmployee;

    FetchingStatisticsQuery: String;

    EmployeeOutcommingDocumentKindsWorkStatisticsQueryParts:
      TEmployeeDocumentKindsWorkStatisticsQueryParts;

    EmployeeApproveableDocumentKindsWorkStatisticsQueryParts:
      TEmployeeDocumentKindsWorkStatisticsQueryParts;
      
    EmployeeIncommingDocumentKindsWorkStatisticsQueryParts:
      TEmployeeDocumentKindsWorkStatisticsQueryParts;
begin

  Employee := nil;

  try

    Employee := FEmployeeRepository.FindEmployeeById(EmployeeId);

    if not Assigned(Employee) then begin

      raise Exception.Create(
              'Не найдена информация о сотруднике для сбора ' +
              'рабочей статистики по документам'
            );

    end;

    EmployeeOutcommingDocumentKindsWorkStatisticsQueryParts:=
      GetEmployeeOutcommingDocumentKindsWorkStatisticsQueryParts(
        Employee, OutcommingDocumentKinds
      );

    EmployeeApproveableDocumentKindsWorkStatisticsQueryParts :=
      GetEmployeeApproveableDocumentKindsWorkStatisticsQueryParts(
        Employee, ApproveableDocumentKinds
      );
      
    EmployeeIncommingDocumentKindsWorkStatisticsQueryParts :=
      GetEmployeeIncommingDocumentKindsWorkStatisticsQueryParts(
        Employee, IncommingDocumentKinds
      );

    { Forming the Fetching Employee Document Work Statistics Query }
    begin
    
      FetchingStatisticsQuery :=
        'with ' +
        EmployeeOutcommingDocumentKindsWorkStatisticsQueryParts.
          FetchingDocumentKindsInfoLocalViewDefs;

      if

          (FetchingStatisticsQuery <> 'with ') and
          ((EmployeeIncommingDocumentKindsWorkStatisticsQueryParts.
              FetchingDocumentKindsInfoLocalViewDefs <> ''
           ) or
           (EmployeeApproveableDocumentKindsWorkStatisticsQueryParts.
              FetchingDocumentKindsInfoLocalViewDefs <> ''
           )
          )

      then
        FetchingStatisticsQuery := FetchingStatisticsQuery + ',';

      FetchingStatisticsQuery :=
        FetchingStatisticsQuery +
        EmployeeIncommingDocumentKindsWorkStatisticsQueryParts.
          FetchingDocumentKindsInfoLocalViewDefs;

      if (EmployeeIncommingDocumentKindsWorkStatisticsQueryParts.
            FetchingDocumentKindsInfoLocalViewDefs <> '') and
         (EmployeeApproveableDocumentKindsWorkStatisticsQueryParts.
          FetchingDocumentKindsInfoLocalViewDefs <> '')
      then
        FetchingStatisticsQuery := FetchingStatisticsQuery + ',';

      FetchingStatisticsQuery :=
        FetchingStatisticsQuery +
        EmployeeApproveableDocumentKindsWorkStatisticsQueryParts.
          FetchingDocumentKindsInfoLocalViewDefs;
  
      FetchingStatisticsQuery :=
        FetchingStatisticsQuery + ' ' +
        EmployeeOutcommingDocumentKindsWorkStatisticsQueryParts.
          FetchingDocumentKindUnionStatisticsQueries;

      if

          (EmployeeOutcommingDocumentKindsWorkStatisticsQueryParts.
            FetchingDocumentKindUnionStatisticsQueries <> '') and
          (EmployeeIncommingDocumentKindsWorkStatisticsQueryParts.
            FetchingDocumentKindUnionStatisticsQueries <> '')

      then FetchingStatisticsQuery := FetchingStatisticsQuery + ' union ';

      FetchingStatisticsQuery :=
        FetchingStatisticsQuery +
        EmployeeIncommingDocumentKindsWorkStatisticsQueryParts.
          FetchingDocumentKindUnionStatisticsQueries;

      if
          ((EmployeeOutcommingDocumentKindsWorkStatisticsQueryParts.
            FetchingDocumentKindUnionStatisticsQueries <> '') or
          (EmployeeIncommingDocumentKindsWorkStatisticsQueryParts.
            FetchingDocumentKindUnionStatisticsQueries <> '')) and
          (EmployeeApproveableDocumentKindsWorkStatisticsQueryParts.
            FetchingDocumentKindUnionStatisticsQueries <> '')

      then FetchingStatisticsQuery := FetchingStatisticsQuery + ' union ';

      FetchingStatisticsQuery :=
        FetchingStatisticsQuery +
        EmployeeApproveableDocumentKindsWorkStatisticsQueryParts.
          FetchingDocumentKindUnionStatisticsQueries;

      Result := FetchingStatisticsQuery;

    end;

  finally

    FreeAndNil(Employee);

  end;

end;

function TEmployeeDocumentWorkStatisticsPostgresService.
  GetEmployeeOutcommingDocumentKindsWorkStatisticsQueryParts(
    Employee: TEmployee;
    OutcommingDocumentKinds: array of TOutcomingDocumentKindClass
  ): TEmployeeDocumentKindsWorkStatisticsQueryParts;
var
    EmployeeDocumentKindWorkStatisticsFetching:
      TEmployeeDocumentKindWorkStatisticsFetching;

    EmployeeDocumentKindWorkStatisticsFetchingQueryData:
      TEmployeeDocumentKindWorkStatisticsFetchingQueryData;

    EmployeeDocumentInfoFetchingQuery: String;

    FetchingDocumentKindInfoLocalViewDefs: String;
    FetchingDocumentKindInfoLocalViewName: String;
    FetchingDocumentKindStatisticsQueries: String;

    OutcommingDocumentKind: TDocumentKindClass;
begin

  for OutcommingDocumentKind in OutcommingDocumentKinds do begin

      if OutcommingDocumentKind = TOutcomingServiceNoteKind then begin

        EmployeeDocumentInfoFetchingQuery :=
          CreateEmployeeOutcommingServiceNotesInfoFetchingQuery(
            Employee.Identity
          );

      end

      else begin

        EmployeeDocumentInfoFetchingQuery :=
          CreeateEmployeeOutcommingDocumentInfoFetchingQuery(
            Employee.Identity
          );

      end;
      
      EmployeeDocumentKindWorkStatisticsFetching :=

        MapEmployeeDocumentKindWorkStatisticsFetchingFrom(
          Employee.Role, OutcommingDocumentKind
        );

      EmployeeDocumentKindWorkStatisticsFetchingQueryData :=
        MapEmployeeDocumentKindWorkStatisticsFetchingToSQLStringList(
          EmployeeDocumentKindWorkStatisticsFetching
        );

      if Result.FetchingDocumentKindsInfoLocalViewDefs <> '' then
        Result.FetchingDocumentKindsInfoLocalViewDefs :=
          Result.FetchingDocumentKindsInfoLocalViewDefs + ',';

      FetchingDocumentKindInfoLocalViewName :=
        'get_' + OutcommingDocumentKind.ClassName + '_info';
        
      Result.FetchingDocumentKindsInfoLocalViewDefs :=
        Result.FetchingDocumentKindsInfoLocalViewDefs +
        FetchingDocumentKindInfoLocalViewName + ' as '
        + '(' + EmployeeDocumentInfoFetchingQuery + ')';

      if Result.FetchingDocumentKindUnionStatisticsQueries <> '' then
        Result.FetchingDocumentKindUnionStatisticsQueries :=
          Result.FetchingDocumentKindUnionStatisticsQueries + ' union ';

      Result.FetchingDocumentKindUnionStatisticsQueries :=
        Result.FetchingDocumentKindUnionStatisticsQueries +
        
        'select distinct ' + #13#10 +
        'type_id,' + #13#10 +
        'count(case when stage_number in (' +

        EmployeeDocumentKindWorkStatisticsFetchingQueryData.
          OwnActionDocumentStageNumbersStringList +

        ') and ((is_employee_signer and 5 in (' +
        EmployeeDocumentKindWorkStatisticsFetchingQueryData.
          OwnActionDocumentStageNumbersStringList
        + ')) or (is_employee_author and array[6,1] <@ array[' +
           EmployeeDocumentKindWorkStatisticsFetchingQueryData.
          OwnActionDocumentStageNumbersStringList +
        '])) then 1 else null end) over () as own_action_count,' + #13#10 +
        'count(case when stage_number in (' +

        EmployeeDocumentKindWorkStatisticsFetchingQueryData.
          InWorkingDocumentStageNumbersStringList +

        ') and (is_employee_signer or is_employee_author) ' +
        'then 1 else null end) over () as in_working_count' + #13#10 +
        'from' + #13#10 +
        FetchingDocumentKindInfoLocalViewName + #13#10;

      FreeAndNil(EmployeeDocumentKindWorkStatisticsFetching);
      FreeAndNil(EmployeeDocumentKindWorkStatisticsFetchingQueryData);

  end;

end;

function TEmployeeDocumentWorkStatisticsPostgresService.
  GetEmployeeIncommingDocumentKindsWorkStatisticsQueryParts(
    Employee: TEmployee;
    IncommingDocumentKinds: array of TIncomingDocumentKindClass
  ): TEmployeeDocumentKindsWorkStatisticsQueryParts;
var
    EmployeeDocumentKindWorkStatisticsFetching:
      TEmployeeDocumentKindWorkStatisticsFetching;

    EmployeeDocumentKindWorkStatisticsFetchingQueryData:
      TEmployeeDocumentKindWorkStatisticsFetchingQueryData;

    EmployeeDocumentInfoFetchingQuery: String;

    FetchingDocumentKindInfoLocalViewDefs: String;
    FetchingDocumentKindInfoLocalViewName: String;
    FetchingDocumentKindStatisticsQueries: String;

    IncommingDocumentKind: TIncomingDocumentKindClass;

    IncommingDocumentReceiversTableName: String;

begin

  for IncommingDocumentKind in IncommingDocumentKinds do begin

      if IncommingDocumentKind = TIncomingServiceNoteKind then begin

        EmployeeDocumentInfoFetchingQuery :=
          CreateEmployeeIncommingServiceNotesInfoFetchingQuery(
            Employee.Identity
          );

        IncommingDocumentReceiversTableName := 'doc.service_note_receivers';

      end

      else begin

        EmployeeDocumentInfoFetchingQuery :=
          CreeateEmployeeIncommingDocumentInfoFetchingQuery(
            Employee.Identity
          );

        IncommingDocumentReceiversTableName := 'doc.document_receivers';
        
      end;
      
      EmployeeDocumentKindWorkStatisticsFetching :=

        MapEmployeeDocumentKindWorkStatisticsFetchingFrom(
          Employee.Role, IncommingDocumentKind
        );

      EmployeeDocumentKindWorkStatisticsFetchingQueryData :=
        MapEmployeeDocumentKindWorkStatisticsFetchingToSQLStringList(
          EmployeeDocumentKindWorkStatisticsFetching
        );

      if Result.FetchingDocumentKindsInfoLocalViewDefs <> '' then
        Result.FetchingDocumentKindsInfoLocalViewDefs :=
          Result.FetchingDocumentKindsInfoLocalViewDefs + ',';

      FetchingDocumentKindInfoLocalViewName :=
        'get_' + IncommingDocumentKind.ClassName + '_info';
        
      Result.FetchingDocumentKindsInfoLocalViewDefs :=
        Result.FetchingDocumentKindsInfoLocalViewDefs +
        FetchingDocumentKindInfoLocalViewName + ' as '
        + '(' + EmployeeDocumentInfoFetchingQuery + ')';

      if Result.FetchingDocumentKindUnionStatisticsQueries <> '' then
        Result.FetchingDocumentKindUnionStatisticsQueries :=
          Result.FetchingDocumentKindUnionStatisticsQueries + ' union ';

      Result.FetchingDocumentKindUnionStatisticsQueries :=
        Result.FetchingDocumentKindUnionStatisticsQueries +
        'select distinct' + #13#10 +
        'type_id,' + #13#10 +
        'count(case when (stage_number in (' +

        EmployeeDocumentKindWorkStatisticsFetchingQueryData.
          OwnActionDocumentStageNumbersStringList +

        ') and not subordinate_charges_exists and is_performer_replacing_ok) ' +
        'then 1 else null end)' + #13#10 +
        'over () as own_action_count,' + #13#10 +
        'count(case when (stage_number in (' +

        EmployeeDocumentKindWorkStatisticsFetchingQueryData.
          InWorkingDocumentStageNumbersStringList +

        ') and is_performer_replacing_ok) then 1 else null end) ' +
        'over () as in_working_count' + #13#10 +
        'from' + #13#10 +
        FetchingDocumentKindInfoLocalViewName + ' a';

      FreeAndNil(EmployeeDocumentKindWorkStatisticsFetching);
      FreeAndNil(EmployeeDocumentKindWorkStatisticsFetchingQueryData);

  end;

end;


function TEmployeeDocumentWorkStatisticsPostgresService.
  GetEmployeeApproveableDocumentKindsWorkStatisticsQueryParts(
  
    Employee: TEmployee;
    ApproveableDocumentKinds: array of TApproveableDocumentKindClass

  ): TEmployeeDocumentKindsWorkStatisticsQueryParts;

var
    ApproveableDocumentKind: TApproveableDocumentKindClass;
    EmployeeApproveableDocumentsInfoFetchingQuery: String;
    FetchingDocumentKindsInfoLocalViewDefs: String;
    FetchingDocumentKindInfoLocalViewName: String;
    FetchingDocumentKindStatisticsQueries: String;
begin

  for ApproveableDocumentKind in ApproveableDocumentKinds do begin

    if ApproveableDocumentKind = TApproveableServiceNoteKind then begin

      EmployeeApproveableDocumentsInfoFetchingQuery :=
        CreateEmployeeApproveableServiceNotesInfoFetchingQuery(
          Employee.Identity
        );

    end

    else begin

      EmployeeApproveableDocumentsInfoFetchingQuery :=
        CreateEmployeeApproveableDocumentsInfoFetchingQuery(
          Employee.Identity
        );

    end;

    FetchingDocumentKindInfoLocalViewName :=
      'get_' + ApproveableDocumentKind.ClassName + '_info';

    if FetchingDocumentKindsInfoLocalViewDefs <> '' then begin
    
      FetchingDocumentKindsInfoLocalViewDefs :=
        FetchingDocumentKindsInfoLocalViewDefs + ','

    end;

    FetchingDocumentKindsInfoLocalViewDefs :=
      FetchingDocumentKindsInfoLocalViewDefs +
      FetchingDocumentKindInfoLocalViewName + ' as (' +
      EmployeeApproveableDocumentsInfoFetchingQuery + ')';

    if FetchingDocumentKindStatisticsQueries <> '' then begin

      FetchingDocumentKindStatisticsQueries :=
        FetchingDocumentKindStatisticsQueries + ' union ';

    end;

    FetchingDocumentKindStatisticsQueries :=
      FetchingDocumentKindStatisticsQueries +
      'select distinct' + #13#10 + 
      'type_id,' + #13#10 + 
      'count (case when service_stage_name = ''IsApproving'' and is_employee_approver ' + #13#10 +
      'then 1 else null end) over () own_action_count,' + #13#10 +
      '0 as in_working_count' + #13#10 + 
      'from ' + FetchingDocumentKindInfoLocalViewName;

  end;

  Result.FetchingDocumentKindsInfoLocalViewDefs :=
    FetchingDocumentKindsInfoLocalViewDefs;

  Result.FetchingDocumentKindUnionStatisticsQueries :=
    FetchingDocumentKindStatisticsQueries;

end;

function TEmployeeDocumentWorkStatisticsPostgresService.
  MapEmployeeDocumentKindWorkStatisticsFetchingToSQLStringList(

    EmployeeDocumentKindWorkStatisticsFetching:
      TEmployeeDocumentKindWorkStatisticsFetching

  ): TEmployeeDocumentKindWorkStatisticsFetchingQueryData;


  function MapDocumentStageNumberListToCommaString(
    DocumentStageNumberList: TVariantList
  ): String;
  var DocumentStageNumber: Integer;
  begin

    Result := '';

    for DocumentStageNumber in DocumentStageNumberList do begin

        if Result = '' then
          Result := IntToStr(DocumentStageNumber)

        else Result := Result + ',' + IntToStr(DocumentStageNumber);

    end;

  end;

begin

  Result := TEmployeeDocumentKindWorkStatisticsFetchingQueryData.Create;

  Result.OwnActionDocumentStageNumbersStringList :=
    MapDocumentStageNumberListToCommaString(
      EmployeeDocumentKindWorkStatisticsFetching.OwnActionDocumentStageNumbers
    );

  Result.InWorkingDocumentStageNumbersStringList :=
    MapDocumentStageNumberListToCommaString(
      EmployeeDocumentKindWorkStatisticsFetching.InWorkingDocumentStageNumbers
    );

end;

function TEmployeeDocumentWorkStatisticsPostgresService.
  MapEmployeeDocumentWorkStatisticsListFromStatisticsFetchingQueryResult(

    ResultSet: TDataSet;

    OutcommingDocumentKinds: array of TOutcomingDocumentKindClass;
    ApproveableDocumentKinds: array of TApproveableDocumentKindClass;
    IncommingDocumentKinds: array of TIncomingDocumentKindClass

  ): TEmployeeDocumentWorkStatisticsList;

var FetchedDocumentKinds: TVariantList;
    OutcommingDocumentKind: TOutcomingDocumentKindClass;
    ApproveableDocumentKind: TApproveableDocumentKindClass;
    IncommingDocumentKind: TIncomingDocumentKindClass;
begin

  Result := TEmployeeDocumentWorkStatisticsList.Create;

  ResultSet.First;

  FetchedDocumentKinds := TVariantList.Create;

  try

    while not ResultSet.Eof do begin

      Result.AddEmployeeDocumentKindWorkStatistics(
        ResultSet.FieldByName('type_id').AsVariant,
        ResultSet.FieldByName('own_action_count').AsInteger,
        ResultSet.FieldByName('in_working_count').AsInteger
      );

      FetchedDocumentKinds.Add(ResultSet.FieldByName('type_id').AsVariant);
      
      ResultSet.Next;

    end;
    
    for OutcommingDocumentKind in OutcommingDocumentKinds do begin

      if not FetchedDocumentKinds.Contains(
                FDocumentKindResolver.ResolveIdForDocumentKind(
                  OutcommingDocumentKind
                )
             )
      then begin
      
        Result.AddEmployeeDocumentKindWorkStatistics(
          FDocumentKindResolver.ResolveIdForDocumentKind(
            OutcommingDocumentKind
          ),
          0,
          0
        );

      end;

    end;

    for ApproveableDocumentKind in ApproveableDocumentKinds do begin

      if not FetchedDocumentKinds.Contains(
                FDocumentKindResolver.ResolveIdForDocumentKind(
                  ApproveableDocumentKind
                )
             )
      then begin

        Result.AddEmployeeDocumentKindWorkStatistics(
          FDocumentKindResolver.ResolveIdForDocumentKind(
            ApproveableDocumentKind
          ),
          0,
          0
        );

      end;

    end;

    for IncommingDocumentKind in IncommingDocumentKinds do begin

      if not FetchedDocumentKinds.Contains(
                FDocumentKindResolver.ResolveIdForDocumentKind(
                  IncommingDocumentKind
                )
             )
      then begin
      
        Result.AddEmployeeDocumentKindWorkStatistics(
          FDocumentKindResolver.ResolveIdForDocumentKind(
            IncommingDocumentKind
          ),
          0,
          0
        );

      end;

    end;
    
  finally

    FreeAndNil(FetchedDocumentKinds);
    
  end;

end;

procedure TEmployeeDocumentWorkStatisticsPostgresService.
OnDocumentWorkStatisticsFetchingQueryFailedEventHandler(
  Sender: Tobject;
  DataSet: TDataSet;
  const Error: Exception;
  RelatedState: TObject
);
var EventHandlers: TDocumentWorkStatisticsAsyncFetchingEventHandlers;
begin

  try

    EventHandlers :=
      RelatedState as
      TDocumentWorkStatisticsAsyncFetchingEventHandlers;

    EventHandlers.OnDocumentWorkStatisticsFetchingErrorEventHandler(
      Self, Error
    );

  finally

    FreeAndNil(RelatedState);
    FreeAndNil(DataSet);
    
  end;

end;

procedure TEmployeeDocumentWorkStatisticsPostgresService.
  OnDocumentWorkStatisticsFetchingQuerySuccessEventHandler(
    Sender: TObject;
    DataSet: TDataSet;
    RelatedState: TObject
  );
var EventHandlers: TDocumentWorkStatisticsAsyncFetchingEventHandlers;
begin

  try

    EventHandlers :=
      RelatedState as TDocumentWorkStatisticsAsyncFetchingEventHandlers;

    EventHandlers.OnDocumentWorkStatisticsFetchedEventHandler(
      Self,
      MapEmployeeDocumentWorkStatisticsListFromStatisticsFetchingQueryResult(
        DataSet,
        EventHandlers.OutcommingDocumentKinds,
        EventHandlers.ApproveableDocumentKinds,
        EventHandlers.IncommingDocumentKinds
      )
    );
    
  finally

    FreeAndNil(RelatedState);
    FreeAndNil(DataSet);
    
  end;
  
end;

function TEmployeeDocumentWorkStatisticsPostgresService.
  InternalGetDocumentKindsWorkStatisticsForEmployee(

    OutcommingDocumentKinds: array of TOutcomingDocumentKindClass;
    ApproveableDocumentKinds: array of TApproveableDocumentKindClass;
    IncommingDocumentKinds: array of TIncomingDocumentKindClass;
    
    const EmployeeId: Variant

  ): TEmployeeDocumentWorkStatisticsList;

var FetchingStatisticsQuery: String;
begin

  FetchingStatisticsQuery :=
    GetDocumentKindsWorkStatisticsForEmployeeQueryText(
      OutcommingDocumentKinds,
      ApproveableDocumentKinds,
      IncommingDocumentKinds,
      EmployeeId
    );

  ExecuteQuery(FZQuery, FetchingStatisticsQuery, [], []);
  
  Result :=
    MapEmployeeDocumentWorkStatisticsListFromStatisticsFetchingQueryResult(
      FZQuery,
      OutcommingDocumentKinds,
      ApproveableDocumentKinds,
      IncommingDocumentKinds
    );
    
end;

procedure TEmployeeDocumentWorkStatisticsPostgresService.
  InternalGetDocumentKindsWorkStatisticsForEmployeeAsync(

    OutcommingDocumentKinds: array of TOutcomingDocumentKindClass;
    ApproveableDocumentKinds: array of TApproveableDocumentKindClass;
    IncommingDocumentKinds: array of TIncomingDocumentKindClass;
    
    const EmployeeId: Variant;

    OnDocumentWorkStatisticsFetchedEventHandler:
      TOnDocumentWorkStatisticsFetchedEventHandler;

    OnDocumentWorkStatisticsFetchingErrorEventHandler:
        TOnDocumentWorkStatisticsFetchingErrorEventHandler
  );
var FetchingStatisticsQuery: String;
    BackgroundQueryObject: TZQuery;
begin

  FetchingStatisticsQuery :=
    GetDocumentKindsWorkStatisticsForEmployeeQueryText(
      OutcommingDocumentKinds,
      ApproveableDocumentKinds,
      IncommingDocumentKinds,
      EmployeeId
    );

  BackgroundQueryObject :=
    CloneQueryObjectFrom(FZQuery, CloneConnectionToo);
  
  ExecuteQueryAsync(
    BackgroundQueryObject,
    FetchingStatisticsQuery,
    [],
    [],
    True,
    OnDocumentWorkStatisticsFetchingQuerySuccessEventHandler,
    OnDocumentWorkStatisticsFetchingQueryFailedEventHandler,

    TDocumentWorkStatisticsAsyncFetchingEventHandlers.Create(
      OutcommingDocumentKinds,
      ApproveableDocumentKinds,
      IncommingDocumentKinds,
      OnDocumentWorkStatisticsFetchedEventHandler,
      OnDocumentWorkStatisticsFetchingErrorEventHandler
    )
  );

end;

function TEmployeeDocumentWorkStatisticsPostgresService.
  InternalGetDocumentWorkStatisticsForEmployee(
    const EmployeeId: Variant
  ): TEmployeeDocumentWorkStatisticsList;
begin

  Result := inherited InternalGetDocumentWorkStatisticsForEmployee(
                        EmployeeId
                      );

end;

{ refactor: внедрять предметную службу,
  представляющую справочник по видам док-ов
  с информацией о стадиях рабочего цикла и т.д.
  для каждого вида документов }
function TEmployeeDocumentWorkStatisticsPostgresService.
  MapEmployeeDocumentKindWorkStatisticsFetchingFrom(
  
    EmployeeRole: TRole;
    const DocumentKind: TDocumentKindClass

  ): TEmployeeDocumentKindWorkStatisticsFetching;
begin

  if DocumentKind.InheritsFrom(TIncomingDocumentKind) then begin

      Result := TEmployeeDocumentKindWorkStatisticsFetching.Create;

      Result.AddOwnActionDocumentStageNumber(1);
      Result.AddInWorkingDocumentStageNumber(1);

  end

  else if DocumentKind.InheritsFrom(TOutcomingDocumentKind) then begin

    Result := TEmployeeDocumentKindWorkStatisticsFetching.Create;

    if EmployeeRole.IsSecretary or EmployeeRole.IsEmployee then begin

        Result.AddOwnActionDocumentStageNumber(1);
        Result.AddOwnActionDocumentStageNumber(2);
        Result.AddOwnActionDocumentStageNumber(6);
        Result.AddInWorkingDocumentStageNumber(8);
        Result.AddInWorkingDocumentStageNumber(5);

    end

    else if
        EmployeeRole.IsLeader or
        EmployeeRole.IsSecretarySigner or
        EmployeeRole.IsSubLeader
    then begin

        Result.AddOwnActionDocumentStageNumber(1);
        Result.AddOwnActionDocumentStageNumber(2);
        Result.AddOwnActionDocumentStageNumber(5);
        Result.AddInWorkingDocumentStageNumber(8);
        
    end;

  end;
  
end;

{ TEmployeeDocumentKindWorkStatisticsFetching }

procedure TEmployeeDocumentKindWorkStatisticsFetching.AddInWorkingDocumentStageNumber(
  const StageNumber: Integer);
begin

  InWorkingDocumentStageNumbers.Add(StageNumber);
  
end;

procedure TEmployeeDocumentKindWorkStatisticsFetching.AddOwnActionDocumentStageNumber(
  const StageNumber: Integer);
begin

  OwnActionDocumentStageNumbers.Add(StageNumber);
  
end;

constructor TEmployeeDocumentKindWorkStatisticsFetching.Create;
begin

  inherited;

  OwnActionDocumentStageNumbers := TVariantList.Create;
  InWorkingDocumentStageNumbers := TVariantList.Create;

end;

destructor TEmployeeDocumentKindWorkStatisticsFetching.Destroy;
begin

  FreeAndNil(OwnActionDocumentStageNumbers);
  FreeAndNil(InWorkingDocumentStageNumbers);
  inherited;

end;

{ TDocumentWorkStatisticsAsyncFetchingEventHandlers }

constructor TDocumentWorkStatisticsAsyncFetchingEventHandlers.Create(

  OutcommingDocumentKinds: array of TOutcomingDocumentKindClass;
  ApproveableDocumentKinds: array of TApproveableDocumentKindClass;
  IncommingDocumentKinds: array of TIncomingDocumentKindClass;

  OnDocumentWorkStatisticsFetchedEventHandler: TOnDocumentWorkStatisticsFetchedEventHandler;
  OnDocumentWorkStatisticsFetchingErrorEventHandler: TOnDocumentWorkStatisticsFetchingErrorEventHandler
);
var I: Integer;
begin

  inherited Create;

  SetLength(Self.OutcommingDocumentKinds, Length(OutcommingDocumentKinds));

  for I := Low(OutcommingDocumentKinds) to High(OutcommingDocumentKinds) do
    Self.OutcommingDocumentKinds[I] := OutcommingDocumentKinds[I];

  SetLength(Self.IncommingDocumentKinds, Length(IncommingDocumentKinds));

  for I := Low(IncommingDocumentKinds) to High(IncommingDocumentKinds) do
    Self.IncommingDocumentKinds[I] := IncommingDocumentKinds[I];

  SetLength(Self.ApproveableDocumentKinds, Length(ApproveableDocumentKinds));

  for I := Low(ApproveableDocumentKinds) to High(ApproveableDocumentKinds)
  do Self.ApproveableDocumentKinds[I] := ApproveableDocumentKinds[I];
    
  Self.OnDocumentWorkStatisticsFetchedEventHandler :=
    OnDocumentWorkStatisticsFetchedEventHandler;

  Self.OnDocumentWorkStatisticsFetchingErrorEventHandler :=
    OnDocumentWorkStatisticsFetchingErrorEventHandler;
    
end;

end.
