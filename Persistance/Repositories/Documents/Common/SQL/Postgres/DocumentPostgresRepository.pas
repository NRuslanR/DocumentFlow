unit DocumentPostgresRepository;

interface

uses

  Document,
  DocumentWorkCycle,
  AbstractRepository,
  AbstractPostgresRepository,
  DBTableMapping,
  DomainObjectListUnit,
  DomainObjectUnit,
  DocumentChargeRepository,
  DocumentSigningPostgresRepository,
  DocumentSignings,
  DocumentCharges,
  DocumentApprovings,
  BaseDocumentPostgresRepository,
  DocumentWorkCycleStagesPostgresRepository,
  DocumentWorkCycleRepository,
  DocumentTableDef,
  DocumentApprovingPostgresRepository,
  DocumentChargePostgresRepository,
  DocumentChargeSheetRepository,
  DocumentChargeSheetPostgresRepository,
  DocumentTypeStageTableDef,
  DocumentApprovingRepository,
  Disposable,
  QueryExecutor,
  DataReader,
  Employee,
  SysUtils,
  Classes;

type

  TDocumentPostgresRepository = class abstract (TBaseDocumentPostgresRepository)

    protected

      FChargeRepository: TDocumentChargePostgresRepository;
      FFreeDocumentChargeRepository: IDocumentChargeRepository;

      FChargeSheetRepository: IDocumentChargeSheetRepository;
      
      FDocumentSigningPostgresRepository: TDocumentSigningPostgresRepository;

      FDocumentApprovingRepository: TDocumentApprovingPostgresRepository;
      FFreeDocumentApprovingRepository: IDocumentApprovingRepository;

      FDocumentWorkCycleRepository: IDocumentWorkCycleRepository;
      
    protected

      FDocumentTableDef: TDocumentTableDef;
      FFreeDocumentTableDef: IDisposable;

      FDocumentTypeStageTableDef: TDocumentTypeStageTableDef;
      FFreeDocumentTypeStageTableDef: IDisposable;

      FDocumentClass: TDocumentClass;

      FDocumentWorkCycleMappings: TDBTableMapping;

    protected

      procedure GetDocumentTableNameMapping(
        var TableName: string;
        var DocumentClass: TDocumentClass;
        var DocumentsClass: TDocumentsClass
      ); override;

    protected
    
      function GetQueryParameterValueFromDomainObject(
        DomainObject: TDomainObject;
        const DomainObjectPropertyName: String
      ): Variant; override;

    protected

      procedure CustomizeTableMapping(
        TableMapping: TDBTableMapping
      ); override;

      procedure CustomizeDocumentSelectMappings(
        DocumentMappings: TDBTableMapping
      ); override;

      procedure CustomizeDocumentModificationMappings(
        DocumentMappings: TDBTableMapping
      ); override;

      procedure CustomizeDocumentWorkCycleMappings(
        DocumentWorkCycleMappings: TDBTableMapping
      ); virtual;

    protected

      procedure PrepareAndExecuteAddDomainObjectQuery(
        DomainObject: TDomainObject
      ); override;

      procedure PrepareAndExecuteUpdateDomainObjectQuery(
        DomainObject: TDomainObject
      ); override;

      procedure PrepareAndExecuteRemoveDomainObjectQuery(
        DomainObject: TDomainObject
      ); override;

      procedure PrepareAndExecuteAddDomainObjectListQuery(
        DomainObjectList: TDomainObjectList
      ); override;

      procedure PrepareAndExecuteUpdateDomainObjectListQuery(
        DomainObjectList: TDomainObjectList
      ); override;

      procedure PrepareAndExecuteRemoveDomainObjectListQuery(
        DomainObjectList: TDomainObjectList
      ); override;
      
    protected

       procedure AddDocumentInnerObjects(Document: TDocument);
       procedure AddSigningsOfDocument(Document: TDocument);
       procedure AddChargesOfDocument(Document: TDocument);
       procedure AddApprovingsOfDocument(Document: TDocument);

       procedure UpdateDocumentInnerObjects(Document: TDocument);
       procedure UpdateChargesOfDocument(Document: TDocument);
       procedure UpdateSigningsOfDocument(Document: TDocument);
       procedure UpdateApprovingsOfDocument(Document: TDocument);

       procedure RemoveDocumentInnerObjects(Document: TDocument);
       procedure RemoveAllChargesOfDocument(Document: TDocument);
       procedure RemoveAllSigningsOfDocument(Document: TDocument);
       procedure RemoveAllApprovingsOfDocument(Document: TDocument);

    protected

      function GetJoinWithDocumentWorkCycleStagesTableString: String; virtual;

      procedure GetSelectListFromTableMappingForSelectByIdentity(
        var SelectList: String;
        var WhereClauseForSelectIdentity: String
      ); override;

      function GetSelectListFromTableMappingForSelectGroup: String; override;
      function GetTableNameFromTableMappingForSelect: String; override;

    protected

      procedure FillDomainObjectFromDataReader(
        DomainObject: TDomainObject;
        DataReader: IDataReader
      ); override;

    protected

      function ExtractCurrentDocumentWorkCycleStageNumberFrom(
        DataReader: IDataReader
      ): Integer;

      function LoadDocumentWorkCycle(DataReader: IDataReader): TDocumentWorkCycle;

      function LoadDocumentAuthor(DataReader: IDataReader): TEmployee;

      function LoadAllChargesForDocument(
        const DocumentId: Variant
      ): TDocumentCharges;

      function LoadAllSigningsForDocument(
        const DocumentId: Variant
      ): TDocumentSignings;

      function LoadAllApprovingsForDocument(
        const DocumentId: Variant
      ): TDocumentApprovings;

    public

      constructor Create(
        QueryExecutor: IQueryExecutor;
        DocumentTableDef: TDocumentTableDef;
        DocumentTypeStageTableDef: TDocumentTypeStageTableDef;
        DocumentClass: TDocumentClass;
        ApprovingPostgresRepository: TDocumentApprovingPostgresRepository;
        SigningPostgresRepository: TDocumentSigningPostgresRepository;
        ChargePostgresRepository: TDocumentChargePostgresRepository;
        ChargeSheetRepository: TDocumentChargeSheetPostgresRepository;
        WorkCycleRepository: IDocumentWorkCycleRepository
      );

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

  end;

implementation

uses

  DB,
  DocumentTableDefsFactoryRegistry,
  Variants,
  EmployeeTableDef,
  DocumentChargeInterface,
  RepositoryRegistryUnit,
  StandardDocumentWorkCycleRepository,
  SQLAnyMatchingCriterion,
  AbstractRepositoryCriteriaUnit,
  SQLCastingFunctions,
  PostgresTypeNameConstants,
  IEmployeeRepositoryUnit,
  AuxDebugFunctionsUnit,
  ArrayFunctions,
  AbstractDBRepository,
  TableColumnMappings;

type

  TFindDocumentsByNumbersCriterion = class (TSQLAnyMatchingCriterion)

    public

      constructor Create(
        Repository: TDocumentPostgresRepository;
        const Numbers: TStrings
      ); overload;

  end;

  TFindDocumentsByCreationYearCriterion = class (TSQLAnyMatchingCriterion)

    public

      constructor Create(
        Repository: TDocumentPostgresRepository;
        const CreationYear: Integer
      ); overload;

  end;

  TFindDocumentsByNumbersAndCreationYearCriterion =
    class (TAbstractRepositoryCriterion)

      private

        FByNumbersCriterion: TFindDocumentsByNumbersCriterion;
        FByCreationYearCriterion: TFindDocumentsByCreationYearCriterion;

      protected

        function GetExpression: String; override;
        
      public

        destructor Destroy; override;

        constructor Create(
          Repository: TDocumentPostgresRepository;
          const Numbers: TStrings;
          const CreationYear: Integer
        );
        
    end;
{ TDocumentPostgresRepository }

procedure TDocumentPostgresRepository.CustomizeDocumentWorkCycleMappings(
  DocumentWorkCycleMappings: TDBTableMapping);
begin

  if not Assigned(FDocumentTableDef) then Exit;

  with FDocumentTypeStageTableDef do begin

    DocumentWorkCycleMappings.SetTableNameMapping(
      TableName, FDocumentClass.WorkCycleType
    );

    DocumentWorkCycleMappings.AddColumnMappingForSelect(
      StageNumberColumnName, 'CurrentWorkCycleStageNumber'
    );

    DocumentWorkCycleMappings.AddPrimaryKeyColumnMapping(
      IdColumnName, 'CurrentWorkCycleStageId'
    );

  end;

end;

constructor TDocumentPostgresRepository.Create(
  QueryExecutor: IQueryExecutor;
  DocumentTableDef: TDocumentTableDef;
  DocumentTypeStageTableDef: TDocumentTypeStageTableDef;
  DocumentClass: TDocumentClass;
  ApprovingPostgresRepository: TDocumentApprovingPostgresRepository;
  SigningPostgresRepository: TDocumentSigningPostgresRepository;
  ChargePostgresRepository: TDocumentChargePostgresRepository;
  ChargeSheetRepository: TDocumentChargeSheetPostgresRepository;
  WorkCycleRepository: IDocumentWorkCycleRepository
);
begin

  inherited Create;
  
  FDocumentTableDef := DocumentTableDef;
  FFreeDocumentTableDef := FDocumentTableDef;

  FDocumentTypeStageTableDef := DocumentTypeStageTableDef;
  FFreeDocumentTypeStageTableDef := FDocumentTypeStageTableDef;
  
  FDocumentClass := DocumentClass;

  CustomizeTableMapping(FDBTableMapping);

  Self.QueryExecutor := QueryExecutor;

  FDocumentApprovingRepository := ApprovingPostgresRepository;
  FFreeDocumentApprovingRepository := FDocumentApprovingRepository;
  
  FDocumentSigningPostgresRepository := SigningPostgresRepository;

  FChargeRepository := ChargePostgresRepository;
  FFreeDocumentChargeRepository := FChargeRepository;

  FChargeSheetRepository := ChargeSheetRepository;
  
  FDocumentWorkCycleRepository := WorkCycleRepository;
  
end;

procedure TDocumentPostgresRepository.CustomizeDocumentModificationMappings(
  DocumentMappings: TDBTableMapping
);
begin

  inherited CustomizeDocumentModificationMappings(DocumentMappings);

  with FDocumentTableDef do begin

    DocumentMappings.AddColumnMappingForModification(
      NoteColumnName,
      'Note',
      PostgresTypeNameConstants.VARCHAR_TYPE_NAME
    );

    DocumentMappings.AddColumnMappingForModification(
      ProductCodeColumnName,
      'ProductCode',
      PostgresTypeNameConstants.VARCHAR_TYPE_NAME
    );
    
    DocumentMappings.AddColumnMappingForModification(
      AuthorIdColumnName,
      'Author',
      PostgresTypeNameConstants.INTEGER_TYPE_NAME
    );

    DocumentMappings.AddColumnMappingForModification(
      NameColumnName,
      'Name',
      PostgresTypeNameConstants.VARCHAR_TYPE_NAME
    );

    DocumentMappings.AddColumnMappingForModification(
      FullNameColumnName,
      'FullName',
      PostgresTypeNameConstants.VARCHAR_TYPE_NAME
    );

    DocumentMappings.AddColumnMappingForModification(
      ContentColumnName,
      'Content',
      PostgresTypeNameConstants.VARCHAR_TYPE_NAME
    );

    DocumentMappings.AddColumnMappingForModification(
      NumberColumnName,
      'Number',
      PostgresTypeNameConstants.VARCHAR_TYPE_NAME
    );

    DocumentMappings.AddColumnMappingForModification(
      CurrentWorkCycleStageIdColumnName,
      'CurrentWorkCycleStageNumber',
      PostgresTypeNameConstants.INTEGER_TYPE_NAME
    );

    DocumentMappings.AddColumnMappingForModification(
      ResponsibleIdColumnName,
      'ResponsibleId',
      PostgresTypeNameConstants.INTEGER_TYPE_NAME
    );

    DocumentMappings.AddColumnMappingForModification(
      CreationDateColumnName,
      'CreationDate',
      PostgresTypeNameConstants.TIMESTAMP_WITHOUT_TIME_ZONE_TYPE_NAME
    );

    DocumentMappings.AddColumnMappingForModification(
      DocumentDateColumnName,
      'DocumentDate',
      PostgresTypeNameConstants.VARCHAR_TYPE_NAME
    );
    
    DocumentMappings.AddColumnMappingForModification(
      IsSentToSigningColumnName,
      'IsSentToSigning',
      PostgresTypeNameConstants.BOOLEAN_TYPE_NAME
    );

    if IsSelfRegisteredColumnName <> '' then begin

      DocumentMappings.AddColumnMappingForModification(
        IsSelfRegisteredColumnName,
        'IsSelfRegistered'
      );

    end;

  end;

end;

procedure TDocumentPostgresRepository.CustomizeDocumentSelectMappings(
  DocumentMappings: TDBTableMapping
);
begin

  inherited CustomizeDocumentSelectMappings(DocumentMappings);

  if not Assigned(FDocumentTableDef) then Exit;

  with FDocumentTableDef do begin

    DocumentMappings.AddColumnMappingForSelect(
      NoteColumnName, 'Note'
    );

    DocumentMappings.AddColumnMappingForSelect(
      ProductCodeColumnName, 'ProductCode'
    );
    
    DocumentMappings.AddColumnMappingForSelect(
      NameColumnName, 'Name'
    );

    DocumentMappings.AddColumnMappingForSelect(
      FullNameColumnName, 'FullName'
    );

    DocumentMappings.AddColumnMappingForSelect(
      ContentColumnName, 'Content'
    );

    DocumentMappings.AddColumnMappingForSelect(
      CreationDateColumnName, 'CreationDate'
    );

    DocumentMappings.AddColumnMappingForSelect(
      DocumentDateColumnName, 'DocumentDate'
    );
    
    DocumentMappings.AddColumnMappingForSelect(
      NumberColumnName, 'Number'
    );

    DocumentMappings.AddColumnMappingForSelect(
      AuthorIdColumnName, 'Author', False
    );

    DocumentMappings.AddColumnMappingForSelect(
      ResponsibleIdColumnName, 'ResponsibleId'
    );

    DocumentMappings.AddColumnMappingForSelect(
      IsSentToSigningColumnName,
      'IsSentToSigning'
    );

    if IsSelfRegisteredColumnName <> '' then begin

      DocumentMappings.AddColumnMappingForSelect(
        IsSelfRegisteredColumnName,
        'IsSelfRegistered'
      );

    end;
    
  end;

end;

procedure TDocumentPostgresRepository.CustomizeTableMapping(
  TableMapping: TDBTableMapping);
begin

  if not Assigned(FDocumentTableDef) then Exit;
  
  inherited CustomizeTableMapping(TableMapping);

  FDocumentWorkCycleMappings := TDBTableMapping.Create;

  CustomizeDocumentWorkCycleMappings(FDocumentWorkCycleMappings);

end;

function TDocumentPostgresRepository.ExtractCurrentDocumentWorkCycleStageNumberFrom(
  DataReader: IDataReader
): Integer;
var
    CurrentWorkCycleStageNumberColumnName: String;
begin

  CurrentWorkCycleStageNumberColumnName :=
    FDocumentWorkCycleMappings.FindSelectColumnMappingByObjectPropertyName(
      'CurrentWorkCycleStageNumber'
    ).ColumnName;

  Result := DataReader[CurrentWorkCycleStageNumberColumnName];
  
end;

procedure TDocumentPostgresRepository.FillDomainObjectFromDataReader(
  DomainObject: TDomainObject;
  DataReader: IDataReader
);
var Document: TDocument;
    Charge: TDocumentCharge;
begin

  inherited;

  Document := DomainObject as TDocument;

  Document.WorkCycle := LoadDocumentWorkCycle(DataReader);
  
  Document.CurrentWorkCycleStageNumber :=
    ExtractCurrentDocumentWorkCycleStageNumberFrom(DataReader);

  Document.Author := LoadDocumentAuthor(DataReader);
  Document.Charges := LoadAllChargesForDocument(Document.Identity);
  Document.Signings := LoadAllSigningsForDocument(Document.Identity);
  Document.Approvings := LoadAllApprovingsForDocument(Document.Identity);
  
end;

function TDocumentPostgresRepository
  .FindDocumentsByNumber(const Number: String): TDocuments;
var
    Numbers: TStrings;
begin

  Numbers := StringArrayToStrings([Number]);

  try

    Result := FindDocumentsByNumbers(Numbers);

  finally

    FreeAndNil(Result);
    
  end;

end;

function TDocumentPostgresRepository.FindDocumentsByNumberAndCreationYear(
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

function TDocumentPostgresRepository.FindDocumentsByNumbersAndCreationYear(
  const Numbers: TStrings;
  const CreationYear: Integer
): TDocuments;
var
    Criteria: TFindDocumentsByNumbersAndCreationYearCriterion;
begin

  Criteria :=
    TFindDocumentsByNumbersAndCreationYearCriterion
      .Create(Self, Numbers, CreationYear);

  try

    Result := TDocuments(FindDomainObjectsByCriteria(Criteria));
    
  finally

    FreeAndNil(Criteria);

  end;

end;

function TDocumentPostgresRepository
  .FindDocumentsByNumbers(const Numbers: TStrings): TDocuments;
var
    Criteria: TFindDocumentsByNumbersCriterion;
begin

  Criteria := TFindDocumentsByNumbersCriterion.Create(Self, Numbers);

  try

    Result := TDocuments(FindDomainObjectsByCriteria(Criteria));
    
  finally

    FreeAndNil(Criteria);
    
  end;

end;

procedure TDocumentPostgresRepository.GetDocumentTableNameMapping(
  var TableName: string;
  var DocumentClass: TDocumentClass;
  var DocumentsClass: TDocumentsClass
);
begin

  TableName := FDocumentTableDef.TableName;
  DocumentClass := FDocumentClass;
  DocumentsClass := FDocumentClass.ListType;

end;

function TDocumentPostgresRepository.GetJoinWithDocumentWorkCycleStagesTableString: String;
begin

  Result :=
    Format(
      ' JOIN %s ON %s.%s = %s.%s',
      [
        FDocumentWorkCycleMappings.TableName,
        
        FDocumentWorkCycleMappings.TableName,
        FDocumentWorkCycleMappings.PrimaryKeyColumnMappings[0].ColumnName,

        FDBTableMapping.TableName,
        FDocumentTableDef.CurrentWorkCycleStageIdColumnName
      ]
    );
    
end;

procedure TDocumentPostgresRepository.GetSelectListFromTableMappingForSelectByIdentity(
  var SelectList, WhereClauseForSelectIdentity: String);
var DocumentWorkCycleSelectList,
    Placeholder: String;
begin

  inherited;

  FDocumentWorkCycleMappings.GetSelectListForSelectByIdentity(
    DocumentWorkCycleSelectList, Placeholder
  );

  SelectList := SelectList + ',' + DocumentWorkCycleSelectList;

end;

function TDocumentPostgresRepository.GetSelectListFromTableMappingForSelectGroup: String;
begin

  Result := inherited
            GetSelectListFromTableMappingForSelectGroup + ',' +
            FDocumentWorkCycleMappings.GetSelectListForSelectGroup;

end;

function TDocumentPostgresRepository.GetTableNameFromTableMappingForSelect: String;
begin

  Result := inherited
            GetTableNameFromTableMappingForSelect + ' ' +
            GetJoinWithDocumentWorkCycleStagesTableString;

end;

function TDocumentPostgresRepository.GetQueryParameterValueFromDomainObject(
  DomainObject: TDomainObject;
  const DomainObjectPropertyName: String
): Variant;
var
    Document: TDocument;
begin

  Document := TDocument(DomainObject);
  
  if DomainObjectPropertyName = 'CurrentWorkCycleStageNumber' then
    Result := Document.WorkCycle.CurrentStage.Identity

  else begin

    Result :=
      inherited GetQueryParameterValueFromDomainObject(
        DomainObject, DomainObjectPropertyName
      );

  end;

end;

function TDocumentPostgresRepository.LoadAllApprovingsForDocument(
  const DocumentId: Variant): TDocumentApprovings;
begin

  Result :=
    FDocumentApprovingRepository.FindAllApprovingsForDocument(
      DocumentId
    );

  FDocumentApprovingRepository.ThrowExceptionIfErrorIsNotUnknown;

end;

function TDocumentPostgresRepository.LoadAllChargesForDocument(
  const DocumentId: Variant): TDocumentCharges;
begin

  Result :=
    FChargeRepository.FindAllChargesForDocument(
      DocumentId
    );

  FChargeRepository.
    ThrowExceptionIfErrorIsNotUnknown;

end;

function TDocumentPostgresRepository.LoadAllSigningsForDocument(
  const DocumentId: Variant): TDocumentSignings;
begin

  Result :=
    FDocumentSigningPostgresRepository.FindAllSigningsForDocument(DocumentId);

  FDocumentSigningPostgresRepository.ThrowExceptionIfErrorIsNotUnknown;
    
end;

function TDocumentPostgresRepository.LoadDocumentAuthor(
  DataReader: IDataReader
): TEmployee;
var 
    AuthorColumnName: String;
begin

  AuthorColumnName :=
    FDBTableMapping.FindSelectColumnMappingByObjectPropertyName(
      'Author'
    ).ColumnName;
        
  Result :=
    TRepositoryRegistry.Current.GetEmployeeRepository.FindEmployeeById(
      DataReader[AuthorColumnName]
    );

end;

function TDocumentPostgresRepository.LoadDocumentWorkCycle(
  DataReader: IDataReader
): TDocumentWorkCycle;
var
    DocumentKindIdColumnName: String;
begin

  DocumentKindIdColumnName :=
    FDBTableMapping
      .FindSelectColumnMappingByObjectPropertyName('KindIdentity')
        .ColumnName;

  Result :=
    FDocumentWorkCycleRepository
      .FindWorkCycleForDocumentKind(DataReader[DocumentKindIdColumnName]);

end;

procedure TDocumentPostgresRepository.PrepareAndExecuteAddDomainObjectListQuery(
  DomainObjectList: TDomainObjectList
);
var 
    AddedDocuments: TDocuments;
    AddedDocument: TDocument;
begin

  inherited;
  
  AddedDocuments := DomainObjectList as TDocuments;

  for AddedDocument in AddedDocuments do begin

    AddDocumentInnerObjects(AddedDocument);

  end;

end;

procedure TDocumentPostgresRepository.PrepareAndExecuteAddDomainObjectQuery(
  DomainObject: TDomainObject
);
var Document: TDocument;
begin

  inherited;

  Document := DomainObject as TDocument;

  AddDocumentInnerObjects(Document);
  
end;

procedure TDocumentPostgresRepository.PrepareAndExecuteRemoveDomainObjectListQuery(
  DomainObjectList: TDomainObjectList
);
var 
    RemoveableDocuments: TDocuments;
    RemoveableDocument: TDocument;
begin

  RemoveableDocuments := DomainObjectList as TDocuments;

  for RemoveableDocument in RemoveableDocuments do begin

    RemoveDocumentInnerObjects(RemoveableDocument);
    
  end;

  inherited;

end;

procedure TDocumentPostgresRepository.PrepareAndExecuteRemoveDomainObjectQuery(
  DomainObject: TDomainObject
);
var Document: TDocument;
begin

  Document := DomainObject as TDocument;

  RemoveDocumentInnerObjects(Document);
  
  inherited;
  
end;

procedure TDocumentPostgresRepository.PrepareAndExecuteUpdateDomainObjectListQuery(
  DomainObjectList: TDomainObjectList
);
var 
    UpdatedDocuments: TDocuments;
    UpdatedDocument: TDocument;
begin

  inherited;
  
  UpdatedDocuments := DomainObjectList as TDocuments;

  for UpdatedDocument in UpdatedDocuments do begin

    UpdateDocumentInnerObjects(UpdatedDocument);

  end;
end;

procedure TDocumentPostgresRepository.PrepareAndExecuteUpdateDomainObjectQuery(
  DomainObject: TDomainObject
);
var Document: TDocument;
begin

  inherited PrepareAndExecuteUpdateDomainObjectQuery(DomainObject);

  Document := DomainObject as TDocument;

  if FChargeSheetRepository.AreChargeSheetsExistsForDocument(Document.Identity)
  then begin

    UpdateSigningsOfDocument(Document);
    UpdateApprovingsOfDocument(Document);

  end

  else UpdateDocumentInnerObjects(Document);

end;

procedure TDocumentPostgresRepository.AddApprovingsOfDocument(
  Document: TDocument);
begin

  if Document.Approvings.IsEmpty then Exit;
  
  FDocumentApprovingRepository.AddDocumentApprovings(
    Document.Approvings
  );

  FDocumentApprovingRepository.
    ThrowExceptionIfErrorIsNotUnknown;
  
end;

procedure TDocumentPostgresRepository.AddChargesOfDocument(
  Document: TDocument
);
begin

  if Document.Charges.IsEmpty then Exit;
    
  FChargeRepository.AddDocumentCharges(
    TDocumentCharges(Document.Charges.Self)
  );

  FChargeRepository.
    ThrowExceptionIfErrorIsNotUnknown;

end;

procedure TDocumentPostgresRepository.AddDocumentInnerObjects(
  Document: TDocument);
begin

  AddChargesOfDocument(Document);
  AddSigningsOfDocument(Document);
  AddApprovingsOfDocument(Document);
  
end;

procedure TDocumentPostgresRepository.AddSigningsOfDocument(
  Document: TDocument
);
begin

  if Document.Signings.IsEmpty then Exit;
  
  FDocumentSigningPostgresRepository.AddDocumentSignings(
    Document.Signings
  );

  FDocumentSigningPostgresRepository.
    ThrowExceptionIfErrorIsNotUnknown;

end;

procedure TDocumentPostgresRepository.UpdateApprovingsOfDocument(
  Document: TDocument);
begin

  RemoveAllApprovingsOfDocument(Document);
  AddApprovingsOfDocument(Document);
  
end;

procedure TDocumentPostgresRepository.UpdateChargesOfDocument(
  Document: TDocument);
begin

  RemoveAllChargesOfDocument(Document);
  AddChargesOfDocument(Document);

end;

procedure TDocumentPostgresRepository.UpdateDocumentInnerObjects(
  Document: TDocument);
begin

  UpdateChargesOfDocument(Document);
  UpdateSigningsOfDocument(Document);
  UpdateApprovingsOfDocument(Document);
  
end;

procedure TDocumentPostgresRepository.UpdateSigningsOfDocument(
  Document: TDocument);
begin

  RemoveAllSigningsOfDocument(Document);
  AddSigningsOfDocument(Document);
  
end;

procedure TDocumentPostgresRepository.RemoveAllApprovingsOfDocument(
  Document: TDocument);
begin

  FDocumentApprovingRepository.RemoveAllDocumentApprovings(Document.Identity);

  FDocumentApprovingRepository.ThrowExceptionIfErrorIsNotUnknown;

end;

procedure TDocumentPostgresRepository.RemoveAllChargesOfDocument(
  Document: TDocument);
begin

  FChargeRepository.RemoveAllDocumentCharges(
    Document.Identity
  );

  FChargeRepository.
    ThrowExceptionIfErrorIsNotUnknown;
    
end;

procedure TDocumentPostgresRepository.RemoveAllSigningsOfDocument(
  Document: TDocument);
begin

  FDocumentSigningPostgresRepository.RemoveAllDocumentSignings(
    Document.Identity
  );

  FDocumentSigningPostgresRepository.
    ThrowExceptionIfErrorIsNotUnknown;

end;

procedure TDocumentPostgresRepository.RemoveDocumentInnerObjects(
  Document: TDocument);
begin

  RemoveAllChargesOfDocument(Document);
  RemoveAllSigningsOfDocument(Document);
  RemoveAllApprovingsOfDocument(Document);
  
end;

{ TFindDocumentsByNumbersCriterion }

constructor TFindDocumentsByNumbersCriterion.Create(
  Repository: TDocumentPostgresRepository;
  const Numbers: TStrings
);
var
    DocumentNumberFieldName: String;
    FieldValues: TFieldValueArray;
begin

  DocumentNumberFieldName :=
    Format(
      '%s.%s',
      [
        Repository.TableMapping.TableName,
        Repository.TableMapping.FindSelectColumnMappingByObjectPropertyName(
          TDocument.NumberPropertyName
        ).ColumnName
      ]
    );

  FieldValues := StringsToArray(Numbers);

  inherited Create(DocumentNumberFieldName, FieldValues);
  
end;

{ TFindDocumentsByNumbersAndCreationYearCriterion }

constructor TFindDocumentsByNumbersAndCreationYearCriterion.Create(
  Repository: TDocumentPostgresRepository;
  const Numbers: TStrings;
  const CreationYear: Integer
);
begin

  inherited Create;

  FByNumbersCriterion :=
    TFindDocumentsByNumbersCriterion.Create(Repository, Numbers);

  FByCreationYearCriterion :=
    TFindDocumentsByCreationYearCriterion.Create(Repository, CreationYear);

end;

destructor TFindDocumentsByNumbersAndCreationYearCriterion.Destroy;
begin

  FreeAndNil(FByNumbersCriterion);
  FreeAndNil(FByCreationYearCriterion);
  
  inherited;

end;

function TFindDocumentsByNumbersAndCreationYearCriterion.GetExpression: String;
begin

  Result :=
    FByNumbersCriterion.GetExpression
    + ' AND '
    + FByCreationYearCriterion.GetExpression;

end;

{ TFindDocumentsByCreationYearCriterion }

constructor TFindDocumentsByCreationYearCriterion.Create(
  Repository: TDocumentPostgresRepository;
  const CreationYear: Integer
);
var
    CreationYearFieldName: String;
begin

  CreationYearFieldName :=
    Format(
      'EXTRACT(YEAR FROM %s.%s)',
      [
        Repository.TableMapping.TableName,
        Repository.TableMapping
          .FindSelectColumnMappingByObjectPropertyName('CreationDate').ColumnName
      ]
    );

  inherited Create(CreationYearFieldName, TFieldValueArray.Create(CreationYear));

end;

end.
