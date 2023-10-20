unit DocumentFilesInfoQueryBuilder;

interface

uses

  DocumentFilesInfoHolder,
  DocumentFilesTableDef,
  SysUtils;

type

  IDocumentFilesInfoQueryBuilder = interface

    function BuildDocumentFilesInfoQuery(
      DocumentFilesInfoFieldNames: TDocumentFilesInfoFieldNames;
      DocumentIdParamName: String
    ): String;

  end;

  TDocumentFilesInfoQueryBuilder =
    class (TInterfacedObject, IDocumentFilesInfoQueryBuilder)

      protected

        FDocumentFilesTableDef: TDocumentFilesTableDef;
        
      public

        constructor Create(DocumentFilesTableDef: TDocumentFilesTableDef);

        function BuildDocumentFilesInfoQuery(
          DocumentFilesInfoFieldNames: TDocumentFilesInfoFieldNames;
          DocumentIdParamName: String
        ): String; virtual; 

    end;

implementation

{ TDocumentFilesInfoQueryBuilder }

function TDocumentFilesInfoQueryBuilder.BuildDocumentFilesInfoQuery(
  DocumentFilesInfoFieldNames: TDocumentFilesInfoFieldNames;
  DocumentIdParamName: String): String;
begin

  with DocumentFilesInfoFieldNames do begin

    Result :=
      'SELECT doc_fm.id as ' + IdFieldName + ',' + #13#10 +
      'doc_fm.file_name as ' + NameFieldName + ',' + #13#10 +
      'doc_fm.file_path as ' + PathFieldName + ',' + #13#10 +
      'doc_fm.document_id as ' + DocumentIdFieldName + #13#10 +
      'FROM ' + FDocumentFilesTableDef.TableName + ' doc_fm' + #13#10 +
      'WHERE doc_fm.document_id = :' + DocumentIdParamName;

  end;

end;

constructor TDocumentFilesInfoQueryBuilder.Create(
  DocumentFilesTableDef: TDocumentFilesTableDef);
begin

  inherited Create;

  FDocumentFilesTableDef := DocumentFilesTableDef;
  
end;

end.
