unit PostgresDocumentCreatingDefaultInfoFetchingQueryBuilder;

interface

uses

  DocumentCreatingDefaultInfoDataSetHolder,
  BasedOnDatabaseDocumentCreatingDefaultInfoReadService;

type

  TPostgresDocumentCreatingDefaultInfoFetchingQueryBuilder =
    class (TDocumentCreatingDefaultInfoFetchingQueryBuilder)
    
      public

        function BuildDocumentCreatingDefaultInfoWithSignerInfoFetchingQuery(
          const FieldNames: TDocumentCreatingDefaultInfoDataSetFieldNames;
          const ResponsibleIdParamName: String;
          const SignerIdParamName: String
        ): String; override;

        function BuildDocumentCreatingDefaultInfoWithoutSignerInfoFetchingQuery(
          const FieldNames: TDocumentCreatingDefaultInfoDataSetFieldNames;
          const ResponsibleIdParamName: String
        ): String; override;

    end;
  
implementation

uses

  DB,
  Variants,
  AuxZeosFunctions;

{ TPostgresDocumentCreatingDefaultInfoFetchingQueryBuilder }

function TPostgresDocumentCreatingDefaultInfoFetchingQueryBuilder.
  BuildDocumentCreatingDefaultInfoWithoutSignerInfoFetchingQuery(
    const FieldNames: TDocumentCreatingDefaultInfoDataSetFieldNames;
    const ResponsibleIdParamName: String
  ): String;
begin

  with FieldNames do begin

    Result :=
      'select' + #13#10 +
      'sp.id as ' + DocumentResponsibleIdFieldName + ',' + #13#10 +
      '(upper(substring(sp.family, 1, 1)) || lower(substring(sp.family, 2, length(sp.family) - 1))) || '' '' ||' + #13#10 +
      '(upper(substring(sp.name, 1, 1)) || lower(substring(sp.name, 2, length(sp.name) - 1))) || '' '' ||' + #13#10 +
      '(upper(substring(sp.patronymic, 1, 1)) || lower(substring(sp.patronymic, 2, length(sp.patronymic) - 1))) as ' + DocumentResponsibleNameFieldName + ',' + #13#10 +
      'sptn.telephone_number as ' + DocumentResponsibleTelephoneNumberFieldName + ',' + #13#10 +
      'podr.id as ' + DocumentResponsibleDepartmentIdFieldName + ',' + #13#10 +
      'podr.podr_code as ' + DocumentResponsibleDepartmentCodeFieldName + ',' + #13#10 + 
      'podr.podr_short_name as ' + DocumentResponsibleDepartmentNameFieldName + #13#10 +
      'from doc.employees e' + #13#10 +
      'join exchange.spr_person sp on sp.id = e.spr_person_id' + #13#10 +
      'join exchange.spr_person_telephone_numbers sptn on sptn.person_id = sp.id' + #13#10 +
      'join nsi.spr_podr podr on podr.id = sp.podr_id' + #13#10 +
      'where e.id = :' + ResponsibleIdParamName;

  end;

end;

function TPostgresDocumentCreatingDefaultInfoFetchingQueryBuilder.
  BuildDocumentCreatingDefaultInfoWithSignerInfoFetchingQuery(
    const FieldNames: TDocumentCreatingDefaultInfoDataSetFieldNames;
    const ResponsibleIdParamName, SignerIdParamName: String
  ): String;
begin

  with FieldNames do begin

    Result :=
      'select' + #13#10 +
      'sp.id as ' + DocumentResponsibleIdFieldName + ',' + #13#10 +
      '(upper(substring(sp.family, 1, 1)) || lower(substring(sp.family, 2, length(sp.family) - 1))) || '' '' ||' + #13#10 +
      '(upper(substring(sp.name, 1, 1)) || lower(substring(sp.name, 2, length(sp.name) - 1))) || '' '' ||' + #13#10 +
      '(upper(substring(sp.patronymic, 1, 1)) || lower(substring(sp.patronymic, 2, length(sp.patronymic) - 1))) as ' + DocumentResponsibleNameFieldName + ',' + #13#10 +
      'sptn.telephone_number as ' + DocumentResponsibleTelephoneNumberFieldName + ',' + #13#10 +
      'podr.id as ' + DocumentResponsibleDepartmentIdFieldName + ',' + #13#10 +
      'podr.podr_code as ' + DocumentResponsibleDepartmentCodeFieldName + ',' + #13#10 +
      'podr.podr_short_name as ' + DocumentResponsibleDepartmentNameFieldName + ',' + #13#10 +
      'signer.id as ' + DocumentSignerIdFieldName + ',' + #13#10 +
      'signer.leader_id as ' + DocumentSignerLeaderIdFieldName + ',' + #13#10 +
      'er.role_id as ' + DocumentSignerRoleIdFieldName + ',' + #13#10 +
      'signer.is_foreign as ' + DocumentSignerIsForeignFieldName + ',' + #13#10 +
      '(signer.surname || '' '' || signer.name || '' '' || signer.patronymic) as ' + DocumentSignerNameFieldName + ',' + #13#10 +
      'signer.speciality as ' + DocumentSignerSpecialityFieldName + ',' + #13#10 +
      'd.id as ' + DocumentSignerDepartmentIdFieldName + ',' + #13#10 +
      'd.code as ' + DocumentSignerDepartmentCodeFieldName + ',' + #13#10 +
      'd.short_name as ' + DocumentSignerDepartmentNameFieldName + #13#10 +
      'from doc.employees e' + #13#10 +
      'join doc.employees signer on signer.id = :' + SignerIdParamName + ' ' +
      'join doc.employees_roles er on er.employee_id = signer.id' + #13#10 +
      'join doc.departments d on signer.department_id = d.id' + #13#10 +
      'join exchange.spr_person sp on sp.id = e.spr_person_id' + #13#10 +
      'left join exchange.spr_person_telephone_numbers sptn on sptn.person_id = sp.id' + #13#10 +
      'join nsi.spr_podr podr on podr.id = sp.podr_id' + #13#10 +
      'where e.id = :' + ResponsibleIdParamName;

  end;

end;

end.
