unit DocumentInfoQueryBuilder;

interface

uses

  DocumentInfoHolder,
  DocumentTableDef,
  SysUtils;

type

  IDocumentInfoQueryBuilder = interface

    function BuildDocumentInfoQuery(
      FieldNames: TDocumentInfoFieldNames;
      const DocumentIdParamName: String
    ): String;
    
  end;
  
  TDocumentInfoQueryBuilder = class (TInterfacedObject, IDocumentInfoQueryBuilder)

    protected

      FDocumentTableDef: TDocumentTableDef;

    public
    
      function GetMainDocumentTableExpression: String; virtual; abstract;
      function GetDocumentFieldNameListExpression(FieldNames: TDocumentInfoFieldNames): String; virtual; abstract;
      function GetDocumentSignerFieldNameListExpression(FieldNames: TDocumentInfoFieldNames): String; virtual; abstract;
      function GetDocumentTableExpression(DocumentIdParamName: String): String; virtual;
      function GetCurrentEmployeeJoinExpression: String; virtual; abstract;
      function GetDocumentTableFilterExpression(DocumentIdParamName: String): String; virtual; abstract;
      function GetRestDocumentTableJoinExpression: String; virtual; abstract;

    public

      constructor Create(DocumentTableDef: TDocumentTableDef);

      function BuildDocumentInfoQuery(
        FieldNames: TDocumentInfoFieldNames;
        const DocumentIdParamName: String
      ): String; virtual;

  end;

implementation

{ TAbstractDocumentInfoQueryBuilder }

function TDocumentInfoQueryBuilder.BuildDocumentInfoQuery(
  FieldNames: TDocumentInfoFieldNames;
  const DocumentIdParamName: String
): String;
begin

  with FieldNames do begin

    Result :=
      ' select distinct' + #13#10 +
      GetDocumentFieldNameListExpression(FieldNames) + #13#10 +
      'from ' + GetDocumentTableExpression(DocumentIdParamName) + #13#10 +
      'where ' + GetDocumentTableFilterExpression(DocumentIdParamName);

  end;

end;

constructor TDocumentInfoQueryBuilder.Create(
  DocumentTableDef: TDocumentTableDef);
begin

  inherited Create;

  FDocumentTableDef := DocumentTableDef;
  
end;

function TDocumentInfoQueryBuilder.GetDocumentTableExpression(
  DocumentIdParamName: String
): String;
begin

  Result :=
      GetMainDocumentTableExpression + #13#10 +
      GetCurrentEmployeeJoinExpression + #13#10 +
      GetRestDocumentTableJoinExpression;

end;

end.
