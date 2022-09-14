unit DocumentFilesTableDef;

interface

uses

  TableDef;

const

  DOCUMENT_FILES_TABLE_NAME = 'doc.document_file_metadata';

  DOCUMENT_FILES_TABLE_ID_FIELD = 'id';
  DOCUMENT_FILES_TABLE_DOCUMENT_ID_FIELD = 'document_id';
  DOCUMENT_FILES_TABLE_FILE_NAME_FIELD = 'file_name';
  DOCUMENT_FILES_TABLE_FILE_PATH_FIELD = 'file_path';

type

  TDocumentFilesTableDef = class (TTableDef)

    public

      DocumentIdColumnName: String;
      FileNameColumnName: String;
      FilePathColumnName: String;
    
  end;
  
implementation

end.
