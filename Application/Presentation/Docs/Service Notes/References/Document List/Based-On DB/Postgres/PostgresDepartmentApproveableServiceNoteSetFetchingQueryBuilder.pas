unit PostgresDepartmentApproveableServiceNoteSetFetchingQueryBuilder;

interface

uses

  BasedOnDatabaseAbstractDepartmentDocumentSetReadService,
  VariantListUnit,
  SysUtils;

type

  TPostgresDepartmentApproveableServiceNoteSetFetchingQueryBuilder =
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
  
{ TPostgresDepartmentApproveableServiceNoteSetFetchingQueryBuilder }

function TPostgresDepartmentApproveableServiceNoteSetFetchingQueryBuilder.
BuildDepartmentDocumentSetByIdsFetchingQuery(
  const DocumentIds: TVariantList): String;
begin

  Result :=
    ReplaceStr(
      SELECT_DEPARTMENT_APPROVEABLE_SERVICE_NOTES_BY_IDS_QUERY,
      DOCUMENT_IDS_PARAM_NAME,
      IfThen(
        not DocumentIds.IsEmpty,
        'ARRAY[' + CreateStringFromVariantList(DocumentIds) + ']',
        'NULL'
      )
    );

end;

function TPostgresDepartmentApproveableServiceNoteSetFetchingQueryBuilder
  .BuildDepartmentDocumentSetFetchingQuery(
    const DepartmentIds: TVariantList
  ): String;
begin

  Result :=
    ReplaceStr(
      SELECT_ALL_APPROVEABLE_SERVICE_NOTES_FROM_DEPARTMENTS_QUERY,
      DEPARTMENT_IDS_PARAM_NAME,
      IfThen(
        not DepartmentIds.IsEmpty,
        'ARRAY[' + CreateStringFromVariantList(DepartmentIds) + ']',
        'NULL'
      )
    );

end;

end.
