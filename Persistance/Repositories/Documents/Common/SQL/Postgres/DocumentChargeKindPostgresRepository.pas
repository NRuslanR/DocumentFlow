unit DocumentChargeKindPostgresRepository;

interface

uses

  DocumentChargeKindRepository,
  DocumentChargeKind,
  AbstractPostgresRepository,
  AbstractRepository,
  AbstractDBRepository,
  TableColumnMappings,
  DBTableMapping,
  DataReader,
  DomainObjectUnit,
  DomainObjectListUnit,
  DocumentChargeKindTableDef,
  AbstractRepositoryCriteriaUnit,
  QueryExecutor,
  Disposable,
  SysUtils;

type

  TDocumentChargeKindPostgresRepository = class;
  
  TAllowedChargeKindsForDocumentKindCriterion =
    class (TAbstractRepositoryCriterion)

      private

        FRepository: TDocumentChargeKindPostgresRepository;
        FDocumentKindId: Variant;

      protected

        function GetExpression: String; override;

      public

        constructor Create(
          Repository: TDocumentChargeKindPostgresRepository;
          const DocumentKindId: Variant
        );

        property DocumentKindId: Variant read FDocumentKindId write FDocumentKindId;

  end;

  TDocumentChargeKindPostgresRepository =
    class (TAbstractPostgresRepository, IDocumentChargeKindRepository)

      private

        FDocumentChargeKindTableDef: TDocumentChargeKindTableDef;
        FFreeDocumentChargeKindTableDef: IDisposable;

      protected

        procedure CustomizeTableMapping(
          TableMapping: TDBTableMapping
        ); override;

      protected

        procedure PrepareFindDomainObjectsByCriteria(
          Criteria: TAbstractRepositoryCriterion;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        ); override;

        procedure PrepareFindAllowedDocumentChargeKindsForDocumentKind(
          var QueryPattern: String;
          var QueryParams: TQueryParams;
          Criteria: TAllowedChargeKindsForDocumentKindCriterion
        );

        procedure FillDomainObjectFromDataReader(
          DomainObject: TDomainObject;
          DataReader: IDataReader
        ); override;
        
      public

        constructor Create(
          QueryExecutor: IQueryExecutor;
          DocumentChargeKindTableDef: TDocumentChargeKindTableDef
        );

        function GetSelf: TObject;
        
        function FindAllDocumentChargeKinds: TDocumentChargeKinds;
        function FindDocumentChargeKindById(const ChargeKindId: Variant): TDocumentChargeKind;

        function FindAllowedDocumentChargeKindsForDocumentKind(const DocumentKindId: Variant): TDocumentChargeKinds;
        
        procedure AddDocumentChargeKind(DocumentChargeKind: TDocumentChargeKind);
        procedure AddDocumentChargeKinds(DocumentChargeKinds: TDocumentChargeKinds);

        procedure UpdateDocumentChargeKind(DocumentChargeKind: TDocumentChargeKind);
        procedure UpdateDocumentChargeKinds(DocumentChargeKinds: TDocumentChargeKinds);

        procedure RemoveDocumentChargeKind(DocumentChargeKind: TDocumentChargeKind);
        procedure RemoveDocumentChargeKinds(DocumentChargeKinds: TDocumentChargeKinds);

    end;
    
implementation

uses

  StrUtils,
  TableMapping,
  DocumentAcquaitance,
  DocumentPerforming;

{ TDocumentChargeKindPostgresRepository }

constructor TDocumentChargeKindPostgresRepository.Create(
  QueryExecutor: IQueryExecutor;
  DocumentChargeKindTableDef: TDocumentChargeKindTableDef);
begin

  inherited Create(QueryExecutor);

  FDocumentChargeKindTableDef := DocumentChargeKindTableDef;
  FFreeDocumentChargeKindTableDef := FDocumentChargeKindTableDef;

  CustomizeTableMapping(FDBTableMapping);
  
end;

procedure TDocumentChargeKindPostgresRepository.CustomizeTableMapping(
  TableMapping: TDBTableMapping);
begin

  if not Assigned(FDocumentChargeKindTableDef) then Exit;
  
  inherited CustomizeTableMapping(TableMapping);

  with FDocumentChargeKindTableDef, TableMapping do begin

    SetTableNameMapping(
      FDocumentChargeKindTableDef.TableName,
      TDocumentChargeKind,
      TDocumentChargeKinds
    );

    begin

      AddColumnMappingForSelect(IdColumnName, 'Identity');
      AddColumnMappingForSelect(NameColumnName, 'Name');
      AddColumnMappingForSelect(ServiceNameColumnName, 'ServiceName');
      
    end;

    begin

      AddColumnMappingForModification(NameColumnName, 'Name');
      AddColumnMappingForModification(ServiceNameColumnName, 'ServiceName');

    end;

    begin

      AddPrimaryKeyColumnMapping(IdColumnName, 'Identity');
      
    end;
    
  end;

end;

procedure TDocumentChargeKindPostgresRepository.AddDocumentChargeKind(
  DocumentChargeKind: TDocumentChargeKind);
begin

  Add(DocumentChargeKind);

  ThrowExceptionWithInformativeMessageIfHasError;

end;

procedure TDocumentChargeKindPostgresRepository.AddDocumentChargeKinds(
  DocumentChargeKinds: TDocumentChargeKinds);
begin

  AddDomainObjectList(DocumentChargeKinds);

  ThrowExceptionWithInformativeMessageIfHasError;

end;

procedure TDocumentChargeKindPostgresRepository.FillDomainObjectFromDataReader(
  DomainObject: TDomainObject;
  DataReader: IDataReader
);
begin

  inherited FillDomainObjectFromDataReader(DomainObject, DataReader);

  with TDocumentChargeKind(DomainObject) do begin

    if ServiceName = 'performing' then
      ChargeClass := TDocumentPerforming

    else if ServiceName = 'acquaitance' then
      ChargeClass := TDocumentAcquaitance

    else Raise Exception.Create('Обнаружено неожидаемое служебное наименование типа поручения');
         
  end;

end;

function TDocumentChargeKindPostgresRepository.FindAllDocumentChargeKinds: TDocumentChargeKinds;
begin

  Result := TDocumentChargeKinds(LoadAll);

  ThrowExceptionWithInformativeMessageIfHasError;

end;

function TDocumentChargeKindPostgresRepository.FindAllowedDocumentChargeKindsForDocumentKind(
  const DocumentKindId: Variant): TDocumentChargeKinds;
var
    Criteria: TAllowedChargeKindsForDocumentKindCriterion;
begin

  Criteria := TAllowedChargeKindsForDocumentKindCriterion.Create(Self, DocumentKindId);

  try

    Result := TDocumentChargeKinds(FindDomainObjectsByCriteria(Criteria));

    ThrowExceptionIfErrorIsNotUnknown;
    
  finally

    FreeAndNil(Criteria);
    
  end;

end;

function TDocumentChargeKindPostgresRepository.FindDocumentChargeKindById(
  const ChargeKindId: Variant): TDocumentChargeKind;
begin

  Result := TDocumentChargeKind(FindDomainObjectByIdentity(ChargeKindId));

  ThrowExceptionWithInformativeMessageIfHasError;

end;

function TDocumentChargeKindPostgresRepository.GetSelf: TObject;
begin

  Result := Self;
  
end;

procedure TDocumentChargeKindPostgresRepository.PrepareFindDomainObjectsByCriteria(
  Criteria: TAbstractRepositoryCriterion;
  var QueryPattern: String;
  var QueryParams: TQueryParams
);
begin

  if Criteria is TAllowedChargeKindsForDocumentKindCriterion then begin

    PrepareFindAllowedDocumentChargeKindsForDocumentKind(
      QueryPattern,
      QueryParams,
      TAllowedChargeKindsForDocumentKindCriterion(Criteria)
    );

  end

  else begin

    inherited PrepareFindDomainObjectsByCriteria(
      Criteria, QueryPattern, QueryParams
    );
    
  end;

end;

procedure TDocumentChargeKindPostgresRepository.PrepareFindAllowedDocumentChargeKindsForDocumentKind(
  var QueryPattern: String;
  var QueryParams: TQueryParams;
  Criteria: TAllowedChargeKindsForDocumentKindCriterion
);
var
    TableName: String;
    SelectList: String;
    CriteriaWhereClause, CustomWhereClause: String;
begin

  {
    refactor(DocumentChargeKindPostgresRepository, 1):
    разбить метод PrepareFindDomainObjectsByCriteria предкового класса
    на несколько методов, с помощью которых можно будет в наследниках
    переопределить наименования таблиц, список столбцов, выражение where
    и прочие, для исключения необходимости копировать весь код метода
    для внесения некоторых изменений
  }

  TableName := GetTableNameFromTableMappingForSelect;
  SelectList := GetSelectListFromTableMappingForSelectGroup;
  CustomWhereClause := GetCustomWhereClauseForSelect;

  CriteriaWhereClause := Criteria.Expression;

  if CustomWhereClause <> '' then
    CriteriaWhereClause := CriteriaWhereClause + ' AND ' + CustomWhereClause;

  CriteriaWhereClause :=
    IfThen(
      (CriteriaWhereClause <> '') and (CustomWhereClause <> ''),
      CriteriaWhereClause + ' AND ' + CustomWhereClause,
      IfThen(
        CriteriaWhereClause <> '',
        CriteriaWhereClause,
        CustomWhereClause
      )
    );
  {
    refactor(DocumentChargeKindPostgresRepository, 2):
    получать наименования элементов БД объектом в конструктор
  }

  QueryPattern :=
    Format(
      'SELECT %s ' +
      'FROM %s ' +
      'WHERE %s = any(' +
      'select ' +
      'document_charge_type_id ' +
      'FROM doc.document_types_allowable_document_charges_types ' +
      'WHERE %s)',
      [
       SelectList,
       TableName,
       FDocumentChargeKindTableDef.IdColumnName,
       CriteriaWhereClause
      ]
    )
    + ' ' + GetCustomTrailingSelectQueryTextPart;

  QueryParams := TQueryParams.Create;

  QueryParams.Add('pdocument_type_id', Criteria.DocumentKindId);

end;

procedure TDocumentChargeKindPostgresRepository.RemoveDocumentChargeKind(
  DocumentChargeKind: TDocumentChargeKind);
begin

  Remove(DocumentChargeKind);

  ThrowExceptionWithInformativeMessageIfHasError;

end;

procedure TDocumentChargeKindPostgresRepository.RemoveDocumentChargeKinds(
  DocumentChargeKinds: TDocumentChargeKinds);
begin

  RemoveDomainObjectList(DocumentChargeKinds);

  ThrowExceptionWithInformativeMessageIfHasError;

end;

procedure TDocumentChargeKindPostgresRepository.UpdateDocumentChargeKind(
  DocumentChargeKind: TDocumentChargeKind);
begin

  Update(DocumentChargeKind);

  ThrowExceptionWithInformativeMessageIfHasError;

end;

procedure TDocumentChargeKindPostgresRepository.UpdateDocumentChargeKinds(
  DocumentChargeKinds: TDocumentChargeKinds);
begin

  UpdateDomainObjectList(DocumentChargeKinds);

  ThrowExceptionWithInformativeMessageIfHasError;
  
end;

{ TAllowedChargeKindsForDocumentKindCriterion }

constructor TAllowedChargeKindsForDocumentKindCriterion.Create(
  Repository: TDocumentChargeKindPostgresRepository;
  const DocumentKindId: Variant);
begin

  inherited Create;

  FRepository := Repository;
  FDocumentKindId := DocumentKindId;
  
end;

function TAllowedChargeKindsForDocumentKindCriterion.GetExpression: String;
begin

  Result := 'document_type_id=:pdocument_type_id';
  
end;

end.
