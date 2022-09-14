unit DocumentChargeKindTableDef;

interface

uses

  TableDef,
  SysUtils;

type

  TDocumentChargeKindTableDef = class (TTableDef)

    public

      NameColumnName: String;
      ServiceNameColumnName: String;
      
  end;

implementation

end.
