unit DocumentApprovingPostgresRepository;

interface

uses

  AbstractPostgresRepository,
  IEmployeeRepositoryUnit,
  DBTableMapping,
  DomainObjectUnit,
  DomainObjectListUnit,
  ZConnection,
  Employee,
  DataReader,
  QueryExecutor,
  DocumentApprovings,
  DocumentApprovingsTableDef,
  DocumentApprovingResultsTableDef,
  DocumentApprovingRepository,
  Disposable,
  SysUtils,
  Classes,
  DB;

type

  TDocumentApprovingPostgresRepository =
    class (TAbstractPostgresRepository, IDocumentApprovingRepository)

      protected

        FDocumentApprovingsTableDef: TDocumentApprovingsTableDef;
        FFreeDocumentApprovingsTableDef: IDisposable;
        
        FDocumentApprovingResultsTableDef: TDocumentApprovingResultsTableDef;
        FFreeDocumentApprovingResultsTableDef: IDisposable;

        procedure CustomizeTableMapping(
          TableMapping: TDBTableMapping
        ); override;

      protected

        procedure FillDomainObjectFromDataReader(
            DomainObject: TDomainObject;
            DataReader: IDataReader
          ); override;

        function GetQueryParameterValueFromDomainObject(
          DomainObject: TDomainObject;
          const DomainObjectPropertyName: String
        ): Variant; override;

        procedure PrepareRemoveDomainObjectQuery(
          DomainObject: TDomainObject;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        ); override;

        procedure PrepareRemovingAllApprovingsForDocumentQuery(
          const DocumentId: Variant;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        );

      protected

        function GetCustomWhereClauseForSelect: String; override;
        function GetCustomWhereClauseForDelete: String; override;
      
      protected

        function FetchPerformingResultFrom(
          DataReader: IDataReader
        ): TDocumentApprovingPerformingResult;

        function LoadApproverFrom(DataReader: IDataReader): TEmployee;

      public

        constructor Create(
          QueryExecutor: IQueryExecutor;
          DocumentApprovingsTableDef: TDocumentApprovingsTableDef;
          DocumentApprovingResultsTableDef: TDocumentApprovingResultsTableDef
        );

        function FindAllApprovingsForDocument(
          const DocumentId: Variant
        ): TDocumentApprovings;

        procedure AddDocumentApprovings(
          DocumentApprovings: TDocumentApprovings
        );

        procedure RemoveAllDocumentApprovings(const DocumentId: Variant);

        function GetSelf: TObject;

  end;

implementation

uses

  Variants,
  RepositoryRegistryUnit,
  AbstractDBRepository,
  AbstractRepositoryCriteriaUnit,
  AbstractRepository, TableDef;

type

  TFindAllApprovingsForDocumentCriterion =
    class (TAbstractRepositoryCriterion)

      protected

        FDocumentId: Variant;
        FRepository: TDocumentApprovingPostgresRepository;

      protected

        function GetExpression: String; override;

      public

        constructor Create(
          Repository: TDocumentApprovingPostgresRepository;
          const DocumentId: Variant
        );

      published

        property DocumentId: Variant
        read FDocumentId write FDocumentId;
        
    end;

    TRemovingAllApprovingsForDocumentWrapper = class (TDomainObject)

      protected

        FDocumentId: Variant;
        
      public

        constructor Create(const DocumentId: Variant);

      published

        property DocumentId: Variant read FDocumentId write FDocumentId;
        
    end;
    
{ TDocumentApprovingPostgresRepository }

function TDocumentApprovingPostgresRepository.
  FindAllApprovingsForDocument(
    const DocumentId: Variant
  ): TDocumentApprovings;
var Criteria: TFindAllApprovingsForDocumentCriterion;
    DomainObjectList: TDomainObjectList;
begin

  Criteria := TFindAllApprovingsForDocumentCriterion.Create(Self, DocumentId);

  try

    DomainObjectList := FindDomainObjectsByCriteria(Criteria);

    ThrowExceptionIfErrorIsNotUnknown;

    if not Assigned(DomainObjectList) then
      Result := nil

    else Result := DomainObjectList as TDocumentApprovings;
    
  finally

    FreeAndNil(Criteria);
    
  end;

end;

procedure TDocumentApprovingPostgresRepository.
  AddDocumentApprovings(
    DocumentApprovings: TDocumentApprovings
  );
begin

  AddDomainObjectList(DocumentApprovings);

  ThrowExceptionIfErrorIsNotUnknown;

end;

procedure TDocumentApprovingPostgresRepository.
  RemoveAllDocumentApprovings(
    const DocumentId: Variant
  );
var Wrapper: TRemovingAllApprovingsForDocumentWrapper;
begin

  Wrapper := TRemovingAllApprovingsForDocumentWrapper.Create(DocumentId);
  
  try

    Remove(Wrapper);

    ThrowExceptionIfErrorIsNotUnknown;
    
  finally

    FreeAndNil(Wrapper);

  end;

end;

constructor TDocumentApprovingPostgresRepository.Create(
  QueryExecutor: IQueryExecutor;
  DocumentApprovingsTableDef: TDocumentApprovingsTableDef;
  DocumentApprovingResultsTableDef: TDocumentApprovingResultsTableDef
);
begin

  inherited Create(QueryExecutor);

  FDocumentApprovingsTableDef := DocumentApprovingsTableDef;
  FFreeDocumentApprovingsTableDef := FDocumentApprovingsTableDef;
  
  FDocumentApprovingResultsTableDef := DocumentApprovingResultsTableDef;
  FFreeDocumentApprovingResultsTableDef := FDocumentApprovingResultsTableDef;

  CustomizeTableMapping(FDBTableMapping);

end;

procedure TDocumentApprovingPostgresRepository.CustomizeTableMapping(
  TableMapping: TDBTableMapping);
begin

  inherited;

  if not Assigned(FDocumentApprovingsTableDef) then
    Exit;

  with FDocumentApprovingsTableDef do begin

    TableMapping.SetTableNameMapping(
      TableName, TDocumentApproving, TDocumentApprovings
    );

    begin { Select }

      TableMapping.AddColumnMappingForSelect(IdColumnName, 'Identity');

      TableMapping.AddColumnMappingForSelect(NoteColumnName, 'Note');

      TableMapping.AddColumnMappingForSelect(DocumentIdColumnName, 'DocumentId');

      TableMapping.AddColumnMappingForSelect(PerformingDateColumnName, 'PerformingDateTime');

      TableMapping.AddColumnMappingForSelect(
        PerformingResultIdColumnName, 'PerformingResult', False
      );

      TableMapping.AddColumnMappingForSelect(
        ApproverIdColumnName, 'Approver.Identity', False
      );

      TableMapping.AddColumnMappingForSelect(
        ActualPerformedEmployeeIdColumnName, 'ActuallyPerformedEmployeeId'
      );

    end;

    begin { Modification }

      TableMapping.AddColumnMappingForModification(NoteColumnName, 'Note');

      TableMapping.AddColumnMappingForModification(DocumentIdColumnName, 'DocumentId');

      TableMapping.AddColumnMappingForModification(PerformingDateColumnName, 'PerformingDateTime');

      TableMapping.AddColumnMappingForModification(ApproverIdColumnName, 'Approver.Identity');

      TableMapping.AddColumnMappingForModification(
        ActualPerformedEmployeeIdColumnName, 'ActuallyPerformedEmployeeId'
      );

      TableMapping.AddColumnMappingForModification(
        PerformingResultIdColumnName, 'PerformingResult'
      );

    end;

    begin {Primary Keys}

      TableMapping.AddPrimaryKeyColumnMapping(IdColumnName, 'Identity');
    
    end;

  end;

end;

function TDocumentApprovingPostgresRepository.FetchPerformingResultFrom(
  DataReader: IDataReader
): TDocumentApprovingPerformingResult;
begin

  with FDocumentApprovingsTableDef do begin

    case DataReader[PerformingResultIdColumnName] of

      DOCUMENT_APPROVED_RESULT_ID:

        Result := prApproved;

      DOCUMENT_NOT_APPROVED_RESULT_ID:

        Result := prRejected;

      DOCUMENT_APPROVING_NOT_PERFORMED_RESULT_ID:

        Result := prNotPerformed;

      else begin

        raise Exception.Create(
                '¬стретилс€ неожидаемый ' +
                'идентификатор результата ' +
                'согласовани€ документа'
              );

      end;

    end;

  end;

end;

procedure TDocumentApprovingPostgresRepository.FillDomainObjectFromDataReader(
  DomainObject: TDomainObject;
  DataReader: IDataReader
);
var DocumentApproving: TDocumentApproving;
begin

  inherited;

  DocumentApproving := DomainObject as TDocumentApproving;

  DocumentApproving.PerformingResult := FetchPerformingResultFrom(DataReader);

  DocumentApproving.Approver := LoadApproverFrom(DataReader);
  
end;

function TDocumentApprovingPostgresRepository.GetCustomWhereClauseForDelete: String;
begin

  Result :=
    FDocumentApprovingsTableDef.CycleNumberColumnName + ' IS NULL';

end;

function TDocumentApprovingPostgresRepository.
  GetCustomWhereClauseForSelect: String;
begin

  Result :=
    FDocumentApprovingsTableDef.CycleNumberColumnName + ' IS NULL';

end;

function TDocumentApprovingPostgresRepository.
  GetQueryParameterValueFromDomainObject(
    DomainObject: TDomainObject;
    const DomainObjectPropertyName: String
  ): Variant;
var
    DocumentApproving: TDocumentApproving;
begin

  DocumentApproving := DomainObject as TDocumentApproving;

  if DomainObjectPropertyName = 'PerformingResult' then begin

    case DocumentApproving.PerformingResult of

      prApproved: Result := DOCUMENT_APPROVED_RESULT_ID;
      prRejected: Result := DOCUMENT_NOT_APPROVED_RESULT_ID;
      prNotPerformed: Result := DOCUMENT_APPROVING_NOT_PERFORMED_RESULT_ID;

      else begin
      
        raise Exception.Create(
                'Ќе найден соответствующий ' +
                'идентификатор результата ' +
                'согласовани€ во врем€ сохранени€ ' +
                'данных о согласовании в репозиторий'
              );

      end;

    end;

  end

  else
    Result :=
      inherited GetQueryParameterValueFromDomainObject(
        DomainObject, DomainObjectPropertyName
      );

end;

function TDocumentApprovingPostgresRepository.GetSelf: TObject;
begin

  Result := Self;
  
end;

function TDocumentApprovingPostgresRepository.LoadApproverFrom(
  DataReader: IDataReader
): TEmployee;
var
    ApproverId: Variant;
    EmployeeRepository: IEmployeeRepository;
begin

  ApproverId := DataReader[FDocumentApprovingsTableDef.ApproverIdColumnName];
  
  if VarIsNull(ApproverId) then begin

    raise Exception.Create(
            '¬о врем€ загрузки данных ' +
            'о согласовании документа ' +
            'не была найдена информаци€ ' +
            'об одном из назначенных ' +
            'согласовантов.'
          );

  end;

  EmployeeRepository := TRepositoryRegistry.Current.GetEmployeeRepository;

  if not Assigned(EmployeeRepository) then begin

    raise Exception.Create(
            '¬о врем€ загрузки данных ' +
            'об одном из согласовантов ' +
            'документа не был найден ' +
            'соответствующий репозиторий'
          );

  end;

  Result := EmployeeRepository.FindEmployeeById(ApproverId);
  
end;

procedure TDocumentApprovingPostgresRepository.
  PrepareRemoveDomainObjectQuery(
    DomainObject: TDomainObject;
    var QueryPattern: String;
    var QueryParams: TQueryParams
  );
var
    Wrapper: TRemovingAllApprovingsForDocumentWrapper;
begin

  if not (DomainObject is TRemovingAllApprovingsForDocumentWrapper) then
  begin

    inherited;
    Exit;
    
  end;
  
  Wrapper := DomainObject as TRemovingAllApprovingsForDocumentWrapper;

  PrepareRemovingAllApprovingsForDocumentQuery(
    Wrapper.DocumentId, QueryPattern, QueryParams
  );
  
end;

procedure TDocumentApprovingPostgresRepository.
  PrepareRemovingAllApprovingsForDocumentQuery(
    const DocumentId: Variant;
    var QueryPattern: String;
    var QueryParams: TQueryParams
  );
var
    DocumentIdColumnName: String;
    CustomWhereClause: String;
begin

  DocumentIdColumnName :=
    
    FDBTableMapping.
      ColumnMappingsForModification.
        FindColumnMappingByObjectPropertyName(
          'DocumentId'
        ).ColumnName;

  QueryPattern :=
    Format(
      'DELETE FROM %s WHERE %s=:p%s',
      [
        FDBTableMapping.TableName,
        DocumentIdColumnName,
        DocumentIdColumnName
      ]
    );

  CustomWhereClause := GetCustomWhereClauseForDelete;

  if CustomWhereClause <> '' then
    QueryPattern := QueryPattern + ' AND ' + CustomWhereClause;

  QueryParams := TQueryParams.Create;

  QueryParams.Add('p' + DocumentIdColumnName, DocumentId);
  
end;

{ TFindAllApprovingsForDocumentCriterion }

constructor TFindAllApprovingsForDocumentCriterion.Create(
    Repository: TDocumentApprovingPostgresRepository;
    const DocumentId: Variant
);
begin

  inherited Create;

  FRepository := Repository;
  FDocumentId := DocumentId;

end;

function TFindAllApprovingsForDocumentCriterion.GetExpression: String;
begin

  Result :=
    FRepository.TableMapping.FindSelectColumnMappingByObjectPropertyName(
      'DocumentId'
    ).ColumnName

    + '=' +

    VarToStr(DocumentId);

end;

{ TRemovingAllApprovingsForDocumentWrapper }

constructor TRemovingAllApprovingsForDocumentWrapper.Create(
  const DocumentId: Variant);
begin

  inherited Create;

  FDocumentId := DocumentId;
  
end;

end.

