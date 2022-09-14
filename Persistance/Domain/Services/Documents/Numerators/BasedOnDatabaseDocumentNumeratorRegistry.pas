{ refactor: рассмотреть переработку данного класса и его предков }
unit BasedOnDatabaseDocumentNumeratorRegistry;

interface

uses

  DocumentNumeratorRegistry,
  AbstractDocumentNumeratorRegistry,
  INumberGeneratorUnit,
  Document,
  StandardDocumentNumerator,
  DocumentKindRepository,
  DepartmentRepository,
  DepartmentUnit,
  DocumentKind,
  QueryExecutor,
  DataReader;

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

  TBasedOnDatabaseDocumentNumeratorRegistry =
    class abstract (TDocumentNumeratorRegistry)

      protected

        FQueryExecutor: IQueryExecutor;
        FDepartmentRepository: IDepartmentRepository;
        FDocumentKindRepository: IDocumentKindRepository;

      protected

        FPreparedNumberConstantPartsFetchingQueryPattern: String;

        function PrepareNumberConstantPartsFetchingQueryPattern: String; virtual;

        function GetDepartmentIdExpressionPattern: String; virtual; abstract;
        function GetDepartmentIdExpression(const InnerDepartmentId: Variant): String; virtual; abstract;

        function ExecuteNumberConstantPartsFetchingQuery(
          const QueryPattern: String;
          const DepartmentId: Variant;
          const DocumentTypeId: Variant
        ): IDataReader; virtual;
        
      protected

        FDocumentNumeratorTableData: TDocumentNumeratorTableData;

        function GetIdForDocumentType(DocumentType: TDocumentClass): Integer;
        
        function CreateNumberGeneratorBy(
          DocumentType: TDocumentClass;
          const DepartmentId: Variant
        ): INumberGenerator; override;

        function GetNumberConstantPartsBy(
          DocumentType: TDocumentClass;
          const DepartmentId: Variant
        ): TDocumentNumberConstantParts; override;

        procedure SetDocumentNumeratorTableData(
          DocumentNumeratorTableData: TDocumentNumeratorTableData
        );

      protected

        procedure RaiseExceptionIfDocumentNumeratorDataRecordCountIsNotValid(
          DataReader: IDataReader;
          const DepartmentId: Variant
        );
        
      public

        destructor Destroy; override;
        
        constructor Create(
          DocumentNumeratorTableData: TDocumentNumeratorTableData;
          QueryExecutor: IQueryExecutor;
          DepartmentRepository: IDepartmentRepository;
          DocumentKindRepository: IDocumentKindRepository
        );

        property DocumentNumeratorTableData: TDocumentNumeratorTableData
        read FDocumentNumeratorTableData
        write SetDocumentNumeratorTableData;

    end;
    
implementation

uses

  SysUtils,
  Variants,
  AuxZeosFunctions,
  ServiceNote,
  IDomainObjectBaseUnit,
  IncomingServiceNote,
  DBSequenceNumberGeneratorUnit;

{ TBasedOnDatabaseDocumentNumeratorRegistry }

constructor TBasedOnDatabaseDocumentNumeratorRegistry.Create(
  DocumentNumeratorTableData: TDocumentNumeratorTableData;
  QueryExecutor: IQueryExecutor;
  DepartmentRepository: IDepartmentRepository;
  DocumentKindRepository: IDocumentKindRepository
);
begin

  inherited Create;

  FDocumentNumeratorTableData := DocumentNumeratorTableData;
  FQueryExecutor := QueryExecutor;
  FDepartmentRepository := DepartmentRepository;
  FDocumentKindRepository := DocumentKindRepository;
  
  FPreparedNumberConstantPartsFetchingQueryPattern :=
    PrepareNumberConstantPartsFetchingQueryPattern;
    
end;

function TBasedOnDatabaseDocumentNumeratorRegistry.CreateNumberGeneratorBy(
  DocumentType: TDocumentClass;
  const DepartmentId: Variant
): INumberGenerator;
var SequenceNumberGenerator: TDBSequenceNumberGenerator;
    FilterStatement: String;
begin

  SequenceNumberGenerator := TDBSequenceNumberGenerator.Create(FQueryExecutor);

  SequenceNumberGenerator.TableName :=
    FDocumentNumeratorTableData.TableName;
    
  SequenceNumberGenerator.NumberFieldName :=
    FDocumentNumeratorTableData.CurrentNumberColumnName;

  if not VarIsNull(DepartmentId) then begin

    FilterStatement :=
      Format(
        '%s=%s AND %s=%d',
        [
          FDocumentNumeratorTableData.DepartmentIdColumnName,
          GetDepartmentIdExpression(DepartmentId),
          FDocumentNumeratorTableData.DocumentTypeIdColumnName,
          GetIdForDocumentType(DocumentType)
        ]
      );

  end

  else begin

    FilterStatement :=
      Format(
        '%s is NULL AND %s=%d',
        [
          FDocumentNumeratorTableData.DepartmentIdColumnName,
          FDocumentNumeratorTableData.DocumentTypeIdColumnName,
          GetIdForDocumentType(DocumentType)
        ]
      );
      
  end;
  
  SequenceNumberGenerator.FilterStatement := FilterStatement;
  
  Result := SequenceNumberGenerator;

end;

destructor TBasedOnDatabaseDocumentNumeratorRegistry.Destroy;
begin

  FreeAndNil(FDocumentNumeratorTableData);

  inherited;

end;

function TBasedOnDatabaseDocumentNumeratorRegistry.ExecuteNumberConstantPartsFetchingQuery(
  const QueryPattern: String;
  const DepartmentId,
  DocumentTypeId: Variant
): IDataReader;
var QueryParams: TQueryParams;
begin

  QueryParams := TQueryParams.Create;

  try

    QueryParams
      .AddFluently(
        'p' + DocumentNumeratorTableData.DepartmentIdColumnName,
        DepartmentId
      )
      .Add(
        'p' + DocumentNumeratorTableData.DocumentTypeIdColumnName,
        DocumentTypeId
      );

    Result := FQueryExecutor.ExecuteSelectionQuery(QueryPattern, QueryParams);

  finally

    FreeAndNil(QueryParams);
    
  end;

end;

function TBasedOnDatabaseDocumentNumeratorRegistry.GetIdForDocumentType(
  DocumentType: TDocumentClass
): Integer;
var
    DocumentKind: TDocumentKind;
    Free: IDomainObjectBase;
begin

  DocumentKind :=
    FDocumentKindRepository.FindDocumentKindByClassType(DocumentType);

  Free := DocumentKind;

  Result := DocumentKind.Identity;
  
end;

function TBasedOnDatabaseDocumentNumeratorRegistry.GetNumberConstantPartsBy(
  DocumentType: TDocumentClass;
  const DepartmentId: Variant
): TDocumentNumberConstantParts;

var
    VariantResult: Variant;
    NumberPrefixValue, NumberPostfixValue, Delimiter: String;
    DataReader: IDataReader;
begin
  
  DataReader :=
    ExecuteNumberConstantPartsFetchingQuery(
      FPreparedNumberConstantPartsFetchingQueryPattern,
      DepartmentId,
      GetIdForDocumentType(DocumentType)
    );

  RaiseExceptionIfDocumentNumeratorDataRecordCountIsNotValid(
    DataReader, DepartmentId
  );

  Result :=
    TDocumentNumberConstantParts.Create(
      VarToStr(DataReader[DocumentNumeratorTableData.NumberPrefixColumnName]),
      VarToStr(DataReader[DocumentNumeratorTableData.NumberPostfixColumnName]),
      VarToStr(DataReader[DocumentNumeratorTableData.DelimiterColumnName])
    );
  
end;

function TBasedOnDatabaseDocumentNumeratorRegistry.
  PrepareNumberConstantPartsFetchingQueryPattern: String;
begin

  Result :=
    Format(
      'SELECT %s,%s,%s FROM %s ' +
      'WHERE %s=%s AND %s=:p%s',
      [
        FDocumentNumeratorTableData.NumberPrefixColumnName,
        FDocumentNumeratorTableData.NumberPostfixColumnName,
        FDocumentNumeratorTableData.DelimiterColumnName,
        FDocumentNumeratorTableData.TableName,
        FDocumentNumeratorTableData.DepartmentIdColumnName,
        GetDepartmentIdExpressionPattern,
        FDocumentNumeratorTableData.DocumentTypeIdColumnName,
        FDocumentNumeratorTableData.DocumentTypeIdColumnName
      ]
    );

end;

procedure TBasedOnDatabaseDocumentNumeratorRegistry.
  RaiseExceptionIfDocumentNumeratorDataRecordCountIsNotValid(
    DataReader: IDataReader;
    const DepartmentId: Variant
  );
  var
      Department: TDepartment;
      ErrorMessage: String;
begin

  if not ((DataReader.RecordCount = 0) or (DataReader.RecordCount > 1))
  then Exit;

  if not VarIsNull(DepartmentId) then
    Department := FDepartmentRepository.FindDepartmentById(DepartmentId)

  else Department := nil;

  if DataReader.RecordCount = 0 then begin

    if not Assigned(Department) then begin

      ErrorMessage :=
        'Ќе найден нумератор дл€ ' +
        'данного вида документов. ќбратитесь ' +
        'к администратору.';

    end

    else begin

      ErrorMessage :=
        Format(
          'Ќе найден нумератор дл€ ' +
          'данного вида документов и ' +
          'подразделени€ "%s". ќбратитесь ' +
          'к администратору.',
          [
            Department.ShortName
          ]
        );

    end;

  end

  else if DataReader.RecordCount > 1 then begin

    if not Assigned(Department) then begin

      ErrorMessage :=
        'Ќайдено более одного нумератора дл€ ' +
        'данного вида документов. ќбратитесь ' +
        'к администратору.';

    end

    else begin

      ErrorMessage :=
        Format(
          'Ќайдено более одного нумератора дл€ ' +
          'данного вида документов и ' +
          'подразделени€ "%s". ќбратитесь ' +
          'к администратору.',
          [
            Department.ShortName
          ]
        );

    end;

  end;

  if ErrorMessage <> '' then
    raise TDocumentNumeratorRegistryException.Create(ErrorMessage);
    
end;

procedure TBasedOnDatabaseDocumentNumeratorRegistry.
  SetDocumentNumeratorTableData(
    DocumentNumeratorTableData: TDocumentNumeratorTableData
  );
begin

  FreeAndNil(FDocumentNumeratorTableData);

  FDocumentNumeratorTableData := DocumentNumeratorTableData;
  
end;

end.
