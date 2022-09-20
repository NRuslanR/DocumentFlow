{
  refactor:
  рассмотреть избежание дублировани€
  логики отображени€ листов поручений в Ѕƒ
  относительно, собственно, поручений, а именно:
  в данном репозитории обращатьс€ к репозиторию поручений
  дл€ выборки поручений после выборки данных о соответствующем
  листе поручени€. ¬ этом случае проблема дублировани€
  решитс€ выполнением дополнительного запроса вместо одного,
  как в данное врем€
}
unit DocumentChargeSheetPostgresRepository;

interface

uses

  AbstractDBRepository,
  AbstractRepositoryCriteriaUnit,
  AbstractPostgresRepository,
  DocumentChargeSheet,
  IDocumentChargeSheetUnit,
  DBTableMapping,
  DomainObjectUnit,
  DomainObjectListUnit,
  DocumentChargeSheetRepository,
  DocumentChargeSheetTableDef,
  VariantListUnit,
  DocumentChargeKindTableDef,
  DocumentChargePostgresRepository,
  DocumentChargeRepository,
  QueryExecutor,
  DocumentCharges,
  Disposable,
  DataReader,
  Employee,
  SysUtils,
  Classes;

type

  TDocumentChargeSheetPostgresRepository =
    class (TAbstractPostgresRepository, IDocumentChargeSheetRepository)

      protected

        FDocumentChargeRepository: IDocumentChargeRepository;

        FDocumentChargeSheetTableDef: TDocumentChargeSheetTableDef;
        FFreeDocumentChargeSheetTableDef: IDisposable;

        procedure Initialize; override;
      
        procedure CustomizeTableMapping(
          TableMapping: TDBTableMapping
        ); override;

        function CreateDomainObject(DataReader: IDataReader): TDomainObject; override;
        
      protected

        procedure PrepareAddDomainObjectListQuery(
          DomainObjectList: TDomainObjectList;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        ); override;

        procedure PrepareRemoveDomainObjectListQuery(
          DomainObjectList: TDomainObjectList;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        ); override;

        procedure PrepareRemoveDomainObjectQuery(
          DomainObject: TDomainObject;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        ); override;

        procedure PrepareFindDomainObjectsByCriteria(
          Criteria: TAbstractRepositoryCriterion;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        ); override;

        procedure PrepareFetchingAllSubordinateChargeSheetsForGivenChargeSheetQuery(
          const ChargeSheetId: Variant;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        );

        procedure PrepareFetchingOwnAndSubordinateDocumentChargeSheetsForPerformerQuery(
          const DocumentId: Variant;
          const PerformerId: Variant;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        );
      
        procedure PrepareRemovingAllChargeSheetsForDocumentQuery(
          const DocumentId: Variant;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        );

        procedure PrepareRemovingHeadDocumentChargeSheetsQuery(
          DocumentChargeSheets: TDocumentChargeSheets;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        );

      protected

        function GetTableNameFromTableMappingForSelect: String; override;
        function GetCustomWhereClauseForSelect: String; override;
        function GetCustomWhereClauseForDelete: String; override;

      protected

        procedure FillDomainObjectFromDataReader(
          DomainObject: TDomainObject;
          DataReader: IDataReader
        ); override;

      protected

        function LoadIssuer(DataReader: IDataReader): TEmployee;

      protected

        procedure FetchHeadAndSubordinateDocumentChargeSheets(
          SourceDocumentChargeSheets: TDocumentChargeSheets;
          var HeadDocumentChargeSheets: TDocumentChargeSheets;
          var SubordinateDocumentChargeSheets: TDocumentChargeSheets
        );

        procedure AddHeadDocumentChargeSheets(
          DocumentChargeSheets: TDocumentChargeSheets
        );

        procedure AddSubordinateDocumentChargeSheets(
          DocumentChargeSheets: TDocumentChargeSheets
        );

        procedure RemoveHeadDocumentChargeSheets(
          DocumentChargeSheets: TDocumentChargeSheets
        );

        procedure RemoveSubordinateDocumentChargeSheets(
          DocumentChargeSheets: TDocumentChargeSheets
        );

      protected

        function FindDocumentChargeSheetsByCriteria(
          Criteria: TAbstractRepositoryCriterion
        ): TDocumentChargeSheets;
      
      public

        constructor Create(
          DocumentChargeRepository: IDocumentChargeRepository;
          QueryExecutor: IQueryExecutor;
          DocumentChargeSheetTableDef: TDocumentChargeSheetTableDef
        );

        function LoadAllDocumentChargeSheets: TDocumentChargeSheets;

        function FindAllChargeSheetsForDocument(
          const DocumentId: Variant
        ): TDocumentChargeSheets;

        function AreChargeSheetsExistsForDocument(
          const DocumentId: Variant
        ): Boolean;

        function FindDocumentChargeSheetById(
          const DocumentChargeSheetId: Variant
        ): TDocumentChargeSheet;

        function FindDocumentChargeSheetsByIds(
          const DocumentChargeSheetIds: TVariantList
        ): TDocumentChargeSheets;

        function FindAllSubordinateChargeSheetsForGivenChargeSheet(
          const TargetChargeSheetId: Variant
        ): TDocumentChargeSheets;

        function FindDocumentChargeSheetsForPerformer(
          const DocumentId: Variant;
          const PerformerId: Variant
        ): TDocumentChargeSheets;

        function FindOwnAndSubordinateDocumentChargeSheetsForPerformer(
          const DocumentId: Variant;
          const PerformerId: Variant
        ): TDocumentChargeSheets;

        procedure AddDocumentChargeSheet(
          DocumentChargeSheet: TDocumentChargeSheet
        );

        procedure AddDocumentChargeSheets(
          DocumentChargeSheets: TDocumentChargeSheets
        );

        procedure UpdateDocumentChargeSheet(
          DocumentChargeSheet: TDocumentChargeSheet
        );

        procedure UpdateDocumentChargeSheets(
          DocumentChargeSheets: TDocumentChargeSheets
        );

        procedure RemoveDocumentChargeSheet(
          DocumentChargeSheet: TDocumentChargeSheet
        );

        procedure RemoveDocumentChargeSheets(
          DocumentChargeSheets: TDocumentChargeSheets
        );

        procedure RemoveDocumentChargeSheetWithAllSubordinates(
          DocumentChargeSheet: TDocumentChargeSheet
        );

        procedure RemoveDocumentChargeSheetsWithAllSubordinates(
          DocumentChargeSheets: TDocumentChargeSheets
        );

        procedure RemoveAllChargeSheetsForDocument(
          const DocumentId: Variant
        );

    end;

implementation

uses

  DB,
  Variants,
  RepositoryRegistryUnit,
  PostgresTypeNameConstants,
  PostgresTableMapping,
  AbstractRepository,
  DBTableColumnMappings,
  IDomainObjectBaseListUnit,
  TableColumnMappings,
  DocumentChargeTableDef;

type

  THeadDocumentChargeSheetsWrapper = class sealed (TDocumentChargeSheets)

    protected

      function GetDomainObjectCount: Integer; override;

      function GetDomainObjectByIndex(Index: Integer): TDomainObject; override;

      procedure SetDomainObjectByIndex(
        Index: Integer;
        const Value: TDomainObject
      ); override;

    private

      FHeadChargeSheets: TDocumentChargeSheets;

    public

      constructor Create(ChargeSheets: TDocumentChargeSheets);

      procedure Clear; override;
      
      property HeadChargeSheets: TDocumentChargeSheets
      read FHeadChargeSheets;

  end;

  TDocumentIdForRemovingAllRelatedChargeSheetsWrapper = class (TDomainObject)

    private

      FDocumentId: Variant;

    public

      constructor Create(const DocumentId: Variant);

      property DocumentId: Variant
      read FDocumentId;
      
  end;

  TDocumentChargeSheetRepositoryCriterion = class (TAbstractRepositoryCriterion)

    protected

      FRepository: TDocumentChargeSheetPostgresRepository;

      constructor Create(Repository: TDocumentChargeSheetPostgresRepository);
      
  end;
  
  TFindAllSubordinateChargeSheetsForGivenChargeSheetCriterion =
    class (TDocumentChargeSheetRepositoryCriterion)

      private

        FTargetChargeSheetId: Variant;

      public

        constructor Create(
          const TargetChargeSheetId: Variant;
          Repository: TDocumentChargeSheetPostgresRepository
        );

      published

        property TargetChargeSheetId: Variant
        read FTargetChargeSheetId write FTargetChargeSheetId;
        
    end;

    TFindAllChargeSheetsForDocumentCriterion =
      class (TDocumentChargeSheetRepositoryCriterion)

        protected

          FDocumentId: Variant;
    
        protected

          function GetExpression: String; override;

        public

          constructor Create(
            const DocumentId: Variant;
            Repository: TDocumentChargeSheetPostgresRepository
          );

        published

          property DocumentId: Variant
          read FDocumentId write FDocumentId;
          
      end;

    TFindDocumentChargeSheetsForPerformerCriterion =
      class (TDocumentChargeSheetRepositoryCriterion)

        private

          FDocumentId: Variant;
          FPerformerId: Variant;
          
        protected

          function GetExpression: String; override;

        public

          constructor Create(
            const DocumentId: Variant;
            const PerformerId: Variant;
            Repository: TDocumentChargeSheetPostgresRepository
          );

          property DocumentId: Variant read FDocumentId;
          property PerformerId: Variant read FPerformerId;

        
      end;

      TFindOwnAndSubordinateDocumentChargeSheetsForPerformerCriterion =
        class (TFindDocumentChargeSheetsForPerformerCriterion)


          
        end;

{ TDocumentChargeSheetPostgresRepository }

constructor TDocumentChargeSheetPostgresRepository.Create(
  DocumentChargeRepository: IDocumentChargeRepository;
  QueryExecutor: IQueryExecutor;
  DocumentChargeSheetTableDef: TDocumentChargeSheetTableDef
);
begin

  inherited Create(QueryExecutor);

  FDocumentChargeRepository := DocumentChargeRepository;
  
  FDocumentChargeSheetTableDef := DocumentChargeSheetTableDef;
  FFreeDocumentChargeSheetTableDef := FDocumentChargeSheetTableDef;

  CustomizeTableMapping(FDBTableMapping);

end;

procedure TDocumentChargeSheetPostgresRepository.CustomizeTableMapping(
  TableMapping: TDBTableMapping);
begin

  if not Assigned(FDocumentChargeSheetTableDef) then Exit;

  with FDocumentChargeSheetTableDef do begin

    TableMapping.SetTableNameMapping(
      TableName, nil, TDocumentChargeSheets
    );

    begin { Column Mappings for Select }

      TableMapping.AddColumnMappingForSelect(IdColumnName, 'Identity');

      TableMapping.AddColumnMappingForSelect(
        TopLevelChargeSheetIdColumnName, 'TopLevelChargeSheetId'
      );

      TableMapping.AddColumnMappingForSelect(
        IssuerIdColumnName, 'Issuer.Identity'
      );

      TableMapping.AddColumnMappingForSelect(
        DocumentKindIdColumnName, 'DocumentKindId'
      );

      TableMapping.AddColumnMappingForSelect(
        IssuingDateTimeColumnName, 'IssuingDateTime'
      );

    end;

    begin { Column Mappings For Modification }

      TableMapping.AddColumnMappingForModification(
        TopLevelChargeSheetIdColumnName,
        'TopLevelChargeSheetId',
        PostgresTypeNameConstants.INTEGER_TYPE_NAME
      );

      TableMapping.AddColumnMappingForModification(
        IssuerIdColumnName,
        'Issuer.Identity',
        PostgresTypeNameConstants.INTEGER_TYPE_NAME
      );

      TableMapping.AddColumnMappingForModification(
        IssuingDateTimeColumnName,
        'IssuingDateTime',
        PostgresTypeNameConstants.TIMESTAMP_WITHOUT_TIME_ZONE_TYPE_NAME
      );

      TableMapping.AddColumnMappingForModification(
        DocumentKindIdColumnName,
        'DocumentKindId',
        PostgresTypeNameConstants.INTEGER_TYPE_NAME
      );

      {
        -refactor: delete lines below after the adding
        charges' updating logic up on to update charge sheets. At the time
        the given mappings are being needed to save charge's fields together with
        charge sheet's fields
      }

      TableMapping.AddColumnMappingForModification(
        OriginalDocumentIdColumnName,
        'DocumentId',
        PostgresTypeNameConstants.INTEGER_TYPE_NAME
      );

      TableMapping.AddColumnMappingForModification(
        ChargeColumnName,
        'ChargeText',
        PostgresTypeNameConstants.VARCHAR_TYPE_NAME
      );

      TableMapping.AddColumnMappingForModification(
        PerformerIdColumnName,
        'Performer.Identity',
        PostgresTypeNameConstants.INTEGER_TYPE_NAME
      );

      TableMapping.AddColumnMappingForModification(
        KindIdColumnName,
        'KindId',
        PostgresTypeNameConstants.INTEGER_TYPE_NAME
      );
      
      TableMapping.AddColumnMappingForModification(
        ActualPerformerIdColumnName,
        'ActuallyPerformedEmployee.Identity',
        PostgresTypeNameConstants.INTEGER_TYPE_NAME
      );

      TableMapping.AddColumnMappingForModification(
        ChargePeriodStartColumnName,
        'TimeFrameStart',
        PostgresTypeNameConstants.TIMESTAMP_WITHOUT_TIME_ZONE_TYPE_NAME
      );

      TableMapping.AddColumnMappingForModification(
        ChargePeriodEndColumnName,
        'TimeFrameDeadline',
        PostgresTypeNameConstants.TIMESTAMP_WITHOUT_TIME_ZONE_TYPE_NAME
      );

      TableMapping.AddColumnMappingForModification(
        PerformerResponseColumnName,
        'PerformerResponse',
        PostgresTypeNameConstants.VARCHAR_TYPE_NAME
      );

      TableMapping.AddColumnMappingForModification(
        PerformingDateTimeColumnName,
        'PerformingDateTime',
        PostgresTypeNameConstants.TIMESTAMP_WITHOUT_TIME_ZONE_TYPE_NAME
      );

      TableMapping.AddColumnMappingForModification(
        IsForAcquaitanceColumnName,
        'IsForAcquaitance',
        PostgresTypeNameConstants.BOOLEAN_TYPE_NAME
      );

      { refactor- }

    end;

    begin { Primary Key Columns }

      TableMapping.AddPrimaryKeyColumnMapping(
        IdColumnName,
        'Identity',
        PostgresTypeNameConstants.INTEGER_TYPE_NAME
      );

    end;

  end;

end;

procedure TDocumentChargeSheetPostgresRepository.AddDocumentChargeSheet(
  DocumentChargeSheet: TDocumentChargeSheet);
begin

  Add(DocumentChargeSheet);

  ThrowExceptionIfErrorIsNotUnknown;

end;

procedure TDocumentChargeSheetPostgresRepository.AddDocumentChargeSheets(
  DocumentChargeSheets: TDocumentChargeSheets
);
var
    HeadDocumentChargeSheets: TDocumentChargeSheets;
    SubordinateDocumentChargeSheets: TDocumentChargeSheets;

    FreeHeadDocumentChargeSheets: IDocumentChargeSheets;
    FreeSubordinateDocumentChargeSheets: IDocumentChargeSheets;
begin

  FetchHeadAndSubordinateDocumentChargeSheets(
    DocumentChargeSheets,
    HeadDocumentChargeSheets,
    SubordinateDocumentChargeSheets
  );

  FreeHeadDocumentChargeSheets := HeadDocumentChargeSheets;
  FreeSubordinateDocumentChargeSheets := SubordinateDocumentChargeSheets;
  
  AddHeadDocumentChargeSheets(HeadDocumentChargeSheets);
  AddSubordinateDocumentChargeSheets(SubordinateDocumentChargeSheets);

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

procedure TDocumentChargeSheetPostgresRepository.AddHeadDocumentChargeSheets(
  DocumentChargeSheets: TDocumentChargeSheets
);
var
    DocumentCharge: TDocumentCharge;
    AllDocumentCharges, DocumentChargesForAdding: TDocumentCharges;
    FreeAllDocumentCharges, FreeDocumentChargesForAdding: IDomainObjectBaseList;
begin

  if DocumentChargeSheets.IsEmpty then Exit;

  AllDocumentCharges := DocumentChargeSheets.FetchCharges;

  FreeAllDocumentCharges := AllDocumentCharges;

  DocumentChargesForAdding :=
    TDocumentCharges(AllDocumentCharges.GetNotIdentityAssignedDomainObjects);

  FreeAllDocumentCharges := DocumentChargesForAdding;
  
  if not DocumentChargesForAdding.IsEmpty then
    FDocumentChargeRepository.AddDocumentCharges(DocumentChargesForAdding);

  DocumentChargeSheets.SyncIdentitiesByChargeIdentities;
  
  UpdateDomainObjectList(DocumentChargeSheets);

end;

procedure TDocumentChargeSheetPostgresRepository.AddSubordinateDocumentChargeSheets(
  DocumentChargeSheets: TDocumentChargeSheets);
var
    Charges: TDocumentCharges;
begin

  AddHeadDocumentChargeSheets(DocumentChargeSheets);

end;

function TDocumentChargeSheetPostgresRepository.AreChargeSheetsExistsForDocument(
  const DocumentId: Variant
): Boolean;
var
    QueryPattern: String;
    QueryParams: TQueryParams;
    DataReader: IDataReader;
begin

  if VarIsNull(DocumentId) then begin

    Result := False;
    Exit;

  end;

  {
    refactor:
    ƒобавить в интерфейс DomainObjectRepository
    метод AreDomainObjectsExistsByCriteria(Criteria)
    и реализовать в наследниках дл€ определени€
    существовани€ объектов, удовлетвор€ющих критерию Criteria
  }

  QueryParams := TQueryParams.Create;

  try

    QueryPattern :=
      Format(
        'SELECT EXISTS(SELECT 1 FROM %s WHERE %s AND %s=:p%s) AS result',
        [
          FDocumentChargeSheetTableDef.TableName,
          GetCustomWhereClauseForSelect,
          FDocumentChargeSheetTableDef.OriginalDocumentIdColumnName,
          FDocumentChargeSheetTableDef.OriginalDocumentIdColumnName
        ]
      );

    QueryParams.Add(
      'p' + FDocumentChargeSheetTableDef.OriginalDocumentIdColumnName,
      DocumentId
    );

    DataReader := SafeQueryExecutor.ExecuteSelectionQuery(QueryPattern, QueryParams);

    Result := DataReader['result'];

  finally

    FreeAndNil(QueryParams);

  end;

end;

procedure TDocumentChargeSheetPostgresRepository.
  FetchHeadAndSubordinateDocumentChargeSheets(
    SourceDocumentChargeSheets: TDocumentChargeSheets;
    var HeadDocumentChargeSheets,
    SubordinateDocumentChargeSheets: TDocumentChargeSheets
  );
var
    ChargeSheet: IDocumentChargeSheet;
begin

  HeadDocumentChargeSheets := TDocumentChargeSheets.Create;
  SubordinateDocumentChargeSheets := TDocumentChargeSheets.Create;

  for ChargeSheet in SourceDocumentChargeSheets do begin

    if ChargeSheet.IsHead then begin
    
      HeadDocumentChargeSheets.AddDocumentChargeSheet(
        ChargeSheet
      )

    end

    else begin

      SubordinateDocumentChargeSheets.AddDocumentChargeSheet(
        ChargeSheet
      );

    end;

  end;

end;

function TDocumentChargeSheetPostgresRepository.CreateDomainObject(
  DataReader: IDataReader): TDomainObject;
var
    DocumentCharge: TDocumentCharge;
begin

  DocumentCharge :=
    FDocumentChargeRepository.FindDocumentChargeById(
      DataReader[FDocumentChargeSheetTableDef.IdColumnName]
    );

  Result :=
    TDocumentChargeSheetClass(DocumentCharge.ChargeSheetType)
      .Create(DocumentCharge);

end;

procedure TDocumentChargeSheetPostgresRepository.
  FillDomainObjectFromDataReader(
    DomainObject: TDomainObject;
    DataReader: IDataReader
  );
var DocumentChargeSheet: TDocumentChargeSheet;
begin

  inherited;

  DocumentChargeSheet := DomainObject as TDocumentChargeSheet;
  
  DocumentChargeSheet.Issuer := LoadIssuer(DataReader);

end;

function TDocumentChargeSheetPostgresRepository.
  FindAllChargeSheetsForDocument(
    const DocumentId: Variant
  ): TDocumentChargeSheets;
var
    Criteria: TFindAllChargeSheetsForDocumentCriterion;
begin

  if VarIsNull(DocumentId) then begin

    Result := nil;
    Exit;
    
  end;

  Criteria :=
    TFindAllChargeSheetsForDocumentCriterion.Create(
      DocumentId, Self
    );

  try

    Result := FindDocumentChargeSheetsByCriteria(Criteria);

    ThrowExceptionIfErrorIsNotUnknown;
    
  finally

    FreeAndNil(Criteria);
    
  end;

end;

function TDocumentChargeSheetPostgresRepository.
  FindAllSubordinateChargeSheetsForGivenChargeSheet(
    const TargetChargeSheetId: Variant
  ): TDocumentChargeSheets;
var DomainObjectList: TDomainObjectList;
    Criterion: TFindAllSubordinateChargeSheetsForGivenChargeSheetCriterion;
begin

  if VarIsNull(TargetChargeSheetId) or
     VarIsEmpty(TargetChargeSheetId)

  then raise Exception.Create(
                'ќбнаружен недействительный ' +
                'идентификатор поручени€ ' +
                'дл€ выборки всех подчинЄнных ' +
                'поручений'
             );
  
  Criterion :=
    TFindAllSubordinateChargeSheetsForGivenChargeSheetCriterion.Create(
      TargetChargeSheetId, Self
    );

  try

    DomainObjectList := FindDomainObjectsByCriteria(Criterion);

    ThrowExceptionIfErrorIsNotUnknown;
    
    if not Assigned(DomainObjectList) then
      Result := nil

    else Result := DomainObjectList as TDocumentChargeSheets;
    
  finally

    FreeAndNil(Criterion);
    
  end;

end;

function TDocumentChargeSheetPostgresRepository.FindDocumentChargeSheetById(
  const DocumentChargeSheetId: Variant): TDocumentChargeSheet;
var DomainObject: TDomainObject;
begin

  DomainObject := FindDomainObjectByIdentity(DocumentChargeSheetId);

  if not Assigned(DomainObject) then
    Result := nil

  else Result := DomainObject as TDocumentChargeSheet;

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

function TDocumentChargeSheetPostgresRepository.FindDocumentChargeSheetsByIds(
  const DocumentChargeSheetIds: TVariantList): TDocumentChargeSheets;
begin

  Result := TDocumentChargeSheets(FindDomainObjectsByIdentities(DocumentChargeSheetIds));
  
end;

function TDocumentChargeSheetPostgresRepository.
  FindDocumentChargeSheetsByCriteria(
    Criteria: TAbstractRepositoryCriterion
  ): TDocumentChargeSheets;
var DomainObjectList: TDomainObjectList;
begin

  DomainObjectList := FindDomainObjectsByCriteria(Criteria);

  if not Assigned(DomainObjectList) then
    Result := nil

  else
    Result := DomainObjectList as TDocumentChargeSheets;
  
end;

function TDocumentChargeSheetPostgresRepository.
  FindDocumentChargeSheetsForPerformer(
    const DocumentId, PerformerId: Variant
  ): TDocumentChargeSheets;
var
    FindDocumentChargeSheetsForPerformerCriterion:
      TFindDocumentChargeSheetsForPerformerCriterion;
begin

  FindDocumentChargeSheetsForPerformerCriterion :=
    TFindDocumentChargeSheetsForPerformerCriterion.Create(
      DocumentId, PerformerId, Self
    );

  try

    Result :=
      TDocumentChargeSheets(
        FindDomainObjectsByCriteria(
          FindDocumentChargeSheetsForPerformerCriterion
        )
      );

    ThrowExceptionIfErrorIsNotUnknown;
    
  finally

    FreeAndNil(FindDocumentChargeSheetsForPerformerCriterion);
    
  end;
  
end;

function TDocumentChargeSheetPostgresRepository.
  FindOwnAndSubordinateDocumentChargeSheetsForPerformer(
    const DocumentId, PerformerId: Variant
  ): TDocumentChargeSheets;
var
    FindOwnAndSubordinateDocumentChargeSheetsForPerformerCriterion:
      TFindOwnAndSubordinateDocumentChargeSheetsForPerformerCriterion;
begin

  FindOwnAndSubordinateDocumentChargeSheetsForPerformerCriterion :=
    TFindOwnAndSubordinateDocumentChargeSheetsForPerformerCriterion.Create(
      DocumentId, PerformerId, Self
    );

  try

    Result :=
      TDocumentChargeSheets(
        FindDomainObjectsByCriteria(
          FindOwnAndSubordinateDocumentChargeSheetsForPerformerCriterion
        )
      );

    ThrowExceptionIfErrorIsNotUnknown;
      
  finally

    FreeAndNil(FindOwnAndSubordinateDocumentChargeSheetsForPerformerCriterion);
    
  end;

end;

function TDocumentChargeSheetPostgresRepository.GetCustomWhereClauseForDelete: String;
begin

  Result :=
    FDocumentChargeSheetTableDef.IssuerIdColumnName + ' is not null';

end;

function TDocumentChargeSheetPostgresRepository.GetCustomWhereClauseForSelect: String;
begin

  Result :=
    FDocumentChargeSheetTableDef.IssuerIdColumnName + ' is not null';
    
end;

function TDocumentChargeSheetPostgresRepository.GetTableNameFromTableMappingForSelect: String;
begin

  Result :=
    inherited GetTableNameFromTableMappingForSelect;

end;

procedure TDocumentChargeSheetPostgresRepository.Initialize;
begin

  inherited;

  ReturnIdOfDomainObjectAfterUpdate := True;

end;

function TDocumentChargeSheetPostgresRepository.LoadAllDocumentChargeSheets: TDocumentChargeSheets;
var DomainObjectList: TDomainObjectList;
begin

  DomainObjectList := LoadAll;

  if not Assigned(DomainObjectList) then
    Result := nil

  else Result := DomainObjectList as TDocumentChargeSheets;

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

function TDocumentChargeSheetPostgresRepository.LoadIssuer(
  DataReader: IDataReader
): TEmployee;
var
    IssuerId: Variant;
begin

  IssuerId := DataReader[FDocumentChargeSheetTableDef.IssuerIdColumnName];
  
  if VarIsNull(IssuerId) then
    Result := nil

  else begin
  
    Result :=
      TRepositoryRegistry.Current.GetEmployeeRepository.FindEmployeeById(
        IssuerId
      );

  end;

end;

procedure TDocumentChargeSheetPostgresRepository.
  PrepareAddDomainObjectListQuery(
    DomainObjectList: TDomainObjectList;
    var QueryPattern: String;
    var QueryParams: TQueryParams
  );
var
    Wrapper: THeadDocumentChargeSheetsWrapper;
    HeadChargeSheets: TDocumentChargeSheets;

    begin

  inherited PrepareAddDomainObjectListQuery(DomainObjectList, QueryPattern, QueryParams);

end;

procedure TDocumentChargeSheetPostgresRepository.
  PrepareFetchingAllSubordinateChargeSheetsForGivenChargeSheetQuery(
    const ChargeSheetId: Variant;
    var QueryPattern: String;
    var QueryParams: TQueryParams
  );
var QueryText: String;
    SelectColumnNameListWithoutTablePrefix: String;
    TopLevelChargeSheetIdColumnName: String;
    ChargeSheetIdColumnName: String;
begin

  SelectColumnNameListWithoutTablePrefix :=
    FDBTableMapping.GetSelectColumnNameListWithoutTablePrefix;

  ChargeSheetIdColumnName :=
    FDocumentChargeSheetTableDef.IdColumnName;

  TopLevelChargeSheetIdColumnName :=
    FDocumentChargeSheetTableDef.TopLevelChargeSheetIdColumnName;

  QueryPattern :=
    Format(
      'WITH RECURSIVE subordinate_charge_sheets (%s) ' +
      'AS (' +
      'SELECT %s ' +
      'FROM %s ' +
      'WHERE %s=%s ' +
      'UNION ' +
      'SELECT %s ' +
      'FROM %s AS t1 ' +
      'JOIN subordinate_charge_sheets AS t2 ON t1.%s=t2.%s' +
      ') ' +
      'SELECT * FROM subordinate_charge_sheets',
      [
        SelectColumnNameListWithoutTablePrefix,

        SelectColumnNameListWithoutTablePrefix,

        FDBTableMapping.TableName,

        TopLevelChargeSheetIdColumnName,
        VarToStr(ChargeSheetId),

        FDBTableMapping.GetSelectListForSelectGroup('t1'),

        FDBTableMapping.TableName,

        TopLevelChargeSheetIdColumnName,
        ChargeSheetIdColumnName
      ]
    );

end;

procedure TDocumentChargeSheetPostgresRepository.
  PrepareFetchingOwnAndSubordinateDocumentChargeSheetsForPerformerQuery(
    const DocumentId, PerformerId: Variant;
    var QueryPattern: String;
    var QueryParams: TQueryParams
  );
var QueryText: String;
    SelectColumnNameListWithoutTablePrefix: String;
    TopLevelChargeSheetIdColumnName: String;

    DocumentIdColumnName: String;
    PerformerIdColumnName: String;
    ChargeSheetIdColumnName: String;
begin

  SelectColumnNameListWithoutTablePrefix :=
    FDBTableMapping.GetSelectColumnNameListWithoutTablePrefix;

  DocumentIdColumnName :=
    FDocumentChargeSheetTableDef.OriginalDocumentIdColumnName;

  PerformerIdColumnName :=
    FDocumentChargeSheetTableDef.PerformerIdColumnName;

  ChargeSheetIdColumnName :=
    FDocumentChargeSheetTableDef.IdColumnName;

  TopLevelChargeSheetIdColumnName :=
    FDocumentChargeSheetTableDef.TopLevelChargeSheetIdColumnName;
    
  QueryPattern :=
    Format(
      'WITH RECURSIVE subordinate_charge_sheets (%s) ' +
      'AS (' +
      'SELECT %s ' +
      'FROM %s ' +
      'WHERE %s=%s AND %s=%s ' +
      'UNION ' +
      'SELECT %s ' +
      'FROM %s AS t1 ' +
      'JOIN subordinate_charge_sheets AS t2 ON t1.%s=t2.%s' +
      ') ' +
      'SELECT * FROM subordinate_charge_sheets',
      [
        SelectColumnNameListWithoutTablePrefix,

        SelectColumnNameListWithoutTablePrefix,

        FDBTableMapping.TableName,

        DocumentIdColumnName,
        VarToStr(DocumentId),

        PerformerIdColumnName,
        VarToStr(PerformerId),

        FDBTableMapping.GetSelectListForSelectGroup('t1'),

        FDBTableMapping.TableName,

        TopLevelChargeSheetIdColumnName,
        ChargeSheetIdColumnName
      ]
    );

end;

procedure TDocumentChargeSheetPostgresRepository.PrepareFindDomainObjectsByCriteria(
  Criteria: TAbstractRepositoryCriterion;
  var QueryPattern: String;
  var QueryParams: TQueryParams
);
var
    Criterion:
      TFindAllSubordinateChargeSheetsForGivenChargeSheetCriterion;

    FindOwnAndSubordinateDocumentChargeSheetsForPerformerCriterion:
      TFindOwnAndSubordinateDocumentChargeSheetsForPerformerCriterion;
begin

  if Criteria is TFindAllSubordinateChargeSheetsForGivenChargeSheetCriterion

  then begin

    Criterion := TFindAllSubordinateChargeSheetsForGivenChargeSheetCriterion(Criteria);

    PrepareFetchingAllSubordinateChargeSheetsForGivenChargeSheetQuery(
      Criterion.TargetChargeSheetId, QueryPattern, QueryParams
    );

  end

  else if Criteria is TFindOwnAndSubordinateDocumentChargeSheetsForPerformerCriterion
  then begin

    FindOwnAndSubordinateDocumentChargeSheetsForPerformerCriterion :=
      TFindOwnAndSubordinateDocumentChargeSheetsForPerformerCriterion(Criteria);

    PrepareFetchingOwnAndSubordinateDocumentChargeSheetsForPerformerQuery(
      FindOwnAndSubordinateDocumentChargeSheetsForPerformerCriterion.DocumentId,
      FindOwnAndSubordinateDocumentChargeSheetsForPerformerCriterion.PerformerId,
      QueryPattern,
      QueryParams
    );

  end
       

  else inherited;

end;

procedure TDocumentChargeSheetPostgresRepository.PrepareRemoveDomainObjectListQuery(
  DomainObjectList: TDomainObjectList;
  var QueryPattern: String;
  var QueryParams: TQueryParams
);
var Wrapper: THeadDocumentChargeSheetsWrapper;
begin

  if not (DomainObjectList is THeadDocumentChargeSheetsWrapper) then begin

    inherited PrepareRemoveDomainObjectListQuery(DomainObjectList, QueryPattern, QueryParams);

    Exit;
    
  end;

  Wrapper := DomainObjectList as THeadDocumentChargeSheetsWrapper;

  PrepareRemovingHeadDocumentChargeSheetsQuery(
    Wrapper.HeadChargeSheets, QueryPattern, QueryParams
  );

end;

procedure TDocumentChargeSheetPostgresRepository.PrepareRemoveDomainObjectQuery(
  DomainObject: TDomainObject;
  var QueryPattern: String;
  var QueryParams: TQueryParams
);
var Wrapper: TDocumentIdForRemovingAllRelatedChargeSheetsWrapper;
begin

  if not (DomainObject is TDocumentIdForRemovingAllRelatedChargeSheetsWrapper)
  then begin

    inherited PrepareRemoveDomainObjectQuery(DomainObject, QueryPattern, QueryParams);

    Exit;
    
  end;
  
  Wrapper :=
    DomainObject as TDocumentIdForRemovingAllRelatedChargeSheetsWrapper;

  PrepareRemovingAllChargeSheetsForDocumentQuery(
    Wrapper.DocumentId, QueryPattern, QueryParams
  );

end;

procedure TDocumentChargeSheetPostgresRepository.
  PrepareRemovingAllChargeSheetsForDocumentQuery(
    const DocumentId: Variant;
    var QueryPattern: String;
    var QueryParams: TQueryParams
  );
var
    DocumentIdColumnName: String;
    TopLevelChargeSheetIdColumnName: String;
    QueryText: String;
begin

  DocumentIdColumnName :=
    FDocumentChargeSheetTableDef.OriginalDocumentIdColumnName;

  TopLevelChargeSheetIdColumnName :=
    FDocumentChargeSheetTableDef.TopLevelChargeSheetIdColumnName;
    
  QueryPattern :=
    Format(
      'WITH remove_head_charge_sheets AS (' +
      'UPDATE %s ' +
      'SET %s = NULL ' +
      'WHERE %s = :p%s AND %s IS NULL RETURNING %s ' +
      ') ' +
      'DELETE FROM %s ' +
      'WHERE %s = (SELECT DISTINCT * FROM remove_head_charge_sheets) ' +
      'AND %s IS NOT NULL',
      [
        FDBTableMapping.TableName,

        FDocumentChargeSheetTableDef.IssuerIdColumnName,

        DocumentIdColumnName,
        DocumentIdColumnName,
        TopLevelChargeSheetIdColumnName,
        DocumentIdColumnName,
        
        FDBTableMapping.TableName,
        DocumentIdColumnName,
        TopLevelChargeSheetIdColumnName
      ]
    );
    
  QueryParams := TQueryParams.Create;

  QueryParams.Add('p' + DocumentIdColumnName, DocumentId);

end;

procedure TDocumentChargeSheetPostgresRepository.
  PrepareRemovingHeadDocumentChargeSheetsQuery(
    DocumentChargeSheets: TDocumentChargeSheets;
    var QueryPattern: String;
    var QueryParams: TQueryParams
  );
var
    IdColumnName: String;
    IssuerIdColumnName: String;
    TopLevelChargeSheetIdColumnName: String;
    CommaSeparatedDomainObjectIdentitiesString: String;

    function GetCommaSeparatedDomainObjectIdentitiesString(
      DomainObjectList: TDomainObjectList
    ): String;
    var DomainObject: TDomainObject;
        IdentityString: String;
    begin

      for DomainObject in DomainObjectList do begin

        IdentityString := VarToStr(DomainObject.Identity);

        if Result = '' then
          Result := IdentityString

        else Result := Result + ',' + IdentityString;
        
      end;
        
    end;

begin

  IdColumnName := FDBTableMapping.PrimaryKeyColumnMappings[0].ColumnName;

  IssuerIdColumnName :=
    FDocumentChargeSheetTableDef.IssuerIdColumnName;
        
  TopLevelChargeSheetIdColumnName :=
    FDocumentChargeSheetTableDef.TopLevelChargeSheetIdColumnName;

  CommaSeparatedDomainObjectIdentitiesString :=
    GetCommaSeparatedDomainObjectIdentitiesString(DocumentChargeSheets);

  QueryPattern :=
    Format(
      'UPDATE %s ' +
      'SET %s = NULL ' +
      'WHERE %s IN (%s) and %s IS NULL'
      ,
      [
        FDBTableMapping.TableName,

        IssuerIdColumnName,

        IdColumnName,
        CommaSeparatedDomainObjectIdentitiesString,
        TopLevelChargeSheetIdColumnName
      ]
    );
  
end;

procedure TDocumentChargeSheetPostgresRepository.RemoveAllChargeSheetsForDocument(
  const DocumentId: Variant);
var Wrapper: TDocumentIdForRemovingAllRelatedChargeSheetsWrapper;
begin

  Wrapper :=
    TDocumentIdForRemovingAllRelatedChargeSheetsWrapper.Create(DocumentId);

  try

    Remove(Wrapper);

    ThrowExceptionIfErrorIsNotUnknown;
    
  finally

    FreeAndNil(Wrapper);
    
  end;
    
end;

procedure TDocumentChargeSheetPostgresRepository.RemoveDocumentChargeSheet(
  DocumentChargeSheet: TDocumentChargeSheet
);
begin

  Remove(DocumentChargeSheet);

  ThrowExceptionIfErrorIsNotUnknown;

end;

procedure TDocumentChargeSheetPostgresRepository.RemoveDocumentChargeSheets(
  DocumentChargeSheets: TDocumentChargeSheets
);
var
    HeadDocumentChargeSheets: TDocumentChargeSheets;
    SubordinateDocumentChargeSheets: TDocumentChargeSheets;

    FreeHeadDocumentChargeSheets: IDocumentChargeSheets;
    FreeSubordinateDocumentChargeSheets: IDocumentChargeSheets;
begin

  FetchHeadAndSubordinateDocumentChargeSheets(
    DocumentChargeSheets,
    HeadDocumentChargeSheets,
    SubordinateDocumentChargeSheets
  );

  FreeHeadDocumentChargeSheets := HeadDocumentChargeSheets;
  FreeSubordinateDocumentChargeSheets := SubordinateDocumentChargeSheets;

  RemoveHeadDocumentChargeSheets(HeadDocumentChargeSheets);
  RemoveSubordinateDocumentChargeSheets(SubordinateDocumentChargeSheets);

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

procedure TDocumentChargeSheetPostgresRepository.RemoveDocumentChargeSheetsWithAllSubordinates(
  DocumentChargeSheets: TDocumentChargeSheets);
begin

  { refactor: make removing without using the db removing cascading mechanism }
  
  RemoveDocumentChargeSheets(DocumentChargeSheets);

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

procedure TDocumentChargeSheetPostgresRepository.
  RemoveDocumentChargeSheetWithAllSubordinates(
    DocumentChargeSheet: TDocumentChargeSheet
  );
begin

  { refactor: make removing without using the db removing cascading mechanism }

  RemoveDocumentChargeSheet(DocumentChargeSheet);

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

procedure TDocumentChargeSheetPostgresRepository.
  RemoveHeadDocumentChargeSheets(
    DocumentChargeSheets: TDocumentChargeSheets
  );
var HeadDocumentChargeSheetsWrapper: THeadDocumentChargeSheetsWrapper;
begin

  if DocumentChargeSheets.IsEmpty then Exit;

  HeadDocumentChargeSheetsWrapper :=
    THeadDocumentChargeSheetsWrapper.Create(DocumentChargeSheets);

  try

    RemoveDomainObjectList(HeadDocumentChargeSheetsWrapper);
    
  finally

    FreeAndNil(HeadDocumentChargeSheetsWrapper);
    
  end;

end;

procedure TDocumentChargeSheetPostgresRepository.
  RemoveSubordinateDocumentChargeSheets(
    DocumentChargeSheets: TDocumentChargeSheets
  );
begin

  if DocumentChargeSheets.IsEmpty then Exit;
  
  RemoveDomainObjectList(DocumentChargeSheets);

end;

procedure TDocumentChargeSheetPostgresRepository.UpdateDocumentChargeSheet(
  DocumentChargeSheet: TDocumentChargeSheet);
begin

  Update(DocumentChargeSheet);

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

procedure TDocumentChargeSheetPostgresRepository.UpdateDocumentChargeSheets(
  DocumentChargeSheets: TDocumentChargeSheets);
begin

  if DocumentChargeSheets.IsEmpty then Exit;
  
  UpdateDomainObjectList(DocumentChargeSheets);

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

procedure THeadDocumentChargeSheetsWrapper.Clear;
begin

  
end;

constructor THeadDocumentChargeSheetsWrapper.Create(
  ChargeSheets: TDocumentChargeSheets);
begin

  inherited Create;

  FHeadChargeSheets := ChargeSheets;
  
end;

function THeadDocumentChargeSheetsWrapper.GetDomainObjectByIndex(
  Index: Integer
): TDomainObject;
begin

  Result := TDocumentChargeSheet(FHeadChargeSheets[Index].Self);
  
end;

function THeadDocumentChargeSheetsWrapper.GetDomainObjectCount: Integer;
begin

  Result := FHeadChargeSheets.Count;
  
end;

procedure THeadDocumentChargeSheetsWrapper.SetDomainObjectByIndex(
  Index: Integer; const Value: TDomainObject);
begin

  FHeadChargeSheets[Index] := Value as TDocumentChargeSheet;

end;

{ TFindAllSubordinateChargeSheetsForGivenChargeSheetCriterion }

constructor TFindAllSubordinateChargeSheetsForGivenChargeSheetCriterion.Create(
  const TargetChargeSheetId: Variant;
  Repository: TDocumentChargeSheetPostgresRepository
);
begin

  inherited Create(Repository);

  FTargetChargeSheetId := TargetChargeSheetId;

end;

{ TDocumentIdForRemovingAllRelatedChargeSheetsWrapper }

constructor TDocumentIdForRemovingAllRelatedChargeSheetsWrapper.Create(
  const DocumentId: Variant);
begin

  inherited Create;

  FDocumentId := DocumentId;
  
end;

{ TFindAllChargeSheetsForDocumentCriterion }

constructor TFindAllChargeSheetsForDocumentCriterion.Create(
  const DocumentId: Variant;
  Repository: TDocumentChargeSheetPostgresRepository);
begin

  inherited Create(Repository);

  FDocumentId := DocumentId;

end;

function TFindAllChargeSheetsForDocumentCriterion.GetExpression: String;
var DocumentIdColumnName: String;
begin

  DocumentIdColumnName :=
    FRepository
      .FDocumentChargeSheetTableDef
        .OriginalDocumentIdColumnName;

  Result :=
    Format(
      '%s=%s',
      [
        DocumentIdColumnName,
        VarToStr(DocumentId)
      ]
    );
      
end;

{ TFindDocumentChargeSheetsForPerformerCriterion }

constructor TFindDocumentChargeSheetsForPerformerCriterion.Create(
  const DocumentId, PerformerId: Variant;
  Repository: TDocumentChargeSheetPostgresRepository
);
begin

  inherited Create(Repository);

  FDocumentId := DocumentId;
  FPerformerId := PerformerId;

end;

function TFindDocumentChargeSheetsForPerformerCriterion.GetExpression: String;
var
    DocumentIdColumnName: String;
    PerformerIdColumnName: String;
begin

  DocumentIdColumnName :=
    FRepository
      .FDocumentChargeSheetTableDef
        .OriginalDocumentIdColumnName;

  PerformerIdColumnName :=
    FRepository
      .FDocumentChargeSheetTableDef
        .PerformerIdColumnName;

  Result :=
    Format(
      '%s=%s AND %s=%s',
      [
        DocumentIdColumnName,
        VarToStr(FDocumentId),

        PerformerIdColumnName,
        VarToStr(FPerformerId)
      ]
    );
    
end;

{ TDocumentChargeSheetRepositoryCriterion }

constructor TDocumentChargeSheetRepositoryCriterion.Create(
  Repository: TDocumentChargeSheetPostgresRepository
);
begin

  inherited Create;

  FRepository := Repository;

end;

end.
