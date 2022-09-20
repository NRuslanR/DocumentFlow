unit DocumentFilesPostgresRepository;

interface

uses

  DocumentFileUnit,
  DBTableMapping,
  AbstractRepositoryCriteriaUnit,
  AbstractPostgresRepository,
  DomainObjectUnit,
  DomainObjectListUnit,
  DocumentFilesRepository,
  DocumentFilesTableDef,
  Disposable,
  Document,
  AbstractDBRepository,
  QueryExecutor,
  DataReader,
  SysUtils,
  Classes;

type

  TDocumentFilesWrapper = class (TDomainObject)

    public

      DocumentFiles: TDocumentFiles;

    public

      constructor Create(DocumentFiles: TDocumentFiles);

  end;

  TDocumentFilesPostgresRepository = class;

  TFindFilesForDocumentCriterion = class (TAbstractRepositoryCriterion)

    private

      FDocumentId: Variant;
      FDocumentFilesPostgresRepository: TDocumentFilesPostgresRepository;

    protected

      function GetExpression: String; override;

    public

      constructor Create(
        DocumentFilesPostgresRepository: TDocumentFilesPostgresRepository;
        const DocumentId: Variant
      );

  end;

  TDocumentFilesPostgresRepository =
    class (TAbstractPostgresRepository, IDocumentFilesRepository)

      protected

        type

          TSpecificDocumentFileOperation = (

            None,
            AddingDocumentFiles,
            RemovingAllFilesForDocument

          );

      protected

        FDocumentFilesTableDef: TDocumentFilesTableDef;
        FFreeDocumentFilesTableDef: IDisposable;

        FCurrentSpecificDocumentFileOperation: TSpecificDocumentFileOperation;

        procedure Initialize; override;

        function CreateDomainObjectList(DataReader: IDataReader): TDomainObjectList; override;
      
        procedure CustomizeTableMapping(
          TableMapping: TDBTableMapping
        ); override;

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

        procedure SetIdForDomainObject(
          DomainObject: TDomainObject;
          DataReader: IDataReader
        ); override;

        procedure FillDomainObjectFromDataReader(
          DomainObject: TDomainObject;
          DataReader: IDataReader
        ); override;

      private

        function ConstructQueryTextForAddingDocumentFilesFrom(
          DocumentFiles: TDocumentFiles
        ): String;

      public

        constructor Create(
          QueryExecutor: IQueryExecutor;
          DocumentFilesTableDef: TDocumentFilesTableDef
        );

        procedure AddDocumentFile(DocumentFile: TDocumentFile);
        procedure AddDocumentFiles(DocumentFiles: TDocumentFiles);

        procedure UpdateDocumentFile(DocumentFile: TDocumentFile);
        procedure RemoveDocumentFile(DocumentFile: TDocumentFile);
        procedure RemoveAllFilesForDocument(const DocumentId: Variant);

        function FindDocumentFileById(const DocumentFileId: Variant): TDocumentFile;
        function FindFilesForDocument(const DocumentId: Variant): TDocumentFiles;

    end;

implementation

uses

  PersonnelOrder,
  ServiceNote,
  Variants,
  AbstractRepository;

{ TDocumentFilesPostgresRepository }

procedure TDocumentFilesPostgresRepository.PrepareAddDomainObjectQuery(
  DomainObject: TDomainObject;
  var QueryPattern: String;
  var QueryParams: TQueryParams
);
var DocumentFilesWrapper: TDocumentFilesWrapper;
begin

  if FCurrentSpecificDocumentFileOperation = AddingDocumentFiles then begin

    DocumentFilesWrapper := DomainObject as TDocumentFilesWrapper;
    
    QueryPattern :=
      ConstructQueryTextForAddingDocumentFilesFrom(
        DocumentFilesWrapper.DocumentFiles
      );

  end

  else inherited;


end;

procedure TDocumentFilesPostgresRepository.AddDocumentFile(
  DocumentFile: TDocumentFile);
begin

  Add(DocumentFile);

  ThrowExceptionIfErrorIsNotUnknown;

end;

procedure TDocumentFilesPostgresRepository.AddDocumentFiles(
  DocumentFiles: TDocumentFiles
);
var DocumentFilesWrapper: TDocumentFilesWrapper;
begin

  if DocumentFiles.Count = 0 then Exit;
  
  ReturnIdOfDomainObjectAfterAdding := False;
  FCurrentSpecificDocumentFileOperation := AddingDocumentFiles;

  DocumentFilesWrapper := TDocumentFilesWrapper.Create(DocumentFiles);
  
  Add(DocumentFilesWrapper);

  DocumentFilesWrapper.Free;

  ReturnIdOfDomainObjectAfterAdding := True;
  FCurrentSpecificDocumentFileOperation := None;

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

function TDocumentFilesPostgresRepository.ConstructQueryTextForAddingDocumentFilesFrom(
  DocumentFiles: TDocumentFiles
): String;
var DocumentFile: TDocumentFile;
    ValueListString: String;
    DocumentIdColumnName,
    DocumentFileNameColumnName,
    DocumentFilePathColumnName: String;
begin

  Result := '';

  DocumentIdColumnName :=
    FDBTableMapping.
      ColumnMappingsForModification.
        FindColumnMappingByObjectPropertyName('DocumentId').ColumnName;

  DocumentFileNameColumnName :=
    FDBTableMapping.
      ColumnMappingsForModification.
        FindColumnMappingByObjectPropertyName('FileName').ColumnName;

  DocumentFilePathColumnName :=
    FDBTableMapping.
      ColumnMappingsForModification.
        FindColumnMappingByObjectPropertyName('FilePath').ColumnName;

  for DocumentFile in DocumentFiles do begin

    ValueListString :=
      Format(
        '(%s,%s,%s)',
        [
          VarToStr(DocumentFile.DocumentId),
          QuotedStr(DocumentFile.FileName),
          QuotedStr(DocumentFile.FilePath)
        ]
      );
      
    if Result = '' then
      Result :=
        Format(
          'INSERT INTO %s (%s,%s,%s) VALUES ',
          [
            FDBTableMapping.TableName,
            DocumentIdColumnName,
            DocumentFileNameColumnName,
            DocumentFilePathColumnName
          ]
        ) + ValueListString

    else Result := Result + ',' + ValueListString;

  end;

end;

constructor TDocumentFilesPostgresRepository.Create(
  QueryExecutor: IQueryExecutor;
  DocumentFilesTableDef: TDocumentFilesTableDef
);
begin

  inherited Create(QueryExecutor);

  FDocumentFilesTableDef := DocumentFilesTableDef;
  FFreeDocumentFilesTableDef := FDocumentFilesTableDef;

  CustomizeTableMapping(FDBTableMapping);
  
end;

function TDocumentFilesPostgresRepository.CreateDomainObjectList(DataReader: IDataReader): TDomainObjectList;
begin

  Result := TDocumentFiles.Create;
  
end;

procedure TDocumentFilesPostgresRepository.CustomizeTableMapping(
  TableMapping: TDBTableMapping
);
begin

  if not Assigned(FDocumentFilesTableDef) then Exit;
  
  with FDocumentFilesTableDef do begin

    TableMapping.SetTableNameMapping(TableName, TDocumentFile);

    TableMapping.AddColumnMappingForSelect(IdColumnName, 'Identity');
    TableMapping.AddColumnMappingForSelect(DocumentIdColumnName, 'DocumentId');
    TableMapping.AddColumnMappingForSelect(FileNameColumnName, 'FileName');
    TableMapping.AddColumnMappingForSelect(FilePathColumnName, 'FilePath');

    TableMapping.AddColumnMappingForModification(DocumentIdColumnName, 'DocumentId');
    TableMapping.AddColumnMappingForModification(FileNameColumnName, 'FileName');
    TableMapping.AddColumnMappingForModification(FilePathColumnName, 'FilePath');

    TableMapping.AddPrimaryKeyColumnMapping(IdColumnName, 'Identity');

  end;

end;

procedure TDocumentFilesPostgresRepository.FillDomainObjectFromDataReader(
  DomainObject: TDomainObject;
  DataReader: IDataReader
);
begin

  DomainObject.InvariantsComplianceRequested := False;
  
  inherited FillDomainObjectFromDataReader(DomainObject, DataReader);

  DomainObject.InvariantsComplianceRequested := True;
  
end;

function TDocumentFilesPostgresRepository.FindDocumentFileById(
  const DocumentFileId: Variant
): TDocumentFile;
var DomainObject: TDomainObject;
begin

  DomainObject := FindDomainObjectByIdentity(DocumentFileId);

  if Assigned(DomainObject) then
    Result := DomainObject as TDocumentFile

  else Result := nil;

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

function TDocumentFilesPostgresRepository.FindFilesForDocument(
  const DocumentId: Variant): TDocumentFiles;
var DomainObjectList: TDomainObjectList;
    FindFilesForDocumentCriterion: TFindFilesForDocumentCriterion;
begin

  FindFilesForDocumentCriterion := nil;

  try

    FindFilesForDocumentCriterion :=
      TFindFilesForDocumentCriterion.Create(Self, DocumentId);

    DomainObjectList :=
      FindDomainObjectsByCriteria(FindFilesForDocumentCriterion);

    if DomainObjectList = nil then
      Result := nil

    else Result := DomainObjectList as TDocumentFiles;

    ThrowExceptionIfErrorIsNotUnknown;
    
  finally

    FreeAndNil(FindFilesForDocumentCriterion);

  end;

end;


procedure TDocumentFilesPostgresRepository.Initialize;
begin

  inherited;

  FCurrentSpecificDocumentFileOperation := None;

end;

procedure TDocumentFilesPostgresRepository.PrepareRemoveDomainObjectQuery(
  DomainObject: TDomainObject;
  var QueryPattern: String;
  var QueryParams: TQueryParams
);
var
    DummyForRemovingAllDocumentFiles: TDocumentFile;
    DocumentIdColumnName: String;
begin

  if FCurrentSpecificDocumentFileOperation = RemovingAllFilesForDocument
  then begin

    DummyForRemovingAllDocumentFiles := DomainObject as TDocumentFile;

    DocumentIdColumnName :=
      FDBTableMapping.
        ColumnMappingsForModification.
          FindColumnMappingByObjectPropertyName('DocumentId').ColumnName;

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

    QueryParams.Add(
      'p' + DocumentIdColumnName,
      DummyForRemovingAllDocumentFiles.DocumentId
    );

  end

  else inherited;

end;

procedure TDocumentFilesPostgresRepository.RemoveAllFilesForDocument(
  const DocumentId: Variant
);
var DummyForRemovingAllDocumentFiles: TDocumentFile;
begin

  FCurrentSpecificDocumentFileOperation := RemovingAllFilesForDocument;

  DummyForRemovingAllDocumentFiles := TDocumentFile.Create;
  DummyForRemovingAllDocumentFiles.DocumentId := DocumentId;

  Remove(DummyForRemovingAllDocumentFiles);

  DummyForRemovingAllDocumentFiles.Free;

  FCurrentSpecificDocumentFileOperation := None;

  ThrowExceptionIfErrorIsNotUnknown;

end;

procedure TDocumentFilesPostgresRepository.RemoveDocumentFile(
  DocumentFile: TDocumentFile);
begin

  Remove(DocumentFile);

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

procedure TDocumentFilesPostgresRepository.SetIdForDomainObject(
  DomainObject: TDomainObject;
  DataReader: IDataReader
);
var DocumentFiles: TDocumentFiles;
    DocumentFile: TDocumentFile;
begin

  if not (FCurrentSpecificDocumentFileOperation in [AddingDocumentFiles]) then
  begin

    inherited;
    Exit;

  end;

  DocumentFiles := (DomainObject as TDocumentFilesWrapper).DocumentFiles;

  DataReader.Restart;
  
  for DocumentFile in DocumentFiles do begin

    DataReader.Next;
    
    inherited SetIdForDomainObject(DocumentFile, DataReader);
    
  end;

end;

procedure TDocumentFilesPostgresRepository.UpdateDocumentFile(
  DocumentFile: TDocumentFile);
begin

  Update(DocumentFile);

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

{ TFindFilesForDocumentCriterion }

constructor TFindFilesForDocumentCriterion.Create(
  DocumentFilesPostgresRepository: TDocumentFilesPostgresRepository;
  const DocumentId: Variant
);
begin

  inherited Create;

  FDocumentId := DocumentId;
  FDocumentFilesPostgresRepository := DocumentFilesPostgresRepository;
  
end;

function TFindFilesForDocumentCriterion.GetExpression: String;
begin

  Result :=
    Format(
      '%s.%s=%s',
      [
        FDocumentFilesPostgresRepository.FDocumentFilesTableDef.TableName,
        FDocumentFilesPostgresRepository.FDocumentFilesTableDef.DocumentIdColumnName,
        VarToStr(FDocumentId)
      ]
    );
    
end;

{ TDocumentFilesWrapper }

constructor TDocumentFilesWrapper.Create(DocumentFiles: TDocumentFiles);
begin

  inherited Create;

  Self.DocumentFiles := DocumentFiles;
  
end;


end.
