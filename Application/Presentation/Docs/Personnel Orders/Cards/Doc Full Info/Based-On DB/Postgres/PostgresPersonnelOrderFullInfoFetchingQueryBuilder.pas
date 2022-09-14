unit PostgresPersonnelOrderFullInfoFetchingQueryBuilder;

interface

uses

  PostgresDocumentFullInfoFetchingQueryBuilder,
  PersonnelOrderInfoHolder,
  PersonnelOrderTableDefsFactory,
  DocumentFullInfoDataSetHolder,
  SysUtils;

type

  TPostgresPersonnelOrderFullInfoFetchingQueryBuilder =
    class (TPostgresDocumentInfoFetchingQueryBuilder)

      protected

        function GetDocumentFullInfoFieldNameListExpression(
          DocumentFullInfoDataSetFieldNames: TDocumentFullInfoDataSetFieldNames
        ): String; override;

        function GetDocumentFullInfoTableExpression(
          DocumentFullInfoDataSetFieldNames: TDocumentFullInfoDataSetFieldNames;
          const DocumentIdParamName: String
        ): String; override;
      
      public

        constructor Create(PersonnelOrderTableDefsFactory: TPersonnelOrderTableDefsFactory);
        
    end;
  
implementation

{ TPostgresPersonnelOrderFullInfoFetchingQueryBuilder }

constructor TPostgresPersonnelOrderFullInfoFetchingQueryBuilder.Create(
  PersonnelOrderTableDefsFactory: TPersonnelOrderTableDefsFactory);
begin

  inherited Create(PersonnelOrderTableDefsFactory);
  
end;

function TPostgresPersonnelOrderFullInfoFetchingQueryBuilder.
  GetDocumentFullInfoFieldNameListExpression(
    DocumentFullInfoDataSetFieldNames: TDocumentFullInfoDataSetFieldNames
  ): String;
begin

  with
    DocumentFullInfoDataSetFieldNames.DocumentInfoFieldNames
    as
    TPersonnelOrdeInfoFieldNames
  do begin

    Result :=
      inherited GetDocumentFullInfoFieldNameListExpression(DocumentFullInfoDataSetFieldNames) +
      ',' +
      'doc.sub_type_id as ' + SubKindIdFieldName + ',' +
      'posk.name as ' + SubKindNameFieldName;

  end;
  
end;

function TPostgresPersonnelOrderFullInfoFetchingQueryBuilder.GetDocumentFullInfoTableExpression(
  DocumentFullInfoDataSetFieldNames: TDocumentFullInfoDataSetFieldNames;
  const DocumentIdParamName: String
): String;
begin

  Result :=
    inherited GetDocumentFullInfoTableExpression(
      DocumentFullInfoDataSetFieldNames, DocumentIdParamName
    ) +
    ' join doc.personnel_order_sub_kinds posk on posk.id = doc.sub_type_id';
    
end;

end.
