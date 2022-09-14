unit DocumentKindPostgresRepository;

interface

uses

  DocumentKind,
  DomainObjectUnit,
  DBTableMapping,
  VariantListUnit,
  SysUtils,
  Classes,
  Document,
  ZConnection,
  DocumentTypeDBResolver,
  DocumentTypesTableDef,
  Disposable,
  QueryExecutor,
  DocumentKindRepository,
  DataReader,
  AbstractPostgresRepository;

type

  TDocumentKindPostgresRepository =
    class (TAbstractPostgresRepository, IDocumentKindRepository)

      protected

        FDocumentTypesTableDef: TDocumentTypesTableDef;
        FFreeDocumentTypesTableDef: IDisposable;

        FDocumentTypeDBResolver: IDocumentTypeDBResolver;

        procedure Initialize; override;

        procedure CustomizeTableMapping(
          TableMapping: TDBTableMapping
        ); override;

      protected

        function GetCustomWhereClauseForSelect: String; override;

      protected

        procedure FillDomainObjectFromDataReader(
          DomainObject: TDomainObject;
          DataReader: IDataReader
        ); override;

      public

        constructor Create(
          QueryExecutor: IQueryExecutor;
          DocumentTypesTableDef: TDocumentTypesTableDef
        );
        
        function LoadAllDocumentKinds: TDocumentKinds;
        function FindDocumentKindByIdentity(const DocumentKindIdentity: Variant): TDocumentKind;
        function FindDocumentKindsByIdentities(const Identities: TVariantList): TDocumentKinds;
        function FindDocumentKindByServiceName(const ServiceName: String): TDocumentKind;
        function FindDocumentKindByClassType(DocumentType: TDocumentClass): TDocumentKind;

    end;

implementation

uses

  ServiceNote,
  IncomingServiceNote,
  InternalServiceNote,
  IDomainObjectBaseUnit,
  IDomainObjectBaseListUnit,
  IncomingInternalServiceNote,
  DBTableColumnMappings,
  AuxiliaryStringFunctions,
  SQLAnyMatchingCriterion,
  SQLAllMultiFieldsEqualityCriterion,
  AbstractRepository, TableColumnMappings, AbstractDBRepository;

type

  TFindDocumentKindsByIdentitiesCriterion =
    class (TSQLAnyMatchingCriterion)

      public

        constructor Create(
          Identities: TVariantList;
          Repository: TDocumentKindPostgresRepository
        );
          
    end;

    TFindDocumentKindByServiceNameCriterion =
      class (TSQLAllMultiFieldsEqualityCriterion)

        public

          constructor Create(
            Repository: TDocumentKindPostgresRepository;
            const ServiceName: String
          );
          
      end;

{ TDocumentKindPostgresRepository }

constructor TDocumentKindPostgresRepository.Create(
  QueryExecutor: IQueryExecutor; DocumentTypesTableDef: TDocumentTypesTableDef);
begin

  inherited Create(QueryExecutor);

  FDocumentTypesTableDef := DocumentTypesTableDef;
  FFreeDocumentTypesTableDef := FDocumentTypesTableDef;

  CustomizeTableMapping(FDBTableMapping);
  
end;

procedure TDocumentKindPostgresRepository.CustomizeTableMapping(
  TableMapping: TDBTableMapping
);
begin

  inherited;

  if not Assigned(FDocumentTypesTableDef) then Exit;

  with FDocumentTypesTableDef do begin
  
    TableMapping.SetTableNameMapping(
      TableName, TDocumentKind, TDocumentKinds
    );

    TableMapping.AddColumnMappingForSelect(
      IdColumnName, 'Identity'
    );

    TableMapping.AddColumnMappingForSelect(
      ShortFullNameColumnName, 'Name'
    );

    TableMapping.AddColumnMappingForSelect(
      ServiceNameColumnName, 'ServiceName'
    );

    TableMapping.AddColumnMappingForSelect(
      ParentTypeIdColumnName, 'ParentDocumentKindId'
    );

    TableMapping.AddColumnMappingForSelect(
      SingleFullNameColumnName, 'Description'
    );

    TableMapping.AddPrimaryKeyColumnMapping(
      IdColumnName, 'Identity'
    );

  end;

end;

procedure TDocumentKindPostgresRepository.FillDomainObjectFromDataReader(
  DomainObject: TDomainObject;
  DataReader: IDataReader
);
var
    DocumentKind: TDocumentKind;
begin

  inherited;

  DocumentKind := DomainObject as TDocumentKind;

  DocumentKind.DocumentClass :=
    FDocumentTypeDBResolver.ResolveDocumentType(
      DataReader[FDocumentTypesTableDef.ServiceNameColumnName]
    );
  
end;

function TDocumentKindPostgresRepository.FindDocumentKindByClassType(
  DocumentType: TDocumentClass): TDocumentKind;
begin

  Result :=
    FindDocumentKindByServiceName(
      FDocumentTypeDBResolver.ResolveServiceNameForDocumentType(DocumentType)
    )

end;

function TDocumentKindPostgresRepository.FindDocumentKindByIdentity(
  const DocumentKindIdentity: Variant
): TDocumentKind;
begin

  Result := TDocumentKind(FindDomainObjectByIdentity(DocumentKindIdentity));

  if not Assigned(Result) then begin

    raise Exception.Create(
      'Информация о виде документов не найдена в базе данных'
    );
    
  end;

  ThrowExceptionIfErrorIsNotUnknown;

end;

function TDocumentKindPostgresRepository.FindDocumentKindByServiceName(
  const ServiceName: String): TDocumentKind;
var
    Criteria: TFindDocumentKindByServiceNameCriterion;

    DocumentKinds: TDocumentKinds;
    FreeDocumentKinds: IDomainObjectBaseList;
begin

  Criteria := TFindDocumentKindByServiceNameCriterion.Create(Self, ServiceName);
  
  try

    DocumentKinds := TDocumentKinds(FindDomainObjectsByCriteria(Criteria));

    FreeDocumentKinds := DocumentKinds;

    Result := TDocumentKind(DocumentKinds.First.Clone);
    
  finally

    FreeAndNil(Criteria);

  end;

end;

function TDocumentKindPostgresRepository.FindDocumentKindsByIdentities(
  const Identities: TVariantList): TDocumentKinds;
var FindDocumentKindsByIdentitiesCriterion: TFindDocumentKindsByIdentitiesCriterion;
begin

  FindDocumentKindsByIdentitiesCriterion :=
    TFindDocumentKindsByIdentitiesCriterion.Create(
      Identities,
      Self
    );

  try

    Result :=
      TDocumentKinds(
        FindDomainObjectsByCriteria(FindDocumentKindsByIdentitiesCriterion)
      );

    ThrowExceptionIfErrorIsNotUnknown;
      
  finally

    FreeAndNil(FindDocumentKindsByIdentitiesCriterion);

  end;

end;

function TDocumentKindPostgresRepository.GetCustomWhereClauseForSelect: String;
begin

  Result := FDocumentTypesTableDef.IsDomainColumnName;
  
end;

procedure TDocumentKindPostgresRepository.Initialize;
begin

  inherited;

  FDocumentTypeDBResolver := TDocumentTypeDBResolver.Create;

end;

function TDocumentKindPostgresRepository.LoadAllDocumentKinds: TDocumentKinds;
begin

  Result := TDocumentKinds(LoadAll);

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

{ TFindDocumentKindsByIdentitiesCriterion }

constructor TFindDocumentKindsByIdentitiesCriterion.Create(
  Identities: TVariantList;
  Repository: TDocumentKindPostgresRepository
);
var
    IdentityColumnName: String;
begin

  IdentityColumnName :=
    Repository
    .TableMapping
      .FindSelectColumnMappingByObjectPropertyName('Identity')
        .ColumnName;

  inherited Create(IdentityColumnName, Identities);
  
end;

{ TFindDocumentKindByServiceNameCriterion }

constructor TFindDocumentKindByServiceNameCriterion.Create(
  Repository: TDocumentKindPostgresRepository; const ServiceName: String);
var
    ServiceNameColumnName: String;
begin

  ServiceNameColumnName :=
    Repository
      .TableMapping
        .FindSelectColumnMappingByObjectPropertyName('ServiceName')
          .ColumnName;

  inherited Create([ServiceNameColumnName], [ServiceName]);

end;

end.
