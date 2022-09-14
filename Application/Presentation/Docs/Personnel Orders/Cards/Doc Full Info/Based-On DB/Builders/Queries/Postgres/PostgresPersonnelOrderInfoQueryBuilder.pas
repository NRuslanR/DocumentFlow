unit PostgresPersonnelOrderInfoQueryBuilder;

interface

uses

  PostgresDocumentInfoQueryBuilder,
  DocumentInfoHolder,
  PersonnelOrderInfoHolder,
  SysUtils;

type

  TPostgresPersonnelOrderInfoQueryBuilder = class (TPostgresDocumentInfoQueryBuilder)

    public

      function GetDocumentFieldNameListExpression(FieldNames: TDocumentInfoFieldNames): String; override;
      function GetRestDocumentTableJoinExpression: String; override;

  end;
  
implementation

{ TPostgresPersonnelOrderInfoQueryBuilder }

function TPostgresPersonnelOrderInfoQueryBuilder.GetDocumentFieldNameListExpression(
  FieldNames: TDocumentInfoFieldNames
): String;
begin

  with TPersonnelOrdeInfoFieldNames(FieldNames) do begin

    Result :=
      inherited GetDocumentFieldNameListExpression(FieldNames) +
      ',' +
      'doc.sub_type_id as ' + SubKindIdFieldName + ',' +
      'posk.name as ' + SubKindNameFieldName;

  end;

end;

function TPostgresPersonnelOrderInfoQueryBuilder.GetRestDocumentTableJoinExpression: String;
begin

  Result :=
    inherited GetRestDocumentTableJoinExpression + #13#10 +
    'join doc.personnel_order_sub_kinds posk on posk.id = doc.sub_type_id';

end;

end.
