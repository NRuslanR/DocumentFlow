unit LookedDocumentsTableDef;

interface

uses

  TableDef,
  SysUtils;

type

  TLookedDocumentsTableDef = class (TTableDef)

    public

      DocumentIdColumnName: String;
      LookedEmployeeIdColumnName: String;
      LookDateColumnName: String;
      
  end;

implementation

end.
