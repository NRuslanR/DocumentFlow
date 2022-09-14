unit DocumentWorkCycleStagesPostgresRepository;

interface

uses

  AbstractPostgresRepository,
  AbstractRepositoryCriteriaUnit,
  DocumentWorkCycleStagesRepository,
  DocumentTypeStageTableDef,
  QueryExecutor,
  Disposable,
  DocumentWorkCycle,
  DBTableMapping,
  VariantListUnit,
  Classes,
  SysUtils;

type

  TDocumentWorkCycleStagesPostgresRepository =
    class (TAbstractPostgresRepository, IDocumentWorkCycleStagesRepository)

      protected

        FDocumentTypeStageTableDef: TDocumentTypeStageTableDef;
        FFreeDocumentTypeStageTableDef: IDisposable;
        
        procedure CustomizeTableMapping(
          TableMapping: TDBTableMapping
        ); override;

        function GetCustomTrailingSelectQueryTextPart: String; override;
        
      public

        constructor Create(
          QueryExecutor: IQueryExecutor;
          DocumentTypeStageTableDef: TDocumentTypeStageTableDef
        );
        
        function FindWorkCycleStagesForDocumentKind(
          const DocumentKindId: Variant
        ): TDocumentWorkCycleStages;
        
        function FindDocumentWorkCycleStageByDocumentKindAndStageNumber(
          const DocumentKindId: Variant;
          const StageNumber: Integer
        ): TDocumentWorkCycleStage;
        
    end;

implementation

uses

  SQLAllMultiFieldsEqualityCriterion,
  SQLCastingFunctions,
  StrUtils,
  AbstractDBRepository,
  TableColumnMappings,
  AbstractRepository;

type

  TDocumentWorkCycleStagesRepositoryCriterion =
    class abstract (TAbstractRepositoryCriterion)

      protected

        FRepository: TDocumentWorkCycleStagesPostgresRepository;

      public

        constructor Create(Repository: TDocumentWorkCycleStagesPostgresRepository);

    end;

    TDocumentWorkCycleStagesMultiFieldsEqualityRepositoryCriterion =
      class (TSQLAllMultiFieldsEqualityCriterion)

        protected

          FRepository: TDocumentWorkCycleStagesPostgresRepository;

        public

          constructor Create(
            Repository: TDocumentWorkCycleStagesPostgresRepository;
            FieldNames: array of String;
            FieldValues: array of Variant
          );

      end;

    TFindDocumentWorkCycleStageByDocumentKindAndStageNumberCriterion =
      class (TDocumentWorkCycleStagesMultiFieldsEqualityRepositoryCriterion)

        public

          constructor Create(
            Repository: TDocumentWorkCycleStagesPostgresRepository;
            const DocumentKindId: Variant;
            const StageNumber: Integer
          );
          
      end;

    TFindWorkCycleStagesForDocumentKindCriterion =
      class (TDocumentWorkCycleStagesMultiFieldsEqualityRepositoryCriterion)

        public

          constructor Create(
            Repository: TDocumentWorkCycleStagesPostgresRepository;
            const DocumentKindId: Variant
          );
          
      end;
      
{ TDocumentWorkCycleStagesPostgresRepository }

constructor TDocumentWorkCycleStagesPostgresRepository.Create(
  QueryExecutor: IQueryExecutor;
  DocumentTypeStageTableDef: TDocumentTypeStageTableDef
);
begin

  inherited Create(QueryExecutor);

  FDocumentTypeStageTableDef := DocumentTypeStageTableDef;
  FFreeDocumentTypeStageTableDef := FDocumentTypeStageTableDef;

  CustomizeTableMapping(FDBTableMapping);
  
end;

procedure TDocumentWorkCycleStagesPostgresRepository.CustomizeTableMapping(
  TableMapping: TDBTableMapping);
begin

  if not Assigned(FDocumentTypeStageTableDef) then Exit;
  
  inherited;

  with FDocumentTypeStageTableDef, TableMapping do begin

    AddColumnMappingForSelect(IdColumnName, 'Identity');
    AddColumnMappingForSelect(DocumentTypeIdColumnName, 'DocumentKindId');
    AddColumnMappingForSelect(StageNumberColumnName, 'Number');
    AddColumnMappingForSelect(StageNameColumnName, 'Name');
    AddColumnMappingForSelect(ServiceStageNameColumnName, 'ServiceName');

    AddColumnMappingForModification(DocumentTypeIdColumnName, 'DocumentKindId');
    AddColumnMappingForModification(StageNumberColumnName, 'Number');
    AddColumnMappingForModification(StageNameColumnName, 'Name');
    AddColumnMappingForModification(ServiceStageNameColumnName, 'ServiceName');
    
    AddPrimaryKeyColumnMapping(IdColumnName, 'Identity');
    
  end;

  with FDocumentTypeStageTableDef do begin

    TableMapping.SetTableNameMapping(
      TableName, TDocumentWorkCycleStage, TDocumentWorkCycleStages
    );
  
  end;

end;

function TDocumentWorkCycleStagesPostgresRepository.FindDocumentWorkCycleStageByDocumentKindAndStageNumber(
  const DocumentKindId: Variant;
  const StageNumber: Integer
): TDocumentWorkCycleStage;
var
    Criteria: TFindDocumentWorkCycleStageByDocumentKindAndStageNumberCriterion;
    Stages: TDocumentWorkCycleStages;
begin

  Criteria :=
    TFindDocumentWorkCycleStageByDocumentKindAndStageNumberCriterion.Create(
      Self, DocumentKindId, StageNumber
    );

  try

    Stages := TDocumentWorkCycleStages(FindDomainObjectsByCriteria(Criteria));

    if not Assigned(Stages) then
      Result := nil

    else if Stages.Count > 1 then begin

      raise Exception.Create(
        'Для данного вида документов и номера стадии рабочего цикла ' +
        'найдено несколько стадий'
      );
      
    end

    else Result := TDocumentWorkCycleStage(Stages.First.Clone);

  finally

    FreeAndNil(Criteria);
    
  end;

end;

function TDocumentWorkCycleStagesPostgresRepository.
  FindWorkCycleStagesForDocumentKind(
    const DocumentKindId: Variant
  ): TDocumentWorkCycleStages;
var
    Criteria: TFindWorkCycleStagesForDocumentKindCriterion;
begin

  Criteria :=
    TFindWorkCycleStagesForDocumentKindCriterion.Create(Self, DocumentKindId);

  try

    Result := TDocumentWorkCycleStages(FindDomainObjectsByCriteria(Criteria));
    
  finally

    FreeAndNil(Criteria);

  end;

end;

function TDocumentWorkCycleStagesPostgresRepository.GetCustomTrailingSelectQueryTextPart: String;
var
    StageNumberColumnName: String;
begin

  StageNumberColumnName :=
    FDBTableMapping
      .FindSelectColumnMappingByObjectPropertyName('Number')
        .ColumnName;

  Result := ' ORDER BY ' + StageNumberColumnName;
  
end;

{ TDocumentWorkCycleStagesRepositoryCriterion }

constructor TDocumentWorkCycleStagesRepositoryCriterion.Create(
  Repository: TDocumentWorkCycleStagesPostgresRepository);
begin

  inherited Create;

  FRepository := Repository;
  
end;

{ TFindDocumentWorkCycleStageByDocumentKindAndStageNumberCriterion }

constructor TFindDocumentWorkCycleStageByDocumentKindAndStageNumberCriterion.
  Create(
    Repository: TDocumentWorkCycleStagesPostgresRepository;
    const DocumentKindId: Variant;
    const StageNumber: Integer
  );
var
    DocumentKindIdColumnName,
    StageNumberColumnName: String;
begin

  DocumentKindIdColumnName :=
    Repository
      .TableMapping
        .FindSelectColumnMappingByObjectPropertyName('DocumentKindId')
          .ColumnName;

  StageNumberColumnName :=
    Repository
      .TableMapping
        .FindSelectColumnMappingByObjectPropertyName('Number')
          .ColumnName;
  
  inherited Create(
    Repository,
    [DocumentKindIdColumnName, StageNumberColumnName],
    [DocumentKindId, StageNumber]
  );

end;

{ TFindWorkCycleStagesForDocumentKindCriterion }

constructor TFindWorkCycleStagesForDocumentKindCriterion.Create(
  Repository: TDocumentWorkCycleStagesPostgresRepository;
  const DocumentKindId: Variant
);
var
    DocumentKindIdColumnName: String;
begin
  
  DocumentKindIdColumnName :=
    Repository
      .TableMapping
        .FindSelectColumnMappingByObjectPropertyName(
          'DocumentKindId'
        ).ColumnName;


  inherited Create(Repository, [DocumentKindIdColumnName], [DocumentKindId]);

end;

{ TDocumentWorkCycleStagesMultiFieldsEqualityRepositoryCriterion }

constructor TDocumentWorkCycleStagesMultiFieldsEqualityRepositoryCriterion.Create(
  Repository: TDocumentWorkCycleStagesPostgresRepository;
  FieldNames: array of String;
  FieldValues: array of Variant
);
begin

  inherited Create(FieldNames, FieldValues);

  FRepository := Repository;
  
end;

end.
