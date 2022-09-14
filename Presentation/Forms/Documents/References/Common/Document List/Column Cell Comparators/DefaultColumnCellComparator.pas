unit DefaultColumnCellComparator;

interface

uses

  ColumnCellComparator,
  SysUtils,
  Classes,
  Variants;

type

  TDefaultColumnCellComparator =
    class (TInterfacedObject, IColumnCellComparator)

      protected

        function InternalCompare(
          const FirstValue, SecondValue: Variant;
          const ColumnName: String
        ): Integer; virtual;
        
      public

        function Compare(
          const FirstValue, SecondValue: Variant;
          const ColumnName: String
        ): Integer;

    end;

    TDefaultColumnCellComparatorClass = class of TDefaultColumnCellComparator;

implementation

{ TDefaultColumnCellComparator }

function TDefaultColumnCellComparator.Compare(
  const FirstValue, SecondValue: Variant;
  const ColumnName: String
): Integer;
begin

  Result := InternalCompare(FirstValue, SecondValue, ColumnName);
  

end;

function TDefaultColumnCellComparator.InternalCompare(const FirstValue,
  SecondValue: Variant; const ColumnName: String): Integer;
begin

  if FirstValue < SecondValue then
    Result := -1

  else if FirstValue = SecondValue then
    Result := 0

  else Result := 1;
  
end;

end.
