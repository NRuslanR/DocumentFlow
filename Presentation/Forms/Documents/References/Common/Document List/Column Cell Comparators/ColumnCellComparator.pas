unit ColumnCellComparator;

interface

type

  IColumnCellComparator = interface

    function Compare(
      const FirstValue, SecondValue: Variant;
      const ColumnName: String
    ): Integer;

  end;
  
implementation

end.
