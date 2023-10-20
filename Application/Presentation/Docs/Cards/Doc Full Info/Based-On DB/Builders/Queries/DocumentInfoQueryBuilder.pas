unit DocumentInfoQueryBuilder;

interface

uses

  IGetSelfUnit,
  DocumentInfoHolder,
  DocumentTableDef,
  DocumentSigningTableDef,
  SysUtils;

type

  IDocumentInfoQueryBuilderOptions = interface (IGetSelf)

    function FetchSelfDocumentRegistrationData: Boolean; overload;
    function FetchSelfDocumentRegistrationData(const Value: Boolean): IDocumentInfoQueryBuilderOptions; overload;

  end;

  TDocumentInfoQueryBuilderOptions = class (TInterfacedObject, IDocumentInfoQueryBuilderOptions)

    strict private

      FFetchSelfDocumentRegistrationData: Boolean;

      class var FDefault: IDocumentInfoQueryBuilderOptions;

    public

      function GetSelf: TObject;

      function FetchSelfDocumentRegistrationData: Boolean; overload;
      function FetchSelfDocumentRegistrationData(const Value: Boolean): IDocumentInfoQueryBuilderOptions; overload;

      class function Default: IDocumentInfoQueryBuilderOptions;

  end;

  IDocumentInfoQueryBuilder = interface

    function GetOptions: IDocumentInfoQueryBuilderOptions;
    procedure SetOptions(const Value: IDocumentInfoQueryBuilderOptions);
    
    function BuildDocumentInfoQuery(
      FieldNames: TDocumentInfoFieldNames;
      const DocumentIdParamName: String
    ): String;

    property Options: IDocumentInfoQueryBuilderOptions
    read GetOptions write SetOptions;

  end;
  
  TDocumentInfoQueryBuilder = class abstract (TInterfacedObject, IDocumentInfoQueryBuilder)

    protected

      FDocumentTableDef: TDocumentTableDef;
      FSigningTableDef: TDocumentSigningTableDef;
      FOptions: IDocumentInfoQueryBuilderOptions;
      
    public

      function GetMainDocumentTableExpression: String; virtual; abstract;
      function GetDocumentFieldNameListExpression(FieldNames: TDocumentInfoFieldNames): String; virtual; abstract;
      function GetDocumentSignerFieldNameListExpression(FieldNames: TDocumentInfoFieldNames): String; virtual; abstract;
      function GetDocumentTableExpression(DocumentIdParamName: String): String; virtual;
      function GetCurrentEmployeeJoinExpression: String; virtual; abstract;
      function GetDocumentTableFilterExpression(DocumentIdParamName: String): String; virtual; abstract;
      function GetRestDocumentTableJoinExpression: String; virtual; abstract;

    public

      constructor Create(
        DocumentTableDef: TDocumentTableDef;
        SigningTableDef: TDocumentSigningTableDef;
        Options: IDocumentInfoQueryBuilderOptions = nil
      );

      function GetSelf: TObject;
      
      function GetOptions: IDocumentInfoQueryBuilderOptions;
      procedure SetOptions(const Value: IDocumentInfoQueryBuilderOptions);

      function BuildDocumentInfoQuery(
        FieldNames: TDocumentInfoFieldNames;
        const DocumentIdParamName: String
      ): String; virtual;

      property Options: IDocumentInfoQueryBuilderOptions
      read GetOptions write SetOptions;
      
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
  DocumentTableDef: TDocumentTableDef;
  SigningTableDef: TDocumentSigningTableDef;
  Options: IDocumentInfoQueryBuilderOptions
);
begin

  inherited Create;

  FDocumentTableDef := DocumentTableDef;
  FSigningTableDef := SigningTableDef;
  
  if Assigned(Options) then
    Self.Options := Options

  else Self.Options := TDocumentInfoQueryBuilderOptions.Default;
  
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

function TDocumentInfoQueryBuilder.GetSelf: TObject;
begin

  Result := Self;
  
end;

function TDocumentInfoQueryBuilder.GetOptions: IDocumentInfoQueryBuilderOptions;
begin

  Result := FOptions;
  
end;

procedure TDocumentInfoQueryBuilder.SetOptions(
  const Value: IDocumentInfoQueryBuilderOptions);
begin

  FOptions := Value;
  
end;


{ TDocumentInfoQueryBuilderOptions }

function TDocumentInfoQueryBuilderOptions.FetchSelfDocumentRegistrationData: Boolean;
begin

  Result := FFetchSelfDocumentRegistrationData;

end;

class function TDocumentInfoQueryBuilderOptions.Default: IDocumentInfoQueryBuilderOptions;
begin

  if not Assigned(FDefault) then begin

    FDefault :=
      TDocumentInfoQueryBuilderOptions
        .Create
          .FetchSelfDocumentRegistrationData(True);

  end;

  Result := FDefault;

end;

function TDocumentInfoQueryBuilderOptions.FetchSelfDocumentRegistrationData(
  const Value: Boolean): IDocumentInfoQueryBuilderOptions;
begin

  FFetchSelfDocumentRegistrationData := Value;

  Result := Self;

end;

function TDocumentInfoQueryBuilderOptions.GetSelf: TObject;
begin

  Result := Self;

end;

end.
