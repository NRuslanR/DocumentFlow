unit DocumentNumeratorTableDef;

interface

uses

  TableDef;
  
const

  DOCUMENT_NUMERATOR_TABLE_NAME = 'doc.document_numerators';
  DOCUMENT_NUMERATOR_TABLE_CURRENT_NUMBER_COLUMN_NAME = 'main_value';

  DOCUMENT_NUMERATOR_TABLE_DEPARTMENT_ID_COLUMN_NAME = 'department_id';
  DOCUMENT_NUMERATOR_TABLE_DOCUMENT_TYPE_ID_COLUMN_NAME = 'document_type_id';

  DOCUMENT_NUMERATOR_TABLE_PREFIX_COLUMN_NAME = 'prefix_value';
  DOCUMENT_NUMERATOR_TABLE_POSTFIX_COLUMN_NAME = 'postfix_value';
  DOCUMENT_NUMERATOR_TABLE_DELIMITER_COLUMN_NAME = 'delimiter';

type

  TDocumentNumeratorTableDef = class (TTableDef)

    public
    
      MainValueColumnName: String;
      DepartmentIdColumnName: String;
      DocumentTypeIdColumnName: String;
      PrefixColumnName: String;
      PostfixColumnName: String;
      DelimiterColumnName: String;
    
  end;

implementation

end.
