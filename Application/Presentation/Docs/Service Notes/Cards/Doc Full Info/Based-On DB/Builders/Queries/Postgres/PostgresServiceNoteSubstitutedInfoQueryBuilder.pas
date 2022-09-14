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
    'left(doc.document_number, length(doc.document_number) - position(''/'' in reverse(doc.document_number))) and subst_signer_dep.prizn_old is null  ' + #13#10 +
    'left join doc.employees subst_signer on subst_signer.id =  ' + #13#10 +
    '(select e1.id  from doc.employees e1 join doc.employees_roles er1 on er1.employee_id=e1.id where er1.role_id=2 and department_id=subst_signer_dep.id)';

end;


end.
