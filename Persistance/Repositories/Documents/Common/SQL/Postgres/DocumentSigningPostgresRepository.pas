unit DocumentSigningPostgresRepository;

interface

uses

  AbstractRepositoryCriteriaUnit,
  AbstractDBRepository,
  AbstractPostgresRepository,
  DomainObjectListUnit,
  DomainObjectUnit,
  DocumentSignings,
  DBTableMapping,
  QueryExecutor,
  DocumentSigningTableDef,
  Disposable,
  DataReader,
  SysUtils,
  Employee,
  Classes,
  ZConnection;

type

  TDocumentSigningPostgresRepository = class (TAbstractPostgresRepository)

    protected

      FDocumentSigningTableDef: TDocumentSigningTableDef;
      FFreeDocumentSigningTableDef: IDisposable;
      
      procedure CustomizeTableMapping(
        TableMapping: TDBTableMapping
      ); override;

    protected

      procedure PrepareRemoveDomainObjectQuery(
        DomainObject: TDomainObject;
        var QueryPattern: String;
        var QueryParams: TQueryParams
      ); override;

      procedure PrepareRemovingAllDocumentSigningsQuery(
        const DocumentId: Variant;
        var QueryPattern: String;
        var QueryParams: TQueryParams
      );

      procedure FillDomainObjectFromDataReader(
        DomainObject: TDomainObject;
        DataReader: IDataReader
      ); override;
        
      function GetQueryParameterValueFromDomainObject(
        DomainObject: TDomainObject;
        const DomainObjectPropertyName: String
      ): Variant; override;

    protected

      function GetCustomWhereClauseForSelect: String; override;
      

    protected

      function LoadSigner(DataReader: IDataReader): TEmployee;
      function LoadActuallySignedEmployee(DataReader: IDataReader): TEmployee;

    protected

      procedure Initialize; override;
      
    public

      constructor Create(
        QueryExecutor: IQueryExecutor;
        DocumentSigningTableDef: TDocumentSigningTableDef
      );

      function FindAllSigningsForDocument(
        const DocumentId: Variant
      ): TDocumentSignings;
      
      procedure AddDocumentSignings(DocumentSignings: TDocumentSignings);
      procedure RemoveAllDocumentSignings(const DocumentId: Variant);
      
  end;

  TFindAllSigningsForDocumentCriterion = class (TAbstractRepositoryCriterion)

    private

      FDocumentId: Variant;
      FDocumentSigningPostgresRepository: TDocumentSigningPostgresRepository;

    protected

      function GetExpression: String; override;
      
    public

      constructor Create(
        DocumentSigningPostgresRepository: TDocumentSigningPostgresRepository;
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

  TRemovingAllDocumentSigningsWrapper = class (TDomainObject)

    private

      FDocumentId: Variant;

    public

      constructor Create(const DocumentId: Variant);

    published

      property DocumentId: Variant read FDocumentId;
      
  end;
{ TDocumentSigningPostgresRepository }

procedure TDocumentSigningPostgresRepository.AddDocumentSignings(
  DocumentSignings: TDocumentSignings
);
begin

  AddDomainObjectList(DocumentSignings);

end;

constructor TDocumentSigningPostgresRepository.Create(
  QueryExecutor: IQueryExecutor;
  DocumentSigningTableDef: TDocumentSigningTableDef
);
begin

  inherited Create(QueryExecutor);

  FDocumentSigningTableDef := DocumentSigningTableDef;
  FFreeDocumentSigningTableDef := FDocumentSigningTableDef;

  CustomizeTableMapping(FDBTableMapping);
  
end;

procedure TDocumentSigningPostgresRepository.CustomizeTableMapping(
  TableMapping: TDBTableMapping);
begin

  if not Assigned(FDocumentSigningTableDef) then Exit;

  with FDocumentSigningTableDef do begin

    TableMapping.SetTableNameMapping(
      TableName, TDocumentSigning, TDocumentSignings
    );

    begin

      TableMapping.AddColumnMappingForSelect(
        IdColumnName, 'Identity'
      );

      TableMapping.AddColumnMappingForSelect(
        SignerIdColumnName, 'Signer', False
      );

      TableMapping.AddColumnMappingForSelect(
        ActualSignerIdColumnName, 'ActuallySignedEmployee', False
      );

      TableMapping.AddColumnMappingForSelect(
        DocumentIdColumnName, 'DocumentId'
      );

      TableMapping.AddColumnMappingForSelect(
        SigningDateColumnName, 'SigningDate'
      );

    end;

    begin

      TableMapping.AddColumnMappingForModification(
        SignerIdColumnName, 'Signer'
      );

      TableMapping.AddColumnMappingForModification(
        ActualSignerIdColumnName, 'ActuallySignedEmployee'
      );

      TableMapping.AddColumnMappingForModification(
        DocumentIdColumnName, 'DocumentId'
      );

      TableMapping.AddColumnMappingForModification(
        SigningDateColumnName, 'SigningDate'
      );

    end;

    TableMapping.AddPrimaryKeyColumnMapping(
      IdColumnName, 'Identity'
    );

  end;

end;

procedure TDocumentSigningPostgresRepository.FillDomainObjectFromDataReader(
  DomainObject: TDomainObject;
  DataReader: IDataReader
);
var DocumentSigning: TDocumentSigning;
begin

  inherited;

  DocumentSigning := DomainObject as TDocumentSigning;

  DocumentSigning.Signer := LoadSigner(DataReader);
  DocumentSigning.ActuallySignedEmployee := LoadActuallySignedEmployee(DataReader);

end;

function TDocumentSigningPostgresRepository.FindAllSigningsForDocument(
  const DocumentId: Variant): TDocumentSignings;
var DomainObjectList: TDomainObjectList;
    FindAllSigningsForDocumentCriterion: TFindAllSigningsForDocumentCriterion;
begin

  FindAllSigningsForDocumentCriterion :=
    TFindAllSigningsForDocumentCriterion.Create(Self, DocumentId);

  try

    DomainObjectList :=
      FindDomainObjectsByCriteria(FindAllSigningsForDocumentCriterion);

    if Assigned(DomainObjectList) then
      Result := DomainObjectList as TDocumentSignings

    else Result := nil;

  finally

    FreeAndNil(FindAllSigningsForDocumentCriterion);

  end;

end;

function TDocumentSigningPostgresRepository.GetCustomWhereClauseForSelect: String;
begin

  Result := inherited GetCustomWhereClauseForSelect;

end;

function TDocumentSigningPostgresRepository.
  GetQueryParameterValueFromDomainObject(
    DomainObject: TDomainObject;
    const DomainObjectPropertyName: String
  ): Variant;
var DocumentSigning: TDocumentSigning;
begin

  DocumentSigning := DomainObject as TDocumentSigning;
  
  if DomainObjectPropertyName = 'Signer' then
    Result := DocumentSigning.Signer.Identity

  else if DomainObjectPropertyName = 'ActuallySignedEmployee' then begin

    if Assigned(DocumentSigning.ActuallySignedEmployee) then
      Result := DocumentSigning.ActuallySignedEmployee.Identity

    else Result := Null;
    
  end

  else
    Result := inherited GetQueryParameterValueFromDomainObject(
                          DomainObject,
                          DomainObjectPropertyName
                        );

end;

procedure TDocumentSigningPostgresRepository.Initialize;
begin

  inherited;

  ReturnIdOfDomainObjectAfterAdding := True;

end;

function TDocumentSigningPostgresRepository.LoadActuallySignedEmployee(
  DataReader: IDataReader
): TEmployee;
var 
    ActuallySignedEmployeeIdColumnName: String;
    ActualSignerId: Variant;
begin

  ActuallySignedEmployeeIdColumnName :=
    FDBTableMapping.FindSelectColumnMappingByObjectPropertyName(
      'ActuallySignedEmployee'
    ).ColumnName;

  ActualSignerId := DataReader[ActuallySignedEmployeeIdColumnName];
  
  if VarIsNull(ActualSignerId) then
    Result := nil

  else
    Result :=
      TRepositoryRegistry.Current.GetEmployeeRepository.FindEmployeeById(
        ActualSignerId
      );
  
end;

function TDocumentSigningPostgresRepository.LoadSigner(
  DataReader: IDataReader
): TEmployee;
var 
    SignerIdColumnName: String;
    SignerId: Variant;
begin

  SignerIdColumnName :=
    FDBTableMapping.FindSelectColumnMappingByObjectPropertyName(
      'Signer'
    ).ColumnName;

  SignerId := DataReader[SignerIdColumnName];
  
  if VarIsNull(SignerId) then
    Result := nil

  else
    Result :=
      TRepositoryRegistry.Current.GetEmployeeRepository.FindEmployeeById(
        SignerId
      );

end;

procedure TDocumentSigningPostgresRepository.PrepareRemoveDomainObjectQuery(
  DomainObject: TDomainObject;
  var QueryPattern: String;
  var QueryParams: TQueryParams
);
var Wrapper: TRemovingAllDocumentSigningsWrapper;
begin

  if not (DomainObject is TRemovingAllDocumentSigningsWrapper) then begin

    inherited;
    Exit;
    
  end;

  Wrapper := DomainObject as TRemovingAllDocumentSigningsWrapper;

  PrepareRemovingAllDocumentSigningsQuery(
    Wrapper.DocumentId, QueryPattern, QueryParams
  );

end;

procedure TDocumentSigningPostgresRepository.
  PrepareRemovingAllDocumentSigningsQuery(
    const DocumentId: Variant;
    var QueryPattern: String;
    var QueryParams: TQueryParams
  );
var
    DocumentIdColumnName: String;
begin

  DocumentIdColumnName :=
    FDBTableMapping.FindSelectColumnMappingByObjectPropertyName(
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

  QueryParams := TQueryParams.Create;

  QueryParams.Add('p' + DocumentIdColumnName, DocumentId);
  
end;

procedure TDocumentSigningPostgresRepository.RemoveAllDocumentSignings(
  const DocumentId: Variant
);
var Wrapper: TRemovingAllDocumentSigningsWrapper;
begin

  Wrapper := TRemovingAllDocumentSigningsWrapper.Create(DocumentId);

  try

    Remove(Wrapper);

  finally

    FreeAndNil(Wrapper);

  end;
  
end;

{ TRemovingAllDocumentSigningsWrapper }

constructor TRemovingAllDocumentSigningsWrapper.Create(
  const DocumentId: Variant);
begin

  inherited Create;

  FDocumentId := DocumentId;
  
end;

{ TFindAllSigningsForDocumentCriterion }

constructor TFindAllSigningsForDocumentCriterion.Create(
  DocumentSigningPostgresRepository: TDocumentSigningPostgresRepository;
  const DocumentId: Variant
);
begin

  inherited Create;

  FDocumentSigningPostgresRepository := DocumentSigningPostgresRepository;
  FDocumentId := DocumentId;

end;

function TFindAllSigningsForDocumentCriterion.GetExpression: String;
var TableMapping: TDBTableMapping;
begin

  TableMapping := FDocumentSigningPostgresRepository.TableMapping;

  Result :=
    TableMapping.TableName + '.' +
    TableMapping.FindSelectColumnMappingByObjectPropertyName(
      'DocumentId'
    ).ColumnName + '=' + VarToStr(FDocumentId);

end;

end.
