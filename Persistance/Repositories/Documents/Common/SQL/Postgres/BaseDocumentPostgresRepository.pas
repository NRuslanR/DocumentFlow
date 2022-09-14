unit BaseDocumentPostgresRepository;

interface

uses

  AbstractPostgresRepository,
  DomainObjectUnit,
  TableColumnMappings,
  DocumentRepository,
  DBTableMapping,
  Document,
  ZConnection,
  AbstractRepositoryCriteriaUnit,
  DocumentKindRepository,
  DocumentKindPostgresRepository,
  SQLAnyMatchingCriterion,
  VariantListUnit,
  SysUtils,
  Classes;

type

  TBaseDocumentPostgresRepository = class;

  TFindDocumentsByIdsCriterion = class (TSQLAnyMatchingCriterion)

    public

      constructor Create(
        Repository: TBaseDocumentPostgresRepository;
        DocumentIds: TVariantList
      );

  end;
  
  TBaseDocumentPostgresRepository =
    class (TAbstractPostgresRepository, IDocumentRepository)

      protected

        procedure CustomizeTableMapping(
          TableMapping: TDBTableMapping
        ); override;

      protected

        procedure GetDocumentTableNameMapping(
          var TableName: string;
          var DocumentClass: TDocumentClass;
          var DocumentsClass: TDocumentsClass
        ); virtual; abstract;

        procedure CustomizeDocumentMappings(
          DocumentMappings: TDBTableMapping
        ); virtual;

        procedure CustomizeDocumentPrimaryKeyMappings(
          DocumentMappings: TDBTableMapping
        ); virtual;

        procedure CustomizeDocumentSelectMappings(
          DocumentMappings: TDBTableMapping
        ); virtual;

        procedure CustomizeDocumentModificationMappings(
          DocumentMappings: TDBTableMapping
        ); virtual;

      protected

        function GetQueryParameterValueFromDomainObject(
          DomainObject: TDomainObject;
          const DomainObjectPropertyName: String
        ): Variant; override;

      protected

        function GetJoinWithDocumentTypesTableString: String; virtual;

        function GetTableNameFromTableMappingForSelect: String; override;

      public

        function GetSelf: TObject;
        
        function LoadAllDocuments: TDocuments; virtual;

        function FindDocumentsByNumber(const Number: String): TDocuments; virtual; abstract;
        function FindDocumentsByNumbers(const Numbers: TStrings): TDocuments; virtual; abstract;

        function FindDocumentsByNumberAndCreationYear(
          const Number: String;
          const CreationYear: Integer
        ): TDocuments; virtual; abstract;

        function FindDocumentsByNumbersAndCreationYear(
          const Numbers: TStrings;
          const CreationYear: Integer
        ): TDocuments; virtual; abstract;

        function FindDocumentById(const DocumentId: Variant): TDocument; virtual;
        function FindDocumentsByIds(const DocumentIds: TVariantList): TDocuments; virtual;

        procedure AddDocument(Document: TDocument); virtual;
        procedure AddDocuments(Documents: TDocuments); virtual;

        procedure UpdateDocument(Document: TDocument); virtual;
        procedure UpdateDocuments(Documents: TDocuments); virtual;
      
        procedure RemoveDocument(Document: TDocument); virtual;
        procedure RemoveDocuments(Documents: TDocuments); virtual;
      
    end;

implementation

uses

  DocumentTableDef,
  DocumentKind,
  IDomainObjectBaseUnit,
  DocumentTypesTableDef,
  PostgresTypeNameConstants,
  Variants,
  AuxiliaryStringFunctions,
  AbstractDBRepository,
  AbstractRepository, TableMapping;

{ TBaseDocumentPostgresRepository }

procedure TBaseDocumentPostgresRepository.AddDocument(Document: TDocument);
begin

  Add(Document);

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

procedure TBaseDocumentPostgresRepository.AddDocuments(
  Documents: TDocuments);
begin

  AddDomainObjectList(Documents);

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

procedure TBaseDocumentPostgresRepository.CustomizeDocumentMappings(
  DocumentMappings: TDBTableMapping);
var TableName: String;
    DocumentClass: TDocumentClass;
    DocumentsClass: TDocumentsClass;
begin

  GetDocumentTableNameMapping(TableName, DocumentClass, DocumentsClass);

  DocumentMappings.SetTableNameMapping(
    TableName, DocumentClass, DocumentsClass
  );

  CustomizeDocumentSelectMappings(DocumentMappings);
  CustomizeDocumentModificationMappings(DocumentMappings);
  CustomizeDocumentPrimaryKeyMappings(DocumentMappings);
  
end;

procedure TBaseDocumentPostgresRepository.
  CustomizeDocumentModificationMappings(
    DocumentMappings: TDBTableMapping
  );
begin

  DocumentMappings.AddColumnMappingForModification(
    DOCUMENT_TABLE_TYPE_ID_FIELD,
    'KindIdentity',
    PostgresTypeNameConstants.INTEGER_TYPE_NAME
  );

end;

procedure TBaseDocumentPostgresRepository.
  CustomizeDocumentPrimaryKeyMappings(
    DocumentMappings: TDBTableMapping
  );
begin

  DocumentMappings.AddPrimaryKeyColumnMapping(
    DOCUMENT_TABLE_ID_FIELD, 'Identity'
  );
  
end;

procedure TBaseDocumentPostgresRepository.
  CustomizeDocumentSelectMappings(
    DocumentMappings: TDBTableMapping
  );
begin

  DocumentMappings.AddColumnMappingForSelect(
    DOCUMENT_TABLE_ID_FIELD, 'Identity'
  );

  DocumentMappings.AddColumnMappingForSelect(
    DOCUMENT_TABLE_TYPE_ID_FIELD, 'KindIdentity'
  );
  
end;

procedure TBaseDocumentPostgresRepository.CustomizeTableMapping(
  TableMapping: TDBTableMapping);
begin

  CustomizeDocumentMappings(TableMapping);

end;

function TBaseDocumentPostgresRepository.FindDocumentById(
  const DocumentId: Variant): TDocument;
begin

  Result := TDocument(FindDomainObjectByIdentity(DocumentId));

  ThrowExceptionIfErrorIsNotUnknown;

end;

function TBaseDocumentPostgresRepository.FindDocumentsByIds(
  const DocumentIds: TVariantList
): TDocuments;
var
    FindDocumentsByIdsCriterion: TFindDocumentsByIdsCriterion;
begin

  FindDocumentsByIdsCriterion := TFindDocumentsByIdsCriterion.Create(Self, DocumentIds);

  try

    Result := TDocuments(FindDomainObjectsByCriteria(FindDocumentsByIdsCriterion));
    
  finally

    FreeAndNil(FindDocumentsByIdsCriterion);

  end;

  ThrowExceptionIfErrorIsNotUnknown;

end;
function TBaseDocumentPostgresRepository.GetJoinWithDocumentTypesTableString: String;
var
    DocumentTypeIdColumnMapping: TTableColumnMapping;
begin

  DocumentTypeIdColumnMapping :=
    FDBTableMapping
      .ColumnMappingsForModification
        .FindColumnMappingByObjectPropertyName(
          'KindIdentity'
        );
        
  Result :=
    Format(
      'JOIN %s ON %s.%s = %s.%s',
      [
        DOCUMENT_TYPES_TABLE_NAME,
        DOCUMENT_TYPES_TABLE_NAME,
        DOCUMENT_TYPES_TABLE_ID_FIELD,
        FDBTableMapping.TableName,
        DocumentTypeIdColumnMapping.ColumnName
      ]
    );

end;

function TBaseDocumentPostgresRepository.
  GetTableNameFromTableMappingForSelect: String;
begin

  Result := inherited
            GetTableNameFromTableMappingForSelect + ' ' +
            GetJoinWithDocumentTypesTableString;
            
end;

function TBaseDocumentPostgresRepository.
  GetQueryParameterValueFromDomainObject(
    DomainObject: TDomainObject;
    const DomainObjectPropertyName: String
  ): Variant;
var Document: TDocument;
begin

  Document := DomainObject as TDocument;

  if DomainObjectPropertyName = 'Author' then begin

    Result := Document.Author.Identity;

  end

  else begin

    Result :=
      inherited GetQueryParameterValueFromDomainObject(
        DomainObject, DomainObjectPropertyName
      );

  end;

end;

function TBaseDocumentPostgresRepository.GetSelf: TObject;
begin

  Result := Self;
  
end;

function TBaseDocumentPostgresRepository.LoadAllDocuments: TDocuments;
begin

  Result := TDocuments(LoadAll);

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

procedure TBaseDocumentPostgresRepository.RemoveDocument(
  Document: TDocument);
begin

  Remove(Document);

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

procedure TBaseDocumentPostgresRepository.RemoveDocuments(
  Documents: TDocuments);
begin

  RemoveDomainObjectList(Documents);

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

procedure TBaseDocumentPostgresRepository.UpdateDocument(
  Document: TDocument);
begin

  Update(Document);

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

procedure TBaseDocumentPostgresRepository.UpdateDocuments(
  Documents: TDocuments);
begin

  UpdateDomainObjectList(Documents);

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

{ TFindDocumentsByIdsCriterion }

constructor TFindDocumentsByIdsCriterion.Create(
  Repository: TBaseDocumentPostgresRepository;
  DocumentIds: TVariantList
);
var
    DocumentIdColumnName: String;
begin

  DocumentIdColumnName :=
    Format(
      '%s.%s',
      [
        Repository.TableMapping.TableName
        ,
        Repository
          .TableMapping
            .FindSelectColumnMappingByObjectPropertyName('Identity')
              .ColumnName
      ]
    );

  inherited Create(DocumentIdColumnName, DocumentIds);

end;

end.
