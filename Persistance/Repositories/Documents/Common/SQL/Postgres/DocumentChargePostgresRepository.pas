unit DocumentChargePostgresRepository;

interface

uses

  AbstractRepositoryCriteriaUnit,
  AbstractDBRepository,
  AbstractPostgresRepository,
  DomainObjectUnit,
  DomainObjectListUnit,
  DocumentCharges,
  IEmployeeRepositoryUnit,
  DBTableMapping,
  DocumentChargeTableDef,
  DocumentChargeSheetTableDef,
  DocumentChargeKindTableDef,
  DocumentChargeKindRepository,
  DocumentChargeKindPostgresRepository,
  DocumentChargeRepository,
  Disposable,
  ZConnection,
  IDomainObjectBaseListUnit,
  VariantListUnit,
  DocumentChargeKind,
  QueryExecutor,
  DataReader,
  Employee,
  SysUtils,
  Classes;

type

  TDocumentChargePostgresRepository =
    class (TAbstractPostgresRepository, IDocumentChargeRepository)

      protected

        FChargeKindPostgresRepository: IDocumentChargeKindRepository;

        FDocumentChargeTableDef: TDocumentChargeTableDef;
        FFreeDocumentChargeTableDef: IDisposable;

        FDocumentChargeSheetTableDef: TDocumentChargeSheetTableDef;
        FFreeDocumentChargeSheetTableDef: IDisposable;

        FChargeKinds: TDocumentChargeKinds;
        FFreeChargeKinds: IDomainObjectBaseList;

      protected

        procedure CustomizeTableMapping(
          TableMapping: TDBTableMapping
        ); override;

      protected

        procedure Initialize; override;

      protected

        function CreateDomainObject(DataReader: IDataReader): TDomainObject; override;
      
        procedure FillDomainObjectFromDataReader(
          DomainObject: TDomainObject;
          DataReader: IDataReader
        ); override;

        procedure PrepareRemoveDomainObjectQuery(
          DomainObject: TDomainObject;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        ); override;

        procedure PrepareRemovingAllDocumentChargesQuery(
          const DocumentId: Variant;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        );

      protected

        function GetTableNameFromTableMappingForSelect: String; override;

      protected

        function LoadPerformer(DataReader: IDataReader): TEmployee;
        function LoadActuallyPerformedEmployee(DataReader: IDataReader): TEmployee;

      protected

        procedure FillChargeKindsBy(ChargeKindPostgresRepository: IDocumentChargeKindRepository);

      public

        destructor Destroy; override;

        constructor Create(
          ChargeKindPostgresRepository: TDocumentChargeKindPostgresRepository;
          QueryExecutor: IQueryExecutor;
          DocumentChargeTableDef: TDocumentChargeTableDef;
          DocumentChargeSheetTableDef: TDocumentChargeSheetTableDef
        );

        function GetSelf: TObject;
        
        function FindDocumentChargeById(const ChargeId: Variant): TDocumentCharge;
        function FindDocumentChargeByIds(const ChargeIds: TVariantList): TDocumentCharges;
        
        function FindAllChargesForDocument(
          const DocumentId: Variant
        ): TDocumentCharges;
      
        procedure AddDocumentCharges(DocumentCharges: TDocumentCharges);
        procedure UpdateDocumentCharge(DocumentCharge: TDocumentCharge);
        procedure UpdateDocumentCharges(DocumentCharges: TDocumentCharges);
        procedure SaveDocumentCharge(DocumentCharge: TDocumentCharge);
        procedure RemoveAllDocumentCharges(const DocumentId: Variant);

    end;

  TFindAllChargesForDocumentCriterion = class (TAbstractRepositoryCriterion)

    private

      FDocumentId: Variant;
      FDocumentChargePostgresRepository: TDocumentChargePostgresRepository;

    protected

      function GetExpression: String; override;

    public

      constructor Create(
        DocumentChargePostgresRepository: TDocumentChargePostgresRepository;
        const DocumentId: Variant
      );

  end;

implementation

uses

  DB,
  Variants,
  RepositoryRegistryUnit,
  AbstractRepository;

type

  TRemovingAllDocumentChargesWrapper = class (TDomainObject)

    private

      FDocumentId: Variant;

    public

      constructor Create(const DocumentId: Variant);

    published

      property DocumentId: Variant read FDocumentId;
      
  end;

{ TDocumentChargePostgresRepository }

constructor TDocumentChargePostgresRepository.Create(
  ChargeKindPostgresRepository: TDocumentChargeKindPostgresRepository;
  QueryExecutor: IQueryExecutor;
  DocumentChargeTableDef: TDocumentChargeTableDef;
  DocumentChargeSheetTableDef: TDocumentChargeSheetTableDef
);
begin

  inherited Create(QueryExecutor);

  FChargeKindPostgresRepository := ChargeKindPostgresRepository;
  
  FillChargeKindsBy(ChargeKindPostgresRepository);

  FDocumentChargeTableDef := DocumentChargeTableDef;
  FFreeDocumentChargeTableDef := DocumentChargeTableDef;

  FDocumentChargeSheetTableDef := DocumentChargeSheetTableDef;
  FFreeDocumentChargeSheetTableDef := FDocumentChargeSheetTableDef;

  CustomizeTableMapping(FDBTableMapping);
  
end;

function TDocumentChargePostgresRepository.CreateDomainObject(DataReader: IDataReader): TDomainObject;
var
    ChargeKind: TDocumentChargeKind;
begin

  ChargeKind :=
    FChargeKinds.FindByIdentity(
      DataReader[FDocumentChargeTableDef.KindIdColumnName]
    );

  if not Assigned(ChargeKind) then begin

    Raise Exception.Create(
      'При создании экземпляра поручения в репозитории обнаружен ' +
      'неожидаемый тип поручения'
    );
    
  end;

  Result := ChargeKind.ChargeClass.Create;

  with TDocumentCharge(Result) do begin

    KindName := ChargeKind.Name;
    ServiceKindName := ChargeKind.ServiceName;

  end;

end;

procedure TDocumentChargePostgresRepository.CustomizeTableMapping(
  TableMapping: TDBTableMapping
);
begin

  if not Assigned(FDocumentChargeTableDef) then Exit;

  with FDocumentChargeTableDef do begin

    TableMapping.SetTableNameMapping(TableName, nil, TDocumentCharges);

    begin

      TableMapping.AddColumnMappingForSelect(IdColumnName, 'Identity');

      TableMapping.AddColumnMappingForSelect(
        OriginalDocumentIdColumnName, 'DocumentId'
      );

      TableMapping.AddColumnMappingForSelect(ChargeColumnName, 'ChargeText');

      TableMapping.AddColumnMappingForSelect(
        PerformerIdColumnName, 'Performer.Identity', False
      );

      TableMapping.AddColumnMappingForSelect(
        ActualPerformerIdColumnName, 'ActuallyPerformedEmployee.Identity', False
      );

      TableMapping.AddColumnMappingForSelect(KindIdColumnName, 'KindId');

      TableMapping.AddColumnMappingForSelect(
        ChargePeriodStartColumnName, 'TimeFrameStart'
      );

      TableMapping.AddColumnMappingForSelect(
        ChargePeriodEndColumnName, 'TimeFrameDeadline'
      );

      TableMapping.AddColumnMappingForSelect(
        PerformerResponseColumnName, 'Response'
      );

      TableMapping.AddColumnMappingForSelect(
        PerformingDateTimeColumnName, 'PerformingDateTime'
      );

      TableMapping.AddColumnMappingForSelect(
        IsForAcquaitanceColumnName, 'IsForAcquaitance'
      );

    end;

    begin

      TableMapping.AddColumnMappingForModification(
        OriginalDocumentIdColumnName, 'DocumentId'
      );

      TableMapping.AddColumnMappingForModification(
        ChargeColumnName, 'ChargeText'
      );

      TableMapping.AddColumnMappingForModification(
        PerformerIdColumnName, 'Performer.Identity'
      );

      TableMapping.AddColumnMappingForModification(
        KindIdColumnName, 'KindId'
      );
      
      TableMapping.AddColumnMappingForModification(
        ActualPerformerIdColumnName, 'ActuallyPerformedEmployee.Identity'
      );

      TableMapping.AddColumnMappingForModification(
        ChargePeriodStartColumnName, 'TimeFrameStart'
      );

      TableMapping.AddColumnMappingForModification(
        ChargePeriodEndColumnName, 'TimeFrameDeadline'
      );

      TableMapping.AddColumnMappingForModification(
        PerformerResponseColumnName, 'Response'
      );

      TableMapping.AddColumnMappingForModification(
        PerformingDateTimeColumnName, 'PerformingDateTime'
      );

      TableMapping.AddColumnMappingForModification(
        IsForAcquaitanceColumnName, 'IsForAcquaitance'
      );

    end;

    TableMapping.AddPrimaryKeyColumnMapping(IdColumnName, 'Identity');

  end;

end;

destructor TDocumentChargePostgresRepository.Destroy;
begin

  inherited;

end;

procedure TDocumentChargePostgresRepository.FillChargeKindsBy(
  ChargeKindPostgresRepository: IDocumentChargeKindRepository);
begin

  FChargeKinds := ChargeKindPostgresRepository.FindAllDocumentChargeKinds;

  FFreeChargeKinds := FChargeKinds;
  
end;

procedure TDocumentChargePostgresRepository.FillDomainObjectFromDataReader(
  DomainObject: TDomainObject;
  DataReader: IDataReader
);
var
    DocumentCharge: TDocumentCharge;
begin

  inherited FillDomainObjectFromDataReader(DomainObject, DataReader);
  
  DocumentCharge := DomainObject as TDocumentCharge;

  DocumentCharge.Performer := LoadPerformer(DataReader);

  DocumentCharge.ActuallyPerformedEmployee := LoadActuallyPerformedEmployee(DataReader);

end;

function TDocumentChargePostgresRepository.FindAllChargesForDocument(
  const DocumentId: Variant
): TDocumentCharges;
var DomainObjectList: TDomainObjectList;
    FindAllChargesForDocumentCriterion: TFindAllChargesForDocumentCriterion;
begin

  FindAllChargesForDocumentCriterion :=
    TFindAllChargesForDocumentCriterion.Create(Self, DocumentId);

  try

    DomainObjectList :=
      FindDomainObjectsByCriteria(FindAllChargesForDocumentCriterion);

    if Assigned(DomainObjectList) then
      Result := DomainObjectList as TDocumentCharges

    else Result := nil;
    
  finally

    FreeAndNil(FindAllChargesForDocumentCriterion);

  end;

end;

function TDocumentChargePostgresRepository.FindDocumentChargeById(
  const ChargeId: Variant): TDocumentCharge;
begin

  Result := TDocumentCharge(FindDomainObjectByIdentity(ChargeId));

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

function TDocumentChargePostgresRepository.FindDocumentChargeByIds(
  const ChargeIds: TVariantList): TDocumentCharges;
begin

  Result := TDocumentCharges(FindDomainObjectsByIdentities(ChargeIds));

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

function TDocumentChargePostgresRepository.GetSelf: TObject;
begin

  Result := Self;
  
end;

function TDocumentChargePostgresRepository.GetTableNameFromTableMappingForSelect: String;
begin

  Result := inherited GetTableNameFromTableMappingForSelect;

end;

procedure TDocumentChargePostgresRepository.Initialize;
begin

  inherited;

  ReturnIdOfDomainObjectAfterAdding := True;
  
end;

function TDocumentChargePostgresRepository.LoadActuallyPerformedEmployee(
  DataReader: IDataReader
): TEmployee;
var
    ActuallyPerformedEmployeeId: Variant;
begin

  ActuallyPerformedEmployeeId := DataReader[FDocumentChargeTableDef.ActualPerformerIdColumnName];
    
  if VarIsNull(ActuallyPerformedEmployeeId) then
    Result := nil

  else begin
  
    Result :=
      TRepositoryRegistry.Current.GetEmployeeRepository.FindEmployeeById(
        ActuallyPerformedEmployeeId
      );

  end;

end;

function TDocumentChargePostgresRepository.LoadPerformer(
  DataReader: IDataReader
): TEmployee;
var
    PerformerId: Variant;
begin

  PerformerId := DataReader[FDocumentChargeTableDef.PerformerIdColumnName];
  
  if VarIsNull(PerformerId) then
    Result := nil

  else begin

    Result :=
      TRepositoryRegistry.Current.GetEmployeeRepository.FindEmployeeById(
        PerformerId
      );

  end;

end;

procedure TDocumentChargePostgresRepository.PrepareRemoveDomainObjectQuery(
  DomainObject: TDomainObject;
  var QueryPattern: String;
  var QueryParams: TQueryParams
);
var
    Wrapper: TRemovingAllDocumentChargesWrapper;
begin

  if not (DomainObject is TRemovingAllDocumentChargesWrapper) then begin

    inherited PrepareRemoveDomainObjectQuery(DomainObject, QueryPattern, QueryParams);

    Exit;
    
  end;

  Wrapper := DomainObject as TRemovingAllDocumentChargesWrapper;

  PrepareRemovingAllDocumentChargesQuery(
    Wrapper.DocumentId, QueryPattern, QueryParams
  );
  
end;

procedure TDocumentChargePostgresRepository.
  PrepareRemovingAllDocumentChargesQuery(
    const DocumentId: Variant;
    var QueryPattern: String;
    var QueryParams: TQueryParams
  );
var
    DocumentIdColumnName: String;
begin

  DocumentIdColumnName := FDocumentChargeTableDef.OriginalDocumentIdColumnName;

  QueryPattern :=
    Format(
      'DELETE FROM %s WHERE %s=:p%s',
      [
        FDBTableMapping.TableName,
        DocumentIdColumnName,
        DocumentIdColumnName
      ]
    );

  QueryParams := TQueryParams.Create;

  QueryParams.Add('p' + DocumentIdColumnName, DocumentId);
  
end;

procedure TDocumentChargePostgresRepository.AddDocumentCharges(
  DocumentCharges: TDocumentCharges
);
begin

  AddDomainObjectList(DocumentCharges);
  
end;

procedure TDocumentChargePostgresRepository.RemoveAllDocumentCharges(
  const DocumentId: Variant
);
var Wrapper: TRemovingAllDocumentChargesWrapper;
begin

  Wrapper := TRemovingAllDocumentChargesWrapper.Create(DocumentId);

  try

    Remove(Wrapper);
    
  finally

    FreeAndNil(Wrapper);
    
  end;

end;

procedure TDocumentChargePostgresRepository.SaveDocumentCharge(
  DocumentCharge: TDocumentCharge);
begin

  Save(DocumentCharge);

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

procedure TDocumentChargePostgresRepository.UpdateDocumentCharge(
  DocumentCharge: TDocumentCharge);
begin

  Update(DocumentCharge);

end;

procedure TDocumentChargePostgresRepository.UpdateDocumentCharges(
  DocumentCharges: TDocumentCharges);
begin

  UpdateDomainObjectList(DocumentCharges);
  
end;

{ TRemovingAllDocumentChargesWrapper }

constructor TRemovingAllDocumentChargesWrapper.Create(
  const DocumentId: Variant);
begin

  inherited Create;

  FDocumentId := DocumentId;
  
end;

{ TFindAllChargesForDocumentCriterion }

constructor TFindAllChargesForDocumentCriterion.Create(
  DocumentChargePostgresRepository: TDocumentChargePostgresRepository;
  const DocumentId: Variant
);
begin

  inherited Create;

  FDocumentChargePostgresRepository := DocumentChargePostgresRepository;
  FDocumentId := DocumentId;

end;

function TFindAllChargesForDocumentCriterion.GetExpression: String;
var TableMapping: TDBTableMapping;
begin

  TableMapping := FDocumentChargePostgresRepository.TableMapping;

  Result :=
    Format(
      '%s=%s AND %s IS NULL',
      [
        TableMapping.TableName + '.' +
        FDocumentChargePostgresRepository
          .FDocumentChargeTableDef
            .OriginalDocumentIdColumnName,
            
        VarToStr(FDocumentId),

        FDocumentChargePostgresRepository
          .FDocumentChargeSheetTableDef.TopLevelChargeSheetIdColumnName
      ]
    );

end;

end.

