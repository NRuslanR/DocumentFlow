unit ZeosPostgresDocumentNumeratorRegistryUnit;

interface

uses

  AbstractDocumentNumeratorRegistry,
  INumberGeneratorUnit,
  Document,
  StandardDocumentNumerator,
  Department,
  ZConnection;

type

  TDocumentNumeratorTableData = class

    TableName: String;
    DepartmentIdColumnName: String;
    DocumentTypeIdColumnName: String;
    NumberPrefixColumnName: String;
    NumberPostfixColumnName: String;
    DelimiterColumnName: String;
    CurrentNumberColumnName: String;
    
  end;

  TZeosPostgresDocumentNumeratorRegistry =
    class (TDocumentNumeratorRegistry)

      private

        FConnection: TZConnection;

      protected

        FDocumentNumeratorTableData: TDocumentNumeratorTableData;

        function GetIdForDocumentType(DocumentType: TDocumentClass): Integer;
        
        function CreateNumberGeneratorBy(
          Department: TDepartment;
          DocumentType: TDocumentClass
        ): INumberGenerator; override;

        function GetNumberConstantPartsBy(
          Department: TDepartment;
          DocumentType: TDocumentClass
        ): TDocumentNumberConstantParts; override;

        procedure SetDocumentNumeratorTableData(
          DocumentNumeratorTableData: TDocumentNumeratorTableData
        );
        
      public

        destructor Destroy; override;
        constructor Create(Connection: TZConnection);
        
        property Connection: TZConnection read FConnection write FConnection;

        property DocumentNumeratorTableData: TDocumentNumeratorTableData
        read FDocumentNumeratorTableData
        write SetDocumentNumeratorTableData;

    end;
    
implementation

uses

  SysUtils,
  StrUtils,
  Variants,
  AuxZeosFunctions,
  ServiceNote,
  IncomingServiceNote,
  ZeosPostgresSequenceNumberGeneratorUnit;

{ TZeosPostgresDocumentNumeratorRegistry }

constructor TZeosPostgresDocumentNumeratorRegistry.Create(
  Connection: TZConnection);
begin

  inherited Create;
  
  FConnection := Connection;

end;

function TZeosPostgresDocumentNumeratorRegistry.CreateNumberGeneratorBy(
  Department: TDepartment;
  DocumentType: TDocumentClass
): INumberGenerator;
var PostgresSequenceNumberGenerator: TZeosPostgresSequenceNumberGenerator;
begin

  { refactor }
  PostgresSequenceNumberGenerator :=
    TZeosPostgresSequenceNumberGenerator.Create(FConnection);

  PostgresSequenceNumberGenerator.TableName :=
    FDocumentNumeratorTableData.TableName;
    
  PostgresSequenceNumberGenerator.NumberFieldName :=
    FDocumentNumeratorTableData.CurrentNumberColumnName;
  
  PostgresSequenceNumberGenerator.FilterStatement :=
    Format(
      '%s=doc.find_head_kindred_department_for_inner(%s) AND %s=%d',
      [
        FDocumentNumeratorTableData.DepartmentIdColumnName,
        VarToStr(Department.Identity),
        FDocumentNumeratorTableData.DocumentTypeIdColumnName,
        GetIdForDocumentType(DocumentType)
      ]
    );
    
  Result := PostgresSequenceNumberGenerator;

end;

destructor TZeosPostgresDocumentNumeratorRegistry.Destroy;
begin

  FreeAndNil(FDocumentNumeratorTableData);
  inherited;

end;

function TZeosPostgresDocumentNumeratorRegistry.GetIdForDocumentType(
  DocumentType: TDocumentClass
): Integer;
begin

  if DocumentType.InheritsFrom(TServiceNote) then
    Result := 2

  else if DocumentType.InheritsFrom(TIncomingServiceNote) then
    Result := 3

  else
    raise Exception.Create(
            'Не найден идентификатор ' +
            'вида документов для ' +
            'создания нумератора'
          );
    
end;

function TZeosPostgresDocumentNumeratorRegistry.GetNumberConstantPartsBy(
  Department: TDepartment;
  DocumentType: TDocumentClass
): TDocumentNumberConstantParts;
var VariantResult: Variant;
    NumberPrefixValue, NumberPostfixValue, Delimiter: String;
begin

  VariantResult :=
    CreateAndExecuteQueryWithResults(
      Connection,
      Format(
        'SELECT %s,%s,%s FROM %s ' +
        'WHERE %s=doc.find_head_kindred_department_for_inner(:p%s) AND %s=:p%s',
        [
          FDocumentNumeratorTableData.NumberPrefixColumnName,
          FDocumentNumeratorTableData.NumberPostfixColumnName,
          FDocumentNumeratorTableData.DelimiterColumnName,
          FDocumentNumeratorTableData.TableName,
          FDocumentNumeratorTableData.DepartmentIdColumnName,
          FDocumentNumeratorTableData.DepartmentIdColumnName,
          FDocumentNumeratorTableData.DocumentTypeIdColumnName,
          FDocumentNumeratorTableData.DocumentTypeIdColumnName
        ]
      ),
      [
        'p' + FDocumentNumeratorTableData.DepartmentIdColumnName,
        'p' + FDocumentNumeratorTableData.DocumentTypeIdColumnName
      ],
      [
        Department.Identity,
        GetIdForDocumentType(DocumentType)
      ],
      [
        FDocumentNumeratorTableData.NumberPrefixColumnName,
        FDocumentNumeratorTableData.NumberPostfixColumnName,
        FDocumentNumeratorTableData.DelimiterColumnName
      ]
    );

  if VarIsNull(VariantResult) then
    raise Exception.CreateFmt(
            'Не найден нумератор документов ' +
            'для подразделения "%s". Обратитесь ' +
            'к администратору.',
            [
              Department.ShortName
            ]
          );

  if not VarIsNull(VariantResult[0]) then
    NumberPrefixValue := VariantResult[0]

  else NumberPrefixValue := '';

  if not VarIsNull(VariantResult[1]) then
    NumberPostfixValue := VariantResult[1]

  else NumberPostfixValue := '';

  if not VarIsNull(VariantResult[2]) then
    Delimiter := VariantResult[2]

  else Delimiter := '';

  Result :=
    TDocumentNumberConstantParts.Create(
      NumberPrefixValue, NumberPostfixValue, Delimiter
    );
  
end;

procedure TZeosPostgresDocumentNumeratorRegistry.
  SetDocumentNumeratorTableData(
    DocumentNumeratorTableData: TDocumentNumeratorTableData
  );
begin

  FreeAndNil(FDocumentNumeratorTableData);

  FDocumentNumeratorTableData := DocumentNumeratorTableData;
  
end;

end.
