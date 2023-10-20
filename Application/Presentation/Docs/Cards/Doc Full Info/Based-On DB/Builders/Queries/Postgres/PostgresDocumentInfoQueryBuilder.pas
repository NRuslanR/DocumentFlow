unit PostgresDocumentInfoQueryBuilder;

interface

uses

  DocumentInfoQueryBuilder,
  DocumentInfoHolder,
  DocumentTableDef,
  SysUtils;

type

  TPostgresDocumentInfoQueryBuilder = class (TDocumentInfoQueryBuilder)

      function GetMainDocumentTableExpression: String; override;
      function GetDocumentFieldNameListExpression(FieldNames: TDocumentInfoFieldNames): String; override;
      function GetDocumentSignerFieldNameListExpression(FieldNames: TDocumentInfoFieldNames): String; override;
      function GetCurrentEmployeeJoinExpression: String; override;
      function GetDocumentTableFilterExpression(DocumentIdParamName: String): String; override;
      function GetRestDocumentTableJoinExpression: String; override;

  end;

implementation

uses

  StrUtils;

{ TPostgresDocumentInfoQueryBuilder }

function TPostgresDocumentInfoQueryBuilder.GetCurrentEmployeeJoinExpression: String;
begin

  Result := 'join doc.get_current_employee_id() cur_emp(id) on true'

end;

function TPostgresDocumentInfoQueryBuilder.GetDocumentFieldNameListExpression(
  FieldNames: TDocumentInfoFieldNames): String;
begin

  with FieldNames do begin

    Result :=
      '	doc.id as ' + IdFieldName + ',' + #13#10 +
      '	doc.id as ' + BaseIdFieldName + ',' + #13#10 +
      '	doc.type_id as ' + KindIdFieldName + ',' + #13#10 +
      '	doc.document_number as ' + NumberFieldName + ',' + #13#10 +
      '	doc.name as ' + NameFieldName + ',' + #13#10 +
      '	doc.full_name as ' + FullNameFieldName + ',' + #13#10 +
      '	doc.content as ' + ContentFieldName + ',' + #13#10 +
      '	doc.note as ' + NoteFieldName + ',' + #13#10 +
      IfThen(
        Options.FetchSelfDocumentRegistrationData,
        'doc.is_self_registered as ' + IsSelfRegisteredFieldName + ',',
        ''
       ) + #13#10 +
      '	doc.product_code as ' + ProductCodeFieldName + ',' + #13#10 +
      '	doc.creation_date as ' + CreationDateFieldName + ',' + #13#10 + 
      '	doc.document_date as ' + DateFieldName + ',' + #13#10 + 
      '	dt.short_full_name as ' + KindFieldName + ',' + #13#10 +
      '	dtwcs.stage_name as ' + CurrentWorkCycleStageNameFieldName + ',' + #13#10 +
      '	dtwcs.stage_number as ' + CurrentWorkCycleStageNumberFieldName + ',' + #13#10 +
      '	e.id as ' + AuthorIdFieldName + ',' + #13#10 +
      '	e.leader_id as ' + AuthorLeaderIdFieldName + ',' + #13#10 + 
      '	(e.surname || '' '' || e.name || '' '' || e.patronymic) as ' + AuthorNameFieldName + ',' + #13#10 +
      '	e.speciality as ' + AuthorSpecialityFieldName + ',' + #13#10 + 
      '	d.id as ' + AuthorDepartmentIdFieldName + ',' + #13#10 + 
      '	d.code as ' + AuthorDepartmentCodeFieldName  + ',' + #13#10 + 
      '	d.short_name as ' + AuthorDepartmentNameFieldName + ',' + #13#10 +
      '	sp.id as ' + ResponsibleIdFieldName + ',' + #13#10 + 
      '	(upper(substring(sp.family, 1, 1)) || lower(substring(sp.family, 2, length(sp.family) - 1))) || '' '' ||(upper(substring(sp.name, 1, 1)) || lower(substring(sp.name, 2, length(sp.name) - 1))) || '' '' ||(upper(substring(sp.patronymic, 1, 1)) || lower(sub' + 'string(sp.patronymic, 2, length(sp.patronymic) - 1)))  as ' + ResponsibleNameFieldName + ',' + #13#10 + 
      '	sptn.telephone_number as ' + ResponsibleTelephoneNumberFieldName + ',' + #13#10 +
      '	spr_podr.id as ' + ResponsibleDepartmentIdFieldName + ',' + #13#10 +
      '	spr_podr.podr_code as ' + ResponsibleDepartmentCodeFieldName + ',' + #13#10 +
      '	spr_podr.podr_short_name as ' + ResponsibleDepartmentNameFieldName + ',' + #13#10 +
      '	doc_signings.id as ' + SigningIdFieldName + ',' + #13#10 +
      '	doc_signings.signing_date as ' + SigningDateFieldName + ',' + #13#10 + 
      GetDocumentSignerFieldNameListExpression(FieldNames) + ',' +
      ' fact_signer.id as ' + ActualSignerIdFieldName + ',' + #13#10 +
      '	fact_signer.leader_id as ' + ActualSignerLeaderIdFieldName + ',' + #13#10 +
      '	(fact_signer.surname || '' '' || fact_signer.name || '' '' || fact_signer.patronymic) as ' + ActualSignerNameFieldName + ',' + #13#10 +
      '	fact_signer.speciality as ' + ActualSignerSpecialityFieldName + ',' + #13#10 +
      '	fact_signer_dep.id as ' + ActualSignerDepartmentIdFieldName + ',' + #13#10 +
      '	fact_signer_dep.code as ' + ActualSignerDepartmentCodeFieldName + ',' + #13#10 +
      '	fact_signer_dep.short_name as ' + ActualSignerDepartmentNameFieldName;

  end;

end;

function TPostgresDocumentInfoQueryBuilder.GetDocumentSignerFieldNameListExpression(
  FieldNames: TDocumentInfoFieldNames): String;
begin

  with FieldNames do begin

    Result :=
        '	signer.id as ' + SignerIdFieldName + ',' + #13#10 +
        '	signer.leader_id as ' + SignerLeaderIdFieldName + ',' + #13#10 +
        '	(signer.surname || '' '' || signer.name || '' '' || signer.patronymic) as ' + SignerNameFieldName + ',' + #13#10 +
        '	signer.speciality as ' + SignerSpecialityFieldName + ',' + #13#10 +
        '	signer_dep.id as ' + SignerDepartmentIdFieldName + ',' + #13#10 +
        '	signer_dep.code as ' + SignerDepartmentCodeFieldName + ',' + #13#10 +
        '	signer_dep.short_name as ' + SignerDepartmentNameFieldName;

  end;

end;

function TPostgresDocumentInfoQueryBuilder.GetDocumentTableFilterExpression(
  DocumentIdParamName: String): String;
begin

  Result := 'doc.id=:' + DocumentIdParamName

end;

function TPostgresDocumentInfoQueryBuilder.GetMainDocumentTableExpression: String;
begin

  Result := FDocumentTableDef.TableName + ' doc';

end;

function TPostgresDocumentInfoQueryBuilder.GetRestDocumentTableJoinExpression: String;
begin

  Result :=
      'join doc.document_types dt on dt.id = doc.type_id' + #13#10 +
      'join doc.document_type_work_cycle_stages dtwcs on dtwcs.id = doc.current_work_cycle_stage_id' + #13#10 +
      'left join doc.employees e on e.id = doc.author_id' + #13#10 +
      'left join doc.departments d on d.id = e.department_id' + #13#10 +
      'left join exchange.spr_person sp on sp.id = doc.performer_id' + #13#10 +
      'left join nsi.spr_podr spr_podr on spr_podr.id = sp.podr_id' + #13#10 +
      'left join exchange.spr_person_telephone_numbers sptn on sptn.person_id = sp.id' + #13#10 +
      'left join ' + FSigningTableDef.TableName + ' doc_signings on doc_signings.document_id = doc.id' + #13#10 +
      'left join doc.employees signer on signer.id = doc_signings.signer_id' + #13#10 +
      'left join doc.departments signer_dep on signer_dep.id = signer.department_id' + #13#10 +
      'left join doc.employees fact_signer on fact_signer.id = doc_signings.actual_signed_id' + #13#10 +
      'left join doc.departments fact_signer_dep on fact_signer_dep.id = fact_signer.department_id';

end;

end.
