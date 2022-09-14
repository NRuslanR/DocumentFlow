unit PostgresIncomingServiceNoteFullInfoFetchingQueryBuilder;

interface

uses

  PostgresIncomingDocumentFullInfoFetchingQueryBuilder,
  DocumentFullInfoDataSetHolder,
  SysUtils,
  Classes;

type

  TPostgresIncomingServiceNoteFullInfoFetchingQueryBuilder =
    class (TPostgresIncomingDocumentFullInfoFetchingQueryBuilder)

      protected

        function GetDocumentFullInfoTableExpression(
          DocumentFullInfoDataSetFieldNames: TDocumentFullInfoDataSetFieldNames;
          const DocumentIdParamName: String
        ): String; override;

        function GetDocumentSignerInfoFieldNameListExpression(
          DocumentFullInfoDataSetFieldNames: TDocumentFullInfoDataSetFieldNames
        ): String; override;
      
    end;

implementation

{ TPostgresIncomingServiceNoteFullInfoFetchingQueryBuilder }

function TPostgresIncomingServiceNoteFullInfoFetchingQueryBuilder.
  GetDocumentFullInfoTableExpression(
    DocumentFullInfoDataSetFieldNames: TDocumentFullInfoDataSetFieldNames;
    const DocumentIdParamName: String
  ): String;
begin

  Result :=
    inherited GetDocumentFullInfoTableExpression(
      DocumentFullInfoDataSetFieldNames, DocumentIdParamName
    ) + #13#10 +
    'left join doc.departments subst_signer_dep on subst_signer_dep.code = ' + #13#10 +
    'left(doc.document_number, length(doc.document_number) - position(''/'' in reverse(doc.document_number))) and subst_signer_dep.prizn_old is null  ' + #13#10 + 
    'left join doc.employees subst_signer on subst_signer.id =  ' + #13#10 + 
    '(select e1.id  from doc.employees e1 join doc.employees_roles er1 on er1.employee_id=e1.id where er1.role_id=2 and department_id=subst_signer_dep.id)';

end;

function TPostgresIncomingServiceNoteFullInfoFetchingQueryBuilder.
  GetDocumentSignerInfoFieldNameListExpression(
    DocumentFullInfoDataSetFieldNames: TDocumentFullInfoDataSetFieldNames
  ): String;
begin

  with DocumentFullInfoDataSetFieldNames do begin
  
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
      'end as ' + DocumentSignerIdFieldName + ',  ' + #13#10 +
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
      'end as ' + DocumentSignerNameFieldName + ', ' + #13#10 +
      'case  ' + #13#10 +
          'when doc.is_self_registered  ' + #13#10 +
          'then' + #13#10 +
              'case  ' + #13#10 +
                  'when subst_signer.id is not null ' + #13#10 +
                  'then subst_signer.speciality  ' + #13#10 +
                  'else signer.speciality  ' + #13#10 +
              'end ' + #13#10 +
          'else signer.speciality  ' + #13#10 +
      'end as ' + DocumentSignerSpecialityFieldName + ', ' + #13#10 +
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
      'end as ' + DocumentSignerDepartmentIdFieldName + ',' + #13#10 +
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
      'end as ' + DocumentSignerDepartmentCodeFieldName + ',  ' + #13#10 +
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
      'end as ' + DocumentSignerDepartmentNameFieldName;

  end;

end;

end.
