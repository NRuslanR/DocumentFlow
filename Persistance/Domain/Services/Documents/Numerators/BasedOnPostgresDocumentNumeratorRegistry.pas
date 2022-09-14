unit BasedOnPostgresDocumentNumeratorRegistry;

interface

uses

  BasedOnDatabaseDocumentNumeratorRegistry,
  SysUtils;

type

  TBasedOnPostgresDocumentNumeratorRegistry =
    class (TBasedOnDatabaseDocumentNumeratorRegistry)

      protected

        function GetDepartmentIdExpressionPattern: String; override;
        function GetDepartmentIdExpression(const InnerDepartmentId: Variant): String; override;

    end;

  
implementation

uses

  Variants;
  
{ TBasedOnPostgresDocumentNumeratorRegistry }

function TBasedOnPostgresDocumentNumeratorRegistry.
  GetDepartmentIdExpression(
    const InnerDepartmentId: Variant
  ): String;
begin

  Result := VarToStr(InnerDepartmentId);

end;

function TBasedOnPostgresDocumentNumeratorRegistry.
  GetDepartmentIdExpressionPattern: String;
begin

  Result := ':p' + DocumentNumeratorTableData.DepartmentIdColumnName;
  
end;

end.
