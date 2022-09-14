unit IncomingDocumentInfoQueryBuilder;

interface

uses

  DocumentInfoQueryBuilder,
  IncomingDocumentInfoHolder,
  DocumentInfoHolder,
  IncomingDocumentTableDef,
  DocumentTableDef,
  SysUtils;

type

  TIncomingDocumentInfoQueryBuilder = class (TDocumentInfoQueryBuilder)

    protected

      FDocumentInfoQueryBuilder: TDocumentInfoQueryBuilder;
      FFreeDocumentInfoQueryBuilder: IDocumentInfoQueryBuilder;
      
    protected

      FIncomingDocumentTableDef: TIncomingDocumentTableDef;
      
    public

      function GetDocumentFieldNameListExpression(FieldNames: TDocumentInfoFieldNames): String; override;
      function GetDocumentTableExpression(DocumentIdParamName: String): String; override;
      function GetMainDocumentTableExpression: String; override;
      function GetDocumentSignerFieldNameListExpression(FieldNames: TDocumentInfoFieldNames): String; override;
      function GetCurrentEmployeeJoinExpression: String; override;
      function GetRestDocumentTableJoinExpression: String; override;

    public

      function GetIncomingDocumentFieldNameListExpression(
        FieldNames: TIncomingDocumentInfoFieldNames
      ): String; virtual; abstract;

      function GetIncomingDocumentTableJoinExpression(DocumentIdParamName: String): String; virtual; abstract;

    public

      constructor Create(
        DocumentInfoQueryBuilder: TDocumentInfoQueryBuilder;
        DocumentTableDef: TDocumentTableDef;
        IncomingDocumentTableDef: TIncomingDocumentTableDef
      );

  end;

implementation

uses

  Classes;

{ TIncomingDocumentInfoQueryBuilder }

constructor TIncomingDocumentInfoQueryBuilder.Create(
  DocumentInfoQueryBuilder: TDocumentInfoQueryBuilder;
  DocumentTableDef: TDocumentTableDef;
  IncomingDocumentTableDef: TIncomingDocumentTableDef
);
begin

  inherited Create(DocumentTableDef);

  FIncomingDocumentTableDef := IncomingDocumentTableDef;
  FDocumentInfoQueryBuilder := DocumentInfoQueryBuilder;
  
end;

function TIncomingDocumentInfoQueryBuilder.GetDocumentFieldNameListExpression(
  FieldNames: TDocumentInfoFieldNames): String;
begin

  with FieldNames as TIncomingDocumentInfoFieldNames do begin

    Result :=
      FDocumentInfoQueryBuilder
        .GetDocumentFieldNameListExpression(OriginalDocumentInfoFieldNames)
          +
          ','
          +
        GetIncomingDocumentFieldNameListExpression(
          TIncomingDocumentInfoFieldNames(FieldNames)
        );

  end;

end;

function TIncomingDocumentInfoQueryBuilder.GetDocumentTableExpression(
  DocumentIdParamName: String): String;
begin

    Result :=
      GetMainDocumentTableExpression + #13#10 +
      GetCurrentEmployeeJoinExpression + #13#10 +
      GetIncomingDocumentTableJoinExpression(DocumentIdParamName) + #13#10 +
      GetRestDocumentTableJoinExpression;

end;

function TIncomingDocumentInfoQueryBuilder.GetCurrentEmployeeJoinExpression: String;
begin

  Result := FDocumentInfoQueryBuilder.GetCurrentEmployeeJoinExpression;

end;

function TIncomingDocumentInfoQueryBuilder.GetDocumentSignerFieldNameListExpression(
  FieldNames: TDocumentInfoFieldNames): String;
begin

  Result :=
    FDocumentInfoQueryBuilder
      .GetDocumentSignerFieldNameListExpression(
        TIncomingDocumentInfoFieldNames(FieldNames)
          .OriginalDocumentInfoFieldNames
      );
  
end;

function TIncomingDocumentInfoQueryBuilder.GetMainDocumentTableExpression: String;
begin

  Result := FDocumentInfoQueryBuilder.GetMainDocumentTableExpression;

end;

function TIncomingDocumentInfoQueryBuilder.GetRestDocumentTableJoinExpression: String;
begin

  Result := FDocumentInfoQueryBuilder.GetRestDocumentTableJoinExpression;

end;

end.
