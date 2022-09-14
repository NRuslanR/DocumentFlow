unit DocumentRelationsPostgresRepository;

interface

uses

  DomainObjectUnit,
  DomainObjectListUnit,
  Document,
  DocumentRelationsUnit,
  AbstractDBRepository,
  DBTableMapping,
  AbstractPostgresRepository,
  DocumentRelationsRepository,
  AbstractRepositoryCriteriaUnit,
  DocumentRelationsTableDef,
  Disposable,
  QueryExecutor,
  DataReader,
  SysUtils,
  Classes;

type

  TDocumentRelationsWrapper = class (TDomainObject)

    private

      DocumentRelations: TDocumentRelations;

      constructor Create(DocumentRelations: TDocumentRelations);
      
  end;

  TDocumentRelationsWrapperList = class (TDomainObjectList)

    private

      FDocumentRelations: TDocumentRelations;

    public

      constructor Create;

      property DocumentRelations: TDocumentRelations
      read FDocumentRelations write FDocumentRelations;
      
  end;

  TDocumentRelationsPostgresRepository = class;

  TFindRelationsByDocumentIdCriterion = class (TAbstractRepositoryCriterion)

    protected

      FDocumentRelationsPostgresRepository:
        TDocumentRelationsPostgresRepository;
      FDocumentId: Variant;
      
      function GetExpression: String; override;

    public

      constructor Create(
        DocumentRelationsPostgresRepository:
          TDocumentRelationsPostgresRepository;
        const DocumentId: Variant
      );

  end;

  TFindRelationsByDocumentIdCriterionClass =
    class of TFindRelationsByDocumentIdCriterion;

  TDocumentRelationsPostgresRepository =
    class (TAbstractPostgresRepository, IDocumentRelationsRepository)

      private

        type

          TDocumentRelationsOperation = (

            None,
            AddingDocumentRelations,
            RemovingDocumentRelations,
            RemovingAllRelationsForDocument

          );

      private

        FDocumentRelationsTableDef: TDocumentRelationsTableDef;
        FFreeDocumentRelationsTableDef: IDisposable;
        
        FCurrentSpecificDocumentRelationsOperation: TDocumentRelationsOperation;

        function ConstructQueryTextForAddingDocumentRelations(
          DocumentRelations: TDocumentRelations
        ): String;

        function IsCurrentOperationTheRemovingDocumentRelations: Boolean;

        function ConstructQueryTextForRemovingSomeDocumentRelations(
          DocumentRelations: TDocumentRelations
        ): String;

        function ConstructQueryTextForRemovingAllRelationsForDocument(
          const TargetDocumentId: Variant
        ): String;

      protected
      
        procedure PrepareAddDomainObjectQuery(
          DomainObject: TDomainObject;
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

        procedure FillDomainObjectListFromDataReader(
          DomainObjects: TDomainObjectList;
          DataReader: IDataReader
        ); override;

        function CreateDomainObjectList(DataReader: IDataReader): TDomainObjectList; override;
        
        function InternalUpdate(DomainObject: TDomainObject): Boolean; override;
        function InternalFindDomainObjectByIdentity(Identity: Variant): TDomainObject; override;
        function InternalLoadAll: TDomainObjectList; override;

      protected

        function CreateFetchingDocumentRelationsQuery(
          FindRelationsByDocumentIdCriterion: TFindRelationsByDocumentIdCriterion
        ): String; virtual;

      public

        constructor Create(
          QueryExecutor: IQueryExecutor;
          DocumentRelationsTableDef: TDocumentRelationsTableDef
        );
        
        procedure AddDocumentRelations(DocumentRelations: TDocumentRelations); virtual;
        procedure RemoveDocumentRelations(DocumentRelations: TDocumentRelations); virtual;
        procedure RemoveAllRelationsForDocument(const DocumentId: Variant); virtual;
        function FindRelationsForDocument(const DocumentId: Variant): TDocumentRelations; virtual;

    end;


implementation

uses

  DB,
  ServiceNote,
  IncomingServiceNote,
  IDomainObjectBaseListUnit,
  InternalServiceNote,
  IncomingInternalServiceNote,
  Variants,
  AbstractRepository;

{ TDocumentRelationsPostgresRepository }

constructor TDocumentRelationsPostgresRepository.Create(
  QueryExecutor: IQueryExecutor;
  DocumentRelationsTableDef: TDocumentRelationsTableDef);
begin

  inherited Create(QueryExecutor);

  FDocumentRelationsTableDef := DocumentRelationsTableDef;
  FFreeDocumentRelationsTableDef := FDocumentRelationsTableDef;
  
  CustomizeTableMapping(FDBTableMapping);
  
end;

function TDocumentRelationsPostgresRepository.CreateDomainObjectList(DataReader: IDataReader): TDomainObjectList;
begin

  Result := TDocumentRelationsWrapperList.Create;
  
end;

function TDocumentRelationsPostgresRepository.
  CreateFetchingDocumentRelationsQuery(
    FindRelationsByDocumentIdCriterion:
      TFindRelationsByDocumentIdCriterion
  ): String;
begin

  Result :=
    Format(
      'SELECT %s,%s,%s FROM %s WHERE %s',
      [
        FDocumentRelationsTableDef.TargetDocumentIdColumnName,
        FDocumentRelationsTableDef.RelatedDocumentIdColumnName,
        FDocumentRelationsTableDef.RelatedDocumentTypeIdColumnName,
        FDocumentRelationsTableDef.TableName,
        FindRelationsByDocumentIdCriterion.Expression
      ]
    );

end;

procedure TDocumentRelationsPostgresRepository.
  FillDomainObjectListFromDataReader(
    DomainObjects: TDomainObjectList;
    DataReader: IDataReader
  );
var
    DocumentRelationWrapperList: TDocumentRelationsWrapperList;
    DocumentRelations: TDocumentRelations;
begin

  if DataReader.RecordCount = 0 then Exit;

  DocumentRelations := nil;
  
  DocumentRelationWrapperList :=
    DomainObjects as TDocumentRelationsWrapperList;

  while DataReader.Next do begin

    if not Assigned(DocumentRelations) then begin

      DocumentRelations :=
        TDocumentRelations.Create(
          DataReader[FDocumentRelationsTableDef.TargetDocumentIdColumnName]
        );
        
    end;

    DocumentRelations.AddRelation(
      DataReader[FDocumentRelationsTableDef.RelatedDocumentIdColumnName],
      DataReader[FDocumentRelationsTableDef.RelatedDocumentTypeIdColumnName]
    );

  end;

  DocumentRelationWrapperList.DocumentRelations := DocumentRelations;

end;

function TDocumentRelationsPostgresRepository.FindRelationsForDocument(
  const DocumentId: Variant
): TDocumentRelations;
var FindRelationsByDocumentIdCriterion:
      TFindRelationsByDocumentIdCriterion;

  DomainObjectList: TDomainObjectList;
  Free: IDomainObjectBaseList;
begin

  FindRelationsByDocumentIdCriterion :=
    TFindRelationsByDocumentIdCriterion.Create(Self, DocumentId);

  try

    DomainObjectList :=
      FindDomainObjectsByCriteria(FindRelationsByDocumentIdCriterion);

    if Assigned(DomainObjectList) then begin

      Free := DomainObjectList;
      
      Result :=
        (DomainObjectList as TDocumentRelationsWrapperList).DocumentRelations;

    end

    else Result := nil;

    ThrowExceptionIfErrorIsNotUnknown;

  finally

    FreeAndNil(FindRelationsByDocumentIdCriterion);
    
  end;

end;

function TDocumentRelationsPostgresRepository.InternalFindDomainObjectByIdentity(
  Identity: Variant
): TDomainObject;
begin

  raise Exception.Create(
          'В хранилище отсутствует возможность выборки ' +
          'связанных документов'
        );

end;

function TDocumentRelationsPostgresRepository.InternalLoadAll: TDomainObjectList;
begin

  raise Exception.Create(
          'В хранилище отсутствует возможность выборки ' +
          'связанных документов'
        );

end;

function TDocumentRelationsPostgresRepository.InternalUpdate(
  DomainObject: TDomainObject): Boolean;
begin

  raise Exception.Create(
          'В хранилище отсутствует возможность изменения ' +
          'связей между документами'
        );
        
end;

function TDocumentRelationsPostgresRepository.IsCurrentOperationTheRemovingDocumentRelations: Boolean;
begin

  Result := FCurrentSpecificDocumentRelationsOperation in
            [
              RemovingDocumentRelations,
              RemovingAllRelationsForDocument
            ];
            
end;

procedure TDocumentRelationsPostgresRepository.AddDocumentRelations(
  DocumentRelations: TDocumentRelations
);
var DocumentRelationsWrapper: TDocumentRelationsWrapper;
begin

  if DocumentRelations.RelationCount = 0 then Exit;
  
  FCurrentSpecificDocumentRelationsOperation := AddingDocumentRelations;

  DocumentRelationsWrapper :=
    TDocumentRelationsWrapper.Create(DocumentRelations);

  Add(DocumentRelationsWrapper);
  
  DocumentRelationsWrapper.Free;

  FCurrentSpecificDocumentRelationsOperation := None;

  ThrowExceptionIfErrorIsNotUnknown;

end;

procedure TDocumentRelationsPostgresRepository.PrepareAddDomainObjectQuery(
  DomainObject: TDomainObject;
  var QueryPattern: String;
  var QueryParams: TQueryParams
);
begin

  if FCurrentSpecificDocumentRelationsOperation = AddingDocumentRelations
  then begin

    QueryPattern :=
      ConstructQueryTextForAddingDocumentRelations(
        (DomainObject as TDocumentRelationsWrapper).DocumentRelations
      );

  end

  else inherited;

end;

procedure TDocumentRelationsPostgresRepository.
  PrepareFindDomainObjectsByCriteria(
    Criteria: TAbstractRepositoryCriterion;
    var QueryPattern: String;
    var QueryParams: TQueryParams
  );
var FindRelationsByDocumentIdCriterion:
      TFindRelationsByDocumentIdCriterion;
begin

  if not (Criteria is TFindRelationsByDocumentIdCriterion) then begin

    inherited;
    
    Exit;

  end;

  FindRelationsByDocumentIdCriterion :=
    Criteria as TFindRelationsByDocumentIdCriterion;

  QueryPattern :=
    CreateFetchingDocumentRelationsQuery(
      FindRelationsByDocumentIdCriterion
    );
  
end;

function TDocumentRelationsPostgresRepository.ConstructQueryTextForAddingDocumentRelations(
  DocumentRelations: TDocumentRelations
): String;
var
    ValueListString: String;
    RelatedDocumentInfo: Variant;
    RelatedDocumentId, RelatedDocumentTypeId: Variant;
begin

  Result := '';

  for RelatedDocumentInfo in DocumentRelations.RelatedDocumentInfoList do begin

    RelatedDocumentId := RelatedDocumentInfo[0];
    RelatedDocumentTypeId := RelatedDocumentInfo[1];
    
    ValueListString :=
      Format(
        '(%s,%s,%s)',
        [
          VarToStr(DocumentRelations.TargetDocumentId),
          VarToStr(RelatedDocumentId),
          VarToStr(RelatedDocumentTypeId)
        ]
      );
      
    if Result = '' then begin

      Result :=
        Format(
          'INSERT INTO %s (%s,%s,%s) VALUES ',
          [
            FDocumentRelationsTableDef.TableName,
            FDocumentRelationsTableDef.TargetDocumentIdColumnName,
            FDocumentRelationsTableDef.RelatedDocumentIdColumnName,
            FDocumentRelationsTableDef.RelatedDocumentTypeIdColumnName
          ]
        ) + ValueListString;

    end

    else Result := Result + ',' + ValueListString;
    
  end;

end;

procedure TDocumentRelationsPostgresRepository.RemoveAllRelationsForDocument(
  const DocumentId: Variant
);
var DocumentRelationsWrapper: TDocumentRelationsWrapper;
begin

  FCurrentSpecificDocumentRelationsOperation := RemovingAllRelationsForDocument;

  DocumentRelationsWrapper :=
    TDocumentRelationsWrapper.Create(
      TDocumentRelations.Create(DocumentId)
  );

  Remove(DocumentRelationsWrapper);

  DocumentRelationsWrapper.DocumentRelations.Free;
  DocumentRelationsWrapper.Free;
  
  FCurrentSpecificDocumentRelationsOperation := None;

  ThrowExceptionIfErrorIsNotUnknown;

end;

procedure TDocumentRelationsPostgresRepository.RemoveDocumentRelations(
  DocumentRelations: TDocumentRelations);
var DocumentRelationsWrapper: TDocumentRelationsWrapper;
begin

  if DocumentRelations.RelationCount = 0 then Exit;
  
  FCurrentSpecificDocumentRelationsOperation := RemovingDocumentRelations;

  DocumentRelationsWrapper :=
    TDocumentRelationsWrapper.Create(DocumentRelations);

  Remove(DocumentRelationsWrapper);

  DocumentRelationsWrapper.Free;
  
  FCurrentSpecificDocumentRelationsOperation := None;

  ThrowExceptionIfErrorIsNotUnknown;

end;

procedure TDocumentRelationsPostgresRepository.PrepareRemoveDomainObjectQuery(
  DomainObject: TDomainObject;
  var QueryPattern: String;
  var QueryParams: TQueryParams
);
var DocumentRelations: TDocumentRelations;
    RemovingDocumentRelationsQueryText: String;
begin

  if not IsCurrentOperationTheRemovingDocumentRelations then begin

    inherited;
    Exit;

  end;

  DocumentRelations :=
    (DomainObject as TDocumentRelationsWrapper).DocumentRelations;

  case FCurrentSpecificDocumentRelationsOperation of

    RemovingDocumentRelations:

      RemovingDocumentRelationsQueryText :=
        ConstructQueryTextForRemovingSomeDocumentRelations(
          DocumentRelations
        );

    RemovingAllRelationsForDocument:

      RemovingDocumentRelationsQueryText :=
        ConstructQueryTextForRemovingAllRelationsForDocument(
          DocumentRelations.TargetDocumentId
        );

  end;

  QueryPattern := RemovingDocumentRelationsQueryText;

end;

function TDocumentRelationsPostgresRepository.ConstructQueryTextForRemovingAllRelationsForDocument(
  const TargetDocumentId: Variant
): String;
begin

  Result :=
    Format(
      'DELETE FROM %s WHERE %s.%s=%s',
      [
        FDocumentRelationsTableDef.TableName,
        FDocumentRelationsTableDef.TableName,
        FDocumentRelationsTableDef.TargetDocumentIdColumnName,
        VarToStr(TargetDocumentId)
      ]
    );

end;

function TDocumentRelationsPostgresRepository.ConstructQueryTextForRemovingSomeDocumentRelations(
  DocumentRelations: TDocumentRelations
): String;
var RelatedDocumentInfo: Variant;
    RelatedDocumentId, RelatedDocumentTypeId: Variant;
    DeletableRelatedDocumentInfoListString,
    DeletableRelatedDocumentInfo: String;
begin

  DeletableRelatedDocumentInfoListString := '';

  for RelatedDocumentInfo in DocumentRelations.RelatedDocumentInfoList do begin

    RelatedDocumentId := RelatedDocumentInfo[0];
    RelatedDocumentTypeId := RelatedDocumentInfo[1];

    DeletableRelatedDocumentInfo :=
      '[' + VarToStr(RelatedDocumentId) + ',' +
            VarToStr(RelatedDocumentTypeId) +
      ']';
      
    if DeletableRelatedDocumentInfoListString = '' then
      DeletableRelatedDocumentInfoListString :=
        DeletableRelatedDocumentInfo

    else
      DeletableRelatedDocumentInfoListString :=
        DeletableRelatedDocumentInfoListString + ',' +
        DeletableRelatedDocumentInfo;
    
  end;

  Result :=
    Format(
      'DELETE FROM %s WHERE %s.%s=%s AND ARRAY[%s.%s,%s.%s] <@ ARRAY[%s]',
      [
        FDocumentRelationsTableDef.TableName,

        FDocumentRelationsTableDef.TableName,
        FDocumentRelationsTableDef.TargetDocumentIdColumnName,
        VarToStr(DocumentRelations.TargetDocumentId),

        FDocumentRelationsTableDef.TableName,
        FDocumentRelationsTableDef.RelatedDocumentIdColumnName,
        FDocumentRelationsTableDef.TableName,
        FDocumentRelationsTableDef.RelatedDocumentTypeIdColumnName,
        
        DeletableRelatedDocumentInfoListString
      ]
    );

end;

{ TDocumentRelationsWrapper }

constructor TDocumentRelationsWrapper.Create(
  DocumentRelations: TDocumentRelations);
begin

  inherited Create;

  Self.DocumentRelations := DocumentRelations;
  
end;

{ TFindRelationsByDocumentIdCriterion }

constructor TFindRelationsByDocumentIdCriterion.Create(
  DocumentRelationsPostgresRepository: TDocumentRelationsPostgresRepository;
  const DocumentId: Variant
);
begin

  inherited Create;

  FDocumentRelationsPostgresRepository := DocumentRelationsPostgresRepository;
  FDocumentId := DocumentId;

end;

function TFindRelationsByDocumentIdCriterion.GetExpression: String;
begin

  Result :=
    FDocumentRelationsPostgresRepository.
      FDocumentRelationsTableDef.
        TargetDocumentIdColumnName + '=' + VarToStr(FDocumentId);
        
end;

{ TDocumentRelationsWrapperList }

constructor TDocumentRelationsWrapperList.Create;
begin

  inherited;
  
end;

end.
