unit HistoricalDocumentApprovingPostgresRepository;

interface

uses

  AbstractRepositoryCriteriaUnit,
  DocumentApprovingPostgresRepository,
  DocumentApprovings,
  DomainObjectUnit,
  DomainObjectListUnit,
  DBTableMapping,
  QueryExecutor,
  DataReader,
  SysUtils,
  Classes;

type

  THistoricalDocumentApprovingPostgresRepository =
    class (TDocumentApprovingPostgresRepository)

      protected

        procedure CustomizeTableMapping(
          TableMapping: TDBTableMapping
        ); override;

      protected

        procedure FillDomainObjectFromDataReader(
          DomainObject: TDomainObject;
          DataReader: IDataReader
        ); override;
        
      protected

        function GetCustomWhereClauseForSelect: String; override;
        function GetCustomWhereClauseForDelete: String; override;

      protected

        procedure PrepareRemoveDomainObjectQuery(
          DomainObject: TDomainObject;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        ); virtual;

        procedure PrepareRemovingHistoricalApprovingsForDocumentQuery(
          const DocumentId: Variant;
          const ApprovingCycleId: Variant;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        );
        
      public

        function FindAllHistoricalApprovingsForDocument(
          const DocumentId: Variant
        ): THistoricalDocumentApprovings;

        function FindDocumentHistoricalApprovings(
          const DocumentId: Variant;
          const ApprovingCycleId: Variant
        ): THistoricalDocumentApprovings;

        procedure RemoveHistoricalApprovingsForDocument(
          const DocumentId: Variant;
          const ApprovingCycleId: Variant
        );

        procedure RemoveAllHistoricalDocumentApprovings(
          const DocumentId: Variant
        );

        procedure AddHistoricalDocumentApprovings(
          DocumentApprovings: THistoricalDocumentApprovings
        );

    end;
    
implementation

uses

  Variants,
  DocumentApprovingsTableDef,
  AbstractRepository,
  AbstractDBRepository;

type

  TFindHistoricalDocumentApprovingsForDocumentCriterion =
    class (TAbstractRepositoryCriterion)

      protected

        FDocumentId: Variant;
        FApprovingCycleId: Variant;
        FRepository: THistoricalDocumentApprovingPostgresRepository;

        function GetExpression: String; override;
        
      public

        constructor Create(
          const DocumentId: Variant;
          const ApprovingCycleId: Variant;
          Repository: THistoricalDocumentApprovingPostgresRepository
        );

      published

        property DocumentId: Variant read FDocumentId write FDocumentId;
        
        property ApprovingCycleId: Variant
        read FApprovingCycleId write FApprovingCycleId;

    end;

    TRemovingHistoricalDocumentApprovingsForDocumentWrapper =
      class (TDomainObject)

        protected

          FDocumentId: Variant;
          FApprovingCycleId: Variant;

        public

          constructor Create(
            DocumentId: Variant;
            ApprovingCycleId: Variant
          );

        published

          property DocumentId: Variant read FDocumentId write FDocumentId;
          property ApprovingCycleId: Variant read FApprovingCycleId write FApprovingCycleId;
      
      end;

{ THistoricalDocumentApprovingPostgresRepository }

procedure THistoricalDocumentApprovingPostgresRepository.
  AddHistoricalDocumentApprovings(
    DocumentApprovings: THistoricalDocumentApprovings
  );
begin

  AddDocumentApprovings(DocumentApprovings);
  
end;

procedure THistoricalDocumentApprovingPostgresRepository.
  CustomizeTableMapping(
    TableMapping: TDBTableMapping
  );
begin

  inherited;

  TableMapping.ObjectClass := THistoricalDocumentApproving;
  TableMapping.ObjectListClass := THistoricalDocumentApprovings;
  
  TableMapping.AddColumnMappingForSelect(
    DOCUMENT_APPROVINGS_TABLE_CYCLE_NUMBER_FIELD, 'ApprovingCycleId'
  );
  
  TableMapping.AddColumnMappingForModification(
    DOCUMENT_APPROVINGS_TABLE_CYCLE_NUMBER_FIELD, 'ApprovingCycleId'
  );
  
end;

procedure THistoricalDocumentApprovingPostgresRepository.
  FillDomainObjectFromDataReader(
    DomainObject: TDomainObject;
    DataReader: IDataReader
  );
var
    OriginalApproving: TDocumentApproving;
    HistoricalApproving: THistoricalDocumentApproving;
begin

  OriginalApproving := TDocumentApproving.Create;

  HistoricalApproving := DomainObject as THistoricalDocumentApproving;

  HistoricalApproving.OriginalApproving := OriginalApproving;
  
  inherited;

end;

function THistoricalDocumentApprovingPostgresRepository.
  FindAllHistoricalApprovingsForDocument(
    const DocumentId: Variant
  ): THistoricalDocumentApprovings;
begin

  Result := FindAllApprovingsForDocument(DocumentId) as THistoricalDocumentApprovings;

end;

procedure THistoricalDocumentApprovingPostgresRepository.
  RemoveAllHistoricalDocumentApprovings(
    const DocumentId: Variant
  );
begin

  RemoveAllDocumentApprovings(DocumentId);
  
end;

function THistoricalDocumentApprovingPostgresRepository.
  FindDocumentHistoricalApprovings(
    const DocumentId, ApprovingCycleId: Variant
  ): THistoricalDocumentApprovings;
var DomainObjectList: TDomainObjectList;
    Criteria: TFindHistoricalDocumentApprovingsForDocumentCriterion;
begin

  Criteria :=
    TFindHistoricalDocumentApprovingsForDocumentCriterion.Create(
      DocumentId, ApprovingCycleId, Self
    );

  try

    DomainObjectList := FindDomainObjectsByCriteria(Criteria);

    if not Assigned(DomainObjectList) then
      Result := nil

    else Result := DomainObjectList as THistoricalDocumentApprovings;

  finally

    FreeAndNil(Criteria);
    
  end;

end;

procedure THistoricalDocumentApprovingPostgresRepository.
  RemoveHistoricalApprovingsForDocument(
    const DocumentId, ApprovingCycleId: Variant
  );
var Wrapper: TRemovingHistoricalDocumentApprovingsForDocumentWrapper;
begin

  Wrapper :=
    TRemovingHistoricalDocumentApprovingsForDocumentWrapper.Create(
      DocumentId, ApprovingCycleId
    );

  try

    Remove(Wrapper);
    
  finally

    FreeAndNil(Wrapper);
    
  end;

end;

function THistoricalDocumentApprovingPostgresRepository.
  GetCustomWhereClauseForDelete: String;
begin

  Result :=
    DOCUMENT_APPROVINGS_TABLE_CYCLE_NUMBER_FIELD + ' IS NOT NULL';
    
end;

function THistoricalDocumentApprovingPostgresRepository.
  GetCustomWhereClauseForSelect: String;
begin

  Result :=
    DOCUMENT_APPROVINGS_TABLE_CYCLE_NUMBER_FIELD + ' IS NOT NULL';
    
end;

procedure THistoricalDocumentApprovingPostgresRepository.
  PrepareRemoveDomainObjectQuery(
    DomainObject: TDomainObject;
    var QueryPattern: String;
    var QueryParams: TQueryParams
  );
var Wrapper: TRemovingHistoricalDocumentApprovingsForDocumentWrapper;
begin

  if
    not (DomainObject is TRemovingHistoricalDocumentApprovingsForDocumentWrapper)
  then begin

    inherited;

    Exit;

  end;

  Wrapper := DomainObject as
             TRemovingHistoricalDocumentApprovingsForDocumentWrapper;

  PrepareRemovingHistoricalApprovingsForDocumentQuery(
    Wrapper.DocumentId, Wrapper.ApprovingCycleId, QueryPattern, QueryParams
  );

end;

procedure THistoricalDocumentApprovingPostgresRepository.
  PrepareRemovingHistoricalApprovingsForDocumentQuery(
    const DocumentId, ApprovingCycleId: Variant;
    var QueryPattern: String;
    var QueryParams: TQueryParams
  );
var
    DocumentIdColumnName, ApprovingCycleIdColumnName: String;
begin

  DocumentIdColumnName :=

    FDBTableMapping.
      ColumnMappingsForModification.
        FindColumnMappingByObjectPropertyName(
          'DocumentId'
        ).ColumnName;

  ApprovingCycleIdColumnName :=

    FDBTableMapping.
      ColumnMappingsForModification.
        FindColumnMappingByObjectPropertyName(
          'ApprovingCycleId'
        ).ColumnName;

  QueryPattern :=
    Format(
      'DELETE FROM %s WHERE %s=:p%s AND %s=:%s',
      [
        FDBTableMapping.TableName,
        DocumentIdColumnName,
        DocumentIdColumnName,
        ApprovingCycleIdColumnName,
        ApprovingCycleIdColumnName
      ]
    );

  QueryParams := TQueryParams.Create;


  QueryParams
    .AddFluently('p' + DocumentIdColumnName, DocumentId)
    .AddFluently('p' + ApprovingCycleIdColumnName, ApprovingCycleId);
  
end;

{ TFindHistoricalDocumentApprovingsForDocumentCriterion }

constructor TFindHistoricalDocumentApprovingsForDocumentCriterion.Create(
  const DocumentId, ApprovingCycleId: Variant;
  Repository: THistoricalDocumentApprovingPostgresRepository);
begin

  inherited Create;

  FDocumentId := DocumentId;
  FApprovingCycleId := ApprovingCycleId;
  FRepository := Repository;

end;

function TFindHistoricalDocumentApprovingsForDocumentCriterion.
  GetExpression: String;
var DocumentIdColumnName: String;
    ApprovingCycleIdColumnName: String;
begin

  DocumentIdColumnName :=
    FRepository.
      TableMapping.
        ColumnMappingsForSelect.
          FindColumnMappingByObjectPropertyName(
            'DocumentId'
          ).ColumnName;

  ApprovingCycleIdColumnName :=
    FRepository.
      TableMapping.
        ColumnMappingsForSelect.
          FindColumnMappingByObjectPropertyName(
            'ApprovingCycleId'
          ).ColumnName;

  Result :=
    Format(
      '%s=%s AND %s=%s',
      [
        DocumentIdColumnName,
        VarToStr(FDocumentId),
        ApprovingCycleIdColumnName,
        VarToStr(FApprovingCycleId)
      ]
    );

end;

{ TRemovingHistoricalDocumentApprovingsForDocumentWrapper }

constructor TRemovingHistoricalDocumentApprovingsForDocumentWrapper.Create(
  DocumentId, ApprovingCycleId: Variant);
begin

  inherited Create;

  FDocumentId := DocumentId;
  FApprovingCycleId := ApprovingCycleId;
  
end;

end.
