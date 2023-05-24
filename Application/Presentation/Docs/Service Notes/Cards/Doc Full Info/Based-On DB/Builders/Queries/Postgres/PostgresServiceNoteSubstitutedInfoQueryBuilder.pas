unit PostgresServiceNoteSubstitutedInfoQueryBuilder;

interface

uses

  DocumentInfoHolder,
  PostgresDocumentInfoQueryBuilder,
  SysUtils;

type

  TPostgresServiceNoteSubstitutedInfoQueryBuilder =
    class (TPostgresDocumentInfoQueryBuilder)

      public

        function GetDocumentSignerFieldNameListExpression(FieldNames: TDocumentInfoFieldNames): String; override;
        function GetRestDocumentTableJoinExpression: String; override;

    end;

implementation

{ TPostgresServiceNoteSubstitutedInfoQueryBuilder }

function TPostgresServiceNoteSubstitutedInfoQueryBuilder.
  GetDocumentSignerFieldNameListExpression(FieldNames: TDocumentInfoFieldNames): String;
begin

  with FieldNames do begin
  
    Result :=
      'case  ' + #13#10 +
            'when doc.is_self_registered  ' + #13#10 +
            'then  ' + #13#10 +
                'case  ' + #13#10 +
                    'when subst_signer.id is not null  ' + #13#10 +
                    'then subst_signer.id' + #13#10 +
                    'else signer.id  ' + #13#10 +
                'end  ' + #13#10 +
            'else signer.id  ' + #13#10 +
        'end as ' + SignerIdFieldName + ',  ' + #13#10 +
          '' + #13#10 +
        'case  ' + #13#10 +
            'when doc.is_self_registered  ' + #13#10 +
            'then  ' + #13#10 +
                'case' + #13#10 +
                    'when subst_signer.id is not null ' + #13#10 +
                    'then subst_signer.surname || '' '' || subst_signer.name || '' '' || subst_signer.patronymic  ' + #13#10 +
                    'else signer.surname || '' '' || signer.name || '' '' || signer.patronymic  ' + #13#10 +
                'end ' + #13#10 +
            'else signer.surname || '' '' || signer.name || '' '' || signer.patronymic  ' + #13#10 +
        'end as ' + SignerNameFieldName + ', ' + #13#10 +
        'case  ' + #13#10 +
            'when doc.is_self_registered  ' + #13#10 +
            'then' + #13#10 +
                'case  ' + #13#10 +
                    'when subst_signer.id is not null ' + #13#10 +
                    'then subst_signer.speciality  ' + #13#10 +
                    'else signer.speciality  ' + #13#10 +
                'end ' + #13#10 +
            'else signer.speciality  ' + #13#10 +
        'end as ' + SignerSpecialityFieldName + ', ' + #13#10 +
          '' + #13#10 + 
        'case' + #13#10 +
            'when doc.is_self_registered  ' + #13#10 +
            'then   ' + #13#10 +
                'case  ' + #13#10 +
                    'when subst_signer.id is not null  ' + #13#10 +
                    'then subst_signer_dep.id  ' + #13#10 +
                    'else signer_dep.id  ' + #13#10 +
                'end  ' + #13#10 +
            'else signer_dep.id  ' + #13#10 +
        'end as ' + SignerDepartmentIdFieldName + ',' + #13#10 +
          '' + #13#10 +
        'case  ' + #13#10 +
            'when doc.is_self_registered   ' + #13#10 +
            'then   ' + #13#10 +
                'case   ' + #13#10 +
                    'when subst_signer.id is not null  ' + #13#10 +
                    'then subst_signer_dep.code  ' + #13#10 +
                    'else signer_dep.code  ' + #13#10 +
                'end' + #13#10 +
            'else signer_dep.code  ' + #13#10 +
        'end as ' + SignerDepartmentCodeFieldName + ',  ' + #13#10 +
          '' + #13#10 +
        'case  ' + #13#10 +
            'when doc.is_self_registered   ' + #13#10 +
            'then   ' + #13#10 +
                'case  ' + #13#10 +
                    'when subst_signer.id is not null  ' + #13#10 +
                    'then subst_signer_dep.short_name' + #13#10 +
                    'else signer_dep.short_name  ' + #13#10 +
                'end  ' + #13#10 +
            'else signer_dep.short_name  ' + #13#10 +
        'end as ' + SignerDepartmentNameFieldName;

  end;

end;

function TPostgresServiceNoteSubstitutedInfoQueryBuilder.GetRestDocumentTableJoinExpression: String;
begin

  Result :=
    inherited GetRestDocumentTableJoinExpression + #13#10 +
    'left join doc.departments subst_signer_dep on subst_signer_dep.code = ' + #13#10 +
    'left(doc.document_number, position(''/'' in doc.document_number) - 1) and subst_signer_dep.prizn_old is null' + #13#10 +
    //'left(doc.document_number, length(doc.document_number) - position(''/'' in (doc.document_number))) and subst_signer_dep.prizn_old is null  ' + #13#10 +
    'left join doc.employees subst_signer on subst_signer.id =  ' + #13#10 +
    '(' + #13#10 +
        'select' + #13#10 +
        'id' + #13#10 +
        'from (' + #13#10 +
          'select' + #13#10 +
          'e.id,' + #13#10 +
          'e.changing_date as reg_date,' + #13#10 +
          'min (e.changing_date) over () as min_reg_date,' + #13#10 +
          'doc.creation_date - e.changing_date as delta_date,' + #13#10 +
          'min (case when doc.creation_date >= e.changing_date then doc.creation_date - e.changing_date else null end) over () as min_delta_date' + #13#10 +
          'from doc.employees e' + #13#10 +
          'join doc.employees_roles er on er.employee_id = e.id' + #13#10 +
          'where e.department_id = subst_signer_dep.id and er.role_id = 2' + #13#10 +
        ') q' + #13#10 +
        'where ' + #13#10 +
            'case' + #13#10 +
                'when q.min_delta_date is not null' + #13#10 + 
                    'then q.delta_date = q.min_delta_date' + #13#10 + 
                    'else q.reg_date = q.min_reg_date' + #13#10 + 
            'end' + #13#10 +
    ')';

end;


end.
