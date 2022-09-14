unit PostgresDocumentFilesInfoQueryBuilder;

interface

uses

  DocumentFilesInfoQueryBuilder,
  DocumentFilesInfoHolder,
  DocumentFilesTableDef,
  SysUtils;

type

  TPostgresDocumentFilesInfoQueryBuilder =
    class (TDocumentFilesInfoQueryBuilder)

      public

        constructor Create(DocumentFilesTableDef: TDocumentFilesTableDef);

    end;

implementation

{ TPostgresDocumentFilesInfoQueryBuilder }

constructor TPostgresDocumentFilesInfoQueryBuilder.Create(
  DocumentFilesTableDef: TDocumentFilesTableDef);
begin

  inherited Create(DocumentFilesTableDef);

  FDocumentFilesTableDef := DocumentFilesTableDef;
  
end;

end.
