unit DocumentNumberColumnCellComparator;

interface

uses

  DefaultColumnCellComparator,
  SysUtils,
  Classes,
  Variants;

type

  TDocumentNumberColumnCellComparator = class (TDefaultColumnCellComparator)

    protected

      function CompareDocumentNumbers(
        const FirstDocumentNumber: String;
        const SecondDocumentNumber: String
      ): Integer; virtual;
      
      function InternalCompare(
        const FirstValue, SecondValue: Variant;
        const ColumnName: String
      ): Integer; override;

  end;
  
implementation

uses

  StrUtils;

{ TDocumentNumberColumnCellComparator }

function TDocumentNumberColumnCellComparator.CompareDocumentNumbers(
  const FirstDocumentNumber, SecondDocumentNumber: String
): Integer;
begin

  Result := CompareStr(FirstDocumentNumber, SecondDocumentNumber);

end;

function TDocumentNumberColumnCellComparator.InternalCompare(
  const FirstValue, SecondValue: Variant;
  const ColumnName: String
): Integer;
begin

  if not ContainsStr(ColumnName, 'number') then
    Result := inherited InternalCompare(FirstValue, SecondValue, ColumnName)

  else
    Result := CompareDocumentNumbers(FirstValue, SecondValue);
  
end;

end.
