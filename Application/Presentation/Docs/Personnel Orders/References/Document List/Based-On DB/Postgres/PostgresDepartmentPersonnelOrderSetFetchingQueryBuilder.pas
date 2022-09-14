unit PostgresDepartmentPersonnelOrderSetFetchingQueryBuilder;

interface

uses

  BasedOnDatabaseAbstractDepartmentDocumentSetReadService,
  VariantListUnit,
  SysUtils;

type

  TPostgresDepartmentPersonnelOrderSetFetchingQueryBuilder =
    class (TDepartmentDocumentSetFetchingQueryBuilder)

      public

        function BuildDepartmentDocumentSetFetchingQuery(
          const DepartmentIds: TVariantList
        ): String; override;

        function BuildDepartmentDocumentSetByIdsFetchingQuery(
          const DocumentIds: TVariantList
        ): String; override;

    end;

implementation

uses

  StrUtils,
  SelectDocumentRecordsViewQueries,
  AuxiliaryStringFunctions;
  
{ TPostgresDepartmentPersonnelOrderSetFetchingQueryBuilder }

function TPostgresDepartmentPersonnelOrderSetFetchingQueryBuilder.BuildDepartmentDocumentSetByIdsFetchingQuery(
  const DocumentIds: TVariantList): String;
begin

  Result :=
    ReplaceStr(
      SELECT_DEPARTMENT_PERSONNEL_ORDERS_BY_IDS_QUERY,
      DOCUMENT_IDS_PARAM_NAME,
      IfThen(
        not DocumentIds.IsEmpty,
        'ARRAY[' + CreateStringFromVariantList(DocumentIds) + ']',
        'NULL'
      )
    );
    
end;

function TPostgresDepartmentPersonnelOrderSetFetchingQueryBuilder.BuildDepartmentDocumentSetFetchingQuery(
  const DepartmentIds: TVariantList): String;
begin

  Result :=
    ReplaceStr(
      SELECT_PERSONNEL_ORDERS_FROM_DEPARTMENTS_QUERY,
      DEPARTMENT_IDS_PARAM_NAME,
      IfThen(
        not DepartmentIds.IsEmpty,
        'ARRAY[' + CreateStringFromVariantList(DepartmentIds) + ']',
        'NULL'
      )
    );
    
end;

end.
