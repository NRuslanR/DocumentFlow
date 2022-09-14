unit IncomingDocumentPostgresRepository;

interface

uses

  Document,
  IncomingDocument,
  DomainObjectUnit,
  AbstractDBRepository,
  BaseDocumentPostgresRepository,
  AbstractPostgresRepository,
  DocumentPostgresRepository,
  DBTableMapping,
  DBTableColumnMappings,
  DomainObjectListUnit,
  TableColumnMappings,
  PostgresTableMapping,
  QueryExecutor,
  DataReader,
  IncomingDocumentRepository,
  IncomingDocumentTableDef,
  DocumentRepository,
  DocumentChargeSheetTableDef,
  Disposable,
  VariantListUnit,
  ZConnection,
  SysUtils,
  Classes;

type

  TIncomingDocumentPostgresRepository =
    class (TBaseDocumentPostgresRepository, IIncomingDocumentRepository)

      protected

        type

          TSpecialRepositoryOperation = (
            AddingNewIncomingDocuments,
            NonSpecialOperation
          );

      protected

        FIncomingDocumentTableDef: TIncomingDocumentTableDef;
        FFreeIncomingDocumentTableDef: IDisposable;

        FDocumentChargeSheetTableDef: TDocumentChargeSheetTableDef;
        FFreeDocumentChargeSheetTableDef: IDisposable;
        
        FCurrentSpecialOperation: TSpecialRepositoryOperation;

        FDocumentPostgresRepository: TDocumentPostgresRepository;
        FFreeDocumentRepository: IDocumentRepository;
        
        FIncomingDocumentTypeClass: TIncomingDocumentClass;

      protected

        procedure Initialize; override;

        procedure GetDocumentTableNameMapping(
          var TableName: String;
          var DocumentClass: TDocumentClass;
          var DocumentsClass: TDocumentsClass
        ); override;

      protected

        procedure CustomizeTableMapping(
          TableMappings: TDBTableMapping
        ); override;

        procedure CustomizeDocumentPrimaryKeyMappings(
          DocumentMappings: TDBTableMapping
        ); override;

        procedure CustomizeDocumentSelectMappings(
          DocumentMappings: TDBTableMapping
        ); override;

        procedure CustomizeDocumentModificationMappings(
          DocumentMappings: TDBTableMapping
        ); override;

      protected

        function GetCustomWhereClauseForSelect: String; override;

      protected

        function GetQueryParameterValueFromDomainObject(
          DomainObject: TDomainObject;
          const DomainObjectPropertyName: String
        ): Variant; override;

      protected

        procedure PrepareAddDomainObjectListQuery(
          DomainObjectList: TDomainObjectList;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        ); override;

        procedure PrepareAddingNewIncomingDocumentsQueryFrom(
          IncomingDocuments: TIncomingDocuments;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        );

      protected

        procedure PrepareAndExecuteRemoveDomainObjectQuery(DomainObject: TDomainObject); override;
        procedure PrepareAndExecuteRemoveDomainObjectListQuery(DomainObjectList: TDomainObjectList); override;

        procedure RemoveAllChargeSheetsForDocuments(Documents: TIncomingDocuments);
        procedure RemoveAllDocumentChargeSheets(Document: TIncomingDocument);
      
      protected

        procedure FillDomainObjectFromDataReader(
          DomainObject: TDomainObject;
          DataReader: IDataReader
        ); override;

        function LoadOriginalDocument(DataReader: IDataReader): TDocument;

      protected

        procedure SetQueryExecutor(const Value: IQueryExecutor); override;
        
      public

        constructor Create(
          DocumentPostgresRepository: TDocumentPostgresRepository;
          IncomingDocumentTableDef: TIncomingDocumentTableDef;
          DocumentChargeSheetTableDef: TDocumentChargeSheetTableDef;
          IncomingDocumentTypeClass: TIncomingDocumentClass
        );

      public

        procedure AddDocument(Document: TDocument); override;
        procedure AddDocuments(Documents: TDocuments); override;

      public
    
        function LoadAllIncomingDocuments: TIncomingDocuments;

        function FindIncomingDocumentsByOriginalDocument(
          const OriginalDocumentId: Variant
        ): TIncomingDocuments;

        function FindIncomingDocumentsByOriginalDocuments(
          const OriginalDocumentIds: TVariantList
        ): TIncomingDocuments; overload;

        function FindIncomingDocumentsByOriginalDocuments(
          OriginalDocuments: TDocuments
        ): TIncomingDocuments; overload;

        function FindIncomingDocumentById(
          const IncomingDocumentId: Variant
        ): TIncomingDocument;

        function FindIncomingDocumentsByIds(
          const IncomingDocumentIds: TVariantList
        ): TIncomingDocuments;

        function FindDocumentsByNumber(const Number: String): TDocuments; override;
        function FindDocumentsByNumbers(const Numbers: TStrings): TDocuments; override;

        function FindDocumentsByNumberAndCreationYear(
          const Number: String;
          const CreationYear: Integer
        ): TDocuments; override;

        function FindDocumentsByNumbersAndCreationYear(
          const Numbers: TStrings;
          const CreationYear: Integer
        ): TDocuments; override;
        
        procedure AddIncomingDocument(IncomingDocument: TIncomingDocument);
        procedure AddIncomingDocuments(IncomingDocuments: TIncomingDocuments);

        procedure UpdateIncomingDocument(IncomingDocument: TIncomingDocument);
        procedure UpdateIncomingDocuments(IncomingDocuments: TIncomingDocuments);

        procedure RemoveIncomingDocument(IncomingDocument: TIncomingDocument);
        procedure RemoveIncomingDocuments(IncomingDocuments: TIncomingDocuments); 

    end;

implementation

uses

  DB,
  Variants,
  StrUtils,
  ArrayFunctions,
  RepositoryRegistryUnit,
  SQLAnyMatchingCriterion,
  AuxDebugFunctionsUnit,
  AbstractRepository,
  IDomainObjectBaseListUnit,
  DocumentChargeSheetRepository,
  PostgresTypeNameConstants;

type

  TFindIncomingDocumentsByOriginalDocumentCriterion =
    class (TSQLAnyMatchingCriterion)

      public

        constructor Create(
          Repository: TIncomingDocumentPostgresRepository;
          const OriginalDocumentIds: TVariantList
        );
        
    end;

type

  TAddableIncomingDocuments = class (TIncomingDocuments)

    private

      FIncomingDocuments: TIncomingDocuments;

      function GetDocumentByIndex(Index: Integer): TIncomingDocument;
      procedure SetDocumentByIndex(
        Index: Integer;
        const Value: TIncomingDocument
      );

      function GetDomainObjectCount: Integer; override;

    public

      constructor Create(IncomingDocuments: TIncomingDocuments);

      procedure AddDomainObject(DomainObject: TDomainObject); override;

      destructor Destroy; override;

      procedure Clear; override;

      function FindByIdentity(
        const Identity: Variant
      ): TDomainObject; override;

      property IncomingDocuments: TIncomingDocuments
      read FIncomingDocuments write FIncomingDocuments;
      
  end;

{ TIncomingDocumentPostgresRepository }

procedure TIncomingDocumentPostgresRepository.AddDocument(
  Document: TDocument);
begin

  {
    из-за хранения в одной таблице
    данных о нескольких сущностях в целях
    повышения производительности
  }

  Update(Document);

end;

procedure TIncomingDocumentPostgresRepository.AddDocuments(
  Documents: TDocuments);
begin

  try

    FCurrentSpecialOperation := AddingNewIncomingDocuments;

    AddDomainObjectList(Documents);
    
  finally

    FCurrentSpecialOperation := NonSpecialOperation;

  end;

end;

procedure TIncomingDocumentPostgresRepository.AddIncomingDocument(
  IncomingDocument: TIncomingDocument);
begin

  AddDocument(IncomingDocument);
  
end;

procedure TIncomingDocumentPostgresRepository.AddIncomingDocuments(
  IncomingDocuments: TIncomingDocuments);
begin

  AddDocuments(IncomingDocuments);
  
end;

constructor TIncomingDocumentPostgresRepository.Create(
  DocumentPostgresRepository: TDocumentPostgresRepository;
  IncomingDocumentTableDef: TIncomingDocumentTableDef;
  DocumentChargeSheetTableDef: TDocumentChargeSheetTableDef;
  IncomingDocumentTypeClass: TIncomingDocumentClass
);
begin

  inherited Create(DocumentPostgresRepository.QueryExecutor);

  FDocumentPostgresRepository := DocumentPostgresRepository;
  FFreeDocumentRepository := FDocumentPostgresRepository;
  
  FIncomingDocumentTableDef := IncomingDocumentTableDef;
  FFreeIncomingDocumentTableDef := FIncomingDocumentTableDef;

  FDocumentChargeSheetTableDef := DocumentChargeSheetTableDef;
  FFreeDocumentChargeSheetTableDef := FDocumentChargeSheetTableDef;

  FIncomingDocumentTypeClass := IncomingDocumentTypeClass;
  
  CustomizeTableMapping(FDBTableMapping);
  
end;

procedure TIncomingDocumentPostgresRepository.
  CustomizeDocumentModificationMappings(
    DocumentMappings: TDBTableMapping
  );
var DocumentTypeIdColumnMapping: TTableColumnMapping;
begin

  inherited CustomizeDocumentModificationMappings(DocumentMappings);
  
  DocumentMappings.AddColumnMappingForModification(
    FIncomingDocumentTableDef.OriginalDocumentIdColumnName,
    'OriginalDocument',
    PostgresTypeNameConstants.INTEGER_TYPE_NAME
  );

  DocumentMappings.AddColumnMappingForModification(
    FIncomingDocumentTableDef.NumberColumnName,
    'IncomingNumber',
    PostgresTypeNameConstants.VARCHAR_TYPE_NAME
  );

  DocumentMappings.AddColumnMappingForModification(
    FIncomingDocumentTableDef.ReceiptDateColumnName,
    'ReceiptDate',
    PostgresTypeNameConstants.TIMESTAMP_WITHOUT_TIME_ZONE_TYPE_NAME
  );

  DocumentMappings.AddColumnMappingForModification(
    FIncomingDocumentTableDef.ReceiverIdColumnName,
    'ReceiverId',
    PostgresTypeNameConstants.INTEGER_TYPE_NAME
  );

  DocumentTypeIdColumnMapping :=
    DocumentMappings
      .ColumnMappingsForModification
        .FindColumnMappingByObjectPropertyName('KindIdentity');

  DocumentTypeIdColumnMapping.ColumnName :=
    FIncomingDocumentTableDef.TypeIdColumnName;

end;

procedure TIncomingDocumentPostgresRepository.
  CustomizeDocumentPrimaryKeyMappings(
    DocumentMappings: TDBTableMapping
  );
begin

  inherited CustomizeDocumentPrimaryKeyMappings(DocumentMappings);

  DocumentMappings.PrimaryKeyColumnMappings[0].ColumnName :=
    FIncomingDocumentTableDef.IdColumnName;

end;

procedure TIncomingDocumentPostgresRepository.
  CustomizeDocumentSelectMappings(
    DocumentMappings: TDBTableMapping
  );
var
    DocumentIdColumnMapping: TTableColumnMapping;
    DocumentKindIdColumnMapping: TTableColumnMapping;
begin

  inherited CustomizeDocumentSelectMappings(DocumentMappings);

  DocumentMappings.AddColumnMappingForSelect(
    FIncomingDocumentTableDef.NumberColumnName,
    'IncomingNumber'
  );

  DocumentMappings.AddColumnMappingForSelect(
    FIncomingDocumentTableDef.ReceiptDateColumnName,
    'ReceiptDate'
  );

  DocumentMappings.AddColumnMappingForSelect(
    FIncomingDocumentTableDef.ReceiverIdColumnName,
    'ReceiverId'
  );

  DocumentMappings.AddColumnNameForSelect(
    FIncomingDocumentTableDef.OriginalDocumentIdColumnName
  );

  DocumentIdColumnMapping :=
    DocumentMappings
      .FindSelectColumnMappingByObjectPropertyName('Identity');

  DocumentIdColumnMapping.ColumnName :=
    FIncomingDocumentTableDef.IdColumnName;

  DocumentKindIdColumnMapping :=
    DocumentMappings
      .FindSelectColumnMappingByObjectPropertyName('KindIdentity');

  DocumentKindIdColumnMapping.ColumnName :=
    FIncomingDocumentTableDef.TypeIdColumnName;
    
end;

procedure TIncomingDocumentPostgresRepository.CustomizeTableMapping(
  TableMappings: TDBTableMapping);
begin

  if not Assigned(FIncomingDocumentTableDef) then Exit;
  
  inherited CustomizeTableMapping(TableMappings);
  
end;

procedure TIncomingDocumentPostgresRepository.FillDomainObjectFromDataReader(
  DomainObject: TDomainObject;
  DataReader: IDataReader
);
var IncomingDocument: TIncomingDocument;
begin

  inherited;

  IncomingDocument := DomainObject as TIncomingDocument;

  IncomingDocument.OriginalDocument := LoadOriginalDocument(DataReader);

end;

function TIncomingDocumentPostgresRepository.FindDocumentsByNumber(
  const Number: String): TDocuments;
var
    Numbers: TStrings;
begin

  Numbers := StringArrayToStrings([Number]);

  try

    Result := FindDocumentsByNumbers(Numbers);
    
  finally

    FreeAndNil(Numbers);
    
  end;

end;

function TIncomingDocumentPostgresRepository.FindDocumentsByNumberAndCreationYear(
  const Number: String;
  const CreationYear: Integer
): TDocuments;
var
    Numbers: TStrings;
begin

  Numbers := StringArrayToStrings([Number]);

  try

    Result := FindDocumentsByNumbersAndCreationYear(Numbers, CreationYear);
    
  finally

    FreeAndNil(Numbers);

  end;

end;

function TIncomingDocumentPostgresRepository.FindDocumentsByNumbersAndCreationYear(
  const Numbers: TStrings;
  const CreationYear: Integer
): TDocuments;
var
    OriginalDocuments: TDocuments;
    Free: IDomainObjectBaseList;
begin

  OriginalDocuments :=
    FDocumentPostgresRepository
      .FindDocumentsByNumbersAndCreationYear(Numbers, CreationYear);

  Free := OriginalDocuments;

  Result := FindIncomingDocumentsByOriginalDocuments(OriginalDocuments);

end;

function TIncomingDocumentPostgresRepository.FindDocumentsByNumbers(
  const Numbers: TStrings): TDocuments;
var
    OriginalDocuments: TDocuments;
    FreeOriginalDocuments: IDomainObjectBaseList;
begin

  OriginalDocuments := FDocumentPostgresRepository.FindDocumentsByNumbers(Numbers);

  FreeOriginalDocuments := OriginalDocuments;

  Result := FindIncomingDocumentsByOriginalDocuments(OriginalDocuments);
  
end;                                       

function TIncomingDocumentPostgresRepository.FindIncomingDocumentById(
  const IncomingDocumentId: Variant): TIncomingDocument;
begin

  Result := TIncomingDocument(FindDocumentById(IncomingDocumentId));

end;

function TIncomingDocumentPostgresRepository.
  FindIncomingDocumentsByIds(
    const IncomingDocumentIds: TVariantList
  ): TIncomingDocuments;
begin

  Result := TIncomingDocuments(FindDocumentsByIds(IncomingDocumentIds));
  
end;

function TIncomingDocumentPostgresRepository.FindIncomingDocumentsByOriginalDocument(
  const OriginalDocumentId: Variant): TIncomingDocuments;
var
    OriginalDocumentIds: TVariantList;
begin

  OriginalDocumentIds := TVariantList.CreateFrom([OriginalDocumentId]);

  try

    Result := FindIncomingDocumentsByOriginalDocuments(OriginalDocumentIds);

  finally

    FreeAndNil(OriginalDocumentIds);
    
  end;

end;

function TIncomingDocumentPostgresRepository
  .FindIncomingDocumentsByOriginalDocuments(
    OriginalDocuments: TDocuments
  ): TIncomingDocuments;
var
    OriginalDocumentIds: TVariantList;
begin

  if not Assigned(OriginalDocuments) or OriginalDocuments.IsEmpty then begin

    Result := nil;
    Exit;

  end;

  OriginalDocumentIds := OriginalDocuments.CreateDomainObjectIdentityList;

  try

    Result := FindIncomingDocumentsByOriginalDocuments(OriginalDocumentIds);
    
  finally

    FreeAndNil(OriginalDocumentIds);

  end;

end;

function TIncomingDocumentPostgresRepository.FindIncomingDocumentsByOriginalDocuments(
  const OriginalDocumentIds: TVariantList): TIncomingDocuments;
var
    Criteria: TFindIncomingDocumentsByOriginalDocumentCriterion;
begin

  Criteria :=
    TFindIncomingDocumentsByOriginalDocumentCriterion
      .Create(Self, OriginalDocumentIds);

  try

    Result := TIncomingDocuments(FindDomainObjectsByCriteria(Criteria));

  finally

    FreeAndNil(Criteria);

  end;
end;

function TIncomingDocumentPostgresRepository.GetCustomWhereClauseForSelect: String;
var TopLevelChargeSheetIsNullExpression,
    IncomingNumberIsNotNullExpression,
    ReceiptDateIsNotNullExpression: String;
begin

  { Условия для определения, содержит ли
    строчка в таблице БД данные для
    входящего документа }
    
  TopLevelChargeSheetIsNullExpression :=
    DOCUMENT_CHARGE_SHEET_TABLE_TOP_LEVEL_CHARGE_SHEET_ID_FIELD +
    ' is null';

  IncomingNumberIsNotNullExpression :=
    INCOMING_DOCUMENT_TABLE_NUMBER_FIELD + ' is not null';

  ReceiptDateisNotNullExpression :=
    INCOMING_DOCUMENT_TABLE_RECEIPT_DATE_FIELD + ' is not null';

  Result :=
    IfThen(
      inherited GetCustomWhereClauseForSelect <> '',
      inherited GetCustomWhereClauseForSelect + ' AND ',
      ''
    ) +
    TopLevelChargeSheetIsNullExpression +
    ' AND ' +
    IncomingNumberIsNotNullExpression +
    ' AND ' +
    ReceiptDateIsNotNullExpression;
    
end;

procedure TIncomingDocumentPostgresRepository.
  GetDocumentTableNameMapping(
    var TableName: String;
    var DocumentClass: TDocumentClass;
    var DocumentsClass: TDocumentsClass
  );
begin

  TableName := FIncomingDocumentTableDef.TableName;
  DocumentClass := FIncomingDocumentTypeClass;
  DocumentsClass := FIncomingDocumentTypeClass.ListType;

end;

function TIncomingDocumentPostgresRepository.
  GetQueryParameterValueFromDomainObject(
    DomainObject: TDomainObject;
    const DomainObjectPropertyName: String
  ): Variant;
var IncomingDocument: TIncomingDocument;
begin

  IncomingDocument := DomainObject as TIncomingDocument;
  
  if DomainObjectPropertyName = 'OriginalDocument' then
    Result := IncomingDocument.OriginalDocument.Identity

  else begin

    Result :=
      inherited GetQueryParameterValueFromDomainObject(
        DomainObject, DomainObjectPropertyName
    );

  end;

end;

procedure TIncomingDocumentPostgresRepository.Initialize;
begin

  inherited;

  FCurrentSpecialOperation := NonSpecialOperation;
  
  ReturnIdOfDomainObjectAfterAdding := True;
  
end;

function TIncomingDocumentPostgresRepository.
  LoadAllIncomingDocuments: TIncomingDocuments;
begin

  Result := TIncomingDocuments(LoadAllDocuments);

end;

function TIncomingDocumentPostgresRepository.LoadOriginalDocument(
  DataReader: IDataReader
  ): TDocument;
var
    OriginalDocumentIdColumnName: String;
    OriginalDocumentId: Variant;
begin

  OriginalDocumentIdColumnName :=
    TableMapping.
      ColumnMappingsForModification.
        FindColumnMappingByObjectPropertyName(
          'OriginalDocument'
        ).ColumnName;


  OriginalDocumentId := DataReader[OriginalDocumentIdColumnName];
    
  Result :=
    FDocumentPostgresRepository.FindDocumentById(
      OriginalDocumentId
    );

  FDocumentPostgresRepository.
    ThrowExceptionIfErrorIsNotUnknown;

end;

procedure TIncomingDocumentPostgresRepository.PrepareAddDomainObjectListQuery(
  DomainObjectList: TDomainObjectList;
  var QueryPattern: String;
  var QueryParams: TQueryParams
);
begin

  if not (FCurrentSpecialOperation = AddingNewIncomingDocuments) then begin

    inherited;
    Exit;
    
  end;

  PrepareAddingNewIncomingDocumentsQueryFrom(
    DomainObjectList as TIncomingDocuments,
    QueryPattern,
    QueryParams
  );

end;

procedure TIncomingDocumentPostgresRepository.
  PrepareAddingNewIncomingDocumentsQueryFrom(
    IncomingDocuments: TIncomingDocuments;
    var QueryPattern: String;
    var QueryParams: TQueryParams
  );
var 
    DomainObjectColumnNameList: String;
    VALUESRowsLayout: String;
    TableMapping: TPostgresTableMapping;
    OriginalDocumentIdColumnName: String;
    ReceiverIdColumnName: String;
begin

  DomainObjectColumnNameList :=
    FDBTableMapping.GetModificationColumnCommaSeparatedList;

  VALUESRowsLayout :=
    CreateVALUESRowsLayoutStringFromDomainObjectList(
      IncomingDocuments, DontUsePrimaryKeyColumns
    );

  TableMapping := FDBTableMapping as TPostgresTableMapping;

  OriginalDocumentIdColumnName :=
    FDBTableMapping.
    ColumnMappingsForModification.
    FindColumnMappingByObjectPropertyName('OriginalDocument').ColumnName;

  ReceiverIdColumnName :=
    FDBTableMapping.ColumnMappingsForModification.
    FindColumnMappingByObjectPropertyName('ReceiverId').ColumnName;

  QueryPattern :=
    Format(
      'UPDATE %s as t1 SET %s ' +
      'FROM (VALUES %s) as t2(%s) ' +
      'WHERE t1.%s=t2.%s AND t1.%s=t2.%s ' +
      'RETURNING %s',
      [
        TableMapping.TableName,
        TableMapping.GetUpdateListForMultipleUpdates('t2'),
        VALUESRowsLayout,
        DomainObjectColumnNameList,
        OriginalDocumentIdColumnName, OriginalDocumentIdColumnName,
        ReceiverIdColumnName, ReceiverIdColumnName,
        TableMapping.GetUniqueObjectColumnCommaSeparatedList(
          UseNonQualifiedColumnNaming
        )
      ]
    ) + ' ' + GetCustomTrailingUpdateQueryTextPart;

end;

procedure TIncomingDocumentPostgresRepository.
  PrepareAndExecuteRemoveDomainObjectListQuery(
    DomainObjectList: TDomainObjectList
  );
begin

  RemoveAllChargeSheetsForDocuments(TIncomingDocuments(DomainObjectList));
  
  inherited PrepareAndExecuteRemoveDomainObjectListQuery(DomainObjectList);

end;

procedure TIncomingDocumentPostgresRepository.PrepareAndExecuteRemoveDomainObjectQuery(
  DomainObject: TDomainObject);
begin

  RemoveAllDocumentChargeSheets(TIncomingDocument(DomainObject));

  inherited PrepareAndExecuteRemoveDomainObjectQuery(DomainObject);

end;

procedure TIncomingDocumentPostgresRepository.RemoveAllChargeSheetsForDocuments(
  Documents: TIncomingDocuments
);
var
    Document: TIncomingDocument;
begin

  for Document in Documents do
    RemoveAllDocumentChargeSheets(Document);
    
end;

procedure TIncomingDocumentPostgresRepository.RemoveAllDocumentChargeSheets(
  Document: TIncomingDocument);
var
    DocumentChargeSheetRepository: IDocumentChargeSheetRepository;
begin

  DocumentChargeSheetRepository :=
    TRepositoryRegistry
      .Current
        .GetDocumentRepositoryRegistry
          .GetDocumentChargeSheetRepository(Document.ClassType);

  DocumentChargeSheetRepository
    .RemoveAllChargeSheetsForDocument(Document.Identity);
  
end;

procedure TIncomingDocumentPostgresRepository.RemoveIncomingDocument(
  IncomingDocument: TIncomingDocument);
begin

  RemoveDocument(IncomingDocument);
  
end;

procedure TIncomingDocumentPostgresRepository.RemoveIncomingDocuments(
  IncomingDocuments: TIncomingDocuments);
begin

  RemoveDocuments(IncomingDocuments);

end;

procedure TIncomingDocumentPostgresRepository.SetQueryExecutor(
  const Value: IQueryExecutor
);
begin

  inherited;

  if Assigned(FDocumentPostgresRepository) then
    FDocumentPostgresRepository.QueryExecutor := Value;

end;

procedure TIncomingDocumentPostgresRepository.UpdateIncomingDocument(
  IncomingDocument: TIncomingDocument);
begin

  UpdateDocument(IncomingDocument);
  
end;

procedure TIncomingDocumentPostgresRepository.UpdateIncomingDocuments(
  IncomingDocuments: TIncomingDocuments);
begin

  UpdateDocuments(IncomingDocuments);

end;

{ TAddableIncomingDocuments }

procedure TAddableIncomingDocuments.AddDomainObject(
  DomainObject: TDomainObject);
begin

  FIncomingDocuments.AddDomainObject(DomainObject);

end;

procedure TAddableIncomingDocuments.Clear;
begin

end;

constructor TAddableIncomingDocuments.Create(
  IncomingDocuments: TIncomingDocuments);
begin

  inherited Create;

  FIncomingDocuments := IncomingDocuments;
      
end;

destructor TAddableIncomingDocuments.Destroy;
begin

  FreeAndNil(FIncomingDocuments);
  inherited;

end;

function TAddableIncomingDocuments.FindByIdentity(
  const Identity: Variant): TDomainObject;
begin

  Result := FIncomingDocuments.FindByIdentity(Identity);
  
end;

function TAddableIncomingDocuments.GetDocumentByIndex(
  Index: Integer): TIncomingDocument;
begin

  Result := FIncomingDocuments[Index];
  
end;

function TAddableIncomingDocuments.GetDomainObjectCount: Integer;
begin

  Result := FIncomingDocuments.Count;
  
end;

procedure TAddableIncomingDocuments.SetDocumentByIndex(Index: Integer;
  const Value: TIncomingDocument);
begin

  FIncomingDocuments[Index] := Value;
  
end;

{ TFindIncomingDocumentsByOriginalDocumentCriterion }

constructor TFindIncomingDocumentsByOriginalDocumentCriterion.Create(
  Repository: TIncomingDocumentPostgresRepository;
  const OriginalDocumentIds: TVariantList
);
var
    OriginalDocumentIdColumnName: String;
begin

  OriginalDocumentIdColumnName :=
    Format(
      '%s.%s',
      [
        Repository.TableMapping.TableName,
        Repository.FIncomingDocumentTableDef.OriginalDocumentIdColumnName
      ]
    );

  inherited Create(OriginalDocumentIdColumnName, OriginalDocumentIds);

end;

end.
